require('dotenv').config()
const Web3 = require('web3');

const fs = require('fs');
let abi_rawdata = fs.readFileSync('./build/contracts/PaalBet.json');
let abi_json = JSON.parse(abi_rawdata).abi;
const scAddress = "0xa1F21EB9DD697380E87fbb7eafD299FcbfD85e09";

const run = async () => {
  try {
    var web3 = new Web3('https://arbitrum-one.publicnode.com');

    const prv_key = process.env.PRV_KEY;
    var alice = web3.eth.accounts.privateKeyToAccount(prv_key);
    await web3.eth.accounts.wallet.add(alice);
    var owner = alice.address;

    var gasPrice = await web3.eth.getGasPrice();
    console.log(owner, gasPrice)

    var scObj = new web3.eth.Contract(abi_json, scAddress);

    var ret = await scObj.methods.exerciseOptions(
      "0x373B453E0a6131DacD36278fD1199A5dB196D68F"
    // ).estimateGas({ from: owner });
    // ).encodeABI({ from: owner });
    // ).call({ from: owner });
    ).send({ from: owner, gas: "400000", gasPrice: "10000000" })
    console.log(ret);
  } catch (error) {
    console.log(error)
  }
}

run()
