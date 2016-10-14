__luaver_list_luajit() {
	local installed_versions=($(ls $__luaver_LUAJIT_DIR/))
	__luaver_get_current_luajit_version current_version
	if [ ${#installed_versions[@]} -eq 0 ]; then
		__luaver_print "No version of LuaJIT is installed"
	else
		__luaver_print "Installed versions: "
		for version in "${installed_versions[@]}"; do
			if [ "${version}" = "${current_version}" ]; then
				__luaver_print "LuaJIT-${version} <--"
			else
				__luaver_print "LuaJIT-${version}"
			fi
		done
	fi
}
