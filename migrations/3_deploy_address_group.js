module.exports = function(deployer) {
    deployer.deploy(AddressGroupEvent_v1, ContractNameService.address).then(function() {
        return deployer.deploy(AddressGroupField_v1, ContractNameService.address);
    }).then(function() {
        return deployer.deploy(AddressGroupLogic_v1, ContractNameService.address, AddressGroupField_v1.address, AddressGroupEvent_v1.address);
    }).then(function() {
        return deployer.deploy(AddressGroup_v1, ContractNameService.address, AddressGroupLogic_v1.address);
    }).then(function() {
        return ContractNameService.deployed().setContract('AddressGroup', 1, AddressGroup_v1.address, AddressGroupLogic_v1.address);
    });
};
