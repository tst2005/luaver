__luaver_list_lua() {
	local installed_versions=($(ls $__luaver_LUA_DIR/))
	__luaver_get_current_lua_version current_version
	if [ ${#installed_versions[@]} -eq 0 ]; then
		__luaver_print "No version of lua is installed"
	else
		__luaver_print "Installed versions: "
		for version in "${installed_versions[@]}"; do
			if [ "${version}" = "${current_version}" ]; then
				__luaver_print "lua-${version} <--"
			else
				__luaver_print "lua-${version}"
			fi
		done
	fi
}
