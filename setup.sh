last_arg=$_
if [[ "$(basename $last_arg)" != "setup.sh" ]] ; then
	last_arg=$BASH_SOURCE
fi

if [[ "$(basename $last_arg)" != "setup.sh" ]] ; then
	if [[ -z $NOTES_PATH ]] ; then
		echo 'Please set $NOTES_PATH'
	fi
else
	NOTES_PATH="$(dirname $last_arg)"
fi
unset last_arg

echo "NOTES_PATH=${NOTES_PATH}"
function notes(){
	local var1=$1
	local var2=$2
	local timecode="${var1:-now}"
	pushd ~/workspace/notes
	if [[ "$timecode" == 'ls' ]] ; then
		$@
	elif [[ "$timecode" == 'grep' ]] ; then
		$@ *
	elif [[ "$timecode" == 'git' ]] ; then
		$@
	elif [[ "$timecode" == 'vim' ]] ; then
		$@
	elif [[ "$timecode" == 'cat' ]] ; then
		$@
	elif [[ "$timecode" == 'active' ]] ; then
		if [[ -z "$var2" && -e active.md ]] ; then
			rm -f active.md
			git add .
			git commit -a -m "automated commit"
		elif [[ -n "$var2" && -e "$var2" ]] ; then
			ln -fs $var2 active.md
			git add .
			git commit -a -m "automated commit"
		elif [[ ( -n "$var2" ) && ( "$var2" == "rm" ) && ( -e "active.md" ) ]] ; then
			rm -f active.md
			git add .
			git commit -a -m "automated commit"
		else
			echo "active not set"
		fi
	elif [[ "$timecode" == 'append' ]] ; then
		cat >> `date --rfc-3339=date`.md
		git add .
		git commit -a -m 'automated commit'
	elif [[ "$timecode" == 'push' ]] ; then
		git push -u origin master
	elif [[ -e "$timecode" ]]; then
		$EDITOR "${timecode}"
		git add .
		git commit -a -m 'automated commit'
	elif [[ ( -z "$var1" ) && ( -e active.md ) ]] ; then
		$EDITOR active.md
		git add .
		git commit -a -m "automated commit"
	else
		$EDITOR `date -d "${timecode}" --rfc-3339=date`.md
		git add .
		git commit -a -m 'automated commit'
	fi
	popd
}
