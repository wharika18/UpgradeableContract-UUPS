//SPDX License Identifier:MIT
pragma solidity ^0.8.19;

import {DeployImplementation} from "../script/DeployImplementation.s.sol";
import {UpgradeImplementation} from "../script/UpgradeImplementation.s.sol";
import {Test, console} from "forge-std/Test.sol";
import {StdCheats} from "forge-std/StdCheats.sol";
import {ERC1967Proxy} from "lib/openzeppelin-contracts/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import {Implementation1} from "../../src/Implementation1.sol";
import {Implementation2} from "../../src/Implementation2.sol";

contract DeployAndUpgradeTest is StdCheats, Test {
    DeployImplementation public deployImp;
    UpgradeImplementation public upgradeImp;
    address public OWNER = address(1);

    function setUp() public {
        deployImp = new DeployImplementation();
        upgradeImp = new UpgradeImplementation();
    }

    function testProxyWorks() public {
        address proxyAddress = deployImp.deployImplementation();
        uint16 expectedVersion = 1;
        assertEq(expectedVersion, Implementation1(proxyAddress).version());
    }

    function testDeploymentIsImplementation1() public {
        address proxyAddress = deployImp.deployImplementation();
        uint16 Repo = 8;
        vm.expectRevert();
        Implementation2(proxyAddress).setRepoBasedInterest(Repo);
    }

    function testUpgrade() public {
        address proxyAddress = deployImp.deployImplementation();
        Implementation2 implementation2 = new Implementation2();

        vm.prank(Implementation1(proxyAddress).owner());
        Implementation1(proxyAddress).transferOwnership(msg.sender);

        address proxyAddressNew = upgradeImp.upgradeImplementation(
            proxyAddress,
            address(implementation2)
        );
        uint16 expectedVersion = 2;

        assertEq(expectedVersion, Implementation2(proxyAddressNew).version());
    }

    function testInterestAssignment() public {
        address proxyAddress = deployImp.deployImplementation();

        uint16 inflation = 4;
        Implementation1(proxyAddress).setInterestRate(inflation);
        uint16 expectedInterest = 12;
        assertEq(
            Implementation1(proxyAddress).getInterestRate(),
            expectedInterest
        );
    }

    function testInterestAfterUpgrade() public {
        address proxyAddress = deployImp.deployImplementation();
        uint16 repo = 5;
        Implementation2 implementation2 = new Implementation2();

        vm.prank(Implementation1(proxyAddress).owner());
        Implementation1(proxyAddress).transferOwnership(msg.sender);

        address proxyAddressNew = upgradeImp.upgradeImplementation(
            proxyAddress,
            address(implementation2)
        );
        Implementation2(proxyAddress).setRepoBasedInterest(repo);
        uint16 expectedInterest = 12;
        assertEq(
            Implementation2(proxyAddress).getInterestRate(),
            expectedInterest
        );
    }
}
