// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

import "./MedicineOperates.sol";
import "./Medicines.sol";
import "./Money.sol";


interface IPrescription {
    function createPrescription() external;
    function addMedicine(
       uint256 _id,
       uint32 _quantity,
       uint8 _dosing,
       uint8 _strength,
       uint8 _duration
    ) external;
    function sellMedicine(uint256 _id) external;
} 

contract Prescription is IPrescription {
    MedicineOperates public MedicineOperates;
    Medicines public medicines;
    Money public money;
    constructor(address _medicinesOperatesAddress, address _moneyAddress) {
        medicineOperates = MedicineOperates(_medicinesOperatesAddress);
        money = Money(_moneyAddress);
    }

    event CreatePrescription(address indexed _doctor, uint256 indexed _patient, string message);

    
    struct Patient {
        uint256 ID;
        address prescriptionOwner;
    }

    uint patientCount = 1;

    struct MedicineOnPres {
        uint256 ID;
        string name;
        uint32 quantity;
        uint8 dosing;
        uint8 strength;
        uint8 duration;
        uint128 price;
    }

    mapping(address => Patient) patients;

    MedicineOnPres[] public medicineOnPreses;

    function createPrescription() override external {
        require(patients[msg.sender].ID == 0, "This patient has a prescription already");
        Patient memory patient;
        patient.ID = patientCount;
        patient.prescriptionOwner = msg.sender;
        patients[msg.sender] = patient;
        emit CreatePrescription(msg.sender, patients[msg.sender].ID, "prescription has created");
    }


    function addMedicine(
        string calldata _note,
        uint256 _id,
        uint32 _quantity,
        uint8 _dosing,
        uint8 _strength,
        uint8 _duration
    ) override external {
        MedicineOnPres memory medicineOnPres;
        medicines.mint(msg.sender, _id, _quantity, bytes(_note));
        medicineOnPres.ID = _id;
        medicineOnPres.name = medicines.name;
        medicineOnPres.quantity = _quantity;
        medicineOnPres.dosing = _dosing;
        medicineOnPres.strength = _strength;
        medicineOnPres.duration = _duration;
        medicineOnPres.price = medicines.price * _quantity;
        medicineOnPreses.push(medicineOnPres);
    }

    function sellMedicine(uint256 _id) override external {
        require(money.balanceOf(msg.sender) >= medicineOnPres[_id].price);
        require(_id < medicineOnPres.length, "not found");
        money.burnFrom(msg.sender, medicineOnPres[_id].price);

        for(uint8 i = 0; i < medicineOnPres.length - 1; i++) {
            medicineOnPres[_id] = medicineOnPres[_id + 1];
        }
        medicineOnPres.pop();
    }   
}