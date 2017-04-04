pragma solidity ^0.4.2;

import "./DataObject_v1.sol";

contract BulkContract {
    DataObject_v1 dataObject_v1;

    function BulkContract(DataObject_v1 _dataObject) {
        dataObject_v1 = _dataObject;
    }

    function getHashInDataObject(bytes32[] _ids) constant returns (bytes32[]) {
        bytes32[] memory hashes = new bytes32[](_ids.length);

        for (uint i; i<_ids.length; i++) {
            hashes[i] = dataObject_v1.getHash(_ids[i]);
        }
        return hashes;
    }

    function canReadInDataObject(address _account, bytes32[] _ids) constant returns (bool) {
        for (uint i; i<_ids.length; i++) {
            if (!dataObject_v1.canRead(_account, _ids[i])) return false;
        }
        return true;
    }
}