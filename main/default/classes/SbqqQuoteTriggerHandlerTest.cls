/*
*********************************************************
Class Name       : SbqqQuoteTriggerHandlerTest
Created Date     : 6/11/2024 
Author           : Frank Berni - Cognizant
Description      : Test class for SbqqQuoteTriggerHandler
Percentage       : 94%

History:
<Date>          <Authors Name>              <Brief Description of Change>
6/11/2024       Frank Berni                 Initial creation
**********************************************************/
@IsTest
public with sharing class SbqqQuoteTriggerHandlerTest {
    
    /*
    *********************************************************
    Method Name    : setupTestData
    Author         : Frank Berni
    Description    : Inserts test data being used in SbqqQuoteTriggerHandler
    ********************************************************
    */
    @TestSetup
    static void setupTestData() {

        Id schoolAccId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Schools Account').getRecordTypeId();

        Account acc = new Account();
        acc.RecordTypeId = schoolAccId;
        acc.Name = 'Testing Tykes Elementary';
        acc.Type = 'Public District';
        insert acc;
        System.debug('Account Inserted - ' + acc);

        Opportunity opp = new Opportunity();
        opp.Name = 'Tykes Elem - Envision Core Offerings';
        opp.CloseDate = Date.Today();
        opp.StageName = 'Prospect';
        opp.AccountId = acc.Id;
        insert opp;
        System.debug('Opportunity Inserted - ' + opp);

        // Creating 6 Products - 2 are Product A products used as Quote lines, 4 will be used as Product B products for the quote lines
        /**
         * Product A 1
         * Product A 2
         * Product B 3
         * Product B 4
         * Product B 5
         * Product B 6
         */
        List<Product2> prodList = new List<Product2>();
        for (Integer i = 1; i < 7; i++) {
            Product2 prod = new Product2();
            if (i < 3) {
                prod.Name = 'Product A ' + i;
            } 
            else {
                prod.Name = 'Product B ' + i;
            }
            prod.IsActive = true;
            prod.SBQQ__DefaultQuantity__c = 1;
            prod.ProductCode = '123456789123' + i; 
            prodList.add(prod);
        }

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

        Product2 productA1 = new Product2();
        Product2 productA2 = new Product2();
        Product2 productA1B1 = new Product2();
        Product2 productA1B2 = new Product2();
        Product2 productA2B1 = new Product2();
        Product2 productA2B2 = new Product2();

        List<PricebookEntry> pbeList = new List<PricebookEntry>();
        for (Product2 prod : prodList) {
            
            // Assigning out individual Products
            if (prod.Name == 'Product A 1') {
                productA1 = prod;
            } 
            else if (prod.Name == 'Product A 2') {
                productA2 = prod;
            }
            else if (prod.Name == 'Product B 3') {
                productA1B1 = prod;
            }
            else if (prod.Name == 'Product B 4') {
                productA1B2 = prod;
            }
            else if (prod.Name == 'Product B 5') {
                productA2B1 = prod;
            }
            else if (prod.Name == 'Product B 6') {
                productA2B2 = prod;
            }

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

        System.debug('productA1 - ' + productA1);
        System.debug('productA2 - ' + productA2);
        System.debug('productA1B1 - ' + productA1B1);
        System.debug('productA1B2 - ' + productA1B2);
        System.debug('productA2B1 - ' + productA2B1);
        System.debug('productA2B2 - ' + productA2B2);

        PricebookEntry pbeA1 = new PricebookEntry();
        PricebookEntry pbeA2 = new PricebookEntry();

        // Assigning out specific PricebookEntries for the Quote Lines
        for (PricebookEntry pbe : pbeList) {

            // Find the matching Product A1 Id and Quote Price Id
            if(pbe.Product2Id == productA1.Id && pbe.Pricebook2Id == quotePricebook.Id) {
                pbeA1 = pbe;
            }
            // Find the matching Product A2 Id and Quote Price Id
            else if (pbe.Product2Id == productA2.Id && pbe.Pricebook2Id == quotePricebook.Id) {
                pbeA2 = pbe;
            }
        }

        System.debug('pbeA1 - ' + pbeA1);
        System.debug('pbeA2 - ' + pbeA2);

        List<Related_Product__c> rpList = new List<Related_Product__c>();

        // Populating 4 Related Products - Product A1 will recieve 2 ProductB records, and Product A2 will recieve 2 as well
        for (Integer i = 1; i < 5; i++) {
            Related_Product__c rp = new Related_Product__c();
            // First two records get Product A1
            if (i < 3) {
                rp.ProductA__c = productA1.Id;
            } 
            // Last two records get Product A2
            else if (i >= 3) {
                rp.ProductA__c = productA2.Id;
            }
            
            // each new record will recieve a different Product B
            switch on i {
                when 1 {
                    rp.ProductB__c = productA1B1.Id;
                }
                when 2 {
                    rp.ProductB__c = productA1B2.Id;
                }
                when 3 {
                    rp.ProductB__c = productA2B1.Id;
                }
                when else {
                    rp.ProductB__c = productA2B2.Id;
                }
            }

            rpList.add(rp);    
        }

        insert rpList;
        System.debug('Related Product list inserted - ' + rpList);


        SBQQ__Quote__c quote = new SBQQ__Quote__c();
        quote.SBQQ__Account__c = acc.Id;
        quote.SBQQ__Opportunity2__c = opp.Id;
        quote.SBQQ__PriceBookId__c = quotePricebook.Id;
        quote.SBQQ__StartDate__c = Date.Today(); 
        quote.SBQQ__SubscriptionTerm__c = 12;
        insert quote;
        System.debug('Quote Inserted - ' + quote);

        List<SBQQ__QuoteLine__c> qlList = new List<SBQQ__QuoteLine__c>();
        SBQQ__QuoteLine__c qlA1 = new SBQQ__QuoteLine__c();
        qlA1.SBQQ__Product__c = productA1.Id;
        qlA1.SBQQ__Quote__c = quote.Id;
        qlA1.SBQQ__PricebookEntryId__c = pbeA1.Id;
        qlA1.SBQQ__PricingMethod__c = 'List';
        qlA1.SBQQ__StartDate__c = Date.today();
        qlA1.SBQQ__ListPrice__c = 100;
        qlA1.SBQQ__Quantity__c = 1;
        qlA1.SBQQ__PriorQuantity__c = 0;
        qlA1.SBQQ__RegularPrice__c = 100;
        qlA1.SBQQ__NetPrice__c = 100;
        qlA1.SBQQ__Number__c = 1;
        qlA1.SBQQ__ProrateMultiplier__c = 1;
        qlA1.SBQQ__SubscriptionPricing__c = 'Fixed Price';
        qlA1.SBQQ__SubscriptionScope__c = 'Quote';
        qlA1.SBQQ__DefaultSubscriptionTerm__c = 1;
        qlList.add(qlA1);

        SBQQ__QuoteLine__c qlA2 = new SBQQ__QuoteLine__c();
        qlA2.SBQQ__Product__c = productA2.Id;
        qlA2.SBQQ__Quote__c = quote.Id;
        qlA2.SBQQ__PricebookEntryId__c = pbeA2.Id;
        qlA2.SBQQ__PricingMethod__c = 'List';
        qlA2.SBQQ__StartDate__c = Date.today();
        qlA2.SBQQ__ListPrice__c = 100;
        qlA2.SBQQ__Quantity__c = 1;
        qlA2.SBQQ__PriorQuantity__c = 0;
        qlA2.SBQQ__RegularPrice__c = 100;
        qlA2.SBQQ__NetPrice__c = 100;
        qlA2.SBQQ__Number__c = 1;
        qlA2.SBQQ__ProrateMultiplier__c = 1;
        qlA2.SBQQ__SubscriptionPricing__c = 'Fixed Price';
        qlA2.SBQQ__SubscriptionScope__c = 'Quote';
        qlA2.SBQQ__DefaultSubscriptionTerm__c = 1;
        qlList.add(qlA2);

        insert qlList;
        System.debug('Quote Lines Inserted Successfully - ' + qlList);

        System.debug('All Test Data Inserted Successfully');

    }

    /*
    *********************************************************
    Method Name    : testUpdateQLRelatedProductBoms
    Author         : Frank Berni
    Description    : Tests for updateQLRelatedProductBoms
    ********************************************************
    */
    @IsTest
    static void testUpdateQLRelatedProductBoms() {

        // Query Quote's Explode Boms field
        SBQQ__Quote__c quote = [SELECT Id, Explode_Boms__c FROM SBQQ__Quote__c LIMIT 1];

        // Change it from false to true
        quote.Explode_Boms__c = true;

        Test.startTest();
        // Update the quote which will activate trigger
        update quote;
        Test.stopTest();

        // Query the quote line's Related Product Boms
        List<SBQQ__QuoteLine__c> qlList = [SELECT Id, Related_Product_Boms__c FROM SBQQ__QuoteLine__c];

        // Loop through quote lines and assert each Related Product Bom is not empty
        for (SBQQ__QuoteLine__c ql : qlList) {
            System.assert(ql.Related_Product_Boms__c != null, 'The Quote Line is missing its Related Product Product B Names');
        }
        
    }
}