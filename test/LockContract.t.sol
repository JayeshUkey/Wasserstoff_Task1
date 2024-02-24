// SPDX-License-Identifier: UNLICENSED
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@shiso/test/contracts/Contract.sol";
import "@shiso/test/contracts/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./LockContract.sol";

contract LockContractTest is Contract {
    LockContract public lockContract;
    ERC20 public mockERC20;

    // Deploy contracts before each test
    function beforeEach() public {
        lockContract = new LockContract();
        mockERC20 = new ERC20("MockToken", "MTK");
    }

    // Test case for locking ERC20 tokens
    function testLockERC20() public {
        mockERC20.mint(user1, 1000);

        // Approve LockContract to spend ERC20 tokens on behalf of the user
        mockERC20.approve(address(lockContract), 100);

        // Lock ERC20 tokens
        lockContract.lockERC20(mockERC20, 50);

        // Assertions
        assert.equal(
            lockContract.erc20LockedEvents.length,
            1,
            "Should emit ERC20Locked event"
        );
        assert.equal(
            lockContract.erc20LockedEvents[0].user,
            user1,
            "Incorrect user in ERC20Locked event"
        );
        assert.equal(
            lockContract.erc20LockedEvents[0].token,
            address(mockERC20),
            "Incorrect token address in ERC20Locked event"
        );
        assert.equal(
            lockContract.erc20LockedEvents[0].amount,
            50,
            "Incorrect amount in ERC20Locked event"
        );
    }

    // Test case for withdrawing ERC20 tokens by the owner
    function testWithdrawERC20() public {
        mockERC20.mint(user1, 1000);

        // Approve LockContract to spend ERC20 tokens on behalf of the user
        mockERC20.approve(address(lockContract), 100);

        // Lock ERC20 tokens
        lockContract.lockERC20(mockERC20, 50);

        // Withdraw ERC20 tokens by the owner
        lockContract.withdrawERC20(mockERC20, 50);

        // Assertions
        assert.equal(
            mockERC20.balanceOf(address(lockContract)),
            0,
            "Incorrect ERC20 balance in LockContract"
        );
        assert.equal(
            mockERC20.balanceOf(owner),
            50,
            "Incorrect ERC20 balance for the owner"
        );
    }

    // Additional test cases for native token locking, withdrawing, and refunding can be added

    // ... (Add more test cases as needed)

    // Helper function to get the contract's balance
    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }

    // Helper function to receive native tokens
    receive() external payable {}
}
