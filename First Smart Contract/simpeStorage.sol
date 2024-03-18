// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

// example how to use solidity version:
// pragma solidity 0.8.0;
// pragma solidity >=0.8.0 <0.9.0;

contract simpleStorage {
    //Basic types : bytes,boolean,uint,int,address

    uint256 myFavoriteNumber; // default value = 0

    // custom type
    struct Person {
        uint256 favoriteNumber;
        string name;
    }

    //dynamic array
    Person[] public listOfPeople;

    mapping (string => uint256) public nameToFavoriteNumber;

    function store (uint256 _favoriteNumber) public {
        myFavoriteNumber = _favoriteNumber;
    }

    function retrieve() public view returns (uint256) {
        return myFavoriteNumber;
    }

    //view, pure = read function (so it does'nt cost gas)

    function addPerson (string memory _name, uint256 _favoriteNumber) public {
        listOfPeople.push(Person (_favoriteNumber,_name ) );
        nameToFavoriteNumber[_name] = _favoriteNumber;
    }

    // calldata = temporary variabel (can't be modified)
    // memory =  temporary variabel (can be modified)
    // storage = permanent
}