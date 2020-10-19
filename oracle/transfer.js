"use strict";

const Web3 = require("web3");
const web3 = new Web3("http://127.0.0.1:1111");
const ks = require("./ks");
const acc = web3.eth.accounts.decrypt(ks.kstore, ks.kpass);
console.log("===>", acc.address);
const tx = {data: data, gas: "2000000", gasPrice: "2000000000"};
acc.signTransaction(tx).then((stx) => {
    web3.eth.sendSignedTransaction(stx.rawTransaction).on("transactionHash", console.log)
        .then(console.log)
        .catch(console.log);
}).catch(console.log);
