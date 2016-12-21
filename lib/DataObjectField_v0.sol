pragma solidity ^0.4.2;

import "./DataObject.sol";
import "./VersionField.sol";

contract DataObjectField_v0 is VersionField, DataObject {
    struct Field {
        address creator;
        address owner;
        bytes32[3] hashes;
        bytes32 readerId;
        bytes32 writerId;
        mapping (address => mapping (bytes32 => bool)) allowCnsContracts;
        bool deleted;
    }

    mapping (bytes32 => Field) private fields;

    function DataObjectField_v0(ContractNameService _cns) VersionField(_cns, CONTRACT_NAME) {}

    modifier onlyNotDeleted(bytes32 _id) { if (fields[_id].deleted) throw; _; }

    function create(
        bytes32 _id,
        address _creator,
        address _owner,
        bytes32[3] _hashes,
        bytes32 _readerId,
        bytes32 _writerId
    ) onlyByNextVersionOrVersionLogic onlyNotDeleted(_id) returns(bool){
        if (exist(_id)) return false;
        fields[_id] = Field(_creator, _owner, _hashes, _readerId, _writerId, false);
        return true;
    }

    function remove(bytes32 _id) onlyByNextVersionOrVersionLogic onlyNotDeleted(_id) returns(bool){
        if (!exist(_id)) return false;
        delete fields[_id];
        fields[_id].deleted = true;
        return true;
    }

    function getCreator(bytes32 _id) onlyByNextVersionOrVersionLogic constant returns(address) {
        if (existIdAtPrevVersion(_id)) return 0;
        return fields[_id].creator;
    }

    function setCreator(bytes32 _id, address _creator) onlyByNextVersionOrVersionLogic onlyNotDeleted(_id) {
        if (!prepare(_id)) throw;
        fields[_id].creator = _creator;
    }

    function getOwner(bytes32 _id) onlyByNextVersionOrVersionLogic constant returns(address) {
        if (existIdAtPrevVersion(_id)) return 0;
        return fields[_id].owner;
    }

    function setOwner(bytes32 _id, address _owner) onlyByNextVersionOrVersionLogic onlyNotDeleted(_id) {
        if (!prepare(_id)) throw;
        fields[_id].owner = _owner;
    }

    function getHash(bytes32 _id, uint _idx) onlyByNextVersionOrVersionLogic constant returns(bytes32) {
        if (existIdAtPrevVersion(_id)) return 0;
        return fields[_id].hashes[_idx];
    }

    function setHash(bytes32 _id, uint _idx, bytes32 _hash) onlyByNextVersionOrVersionLogic onlyNotDeleted(_id) {
        if (!prepare(_id)) throw;
        fields[_id].hashes[_idx] = _hash;
    }

    function getReaderId(bytes32 _id) onlyByNextVersionOrVersionLogic constant returns(bytes32) {
        if (existIdAtPrevVersion(_id)) return 0;
        return fields[_id].readerId;
    }

    function setReaderId(bytes32 _id, bytes32 _readerId) onlyByNextVersionOrVersionLogic onlyNotDeleted(_id) {
        if (!prepare(_id)) throw;
        fields[_id].readerId = _readerId;
    }

    function getWriterId(bytes32 _id) onlyByNextVersionOrVersionLogic constant returns(bytes32) {
        if (existIdAtPrevVersion(_id)) return 0;
        return fields[_id].writerId;
    }

    function setWriterId(bytes32 _id, bytes32 _writerId) onlyByNextVersionOrVersionLogic onlyNotDeleted(_id) {
        if (!prepare(_id)) throw;
        fields[_id].writerId = _writerId;
    }

    function isAllowCnsContract(bytes32 _id, address _cns, bytes32 _contractName) onlyByNextVersionOrVersionLogic constant returns(bool) {
        if (existIdAtPrevVersion(_id)) return false;
        return fields[_id].allowCnsContracts[_cns][_contractName];
    }

    function setAllowCnsContract(bytes32 _id, address _cns, bytes32 _contractName, bool _b) onlyByNextVersionOrVersionLogic onlyNotDeleted(_id) {
        if (!prepare(_id)) throw;
        fields[_id].allowCnsContracts[_cns][_contractName] = _b;
    }

    function existIdAtCurrentVersion(bytes32 _id) constant returns(bool) { return !(fields[_id].deleted || fields[_id].creator == 0); }
    function setDefault(bytes32 _id) private { /* do nothing on version 0 */ }
}