// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

import "./Medicines.sol";

contract MedicineOperates {

    Medicine public medicines;

    constructor(address _medicinesAddress) {
        medicines = Medicines(_medicinesAddress);
    }


    struct Medicine {
        uint256 ID;
        string name;
        string content;
        uint64 price;
    }


    mapping(uint256 => Medicine) idToMedicine;

    function add(string calldata _name, string calldata _content,uint64 price, uint256 _id) private {
        Medicine memory medicine;
        medicine.ID = _id;
        medicine.name = _name;
        medicine.content = _content;
        medicine.price = _price;
        medicines[_id] = medicine;
    }
    
}