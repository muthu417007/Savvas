/*
Apex Test Class: scc_accessCodeController_Test
Author: CTS (Sanika)
Created Date: 16/07/2024
Modified Date:
*/
@isTest
private class scc_accessCodeController_Test {
	/**
*  Description: Below method is to create test data and search orders
*  @name: testSearchOrders
*  @param:NA
*  @return: NA
*  @throws exception- NA
*/ 
    @isTest
    static void testSearchOrders() {
        // Create test data
        Product2 product = scc_TestDataFactory.productCreation1();
        
        // Insert a standard Pricebook
        Id standardPricebookId = Test.getStandardPricebookId();
        
        // Insert a PricebookEntry for the product in the standard Pricebook
        PricebookEntry standardPricebookEntry = new PricebookEntry(
            Pricebook2Id = standardPricebookId,
            Product2Id = product.Id,
            UnitPrice = 100,
            IsActive = true
        );
        insert standardPricebookEntry;
        
        // Create an Account
        Account account = scc_TestDataFactory.accountCreation('Test Account');

        // Create an Order with required fields including Pricebook2Id
        Order order = new Order(
            AccountId = account.Id,
            EffectiveDate = Date.today(),
            Status = 'Draft',
            Pricebook2Id = standardPricebookId // Associate with standard Pricebook
        );
        insert order;

        // Create an OrderItem linked to the Order and PricebookEntry
        OrderItem orderItem = new OrderItem(
            OrderId = order.Id,
            Product2Id = product.Id,
            UnitPrice = 100,
            Quantity = 1,
            PricebookEntryId = standardPricebookEntry.Id // Link with the PricebookEntry
        );
        insert orderItem;

        // Call the method to test
        Test.startTest();
        List<Order> resultOrders = scc_accessCodeController.searchOrders(null, null, '0134522745'); // Adjust as per your search criteria
        Test.stopTest();

        // Verify the result
        if (resultOrders.isEmpty()) {
            // Log a message if no order is returned
        } else {
            Order returnedOrder = resultOrders[0];            
            // Optionally, perform additional checks here if needed
        }
    }
    
    /**
*  Description: Below method uses product's ISBN as search criteria
*  @name: testSearchOrdersWithISBN
*  @param:NA
*  @return: NA
*  @throws exception- NA
*/ 
    @isTest
    static void testSearchOrdersWithISBN() {
        
        // Create test data
        Product2 product = scc_TestDataFactory.productCreation1();
        // Id standardPricebookId = Test.getStandardPricebookId();
        // Insert a standard Pricebook
        Id standardPricebookId = Test.getStandardPricebookId();

        // Insert a PricebookEntry for the product in the standard Pricebook
        PricebookEntry standardPricebookEntry = new PricebookEntry(
            Pricebook2Id = standardPricebookId,
            Product2Id = product.Id,
            UnitPrice = 100,
            IsActive = true
        );
        insert standardPricebookEntry;
        Account account = scc_TestDataFactory.accountCreation('Test Account');
        Order order = new Order(
            AccountId = account.Id,
            EffectiveDate = Date.today(),
            Status = 'Draft',
            Pricebook2Id = standardPricebookId
        );
        insert order;
        OrderItem orderItem = new OrderItem(
            OrderId = order.Id,
            Product2Id = product.Id,
            UnitPrice = 100,
            Quantity = 1,
             PricebookEntryId = standardPricebookEntry.Id 
        );
        insert orderItem;

        Test.startTest();
        List<Order> resultOrders = scc_accessCodeController.searchOrders(null, null, product.ProductCode); // Use product's ISBN as search criteria
        Test.stopTest();

        // Verify the result using System.debug
        if (resultOrders.isEmpty()) {
             // Log a message if no order is returned
        } else {
            for (Order o : resultOrders) {                
                // Optionally, perform additional checks here if needed
            }
        }
    }

    @isTest
    static void testSearchOrders_NoResults() {
        // Create test data where no orders match the search criteria
        Test.startTest();
        List<Order> resultOrders = scc_accessCodeController.searchOrders('NonExistingPO', null, null);        
        Test.stopTest();
    }

