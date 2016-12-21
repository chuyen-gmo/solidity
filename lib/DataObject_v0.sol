pragma solidity ^0.4.2;

import "./DataObject.sol";
import "./DataObjectLogic_v0.sol";
import "./VersionContract.sol";

contract DataObject_v0 is VersionContract, DataObject {
    DataObjectLogic_v0 logic_v0;

    function DataObject_v0(ContractNameService _cns, DataObjectLogic_v0 _logic) VersionContract(_cns, CONTRACT_NAME) {
        logic_v0 = _logic;
    }

    function create(bytes32 _id, address _owner, bytes32 _hash, address _cns, bytes32 _contractName) {
        logic_v0.create(msg.sender, _id, _owner, _hash, _cns, _contractName);
    }

    function setHashByWriter(address _writer, bytes32 _id, bytes32 _hash) {
        logic_v0.setHashByWriter(msg.sender, _writer, _id, _hash);
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

    function setReaderId(bytes32 _id, bytes32 _readerId) {
        logic_v0.setReaderId(msg.sender, _id, _readerId);
    }

    function setWriterId(bytes32 _id, bytes32 _writerId) {
        logic_v0.setWriterId(msg.sender, _id, _writerId);
    }

    function setAllowCnsContract(bytes32 _id, address _cns, bytes32 _contractName) {
        logic_v0.setAllowCnsContract(msg.sender, _id, _cns, _contractName);
    }
}