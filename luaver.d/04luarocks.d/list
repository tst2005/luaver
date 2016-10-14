__luaver_list_luarocks() {
	local installed_versions=($(ls $__luaver_LUAROCKS_DIR/))
	__luaver_get_current_luarocks_version current_luarocks_version
	__luaver_get_lua_version_by_current_luarocks current_lua_version
	if [ ${#installed_versions[@]} -eq 0 ]; then
		__luaver_print "No version of luarocks is installed"
	else
		__luaver_print "Installed versions: "
		for version in "${installed_versions[@]}"; do
			luarocks_version="${version%_*}"
			lua_version="${version#*_}"
			if [ "${luarocks_version}" = "${current_luarocks_version}" ] && [ "${lua_version}" = "${current_lua_version}" ]; then
				__luaver_print "luarocks-${luarocks_version} (lua version: ${lua_version}) <--"
			else
				__luaver_print "luarocks-${luarocks_version} (lua version: ${lua_version})"
			fi
		done
	fi
}
