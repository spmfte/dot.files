#!/bin/sh

echo "["

find . -name "*.py" | while read file; do
  line_count=$(wc -l < "$file")

  # Extract function and class names with indentation
  structure=$(awk '
    /^[[:space:]]*class / {print $0}
    /^[[:space:]]*def / {print $0}
  ' "$file" | sed 's/^[[:space:]]*//')  # Trim leading spaces

  func_count=$(echo "$structure" | grep -c "^def ")
  class_count=$(echo "$structure" | grep -c "^class ")

  echo "  {"
  echo "    \"file\": \"$file\","
  echo "    \"lines\": $line_count,"
  echo "    \"functions\": $func_count,"
  echo "    \"classes\": $class_count,"
  echo "    \"definitions\": ["

  # Print function/class names in JSON format
  echo "$structure" | awk '{print "      \"" $0 "\","}' | sed '$ s/,$//'

  echo "    ]"
  echo "  },"
done | sed '$ s/,$//'

echo "]"
