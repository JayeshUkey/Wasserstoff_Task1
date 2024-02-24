// SPDX-License-Identifier: UNLICENSED
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract LockContract is Ownable {
    event TokensLocked(
        address indexed sender,
        address indexed targetChain,
        uint256 amount
    );

    // Event emitted when ERC20 tokens are locked
    event ERC20Locked(
        address indexed user,
        address indexed token,
        uint256 amount
    );

    // Event emitted when native tokens (ETH) are locked
    event EthLocked(address indexed user, uint256 amount);

    // Fallback function to accept native tokens (ETH)
    receive() external payable {
        emit EthLocked(msg.sender, msg.value);
    }

    // Function to lock ERC20 tokens
    function lockERC20(IERC20 token, uint256 amount) external {
        // Ensure the contract is allowed to spend the user's tokens
        require(
            token.transferFrom(msg.sender, address(this), amount),
            "Transfer failed"
        );

        // Emit event indicating ERC20 tokens are locked
        emit ERC20Locked(msg.sender, address(token), amount);
    }

    // Function to withdraw ERC20 tokens from the contract (only owner)
    function withdrawERC20(IERC20 token, uint256 amount) external onlyOwner {
        // Ensure the contract has enough balance to withdraw
        require(
            token.balanceOf(address(this)) >= amount,
            "Insufficient balance"
        );

        // Transfer ERC20 tokens to the contract owner
        token.transfer(owner(), amount);
    }

    // Function to withdraw native tokens (ETH) from the contract (only owner)
    function withdrawEth(uint256 amount) external onlyOwner {
        // Ensure the contract has enough balance to withdraw
        require(address(this).balance >= amount, "Insufficient balance");

        // Transfer native tokens (ETH) to the contract owner
        payable(owner()).transfer(amount);
    }

    function lockTokens(
        address token,
        uint256 amount,
        address targetChain
    ) external {
        require(
            IERC20(token).transferFrom(msg.sender, address(this), amount),
            "Transfer failed"
        );

        // Refund mechanism
    function refundTokens(
        address token,
        uint256 amount,
        address targetChain
    ) external onlyOwner {
        bytes32 transactionHash = keccak256(abi.encodePacked(msg.sender, targetChain, amount));
        require(!processedTransactions[transactionHash], "Transaction already processed");

        // Refund tokens to the user
        // ... (Implement the refund logic)
    }

        emit TokensLocked(msg.sender, targetChain, amount);
    }
}
