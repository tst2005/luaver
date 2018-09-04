#!/bin/sh

cd -- "$(dirname "$0")"

(
for f in $(find luaver.d/ -type f -name '*.sh' | sort ); do
	cat "$f"
done
) > luaver.new
chmod +x luaver.new
