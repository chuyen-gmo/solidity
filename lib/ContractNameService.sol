pragma solidity ^0.4.2;

import "./Utils.sol";

contract ContractNameService {
    address provider = msg.sender;
    event SetContract(bytes32 indexed name, uint version, address indexed main, address indexed logic);

    struct ContractSet {
        address main;
        address logic;
    }

    mapping (bytes32 => ContractSet[]) contracts;

    modifier onlyByProvider() { if (msg.sender != provider) throw; _; }

    function setContract(bytes32 _name, uint _version, address _main, address _logic) onlyByProvider {
        if (Utils.isNull(_main)) throw;
        if (Utils.isNull(_logic)) throw;
        if (contracts[_name].length < _version) throw;

        ContractSet memory set = ContractSet(_main, _logic);
        if (contracts[_name].length == _version) {
            contracts[_name].push(set);
        } else {
            contracts[_name][_version] = set;
        }
        SetContract(_name, _version, _main, _logic);
    }

    function isVersionContract(address _sender, bytes32 _name) constant returns(bool) {
        if (Utils.isNull(_sender)) throw;
        for (uint i = 0; i < contracts[_name].length; i++) {
            if (contracts[_name][i].main == _sender) return true;
        }
        return false;
    }

    function isVersionLogic(address _sender, bytes32 _name) constant returns(bool) {
        if (Utils.isNull(_sender)) throw;
        for (uint i = 0; i < contracts[_name].length; i++) {
            if (contracts[_name][i].logic == _sender) return true;
        }
        return false;
    }

    function getContract(bytes32 _name, uint _version) constant returns (address) {
        if (getLatestVersion(_name) < _version) throw;
        return contracts[_name][_version].main;
    }

    function getLatestVersion(bytes32 _name) constant returns (uint) {
        if (contracts[_name].length == 0) throw;
        return contracts[_name].length - 1;
    }

    function getLatestContract(bytes32 _name) constant returns (address) {
        return getContract(_name, getLatestVersion(_name));
    }

    function() { throw; }
}