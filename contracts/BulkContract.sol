pragma solidity ^0.4.2;

import "./DataObject_v0.sol";

contract BulkContract {
    bytes32 constant DATA_OBJECT_CONTRACT_NAME = bytes32('DataObject');
    ContractNameService cns;

    function BulkContract(ContractNameService _cns) {
        cns = _cns;
    }

    function getHashInDataObject(bytes32[] _ids) constant returns (bytes32[]) {
        DataObject_v0 dataObject = DataObject_v0(cns.getLatestContract(DATA_OBJECT_CONTRACT_NAME));
        bytes32[] memory hashes = new bytes32[](_ids.length);

        for (uint i; i<_ids.length; i++) {
            hashes[i] = dataObject.getHash(_ids[i]);
        }
        return hashes;
    }

    function isReaderInDataObject(bytes32[] _ids, address _account) constant returns (bool) {
        DataObject_v0 dataObject = DataObject_v0(cns.getLatestContract(DATA_OBJECT_CONTRACT_NAME));
        for (uint i; i<_ids.length; i++) {
            if (!dataObject.isReader(_ids[i], _account)) return false;
        }
        return true;
    }
}