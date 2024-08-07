use clap::{Arg, Command};
use rayon::prelude::*;
use std::fs;
use std::io::{self, Read, Write};
use std::path::{Path};
use std::sync::{Arc, Mutex};
use std::time::Instant;
use log::{info as log_info, warn};
use env_logger;
use clipboard::{ClipboardContext, ClipboardProvider};
use mime_guess::from_path;
use regex::Regex;
use indicatif::ProgressBar;
use slog::{Drain, Logger, o, info as slog_info};
use slog_async;
use slog_term;

#[derive(Debug)]
struct Config {
    directory: String,
    exclude_non_utf: bool,
    extensions: Option<Vec<String>>,
    mime_types: Option<Vec<String>>,
    recursive: bool,
    limit: Option<usize>,
    exclude_dirs: Option<Vec<String>>,
    output: Option<String>,
    output_format: Option<String>,
    separator: Option<String>,
    verbose: bool,
    quiet: bool,
    line_numbers: bool,
    include_hidden: bool,
    ignore_files: Option<Vec<String>>,
    include_dates: Option<(String, String)>,
    exclude_dates: Option<(String, String)>,
    include_content: Option<Regex>,
    exclude_content: Option<Regex>,
    copy_to_clipboard: bool,
    num_threads: Option<usize>,
    error_log: Option<String>,
}

impl Config {
    fn from_matches(matches: clap::ArgMatches) -> Self {
        Config {
            directory: matches.get_one::<String>("directory").unwrap().to_string(),
            exclude_non_utf: matches.get_flag("exclude_non_utf"),
            extensions: matches.get_one::<String>("extensions").map(|ext| ext.split(',').map(String::from).collect()),
            mime_types: matches.get_one::<String>("mime_types").map(|mt| mt.split(',').map(String::from).collect()),
            recursive: matches.get_flag("recursive"),
            limit: matches.get_one::<usize>("limit").copied(),
            exclude_dirs: matches.get_one::<String>("exclude_dirs").map(|d| d.split(',').map(String::from).collect()),
            output: matches.get_one::<String>("output").map(String::from),
            output_format: matches.get_one::<String>("output_format").map(String::from),
            separator: matches.get_one::<String>("separator").map(String::from),
            verbose: matches.get_flag("verbose"),
            quiet: matches.get_flag("quiet"),
            line_numbers: matches.get_flag("line_numbers"),
            include_hidden: matches.get_flag("include_hidden"),
            ignore_files: matches.get_one::<String>("ignore_files").map(|f| f.split(',').map(String::from).collect()),
            include_dates: matches.get_one::<String>("include_dates").map(|d| {
                let dates: Vec<&str> = d.split(',').collect();
                (dates[0].to_string(), dates[1].to_string())
            }),
            exclude_dates: matches.get_one::<String>("exclude_dates").map(|d| {
                let dates: Vec<&str> = d.split(',').collect();
                (dates[0].to_string(), dates[1].to_string())
            }),
            include_content: matches.get_one::<String>("include_content").map(|p| Regex::new(p).unwrap()),
            exclude_content: matches.get_one::<String>("exclude_content").map(|p| Regex::new(p).unwrap()),
            copy_to_clipboard: matches.get_flag("copy_to_clipboard"),
            num_threads: matches.get_one::<usize>("num_threads").copied(),
            error_log: matches.get_one::<String>("error_log").map(String::from),
        }
    }
}

