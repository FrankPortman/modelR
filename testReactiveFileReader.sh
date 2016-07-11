DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
while [ 1 ]; do
	exec 3>&1 4>&2
	 foo=$( { (TIMEFORMAT="%R"; time curl "http://localhost:8001/mean" 1>&3 2>&4) ; } 2>&1 )
     exec 3>&- 4>&-
	echo "$foo" >> "$DIR/logs/stdoutFile.txt"; sleep .2; done