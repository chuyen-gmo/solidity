module.exports = function(deployer) {
    deployer.deploy(FileObjectEvent_v1, ContractNameService.address).then(function() {
        return deployer.deploy(FileObjectField_v1, ContractNameService.address)
    }).then(function() {
        return deployer.deploy(FileObjectLogic_v1, ContractNameService.address, FileObjectField_v1.address, FileObjectEvent_v1.address, DataObject_v1.address, AddressGroup_v1.address);
    }).then(function() {
        return deployer.deploy(FileObject_v1, ContractNameService.address, FileObjectLogic_v1.address);
    }).then(function() {
        return ContractNameService.deployed().setContract('FileObject', 1, FileObject_v1.address, FileObjectLogic_v1.address);
    });
};
