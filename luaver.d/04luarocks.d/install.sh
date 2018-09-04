__luaver_install_luarocks() {
	# Checking whether any version of lua is installed or not
	__luaver_get_current_lua_version lua_version
	if [ -z "${lua_version}" ]; then
		__luaver_error "No lua version set"
	fi
	__luaver_get_current_lua_version_short lua_version_short
	local version="$1"
	local luarocks_dir_name="luarocks-${version}"
	local archive_name="${luarocks_dir_name}.tar.gz"
	local url="http://luarocks.org/releases/${archive_name}"
	__luaver_print "Installing ${luarocks_dir_name} for lua version ${lua_version}"
	__luaver_exec_command cd -- "${__luaver_SRC_DIR}"
	__luaver_download_and_unpack $luarocks_dir_name $archive_name $url
	__luaver_exec_command cd -- "${luarocks_dir_name}"
	__luaver_print "Compiling ${luarocks_dir_name}"
	__luaver_exec_command ./configure \
		"--prefix=${__luaver_LUAROCKS_DIR}/${version}_${lua_version_short}" \
		"--with-lua=${__luaver_LUA_DIR}/${lua_version}" \
		"--with-lua-bin=${__luaver_LUA_DIR}/${lua_version}/bin" \
		"--with-lua-include=${__luaver_LUA_DIR}/${lua_version}/include" \
		"--with-lua-lib=${__luaver_LUA_DIR}/${lua_version}/lib" \
		"--versioned-rocks-dir"
	__luaver_exec_command make build
	__luaver_exec_command make install
	read -r -p "${luarocks_dir_name} successfully installed. Do you want to switch to this version? [Y/n]: " choice
	case "$choice" in
		([yY][eE][sS]|[yY])
			__luaver_use_luarocks $version
		;;
	esac
}
