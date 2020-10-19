#!/bin/bash

#
# all
#
all_start()
{
    ela_start
    did_start
    token_start
    neo_start
    eth_start
    oracle_start
    arbiter_start
    dns_start
}

all_stop()
{
    ela_stop
    did_stop
    token_stop
    neo_stop
    eth_stop
    oracle_stop
    arbiter_stop
    dns_stop
}

all_deploy()
{
    ela_deploy
    did_deploy
    token_deploy
    neo_deploy
    eth_deploy
    arbiter_deploy
    dns_deploy
}

all_rollback()
{
    ela_rollback
    did_rollback
    token_rollback
    neo_rollback
    arbiter_rollback
}

all_status()
{
    ela_status
    did_status
    token_status
    neo_statue
    eth_status
    oracle_status
    arbiter_status
    dns_status
}

#
# ela
#
ela_start()
{
    if [ -f ~/.dns_ela.conf ]; then
        echo "ERROR: This is the DNS server"
        return
    elif [ ! -f $SCRIPT_PATH/ela/ela ]; then
        echo "ERROR: $SCRIPT_PATH/ela/ela is not exist"
        return
    fi
    echo "Starting ela..."
    cd $SCRIPT_PATH/ela
    if [ -f ~/.node.conf ]; then
        cat ~/.node.conf | nohup ./ela 1>/dev/null 2>output &
    else
        nohup ./ela 1>/dev/null 2>output &
    fi
    sleep 1
    ela_status
}

ela_stop()
{
    echo "Stopping ela..."
    while pgrep -x ela 1>/dev/null; do
        killall ela
        sleep 1
    done
    ela_status
}

ela_deploy()
{
    if [ ! -f $SCRIPT_PATH/ela/ela ]; then
        echo "ERROR: $SCRIPT_PATH/ela/ela is not exist"
        return
    fi
    echo "Deploy ela..."
    ela_stop
    cd $SCRIPT_PATH/ela
    cp ~/deploy/ela .
    cp ~/deploy/ela-cli .
    ela_start
}

ela_rollback()
{
    if [ ! -d $SCRIPT_PATH/ela/elastos/data_backup ]; then
        echo "ERROR: data_backup is not exist"
        return
    fi
    echo "Rollback ela..."
    ela_stop
    cd $SCRIPT_PATH/ela/elastos
    rm -r data && cp -r data_backup data
}

ela_status()
{
    local PID=$(pgrep -x ela)
    if [ "$PID" == "" ]; then
        echo "ela: Stopped"
        return
    fi

    local ELA_RPC_USER=$(cat $SCRIPT_PATH/ela/config.json | \
        jq '.Configuration.RpcConfiguration.User')
    local ELA_RPC_PASS=$(cat $SCRIPT_PATH/ela/config.json | \
        jq '.Configuration.RpcConfiguration.Pass')
    local ELA_CLI="$SCRIPT_PATH/ela/ela-cli --rpcport 21336 \
        --rpcuser $ELA_RPC_USER --rpcpassword $ELA_RPC_PASS"

    local ELA_RAM=$(pmap $PID | tail -1 | sed 's/.* //')
    local ELA_UPTIME=$(ps --pid $PID -oetime:1=)
    local ELA_NUM_TCPS=$(lsof -n -a -itcp -p $PID | wc -l)
    local ELA_NUM_FILES=$(lsof -n -p $PID | wc -l)

    local ELA_NUM_PEERS=$($ELA_CLI info getconnectioncount)
    if [[ ! "$ELA_NUM_PEERS" =~ ^[0-9]+$ ]]; then
        ELA_NUM_PEERS=0
    fi
    local ELA_HEIGHT=$($ELA_CLI info getcurrentheight)
    if [[ ! "$ELA_HEIGHT" =~ ^[0-9]+$ ]]; then
        ELA_HEIGHT=N/A
    fi

    echo "ela: Running"
    echo "  PID:    $PID"
    echo "  RAM:    $ELA_RAM"
    echo "  Uptime: $ELA_UPTIME"
    echo "  #TCP:   $ELA_NUM_TCPS"
    echo "  #Files: $ELA_NUM_FILES"
    echo "  #Peers: $ELA_NUM_PEERS"
    echo "  Height: $ELA_HEIGHT"
    echo
}

