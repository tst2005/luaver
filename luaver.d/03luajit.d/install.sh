__luaver_install_luajit() {
	local version="$1"
	local luajit_dir_name="LuaJIT-${version}"
	local archive_name="${luajit_dir_name}.tar.gz"
	local url="http://luajit.org/download/${archive_name}"
	__luaver_print "Installing ${luajit_dir_name}"
	__luaver_exec_command cd -- "${__luaver_SRC_DIR}"
	__luaver_download_and_unpack $luajit_dir_name $archive_name $url
	__luaver_exec_command cd -- "${luajit_dir_name}"
	__luaver_print "Compiling ${luajit_dir_name}"
	__luaver_exec_command make "PREFIX=${__luaver_LUAJIT_DIR}/${version}"
	__luaver_exec_command make install "PREFIX=${__luaver_LUAJIT_DIR}/${version}"
	read -r -p "${luajit_dir_name} successfully installed. Do you want to switch to this version? [Y/n]: " choice
	case "$choice" in
		([yY][eE][sS]|[yY])
			__luaver_use_luajit $version
		;;
	esac
}
