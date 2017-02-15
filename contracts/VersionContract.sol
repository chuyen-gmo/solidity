pragma solidity ^0.4.2;

import "./CnsController.sol";
import "./VersionLogic.sol";

contract VersionContract is CnsController {
    VersionContract prevVersion;
    VersionContract nextVersion;
    uint amount;

    modifier onlyByProvider() { if (msg.sender != provider) throw; _; }
    modifier onlyByNextVersion() { if (msg.sender != address(nextVersion)) throw; _; }
    modifier onlyByPrevVersion() { if (msg.sender != address(prevVersion)) throw; _; }

    function VersionContract(ContractNameService _cns, bytes32 _contractName) CnsController(_cns, _contractName) {}

    function setPrevVersion(VersionContract _prevVersion) onlyByProvider {
        prevVersion = _prevVersion;
    }

    function setNextVersion(VersionContract _nextVersion) onlyByProvider {
        nextVersion = _nextVersion;
    }

    function calcEnvHash(bytes32 _function) internal constant returns(bytes32) {
        bytes32 h = sha3(cns);
        h = sha3(h, contractName);
        h = sha3(h, _function);
        return h;
    }

    function sendValue(address _to, uint _value) onlyByVersionLogic {
        if (_value <= this.balance) { sendOrThrow(_to, _value); return; }
        if (getBalance() < _value) throw;
        uint remainder = _value - this.balance;
        if (Utils.isNotNull(prevVersion)) {
            remainder -= prevVersion.gatherValueFromAncestor(this, remainder);
        }
        if (Utils.isNotNull(nextVersion)) {
            remainder -= nextVersion.gatherValueFromDescendant(this, remainder);
        }
        sendOrThrow(_to, _value);
    }

    function gatherValueFromAncestor(VersionContract _this, uint _value) onlyByNextVersion returns (uint) {
        if (_value <= this.balance) {
            internalSend(_this, _value);
            return _value;
        } else {
            uint sendedBalance = this.balance;
            internalSend(_this, sendedBalance);
            if (Utils.isNotNull(prevVersion)) {
                return sendedBalance + prevVersion.gatherValueFromAncestor(_this, _value - sendedBalance);
            } else {
                return sendedBalance;
            }
        }
    }

    function gatherValueFromDescendant(VersionContract _this, uint _value) onlyByPrevVersion returns (uint) {
        if (_value <= this.balance) {
            internalSend(_this, _value);
            return _value;
        } else {
            uint sendedBalance = this.balance;
            internalSend(_this, sendedBalance);
            if (Utils.isNotNull(nextVersion)) {
                return sendedBalance + nextVersion.gatherValueFromDescendant(_this, _value - this.balance);
            } else {
                return sendedBalance;
            }
        }
    }

    function internalSend(VersionContract _to, uint _value) private {
        _to.internalReceive.value(_value)();
        amount -= _value;
    }

    function internalReceive() onlyByVersionContract payable {
        amount += msg.value;
    }

    function sendOrThrow(address _to, uint _value) private {
        if (!_to.send(_value)) throw;
        amount -= _value;
    }

    function getBalance() constant returns (uint) {
        uint b = this.balance;
        if (Utils.isNotNull(prevVersion)) { b += prevVersion.getAncestorBalance(); }
        if (Utils.isNotNull(nextVersion)) { b += nextVersion.getDescendantBalance(); }
        return b;
    }

    function getAncestorBalance() constant returns (uint) {
        if (Utils.isNotNull(prevVersion)) {
            return prevVersion.getAncestorBalance() + this.balance;
        }
        return this.balance;
    }

    function getDescendantBalance() constant returns (uint) {
        if (Utils.isNotNull(nextVersion)) {
            return nextVersion.getDescendantBalance() + this.balance;
        }
        return this.balance;
    }

    function() { throw; }
}