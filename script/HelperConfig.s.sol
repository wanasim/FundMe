// SPDX-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mock/MockV3Aggregator.sol";

contract HelperConfig is Script {
    NetworkConfig public activeConfig;
    uint8 DECIMALS = 8;
    int256 INITIAL_ANSWER = 2000e8;

    struct NetworkConfig {
        address priceFeed;
    }

    constructor() {
        if (block.chainid == 11155111) activeConfig = getSepoliaConfig();
        else activeConfig = getAnvilConfig();
    }

    function getSepoliaConfig() public pure returns (NetworkConfig memory) {
        return NetworkConfig({priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306});
    }

    function getAnvilConfig() public returns (NetworkConfig memory) {
        /**
         * deploy to contract to Anvil first since it doesn't exist by default
         */
        vm.startBroadcast();
        MockV3Aggregator mock = new MockV3Aggregator(DECIMALS, INITIAL_ANSWER);
        vm.stopBroadcast();

        return NetworkConfig({priceFeed: address(mock)});
    }
}