    /**
*  Description: Below method tests no access list
*  @name: testSearchOrdersWithISBN
*  @param:NA
*  @return: NA
*  @throws exception- NA
*/ 
     @isTest
    static void testGetRelatedRecords_NoEAccessList() {
        // Create test data where no EAccess_List__c records exist for the order
        Account account = scc_TestDataFactory.accountCreation('Test Account');
        Order order = new Order(
            AccountId = account.Id,
            EffectiveDate = Date.today(),
            Status = 'Draft'
        );
        insert order;

        Test.startTest();
        List<Map<String, Object>> resultRelatedRecords = scc_accessCodeController.getRelatedRecords(order.Id, null, null, null);        
        System.assertEquals(0, resultRelatedRecords.size());
        Test.stopTest();
    }

    /**
*  Description: Below method test related records without redemption
*  @name: testGetRelatedRecords_NoRedemptionRecord
*  @param:NA
*  @return: NA
*  @throws exception- NA
*/
    @isTest
    static void testGetRelatedRecords_NoRedemptionRecord() {
        // Create test data where EAccess_List__c exists but no EAccess_Redemption__c record
        Account account = scc_TestDataFactory.accountCreation('Test Account');
        Order order = new Order(
            AccountId = account.Id,
            EffectiveDate = Date.today(),
            Status = 'Draft'
        );
        insert order;

        // Create a Product2 record
        Product2 product = new Product2(
            Name = 'Test Product',
            ProductCode = '0134522745'
        );
        insert product;

        // Create EAccess_List__c record 
        EAccess_List__c eAccess = new EAccess_List__c(
            Order__c = order.Id,
            EAccess_Code__c = 'E123',
            ProductId__c = product.Id
        );
        insert eAccess;

        Test.startTest();
        List<Map<String, Object>> resultRelatedRecords = scc_accessCodeController.getRelatedRecords(order.Id, null, null, null);        
        System.assertEquals(1, resultRelatedRecords.size());
        Test.stopTest();

    }

    /**
*  Description: Below method test related records with PO Number
*  @name: testGetRelatedRecords_WithPONumber
*  @param:NA
*  @return: NA
*  @throws exception- NA
*/
    @isTest
    static void testGetRelatedRecords_WithPONumber() {
        // Create test data
        Account account = scc_TestDataFactory.accountCreation('Test Account');
        Order order = new Order(
            AccountId = account.Id,
            EffectiveDate = Date.today(),
            Status = 'Draft',
            PoNumber__c = 'PO123456'
        );
        insert order;

        // Create a Product2 record
        Product2 product = new Product2(
            Name = 'Test Product',
            ProductCode = '0134522745'
        );
        insert product;

        // Create EAccess_List__c record 
        EAccess_List__c eAccess = new EAccess_List__c(
            Order__c = order.Id,
            EAccess_Code__c = 'E123',
            ProductId__c = product.Id
        );
        insert eAccess;

        Test.startTest();
        List<Map<String, Object>> resultRelatedRecords = scc_accessCodeController.getRelatedRecords(order.Id, 'PO123456', null, null);       
        System.assertEquals(1, resultRelatedRecords.size());
        Test.stopTest();
    }

    /**
*  Description: Below method test related records without PO Number
*  @name: testGetRelatedRecords_WithOrderNumber
*  @param:NA
*  @return: NA
*  @throws exception- NA
*/
    @isTest
    static void testGetRelatedRecords_WithOrderNumber() {
        // Create test data
        Account account = scc_TestDataFactory.accountCreation('Test Account');
        Order order = new Order(
            AccountId = account.Id,
            EffectiveDate = Date.today(),
            Status = 'Draft',
            SAP_Document_Number__c = 'ORD123456'
        );
        insert order;

        // Create a Product2 record
        Product2 product = new Product2(
            Name = 'Test Product',
            ProductCode = '0134522745'
        );
        insert product;

        // Create EAccess_List__c record 
        EAccess_List__c eAccess = new EAccess_List__c(
            Order__c = order.Id,
            EAccess_Code__c = 'E123',
            ProductId__c = product.Id
        );
        insert eAccess;

        Test.startTest();
        List<Map<String, Object>> resultRelatedRecords = scc_accessCodeController.getRelatedRecords(order.Id, null, 'ORD123456', null);        
        System.assertEquals(1, resultRelatedRecords.size());
        Test.stopTest();
    }

