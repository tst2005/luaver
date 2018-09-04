__luaver_available_luajit() {
	local url="http://luajit.org/download.html"
        local htmlfilename="index_luajit.html"
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
	__luaver_print "LuaJIT available :"
	__luaver_html_to_filenames '<a href="download/[Ll]ua[Jj][Ii][Tt][^"]*">' '".*"' < "$htmlfilename"
}
