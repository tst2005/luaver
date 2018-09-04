__luaver_use_luajit() {
	local version="$1"
	local luajit_name="LuaJIT-${version}"
	__luaver_print "Switching to ${luajit_name}"
	# Checking if this version exists
	__luaver_exec_command cd -- "${__luaver_LUAJIT_DIR}"
	if [ ! -e $version ]; then
		read -r -p "${luajit_name} is not installed. Want to install it? [Y/n]: " choice
		case "$choice" in
			([yY][eE][sS]|[yY])
				__luaver_install_lua $version
			;;
			(*)
				__luaver_error "Unable to use ${luajit_name}"
			;;
		esac
		return
	fi
	__luaver_remove_previous_paths "${__luaver_LUAJIT_DIR}"
	__luaver_append_path "${__luaver_LUAJIT_DIR}/${version}/bin"
	__luaver_print "Successfully switched to ${luajit_name}"
}
