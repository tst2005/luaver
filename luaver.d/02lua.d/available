__luaver_available_lua() {
	local url="http://www.lua.org/ftp/"
        local htmlfilename="index_lua.html"
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
	__luaver_print "Lua available :"
	local pattern='<TD CLASS="name"><A HREF="lua-[0-9].*\.tar\.gz">.*</A></TD>'
	__luaver_html_to_filenames "$pattern" '"lua-[0-9].*.tar.gz"' < "$htmlfilename"
}
