#!/bin/sh

cd -- "$(dirname "$0")"

(
for f in $(find luaver.d/ -type f -name '*.sh' | sort ); do
	cat "$f"
done
) > luaver.new2
#cat luaver.d/01common.header luaver.d/01generic.d/* luaver.d/02lua.d/* luaver.d/03luajit.d/* luaver.d/04luarocks.d/* luaver.d/05common.footer > luaver.new
