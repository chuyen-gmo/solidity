pragma solidity ^0.4.2;

import "./AddressGroup.sol";
import "./VersionEvent.sol";

contract AddressGroupEvent_v0 is VersionEvent, AddressGroup {
    function AddressGroupEvent_v0 (ContractNameService _cns) VersionEvent(_cns, CONTRACT_NAME) {}

    event CreateAddressGroup(address indexed _creator, bytes32 indexed _id);
    /* type : 1=add 2=remove */
    event ModifyAddress(bytes32 indexed _id, uint indexed _type, address _addr);
    /* type : 1=set 2=remove */
    event ModifyAllowCnsContract(bytes32 indexed _id, uint indexed _type, address indexed _cns, bytes32 _contractName);

    function createAddressGroup(bytes32 _id, address _creator) onlyByVersionLogic { CreateAddressGroup(_creator, _id); }
    function modifyAddress(bytes32 _id, uint _type, address _addr) onlyByVersionLogic { ModifyAddress(_id, _type, _addr); }
    function modifyAllowCnsContract(bytes32 _id, uint _type, address _cns, bytes32 _contractName) onlyByVersionLogic { ModifyAllowCnsContract(_id, _type, _cns, _contractName); }
}