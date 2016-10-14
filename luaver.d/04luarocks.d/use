__luaver_use_luarocks() {
	local version="$1"
	local luarocks_name="luarocks-${version}"
	__luaver_get_current_lua_version_short lua_version
	if [ -z "${lua_version}" ]; then
		__luaver_error "You need to first switch to a lua installation"
	fi
	__luaver_print "Switching to ${luarocks_name} with lua version: ${lua_version}"
	# Checking if this version exists
	__luaver_exec_command cd -- "${__luaver_LUAROCKS_DIR}"
	if [ ! -e "${version}_${lua_version}" ]; then
		read -r -p "${luarocks_name} is not installed with lua version ${lua_version}. Want to install it? [Y/n]: " choice
		case "$choice" in
			([yY][eE][sS]|[yY])
				__luaver_install_luarocks $version
			;;
			(*)
				__luaver_error "Unable to use ${luarocks_name}"
			;;
		esac
		return
	fi
	__luaver_remove_previous_paths "${__luaver_LUAROCKS_DIR}"
	__luaver_append_path "${__luaver_LUAROCKS_DIR}/${version}_${lua_version}/bin"
	# Setting up LUA_PATH and LUA_CPATH
	eval $(luarocks path)
	__luaver_print "Successfully switched to ${luarocks_name}"
}
