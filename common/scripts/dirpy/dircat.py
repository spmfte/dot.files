#!/usr/bin/env python3

import os
import argparse
from pathlib import Path
from typing import List, Tuple
from rich.console import Console
from rich.syntax import Syntax
from rich.panel import Panel
from rich.progress import Progress, SpinnerColumn, TextColumn, BarColumn, TaskID
from rich.live import Live
from rich.layout import Layout
from rich.tree import Tree
from rich.style import Style
from rich.text import Text
import chardet
import json
from datetime import datetime
from rich.json import JSON

console = Console()

def create_file_tree(path: Path, extensions: List[str] = None, exclude_dirs: List[str] = None) -> Tree:
    """Create a tree visualization of the directory structure"""
    tree = Tree(
        Text(f"📁 {path.name}", style="bold blue"),
        guide_style="bold bright_black"
    )
    
    def add_to_tree(tree: Tree, path: Path):
        for entry in sorted(path.iterdir()):
            if entry.is_dir():
                if exclude_dirs and entry.name in exclude_dirs:
                    continue
                # Create directory node with folder emoji
                branch = tree.add(Text(f"📁 {entry.name}", style="bold cyan"))
                add_to_tree(branch, entry)
            else:
                if extensions and entry.suffix not in extensions:
                    continue
                # Create file node with file emoji and size
                size = entry.stat().st_size
                size_str = f"{size/1024:.1f}KB" if size > 1024 else f"{size}B"
                file_text = Text(f"📄 {entry.name}", style="green")
                file_text.append(f" ({size_str})", style="italic bright_black")
                tree.add(file_text)
    
    add_to_tree(tree, path)
    return tree

def read_files(
    path: Path,
    progress: Progress,
    task_id: TaskID,
    extensions: List[str],
    recursive: bool,
    exclude_dirs: List[str],
    base_dir: Path
) -> List[Tuple[Path, bytes]]:
    """Read files with progress tracking"""
    total_files = sum(1 for _ in path.rglob('*') if _.is_file()) if recursive else sum(1 for _ in path.glob('*') if _.is_file())
    progress.update(task_id, total=total_files)
    
    files = []
    if path.is_dir():
        for entry in path.iterdir():
            if entry.is_dir() and recursive:
                if exclude_dirs and entry.name in exclude_dirs:
                    continue
                files.extend(
                    read_files(entry, progress, task_id, extensions, recursive, exclude_dirs, base_dir)
                )
            elif entry.is_file():
                if extensions and entry.suffix not in extensions:
                    continue
                relative_path = entry.relative_to(base_dir)
                progress.update(task_id, description=f"Reading [cyan]{relative_path}[/cyan]")
                try:
                    with open(entry, "rb") as file:
                        file_content = file.read()
                    files.append((relative_path, file_content))
                    progress.advance(task_id)
                except Exception as e:
                    console.print(f"[red]Error reading {relative_path}: {str(e)}[/red]")
    return files

