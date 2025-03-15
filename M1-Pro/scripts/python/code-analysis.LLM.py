#!/usr/bin/env python3
"""
Code Analysis Tool for LLM

This tool scans a directory recursively for code files (default: Python files),
analyzes each file to count the total number of lines, functions, classes, and
extracts the top definitions. It supports parallel processing, filtering by
thresholds, multiple output formats (JSON, pretty JSON, CSV, Markdown, table),
sorting, and summary statistics.

Author:
    Aidan Littman[https://github.com/spmfte]

Usage:
    ./code-analysis.LLM.py [directory] [options]

Example:
    ./code-analysis.LLM.py . --exclude venv node_modules --output-format pretty-json --summary
"""

__version__ = "1.0.0"
__author__ = "Aidan Littman [https://github.com/spmfte]"

import argparse
import json
import logging
import multiprocessing
import os
import re
from csv import DictWriter
from io import StringIO
from pathlib import Path
from statistics import mean
from typing import Any, Dict, List, Optional, Pattern

from rich.console import Console
from rich.json import JSON as RichJSON
from rich.progress import Progress, SpinnerColumn, TextColumn
from rich.table import Table

# Setup standard logging
logging.basicConfig(
    level=logging.INFO, format="%(asctime)s [%(levelname)s] %(message)s"
)
logger = logging.getLogger(__name__)

# Global Rich console for styled output
console = Console()


class CodeAnalyzer:
    """Analyzes code files for line counts, function and class definitions.

    Attributes:
        directory (Path): Base directory to scan.
        exclude (List[str]): List of directory names to exclude.
        file_pattern (Pattern[str]): Compiled regex pattern to filter files.
    """

    def __init__(
        self, directory: str = ".", exclude: Optional[List[str]] = None, file_pattern: str = r".*\.py$"
    ) -> None:
        """
        Args:
            directory (str): Directory to scan.
            exclude (Optional[List[str]]): Directories to exclude.
            file_pattern (str): Regex pattern for file matching.
        """
        self.directory = Path(directory)
        self.exclude = exclude or []
        self.file_pattern: Pattern[str] = re.compile(file_pattern)

    def find_files(self) -> List[Path]:
        """Recursively find files matching the file_pattern, excluding specified directories.

        Returns:
            List[Path]: List of matching file paths.
        """
        matched_files = []
        for root, dirs, files in os.walk(self.directory):
            # Exclude specified directories
            dirs[:] = [d for d in dirs if d not in self.exclude]
            for file in files:
                if self.file_pattern.match(file):
                    matched_files.append(Path(root) / file)
        return matched_files

    @staticmethod
    def analyze_file(file_path: Path) -> Dict[str, Any]:
        """Analyze a single file for line count, functions, and classes.

        Args:
            file_path (Path): The file to analyze.

        Returns:
            Dict[str, Any]: Analysis result including file path, counts, and definitions.
        """
        try:
            with file_path.open("r", encoding="utf-8") as f:
                lines = f.readlines()
        except Exception as e:
            return {"file": str(file_path), "error": str(e)}

        structure = []
        func_count = 0
        class_count = 0

        for line in lines:
            stripped = line.strip()
            if stripped.startswith("def "):
                func_count += 1
                structure.append(stripped)
            elif stripped.startswith("class "):
                class_count += 1
                structure.append(stripped)

        return {
            "file": str(file_path),
            "lines": len(lines),
            "functions": func_count,
            "classes": class_count,
            "definitions": structure,
        }

    def analyze_files(self, workers: int = 1) -> List[Dict[str, Any]]:
        """Analyze all matching files in parallel.

        Args:
            workers (int): Number of parallel worker processes.

        Returns:
            List[Dict[str, Any]]: List of analysis results.
        """
        files = self.find_files()
        logger.info("Found %d files for analysis.", len(files))
        results = []

        with Progress(
            SpinnerColumn(), TextColumn("[progress.description]{task.description}"), transient=True
        ) as progress:
            task = progress.add_task("[cyan]Analyzing files...", total=len(files))
            with multiprocessing.Pool(workers) as pool:
                for result in pool.imap_unordered(CodeAnalyzer.analyze_file, files):
                    results.append(result)
                    progress.advance(task)
        return results


def compute_summary(results: List[Dict[str, Any]]) -> Dict[str, Any]:
    """Compute summary statistics from analysis results.

    Args:
        results (List[Dict[str, Any]]): Analysis results.

    Returns:
        Dict[str, Any]: Summary including totals and averages.
    """
    valid_results = [res for res in results if "error" not in res]
    total_files = len(results)
    analyzed_files = len(valid_results)
    total_lines = sum(res.get("lines", 0) for res in valid_results)
    total_functions = sum(res.get("functions", 0) for res in valid_results)
    total_classes = sum(res.get("classes", 0) for res in valid_results)
    avg_lines = mean([res.get("lines", 0) for res in valid_results]) if valid_results else 0

    return {
        "total_files": total_files,
        "analyzed_files": analyzed_files,
        "total_lines": total_lines,
        "total_functions": total_functions,
        "total_classes": total_classes,
        "average_lines_per_file": avg_lines,
    }


