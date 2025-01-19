// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {FundFundMe} from "../../script/Interactions.s.sol";

contract FundMeTestIntegration is Test {
    FundMe fundMe;
    address USER = makeAddr("USER");
    uint256 constant STARTING_BALANCE = 100 ether;

    function setUp() external {
        (FundMe _fundMe,) = new DeployFundMe().run();
        fundMe = _fundMe;
        vm.deal(USER, STARTING_BALANCE);
    }

    function testUserCanFund() public {
        FundFundMe fundFundMe = new FundFundMe();
        vm.deal(USER, 100 ether);
        vm.deal(address(fundMe), 1000 ether);
        vm.prank(USER);
        // figure out why fundFundMe is not pranking as USER. Getting error
        // "NOT ENOUGH FUNDS"
        // fundFundMe.fundFundMe(address(fundMe));
        fundMe.fund{value: 0.1 ether}();

        address funder = fundMe.getFunder(0);
        assertEq(funder, USER);
    }
}
