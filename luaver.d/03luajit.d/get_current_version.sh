# Returns the current luajit version
__luaver_get_current_luajit_version() {
	local version="$(which luajit)"
	if __luaver_exists "luajit"; then
		version="${version#$__luaver_LUAJIT_DIR/}"
		version="${version%/bin/luajit}"
	else
		version=""
	fi
	eval "$1='$version'"
}
