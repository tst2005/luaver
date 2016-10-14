
# Returns the current lua version
__luaver_get_current_lua_version() {
	local version="$(which lua)"
	if __luaver_exists lua; then
		version="${version#$__luaver_LUA_DIR/}"
		version="${version%/bin/lua}"
	else
		version=""
	fi
	eval "$1='$version'"
}

