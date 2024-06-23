use bat::PrettyPrinter;
use clap::{Arg, Command};
use std::fs;
use std::io::{self, Read};
use std::path::Path;

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

    let current_dir = Path::new(dir).canonicalize()?;
    let mut files = Vec::new();
    let mut file_counter = 1;

    fn read_files<P: AsRef<Path>>(
        path: P,
        files: &mut Vec<(String, Vec<u8>)>,
        file_counter: &mut usize,
        extensions: &Option<Vec<&str>>,
        recursive: bool,
        exclude_dirs: &Option<Vec<&str>>,
        base_dir: &Path,
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
                        read_files(entry_path, files, file_counter, extensions, recursive, exclude_dirs, base_dir)?;
                    }
                } else if entry_path.is_file() {
                    if let Some(exts) = extensions {
                        if let Some(ext) = entry_path.extension() {
                            if !exts.contains(&ext.to_str().unwrap()) {
                                continue;
                            }
                        }
                    }
                    let relative_path = entry_path.strip_prefix(base_dir).unwrap().to_string_lossy().to_string();
                    let mut file_content = Vec::new();
                    fs::File::open(&entry_path)?.read_to_end(&mut file_content)?;
                    files.push((relative_path, file_content));
                    *file_counter += 1;
                }
            }
        }
        Ok(())
    }

    read_files(&current_dir, &mut files, &mut file_counter, &extensions, recursive, &exclude_dirs, &current_dir)?;

    if let Some(limit) = limit {
        files.truncate(limit);
    }

    let total_files = files.len();
    for (i, (file_path, content)) in files.into_iter().enumerate() {
        println!("\n{:^80}", "-".repeat(80));
        println!(" {} {{{}/{}}} ", file_path, i + 1, total_files);
        println!("{:^80}\n", "-".repeat(80));

        if let Ok(_) = String::from_utf8(content.clone()) {
            // Use bat for syntax highlighting
            PrettyPrinter::new()
                .input_from_bytes(&content)
                .print()
                .unwrap();
        } else {
            if !exclude_non_utf {
                println!("File contains non-UTF-8 data.");
            }
        }
    }

    Ok(())
}
