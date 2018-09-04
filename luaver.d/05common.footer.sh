
###############################################################################
# Helper functions


# Removes existing strings starting with a prefix in PATH
__luaver_remove_previous_paths() {
	local prefix="$1"
	local new_path="$(echo "$PATH" | sed \
		-e "s#${prefix}/[^/]*/bin[^:]*:##g" \
		-e "s#:${prefix}/[^/]*/bin[^:]*##g" \
		-e "s#${prefix}/[^/]*/bin[^:]*##g")"
	export PATH="$new_path"
}

# Append to PATH
__luaver_append_path() {
	export PATH="${1}:${PATH}"
}


# Error handling function
__luaver_error() {
	printf "$1\n" 1>&2
	__luaver_exec_command cd -- "${__luaver_present_dir}"
	kill -INT $$
}

# Printing bold text - TODO
__luaver_print() {
	if [ $__luaver_verbose -ne 0 ]; then
		tput bold
		printf "==>  $1\n"
		tput sgr0
	fi
}

# Printing formatted text
__luaver_print_formatted() {
	printf "%s"'\n' "${1}"
}

# A wrapper function to execute commands on the terminal and exit on error
# Called whenever the execution should stop after any error occurs
__luaver_exec_command() {
	"$@"
	if [ $? -ne 0 ]; then
		__luaver_error "Unable to execute the following command:\n$1\nExiting"
	fi
}

# Perform some initialization
__luaver_init() {
	__luaver_present_dir="$(pwd)"
	if [ ! -d "$__luaver_LUAVER_DIR" ]; then
		__luaver_exec_command mkdir -- "${__luaver_LUAVER_DIR}"
	fi
	if [ ! -d "$__luaver_SRC_DIR" ]; then
		__luaver_exec_command mkdir -- "${__luaver_SRC_DIR}"
	fi
	if [ ! -d "$__luaver_LUA_DIR" ]; then
		__luaver_exec_command mkdir -- "${__luaver_LUA_DIR}"
	fi
	if [ ! -d "$__luaver_LUAJIT_DIR" ]; then
		__luaver_exec_command mkdir -- "${__luaver_LUAJIT_DIR}"
	fi
	if [ ! -d "$__luaver_LUAROCKS_DIR" ]; then
		__luaver_exec_command mkdir -- "${__luaver_LUAROCKS_DIR}"
	fi
#	if [ -f "$__luaver_LUA_DEFAULT_FILE" ]; then
#		local lua_version="$(cat -- "$__luaver_LUA_DEFAULT_FILE")"
#		__luaver_use_lua $lua_version
#	fi
#	if [ -f "$__luaver_LUAJIT_DEFAULT_FILE" ]; then
#		local luajit_version="$(cat -- "$__luaver_LUAJIT_DEFAULT_FILE")"
#		__luaver_use_luajit $luajit_version
#	fi
#	if [ -f "$__luaver_LUAROCKS_DEFAULT_FILE" ]; then
#		local luarocks_version="$(cat -- "$__luaver_LUAROCKS_DEFAULT_FILE")"
#		__luaver_use_luarocks $luarocks_version
#	fi
	__luaver_verbose=1
	__luaver_exec_command cd -- "${__luaver_present_dir}"
}

# Checking whether a particular tool exists or not
__luaver_exists() {
	case "$1" in
		("lua")
			case "$(which lua)" in
				("${__luaver_LUA_DIR}/"*) return 0 ;;
			esac
			return 1
			#if [ "$(which lua)" = "${__luaver_LUA_DIR}/"* ]; then
			#	return 0
			#else
			#	return 1
			#fi
		;;
		("luajit")
			case "$(which luajit)" in
				("${__luaver_LUAJIT_DIR}/"*) return 0 ;;
			esac
			return 1
			#if [ "$(which luajit)" = "${__luaver_LUAJIT_DIR}/"* ]; then
			#	return 0
			#else
			#	return 1
			#fi
		;;
		("luarocks")
			case "$(which luarocks)" in
				("${__luaver_LUAROCKS_DIR}/"*) return 0 ;;
			esac
			return 1
			#if [ "$(which luarocks)" = "${__luaver_LUAROCKS_DIR}/"* ]; then
			#	return 0
			#else
			#	return 1
			#fi
		;;
	esac

	type "$1" >/dev/null 2>&1
}

