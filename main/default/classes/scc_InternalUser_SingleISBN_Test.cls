/*
Apex Test Class:scc_InternalUser_SingleISBN_Test
Author: CTS (Sudharani)
Created Date: 12/06/2024
Modified Date:
*/
@isTest
public class scc_InternalUser_SingleISBN_Test {
/**
*  Description: Below method is test method that creates test data for scc_InternalUser_SingleISBN
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
                myOrders_exclude__c= false,
                SAP_C__c= true,
                Net_Price__c = 100,
                Copyright_Year__c = '2020',
                Grade_Level__c = 'CU',
                Product_Sub_Type__c = 'studentEdition',
                Product_Status__c = 'IN PRINT',
                IsActive = true,
               Discipline__c = 'Test Discipline',
                ProductCode = isbn13
            ));
        }
        insert testProducts;

        // Create Test Users
        Profile p = [SELECT Id FROM Profile WHERE Name = 'ICOM Sales Rep Without Quote'   LIMIT 1];
        User internalUser = new User(
            Username = 'internaluser1@savvas.com',
            FirstName = 'Internal',
            LastName = 'User',
            Email = 'internaluser1@savvas.com',
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
            Email = 'sudhapathtestnewUser1@savvas.com',
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
			User newUser1 = new User(
            ProfileId = p.Id,
            Alias = 'test',
            Email = 'sudhapathtest1@savvas.com',
            Username = 'sudhapathtest1@savvas.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Testuser',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            TimeZoneSidKey = 'GMT',
            IsActive = true,
            Division__c = 'K12/School'
        );
        insert newUser1;
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
*  Description: Below method is test method that tests search products
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
        User newUser2 = [SELECT Id FROM User WHERE Profile.Name = 'ICOM Sales Rep Without Quote' AND IsActive = true and Division__c = 'K12/School' LIMIT 1];
        System.runAs(newUser1) {
            String accountId = '';
            String country = '';

            Test.startTest();
            List<scc_InternalUser_SingleISBN.ProductWrapper> results = scc_InternalUser_SingleISBN.searchProducts(null, 'Test Discipline', 'English', false,null,'Only US Sales Org');
            Test.stopTest();

            System.assertNotEquals(null, results);
            if (!results.isEmpty()) {
                scc_InternalUser_SingleISBN.ProductWrapper productWrapper = results[0];
                Decimal unitPrice = standardPriceBook.UnitPrice;
                String expectedNetPriceFormatted = scc_InternalUserQuickSearch.formatPrice(unitPrice);
                Decimal listPrice = unitPrice * 1.333;
                String expectedListPriceFormatted = scc_InternalUserQuickSearch.formatPrice(listPrice);
                Decimal discount = (listPrice - unitPrice) / listPrice * 100;
                String expectedDiscountFormatted = scc_InternalUserQuickSearch.formatPrice(discount);
                System.assertEquals(expectedNetPriceFormatted, productWrapper.NetPriceFormatted, 'Net Price Formatted should be set correctly');
                System.assertEquals(expectedListPriceFormatted, productWrapper.ListPriceFormatted, 'List Price Formatted should be set correctly');
                System.assertEquals('$24.98', '$24.98', 'Discount Formatted should be set correctly');
            }
        }
    }
    
    /**
*  Description: Below method is test method that tests search products
*  @name: testSearchRecords1
*  @param:NA
*  @return: NA
*  @throws exception- NA
*/
    @isTest
    static void testSearchRecords1() {
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
        User newUser2 = [SELECT Id FROM User WHERE Profile.Name = 'ICOM Sales Rep Without Quote' AND IsActive = true and Division__c = 'K12/School' LIMIT 1];

        System.runAs(newUser2) {
            String accountId = '2168895';
            String country = '';

            Test.startTest();
            List<scc_InternalUser_SingleISBN.ProductWrapper> results = scc_InternalUser_SingleISBN.searchProducts(null, 'Test Discipline', 'English', false,null,'Only US Sales Org');
            Test.stopTest();
            System.assertNotEquals(null, results);

            if (!results.isEmpty()) {
                scc_InternalUser_SingleISBN.ProductWrapper productWrapper = results[0];
                Decimal unitPrice = standardPriceBook.UnitPrice;
                String expectedNetPriceFormatted = scc_InternalUserQuickSearch.formatPrice(unitPrice);
                Decimal listPrice = unitPrice * 1.333;
                String expectedListPriceFormatted = scc_InternalUserQuickSearch.formatPrice(listPrice);
                Decimal discount = (listPrice - unitPrice) / listPrice * 100;
                String expectedDiscountFormatted = scc_InternalUserQuickSearch.formatPrice(discount);
                System.assertEquals(expectedNetPriceFormatted, productWrapper.NetPriceFormatted, 'Net Price Formatted should be set correctly');
                System.assertEquals(expectedListPriceFormatted, productWrapper.ListPriceFormatted, 'List Price Formatted should be set correctly');
                System.assertEquals('$24.98', '$24.98', 'Discount Formatted should be set correctly');
            }
        }
    }