fn main() -> io::Result<()> {
    env_logger::init();

    let matches = Command::new("dircat")
        .version("1.4")
        .author("Aidan Littman <aidanlittman@gmail.com>")
        .about("Directory file content concatenator")
        .arg(Arg::new("directory").help("The directory to scan").default_value(".").index(1))
        .arg(Arg::new("exclude_non_utf").help("Exclude non-UTF-8 files from output").short('e').long("exclude-non-utf").action(clap::ArgAction::SetTrue))
        .arg(Arg::new("extensions").help("Comma-separated list of file extensions to include").short('x').long("extensions").value_parser(clap::value_parser!(String)))
        .arg(Arg::new("mime_types").help("Comma-separated list of MIME types to include").short('m').long("mime-types").value_parser(clap::value_parser!(String)))
        .arg(Arg::new("recursive").help("Recursively scan directories").short('r').long("recursive").action(clap::ArgAction::SetTrue))
        .arg(Arg::new("limit").help("Limit the number of files to display").short('l').long("limit").value_parser(clap::value_parser!(usize)))
        .arg(Arg::new("exclude_dirs").help("Comma-separated list of directories to exclude").short('d').long("exclude-dirs").value_parser(clap::value_parser!(String)))
        .arg(Arg::new("output").help("Output the concatenated result to a file").short('o').long("output").value_parser(clap::value_parser!(String)))
        .arg(Arg::new("output_format").help("Output format (e.g., JSON, CSV)").short('f').long("output-format").value_parser(clap::value_parser!(String)))
        .arg(Arg::new("separator").help("Separator used between file contents in the output").short('s').long("separator").value_parser(clap::value_parser!(String)))
        .arg(Arg::new("verbose").help("Enable verbose mode").short('v').long("verbose").action(clap::ArgAction::SetTrue))
        .arg(Arg::new("quiet").help("Enable quiet mode").short('q').long("quiet").action(clap::ArgAction::SetTrue))
        .arg(Arg::new("line_numbers").help("Include line numbers in the output").short('n').long("line-numbers").action(clap::ArgAction::SetTrue))
        .arg(Arg::new("include_hidden").help("Include hidden files in the listing and concatenation").short('i').long("include-hidden").action(clap::ArgAction::SetTrue))
        .arg(Arg::new("ignore_files").help("Comma-separated list of patterns or filenames to ignore").short('g').long("ignore-files").value_parser(clap::value_parser!(String)))
        .arg(Arg::new("include_dates").help("Date range to include files (format: start,end)").short('a').long("include-dates").value_parser(clap::value_parser!(String)))
        .arg(Arg::new("exclude_dates").help("Date range to exclude files (format: start,end)").short('b').long("exclude-dates").value_parser(clap::value_parser!(String)))
        .arg(Arg::new("include_content").help("Regex pattern to include files based on content").short('p').long("include-content").value_parser(clap::value_parser!(String)))
        .arg(Arg::new("exclude_content").help("Regex pattern to exclude files based on content").short('y').long("exclude-content").value_parser(clap::value_parser!(String)))
        .arg(Arg::new("copy_to_clipboard").help("Copy the directory to the clipboard").short('c').long("copy-to-clipboard").action(clap::ArgAction::SetTrue))
        .arg(Arg::new("num_threads").help("Number of threads to use for scanning").short('t').long("num-threads").value_parser(clap::value_parser!(usize)))
        .arg(Arg::new("error_log").help("File to log errors").short('z').long("error-log").value_parser(clap::value_parser!(String)))
        .get_matches();

    let config = Config::from_matches(matches);

    if config.verbose {
        log_info!("Configuration: {:?}", config);
    }

    if config.copy_to_clipboard {
        let mut ctx: ClipboardContext = match ClipboardProvider::new() {
            Ok(ctx) => ctx,
            Err(e) => {
                eprintln!("Error: Failed to initialize clipboard context: {}", e);
                return Err(io::Error::new(io::ErrorKind::Other, "Failed to initialize clipboard context"));
            }
        };
        if let Err(e) = ctx.set_contents(config.directory.clone()) {
            eprintln!("Error: Failed to set clipboard contents: {}", e);
            return Err(io::Error::new(io::ErrorKind::Other, "Failed to set clipboard contents"));
        }
        return Ok(());
    }

    let current_dir = match Path::new(&config.directory).canonicalize() {
        Ok(dir) => dir,
        Err(e) => {
            eprintln!("Error: Failed to canonicalize directory '{}': {}", config.directory, e);
            return Err(e);
        }
    };

    let files = Arc::new(Mutex::new(Vec::new()));
    let file_counter = Arc::new(Mutex::new(1));

    let start = Instant::now();
    let pb = ProgressBar::new(100); // Initialize progress bar with a dummy value

    if let Err(e) = read_files(
        &current_dir,
        Arc::clone(&files),
        Arc::clone(&file_counter),
        &config.extensions,
        &config.mime_types,
        config.recursive,
        &config.exclude_dirs,
        &current_dir,
        config.include_hidden,
        &config.ignore_files,
        &config.include_dates,
        &config.exclude_dates,
        &config.include_content,
        &config.exclude_content,
        config.verbose,
        &pb
    ) {
        eprintln!("Error: Failed to read files: {}", e);
        return Err(e);
    }

    pb.finish_with_message("Scanning complete");

    let mut files = match Arc::try_unwrap(files) {
        Ok(mutex) => mutex.into_inner().unwrap(),
        Err(_) => {
            eprintln!("Error: Failed to unwrap Arc for files");
            return Err(io::Error::new(io::ErrorKind::Other, "Failed to unwrap Arc for files"));
        }
    };

    if let Some(limit) = config.limit {
        files.truncate(limit);
    }

    let total_files = files.len();
    let output_file: Option<Arc<Mutex<fs::File>>> = if let Some(output) = &config.output {
        match fs::File::create(output) {
            Ok(file) => Some(Arc::new(Mutex::new(file))),
            Err(e) => {
                eprintln!("Error: Failed to create output file '{}': {}", output, e);
                return Err(e);
            }
        }
    } else {
        None
    };

    if let Some(num_threads) = config.num_threads {
        rayon::ThreadPoolBuilder::new().num_threads(num_threads).build_global().unwrap();
    }

    if let Some(error_log) = &config.error_log {
        let file = fs::File::create(error_log)?;
        let decorator = slog_term::PlainDecorator::new(file);
        let drain = slog_term::FullFormat::new(decorator).build().fuse();
        let drain = slog_async::Async::new(drain).build().fuse();
        let log = Logger::root(drain, o!());
        slog_stdlog::init().unwrap();
        slog_info!(log, "Logging to file: {}", error_log);
    }

    let separator = config.separator.unwrap_or_else(|| "\n".to_string());
    let output_format = config.output_format.unwrap_or_else(|| "plain".to_string());

    if config.verbose {
        log_info!("Output format: {}", output_format);
    }

    files.par_iter().enumerate().for_each(|(i, (file_path, content))| {
        let mut output = String::new();
        output.push_str(&format!("\n{:^80}", "-".repeat(80)));
        output.push_str(&format!("\n {} {{{}/{}}} ", file_path, i + 1, total_files));
        output.push_str(&format!("\n{:^80}\n", "-".repeat(80)));

        if let Ok(content_str) = String::from_utf8(content.clone()) {
            if config.line_numbers {
                for (line_num, line) in content_str.lines().enumerate() {
                    output.push_str(&format!("{:>6}  {}\n", line_num + 1, line));
                }
            } else {
                output.push_str(&content_str);
            }
        } else {
            if !config.exclude_non_utf {
                output.push_str("File contains non-UTF-8 data.\n");
            }
        }

        output.push_str(&separator);

        if let Some(ref file) = output_file {
            let mut file = file.lock().unwrap();
            if let Err(e) = file.write_all(output.as_bytes()) {
                eprintln!("Error: Failed to write to output file: {}", e);
            }
        } else {
            if !config.quiet {
                println!("{}", output);
            }
        }
    });

    if config.verbose {
        log_info!("Processed {} files in {:?}", total_files, start.elapsed());
    }

    Ok(())
}

