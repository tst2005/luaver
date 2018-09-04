#!/bin/bash

# Lua Version Manager
# Managing and switching between different versions of Lua, LuaJIT and Luarocks made easy
#
# Developed by Dhaval Kapil <me@dhavalkapil.com>
#           by TsT <tst2005@gmail.com>
#
# MIT license http://www.opensource.org/licenses/mit-license.php

__luaver_VERSION="1.1.0"

# Directories and files to be used

__luaver_LUAVER_DIR="${HOME}/.luaver"                                      # The luaver directory
__luaver_SRC_DIR="${__luaver_LUAVER_DIR}/src"                              # Source code is downloaded

__luaver_LUA_DIR="${__luaver_LUAVER_DIR}/lua.tmp"                              # Lua      source is built
__luaver_LUAJIT_DIR="${__luaver_LUAVER_DIR}/luajit.tmp"                        # Luajit   source is built
__luaver_LUAROCKS_DIR="${__luaver_LUAVER_DIR}/luarocks.tmp"                    # Luarocks source is built

#__luaver_LUA_DEFAULT_FILE="${__luaver_LUAVER_DIR}/DEFAULT_LUA"             # Lua      default version
#__luaver_LUAJIT_DEFAULT_FILE="${__luaver_LUAVER_DIR}/DEFAULT_LUAJIT"       # Luajit   default version
#__luaver_LUAROCKS_DEFAULT_FILE="${__luaver_LUAVER_DIR}/DEFAULT_LUAROCKS"   # Luarocks default version

# __luaver_getdir src lua 5.3.3
# __luaver_getdir inst lua 5.3.3
# __luaver_getdir default lua
__luaver_getdir() {
	local target="$1";shift
	local product="${1:-unknown}";shift
	case "$product" in
		(lua|luajit|luarocks) ;;
		(".") product='' ;;
		(*) echo >&2 "invalid name $1" ; return 1 ;;
	esac
	case "$target" in
		src)
			printf '%s/%s/%s\n'	"$__luaver_LUAVER_DIR" "src" "$product"
		;;
		tmp)
			printf '%s/%s/%s\n'	"$__luaver_LUAVER_DIR" "tmp" "$product"
		;;
#		default)
#			printf '%s/%s_%s_%s\n'	"$__luaver_LUAVER_DIR" "default" "$product" "${1:-DEFAULT}"
#		;;
		inst)
			local version="${1:-unknown}";shift
			printf '%s/%s/%s/%s\n'	"$__luaver_LUAVER_DIR" "inst" "$product" "$version"
		;;
		(*) echo ERROR; return 1 ;;
	esac
}
__luaver_getbin() {
	local dir="$(__luaver_getdir inst "$@")"
	if [ -x "$dir/bin/$1-$2" ]; then
		echo "$dir/bin/$1-$2"
	elif [ -x "$dir/bin/$1" ]; then
		echo "$dir/bin/$1"
	else
		echo ""
	fi
}

# Directories and files to be used

__luaver_LUAVER_DIR="${HOME}/.luaver"                                      # The luaver directory
__luaver_SRC_DIR="$__luaver_LUAVER_DIR/src"                                # Source code is downloaded

__luaver_LUA_DIR="$(     __luaver_getdir inst lua      .)"                 # Lua      product is installed
__luaver_LUAJIT_DIR="$(  __luaver_getdir inst luajit   .)"                 # Luajit   product is installed
__luaver_LUAROCKS_DIR="$(__luaver_getdir inst luarocks .)"                 # Luarocks product is installed

#__luaver_LUA_DEFAULT_FILE="$(     __luaver_getdir default lua     )"       # Lua      default used version
#__luaver_LUAJIT_DEFAULT_FILE="$(  __luaver_getdir default luajit  )"       # Luajit   default used version
#__luaver_LUAROCKS_DEFAULT_FILE="$(__luaver_getdir default luarocks)"       # Luarocks default used version


# .luaver/
#	src/
#		lua-5.1.5/
#		lua-5.2.4/
#		lua-5.3.3/
#		LuaJIT-2.0.4/
#		LuaJIT-2.1.0-beta2/
#	<product>/<version>/bin/*
#
# .luaver/
#	src/
#		...
#	inst/<product>/<version>/bin/*
#	tmp/

__luaver_present_dir=""

# Verbose level
__luaver_verbose=0

