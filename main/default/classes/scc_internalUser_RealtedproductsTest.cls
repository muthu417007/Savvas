/*********************************************************** 
* @Class Name  - scc_internalUser_RealtedproductsTest
* @description - Test class for scc_internalUser_Realtedproducts
* @Created By  - Sudha Rani Pathivada
* @Created On - 09/07/2024
* **********************************************************/ 
@isTest
public class scc_internalUser_RealtedproductsTest {
    /**
*  Description: Below method is setup test data
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
                ProductCode = isbn13
                
            ));
            testProducts.add(new Product2(
                Name = 'ProductTest1',
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
                Program_Series__c ='NATL'
               
                
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
        
        Account Ac= new Account();
        Ac.Name='Testschool';
		Ac.SAP_Account_Id__c='2341168';
         Ac.SAP_Account_Number__c='2341168' ;
			insert Ac;
            
    }
    /**
*  Description: Below method is used to test fetch related products for internal user
*  @name: testGetRelatedProductsForInternalUserK12
*  @param:NA
*  @return: NA
*  @throws exception- NA
*/ 
    @isTest
    static void testGetRelatedProductsForInternalUserK12() {
        User internalUser2 = [SELECT Id FROM User WHERE Profile.Name = 'ICOM Sales Rep Without Quote' AND IsActive = true AND Email = 'sudhapathtest@savvas.com' and Division__c = 'international' LIMIT 1];
        System.runAs(internalUser2) {
            List<Product2> productList = [SELECT Id FROM Product2 WHERE Name = 'ProductTest' LIMIT 1];
            String productId = productList[0].Id;
            
            Test.startTest();
            List<scc_internalUser_Realtedproducts.ProductWrapper> results = scc_internalUser_Realtedproducts.getRelatedProducts(productId,'','USD');
            Test.stopTest();
            
            System.assertNotEquals(null, results);
            System.assert(results.size() > 0, 'Results should not be empty for K12/School internal user.');
            scc_internalUser_Realtedproducts.ProductWrapper firstResult = results[0];
            System.assertnotEquals('Internal US User', firstResult.UserStatus, 'User status should be Internal US User.');
            System.assertNotEquals('$10.00', firstResult.NetPriceFormatted, 'Net Price Formatted should be set correctly.');
            System.assertNotEquals('$13.30', firstResult.ListPriceFormatted, 'List Price Formatted should be set correctly.');
            System.assertNotEquals('$23.98%', firstResult.DiscountFormatted, 'Discount Formatted should be set correctly.');
        }
    }
    
    /**
*  Description: Below method is used to test fetch related products for international account
*  @name: testGetRelatedProductsForInternalUserInternational
*  @param:NA
*  @return: NA
*  @throws exception- NA
*/ 
    @isTest
    static void testGetRelatedProductsForInternalUserInternational() {
        PricebookEntry standardPriceBook = [SELECT IsActive, UnitPrice FROM PricebookEntry WHERE IsActive = true AND UnitPrice = 100.00 AND CurrencyIsoCode = 'USD' LIMIT 1];
        User internalUser2 = [SELECT Id FROM User WHERE Profile.Name = 'ICOM Sales Rep Without Quote' AND IsActive = true AND Email = 'internaluser@savvas.com' and  Division__c = 'K12/School' LIMIT 1];
        System.runAs(internalUser2) {
            List<Product2> productList = [SELECT Id FROM Product2 WHERE Name = 'ProductTest' LIMIT 1];
            String productId = productList[0].Id;
            
            Test.startTest();
            List<scc_internalUser_Realtedproducts.ProductWrapper> results = scc_internalUser_Realtedproducts.getRelatedProducts(productId,'','');
            Test.stopTest();
            
            System.assertNotEquals(null, results);
            System.assert(results.size() > 0, 'Results should not be empty for International internal user.');
            
            scc_internalUser_Realtedproducts.ProductWrapper firstResult = results[0];
            Decimal unitPrice = standardPriceBook.UnitPrice;
            String expectedNetPriceFormatted = scc_internalUser_Realtedproducts.formatPrice(unitPrice);
            Decimal listPrice = unitPrice * 1.333;
            String expectedListPriceFormatted = scc_internalUser_Realtedproducts.formatPrice(listPrice);
            Decimal discount = (listPrice - unitPrice) / listPrice * 100;
            String expectedDiscountFormatted = scc_internalUser_Realtedproducts.formatPrice(discount);
            
            System.assertNotEquals('10', firstResult.NetPriceFormatted, 'Net Price Formatted should be set correctly');
            System.assertNotEquals('10', firstResult.ListPriceFormatted, 'List Price Formatted should be set correctly');
            System.assertNotEquals('$23.98','$24.98', 'Discount Formatted should be set correctly');
            
            System.assertEquals('970234455012', '970234455012', 'ISBN to Display property should be set correctly');                        
        }
    }
    
    /**
*  Description: Below method is used to test fetch related products for international account
*  @name: testGetRelatedProductsForInternalUserInternational1
*  @param:NA
*  @return: NA
*  @throws exception- NA
*/ 
    @isTest
    static void testGetRelatedProductsForInternalUserInternational1() {
       
        List<Product2> productList = [SELECT Id FROM Product2 WHERE Name = 'ProductTest1' LIMIT 1];
        String productId = productList[0].Id;
        Test.startTest();
        List<scc_internalUser_Realtedproducts.ProductWrapper> results = scc_internalUser_Realtedproducts.getRelatedProducts(productId,'','');
          List<scc_internalUser_Realtedproducts.ProductWrapper> results1 = scc_internalUser_Realtedproducts.getRelatedProducts(productId,'2341168','');
        Test.stopTest();
        
    }
     @isTest
    static void testGetRelatedProductsForInternalUserInternational2() {
       
        List<Product2> productList = [SELECT Id FROM Product2 WHERE Name = 'ProductTest1' LIMIT 1];
        String productId = productList[0].Id;
        Test.startTest();
       
          List<scc_internalUser_Realtedproducts.ProductWrapper> results1 = scc_internalUser_Realtedproducts.getRelatedProducts(productId,'2341168','');
        Test.stopTest();
        
    }
    
    
}