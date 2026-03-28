/*
Apex Test Class: scc_productTitlePage_ControllerTest
Author: CTS (Sanika Sol)
Created Date: 04/04/2024
Modified Date: 17/10/2024
*/
@isTest
private class scc_productTitlePage_ControllerTest {
    /**
*  Description:  Below method is test method that tests restriction description should not null
*  @name: testGetRestrictionDescription
*  @param:NA
*  @return: NA
*  @throws exception- NA
*/ 
    @isTest
    static void testGetRestrictionDescription() {
        Product2 testProduct = new Product2(
            Name = 'Test Product', 
            Sales_Restriction_Code__c = '01');
        insert testProduct;
        
        Test.startTest();
        String restrictionDescription = scc_productTitlePage_Controller.getRestrictionDescription(testProduct.Id);
        Test.stopTest();
        
        System.assertNotEquals(null, restrictionDescription, 'Restriction description should not be null');
    }
    
    /**
*  Description: Below method is test method that tests restriction description should not be empty
*  @name: testGetRestrictionDescription_NoMatchingMetadata
*  @param:NA
*  @return: NA
*  @throws exception- NA
*/ 
    @isTest
    static void testGetRestrictionDescription_NoMatchingMetadata() {
        Product2 testProduct = new Product2(
            Name = 'Test Product', 
            Sales_Restriction_Code__c = 'ABC');
        insert testProduct;
        
        Test.startTest();
        String restrictionDescription = scc_productTitlePage_Controller.getRestrictionDescription(testProduct.Id);
        Test.stopTest();
        
        System.assertEquals('', restrictionDescription, 'Restriction description should be empty');
    }
    
    /**
*  Description: Below method is test method that tests restriction description should not be empty for null product Id
*  @name: testGetRestrictionDescription_NullProductId
*  @param:NA
*  @return: NA
*  @throws exception- NA
*/ 
    @isTest
    static void testGetRestrictionDescription_NullProductId() {
        Test.startTest();
        String restrictionDescription = scc_productTitlePage_Controller.getRestrictionDescription(null);
        Test.stopTest();
        
        System.assertEquals('', restrictionDescription, 'Restriction description should be empty for null product Id');
    }
    
    /**
*  Description: Below method is test method that tests restriction description should be empty for null when an exception occurs
*  @name: testGetRestrictionDescription_Exception
*  @param:NA
*  @return: NA
*  @throws exception- NA
*/ 
    @isTest
    static void testGetRestrictionDescription_Exception() {
        Test.startTest();
        String restrictionDescription = scc_productTitlePage_Controller.getRestrictionDescription(UserInfo.getUserId());
        Test.stopTest();
        
        System.assertEquals('', restrictionDescription, 'Restriction description should be empty when an exception occurs');
    }
    
    /**
*  Description: Below method is test method that gets product details
*  @name: testGetProductDetails
*  @param:NA
*  @return: NA
*  @throws exception- NA
*/ 
    @isTest
    static void testGetProductDetails() {
        Product2 testProduct = new Product2(
            Name = 'Test Product',
            Grade_Range__c = '1-3',
            Availability__c = 'In Stock',
            IsActive = true,
            Carton_Quantity__c = 10,
            Rights_Restriction_Code__c = 'R01',
            Sales_Restriction_Code__c = 'S01'
        );
        insert testProduct;
        
        Test.startTest();
        Product2 productDetails = scc_productTitlePage_Controller.getProductDetails(testProduct.Id);
        Test.stopTest();
        
        System.assertNotEquals(null, productDetails, 'Product details should not be null');
        System.assertEquals(testProduct.Id, productDetails.Id, 'Product Id should match');
        System.assertEquals(testProduct.Name, productDetails.Name, 'Product Name should match');
    }
    
