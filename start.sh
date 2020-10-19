#! /bin/bash

path="/Users/apple/Desktop/pbftTest/"
for ((i=0; i<=5; i ++))
do
	dir="node"$i
	df=$path$dir
	cd $df
	 ./start.sh
	 sleep 1
done
