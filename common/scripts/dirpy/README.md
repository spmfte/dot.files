# dircat - Directory Content Viewer and JSON Generator

A powerful command-line tool for viewing and analyzing directory contents with rich formatting, syntax highlighting, and JSON export capabilities.

## Features

- 📁 Interactive directory tree visualization
- 🎨 Syntax-highlighted file content display
- 🔍 Recursive directory scanning
- 📊 File size and encoding information
- 🔧 Configurable file extension filtering
- 🚫 Directory exclusion support
- 📝 UTF-8 and binary content handling
- 📤 JSON export functionality
- 💅 Rich terminal formatting and styling

## Implementation Details

### Core Components

- **File Tree Visualization**: Uses Rich's Tree component to create an interactive directory structure with file sizes and types
- **Content Detection**: Implements smart binary/text content detection using UTF-8 and chardet
- **Syntax Highlighting**: Automatically detects file types and applies appropriate syntax highlighting
- **Progress Tracking**: Shows real-time progress during file scanning with Rich's Progress bars
- **JSON Generation**: Creates detailed JSON representation of directory structure with metadata

### Key Functions

- `create_file_tree()`: Builds visual directory tree with size information and icons
- `read_files()`: Recursively reads files with progress tracking and error handling
- `create_file_dict()`: Generates JSON-compatible dictionary of directory structure
- `main()`: Handles CLI argument parsing and orchestrates program flow

### Technical Details

- **File Handling**
  - Smart content detection for UTF-8 and other encodings
  - Binary file hex dump preview
  - Size-based content processing limits (1MB threshold)
  - Graceful error handling for inaccessible files

- **Performance Optimizations**
  - Lazy loading of file contents
  - Progress tracking for large directories
  - Efficient recursive traversal
  - Memory-conscious file reading

- **Formatting Features**
  - Custom styling for different file types
  - Emoji indicators for files/folders
  - Word wrapping and line numbering
  - Configurable code width for readability

### CLI Arguments
- `directory`: The directory to scan (default: current directory)
- `-e, --exclude-non-utf`: Exclude non-UTF-8 files from output
- `-x, --extensions`: Comma-separated list of file extensions to include
- `-r, --recursive`: Recursively scan directories
- `-l, --limit`: Limit the number of files to display
- `-d, --exclude-dirs`: Comma-separated list of directories to exclude
- `--json`: Output directory structure as JSON
- `--json-file`: Save JSON output to specified file
- `--pretty-json`: Display formatted JSON with syntax highlighting