    /**
*  Description: Below method is test method that tests Product details should be null for null product Id
*  @name: testGetProductDetails_NullProductId
*  @param:NA
*  @return: NA
*  @throws exception- NA
*/ 
    @isTest
    static void testGetProductDetails_NullProductId() {
        Test.startTest();
        Product2 productDetails = scc_productTitlePage_Controller.getProductDetails(null);
        Test.stopTest();
        
        System.assertEquals(null, productDetails, 'Product details should be null for null product Id');
    }
    
    /**
*  Description: Below method is test method that tests Product details exception
*  @name: testGetProductDetails_Exception
*  @param:NA
*  @return: NA
*  @throws exception- NA
*/ 
    @isTest
    static void testGetProductDetails_Exception() {
        Test.startTest();
        Product2 productDetails = scc_productTitlePage_Controller.getProductDetails(UserInfo.getUserId());
        Test.stopTest();
        
        System.assertEquals(null, productDetails, 'Product details should be null when an exception occurs');
    }
    
    /**
*  Description: Below method is test method to get user details
*  @name: testGetProductDetails
*  @param:NA
*  @return: NA
*  @throws exception- NA
*/ 
    @isTest
    static void testGetUserdetails() {
        Account testAccount = new Account(Name = 'Test Account', Type = 'Customer');
        insert testAccount;
        Contact con = scc_TestDataFactory.contactCreation(testAccount.Id, 'firstname4', 'testlastname4', 'testemail1@abc.com');
        User testUser = scc_TestDataFactory.userCreation(con.Id);
        
        Test.startTest();
        Account accountDetails = scc_productTitlePage_Controller.getUserdetails(testUser.Id);
        Test.stopTest();
        
        System.assertNotEquals(null, accountDetails, 'Account details should not be null');
        System.assertEquals(testAccount.Id, accountDetails.Id, 'Account details should match the inserted account');
        System.assertEquals(testAccount.Name, accountDetails.Name, 'Account name should match');
    }
    
    /**
*  Description: Below method is test method that tests account details are null for null user id
*  @name: testGetUserdetails_NullUserId
*  @param:NA
*  @return: NA
*  @throws exception- NA
*/ 
    @isTest
    static void testGetUserdetails_NullUserId() {
        Test.startTest();
        Account accountDetails = scc_productTitlePage_Controller.getUserdetails(null);
        Test.stopTest();
        
        System.assertEquals(null, accountDetails, 'Account details should be null for null user Id');
    }
    
    /**
*  Description: Below method is test method that tests account details are null when there is no related contact
*  @name: testGetUserdetails_NoRelatedContact
*  @param:NA
*  @return: NA
*  @throws exception- NA
*/ 
    @isTest
    static void testGetUserdetails_NoRelatedContact() {
        User testUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        
        Test.startTest();
        Account accountDetails = scc_productTitlePage_Controller.getUserdetails(testUser.Id);
        Test.stopTest();
        
        System.assertEquals(null, accountDetails, 'Account details should be null when there is no related contact');
    }
    
    /**
*  Description: Below method is test method that tests pricebookentry
*  @name: testGetPricebookEntry
*  @param:NA
*  @return: NA
*  @throws exception- NA
*/ 
    @isTest
    static void testGetPricebookEntry() {
        Product2 testProduct = new Product2(Name = 'Test Product');
        insert testProduct;
        
        Id pricebookId = Test.getStandardPricebookId();     
        
        PricebookEntry standardPricebookEntry = new PricebookEntry(
            Pricebook2Id = pricebookId, 
            Product2Id = testProduct.Id, 
            UnitPrice = 100.00, 
            IsActive = true
        );
        insert standardPricebookEntry;
        
        Test.startTest();
        PricebookEntry pricebookEntry = scc_productTitlePage_Controller.getPricebookEntry(testProduct.Id);
        Test.stopTest();
        
        System.assertNotEquals(null, pricebookEntry, 'Pricebook entry should not be null');
        System.assertEquals(standardPricebookEntry.Id, pricebookEntry.Id, 'Pricebook entry should match the inserted pricebook entry');
        System.assertEquals(standardPricebookEntry.UnitPrice, pricebookEntry.UnitPrice, 'Unit price should match');
    }
}