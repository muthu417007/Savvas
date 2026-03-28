/*
*********************************************************
Class Name       : Sbqq_QuoteLine_TriggerHandlerTest
Created Date     : 12/02/2024 
Author           : Frank Berni - Cognizant
Description      : Test class for Sbqq_QuoteLine_TriggerHandler
Percentage       : 100%

History:
<Date>          <Authors Name>              <Brief Description of Change>
12/02/2024       Frank Berni                 Initial creation
**********************************************************/
@IsTest
public with sharing class Sbqq_QuoteLine_TriggerHandlerTest {
    
    @testSetup
    static void setup() {

        // Insert Products
        List<Product2> prodList = new List<Product2>();
        Product2 prod1 = new Product2();
        prod1.Name = 'Test Tykes Math';
        prod1.IsActive = true;
        prod1.SBQQ__DefaultQuantity__c = 1;
        prod1.ProductCode = '1234567891234'; 
        prod1.ISBN13__c = '1234567891234'; 
        prod1.Audience__c = 'Student';
        prod1.Net_Price__c = 17.50;
        prod1.Description = 'Test Tykes 2020 Math Envision';
        prod1.Product_Sub_Type__c = 'License';
        prod1.GradeBand__c = 'Elementary (K-5)';
        prod1.Copyright_Year__c = '2020';
        prod1.Duration__c = '1YR';
        prod1.Solution_Type__c = 'Digital';
        prodList.add(prod1);

        Product2 prod2 = new Product2();
        prod2.Name = 'Test Tykes Math Pre-Algebra';
        prod2.IsActive = true;
        prod2.SBQQ__DefaultQuantity__c = 1;
        prod2.ProductCode = '1234567574896'; 
        prod2.ISBN13__c = '1234567574896'; 
        prod2.Audience__c = 'Student';
        prod2.Net_Price__c = 20.50;
        prod2.Description = 'Test Tykes 2020 Math Pre-Algebra Envision';
        prod2.Product_Sub_Type__c = 'License';
        prod2.GradeBand__c = 'Elementary (K-5)';
        prod2.Copyright_Year__c = '2020';
        prod2.Duration__c = '1YR';
        prod2.Solution_Type__c = 'Digital';
        prodList.add(prod2);

        insert prodList;
        System.debug('Products Inserted - ' + prodList);

        // Setting up a test PriceBook 
        Pricebook2 testPriceBook = new Pricebook2();
        testPriceBook.Id = Test.getStandardPricebookId();
        testPriceBook.IsActive = true;
        update testPriceBook;
        System.debug('Pricebook setup - ' + testPricebook);

        // Setting up Quote Pricebook to avoid record trigger flow error for defaulting Quote
        PriceBook2 quotePricebook = new PriceBook2();
        quotePricebook.Name = 'Quote Pricebook';
        quotePricebook.IsActive = true;
        insert quotePricebook;

        List<PricebookEntry> pbeList = new List<PricebookEntry>();
        for (Product2 prod : prodList) {
            // Standard pricebook
            PricebookEntry pbe = new PricebookEntry();
            pbe.Product2Id = prod.Id;
            pbe.Pricebook2Id = testPriceBook.Id;
            pbe.UnitPrice = 17.50;
            pbe.IsActive = true;
            pbeList.add(pbe);

            // Quote pricebook
            PricebookEntry pbe2 = new PricebookEntry();
            pbe2.Product2Id = prod.Id;
            pbe2.Pricebook2Id = quotePricebook.Id;
            pbe2.UnitPrice = 17.50;
            pbe2.IsActive = true;
            pbeList.add(pbe2);
        }
        
        insert pbeList;
        System.debug('Pricebook Entries Inserted - ' + pbeList);

        // Create test Quote
        SBQQ__Quote__c quote = new SBQQ__Quote__c();
        // quote.SBQQ__Account__c = acc.Id;
        // quote.SBQQ__Opportunity2__c = opp.Id;
        quote.SBQQ__PriceBookId__c = quotePricebook.Id;
        quote.SBQQ__StartDate__c = Date.Today(); 
        quote.SBQQ__SubscriptionTerm__c = 12;
        quote.ApprovalStatus__c = 'Draft';
        insert quote;
        System.debug('Quote Inserted - ' + quote);

        // Create test QuoteLine records per pricebook entry and ql program
        List<SBQQ__QuoteLine__c> quoteLines = new List<SBQQ__QuoteLine__c>();
        for (PricebookEntry pbe : pbeList) {           
                SBQQ__QuoteLine__c line = new SBQQ__QuoteLine__c(
                    SBQQ__Quote__c = quote.Id,
                    SBQQ__PricebookEntryId__c = pbe.Id,
                    SBQQ__PricingMethod__c = 'List',
                    SBQQ__StartDate__c = Date.today(),
                    SBQQ__Quantity__c = 5,
                    SBQQ__PriorQuantity__c = 0,
                    SBQQ__RegularPrice__c = 100,
                    SBQQ__NetPrice__c = 100,
                    SBQQ__CustomerPrice__c = 80,
                    SBQQ__Number__c = 1,
                    SBQQ__ProrateMultiplier__c = 1,
                    SBQQ__SubscriptionPricing__c = 'Fixed Price',
                    SBQQ__SubscriptionScope__c = 'Quote',
                    SBQQ__DefaultSubscriptionTerm__c = 1,
                    SBQQ__Description__c = 'Test Product Description',
                    SBQQ__ListPrice__c = 100
                );
                quoteLines.add(line);  
        }

        SBQQ.TriggerControl.disable();

        insert quoteLines;
        System.debug('Quote Lines Inserted - ' + quoteLines);
        System.debug('Quote Lines Total' + quoteLines.size());

    }

    // Tests that an Admin User with a Quote in Draft can delete line items
    @IsTest
    static void testPreventNonDraftDelete_Positive() {
        SBQQ.TriggerControl.disable();

        SBQQ__QuoteLine__c lineItem = [SELECT Id FROM SBQQ__QuoteLine__c LIMIT 1];
        Profile sysAdmin = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];

        User adminUser = new User(
            ProfileId = sysAdmin.Id,
            Alias = 'admin',
            Email = 'admin@test.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Admin',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            TimeZoneSidKey = 'America/Los_Angeles',
            Username = 'admin123456@test.com'       
        );

        // User adminUser = [SELECT Id, IsActive FROM User WHERE LastName = 'Admin' LIMIT 1];

        // if(!adminUser.IsActive) {
        //     adminUser.IsActive = true;
        //     update adminUser;
        // }

        System.runAs(adminUser) {

            delete lineItem;
            
        }

        List<SBQQ__QuoteLine__c> lineItemsAfterDelete = [SELECT Id FROM SBQQ__QuoteLine__c];
        System.assert(lineItemsAfterDelete.size() == 3, 'Line item was not deleted as expected');


    }

    // Tests that a Non-Admin User with a Non-Draft Quote can't delete line items
    @IsTest
    static void testPreventNonDraftDelete_Negative() {
        SBQQ.TriggerControl.disable();

        Profile icomSalesOps = [SELECT Id FROM Profile WHERE Name = 'ICOM Sales Ops' LIMIT 1];

        SBQQ__Quote__c quote = [SELECT Id, ApprovalStatus__c FROM SBQQ__Quote__c LIMIT 1];
        quote.ApprovalStatus__c = 'Presented';
        update quote;

        User salesUser = new User(
            ProfileId = icomSalesOps.Id,
            Alias = 'icomSale',
            Email = 'icomSales@test.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Sales',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            TimeZoneSidKey = 'America/Los_Angeles',
            Username = 'icomSales123456@test.com'
        );

        SBQQ__QuoteLine__c lineItem = [SELECT Id FROM SBQQ__QuoteLine__c LIMIT 1];
        // User salesUser = [SELECT Id, IsActive FROM User WHERE LastName = 'Sales' LIMIT 1];

        // if(!salesUser.IsActive) {
        //     salesUser.IsActive = true;
        //     update salesUser;
        // }

        System.runAs(salesUser) {

            Test.startTest();
            try {
                delete lineItem;
                System.assert(false, 'Expected a delete exception but did not get one');
            } catch (Exception e) {
                System.assert(e.getMessage().contains('You can only delete Quote Lines when Quote is in Draft status'));
            }
            Test.stopTest();
        }

        List<SBQQ__QuoteLine__c> lineItemsAfterDelete = [SELECT Id FROM SBQQ__QuoteLine__c];
        System.assert(lineItemsAfterDelete.size() == 4, 'Line item was not prevented from being deleted');


    }
}