// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe fundMe;
    address USER = makeAddr("USER");

    function setUp() external {
        (fundMe,) = new DeployFundMe().run();
        deal(USER, 100 ether);
    }

    function testDemo() public view {
        assertEq(fundMe.MINIMUM_USD(), 5 * 10 ** 18);
    }

    function testOwner() public view {
        assertEq(fundMe.i_owner(), msg.sender);
    }

    function testVersion() public view {
        uint256 version = fundMe.getVersion();
        assertEq(version, 4);
    }

    function testFunding() public {
        vm.prank(USER);
        fundMe.fund{value: 5 * 10 ** 18}();

        assertEq(fundMe.addressToAmountFunded(USER), 5 * 10 ** 18);
    }

    function testWithdraw() public {
        // vm.prank(USER);
        fundMe.fund{value: 5 * 10 ** 18}();
        console.log("address", address(this));
        console.log("address22", address(USER));
        // vm.prank(USER);
        /**
         * DeployFundMe contract is the original owner
         */
        vm.expectRevert();
        fundMe.withdraw();
    }
}
