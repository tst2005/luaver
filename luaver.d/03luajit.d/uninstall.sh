__luaver_uninstall_luajit() {
	local version="$1"
	local luajit_name="LuaJIT-${version}"
	__luaver_get_current_luajit_version current_version
	__luaver_x_uninstall $luajit_name $__luaver_LUAJIT_DIR $version
	if [ "${version}" = "${current_version}" ]; then
		__luaver_remove_previous_paths "${__luaver_LUAJIT_DIR}"
	fi
}
