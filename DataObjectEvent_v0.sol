pragma solidity ^0.4.2;

import "./DataObject.sol";
import "./VersionEvent.sol";

contract DataObjectEvent_v0 is VersionEvent, DataObject {
    function DataObjectEvent_v0(ContractNameService _cns) VersionEvent(_cns, CONTRACT_NAME) {}

    event CreateDataObject(address indexed _creator, bytes32 indexed _id);
    event SetHash(address indexed _sender, bytes32 indexed _id, uint _idx, bytes32 indexed_hash);

    function createDataObject(address _creator, bytes32 _id) onlyByVersionLogic { CreateDataObject(_creator, _id); }
    function setHashEvent(address _sender, bytes32 _id, uint _idx, bytes32 _hash) onlyByVersionLogic { SetHash(_sender, _id, _idx, _hash); }
}