# Downloads file from a url
__luaver_download() {
	local url="$1"
	local tofile="$2"
	__luaver_print "Downloading from ${url}"
	if __luaver_exists "wget"; then
		if [ -n "$tofile" ]; then
			__luaver_exec_command wget -q -O "$tofile" -- "${url}"
		else
			__luaver_exec_command wget -- "${url}"
		fi
	else
		__luaver_error "'wget' must be installed"
	fi
	__luaver_print "Download successful"
}

# Unpacks an archive
__luaver_unpack() {
	__luaver_print "Unpacking ${1}"
	if __luaver_exists "tar"; then
		__luaver_exec_command tar -xvzf "${1}"
	else
		__luaver_error "'tar' must be installed"
	fi
	__luaver_print "Unpack successful"
}

# Downloads and unpacks an archive
__luaver_download_and_unpack() {
	local unpack_dir_name="$1"
	local archive_name="$2"
	local url="$3"
	__luaver_print "Detecting already downloaded archives"
	# Checking if archive already downloaded or not
	if [ -e $unpack_dir_name ]; then
		read -r -p "${unpack_dir_name} has already been downloaded. Download again? [Y/n]: " choice
		case "$choice" in
			([yY][eE][sS]|[yY])
				__luaver_exec_command rm -r -- "${unpack_dir_name}"
			;;
		esac
	fi
	# Downloading the archive only if it does not exist"
	if [ ! -e $unpack_dir_name ]; then
		__luaver_print "Downloading ${unpack_dir_name}"
		__luaver_download $url
		__luaver_print "Extracting archive"
		__luaver_unpack $archive_name
		__luaver_exec_command rm -- "${archive_name}"
	fi
}

# Uninstalls lua/luarocks
__luaver_x_uninstall() {
	local package_name="$1"
	local package_path="$2"
	local package_dir="$3"
	__luaver_print "Uninstalling ${package_name}"
	__luaver_exec_command cd -- "${package_path}"
	if [ ! -e "${package_dir}" ]; then
		__luaver_error "${package_name} is not installed"
	fi
	__luaver_exec_command rm -r -- "${package_dir}"
	__luaver_print "Successfully uninstalled ${package_name}"
}

# Returns the platform
__luaver_get_platform() {
	local platform_str="$(uname | tr "[:upper:]" "[:lower:]")"
	local platforms=("aix" "bsd" "c89" "freebsd" "generic" "linux" "macosx" "mingw" "posix" "solaris")
	__luaver_print "Detecting platform"
	if [[ "${platform_str}" =~ "darwin" ]]; then
		__luaver_print "Platform detected: macosx"
		eval "$1='macosx'"
		return
	fi
	for platform in "${platforms[@]}"; do
		if [[ "${platform_str}" =~ "${platform}" ]]; then
			__luaver_print "Platform detected: ${platform}"
			eval "$1='$platform'"
			return
		fi
	done
	# Default platform
	__luaver_print "Unable to detect platform. Using default 'linux'"
	eval "$1='linux'"
}

__luaver_html_to_filenames() {
	local patt="$1";shift;
	local patt2="$1";shift;
	grep -i -o -- "$patt" | grep -o "$patt2" | sed 's,^[^"]*"\([^"]*\)".*$,\1,g' \
	| while read -r line; do
		line="${line##*/}" # LuaJIT-#.#.*.EXT || lua-#.#.*.EXT
		case "${line%%-*}" in
			(luajit|LuaJIT) ;;
			(lua) ;;
			(*)
				echo >&2 "__luaver_html_to_filenames: continue after ${line%%-*}"
				continue ;;
		esac
		line="${line#*-}"
		case "$line" in
			(*'.tar.gz')	line="${line%.tar.gz}";;
#			(*'.zip')	line="${line%.zip}";;
			*) continue
		esac
		printf '%s\n' "$line"
	done | sort -u | sort -g
}

