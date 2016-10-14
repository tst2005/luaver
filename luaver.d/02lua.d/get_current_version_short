
# Returns the current lua version (only the first two numbers)
__luaver_get_current_lua_version_short() {
	local version=""
	if __luaver_exists lua; then
		version="$(lua -e 'print(_VERSION:sub(5))')"
	fi
	eval "$1='$version'"
}
