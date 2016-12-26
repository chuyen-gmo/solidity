pragma solidity ^0.4.2;

import "./FileObject.sol";
import "./VersionEvent.sol";

contract FileObjectEvent_v0 is VersionEvent, FileObject {
    function FileObjectEvent_v0(ContractNameService _cns) VersionEvent(_cns, CONTRACT_NAME) {}

    event CreateFileObject(address indexed _creator, bytes32 indexed _id);
    event SetHash(address indexed _sender, bytes32 indexed _id, uint _idx, bytes32 indexed_hash);

    function create(address _creator, bytes32 _id) onlyByVersionLogic { CreateFileObject(_creator, _id); }
    function setHash(address _sender, bytes32 _id, uint _idx, bytes32 _hash) onlyByVersionLogic { SetHash(_sender, _id, _idx, _hash); }
}