__luaver_set_default_luajit() {
	local version="$1"
	__luaver_exec_command eval "echo \"${version}\" > \"${__luaver_LUAJIT_DEFAULT_FILE}\""
	__luaver_print "Default version set for luajit: ${version}"
}
