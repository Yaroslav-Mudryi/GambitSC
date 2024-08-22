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

    var ret = await scObj.methods.buyFromAMM(
      "0x373b453e0a6131dacd36278fd1199a5db196d68f",
      0,
      "3690000000000000000",
      "2996843",
      "20000000000000000"
    // ).estimateGas({ from: owner });
    // ).encodeABI({ from: owner });
    // ).call({ from: owner });
    ).send({ from: owner, gas: "1500000", gasPrice: "560366000" })
    console.log(ret);
  } catch (error) {
    console.log(error)
  }
}

run()
