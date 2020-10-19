 #!  /bin/bash

while :
do

    curl -H 'Content-Type:application/json' -H 'Application/json' -X POST --data '{"jsonrpc":"2.0", "method":"discretemining", "params":{"count":"1"}}' http://127.0.0.1:10016
    sleep 3
done