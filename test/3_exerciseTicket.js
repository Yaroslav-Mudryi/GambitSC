require('dotenv').config()
const Web3 = require('web3');

const fs = require('fs');
let abi_rawdata = fs.readFileSync('./build/Gambitv2.json');
let abi_json = JSON.parse(abi_rawdata).abi;
const scAddress = "0x5A03BCD8ca4d78Fe37ac558795803C1B8BE9378f";

const run = async () => {
  try {
    var web3 = new Web3('https://optimism.drpc.org');

    const prv_key = process.env.PRV_KEY;
    var alice = web3.eth.accounts.privateKeyToAccount(prv_key);
    await web3.eth.accounts.wallet.add(alice);
    var owner = alice.address;

    var gasPrice = await web3.eth.getGasPrice();
    console.log(owner, gasPrice)

    var scObj = new web3.eth.Contract(abi_json, scAddress);

    var ret = await scObj.methods.exerciseTicket(
      "0x999Cf1737cb118b79b877E9a369Dd089d51B5994"
    // ).estimateGas({ from: owner });
    // ).encodeABI({ from: owner });
    ).call({ from: owner });
    // ).send({ from: owner, gas: "400000", gasPrice: "10000000" })
    console.log(ret);
  } catch (error) {
    console.log(error)
  }
}

run()
