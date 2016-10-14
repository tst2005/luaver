__luaver_uninstall_lua() {
	local version="$1"
	local lua_name="lua-${version}"
	__luaver_get_current_lua_version current_version
	__luaver_x_uninstall $lua_name $__luaver_LUA_DIR $version
	if [ "${version}" = "${current_version}" ]; then
		__luaver_remove_previous_paths "${__luaver_LUA_DIR}"
	fi
}