#
# did
#
did_start()
{
    if [ -f ~/.dns_did.conf ]; then
        echo "ERROR: This is the DNS server"
        return
    elif [ ! -f $SCRIPT_PATH/did/did ]; then
        echo "ERROR: $SCRIPT_PATH/did/did is not exist"
        return
    fi
    echo "Starting did..."
    cd $SCRIPT_PATH/did
    nohup ./did 1>/dev/null 2>output &
    sleep 1
    did_status
}

did_stop()
{
    echo "Stopping did..."
    while pgrep -x did 1>/dev/null; do
        killall did
        sleep 1
    done
    did_status
}

did_deploy()
{
    if [ ! -f $SCRIPT_PATH/did/did ]; then
        echo "ERROR: $SCRIPT_PATH/did/did is not exist"
        return
    fi
    echo "Deploy did..."
    did_stop
    cd $SCRIPT_PATH/did
    cp ~/deploy/did .
    did_start
}

did_rollback()
{
    if [ ! -d $SCRIPT_PATH/did/elastos_did/data_backup ]; then
        echo "ERROR: data_backup is not exist"
        return
    fi
    echo "Rollback did..."
    did_stop
    cd $SCRIPT_PATH/did/elastos_did
    rm -r data && cp -r data_backup data
}

did_status()
{
    local PID=$(pgrep -x did)
    if [ "$PID" == "" ]; then
        echo "did: Stopped"
        return
    fi

    local DID_RPC_USER=$(cat $SCRIPT_PATH/did/config.json | \
        jq '.Configuration.RpcConfiguration.User')
    local DID_RPC_PASS=$(cat $SCRIPT_PATH/did/config.json | \
        jq '.Configuration.RpcConfiguration.Pass')
    local DID_CLI="$SCRIPT_PATH/ela/ela-cli --rpcport 21606 \
        --rpcuser $DID_RPC_USER --rpcpassword $DID_RPC_PASS"

    local DID_RAM=$(pmap $PID | tail -1 | sed 's/.* //')
    local DID_UPTIME=$(ps --pid $PID -oetime:1=)
    local DID_NUM_TCPS=$(lsof -n -a -itcp -p $PID | wc -l)
    local DID_NUM_FILES=$(lsof -n -p $PID | wc -l)

    local DID_NUM_PEERS=$($DID_CLI info getconnectioncount)
    if [[ ! "$DID_NUM_PEERS" =~ ^[0-9]+$ ]]; then
        DID_NUM_PEERS=0
    fi
    local DID_HEIGHT=$($DID_CLI info getcurrentheight)
    if [[ ! "$DID_HEIGHT" =~ ^[0-9]+$ ]]; then
        DID_HEIGHT=N/A
    fi

    echo "did: Running"
    echo "  PID:    $PID"
    echo "  RAM:    $DID_RAM"
    echo "  Uptime: $DID_UPTIME"
    echo "  #TCP:   $DID_NUM_TCPS"
    echo "  #Files: $DID_NUM_FILES"
    echo "  #Peers: $DID_NUM_PEERS"
    echo "  Height: $DID_HEIGHT"
    echo
}

#
# token
#
token_start()
{
    if [ -f ~/.dns_token.conf ]; then
        echo "ERROR: This is the DNS server"
        return
    elif [ ! -f $SCRIPT_PATH/token/token ]; then
        echo "ERROR: $SCRIPT_PATH/token/token is not exist"
        return
    fi
    echo "Starting token..."
    cd $SCRIPT_PATH/token
    nohup ./token 1>/dev/null 2>output &
    sleep 1
    token_status
}

token_stop()
{
    echo "Stopping token..."
    while pgrep -x token 1>/dev/null; do
        killall token
        sleep 1
    done
    token_status
}

token_deploy()
{
    if [ ! -f $SCRIPT_PATH/token/token ]; then
        echo "ERROR: $SCRIPT_PATH/token/token is not exist"
        return
    fi
    echo "Deploy token..."
    token_stop
    cd $SCRIPT_PATH/token
    cp ~/deploy/token .
    token_start
}

