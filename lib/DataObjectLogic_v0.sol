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

    function create(address _sender, bytes32 _id, address _owner, bytes32 _hash, address _cns, bytes32 _contractName) onlyByVersionContractOrLogic {
        bytes32[3] memory hashes;
        hashes[2] = _hash;
        AddressGroup_v0 addressGroup = AddressGroup_v0(cns.getLatestContract(ADDRESS_GROUP_CONTRACT_NAME));

        bytes32 readerId = Utils.transferUniqueId(_id);
        bytes32 writerId = Utils.transferUniqueId(readerId);
        if (!addressGroup.create(readerId, this, BLANK_ADDRESS_ARRAY)) throw;
        if (!addressGroup.create(writerId, this, BLANK_ADDRESS_ARRAY)) throw;
        addressGroup.setAllowCnsContract(readerId, _cns, _contractName);
        addressGroup.setAllowCnsContract(writerId, _cns, _contractName);
        if (!field_v0.create(_id, _sender, _owner, hashes, readerId, writerId)) throw;
        field_v0.setAllowCnsContract(_id, _cns, _contractName, true);
        event_v0.create(_sender, _id);
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

    function getWriterId(bytes32 _id) onlyByVersionContractOrLogic constant returns (bytes32) {
        return field_v0.getWriterId(_id);
    }

    function setWriterId(address _sender, bytes32 _id, bytes32 _readerId) onlyByVersionContractOrLogic onlyFromOwnerOrAllowCnsContractLogic(_sender, _id) {
        field_v0.setWriterId(_id, _readerId);
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