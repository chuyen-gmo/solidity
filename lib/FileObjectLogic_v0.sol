pragma solidity ^0.4.2;

import "./AddressGroup_v0.sol";
import "./FileObject.sol";
import "./FileObjectField_v0.sol";
import "./FileObjectEvent_v0.sol";
import "./VersionLogic.sol";
import "./DataObject_v0.sol";

contract FileObjectLogic_v0 is VersionLogic, FileObject{
    FileObjectField_v0 field_v0;
    FileObjectEvent_v0 event_v0;

    function FileObjectLogic_v0(ContractNameService _cns) VersionLogic(_cns, CONTRACT_NAME) {}

    function setFileObjectField_v0(FileObjectField_v0 _field) onlyByProvider { field_v0 = _field; }
    function setFileObjectEvent_v0(FileObjectEvent_v0 _event) onlyByProvider { event_v0 = _event; }

    modifier onlyFromOwnerOrAllowCnsContractLogic(address _sender, bytes32 _id) {
        if (field_v0.getOwner(_id) != _sender) {
            VersionLogic logic = VersionLogic(_sender);
            if (!field_v0.isAllowCnsContract(_id, logic.getCns(), logic.getContractName())) throw;
            if (!logic.getCns().isVersionLogic(_sender, logic.getContractName())) throw;
        }
        _;
    }

    modifier onlyFromWriter(address _sender, bytes32 _id) {
        if (!isWriter(_id, _sender)) throw; _;
    }

    modifier onlyFromCreator(address _sender, bytes32 _id) { if (field_v0.getCreator(_id) != _sender) throw; _; }

    function exist(bytes32 _id) onlyByVersionContractOrLogic constant returns (bool) {
        return field_v0.exist(_id);
    }

    function create(
        address _sender,
        bytes32 _id,
        address _owner,
        bytes32 _nameHash,
        bytes32 _fileHash,
        address _cns,
        bytes32 _contractName
    ) onlyByVersionContractOrLogic {
        bytes32[3] memory hashes;
        hashes[2] = _fileHash;
        AddressGroup_v0 addressGroup = AddressGroup_v0(cns.getLatestContract(ADDRESS_GROUP_CONTRACT_NAME));

        bytes32 readerId = Utils.transferUniqueId(_id);
        bytes32 writerId = Utils.transferUniqueId(readerId);
        createGroup(readerId, writerId, _cns, _contractName);

        createDataObject(_id, _nameHash, _cns, _contractName);

        bytes32 nameReaderId = getNameReaderId(_id);
        bytes32 nameWriterId = getNameWriterId(_id);
        addressGroup.setAllowCnsContract(nameReaderId, _cns, _contractName);
        addressGroup.setAllowCnsContract(nameWriterId, _cns, _contractName);
        addressGroup.appendChild(nameReaderId, readerId);
        addressGroup.appendChild(nameWriterId, writerId);

        if (!field_v0.create(_id, _sender, _owner, hashes, readerId, writerId)) throw;
        field_v0.setAllowCnsContract(_id, _cns, _contractName, true);
        event_v0.create(_sender, _id);
    }

    function createGroup(bytes32 _readerId, bytes32 _writerId, address _cns, bytes32 _contractName) private {
        AddressGroup_v0 addressGroup = AddressGroup_v0(cns.getLatestContract(ADDRESS_GROUP_CONTRACT_NAME));
        if (!addressGroup.create(_readerId, this, BLANK_ADDRESS_ARRAY)) throw;
        if (!addressGroup.create(_writerId, this, BLANK_ADDRESS_ARRAY)) throw;
        addressGroup.setAllowCnsContract(_readerId, _cns, _contractName);
        addressGroup.setAllowCnsContract(_writerId, _cns, _contractName);
    }

    function createDataObject(bytes32 _id, bytes32 _nameHash, address _cns, bytes32 _contractName) private {
        DataObject_v0 dataObject = DataObject_v0(cns.getLatestContract(DATA_OBJECT_CONTRACT_NAME));
        dataObject.create(_id, this, _nameHash, cns, CONTRACT_NAME);
        dataObject.setAllowCnsContract(_id, _cns, _contractName);
    }

    function setAllowCnsContract(address _sender, bytes32 _id, address _cns, bytes32 _contractName) onlyByVersionContractOrLogic onlyFromOwnerOrAllowCnsContractLogic(_sender, _id) returns (bool) {
        if (field_v0.isAllowCnsContract(_id, _cns, _contractName)) return false;
        field_v0.setAllowCnsContract(_id, _cns, _contractName, true);
        return true;
    }

    function setOwner(address _sender, bytes32 _id, address _owner) onlyByVersionContractOrLogic onlyFromCreator(_sender, _id) {
        field_v0.setOwner(_id, _owner);
    }

    function setHashByWriter(address _sender, address _writer, bytes32 _id, bytes32 _hash) onlyByVersionContractOrLogic onlyFromOwnerOrAllowCnsContractLogic(_sender, _id) onlyFromWriter(_writer, _id) {
        setHash(_sender, _id, _hash, 2, 1);
    }

    function setNameHashByWriter(address _sender, address _writer, bytes32 _id, bytes32 _hash) onlyByVersionContractOrLogic onlyFromOwnerOrAllowCnsContractLogic(_sender, _id) {
        DataObject_v0 dataObject = DataObject_v0(cns.getLatestContract(DATA_OBJECT_CONTRACT_NAME));
        dataObject.setHashByWriter(_writer, _id, _hash);
    }

    function setHashByProvider(address _sender, bytes32 _id, bytes32 _hash) onlyByVersionContractOrLogic onlyFromProvider(_sender) {
        setHash(_sender, _id, _hash, 1, 2);
    }

    function setHash(address _sender, bytes32 _id, bytes32 _hash, uint _targetIdx, uint _compareIdx) private {
        field_v0.setHash(_id, _targetIdx, _hash);
        event_v0.setHash(_sender, _id, _targetIdx, _hash);

        if (_hash == field_v0.getHash(_id, _compareIdx)) {
            field_v0.setHash(_id, 0, _hash);
            event_v0.setHash(_sender, _id, 0, _hash);
        }
    }

    function getHash(bytes32 _id) onlyByVersionContractOrLogic constant returns (bytes32) {
        return field_v0.getHash(_id, 0);
    }

    function getReaderId(bytes32 _id) onlyByVersionContractOrLogic constant returns (bytes32) {
        return field_v0.getReaderId(_id);
    }

    function setReaderId(address _sender, bytes32 _id, bytes32 _readerId) onlyByVersionContractOrLogic onlyFromOwnerOrAllowCnsContractLogic(_sender, _id) {
        field_v0.setReaderId(_id, _readerId);
    }

    function getNameReaderId(bytes32 _id) onlyByVersionContractOrLogic constant returns (bytes32) {
        DataObject_v0 dataObject = DataObject_v0(cns.getLatestContract(DATA_OBJECT_CONTRACT_NAME));
        return dataObject.getReaderId(_id);
    }

    function getWriterId(bytes32 _id) onlyByVersionContractOrLogic constant returns (bytes32) {
        return field_v0.getWriterId(_id);
    }

    function setWriterId(address _sender, bytes32 _id, bytes32 _readerId) onlyByVersionContractOrLogic onlyFromOwnerOrAllowCnsContractLogic(_sender, _id) {
        field_v0.setWriterId(_id, _readerId);
    }

    function getNameWriterId(bytes32 _id) onlyByVersionContractOrLogic constant returns (bytes32) {
        DataObject_v0 dataObject = DataObject_v0(cns.getLatestContract(DATA_OBJECT_CONTRACT_NAME));
        return dataObject.getWriterId(_id);
    }

    function isReader(bytes32 _id, address _account) onlyByVersionContractOrLogic constant returns (bool) {
        if (field_v0.getOwner(_id) == _account) return true;
        return isInAddressGroup(field_v0.getReaderId(_id), _account);
    }

    function isWriter(bytes32 _id, address _account) onlyByVersionContractOrLogic constant returns (bool) {
        if (field_v0.getOwner(_id) == _account) return true;
        return isInAddressGroup(field_v0.getWriterId(_id), _account);
    }

    function isInAddressGroup(bytes32 _groupId, address _account) private constant returns (bool) {
        AddressGroup_v0 addressGroup = AddressGroup_v0(cns.getLatestContract(ADDRESS_GROUP_CONTRACT_NAME));
        return addressGroup.isTargetAddress(_groupId, _account);
    }
}