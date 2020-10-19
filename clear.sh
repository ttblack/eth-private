#! /bin/bash


for ((i=0; i<=5; i ++))
do
	dir="node"$i"/data/"
	path="node"$i"/data/keystore"

	# rm -fr `ls $dir | grep -v keystore`
	rm -fr $dir"geth/"
	rm -fr $dir"spv_transaction_info.db/"
	rm -fr $dir"header/"
	rm -fr $dir"logs-spv/"
	rm -fr $dir"store/"
	rm -fr $dir"peers.json"
done

dir="syncNode/data/"

rm -fr $dir"geth/"
rm -fr $dir"spv_transaction_info.db/"
rm -fr $dir"header/"
rm -fr $dir"logs-spv/"
rm -fr $dir"store/"