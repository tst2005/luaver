
# Returns the short lua version being supported by present luarocks
__luaver_get_lua_version_by_current_luarocks() {
	local version="$(which luarocks)"
	if __luaver_exists "luarocks"; then
		version="${version#$__luaver_LUAROCKS_DIR/}"
		version="${version%/bin/luarocks}"
		version="${version#*_}"
	else
		version=""
	fi
	eval "$1='$version'"
}
