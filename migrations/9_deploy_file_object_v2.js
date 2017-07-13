module.exports = function(deployer) {
    deployer.deploy(FileObjectField_v2, ContractNameService.address).then(function() {
        return FileObjectField_v2.deployed().setPrevVersion(FileObjectField_v1.address);
    }).then(function() {
        return FileObjectField_v1.deployed().setNextVersion(FileObjectField_v2.address);
    }).then(function(){
        return deployer.deploy(FileObjectLogic_v2, ContractNameService.address, FileObjectField_v1.address, FileObjectField_v2.address, FileObjectEvent_v1.address, DataObject_v2.address, AddressGroup_v1.address);
    }).then(function() {
        return deployer.deploy(FileObject_v2, ContractNameService.address, FileObjectLogic_v1.address, FileObjectLogic_v2.address);
    }).then(function() {
        return ContractNameService.deployed().setContract('FileObject', 2, FileObject_v2.address, FileObjectLogic_v2.address);
    });
};
