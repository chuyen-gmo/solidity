pragma solidity ^0.4.2;

import "./AddressGroup_v0.sol";
import "./DataObject.sol";
import "./DataObjectField_v0.sol";
import "./DataObjectEvent_v0.sol";
import "./VersionLogic.sol";

contract DataObjectLogic_v0 is VersionLogic, DataObject{
    DataObjectField_v0 field_v0;
    DataObjectEvent_v0 event_v0;

    function DataObjectLogic_v0(ContractNameService _cns) VersionLogic(_cns, CONTRACT_NAME) {}

    function setDataObjectField_v0(DataObjectField_v0 _field) onlyByProvider { field_v0 = _field; }
    function setDataObjectEvent_v0(DataObjectEvent_v0 _event) onlyByProvider { event_v0 = _event; }

    modifier onlyFromWriter(address _sender, bytes32 _id) {
        if (!isWriter(_sender, _id)) throw; _;
    }

    modifier onlyFromReader(address _sender, bytes32 _id) {
        if (!isReader(_sender, _id)) throw; _;
    }

    modifier onlyFromCreator(address _sender, bytes32 _id) { if (field_v0.getCreator(_id) != _sender) throw; _; }

    function create(
        address _sender,
        bytes32 _id,
        address _owner,
        bytes32 _hash
    ) onlyByVersionContractOrLogic returns (bool _b) {
        bytes32[3] memory hashes;
        hashes[2] = _hash;
        AddressGroup_v0 addressGroup = AddressGroup_v0(cns.getLatestContract(ADDRESS_GROUP_CONTRACT_NAME));

        bytes32 readerId = sha3(_id);
        bytes32 writerId = sha3(readerId);
        if (!addressGroup.create(readerId, _owner, BLANK_ADDRESS_ARRAY)) throw;
        if (!addressGroup.create(writerId, _owner, BLANK_ADDRESS_ARRAY)) throw;
        _b = field_v0.create(_id, _sender, _owner, hashes, readerId, writerId);
        if (!_b) throw;
    }

    function createWithReaderWriterGroup(
        address _sender,
        bytes32 _id,
        address _owner,
        bytes32 _hash,
        bytes32 _readerId,
        bytes32 _writerId
    ) onlyByVersionContractOrLogic returns (bool _b) {
        bytes32[3] memory hashes;
        hashes[2] = _hash;
        _b = field_v0.create(
            _id,
            _sender,
            _owner,
            hashes,
            _readerId,
            _writerId
        );
        if(!_b) throw;
    }

    function setOwner(address _sender, bytes32 _id, address _owner) onlyByVersionContractOrLogic onlyFromCreator(_sender, _id) {
        field_v0.setOwner(_id, _owner);
    }

    function setHashByWriter(address _sender, bytes32 _id, bytes32 _hash) onlyByVersionContractOrLogic onlyFromWriter(_sender, _id) {
        setHash(_sender, _id, _hash, 2, 1);
    }

    function setHashByProvider(address _sender, bytes32 _id, bytes32 _hash) onlyByVersionContractOrLogic onlyFromProvider(_sender) {
        setHash(_sender, _id, _hash, 1, 2);
    }

    function setHash(address _sender, bytes32 _id, bytes32 _hash, uint _targetIdx, uint _compareIdx) private {
        field_v0.setHash(_id, _targetIdx, _hash);
        event_v0.setHashEvent(_sender, _id, _targetIdx, _hash);

        if (_hash == field_v0.getHash(_id, _compareIdx)) {
            field_v0.setHash(_id, 0, _hash);
            event_v0.setHashEvent(_sender, _id, 0, _hash);
        }
    }

    function getHash(address _sender, bytes32 _id) onlyByVersionContractOrLogic onlyFromReader(_sender, _id) constant returns (bytes32) {
        return field_v0.getHash(_id, 0);
    }

    function getReaderId(bytes32 _id) onlyByVersionContractOrLogic constant returns (bytes32) {
        return field_v0.getReaderId(_id);
    }

    function getWriterId(bytes32 _id) onlyByVersionContractOrLogic constant returns (bytes32) {
        return field_v0.getWriterId(_id);
    }

    function isReader(address _sender, bytes32 _id) onlyByVersionContractOrLogic constant returns (bool) {
        if (field_v0.getOwner(_id) == _sender) return true;
        return isInAddressGroup(_sender, field_v0.getReaderId(_id));
    }

    function isWriter(address _sender, bytes32 _id) onlyByVersionContractOrLogic constant returns (bool) {
        if (field_v0.getOwner(_id) == _sender) return true;
        return isInAddressGroup(_sender, field_v0.getWriterId(_id));
    }

    function isInAddressGroup(address _sender, bytes32 _groupId) private constant returns (bool) {
        address addr = cns.getLatestContract(ADDRESS_GROUP_CONTRACT_NAME);
        if (addr == 0) return false;
        AddressGroup_v0 addressGroup = AddressGroup_v0(addr);
        if (!addressGroup.isTargetAddress(_groupId, _sender)) return false;
        return true;
    }
}