#!/bin/sh

cd -- "$(dirname "$0")"

#cat luaver.d/01common.header luaver.d/02lua luaver.d/03luajit luaver.d/04luarocks luaver.d/05common.footer > luaver.new
cat luaver.d/01common.header luaver.d/02lua.d/* luaver.d/03luajit.d/* luaver.d/04luarocks.d/* luaver.d/05common.footer > luaver.new
