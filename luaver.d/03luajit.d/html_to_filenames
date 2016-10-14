__luaver_html_to_filenames_luajit() {
	grep -o '<a href="download/[Ll]ua[Jj][Ii][Tt][^"]*">' | grep -o '".*"' | sed 's,^[^"]*"\([^"]*\)".*$,\1,g' | while read -r line; do
		line="${line#*download/}" # LuaJIT-#.#.*.EXT
		case "${line%%-*}" in
			(luajit|LuaJIT) ;;
			(*) continue ;;
		esac
		line="${line#*-}"
		case "$line" in
			(*'.tar.gz')	line="${line%.tar.gz}";;
			(*'.zip')	line="${line%.zip}";;
			*) continue
		esac
		printf '%s\n' "$line"
	done | sort -u | sort -g
}
