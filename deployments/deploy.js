const Web3 = require('web3');
const axios = require('axios');

const web3EVM = new Web3('EVM_CHAIN_PROVIDER_URL'); // Replace with the actual EVM chain provider URL
const web3NonEVM = new Web3('NON_EVM_CHAIN_PROVIDER_URL'); // Replace with the actual non-EVM chain provider URL

const lockContractAddress = 'EVM_LOCK_CONTRACT_ADDRESS'; // Replace with the actual address of the LockContract on EVM chain
const releaseContractAddress = 'NON_EVM_RELEASE_CONTRACT_ADDRESS'; // Replace with the actual address of the ReleaseContract on non-EVM chain

const lockContractABI = [...]; // Replace with the ABI of the LockContract
const releaseContractABI = [...]; // Replace with the ABI of the ReleaseContract

const lockContract = new web3EVM.eth.Contract(lockContractABI, lockContractAddress);
const releaseContract = new web3NonEVM.eth.Contract(releaseContractABI, releaseContractAddress);

const lockEventTopic = web3EVM.utils.keccak256('TokensLocked(address,address,uint256)'); // Replace with the actual event topic

async function monitorLockEvents() {
    lockContract.events.TokensLocked({
        fromBlock: 'latest',
    })
    .on('data', async (event) => {
        const { sender, targetChain, amount } = event.returnValues;

        // Additional validation and processing logic

        // Trigger release on the non-EVM chain
        await triggerRelease(sender, targetChain, amount);
    })
    .on('error', console.error);
}

async function triggerRelease(sender, targetChain, amount) {
    // Perform additional verification oracles or centralized checks

    // Trigger release on the non-EVM chain
    const releaseTransaction = releaseContract.methods.releaseTokens(sender, targetChain, amount);
    const releaseGas = await releaseTransaction.estimateGas();
    
    const releaseReceipt = await releaseTransaction.send({
        from: 'YOUR_RELEASE_WALLET_ADDRESS', // Replace with the address triggering the release
        gas: releaseGas * 2, // Adding some buffer for gas
    });

    console.log(`Tokens released on non-EVM chain: Transaction Hash - ${releaseReceipt.transactionHash}`);
}

// Start monitoring lock events
monitorLockEvents();
