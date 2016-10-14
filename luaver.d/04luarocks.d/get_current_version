
# Returns the current luarocks version
__luaver_get_current_luarocks_version() {
	local version="$(which luarocks)"
	if __luaver_exists "luarocks"; then
		version="${version#$__luaver_LUAROCKS_DIR/}"
		version="${version%/bin/luarocks}"
		version="${version%_*}"
	else
		version=""
	fi
	eval "$1='$version'"
}
