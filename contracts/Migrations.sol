// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;


contract Migrations {
    address public owner = msg.sender;
    uint public last_completed_migrations;
    modifier restricted() {
        require(
            msg.sender == owner,
            "This function is restrcited to the contract's owner"
        );
        _;
    }

    function setCompleted(uint completed) public restricted {
        last_completed_migrations = completed;
    }
}