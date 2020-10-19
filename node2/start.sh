#! /bin/bash
account=""
bootnodev4url=""

if [ ! -d "./logs" ];then
mkdir ./logs
fi

while read line
do
    bootnodev4url=$line
    break
done < ../bootnodev4.txt

while read line
do
    account=$line
    break
done < ./account.txt
./geth --datadir "./data"  init "./ethconfig.json"

nohup ./geth --datadir "./data" \
      --lightserv 0 \
      --mine --miner.threads 1 \
      --rpc --rpcvhosts '*' --rpcaddr "127.0.0.1" --port 2113 --rpcport 3333 \
      --rpcapi "personal,db,eth,net,web3,txpool,miner,admin" \
      --allow-insecure-unlock \
      --unlock "0x$(cat ./data/keystore/UTC* | jq -r .address)" \
      --password "./pass.txt" \
      --bootnodes "$bootnodev4url"  \
      --black.contract.address "0x491bC043672B9286fA02FA7e0d6A3E5A0384A31A" \
      --pbft.net.address "127.0.0.1" --pbft.net.port 20022 \
      --syncmode  "full" \
       --pbft.keystore.password "./ethdpos.txt" \
      > ./logs/geth.log 2>&1 &