__luaver_usage() {
	__luaver_print_formatted "Usage:"
	__luaver_print_formatted "   luaver help                                 Displays this message"
	__luaver_print_formatted "   luaver version                              Displays luaver version"
	__luaver_print_formatted ""
	__luaver_print_formatted "   luaver install       <product>=<version>    Installs <product>-<version>"
	__luaver_print_formatted "   luaver use           <product>=<version>    Switches to <product>-<version>"
#	__luaver_print_formatted "   luaver set-default   <product>=<version>    Sets <version> as default for <product>"
#	__luaver_print_formatted "   luaver unset-default <product>              Unsets the default <product> version"
	__luaver_print_formatted "   luaver uninstall     <product>=<version>    Uninstalls <name>-<version>"
	__luaver_print_formatted "   luaver list          <product>              Lists installed product versions"
	__luaver_print_formatted "   luaver available     <product>              Lists available product versions"
	__luaver_print_formatted ""
	__luaver_print_formatted "   luaver current|list                         Lists present versions being used"
	__luaver_print_formatted ""
	__luaver_print_formatted "Examples:"
	__luaver_print_formatted "   luaver install lua=5.3.1                 # Installs lua version 5.3.1"
	__luaver_print_formatted "   luaver install lua=5.3.0                 # Installs lua version 5.3.0"
	__luaver_print_formatted "   luaver use     lua=5.3.1                 # Switches to lua version 5.3.1"
	__luaver_print_formatted "   luaver install luarocks=2.3.0            # Installs luarocks version 2.3.0"
	__luaver_print_formatted "   luaver uninstall lua=5.3.0               # Uninstalls lua version 5.3.0"
}

__luaver_current() {
	__luaver_get_current_lua_version lua_version
	__luaver_get_current_luajit_version luajit_version
	__luaver_get_current_luarocks_version luarocks_version
	__luaver_print "Current versions:"
	if [ -n "${lua_version}" ]; then
		__luaver_print "lua-${lua_version}"
	fi
	if [ -n "${luajit_version}" ]; then
		__luaver_print "luajit-${luajit_version}"
	fi
	if [ -n "${luarocks_version}" ]; then
		__luaver_print "luarocks-${luarocks_version}"
	fi
}

__luaver_version() {
	__luaver_print_formatted "Lua Version Manager ${__luaver_VERSION}"
	__luaver_print_formatted "Developed by Dhaval Kapil <me@dhavalkapil.com>"
	__luaver_print_formatted "          by TsT          <tst2005@gmail.com>"
}

luaver() {
	__luaver_present_dir="$(pwd)"
	local cmd="$1";shift;
	case "$cmd" in
		("help") __luaver_usage; return 0 ;;
		("list")
			if [ $# -eq 0 ]; then
				__luaver_current
				return $?
			fi
		;;
	esac
	case "$cmd" in
		(a|av|ava|avai|avail|availa|availab|availabl|available) cmd=available ;;
		#current
		(i|in|ins|inst|insta|instal|install) cmd=install ;;
		(l|li|lis|list) cmd=list ;;
		#set-default
		#unset-default
		#uninstall
		(us|use) cmd=use ;;
		#version
	esac
	case "$cmd" in
#		("install"|use|set-default|unset-default|uninstall|list|available)
		(use|set-default|unset-default) echo >&2 "feature removed"; return 1;;
		('install'|'uninstall'|list|available)
			local productversion="$1";shift;
			local product=''
			local version=''
			case "$productversion" in
				(?*'='?*)
					product="${productversion%%=*}"
					version="${productversion#*=}"
				;;
				(?*'-'?*'.'?*)
					product="${productversion%%-*}"
					version="${productversion#*-}"
				;;
				(*)
					product="${productversion}"
					version=''
				;;
			esac
#			case "$cmd" in
#				("set-default")		cmd="set_default"	;;
#				("unset-default")	cmd="unset_default"	;;
#			esac
			"__luaver_${cmd}" "${product}" "$version" "$@"
		;;
		("current")			__luaver_current			;;
		("version")			__luaver_version			;;
		("getbin")			__luaver_getbin "$@"; return $?		;;
		("getdir")			__luaver_getdir inst "$@"; return $?	;;
		(*)				__luaver_usage; return 1		;;
	esac
	__luaver_exec_command cd -- "${__luaver_present_dir}"
}

# Init environment
__luaver_init

# keep only the filename (/path/to/file.name => file.name)
case "${0##*/}" in
	('luaver'|'luaver'.*) luaver "$@" ;;
esac