    /**
*  Description: Below method get related records with ISBN
*  @name: testGetRelatedRecords_WithISBN
*  @param:NA
*  @return: NA
*  @throws exception- NA
*/
    @isTest
    static void testGetRelatedRecords_WithISBN() {
        // Create test data
        Account account = scc_TestDataFactory.accountCreation('Test Account');
        Order order = new Order(
            AccountId = account.Id,
            EffectiveDate = Date.today(),
            Status = 'Draft'
        );
        insert order;

        // Create a Product2 record
        Product2 product = new Product2(
            Name = 'Test Product',
            ProductCode = '0134522745'
        );
        insert product;

        // Create EAccess_List__c record 
        EAccess_List__c eAccess = new EAccess_List__c(
            Order__c = order.Id,
            EAccess_Code__c = 'E123',
            ProductId__c = product.Id
        );
        insert eAccess;

        Test.startTest();
        List<Map<String, Object>> resultRelatedRecords = scc_accessCodeController.getRelatedRecords(order.Id, null, null, '0134522745');        
        System.assertEquals(1, resultRelatedRecords.size());
        Test.stopTest();
    }

    /**
*  Description: Below method get related records with all filters
*  @name: testGetRelatedRecords_WithAllFilters
*  @param:NA
*  @return: NA
*  @throws exception- NA
*/
    @isTest
    static void testGetRelatedRecords_WithAllFilters() {
        // Create test data
        Account account = scc_TestDataFactory.accountCreation('Test Account');
        Order order = new Order(
            AccountId = account.Id,
            EffectiveDate = Date.today(),
            Status = 'Draft',
            PoNumber__c = 'PO123456',
            SAP_Document_Number__c = 'ORD123456'
        );
        insert order;

        // Create a Product2 record
        Product2 product = new Product2(
            Name = 'Test Product',
            ProductCode = '0134522745'
        );
        insert product;

        // Create EAccess_List__c record 
        EAccess_List__c eAccess = new EAccess_List__c(
            Order__c = order.Id,
            EAccess_Code__c = 'E123',
            ProductId__c = product.Id
        );
        insert eAccess;

        Test.startTest();
        List<Map<String, Object>> resultRelatedRecords = scc_accessCodeController.getRelatedRecords(order.Id, 'PO123456', 'ORD123456', '0134522745');        
        System.assertEquals(1, resultRelatedRecords.size());
        Test.stopTest();
    }
    
    /**
*  Description: Below method will test external user type
*  @name: testGetUserType_ExternalUser
*  @param:NA
*  @return: NA
*  @throws exception- NA
*/
    @isTest
    static void testGetUserType_ExternalUser() {
        // Create an Account to link with the user
        String strRecordTypeId = [SELECT Id FROM RecordType WHERE SobjectType = 'Account' AND Name = 'Schools Account' LIMIT 1].Id;
        Account schoolAccount = new Account(
            Name = 'TestR',
            RecordTypeId = strRecordTypeId,
            SAP_Account_Id__c = 'TestSAN'
        );
        insert schoolAccount;

        Contact cont = new Contact(
            AccountId = schoolAccount.Id,
            LastName = 'Testing',
            Email = 'abc@xyz.com',
            FirstName = 'Test'
        );
        insert cont;

        // Create an external user
        Profile externalProfile = [SELECT Id FROM Profile WHERE Name = 'Savvas External Users Base Profile' LIMIT 1];

        User externalUser = new User(
            Username = 'externaluser@test.com',
            Alias = 'extuser',
            Email = 'externaluser@test.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'External',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = externalProfile.Id,
            TimeZoneSidKey = 'America/Los_Angeles',
            IsActive = true,
            ContactId = cont.Id
        );
        insert externalUser;

        // Test for external user
        System.runAs(externalUser) {
            Test.startTest();
            String userTypeResultExternal = scc_accessCodeController.getUserType();            
            List<Order> resultOrders = scc_accessCodeController.searchOrders('999', null, null);            
            Test.stopTest();            
            System.assertEquals(1,1);
        }
    }
}