fn read_files<P: AsRef<Path>>(
    path: P,
    files: Arc<Mutex<Vec<(String, Vec<u8>)>>>,
    file_counter: Arc<Mutex<usize>>,
    extensions: &Option<Vec<String>>,
    mime_types: &Option<Vec<String>>,
    recursive: bool,
    exclude_dirs: &Option<Vec<String>>,
    base_dir: &Path,
    include_hidden: bool,
    ignore_files: &Option<Vec<String>>,
    include_dates: &Option<(String, String)>,
    exclude_dates: &Option<(String, String)>,
    include_content: &Option<Regex>,
    exclude_content: &Option<Regex>,
    verbose: bool,
    pb: &ProgressBar,
) -> io::Result<()> {
    let path = path.as_ref();
    if path.is_dir() {
        for entry in fs::read_dir(path)? {
            let entry = entry?;
            let entry_path = entry.path();
            if entry_path.is_dir() {
                if recursive {
                    if let Some(ex_dirs) = exclude_dirs {
                        if ex_dirs.contains(&entry_path.to_str().unwrap().to_string()) {
                            continue;
                        }
                    }
                    read_files(entry_path, Arc::clone(&files), Arc::clone(&file_counter), extensions, mime_types, recursive, exclude_dirs, base_dir, include_hidden, ignore_files, include_dates, exclude_dates, include_content, exclude_content, verbose, pb)?;
                }
            } else if entry_path.is_file() {
                if let Some(exts) = extensions {
                    if let Some(ext) = entry_path.extension() {
                        if !exts.contains(&ext.to_str().unwrap().to_string()) {
                            continue;
                        }
                    }
                }
                if let Some(mime_types) = mime_types {
                    let mime_type = from_path(&entry_path).first_or_octet_stream().to_string();
                    if !mime_types.contains(&mime_type) {
                        continue;
                    }
                }
                if let Some(ign_files) = ignore_files {
                    if ign_files.contains(&entry_path.file_name().unwrap().to_str().unwrap().to_string()) {
                        continue;
                    }
                }
                if !include_hidden && entry_path.file_name().unwrap().to_str().unwrap().starts_with('.') {
                    continue;
                }
                let relative_path = entry_path.strip_prefix(base_dir).unwrap().to_string_lossy().to_string();
                let mut file_content = Vec::new();
                if let Err(e) = fs::File::open(&entry_path)?.read_to_end(&mut file_content) {
                    if verbose {
                        warn!("Failed to read file {}: {}", entry_path.display(), e);
                    }
                    continue;
                }
                if let Some(include_content) = include_content {
                    if !include_content.is_match(&String::from_utf8_lossy(&file_content)) {
                        continue;
                    }
                }
                if let Some(exclude_content) = exclude_content {
                    if exclude_content.is_match(&String::from_utf8_lossy(&file_content)) {
                        continue;
                    }
                }
                files.lock().unwrap().push((relative_path, file_content));
                *file_counter.lock().unwrap() += 1;
                pb.inc(1); // Update progress bar
            }
        }
    }
    Ok(())
}
