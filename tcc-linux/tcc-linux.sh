#!/bin/sh
printf '\033c\033]0;%s\a' The Roket Jumper-Ascencion-tcc
base_path="$(dirname "$(realpath "$0")")"
"$base_path/The_rocket_jumpAcensionV1.9.x86_64" "$@"
