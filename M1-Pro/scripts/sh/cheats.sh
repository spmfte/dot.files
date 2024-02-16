#!/bin/sh
languages=$(echo "python rust lua c bash" | tr   n)
core_utils=$(echo "xargs find mv sed awk" | tr   n)

printf "$languages
$core_utils