def create_file_dict(path: Path, extensions: List[str] = None, exclude_dirs: List[str] = None, max_content_size: int = 1024 * 100) -> dict:
    """Create a clean, structured dictionary representation of the directory"""
    result = {
        "name": path.name,
        "type": "directory",
        "path": str(path.absolute()),
        "last_modified": datetime.fromtimestamp(path.stat().st_mtime).isoformat(),
        "children": []
    }
    
    try:
        for entry in sorted(path.iterdir()):
            # Skip excluded directories
            if entry.is_dir() and exclude_dirs and entry.name in exclude_dirs:
                continue
                
            # Base info for both files and directories
            entry_info = {
                "name": entry.name,
                "type": "directory" if entry.is_dir() else "file",
                "path": str(entry.absolute()),
                "last_modified": datetime.fromtimestamp(entry.stat().st_mtime).isoformat()
            }
            
            if entry.is_dir():
                # Recursively process directories
                child_dict = create_file_dict(entry, extensions, exclude_dirs, max_content_size)
                entry_info["children"] = child_dict["children"]
            else:
                # Add file-specific information
                if extensions and entry.suffix not in extensions:
                    continue
                    
                size = entry.stat().st_size
                entry_info.update({
                    "size": size,
                    "size_formatted": f"{size/1024:.1f}KB" if size > 1024 else f"{size}B",
                    "extension": entry.suffix
                })
                
                # Only include content for text files under size limit
                if size <= max_content_size:
                    try:
                        with open(entry, "rb") as f:
                            content = f.read()
                            try:
                                # Try UTF-8 first
                                decoded = content.decode('utf-8')
                                entry_info.update({
                                    "content": decoded if len(decoded) <= max_content_size else decoded[:max_content_size] + "...",
                                    "encoding": "utf-8"
                                })
                            except UnicodeDecodeError:
                                # Fall back to chardet
                                result = chardet.detect(content)
                                if result["encoding"] and "utf" in result["encoding"].lower():
                                    try:
                                        decoded = content.decode(result["encoding"])
                                        entry_info.update({
                                            "content": decoded if len(decoded) <= max_content_size else decoded[:max_content_size] + "...",
                                            "encoding": result["encoding"]
                                        })
                                    except:
                                        entry_info["content_type"] = "binary"
                                else:
                                    entry_info["content_type"] = "binary"
                    except Exception as e:
                        entry_info["error"] = str(e)
                else:
                    entry_info["content_type"] = "large_file"
            
            result["children"].append(entry_info)
            
    except Exception as e:
        result["error"] = str(e)
        
    return result

