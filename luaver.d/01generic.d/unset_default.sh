__luaver_unset_default() {
	local product="$1";shift;
	__luaver_exec_command rm -- "$(__luaver_getdir default "$product")"
	__luaver_print "Removed default version for ${product}"
}
