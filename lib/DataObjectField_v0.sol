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
    }

    mapping (bytes32 => Field) private fields;

    function DataObjectField_v0(ContractNameService _cns) VersionField(_cns, CONTRACT_NAME) {}

    function create(
        bytes32 _id,
        address _creator,
        address _owner,
        bytes32[3] _hashes,
        bytes32 _readerId,
        bytes32 _writerId
    ) onlyByNextVersionOrVersionLogic returns(bool){
        if (exist(_id)) return false;
        fields[_id] = Field(_creator, _owner, _hashes, _readerId, _writerId);
        return true;
    }

    function remove(bytes32 _id) onlyByNextVersionOrVersionLogic returns(bool){
        if (!exist(_id)) return false;
        fields[_id] = Field(0, 0, BLANK_HASHES, BLANK_BYTES32, BLANK_BYTES32);
        return true;
    }

    function getCreator(bytes32 _id) onlyByNextVersionOrVersionLogic constant returns(address) {
        if (existIdAtPrevVersion(_id)) return 0;
        return fields[_id].creator;
    }

    function setCreator(bytes32 _id, address _creator) onlyByNextVersionOrVersionLogic {
        if (!prepare(_id)) throw;
        fields[_id].creator = _creator;
    }

    function getOwner(bytes32 _id) onlyByNextVersionOrVersionLogic constant returns(address) {
        if (existIdAtPrevVersion(_id)) return 0;
        return fields[_id].owner;
    }

    function setOwner(bytes32 _id, address _owner) onlyByNextVersionOrVersionLogic {
        if (!prepare(_id)) throw;
        fields[_id].owner = _owner;
    }

    function getHash(bytes32 _id, uint _idx) onlyByNextVersionOrVersionLogic constant returns(bytes32) {
        if (existIdAtPrevVersion(_id)) return 0;
        return fields[_id].hashes[_idx];
    }

    function setHash(bytes32 _id, uint _idx, bytes32 _hash) onlyByNextVersionOrVersionLogic {
        if (!prepare(_id)) throw;
        fields[_id].hashes[_idx] = _hash;
    }

    function getReaderId(bytes32 _id) onlyByNextVersionOrVersionLogic constant returns(bytes32) {
        if (existIdAtPrevVersion(_id)) return 0;
        return fields[_id].readerId;
    }

    function setReaderId(bytes32 _id, bytes32 _readerId) onlyByNextVersionOrVersionLogic {
        if (!prepare(_id)) throw;
        fields[_id].readerId = _readerId;
    }

    function getWriterId(bytes32 _id) onlyByNextVersionOrVersionLogic constant returns(bytes32) {
        if (existIdAtPrevVersion(_id)) return 0;
        return fields[_id].writerId;
    }

    function setWriterId(bytes32 _id, bytes32 _writerId) onlyByNextVersionOrVersionLogic {
        if (!prepare(_id)) throw;
        fields[_id].writerId = _writerId;
    }

    function existIdAtCurrentVersion(bytes32 _id) constant returns(bool) { return fields[_id].creator != 0; }
    function setDefault(bytes32 _id) private { /* do nothing on version 0 */ }
}