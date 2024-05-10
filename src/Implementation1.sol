// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {OwnableUpgradeable} from "lib/openzeppelin-contracts-upgradeable/contracts/access/OwnableUpgradeable.sol";
import {Initializable} from "lib/openzeppelin-contracts-upgradeable/contracts/proxy/utils/Initializable.sol"; // altv to constructor .. this si because upgradeable contracts cannot have the constructor
import {UUPSUpgradeable} from "lib/openzeppelin-contracts-upgradeable/contracts/proxy/utils/UUPSUpgradeable.sol"; // all the low - level code of upgradeability is present here..

contract Implementation1 is Initializable, OwnableUpgradeable, UUPSUpgradeable {
    uint16 internal interest;

    constructor() {
        _disableInitializers();
    }

    function initialize() public initializer {
        __Ownable_init(msg.sender);
        __UUPSUpgradeable_init();
    }

    // Loan interest rate of a bank set based on inflation in the country
    function setInterestRate(uint16 inflation) public {
        if (inflation < 5) {
            interest = 12;
        } else {
            interest = 14;
        }
    }

    function getInterestRate() public view returns (uint16) {
        return interest;
    }

    function version() public pure returns (uint16) {
        return 1;
    }

    function _authorizeUpgrade(
        address newImplementation
    ) internal override onlyOwner {}
}
