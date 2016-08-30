# swift completion

have swift &&
_swift()
{


    COMPREPLY=()
    local cur prev cword words
    _get_comp_words_by_ref cur prev cword words

	local subcommands="build package test"
	local subcommand="$(__find_on_cmdline "$subcommands")"
	if [ -z "$subcommand" ]; then
		__gitcomp "$subcommands"
		return 0
	fi

	case "$subcommand" in
		package)
			__package
			return
			;;
		test)
			__test
			return
			;;
		build)
			__build
			return
			;;
	esac

} &&
# complete -F _swift swift
_swift_package() {

	COMPREPLY=()
    local cur prev cword words
    _get_comp_words_by_ref cur prev cword words
    __package

}
_swift_test() {

	COMPREPLY=()
    local cur prev cword words
    _get_comp_words_by_ref cur prev cword words
    __test

} &&
complete -F _swift swift &&
complete -F _swift_package swift-package &&
complete -F _swift_test swift-test 



__build() {

	local flags="-C --chdir --build-path --color  -v --verbose -Xcc -Xlinker -Xswiftc"
	local subcommands="-c --configuration --clean -C --chdir --build-path --color  -v --verbose -Xcc -Xlinker -Xswiftc"
	local subcommand="$(__find_on_cmdline "$subcommands")"
	if [ -z "$subcommand" ]; then
		__comp "$subcommands"
		return 0
	fi

	__build_options ${subcommands}

}

__build_options () {

	local subcommands="${@}"

	case "$prev" in
		-c|--configuration)
			__comp "debug release"
			return 0
			;;
		--clean) 
			__comp "build dist"
			return 0
			;;

		-C|--chdir|--build-path)
			_filedir -D
			return 
			;;
		--color)
			__comp "auto always never"
			return
			;;
		-X*)
			__xcode_options
			return
			;;
	esac
	__comp "$subcommands"
}

__test() {

	local subcommands="-s --specifier -l --list-tests -C --chdir --build-path --color -v --verbose --skip-build -Xcc -Xlinker -Xswiftc"
	local subcommand="$(__find_on_cmdline "$subcommands")"
	if [ -z "$subcommand" ]; then
		__comp "$subcommands"
		return 0
	fi

	__test_options ${subcommands}
	return 0

}

__test_options () {
	local subcommands="${@}"

	case "$prev" in
		-s|--specifier)
			return 0
			;;

		-C|--chdir|--build-path)
			_filedir -D
			return 
			;;
		--color)
			__comp "auto always never"
			return
			;;
		-X*)
			__xcode_options
			return
			;;
	esac
	__comp "$subcommands"
	
}


__package () {
	
#	local flags=`_parse_help swift-package`
	local flags="-C --chdir --color --enable-code-coverage -v --verbose -Xcc -Xlinker -Xswiftc"
	local subcommands="init fetch update generate-xcodeproj show-dependencies dump-package --version"
	local subcommand="$(__find_on_cmdline "$subcommands")"
	if [ -z "$subcommand" ]; then
		__comp "$subcommands"
		return 0
	fi

	case "$subcommand" in
		init)
			__package_init ${flags}
			return
			;;
		fetch|update)
			__package_fetch ${flags}
			return
			;;
		generate-xcodeproj) 
			__package_generate_xcode ${flags}
			return
			;;
		show-dependencies)
			__package_show_dependencies ${flags}
			return
			;;
		dump-package)
			__package_dump_package ${flags}
			return
			;;
		--version)
			return
			;;
	esac
}

__package_init () {
	
	local subcommands="--type ${@}" 
	local subcommand="$(__find_on_cmdline "$subcommands")"
	if [ -z "$subcommand" ]; then
		__comp "$subcommands"
		return 0
	fi

	case "$subcommand,$prev" in
		--type,--type)
			__comp "empty library executable system-module"
			return
			;;
		-*,*) 
			__package_options ${flags}
			return 
			;;
	esac

}

__package_fetch() {
	
	local subcommands="${@}"
	local subcommand="$(__find_on_cmdline "$subcommands")"
	if [ -z "$subcommand" ]; then
		__comp "$subcommands"
		return 0
	fi

	case "$subcommand" in
		--*|-X*) 
			__package_options ${flags}
			return 
			;;
	esac

}

__package_generate_xcode () {
	
	local subcommands="--output ${@}"
	local subcommand="$(__find_on_cmdline "$subcommands")"
	if [ -z "$subcommand" ]; then
		__comp "$subcommands"
		return 0
	fi

	case "$subcommand,$prev" in
		--output,--output)
			_filedir -d
			return
			;;
		-*) 
			__package_options ${flags}
			return 
			;;
	esac
}

__package_show_dependencies () {
	
	local subcommands="--format ${@}"
	local subcommand="$(__find_on_cmdline "$subcommands")"
	if [ -z "$subcommand" ]; then
		__comp "$subcommands"
		return 0
	fi

	case "$subcommand,$prev" in
		--format,--format)
			__comp "text dot json"
			return
			;;
		-*) 
			__package_options ${flags}
			return 
			;;
	esac
}

__package_dump_package () {
	
	local subcommands="--input ${@}"
	local subcommand="$(__find_on_cmdline "$subcommands")"
	if [ -z "$subcommand" ]; then
		__comp "$subcommands"
		return 0
	fi
	case "$subcommand,$prev" in
		--input,--input)
			_filedir -d
			return
			;;
		-*,*) 
			__package_options ${flags}
			return 
			;;
	esac
}

__package_options () {
	
	local subcommands="${@}"

	case "$prev" in
		-C|--chdir)
			_filedir -D
			return 
			;;
		--color)
			__comp "auto always never"
			return
			;;
		-X*)
			__xcode_options
			return
			;;
	esac
#	echo "SUBS $prev"
	__comp "$subcommands"
}


__xcode_options () {

	local subcommands="-Xcc -Xlinker -Xswiftc"
	local subcommand="$(__find_last_on_cmdline "$subcommands")"
	if [ -z "$subcommand" ]; then
		__comp "$subcommands"
		return 0
	fi

	case "$prev" in 
		-Xcc)
			return 0
			;;
	esac

	__comp "$subcommands"
}

__find_last_on_cmdline() {

	local word subcommand c=$cword
    while [ $c -gt 0 ]; do
    	word="${words[c]}"
        for subcommand in $1; do
        	if [ "$subcommand" = "$word" ]; then
            	echo "$subcommand"
                return
             fi
         done
         ((c--))
 	done
	
}

__find_on_cmdline () {
	local word subcommand c=1
    while [ $c -lt $cword ]; do
    	word="${words[c]}"
        for subcommand in $1; do
        	if [ "$subcommand" = "$word" ]; then
            	echo "$subcommand"
                return
             fi
         done
         ((c++))
 	done
}

__comp () {
	local cur_="${3-$cur}"

    case "$cur_" in
        --*=)
        	;;
        *)
            local c i=0 IFS=$' \t\n'
            for c in $1; do
            	c="$c${4-}"
                if [[ $c == "$cur_"* ]]; then
                	case $c in
                    	--*=*|*.) ;;
                        *) c="$c " ;;
                    esac
                    COMPREPLY[i++]="${2-}$c"
                fi
            done
            ;;
        esac
}




# Local variables:
# mode: shell-script
# sh-basic-offset: 4
# sh-indent-comment: t
# indent-tabs-mode: nil
# End:
# ex: ts=4 sw=4 et filetype=sh
