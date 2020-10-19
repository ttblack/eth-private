bebn='{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}'
bwcv='{"jsonrpc":"2.0","method":"web3_clientVersion","params":[],"id":67}'
# curl -X POST --data $BODY http://127.0.0.1:20636 > rpc_result_geth.json
#ROUND=1000
INTERVAL=0.01
IP_LOCAL=localhost
IP_NTN23="3.94.68.38"
# IP=$IP_LOCAL
IP="127.0.0.1"
touch rpc_result_geth.txt
echo "========== script start ========== " > rpc_result_geth.txt
for i in {1..1000}
do
  # addr="$(openssl rand -hex 32)"
  addr="fb9c6044f291cb40bedc074209b26667ebc3e71b326eb2d6a042e2a3871e53c1"
  bpirk='{"jsonrpc":"2.0","method":"personal_importRawKey","params":["'${addr}'","111"],"id":'${i}'}'
  B=$bpirk
  echo $B

  curl \
    -X POST\
    -H "Content-Type: application/json"\
    --data $B\
    http://$IP_NTN23:20636

#    >> rpc_result_geth.txt
  # echo $BODY
  # cat rpc_result_geth.json | tail -n 1 | jq
  # cat rpc_result_geth.json | tail -n 1 | jq | pbcopy && echo "result copied to clipboard"

  # sleep $INTERVAL
  echo 'round '$i 'executed'
done