token_rollback()
{
    if [ ! -d $SCRIPT_PATH/token/elastos_token/data_backup ]; then
        echo "ERROR: data_backup is not exist"
        return
    fi
    echo "Rollback token..."
    token_stop
    cd $SCRIPT_PATH/token/elastos_token
    rm -r data && cp -r data_backup data
}

token_status()
{
    local PID=$(pgrep -x token)
    if [ "$PID" == "" ]; then
        echo "token: Stopped"
        return
    fi

    local TOKEN_RPC_USER=$(cat $SCRIPT_PATH/token/config.json | \
        jq '.Configuration.RpcConfiguration.User')
    local TOKEN_RPC_PASS=$(cat $SCRIPT_PATH/token/config.json | \
        jq '.Configuration.RpcConfiguration.Pass')
    local TOKEN_CLI="$SCRIPT_PATH/ela/ela-cli --rpcport 21616 \
        --rpcuser $TOKEN_RPC_USER --rpcpassword $TOKEN_RPC_PASS"

    local TOKEN_RAM=$(pmap $PID | tail -1 | sed 's/.* //')
    local TOKEN_UPTIME=$(ps --pid $PID -oetime:1=)
    local TOKEN_NUM_TCPS=$(lsof -n -a -itcp -p $PID | wc -l)
    local TOKEN_NUM_FILES=$(lsof -n -p $PID | wc -l)

    local TOKEN_NUM_PEERS=$($TOKEN_CLI info getconnectioncount)
    if [[ ! "$TOKEN_NUM_PEERS" =~ ^[0-9]+$ ]]; then
        TOKEN_NUM_PEERS=0
    fi
    local TOKEN_HEIGHT=$($TOKEN_CLI info getcurrentheight)
    if [[ ! "$TOKEN_HEIGHT" =~ ^[0-9]+$ ]]; then
        TOKEN_HEIGHT=N/A
    fi

    echo "token: Running"
    echo "  PID:    $PID"
    echo "  RAM:    $TOKEN_RAM"
    echo "  Uptime: $TOKEN_UPTIME"
    echo "  #TCP:   $TOKEN_NUM_TCPS"
    echo "  #Files: $TOKEN_NUM_FILES"
    echo "  #Peers: $TOKEN_NUM_PEERS"
    echo "  Height: $TOKEN_HEIGHT"
    echo
}

#
# neo
#
neo_start()
{
    if [ -f ~/.dns_neo.conf ]; then
        echo "ERROR: This is the DNS server"
        return
    elif [ ! -f $SCRIPT_PATH/neo/neo ]; then
        echo "ERROR: $SCRIPT_PATH/neo/neo is not exist"
        return
    fi
    echo "Starting neo..."
    cd $SCRIPT_PATH/neo
    nohup ./neo 1>/dev/null 2>output &
    sleep 1
    neo_status
}

neo_stop()
{
    echo "Stopping neo..."
    while pgrep -x neo 1>/dev/null; do
        killall neo
        sleep 1
    done
    neo_status
}

neo_deploy()
{
    if [ ! -f $SCRIPT_PATH/neo/neo ]; then
        echo "ERROR: $SCRIPT_PATH/neo/neo is not exist"
        return
    fi
    echo "Deploy neo..."
    neo_stop
    cd $SCRIPT_PATH/neo
    cp ~/deploy/neo .
    neo_start
}

neo_rollback()
{
    if [ ! -d $SCRIPT_PATH/neo/elastos_neo/data_backup ]; then
        echo "ERROR: data_backup is not exist"
        return
    fi
    echo "Rollback neo..."
    neo_stop
    cd $SCRIPT_PATH/neo/elastos_neo
    rm -r data && cp -r data_backup data
}

