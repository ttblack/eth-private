"use strict";
var Decimal = require('decimal.js');

const common = require("./common");

let a = 0x000000000000000000000000000000000000000000000046791fc84e07d00000
let b = 1299999900000000000000
let fee = 100000000000000

console.log("a:", BigInt(a))
console.log("b:", b)


//  let crosschainamount = String(common.retnum(a / 1e18));
//  let outputamount = (b / 1e18);

// console.log("crosschainamount:", crosschainamount)
// console.log("outputamount:", outputamount)

let outputamount22 = (common.retnum(b / 1e18));

console.log("outputamount22:", outputamount22)


let c1 = new Decimal(a).sub(new Decimal(fee))

console.log("c1:",  c1)

let c2 = a - fee

console.log("c2:",  c2)

let c3 = c1.div(1e18).toFixed(8)

console.log("c3:",  c3)

let c4 = c1.div(1e18).toPrecision(8)        

console.log("c4:",  c4)

// let v = Number(outputamount22) + fee/1e18
// console.log("v:", v)

// let aa = BigInt(a)
// let bb = BigInt(b)

// let precision = 1000000000000000000n

//  crosschainamount = aa / precision;
//   outputamount = bb / precision;

//  let c = outputamount * precision

//  console.log("crosschainamount:", crosschainamount)
// console.log("outputamount:", outputamount)


// console.log("bb:", String(bb))
// console.log("c:", String(c))

// console.log("c:", c == b)
// console.log("c:", String(c) == String(bb))


 // let crosschainamount = String(common.retnum(log["returnValues"]["_crosschainamount"] / 1e18));
 //                    let outputamount = String(log["returnValues"]["_amount"] / 1e18);


