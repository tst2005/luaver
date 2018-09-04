__luaver_available_luarocks() {
	local url="http://luarocks.github.io/luarocks/releases/"
        local htmlfilename="index_luarocks.html"
	__luaver_exec_command cd -- "${__luaver_SRC_DIR}"
	if [ ! -f "$htmlfilename" ]; then
		__luaver_download "$url" "$htmlfilename"
#	else
#		__luaver_print "index already downloaded"
	fi
	if [ ! -f "$htmlfilename" ]; then
		__luaver_error "Index not found (No such $htmlfilename file)"
		return 1
	fi
	__luaver_print >&2 "Luarocks available :"
	local pattern='<a href="luarocks-[0-9][^"]*\.tar\.gz">'
	__luaver_html_to_filenames "$pattern" '"luarocks-[0-9].*\.tar\.gz"' < "$htmlfilename"
}
