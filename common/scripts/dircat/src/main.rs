use clap::{Arg, Command};
use rayon::prelude::*;
use std::fs;
use std::io::{self, Read, Write};
use std::path::Path;
use std::sync::{Arc, Mutex};
use std::time::Instant;

fn main() -> io::Result<()> {
    let matches = Command::new("dircat")
        .version("1.0")
        .author("Aidan Littman <aidanlittman@gmail.com>")
        .about("Directory file content concatenator")
        .arg(
            Arg::new("directory")
                .help("The directory to scan")
                .default_value(".")
                .index(1),
        )
        .arg(
            Arg::new("exclude_non_utf")
                .help("Exclude non-UTF-8 files from output")
                .short('e')
                .long("exclude-non-utf")
                .action(clap::ArgAction::SetTrue),
        )
        .arg(
            Arg::new("extensions")
                .help("Comma-separated list of file extensions to include")
                .short('x')
                .long("extensions")
                .value_parser(clap::value_parser!(String)),
        )
        .arg(
            Arg::new("recursive")
                .help("Recursively scan directories")
                .short('r')
                .long("recursive")
                .action(clap::ArgAction::SetTrue),
        )
        .arg(
            Arg::new("limit")
                .help("Limit the number of files to display")
                .short('l')
                .long("limit")
                .value_parser(clap::value_parser!(usize)),
        )
        .arg(
            Arg::new("exclude_dirs")
                .help("Comma-separated list of directories to exclude")
                .short('d')
                .long("exclude-dirs")
                .value_parser(clap::value_parser!(String)),
        )
        .arg(
            Arg::new("output")
                .help("Output the concatenated result to a file")
                .short('o')
                .long("output")
                .value_parser(clap::value_parser!(String)),
        )
        .arg(
            Arg::new("verbose")
                .help("Enable verbose mode")
                .short('v')
                .long("verbose")
                .action(clap::ArgAction::SetTrue),
        )
        .arg(
            Arg::new("quiet")
                .help("Enable quiet mode")
                .short('q')
                .long("quiet")
                .action(clap::ArgAction::SetTrue),
        )
        .arg(
            Arg::new("line_numbers")
                .help("Include line numbers in the output")
                .short('n')
                .long("line-numbers")
                .action(clap::ArgAction::SetTrue),
        )
        .arg(
            Arg::new("include_hidden")
                .help("Include hidden files in the listing and concatenation")
                .short('i')
                .long("include-hidden")
                .action(clap::ArgAction::SetTrue),
        )
        .arg(
            Arg::new("ignore_files")
                .help("Comma-separated list of patterns or filenames to ignore")
                .short('g')
                .long("ignore-files")
                .value_parser(clap::value_parser!(String)),
        )
        .arg(
            Arg::new("delimiter")
                .help("Specify delimiters between concatenated files")
                .short('m')
                .long("delimiter")
                .value_parser(clap::value_parser!(String)),
        )
        .get_matches();

    let dir = matches.get_one::<String>("directory").unwrap();
    let exclude_non_utf = matches.get_flag("exclude_non_utf");
    let extensions: Option<Vec<&str>> = matches
        .get_one::<String>("extensions")
        .map(|ext| ext.split(',').collect());
    let recursive = matches.get_flag("recursive");
    let limit: Option<usize> = matches
        .get_one::<usize>("limit")
        .copied();
    let exclude_dirs: Option<Vec<&str>> = matches
        .get_one::<String>("exclude_dirs")
        .map(|d| d.split(',').collect());
    let output = matches.get_one::<String>("output");
    let verbose = matches.get_flag("verbose");
    let quiet = matches.get_flag("quiet");
    let line_numbers = matches.get_flag("line_numbers");
    let include_hidden = matches.get_flag("include_hidden");
    let ignore_files: Option<Vec<&str>> = matches
        .get_one::<String>("ignore_files")
        .map(|f| f.split(',').collect());
    let _delimiter = matches.get_one::<String>("delimiter").unwrap_or(&String::from("---"));

    let current_dir = Path::new(dir).canonicalize()?;
    let files = Arc::new(Mutex::new(Vec::new()));
    let file_counter = Arc::new(Mutex::new(1));

    fn read_files<P: AsRef<Path>>(
        path: P,
        files: Arc<Mutex<Vec<(String, Vec<u8>)>>>,
        file_counter: Arc<Mutex<usize>>,
        extensions: &Option<Vec<&str>>,
        recursive: bool,
        exclude_dirs: &Option<Vec<&str>>,
        base_dir: &Path,
        include_hidden: bool,
        ignore_files: &Option<Vec<&str>>,
        verbose: bool,
    ) -> io::Result<()> {
        let path = path.as_ref();
        if path.is_dir() {
            for entry in fs::read_dir(path)? {
                let entry = entry?;
                let entry_path = entry.path();
                if entry_path.is_dir() {
                    if recursive {
                        if let Some(ex_dirs) = exclude_dirs {
                            if ex_dirs.contains(&entry_path.to_str().unwrap()) {
                                continue;
                            }
                        }
                        read_files(entry_path, Arc::clone(&files), Arc::clone(&file_counter), extensions, recursive, exclude_dirs, base_dir, include_hidden, ignore_files, verbose)?;
                    }
                } else if entry_path.is_file() {
                    if let Some(exts) = extensions {
                        if let Some(ext) = entry_path.extension() {
                            if !exts.contains(&ext.to_str().unwrap()) {
                                continue;
                            }
                        }
                    }
                    if let Some(ign_files) = ignore_files {
                        if ign_files.contains(&entry_path.file_name().unwrap().to_str().unwrap()) {
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
                            eprintln!("Failed to read file {}: {}", entry_path.display(), e);
                        }
                        continue;
                    }
                    files.lock().unwrap().push((relative_path, file_content));
                    *file_counter.lock().unwrap() += 1;
                }
            }
        }
        Ok(())
    }

    let start = Instant::now();
    read_files(&current_dir, Arc::clone(&files), Arc::clone(&file_counter), &extensions, recursive, &exclude_dirs, &current_dir, include_hidden, &ignore_files, verbose)?;

    let mut files = Arc::try_unwrap(files).unwrap().into_inner().unwrap();
    if let Some(limit) = limit {
        files.truncate(limit);
    }

    let total_files = files.len();
    let output_file: Option<Arc<Mutex<fs::File>>> = if let Some(output) = output {
        Some(Arc::new(Mutex::new(fs::File::create(output)?)))
    } else {
        None
    };

    files.par_iter().enumerate().for_each(|(i, (file_path, content))| {
        let mut output = String::new();
        output.push_str(&format!("\n{:^80}", "-".repeat(80)));
        output.push_str(&format!("\n {} {{{}/{}}} ", file_path, i + 1, total_files));
        output.push_str(&format!("\n{:^80}\n", "-".repeat(80)));

        if let Ok(content_str) = String::from_utf8(content.clone()) {
            if line_numbers {
                for (line_num, line) in content_str.lines().enumerate() {
                    output.push_str(&format!("{:>6}  {}\n", line_num + 1, line));
                }
            } else {
                output.push_str(&content_str);
            }
        } else {
            if !exclude_non_utf {
                output.push_str("File contains non-UTF-8 data.\n");
            }
        }

        if let Some(ref file) = output_file {
            let mut file = file.lock().unwrap();
            file.write_all(output.as_bytes()).unwrap();
        } else {
            if !quiet {
                println!("{}", output);
            }
        }
    });

    if verbose {
        eprintln!("Processed {} files in {:?}", total_files, start.elapsed());
    }

    Ok(())
}

