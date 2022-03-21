#!/bin/bash 
# clean up folders before git commiting 

for dir in *
do
	echo $dir
	test -d "$dir" || continue
	#The ( and ) create a subshell, so the current directory isn't changed in the main script
	( cd "$dir" && make clean )
done
