@isTest
private class PortalUserProvisioningTest {

    static testMethod void myUnitTest() {
    	PortalTestHelper.setEnv();
        List<Contact> contacts = PortalTestHelper.createContacts(200);
    	insert contacts;
    	
    	test.startTest();
    	
    	database.executeBatch(new PortalUserProvisioning('FirstName = \'John\'', 'test' ));
    	
    	// now cover errors path.  since the user records already exist, another update will cause errors.
    	database.executeBatch(new PortalUserProvisioning('FirstName = \'John\'', 'test' ));
    	
    	test.stopTest();
    }
    
}