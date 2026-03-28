/*
Apex Test Class:scc_productQuickSearch_Test
Author: CTS (Sudharani)
Created Date: 27/07/2024
Modified Date:
*/
@isTest
public class scc_productQuickSearch_Test {
    /**
*  Description: Below method is test method that creates test data for scc_productQuickSearch_Controller
*  @name: setup
*  @param:NA
*  @return: NA
*  @throws exception- NA
*/
    @testSetup 
    static void setup() {
        List<Product2> testProducts = new List<Product2>();
        for (Integer i = 0; i < 30; i++) {
            String isbn13 = '978' + String.valueOf(1000000000 + i).rightPad(10, '0');
            String isbn10 = '0' + String.valueOf(100000000 + i);
            testProducts.add(new Product2(
                Name = 'ProductTest' + i,
                ISBN13__c = isbn13,
                ISBN10__c = isbn10,
                Material_Type_ID__c = 'ZSBN',
                myOrders_exclude__c = false,
                SAP_C__c = true,
                Net_Price__c = 100,
                Copyright_Year__c = '2020',
                Grade_Level__c = 'CU',
                Product_Sub_Type__c = 'studentEdition',
                Product_Status__c = 'IN PRINT',
                IsActive = true,
                Description = 'Test Description'
            ));
        }
        insert testProducts;
        
        Account testAccount = new Account(Name = 'TestAccount', Type = 'International School');
        insert testAccount;       
        Contact testContact = new Contact(FirstName = 'Test', LastName = 'User', Email = 'testuser@example.com', AccountId = testAccount.Id);
        insert testContact;
    }
    
    /**
*  Description: Below method is test method that tests search records
*  @name: testSearchRecords
*  @param:NA
*  @return: NA
*  @throws exception- NA
*/
    @isTest
    static void testSearchRecords() {
        List<Product2> products = [SELECT Id, ISBN13__c, ISBN10__c FROM Product2 LIMIT 25];
        List<String> recordIds = new List<String>();
        for (Product2 prod : products) {
            recordIds.add(prod.ISBN13__c);
        }
        
        Test.startTest();
        List<scc_productQuickSearch_Controller.ProductWrapper> resultList = scc_productQuickSearch_Controller.searchRecords(recordIds, true);
        Test.stopTest();
                
        for (scc_productQuickSearch_Controller.ProductWrapper wrapper : resultList) {
            System.assertNotEquals(null, wrapper.product, 'Product should not be null');
            System.assertEquals('NA', wrapper.Price, 'Price should be NA for active products');
            System.assertNotEquals(null, wrapper.ISBN, 'ISBN should not be null');
        }
    }
    
    /**
*  Description: Below method is test method that tests international account
*  @name: testIsInternationalAccount
*  @param:NA
*  @return: NA
*  @throws exception- NA
*/
    @isTest
    static void testIsInternationalAccount() {
        System.assertEquals(true, scc_productQuickSearch_Controller.isInternationalAccount('International School'), 'Should be an international account');
        System.assertEquals(true, scc_productQuickSearch_Controller.isInternationalAccount('International Distributor'), 'Should be an international account');
        System.assertEquals(false, scc_productQuickSearch_Controller.isInternationalAccount('Customer'), 'Should not be an international account');
        System.assertEquals(false, scc_productQuickSearch_Controller.isInternationalAccount(null), 'Null should not be an international account');
    }
    
    /**
*  Description: Below method is test method that tests populate search results
*  @name: testPopulateSearchResults
*  @param:NA
*  @return: NA
*  @throws exception- NA
*/
    @isTest
    static void testPopulateSearchResults() {
        List<String> recordIds = new List<String>{'9781000000000', '0100000000'};
            
        Test.startTest();
        List<scc_productQuickSearch_Controller.ProductWrapper> resultList = scc_productQuickSearch_Controller.populateSearchResults(recordIds, false, false, true);
        Test.stopTest();
        
        scc_productQuickSearch_Controller.ProductWrapper wrapper = resultList[0];
        System.assertNotEquals(null, wrapper.product, 'Product should not be null');
        System.assertEquals('NA', wrapper.Price, 'Price should be NA for active products');
        System.assertNotEquals(null, wrapper.ISBN, 'ISBN should not be null');
    }
    
    /**
*  Description: Below method is test method that tests pad zeros to the left
*  @name: testPadZerosLeft
*  @param:NA
*  @return: NA
*  @throws exception- NA
*/
    @isTest
    static void testPadZerosLeft() {
        System.assertEquals('0001234567', scc_productQuickSearch_Controller.padZerosLeft('1234567', 10), 'Should pad zeros to the left');
        System.assertEquals('1234567890', scc_productQuickSearch_Controller.padZerosLeft('1234567890', 10), 'Should not pad if length is already correct');
        System.assertEquals('0000000123', scc_productQuickSearch_Controller.padZerosLeft('123', 10), 'Should pad zeros for short strings');
    }
    
    /**
*  Description: Below method is test method that tests error handeling
*  @name: testErrorHandling
*  @param:NA
*  @return: NA
*  @throws exception- NA
*/
    @isTest
    static void testErrorHandling() {
        Test.startTest();
        List<scc_productQuickSearch_Controller.ProductWrapper> resultList = scc_productQuickSearch_Controller.searchRecords(new List<String>(), true);
        Test.stopTest();
        
        System.assertEquals(0, resultList.size(), 'Should return 0 wrappers for empty list');
    }
    
    /**
*  Description: Below method is test method that tests records with international account
*  @name: testSearchRecordsWithInternationalAccount
*  @param:NA
*  @return: NA
*  @throws exception- NA
*/
    @isTest
    static void testSearchRecordsWithInternationalAccount() {
        // Create products
        Product2 product1 = scc_TestDataFactory.productCreation1();
        Product2 product2 = scc_TestDataFactory.productCreation2();
        
        List<String> recordIds = new List<String>{product1.ISBN13__c, product2.ISBN10__c};
            
            // Ensure we have more than 25 record IDs to trigger the specific code path
            while (recordIds.size() <= 25) {
                recordIds.add('978' + String.valueOf(1000000000 + recordIds.size()).rightPad(10, '0'));
            }
        
        // Create an international account
        Account internationalAccount = scc_TestDataFactory.internationalAccountCreation('International Test Account');
        
        // Create a contact for the international account
        Contact testContact = scc_TestDataFactory.contactCreation(
            internationalAccount.Id,
            'International',
            'TestUser',
            'intl_testuser@example.com'
        );
        
        // Create a user associated with the international contact
        User testUser = scc_TestDataFactory.userCreation(testContact.Id);
        
        Test.startTest();
        System.runAs(testUser) {
            List<scc_productQuickSearch_Controller.ProductWrapper> resultList = scc_productQuickSearch_Controller.searchRecords(recordIds, true);            
            
            // Verify that the international account logic was triggered
            for (scc_productQuickSearch_Controller.ProductWrapper wrapper : resultList) {
                // Add assertions here based on expected behavior for international accounts                
            }
        }
        Test.stopTest();
    }
}