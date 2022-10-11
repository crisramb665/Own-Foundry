// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/TestToken.sol";

contract CounterTest is Test {
    
    MigueToken3 token;
    Tarea3 tarea3;
    uint256 testNum;
    

    function setUp() public {
        token = new MigueToken3();
        tarea3 = new Tarea3(token, 2, 38);
        testNum = 12;
    }

    function testNumberIs12() public {
        assertEq(testNum, 12);
    }

    function testMint() public {
        address accountT = msg.sender;
        token.mint(accountT, 1, 25);
        uint256 expectedBalance = token.balanceOf(accountT, 1);
        assertEq(expectedBalance, 25);
        emit log_named_uint("The value is", expectedBalance);
    }

    // function testBalanceOf() public {
    //     address accountT = msg.sender;
    //     uint256 idT = 1;
    //     uint256 expectedBalance = token.balanceOf(accountT, idT);

    //     assertEq(expectedBalance, 1000);
    // }
}