def main():
    parser = argparse.ArgumentParser(description="Directory content viewer and JSON generator")
    parser.add_argument(
        "directory",
        metavar="directory",
        type=str,
        nargs="?",
        default=".",
        help="The directory to scan",
    )
    parser.add_argument(
        "-e",
        "--exclude-non-utf",
        action="store_true",
        help="Exclude non-UTF-8 files from output",
    )
    parser.add_argument(
        "-x",
        "--extensions",
        type=str,
        help="Comma-separated list of file extensions to include",
    )
    parser.add_argument(
        "-r", "--recursive", action="store_true", help="Recursively scan directories"
    )
    parser.add_argument(
        "-l", "--limit", type=int, help="Limit the number of files to display"
    )
    parser.add_argument(
        "-d",
        "--exclude-dirs",
        type=str,
        help="Comma-separated list of directories to exclude",
    )
    parser.add_argument(
        "--json",
        action="store_true",
        help="Output directory structure as JSON"
    )
    parser.add_argument(
        "--json-file",
        type=str,
        help="Save JSON output to specified file"
    )
    parser.add_argument(
        "--max-file-size",
        type=int,
        default=1024 * 1024,  # 1MB default
        help="Maximum file size in bytes to include content (default: 1MB)"
    )
    parser.add_argument(
        "--pretty-json",
        action="store_true",
        help="Output formatted JSON with syntax highlighting"
    )
    parser.add_argument(
        "--max-content-size",
        type=int,
        default=1024 * 100,  # 100KB default
        help="Maximum size in bytes for including file content in JSON"
    )
    parser.add_argument(
        "--indent",
        type=int,
        default=2,
        help="JSON indentation level"
    )

    args = parser.parse_args()

    dir_path = Path(args.directory).resolve()
    exclude_non_utf = args.exclude_non_utf
    extensions = (
        [f".{ext.strip()}" for ext in args.extensions.split(",")] if args.extensions else None
    )
    recursive = args.recursive
    limit = args.limit
    exclude_dirs = (
        [ex_dir.strip() for ex_dir in args.exclude_dirs.split(",")] if args.exclude_dirs else None
    )

    if args.json or args.json_file or args.pretty_json:
        # Generate directory structure
        dir_dict = create_file_dict(
            dir_path,
            extensions=extensions,
            exclude_dirs=exclude_dirs,
            max_content_size=args.max_content_size
        )
        
        if args.json_file:
            # Save to file with proper formatting
            with open(args.json_file, 'w', encoding='utf-8') as f:
                json.dump(dir_dict, f, indent=args.indent, ensure_ascii=False)
            console.print(f"[green]JSON output saved to: {args.json_file}[/green]")
        
        if args.pretty_json:
            # Display pretty JSON with syntax highlighting
            console.print(JSON(json.dumps(dir_dict, indent=args.indent, ensure_ascii=False)))
        
        if args.json and not args.json_file and not args.pretty_json:
            # Print raw JSON to stdout
            print(json.dumps(dir_dict, indent=args.indent, ensure_ascii=False))
            
        return

    # Create layout with better styling
    layout = Layout()
    layout.split_column(
        Layout(
            Panel.fit(
                "Directory Content Viewer",
                style="bold magenta",
                border_style="bright_magenta",
                padding=(1, 2)
            ),
            size=3
        ),
        Layout(name="main")
    )

    # Show directory tree with better formatting
    console.print("\n[bold yellow]Directory Structure:[/bold yellow]")
    file_tree = create_file_tree(dir_path, extensions, exclude_dirs)
    console.print(file_tree)
    console.print()

    # Read files directly without progress tracking
    files = []
    if dir_path.is_dir():
        for entry in dir_path.rglob('*') if recursive else dir_path.glob('*'):
            if entry.is_file():
                if extensions and entry.suffix not in extensions:
                    continue
                if exclude_dirs and any(d in entry.parts for d in exclude_dirs):
                    continue
                relative_path = entry.relative_to(dir_path)
                try:
                    with open(entry, "rb") as file:
                        file_content = file.read()
                    files.append((relative_path, file_content))
                except Exception as e:
                    console.print(f"[red]Error reading {relative_path}: {str(e)}[/red]")

    if limit:
        files = files[:limit]

    total_files = len(files)
    if total_files == 0:
        console.print("[yellow]No matching files found![/yellow]")
        return

    # Display files with improved content handling
    for i, (file_path, content) in enumerate(files, start=1):
        console.rule(f"[cyan]File {i}/{total_files}[/cyan]", style="bright_black")
        
        # Enhanced file header
        header = Text()
        header.append("📄 ", style="green")
        header.append(str(file_path), style="bold blue")
        header.append(f" ({len(content)/1024:.1f}KB)", style="dim")
        
        console.print(Panel(header, border_style="bright_black", padding=(1, 2)))

        # Better content display with syntax highlighting
        try:
            # Try to decode with UTF-8 first
            try:
                decoded_content = content.decode('utf-8')
                is_binary = False
            except UnicodeDecodeError:
                # Fall back to chardet if UTF-8 fails
                result = chardet.detect(content)
                encoding = result["encoding"] if result["confidence"] > 0.7 else None
                if encoding and "utf" in encoding.lower():
                    decoded_content = content.decode(encoding)
                    is_binary = False
                else:
                    is_binary = True

            if not is_binary:
                # Auto-detect syntax for better highlighting
                file_extension = file_path.suffix.lstrip('.')
                syntax = Syntax(
                    decoded_content,
                    file_extension or "text",
                    theme="monokai",
                    line_numbers=True,
                    word_wrap=True,
                    background_color="default",
                    code_width=100  # Limit width for better readability
                )
                console.print(Panel(
                    syntax,
                    border_style="dim",
                    padding=(1, 2)
                ))
            else:
                if not exclude_non_utf:
                    # For binary files, show a hex dump preview
                    hex_dump = "\n".join(
                        f"{i:08x}: {' '.join(f'{b:02x}' for b in content[i:i+16])}"
                        for i in range(0, min(len(content), 128), 16)
                    )
                    console.print(Panel(
                        Text("Binary or non-text content", style="yellow"),
                        border_style="yellow",
                        padding=(1, 2)
                    ))
                    console.print(Panel(
                        hex_dump,
                        title="First 128 bytes",
                        border_style="dim",
                        padding=(1, 2)
                    ))
        except Exception as e:
            console.print(Panel(
                f"[red]Error displaying content: {str(e)}[/red]",
                border_style="red",
                padding=(1, 2)
            ))

        console.print()  # Add spacing between files

if __name__ == "__main__":
    main()
