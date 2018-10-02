#!/bin/bash
#author: Aayush Jain

script_name=$(basename $0)
script_dir=$(dirname $0)

usage()
{
cat <<EOF
This scripts has some basic functions that can be used in day to day scripting tasks and can be sourced while writing a script. The usage comment followed by the function.
	Args: 
	-h	prints this help
	-D	[OPTIONAL] for debug mode -set vx
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

#set debug mode for script
debug_on()
{
	set -vx
	return 0
}

#set debug mode off
debug_off()
{
	set +vx
	return 0
}

#print the messgae provided in red prints function name and exits
die()
{
	tput setaf 1 2>/dev/null
	printf "$(date) [Error] - [${FUNCNAME[1]}] - [${BASH_SOURCE[2]}#${BASH_SOURCE[0]}] - $*"
	tput sgr0 2>/dev/null
	return 1
}

#print the messgae provided in red prints function name and continues
err()
{
        tput setaf 1 2>/dev/null
        printf "$(date) [Error] - [${FUNCNAME[1]}] - [${BASH_SOURCE[2]}#${BASH_SOURCE[0]}] - $*"
        tput sgr0 2>/dev/null
        return 0
}

#print the messgae provided in green for highlighting and continues
info()
{
        tput setaf 2 2>/dev/null
        printf "$(date) [Info] - [${FUNCNAME[1]}] - $*"
        tput sgr0 2>/dev/null
        return 0
}

#print the warning messgae provided in yellow prints function name and continues
warn()
{
        tput setaf 3 2>/dev/null
        printf "$(date) [Warn] - [${FUNCNAME[1]}] - $*"
        tput sgr0 2>/dev/null
        return 0
}

#convert a input string to uppercase
uppercase()
{
	echo $* | tr '[:lower:]' '[:upper:]'
}

#convert a input string to lower case
lowercase()
{
	echo $* | tr '[:upper:]' '[:lower:]'
}

#chceks if a directory is empty
is_dir_empty()
{
	local dir="$1"
	if  [[ $(ls -a $dir | wc -l ) > 0 ]];then
		return 0
	else
		return 1
	fi
}

#checks if a variabke has any value
is_variable_set()
{
	local variables="$*"
	for variable in variables; do
		[[ ${!variable} ]] || {die "$variable is empty" ; return $? ; }
	done
	return 0
}

#create temproary files to work with
create_tmp_file()
{
	local tmp_file=$(mktemp -u)
	cat /dev/null > $tmp_file
	echo "$tmp_file"
}

#cleans all files and directories
clean()
{
	[[ $# -ge 1 ]] && rm -rf "$*" && info "removed $*" || err "cannot remove $*"
}

#checks if a file is binary
is_binary_file()
{
	local file=$1
	files_to_check "$input"
	[[ $(file $file | grep -v text | wc -l) -gt o ]] && return 0 || return 1
}

#Copies a pdf version of input file
textfile2pdf()
{
	local input="$1"
	local output="$2"
	local title="$3"
	files_to_check "$input" "$output"
	is_binary_file "$input" && {die "$input is binary file" ; return $?; }
	is_variable_set $title || title=$(basename $input)
	enscript $input -t "$title" -o - | ps2pdf - $output
}

#checks if a csv/delmited(defaul is ,) separated file has equal number of columns for all rows, skips blank lines
delimited_column_count()
{
	local file="$1"
	local delimiter="$2"
	local delimited_line=$(grep -v "^#" ${file} | awk -F "${delimiter:-,}" '{print NF}' | grep -v 0 | sort -u | wc -l)
	if [[ $delimited_line = 1 ]];then
		return 0
	else
		err "The file provdied is either blank or is not properly formated (not all rows has same number of columns)"
		return 1
	fi
}

