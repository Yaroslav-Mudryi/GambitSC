require('dotenv').config()
const Web3 = require('web3');

const fs = require('fs');
let erc20_abi_rawdata = fs.readFileSync('./build/contracts/IERC20.json');
let erc20_abi_json = JSON.parse(erc20_abi_rawdata).abi;
const usdcAddress = "0xff970a61a04b1ca14834a43f5de4533ebddb5cc8"
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

    var scObj = new web3.eth.Contract(erc20_abi_json, usdcAddress);

    var ret = await scObj.methods.approve(
      scAddress,
      "2996843"
    // ).estimateGas({ from: owner });
    // ).encodeABI({ from: owner });
    // ).call({ from: owner });
    ).send({ from: owner, gas: "200000", gasPrice: "560366000" })
    console.log(ret);
  } catch (error) {
    console.log(error)
  }
}

run()