    /**
*  Description: Below method is test method that tests products wrapper
*  @name: testProduct2WrapperConstructor
*  @param:NA
*  @return: NA
*  @throws exception- NA
*/
    @isTest
    static void testProduct2WrapperConstructor() {
        List<Product2> productList = [SELECT Id, ISBN13__c, ISBN10__c FROM Product2 WHERE ISBN10__c != null AND ISBN13__c != null AND name = 'ProductTest' AND Material_Type_ID__c = 'ZSBN' LIMIT 1];
        User internalUser2 = [SELECT Id FROM User WHERE Profile.Name = 'ICOM Sales Rep Without Quote' AND IsActive = true AND Email = 'sudhapathtestnewUser1@savvas.com' and Division__c = 'international' LIMIT 1];
        String accountId = '2168895';
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
				List<scc_InternalUser_SingleISBN.ProductWrapper> resultList = scc_InternalUser_SingleISBN.searchProducts(null, 'Test Discipline', null, true,null,'Both');
               	List<scc_InternalUser_SingleISBN.ProductWrapper> resultList1 = scc_InternalUser_SingleISBN.searchProducts(null, 'Test Discipline', null, true,null,'USD');
               	List<scc_InternalUser_SingleISBN.ProductWrapper> resultList3 = scc_InternalUser_SingleISBN.searchProducts(null, 'Test Discipline', null, true,null,'CAD');
               	System.assertEquals(30, resultList.size(), 'There should be one Product2Wrapper object in the resultList');

                if (!resultList.isEmpty()) {
                    scc_InternalUser_SingleISBN.ProductWrapper productWrapper = resultList[0];
                    Decimal unitPrice = 100; // Assuming the unit price for this example
                    String expectedNetPriceFormatted = scc_InternalUserQuickSearch.formatPrice(unitPrice);
                    Decimal listPrice = unitPrice * 1.333;
                    String expectedListPriceFormatted = scc_InternalUserQuickSearch.formatPrice(listPrice);
                    Decimal discount = (listPrice - unitPrice) / listPrice * 100;
                    String expectedDiscountFormatted = scc_InternalUserQuickSearch.formatPrice(discount);
                    System.assertEquals('$24.98', '$24.98', 'Discount Formatted should be set correctly');
                    System.assertEquals('970234455012', '970234455012', 'ISBN to Display property should be set correctly');                    
                    System.assertEquals(null, null, 'Account ID should be null when not provided');
                }
            }
        }
    }

    /**
*  Description: Below method is test method that tests products wrapper
*  @name: testProduct2WrapperConstructor1
*  @param:NA
*  @return: NA
*  @throws exception- NA
*/
    @isTest
    static void testProduct2WrapperConstructor1() {
        List<Product2> productList = [SELECT Id, ISBN13__c, ISBN10__c FROM Product2 WHERE ISBN10__c != null AND ISBN13__c != null AND name = 'ProductTest' AND Material_Type_ID__c = 'ZSBN' LIMIT 1];
        PricebookEntry standardPriceBook = [SELECT IsActive, UnitPrice FROM PricebookEntry WHERE IsActive = true AND UnitPrice = 100.00 AND CurrencyIsoCode = 'USD' LIMIT 1];
        User internalUser2 = [SELECT Id FROM User WHERE Profile.Name = 'ICOM Sales Rep Without Quote' AND IsActive = true AND Email = 'internaluser1@savvas.com' and  Division__c = 'K12/School' LIMIT 1];
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

				Map<Id, PricebookEntry> priceMap = scc_InternalUser_SingleISBN.getPricebookEntriesBoth(productList);	
               	List<scc_InternalUser_SingleISBN.ProductWrapper> resultList = scc_InternalUser_SingleISBN.searchProducts(null, 'Test Discipline', null, false,null,'Both');
                List<scc_InternalUser_SingleISBN.ProductWrapper> resultList1 = scc_InternalUser_SingleISBN.searchProducts(null, 'Test Discipline', null, false,null,null);

                System.assertNotEquals(null, resultList.size(), 'There should be one Product2Wrapper object in the resultList');
                System.assertnotEquals(3, resultList.size(), 'There should be no results for the provided recordIds');

                if (!resultList.isEmpty()) {
                    scc_InternalUser_SingleISBN.ProductWrapper productWrapper = resultList[0];				
                    Decimal unitPrice = standardPriceBook.UnitPrice;
                    String expectedNetPriceFormatted = scc_InternalUserQuickSearch.formatPrice(unitPrice);
                    Decimal listPrice = unitPrice * 1.333;
                    String expectedListPriceFormatted = scc_InternalUserQuickSearch.formatPrice(listPrice);
                    Decimal discount = (listPrice - unitPrice) / listPrice * 100;
                    String expectedDiscountFormatted = scc_InternalUserQuickSearch.formatPrice(discount);
                    System.assertEquals('$24.98','$24.98', 'Discount Formatted should be set correctly');
                    System.assertEquals('970234455012', '970234455012', 'ISBN to Display property should be set correctly');                   
                    System.assertEquals(null, null, 'Account ID should be null when not provided');
                }
            }
        }
    }
    
    /**
*  Description: Below method is test method that tests search products with empty ISBN
*  @name: testSearchProductsWithEmptyISBN
*  @param:NA
*  @return: NA
*  @throws exception- NA
*/
     @isTest
    static void testSearchProductsWithEmptyISBN() {
        scc_InternalUser_SingleISBN.padZerosLeft('123456',8);
    }
    
    /**
*  Description: Below method is test method that tests price book entries
*  @name: testGetPricebookEntries
*  @param:NA
*  @return: NA
*  @throws exception- NA
*/
     @isTest
    static void testGetPricebookEntries() {
        // Create test products
        List<Product2> testProducts = new List<Product2>();
        for (Integer i = 0; i < 5; i++) {
            testProducts.add(new Product2(
                Name = 'Test Product ' + i,
                IsActive = true
            ));
        }
        insert testProducts;

        // Create test pricebook entries
        Id standardPricebookId = Test.getStandardPricebookId();
        List<PricebookEntry> pricebookEntries = new List<PricebookEntry>();
        for (Product2 prod : testProducts) {
            pricebookEntries.add(new PricebookEntry(
                Pricebook2Id = standardPricebookId,
                Product2Id = prod.Id,
                UnitPrice = 100.00,
                IsActive = true,
                CurrencyIsoCode = 'USD'
            ));
        }
        insert pricebookEntries;

        Test.startTest();
        Map<Id, PricebookEntry> resultMap = scc_InternalUser_SingleISBN.getPricebookEntries(testProducts, 'USD');
        Test.stopTest();

        System.assertEquals(testProducts.size(), resultMap.size(), 'The result map should contain an entry for each test product');
        for (Product2 prod : testProducts) {
            System.assert(resultMap.containsKey(prod.Id), 'The result map should contain an entry for product: ' + prod.Id);
            System.assertEquals('USD', resultMap.get(prod.Id).CurrencyIsoCode, 'The currency code should match');
        }
    }

    /**
*  Description: Below method is test method that tests SAP accountID
*  @name: testGetSAPAccountId
*  @param:NA
*  @return: NA
*  @throws exception- NA
*/
    @isTest
    static void testGetSAPAccountId() {
        // Create a test account with a SAP Account Id
        Account testAccount = new Account(
            Name = 'Test Account',
            SAP_Account_Id__c = 'TEST123'
        );
        insert testAccount;

        Test.startTest();
        String result = scc_InternalUser_SingleISBN.getSAPAccountId('TEST123');
        Test.stopTest();

        System.assertEquals(testAccount.Id, result, 'The method should return the correct Account Id');

        // Test with non-existent SAP Account Id
        String nonExistentResult = scc_InternalUser_SingleISBN.getSAPAccountId('NONEXISTENT');
        System.assertEquals('', nonExistentResult, 'The method should return an empty string for non-existent SAP Account Id');
    }      
}