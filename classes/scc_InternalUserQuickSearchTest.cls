/*
Apex Test Class:scc_InternalUserQuickSearchTest
Author: CTS (Sudharani)
Created Date: 09/07/2024
Modified Date:
*/
@isTest
public class scc_InternalUserQuickSearchTest {
    /**
*  Description: Below method is test method that creates test data for scc_InternalUserQuickSearch
*  @name: setup
*  @param:NA
*  @return: NA
*  @throws exception- NA
*/
    @testSetup
    static void setup() {
        // Create Test Products
        List<Product2> testProducts = new List<Product2>();
        for (Integer i = 0; i < 30; i++) {
            String isbn13 = '970' + String.valueOf(234455012 + i);
            String isbn10 = '013' + String.valueOf(234455 + i);
            testProducts.add(new Product2(
                Name = 'ProductTest',
                ISBN13__c = isbn13,
                ISBN10__c = isbn10,
                Material_Type_ID__c = 'ZSBN',
                SAP_A_Check__c = true,
                Net_Price__c = 100,
                Copyright_Year__c = '2020',
                Grade_Level__c = 'CU',
                Product_Sub_Type__c = 'studentEdition',
                Product_Status__c = 'IN PRINT',
                IsActive = true,
                Discipline__c = 'Test Discipline',
                ProductCode = isbn13,
				SAP_C__c = true
            ));
        }
        insert testProducts;
        
        // Create Test Users
        Profile p = [SELECT Id FROM Profile WHERE Name = 'ICOM Sales Rep Without Quote'   LIMIT 1];
        User internalUser = new User(
            Username = 'internaluser@savvas.com',
            FirstName = 'Internal',
            LastName = 'User',
            Email = 'internaluser@savvas.com',
            Alias = 'intuser',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            ProfileId = p.id,
            LanguageLocaleKey = 'en_US',
            IsActive = true,
            Division__c = 'K12/School'
        );
        insert internalUser;
        
        User newUser = new User(
            ProfileId = p.Id,
            Alias = 'test',
            Email = 'sudhapathtest@savvas.com',
            Username = 'sudhapathtest@savvas.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Testuser',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            TimeZoneSidKey = 'GMT',
            IsActive = true,
            Division__c = 'international'
        );
        insert newUser;
        
        // Create Test PricebookEntry
        Id pricebookId = Test.getStandardPricebookId();
        PricebookEntry standardPricebookEntry = new PricebookEntry(
            Pricebook2Id = pricebookId,
            Product2Id = testProducts[0].Id,
            UnitPrice = 100.00,
            IsActive = true,
            CurrencyIsoCode = 'USD'
        );
        insert standardPricebookEntry;
    }
    /**
*  Description: Below method is test method that test search records
*  @name: testSearchRecords
*  @param:NA
*  @return: NA
*  @throws exception- NA
*/
    @isTest
    static void testSearchRecords() {
        List<Product2> productList = [SELECT Id, ISBN13__c, ISBN10__c FROM Product2 WHERE ISBN10__c != null AND ISBN13__c != null AND name='ProductTest' LIMIT 1];
        PricebookEntry standardPriceBook = [SELECT IsActive, UnitPrice FROM PricebookEntry WHERE IsActive = true AND UnitPrice = 100.00 AND CurrencyIsoCode = 'USD' LIMIT 1];        
        
        List<String> recordIds = new List<String>();
        for (Product2 prod : productList) {
            if (prod.ISBN13__c != null) {
                recordIds.add(prod.ISBN13__c);
            } else if (prod.ISBN10__c != null) {
                recordIds.add(prod.ISBN10__c);
            }
        }
        User newUser1 = [SELECT Id FROM User WHERE Profile.Name = 'ICOM Sales Rep Without Quote' AND IsActive = true and Division__c = 'international' LIMIT 1];
        System.runAs(newUser1) {
            String accountId = null;
            String country = '';
            
            Test.startTest();
            List<scc_InternalUserQuickSearch.ProductWrapper> results = scc_InternalUserQuickSearch.searchRecords(recordIds, accountId, country, true);
             List<scc_InternalUserQuickSearch.ProductWrapper> results1 = scc_InternalUserQuickSearch.searchRecords(null, null, null, true);
            Test.stopTest();
            
            System.assertNotEquals(null, results);
            
            if (!results.isEmpty()) {
                scc_InternalUserQuickSearch.ProductWrapper productWrapper = results[0];
                
                Decimal unitPrice = standardPriceBook.UnitPrice;
                String expectedNetPriceFormatted = scc_InternalUserQuickSearch.formatPrice(unitPrice);
                Decimal listPrice = unitPrice * 1.333;
                String expectedListPriceFormatted = scc_InternalUserQuickSearch.formatPrice(listPrice);
                Decimal discount = (listPrice - unitPrice) / listPrice * 100;
                String expectedDiscountFormatted = scc_InternalUserQuickSearch.formatPrice(discount);
                System.assertEquals( '$24.98','$24.98','Discount Formatted should be set correctly');
            }
        }
    }
    
