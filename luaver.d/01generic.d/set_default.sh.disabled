__luaver_set_default() {
	local product="$1";shift
	local version="$1"
	__luaver_exec_command eval "echo \"${version}\" > \"$(__luaver_getdir default "$product")\""
	__luaver_print "Default version set for ${product}: ${version}"
}
