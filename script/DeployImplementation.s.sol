// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;
import {Script} from "forge-std/Script.sol";
import {Implementation1} from "../src/Implementation1.sol";
import {ERC1967Proxy} from "lib/openzeppelin-contracts/contracts/proxy/ERC1967/ERC1967Proxy.sol";

contract DeployImplementation is Script {
    function run() external returns (address) {
        address proxy = deployImplementation();
        return proxy;
    }

    function deployImplementation() public returns (address) {
        vm.startBroadcast();
        Implementation1 implementation = new Implementation1();
        ERC1967Proxy proxy = new ERC1967Proxy(address(implementation), "");
        Implementation1(address(proxy)).initialize();
        vm.stopBroadcast();
        return address(proxy);
    }
}
