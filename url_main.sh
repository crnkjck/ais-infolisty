#!/bin/bash

set -e

usage() {
    echo "Usage: $0 season target_directory" >&2
    echo "season format is {YYYY}-{YYYY+1}" >&2
    exit 1
}

case "$1" in
    ????-????)
	season="$1"
	;;
    *)
	usage
	;;
esac

[ -n "$2" ] || usage
target_directory="$2"

ultimatetarget="$target_directory/$season"

./url_infolists.pl "$season" "$target_directory"
./url_study_programs.pl "$season" "$target_directory"

echo "Merging all language versions into $ultimatetarget" >&2
cd "$ultimatetarget"
for sksp in sk/sp_*; do
    sp="${sksp#sk/}"
    sort */"$sp" > "$sp"
done
