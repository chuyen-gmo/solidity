module.exports = function(deployer) {
    return deployer.deploy(FileObjectEvent_v0, ContractNameService.address).then(function() {
        return deployer.deploy(FileObjectField_v0, ContractNameService.address);
    }).then(function() {
        return deployer.deploy(FileObjectLogic_v0, ContractNameService.address);
    }).then(function() {
        return deployer.deploy(FileObject_v0, ContractNameService.address, FileObjectLogic_v0.address);
    }).then(function() {
        return FileObjectLogic_v0.deployed().setFileObjectEvent_v0(FileObjectEvent_v0.address)
    }).then(function() {
        return FileObjectLogic_v0.deployed().setFileObjectField_v0(FileObjectField_v0.address);
    }).then(function() {
        return ContractNameService.deployed().setContract('FileObject', 0, FileObject_v0.address, FileObjectLogic_v0.address);
    });
}