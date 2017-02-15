pragma solidity ^0.4.2;

import "./AddressGroup.sol";
import "./AddressGroupEvent_v0.sol";
import "./AddressGroupField_v0.sol";
import "./VersionLogic.sol";

contract AddressGroupLogic_v0 is VersionLogic, AddressGroup {
    AddressGroupField_v0 field_v0;
    AddressGroupEvent_v0 event_v0;

    function AddressGroupLogic_v0(ContractNameService _cns) VersionLogic(_cns, CONTRACT_NAME) {}

    function setAddressGroupField_v0(AddressGroupField_v0 _field) onlyByProvider { field_v0 = _field; }
    function setAddressGroupEvent_v0(AddressGroupEvent_v0 _event) onlyByProvider { event_v0 = _event; }

    modifier onlyFromOwnerOrAllowCnsContractLogic(address _sender, bytes32 _id) {
        if (field_v0.getOwner(_id) != _sender) {
            VersionLogic logic = VersionLogic(_sender);
            if (!field_v0.isAllowCnsContract(_id, logic.getCns(), logic.getContractName())) throw;
            if (!logic.getCns().isVersionLogic(_sender, logic.getContractName())) throw;
        }
        _;
    }

    modifier onlyFromCreator(address _sender, bytes32 _id) { if (field_v0.getCreator(_id) != _sender) throw; _; }

    function create(address _sender, bytes32 _id, address _owner, address[] _addrs) onlyByVersionContractOrLogic returns (bool _b) {
        _b = field_v0.create(_id, _sender, _owner);
        if (_b) event_v0.createAddressGroup(_id, _sender);
        for (uint _i = 0; _i < _addrs.length; _i++) {
            event_v0.modifyAddress(_id, 1, _addrs[_i]);
            field_v0.setTargetAddress(_id, _addrs[_i], true);
        }
    }

    function setOwner(address _sender, bytes32 _id, address _owner) onlyByVersionContractOrLogic onlyFromCreator(_sender, _id) {
        field_v0.setOwner(_id, _owner);
    }

    function setAllowCnsContract(address _sender, bytes32 _id, address _cns, bytes32 _contractName) onlyByVersionContractOrLogic onlyFromOwnerOrAllowCnsContractLogic(_sender, _id) returns (bool) {
        if (field_v0.isAllowCnsContract(_id, _cns, _contractName)) return false;
        field_v0.setAllowCnsContract(_id, _cns, _contractName, true);
        return true;
    }

    function removeAllowCnsContract(address _sender, bytes32 _id, address _cns, bytes32 _contractName) onlyByVersionContractOrLogic onlyFromOwnerOrAllowCnsContractLogic(_sender, _id) returns (bool) {
        if (field_v0.isAllowCnsContract(_id, _cns, _contractName)) return false;
        field_v0.setAllowCnsContract(_id, _cns, _contractName, false);
        return true;
    }

    function addAddress(address _sender, bytes32 _id, address _targetAddr) onlyByVersionContractOrLogic onlyFromOwnerOrAllowCnsContractLogic(_sender, _id) returns (bool) {
        return setTargetAddress(_id, _targetAddr, true);
    }

    function removeAddress(address _sender, bytes32 _id, address _targetAddr) onlyByVersionContractOrLogic onlyFromOwnerOrAllowCnsContractLogic(_sender, _id) returns (bool) {
        return setTargetAddress(_id, _targetAddr, false);
    }

    function appendChild(address _sender, bytes32 _id, bytes32 _childId) onlyByVersionContractOrLogic onlyFromOwnerOrAllowCnsContractLogic(_sender, _id) {
        field_v0.appendChild(_id, _childId);
    }

    function removeChild(address _sender, bytes32 _id, bytes32 _childId) onlyByVersionContractOrLogic onlyFromOwnerOrAllowCnsContractLogic(_sender, _id) {
        field_v0.removeChild(_id, _childId);
    }

    function setTargetAddress(bytes32 _id, address _targetAddr, bool _isAdded) private returns(bool) {
        if (field_v0.isTargetAddress(_id, _targetAddr) == _isAdded) return false;
        field_v0.setTargetAddress(_id, _targetAddr, _isAdded);
        uint modifyType = 1;
        if (!_isAdded) {
            modifyType = 2;
        }
        event_v0.modifyAddress(_id, modifyType, _targetAddr);
        return true;
    }

    function isTargetAddress(bytes32 _id, address _targetAddr) onlyByVersionContractOrLogic constant returns (bool) {
        return field_v0.isTargetAddress(_id, _targetAddr);
    }
}
