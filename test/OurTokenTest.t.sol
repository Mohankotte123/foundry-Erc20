// SPDX-License-Identifier: MIT 

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {DeployOurToken} from "../script/DeployOurToken.s.sol";
import {OurToken} from "../src/OurToken.sol";
import {StdCheats} from "forge-std/StdCheats.sol";
 
interface MintableToken {
    function mint(address ,uint256) external;
} 

contract OurTokenTest is StdCheats, Test {
  OurToken public ourToken;
  DeployOurToken public deployer;

  address bob = makeAddr("bob");
  address alice =  makeAddr("alice");
  
  uint256 public constant STARTING_BALANCE = 100 ether;
 function setUp() public {
    deployer = new DeployOurToken();
    ourToken = deployer.run();

    vm.prank(msg.sender);
    ourToken.transfer(bob, STARTING_BALANCE);

}

function testBobBalance() public {
    assertEq(STARTING_BALANCE,ourToken.balanceOf(bob));
}

function testAllowancesWorks() public {
    uint256 initialAllowance = 1000;

    // Bob approves alice to spend tokens on her behalf 
    vm.prank(bob);
    ourToken.approve(alice,initialAllowance); 
    
    uint256 transferAmount = 500;
    vm.prank(alice);
    ourToken.transferFrom(bob,alice,transferAmount);
    assertEq(ourToken.balanceOf(alice),transferAmount);
    assertEq(ourToken.balanceOf(bob),STARTING_BALANCE-transferAmount);

}
function testtransfer() public {
    uint256 amount = 1000;
    address receiver = address(0x1);
    vm.prank(msg.sender);
    ourToken.transfer(receiver,amount);
    assertEq(ourToken.balanceOf(receiver),amount);
}

function testBalanceafterTransfer()public {
    uint256 amount = 1000;
    address receiver = address(0x1);
    uint256 initialBalance = ourToken.balanceOf(msg.sender);
    vm.prank(msg.sender);
    ourToken.transfer(receiver,amount);
    assertEq(ourToken.balanceOf(msg.sender),initialBalance-amount);
}

function testTransferFrom() public {
    uint256 amount = 1000;
    address receiver = address(0x1);
    vm.prank(msg.sender);
    ourToken.approve(address(this),amount);
    ourToken.transferFrom(msg.sender,receiver,amount);
    assertEq(ourToken.balanceOf(receiver),amount);
}

}