module.exports = function(deployer) {
    deployer.deploy(BulkContract, DataObject_v1.address, DataObject_v2.address);
};
