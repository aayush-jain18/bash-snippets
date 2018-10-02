#!/bin/bash
#author: Aayush Jain
script_name=$(basename $0)
script_dir=$(dirname $0)
usage()
{
cat <<EOF
	Args: 
	-i	[REQUIRED] input csv to be coverted to pdf
	-o	[REQUIRED] can be a directory or a file
	-D	[OPTIONAL] for debug mode -set vx
	Example
	$0 -i input.csv -o outputdir/output.pdf
EOF
	exit 1
}
while [[ $# -ge 0 ]];do
	case $1 in 
		-h)					; usage ;;
		-d)	debugMode="on"				;;
		*)	echo "Unknown option $1 !" 	; usage ;;
	esac
	shift
done	
[[ $debugMode = "on" ]] && set -vx
############################# MAIN #############################
die(){
	tput setaf 1 2>/dev/null
	printf "$(date) [ERROR]"
	tput sgr0 2>/dev/null
	return 1
}
info(){}
warn(){}
uppercase(){}
lowercase(){}
is_dir_empty(){}
is_variable_set(){
	local variables=$*
	for variable in variables; do
		[[ ${!variable} ]] || {die "$variable is empty" ; return $? ; }
	done
	return 0
}
unset_variable(){}
create_tmp_file(){
	local tmp_file=$(mktemp -u)
	cat /dev/null > $tmp_file
	echo "$tmp_file"
}
#cleans all files and directories
clean(){
	[[ $# -ge 1 ]] && rm -rf "$*" && info "removed $*" || err "cannot remove $*"
}
start_time=$(date)

end_time=$(date)
