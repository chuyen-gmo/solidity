module.exports = function(deployer) {
    deployer.deploy(DataObjectEvent_v1, ContractNameService.address).then(function() {
        return deployer.deploy(DataObjectField_v1, ContractNameService.address)
    }).then(function() {
        return deployer.deploy(DataObjectLogic_v1, ContractNameService.address, DataObjectField_v1.address, DataObjectEvent_v1.address, AddressGroup_v1.address);
    }).then(function() {
        return deployer.deploy(DataObject_v1, ContractNameService.address, DataObjectLogic_v1.address);
    }).then(function() {
        return ContractNameService.deployed().setContract('DataObject', 1, DataObject_v1.address, DataObjectLogic_v1.address);
    });
};