neo_status()
{
    local PID=$(pgrep -x neo)
    if [ "$PID" == "" ]; then
        echo "neo: Stopped"
        return
    fi

    local NEO_RPC_USER=$(cat $SCRIPT_PATH/neo/config.json | \
        jq '.Configuration.RpcConfiguration.User')
    local NEO_RPC_PASS=$(cat $SCRIPT_PATH/neo/config.json | \
        jq '.Configuration.RpcConfiguration.Pass')
    local NEO_CLI="$SCRIPT_PATH/ela/ela-cli --rpcport 21626 \
        --rpcuser $NEO_RPC_USER --rpcpassword $NEO_RPC_PASS"

    local NEO_RAM=$(pmap $PID | tail -1 | sed 's/.* //')
    local NEO_UPTIME=$(ps --pid $PID -oetime:1=)
    local NEO_NUM_TCPS=$(lsof -n -a -itcp -p $PID | wc -l)
    local NEO_NUM_FILES=$(lsof -n -p $PID | wc -l)

    local NEO_NUM_PEERS=$($NEO_CLI info getconnectioncount)
    if [[ ! "$NEO_NUM_PEERS" =~ ^[0-9]+$ ]]; then
        NEO_NUM_PEERS=0
    fi
    local NEO_HEIGHT=$($NEO_CLI info getcurrentheight)
    if [[ ! "$NEO_HEIGHT" =~ ^[0-9]+$ ]]; then
        NEO_HEIGHT=N/A
    fi

    echo "neo: Running"
    echo "  PID:    $PID"
    echo "  RAM:    $NEO_RAM"
    echo "  Uptime: $NEO_UPTIME"
    echo "  #TCP:   $NEO_NUM_TCPS"
    echo "  #Files: $NEO_NUM_FILES"
    echo "  #Peers: $NEO_NUM_PEERS"
    echo "  Height: $NEO_HEIGHT"
    echo
}

#
# arbiter
#
arbiter_start()
{
    if [ ! -f $SCRIPT_PATH/arbiter/arbiter ]; then
        echo "ERROR: $SCRIPT_PATH/arbiter/arbiter is not exist"
        return
    fi

    echo "Starting arbiter..."
    cd $SCRIPT_PATH/arbiter

    until pgrep -x arbiter 1>/dev/null; do
        if [ -f ~/.node.conf ]; then
            cat ~/.node.conf | nohup ./arbiter 1>/dev/null 2>output &
        else
            nohup ./arbiter 1>/dev/null 2>output &
        fi
        echo "Waiting ela, did, token..."
        sleep 5
    done

    arbiter_status
}

arbiter_stop()
{
    echo "Stopping arbiter..."
    while pgrep -x arbiter 1>/dev/null; do
        killall arbiter
        sleep 1
    done
    arbiter_status
}

arbiter_deploy()
{
    if [ ! -f $SCRIPT_PATH/arbiter/arbiter ]; then
        echo "ERROR: $SCRIPT_PATH/arbiter/arbiter is not exist"
        return
    fi
    echo "Deploy arbiter..."
    arbiter_stop
    cd $SCRIPT_PATH/arbiter
    cp ~/deploy/arbiter .
    arbiter_start
}

arbiter_rollback()
{
    if [ ! -d $SCRIPT_PATH/arbiter/elastos_arbiter/data_backup ]; then
        echo "ERROR: data_backup is not exist"
        return
    fi
    echo "Rollback arbiter..."
    arbiter_stop
    cd $SCRIPT_PATH/arbiter/elastos_arbiter
    rm -r data && cp -r data_backup data
}

arbiter_status()
{
    local PID=$(pgrep -x arbiter)
    if [ $PID ]; then
        echo "arbiter: Running, $PID"
    else
        echo "arbiter: Stopped"
    fi
}

#
# dns
#
dns_start()
{
    if [ -f ~/.dns_ela.conf ]; then
        echo "Starting dns_ela"
        local par=$(cat ~/.dns_ela.conf)
        cd $SCRIPT_PATH/dns_ela
        nohup ./ela-dns ${par} -debug > /dev/null 2>output &
    fi
    if [ -f ~/.dns_did.conf ]; then
        echo "Starting dns_did"
        local par=$(cat ~/.dns_did.conf)
        cd $SCRIPT_PATH/dns_did
        nohup ./ela-dns ${par} -debug > /dev/null 2>output &
    fi
    if [ -f ~/.dns_token.conf ]; then
        echo "Starting dns_token"
        local par=$(cat ~/.dns_token.conf)
        cd $SCRIPT_PATH/dns_token
        nohup ./ela-dns ${par} -debug > /dev/null 2>output &
    fi
    if [ -f ~/.dns_neo.conf ]; then
        echo "Starting dns_neo"
        local par=$(cat ~/.dns_neo.conf)
        cd $SCRIPT_PATH/dns_neo
        nohup ./ela-dns ${par} -debug > /dev/null 2>output &
    fi
    sleep 1
    dns_status
}

