#! /bin/bash
pkill -INT bootnode

ids=`ps -ef | grep bootnode| awk '{print $2}'`
for id in $ids
do
    echo "kill process bootnode id $id"
    kill -9 $id
done