__luaver_uninstall_luarocks() {
	local version="$1"
	local luarocks_name="luarocks-${version}"
	__luaver_get_current_lua_version_short lua_version
	__luaver_get_current_luarocks_version current_version
	__luaver_print "${luarocks_name} will be uninstalled for lua version ${lua_version}"
	__luaver_x_uninstall $luarocks_name $__luaver_LUAROCKS_DIR "${version}_${lua_version}"
	if [ "${version}" = "${current_version}" ]; then
		__luaver_remove_previous_paths "${__luaver_LUAROCKS_DIR}"
	fi
}