dns_stop()
{
    if [ -f ~/.dns_ela.conf ] || [ -f ~/.dns_did.conf ] || [ -f ~/.dns_token.conf ]; then
        echo "Stopping ela-dns..."
        while pgrep -x ela-dns 1>/dev/null; do
            killall ela-dns
            sleep 1
        done
        dns_status
    fi
}

dns_deploy()
{
    if [ -d $SCRIPT_PATH/dns_ela ] || [ -d $SCRIPT_PATH/dns_did ] || [ -d $SCRIPT_PATH/dns_token ]; then
        echo "Deploy dns..."
        dns_stop
        if [ -f ~/.dns_ela.conf ]; then
            cd $SCRIPT_PATH/dns_ela
            cp ~/deploy/ela-dns .
        fi
        if [ -f ~/.dns_did.conf ]; then
            cd $SCRIPT_PATH/dns_did
            cp ~/deploy/ela-dns .
        fi
        if [ -f ~/.dns_token.conf ]; then
            cd $SCRIPT_PATH/dns_token
            cp ~/deploy/ela-dns .
        fi
        if [ -f ~/.dns_neo.conf ]; then
            cd $SCRIPT_PATH/dns_neo
            cp ~/deploy/ela-dns .
        fi
        dns_start
    else
        echo "ERROR: $SCRIPT_PATH/dns is not exist"
        return
    fi
}

dns_status()
{
    local PID=$(pgrep -x ela-dns)
    if [ "$PID" == "" ]; then
        echo "ela-dns: Stopped"
        return
    fi

    echo "dns: Running"
    echo "  PID:    $PID"
    echo
}

usage()
{
    echo "Usage: $(basename $BASH_SOURCE) CHAIN COMMAND"
    echo "ELA Management ($SCRIPT_PATH)"
    echo
    echo "Avaliable Chain"
    echo
    echo "  all"
    echo "  ela"
    echo "  did"
    echo "  token"
    echo "  neo"
    echo "  eth"
    echo "  oracle"
    echo "  arbiter"
    echo "  dns"
    echo
    echo "Avaliable Commands:"
    echo
    echo "  start"
    echo "  stop"
    echo "  deploy"
    echo "  rollback"
    echo "  status"
    echo
}

#
# eth
#
eth_start()
{
   if [ ! -f $SCRIPT_PATH/eth/geth ]; then
        echo "ERROR: $SCRIPT_PATH/eth/geth is not exist"
        return
    fi

    echo "Starting eth..."
    cd $SCRIPT_PATH/eth
    mkdir -p $SCRIPT_PATH/eth/logs/

    if [ -f ~/.config/elastos/eth.txt ]; then
        nohup ./geth --datadir $SCRIPT_PATH/eth/data \
            --testnet \
            --mine --miner.threads 1 \
            --rpc --rpcvhosts '*' --rpcaddr "0.0.0.0" \
            --rpcapi "personal,db,eth,net,web3,txpool,miner" \
            --unlock "0x$(cat $SCRIPT_PATH/eth/data/keystore/UTC* | jq -r .address)" \
            --password ~/.config/elastos/eth.txt \
            >>$SCRIPT_PATH/eth/logs/geth.log 2>&1 &
    else
        nohup ./geth --datadir $SCRIPT_PATH/eth/data \
            --testnet \
            --rpc --rpcvhosts '*' --rpcaddr "0.0.0.0" \
            --rpcapi "eth,web3,admin,txpool" \
            >>$SCRIPT_PATH/eth/logs/geth.log 2>&1 &
    fi

    sleep 1
    eth_status
}

eth_stop()
{
    echo "Stopping eth..."
    while pgrep -x geth 1>/dev/null; do
        killall geth
        sleep 1
    done
    eth_status
}

