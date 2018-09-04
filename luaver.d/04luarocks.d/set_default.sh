__luaver_set_default_luarocks() {
	local version="$1"
	__luaver_exec_command eval "echo \"${version}\" > \"${__luaver_LUAROCKS_DEFAULT_FILE}\""
	__luaver_print "Default version set for luarocks: ${version}"
}
