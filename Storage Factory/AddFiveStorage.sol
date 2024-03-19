// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import {SimpleStorage} from "./SimpleStorage.sol";

// AddFiveStorage inharitance from SimpleStorage
contract AddFiveStorage is SimpleStorage {

    // To customing SimpleStorage function called overide
    // virtual override
    function store(uint256 _favoriteNumber) public override {
        myFavoriteNumber = _favoriteNumber + 5;
    }
}
