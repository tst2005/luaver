__luaver_install_lua() {
	local version="$1"
	local lua_dir_name="lua-${version}"
	local archive_name="${lua_dir_name}.tar.gz"
	local url="http://www.lua.org/ftp/${archive_name}"
	__luaver_print "Installing ${lua_dir_name}"
	__luaver_exec_command cd -- "${__luaver_SRC_DIR}"
	__luaver_download_and_unpack $lua_dir_name $archive_name $url
	__luaver_get_platform platform
	__luaver_exec_command cd -- "${lua_dir_name}"
	__luaver_print "Compiling ${lua_dir_name}"
	__luaver_exec_command make "${platform}" install "INSTALL_TOP=${__luaver_LUA_DIR}/${version}"
	echo >&2 "${lua_dir_name} successfully installed."
#	read -r -p "${lua_dir_name} successfully installed. Do you want to switch to this version? [Y/n]: " choice
#	case "$choice" in
#		([yY][eE][sS]|[yY])
#			__luaver_use_lua $version
#		;;
#	esac
}
