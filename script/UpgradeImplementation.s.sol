// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {Implementation1} from "../src/Implementation1.sol";
import {Implementation2} from "../src/Implementation2.sol";
import {ERC1967Proxy} from "lib/openzeppelin-contracts/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";

contract UpgradeImplementation is Script {
    function run() external returns (address) {
        address mostRecentlyDeployedProxy = DevOpsTools
            .get_most_recent_deployment("ERC1967Proxy", block.chainid);

        vm.startBroadcast();
        Implementation2 newImplementation = new Implementation2();
        vm.stopBroadcast();
        address proxy = upgradeImplementation(
            mostRecentlyDeployedProxy,
            address(newImplementation)
        );
        return proxy;
    }

    function upgradeImplementation(
        address proxyAddress,
        address newImplementation
    ) public returns (address) {
        vm.startBroadcast();
        Implementation1 proxy = Implementation1(payable(proxyAddress));
        proxy.upgradeToAndCall(address(newImplementation), ""); // originally upgradeTo function is given but this has been modified to upgradeandcall
        vm.stopBroadcast();
        return address(proxy);
    }
}