def output_results(
    results: List[Dict[str, Any]], output_format: str, output_file: Optional[str] = None
) -> None:
    """Output analysis results in the specified format.

    Args:
        results (List[Dict[str, Any]]): Analysis results.
        output_format (str): One of 'json', 'pretty-json', 'csv', 'markdown', 'table'.
        output_file (Optional[str]): File path to write output, if provided.
    """
    if output_format in ("json", "pretty-json"):
        indent = 2 if output_format == "pretty-json" else None
        json_output = json.dumps(results, indent=indent)
        if output_file:
            with open(output_file, "w", encoding="utf-8") as f:
                f.write(json_output)
            logger.info("Output written to %s", output_file)
        else:
            if output_format == "pretty-json":
                console.print_json(json_output)
            else:
                print(json_output)

    elif output_format == "csv":
        if results:
            keys = results[0].keys()
            sio = StringIO()
            writer = DictWriter(sio, fieldnames=keys)
            writer.writeheader()
            for row in results:
                writer.writerow(row)
            csv_output = sio.getvalue()
            if output_file:
                with open(output_file, "w", encoding="utf-8") as f:
                    f.write(csv_output)
                logger.info("Output written to %s", output_file)
            else:
                print(csv_output)

    elif output_format in ("markdown", "table"):
        table = Table(title="Code Analysis Results", header_style="bold magenta")
        table.add_column("File", style="cyan")
        table.add_column("Lines", justify="right")
        table.add_column("Functions", justify="right")
        table.add_column("Classes", justify="right")
        table.add_column("Errors", style="red")
        table.add_column("Top Definitions", overflow="fold")

        for res in results:
            error = res.get("error", "")
            defs = "\n".join(res.get("definitions", [])[:3])
            table.add_row(
                res.get("file", ""),
                str(res.get("lines", "")),
                str(res.get("functions", "")),
                str(res.get("classes", "")),
                error,
                defs,
            )

        if output_file:
            with open(output_file, "w", encoding="utf-8") as f:
                f.write(console.export_text())
            logger.info("Output written to %s", output_file)
        else:
            console.print(table)

    else:
        logger.error("Unsupported output format: %s", output_format)


def main() -> None:
    """Main entry point for the code analysis tool."""
    parser = argparse.ArgumentParser(
        description="Code Analysis Tool for LLM"
    )
    parser.add_argument("directory", nargs="?", default=".", help="Directory to scan (default: current dir)")
    parser.add_argument("--exclude", nargs="+", help="Directories to exclude from scanning")
    parser.add_argument(
        "--workers", type=int, default=max(1, multiprocessing.cpu_count() - 1), help="Number of parallel workers"
    )
    parser.add_argument(
        "--output-format",
        choices=["json", "pretty-json", "csv", "markdown", "table"],
        default="pretty-json",
        help="Output format",
    )
    parser.add_argument("--output-file", help="Optional file to write output to")
    parser.add_argument("--min-lines", type=int, default=0, help="Minimum number of lines to include a file")
    parser.add_argument("--min-functions", type=int, default=0, help="Minimum number of functions to include a file")
    parser.add_argument("--min-classes", type=int, default=0, help="Minimum number of classes to include a file")
    parser.add_argument(
        "--sort-by",
        choices=["file", "lines", "functions", "classes"],
        default="file",
        help="Sort output by specified field",
    )
    parser.add_argument("--summary", action="store_true", help="Display summary statistics")
    parser.add_argument("--version", action="version", version="CodeAnalyzer 1.0.0")
    args = parser.parse_args()

    analyzer = CodeAnalyzer(directory=args.directory, exclude=args.exclude)
    results = analyzer.analyze_files(workers=args.workers)

    # Filter results by thresholds
    filtered_results = [
        res
        for res in results
        if res.get("lines", 0) >= args.min_lines
        and res.get("functions", 0) >= args.min_functions
        and res.get("classes", 0) >= args.min_classes
    ]

    # Sort results
    sort_key = args.sort_by
    if sort_key == "file":
        filtered_results.sort(key=lambda x: x.get("file", "").lower())
    else:
        filtered_results.sort(key=lambda x: x.get(sort_key, 0), reverse=True)

    # Output analysis results in chosen format
    output_results(filtered_results, args.output_format, args.output_file)

    # Optionally display summary statistics
    if args.summary:
        summary_stats = compute_summary(filtered_results)
        console.print("\n[bold green]Summary Statistics[/bold green]")
        console.print_json(json.dumps(summary_stats, indent=2))


if __name__ == "__main__":
    main()