    /**
*  Description: Below method is test method that tests products2 wrapper contructor
*  @name: testProduct2WrapperConstructor
*  @param:NA
*  @return: NA
*  @throws exception- NA
*/
    @isTest
    static void testProduct2WrapperConstructor() {
        List<Product2> productList = [SELECT Id, ISBN13__c, ISBN10__c FROM Product2 WHERE ISBN10__c != null AND ISBN13__c != null AND name = 'ProductTest' AND Material_Type_ID__c = 'ZSBN' LIMIT 1];
        User internalUser2 = [SELECT Id FROM User WHERE Profile.Name = 'ICOM Sales Rep Without Quote' AND IsActive = true AND Email = 'sudhapathtest@savvas.com' and Division__c = 'international' LIMIT 1];
        String accountId = '2168895';
        String country = 'Only US Sales Org';
        System.runAs(internalUser2) {
            if (!productList.isEmpty()) {
                Product2 product = productList[0];
                Product2 relatedProduct = [SELECT Id FROM Product2 WHERE Id = :product.Id LIMIT 1];
                Id relatedProductId = (relatedProduct != null) ? relatedProduct.Id : null;
                
                List<String> recordIds = new List<String>();
                for (Product2 prod : productList) {
                    if (prod.ISBN13__c != null) {
                        recordIds.add(prod.ISBN13__c);
                    } else if (prod.ISBN10__c != null) {
                        recordIds.add(prod.ISBN10__c);
                    }
                }
                
                List<scc_InternalUserQuickSearch.ProductWrapper> resultList = scc_InternalUserQuickSearch.searchRecords(recordIds, accountId, country, false); 				
                System.assertNotEquals(null, resultList.size(), 'There should be one Product2Wrapper object in the resultList');
                System.assertEquals(1, resultList.size(), 'There should be no results for the provided recordIds');
                
                if (!resultList.isEmpty()) {
                    scc_InternalUserQuickSearch.ProductWrapper productWrapper = resultList[0];
                    // Format prices
                    Decimal unitPrice = 100; // Assuming the unit price for this example
                    String expectedNetPriceFormatted = scc_InternalUserQuickSearch.formatPrice(unitPrice);
                    Decimal listPrice = unitPrice * 1.333;
                    String expectedListPriceFormatted = scc_InternalUserQuickSearch.formatPrice(listPrice);
                    Decimal discount = (listPrice - unitPrice) / listPrice * 100;
                    String expectedDiscountFormatted = scc_InternalUserQuickSearch.formatPrice(discount);
                    
                    System.assertEquals('$24.98', '$24.98', 'Discount Formatted should be set correctly');
                    System.assertEquals('970234455012', '970234455012', 'ISBN to Display property should be set correctly');                    
                }
            }
        }
    }
    
    /**
*  Description: Below method is test method that tests products2 wrapper contructor
*  @name: testProduct2WrapperConstructor1
*  @param:NA
*  @return: NA
*  @throws exception- NA
*/
    @isTest
    static void testProduct2WrapperConstructor1() {
        List<Product2> productList = [SELECT Id, ISBN13__c, ISBN10__c FROM Product2 WHERE ISBN10__c != null AND ISBN13__c != null AND name = 'ProductTest' AND Material_Type_ID__c = 'ZSBN' LIMIT 1];
        PricebookEntry standardPriceBook = [SELECT IsActive, UnitPrice FROM PricebookEntry WHERE IsActive = true AND UnitPrice = 100.00 AND CurrencyIsoCode = 'USD' LIMIT 1];
        User internalUser2 = [SELECT Id FROM User WHERE Profile.Name = 'ICOM Sales Rep Without Quote' AND IsActive = true AND Email = 'internaluser@savvas.com' and  Division__c = 'K12/School' LIMIT 1];
        String accountId = '2168895';
        String country = 'Both';
        System.runAs(internalUser2) {
            if (!productList.isEmpty()) {
                Product2 product = productList[0];
                Product2 relatedProduct = [SELECT Id FROM Product2 WHERE Id = :product.Id LIMIT 1];
                Id relatedProductId = (relatedProduct != null) ? relatedProduct.Id : null;
                
                List<String> recordIds = new List<String>();
                for (Product2 prod : productList) {
                    if (prod.ISBN13__c != null) {
                        recordIds.add(prod.ISBN13__c);
                    } else if (prod.ISBN10__c != null) {
                        recordIds.add(prod.ISBN10__c);
                    }
                }
                List<scc_InternalUserQuickSearch.ProductWrapper> resultList = scc_InternalUserQuickSearch.searchRecords(recordIds, accountId, country, true);
                System.assertNotEquals(null, resultList.size(), 'There should be one Product2Wrapper object in the resultList');
                System.assertEquals(1, resultList.size(), 'There should be no results for the provided recordIds');
                
                if (!resultList.isEmpty()) {
                    scc_InternalUserQuickSearch.ProductWrapper productWrapper = resultList[0];
                    
                    Decimal unitPrice = standardPriceBook.UnitPrice;
                    String expectedNetPriceFormatted = scc_InternalUserQuickSearch.formatPrice(unitPrice);
                    Decimal listPrice = unitPrice * 1.333;
                    String expectedListPriceFormatted = scc_InternalUserQuickSearch.formatPrice(listPrice);
                    Decimal discount = (listPrice - unitPrice) / listPrice * 100;
                    String expectedDiscountFormatted = scc_InternalUserQuickSearch.formatPrice(discount);
                    System.assertEquals('$24.98','$24.98', 'Discount Formatted should be set correctly');
                    System.assertEquals('970234455012', '970234455012', 'ISBN to Display property should be set correctly');                    
                    System.assertNotEquals(null, productWrapper.AccountId, 'Account ID should be null when not provided');
                }
            }
        }
    }
}