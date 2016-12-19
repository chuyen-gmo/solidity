pragma solidity ^0.4.2;

import "./DataObject.sol";
import "./DataObjectLogic_v0.sol";
import "./VersionContract.sol";

contract DataObject_v0 is VersionContract, DataObject {
    DataObjectLogic_v0 logic_v0;

    function DataObject_v0(ContractNameService _cns, DataObjectLogic_v0 _logic) VersionContract(_cns, CONTRACT_NAME) {
        logic_v0 = _logic;
    }

    function create(bytes32 _id, address _owner, bytes32 _hash) returns (bool) {
        return logic_v0.create(msg.sender, _id, _owner, _hash);
    }

    function createWithReaderWriterGroup(
        bytes32 _id,
        address _owner,
        bytes32 _hash,
        bytes32 _readerId,
        bytes32 _writerId
    ) returns (bool) {
        return logic_v0.createWithReaderWriterGroup(msg.sender, _id, _owner, _hash, _readerId, _writerId);
    }

    function setHashByWriter(bytes32 _id, bytes32 _hash) {
        logic_v0.setHashByWriter(msg.sender, _id, _hash);
    }

    function setHashByProvider(bytes32 _id, bytes32 _hash) {
        logic_v0.setHashByProvider(msg.sender, _id, _hash);
    }

    function getHash(address _sender, bytes32 _id) constant returns (bytes32) {
        return logic_v0.getHash(_sender, _id);
    }

    function getHashes(address _sender, bytes32[] _ids) constant returns (bytes32[] _hashes) {
        _hashes = new bytes32[](_ids.length);

        for (uint i; i<_ids.length; i++) {
            _hashes[i] = logic_v0.getHash(_sender, _ids[i]);
        }
    }

    function getReaderId(bytes32 _id) constant returns (bytes32) {
        return logic_v0.getReaderId(_id);
    }

    function getWriterId(bytes32 _id) constant returns (bytes32) {
        return logic_v0.getWriterId(_id);
    }

    function isReader(address _sender, bytes32 _id) constant returns (bool) {
        return logic_v0.isReader(_sender, _id);
    }

    function isWriter(address _sender, bytes32 _id) constant returns (bool) {
        return logic_v0.isWriter(_sender, _id);
    }
}