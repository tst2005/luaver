__luaver_use() {
	local product="$1";shift;
	local version="$1"
	local name="${product}-${version}"
	__luaver_print "Switching to ${name}"
	# Checking if this version exists
	__luaver_exec_command cd -- "$(__luaver_getdir inst "$product" .)"
	if [ ! -e "$version" ]; then
		read -r -p "${name} is not installed. Do you want to install it? [Y/n]: " choice
		case "$choice" in
			([yY][eE][sS]|[yY])
				__luaver_install lua $version
			;;
			(*)
				__luaver_error "Unable to use ${name}"
			;;
		esac
		return
	fi

	__luaver_remove_previous_paths "$(__luaver_getdir inst "$product" .)"
	__luaver_append_path "$(__luaver_getdir inst "$product" .)/${version}/bin"
	__luaver_print "Successfully switched to ${name}"

	# FIXME: hack for luarocks...
	if [ "$product" = "lua" ]; then
		# Checking whether luarocks is in use
		if __luaver_exists "luarocks"; then
			# Checking if lua version of luarocks is consistent
			__luaver_get_current_lua_version_short lua_version_1
			__luaver_get_lua_version_by_current_luarocks lua_version_2
			__luaver_get_current_luarocks_version luarocks_version
			if [ "$lua_version_1" != "$lua_version_2" ]; then
				# Removing earlier version
				__luaver_remove_previous_paths "${__luaver_LUAROCKS_DIR}"
				__luaver_print "Luarocks in use is inconsistent with this lua version"
				__luaver_use_luarocks $luarocks_version
			fi
		fi
	fi
}
