 #! /bin/bash
from="/Users/apple/Documents/ElastosWork/src/github.com/elastos/Elastos.ELA.SideChain.ETH/build/bin/geth"
to="/Users/apple/Desktop/pbftTest/"
for ((i=0; i<=5; i ++))
do
	dir="node"$i
	df=$to$dir
	cp $from $df
	sleep 1
done
