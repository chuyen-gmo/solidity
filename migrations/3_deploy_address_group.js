module.exports = function(deployer) {
    deployer.deploy(AddressGroupEvent_v0, ContractNameService.address).then(function() {
        return deployer.deploy(AddressGroupField_v0, ContractNameService.address);
    }).then(function() {
        return deployer.deploy(AddressGroupLogic_v0, ContractNameService.address);
    }).then(function() {
        return deployer.deploy(AddressGroup_v0, ContractNameService.address, AddressGroupLogic_v0.address);
    }).then(function() {
        return AddressGroupLogic_v0.deployed().setAddressGroupEvent_v0(AddressGroupEvent_v0.address);
    }).then(function() {
        return AddressGroupLogic_v0.deployed().setAddressGroupField_v0(AddressGroupField_v0.address);
    }).then(function() {
        return ContractNameService.deployed().setContract('AddressGroup', 0, AddressGroup_v0.address, AddressGroupLogic_v0.address);
    });
};
