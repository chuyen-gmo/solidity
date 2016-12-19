pragma solidity ^0.4.2;

import "./AddressGroup.sol";
import "./AddressGroupLogic_v0.sol";
import "./VersionContract.sol";

contract AddressGroup_v0 is VersionContract, AddressGroup {
    AddressGroupLogic_v0 logic_v0;

    function AddressGroup_v0(ContractNameService _cns, AddressGroupLogic_v0 _logic) VersionContract(_cns, CONTRACT_NAME) {
        logic_v0 = _logic;
    }

    function create(bytes32 _id, address _owner, address[] _addrs) returns (bool) {
        return logic_v0.create(msg.sender, _id, _owner, _addrs);
    }

    function addAddress(bytes32 _id, address _addr) returns (bool) {
        return logic_v0.addAddress(msg.sender, _id, _addr);
    }

    function removeAddress(bytes32 _id, address _addr) returns (bool) {
        return logic_v0.removeAddress(msg.sender, _id, _addr);
    }

    function setAllowCnsContract(bytes32 _id, address _cns, bytes32 _contractName) {
        logic_v0.setAllowCnsContract(msg.sender, _id, _cns, _contractName);
    }

    function isTargetAddress(bytes32 _id, address _addr) constant returns (bool) {
        return logic_v0.isTargetAddress(_id, _addr);
    }

    function appendChild(bytes32 _id, bytes32 _childId) {
        logic_v0.appendChild(msg.sender, _id, _childId);
    }    

    function removeChild(bytes32 _id, bytes32 _childId) {
        logic_v0.removeChild(msg.sender, _id, _childId);
    }
}