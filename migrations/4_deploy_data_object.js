module.exports = function(deployer) {
    deployer.deploy(DataObjectEvent_v0, ContractNameService.address).then(function() {
        return deployer.deploy(DataObjectField_v0, ContractNameService.address);
    }).then(function() {
        return deployer.deploy(DataObjectLogic_v0, ContractNameService.address);
    }).then(function() {
        return deployer.deploy(DataObject_v0, ContractNameService.address, DataObjectLogic_v0.address);
    }).then(function() {
        return DataObjectLogic_v0.deployed().setDataObjectEvent_v0(DataObjectEvent_v0.address)
    }).then(function() {
        return DataObjectLogic_v0.deployed().setDataObjectField_v0(DataObjectField_v0.address);
    }).then(function() {
        return ContractNameService.deployed().setContract('DataObject', 0, DataObject_v0.address, DataObjectLogic_v0.address);
    });
};
