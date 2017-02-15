pragma solidity ^0.4.2;

import "./AddressGroup.sol";
import "./VersionField.sol";

contract AddressGroupField_v0 is VersionField, AddressGroup {
    struct Group {
        address creator;
        address owner;
        bytes32[] children;
        mapping (address => bool) targetAddress;
        mapping (address => mapping (bytes32 => bool)) allowCnsContracts;
        bool deleted;
    }

    mapping (bytes32 => Group) private groups;

    modifier onlyNotDeleted(bytes32 _id) { if (groups[_id].deleted) throw; _; }

    function AddressGroupField_v0(ContractNameService _cns) VersionField(_cns, CONTRACT_NAME) {}

    function create(bytes32 _id, address _creator, address _owner) onlyByNextVersionOrVersionLogic onlyNotDeleted(_id) returns(bool){
        if (exist(_id)) return false;
        groups[_id] = Group(_creator, _owner, BLANK_BYTE32_ARRAY, false);
        return true;
    }

    function remove(bytes32 _id) onlyByNextVersionOrVersionLogic onlyNotDeleted(_id) returns(bool){
        if (!exist(_id)) return false;
        delete groups[_id];
        groups[_id].deleted = true;
        return true;
    }

    function getCreator(bytes32 _id) onlyByNextVersionOrVersionLogic constant returns(address) {
        if (existIdAtPrevVersion(_id)) return 0;
        return groups[_id].creator;
    }

    function setCreator(bytes32 _id, address _creator) onlyByNextVersionOrVersionLogic onlyNotDeleted(_id) {
        if (!prepare(_id)) throw;
        groups[_id].creator = _creator;
    }

    function getOwner(bytes32 _id) onlyByNextVersionOrVersionLogic constant returns(address) {
        if (existIdAtPrevVersion(_id)) return 0;
        return groups[_id].owner;
    }

    function setOwner(bytes32 _id, address _owner) onlyByNextVersionOrVersionLogic onlyNotDeleted(_id) {
        if (!prepare(_id)) throw;
        groups[_id].owner = _owner;
    }

    function isTargetAddress(bytes32 _id, address _targetAddress) onlyByNextVersionOrVersionLogic constant returns(bool) {
        if (existIdAtPrevVersion(_id)) return false;
        return isTargetAddressInDescendant(_id, _targetAddress);
    }

    function isTargetAddressInDescendant(bytes32 _id, address _targetAddress) private constant returns(bool) {
        if (groups[_id].targetAddress[_targetAddress]) return true;
        for (uint i=0; i<groups[_id].children.length; i++) {
            if (isTargetAddressInDescendant(groups[_id].children[i], _targetAddress)) return true;
        }
        return false;
    }

    function setTargetAddress(bytes32 _id, address _targetAddress, bool _b) onlyByNextVersionOrVersionLogic onlyNotDeleted(_id) {
        if (!prepare(_id)) throw;
        groups[_id].targetAddress[_targetAddress] = _b;
    }

    function appendChild(bytes32 _id, bytes32 _childId) onlyByNextVersionOrVersionLogic onlyNotDeleted(_id) {
        if (!prepare(_id)) throw;
        for (uint i=0; i<groups[_id].children.length; i++) {
            if (groups[_id].children[i] == _childId) throw;
        }
        groups[_id].children.push(_childId);
    }

    function removeChild(bytes32 _id, bytes32 _childId) onlyByNextVersionOrVersionLogic onlyNotDeleted(_id) {
        for (uint i=0; i<groups[_id].children.length; i++) {
            if (groups[_id].children[i] == _childId) {
                delete groups[_id].children[i];
                return;
            }
        }
    }

    function isAllowCnsContract(bytes32 _id, address _cns, bytes32 _contractName) onlyByNextVersionOrVersionLogic constant returns(bool) {
        if (existIdAtPrevVersion(_id)) return false;
        return groups[_id].allowCnsContracts[_cns][_contractName];
    }

    function setAllowCnsContract(bytes32 _id, address _cns, bytes32 _contractName, bool _b) onlyByNextVersionOrVersionLogic onlyNotDeleted(_id) {
        if (!prepare(_id)) throw;
        groups[_id].allowCnsContracts[_cns][_contractName] = _b;
    }

    function existIdAtCurrentVersion(bytes32 _id) constant returns(bool) {
        return !(groups[_id].deleted || groups[_id].creator == 0);
    }

    function setDefault(bytes32 _id) private { /* do nothing on version 0 */ }
}