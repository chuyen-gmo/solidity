pragma solidity ^0.4.2;

import "./CnsController.sol";

contract VersionField is CnsController {
    VersionField prevVersion;
    VersionField nextVersion;

    function VersionField (ContractNameService _cns, bytes32 _contractName) CnsController(_cns, _contractName) {}

    function setPrevVersion(VersionField _prevVersion) onlyByProvider {
        prevVersion = _prevVersion;
    }
    function setNextVersion(VersionField _nextVersions) onlyByProvider {
        nextVersion = _nextVersions;
    }

    modifier onlyByNextVersionOrVersionLogic() { if (!isVersionLogic() && msg.sender != Utils.toAddress(nextVersion)) throw; _; }

    /** PREPARE CURRENT VERSION */
    function prepare(bytes32 _id) onlyByNextVersionOrVersionLogic returns(bool) {
        if (existIdAtCurrentVersion(_id)) return true;
        if (Utils.isNull(prevVersion)) return false;
        if (!prevVersion.prepare(_id)) return false;
        setDefault(_id);
        return true;
    }

    function exist(bytes32 _id) constant returns(bool) {
        if (existIdAtCurrentVersion(_id)) return true;
        if (Utils.isNull(prevVersion)) return false;
        return prevVersion.exist(_id);
    }

    /** CHECK JUST ONLY PREV VERSION (IF NOT EXIST AT ALL THROW) */
    function existIdAtPrevVersion(bytes32 _id) constant returns(bool) {
        if (existIdAtCurrentVersion(_id)) return false;
        if (exist(_id)) return true;
        throw;
    }

    function existIdAtCurrentVersion(bytes32 _id) constant returns(bool);
    function setDefault(bytes32 _id) private;
}