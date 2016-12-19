pragma solidity ^0.4.2;

import "./CnsController.sol";

contract VersionLogic is CnsController {
    function VersionLogic (ContractNameService _cns, bytes32 _contractName) CnsController(_cns, _contractName) {}

    modifier onlyFromProvider(address _sender) { if (_sender != provider) throw; _; }
}
