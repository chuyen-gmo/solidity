module.exports = function(deployer) {
    deployer.deploy(DataObjectField_v2, ContractNameService.address).then(function() {
        return DataObjectField_v2.deployed().setPrevVersion(DataObjectField_v1.address);
    }).then(function() {
        return DataObjectField_v1.deployed().setNextVersion(DataObjectField_v2.address);
    }).then(function(){
        return deployer.deploy(DataObjectLogic_v2, ContractNameService.address, DataObjectField_v1.address, DataObjectField_v2.address, DataObjectEvent_v1.address, AddressGroup_v1.address);
    }).then(function() {
        return deployer.deploy(DataObject_v2, ContractNameService.address, DataObjectLogic_v1.address, DataObjectLogic_v2.address);
    }).then(function() {
        return ContractNameService.deployed().setContract('DataObject', 2, DataObject_v2.address, DataObjectLogic_v2.address);
    });
};