eth_status()
{
    local PID=$(pgrep -x geth)
    if [ "$PID" == "" ]; then
        echo "eth: Stopped"
        return
    fi

    local ETH_CLI=

    local ETH_RAM=$(pmap $PID | tail -1 | sed 's/.* //')
    local ETH_UPTIME=$(ps --pid $PID -oetime:1=)
    local ETH_NUM_TCPS=$(lsof -n -a -itcp -p $PID | wc -l)
    local ETH_NUM_FILES=$(lsof -n -p $PID | wc -l)

    local ETH_NUM_PEERS=
    if [[ ! "$ETH_NUM_PEERS" =~ ^[0-9]+$ ]]; then
        ETH_NUM_PEERS=0
    fi
    local ETH_HEIGHT=
    if [[ ! "$ETH_HEIGHT" =~ ^[0-9]+$ ]]; then
        ETH_HEIGHT=N/A
    fi

    echo "eth: Running"
    echo "  PID:    $PID"
    echo "  RAM:    $ETH_RAM"
    echo "  Uptime: $ETH_UPTIME"
    echo "  #TCP:   $ETH_NUM_TCPS"
    echo "  #Files: $ETH_NUM_FILES"
    echo "  #Peers: $ETH_NUM_PEERS"
    echo "  Height: $ETH_HEIGHT"
    echo
}

eth_deploy()
{
    if [ ! -f $SCRIPT_PATH/eth/geth ]; then
        echo "ERROR: $SCRIPT_PATH/eth/geth is not exist"
        return
    fi
    echo "Deploy eth..."
    eth_stop
    cd $SCRIPT_PATH/eth
    cp ~/deploy/geth .
    eth_start
}


#
# oracle
#
oracle_start()
{
    # TODO: check nodejs and pm
    export PATH=~/node/eth/node-v10.13.0-linux-x64/bin:$PATH
    export PATH=~/node/eth/node_modules/pm2/bin:$PATH

    if [ ! -f $SCRIPT_PATH/eth/oracle/crosschain_oracle.js ]; then
        echo "ERROR: $SCRIPT_PATH/eth/oracle/crosschain_oracle.js is not exist"
        return
    fi

    cd $SCRIPT_PATH/eth
    mkdir -p $SCRIPT_PATH/eth/logs

    export env=testnet

    pm2 start $SCRIPT_PATH/eth/oracle/crosschain_oracle.js -i 1 \
        -e $SCRIPT_PATH/eth/logs/oracle_err.log \
        -o $SCRIPT_PATH/eth/logs/oracle_out.log
}

oracle_stop()
{
    export PATH=~/node/eth/node-v10.13.0-linux-x64/bin:$PATH
    export PATH=~/node/eth/node_modules/pm2/bin:$PATH

    if [ ! -f $SCRIPT_PATH/eth/oracle/crosschain_oracle.js ]; then
        echo "ERROR: $SCRIPT_PATH/eth/oracle/crosschain_oracle.js is not exist"
        return
    fi

    cd $SCRIPT_PATH/eth
    mkdir -p $SCRIPT_PATH/eth/logs

    pm2 stop $SCRIPT_PATH/eth/oracle/crosschain_oracle.js
}

oracle_status()
{
    export PATH=~/node/eth/node-v10.13.0-linux-x64/bin:$PATH
    export PATH=~/node/eth/node_modules/pm2/bin:$PATH

    if [ ! -f $SCRIPT_PATH/eth/oracle/crosschain_oracle.js ]; then
        echo "ERROR: $SCRIPT_PATH/eth/oracle/crosschain_oracle.js is not exist"
        return
    fi

    cd $SCRIPT_PATH/eth
    mkdir -p $SCRIPT_PATH/eth/logs

    pm2 status $SCRIPT_PATH/eth/oracle/crosschain_oracle.js
}

#
# Main
#
SCRIPT_PATH=$(cd $(dirname $BASH_SOURCE); pwd)

if [ "$1" == "" ]; then
    usage
    exit
fi

if [ "$1" != "all" -a \
     "$1" != "ela" -a \
     "$1" != "did" -a \
     "$1" != "token" -a \
     "$1" != "neo" -a \
     "$1" != "eth" -a \
     "$1" != "oracle" -a \
     "$1" != "arbiter" -a \
     "$1" != "dns" ]; then
    echo "ERROR: do not support chain: $1"
    exit
fi

if [ "$2" != "start" -a \
     "$2" != "stop" -a \
     "$2" != "deploy" -a \
     "$2" != "rollback" -a \
     "$2" != "status" ]; then
    echo "ERROR: do not support command: $2"
    exit
fi

$1_$2