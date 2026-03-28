/*
*********************************************************
Class Name       : AddOpptyProductsControllerExtensionTest
Created Date     : 7/10/2024  
Author           : Frank Berni - Cognizant
Description      : Test class for AddOpptyProductsControllerExtension
Percentage       : 93%

History:
<Date>          <Authors Name>              <Brief Description of Change>
7/10/2024       Frank Berni                 Initial creation
**********************************************************/
@IsTest
public with sharing class AddOpptyProductsControllerExtensionTest {
    
    @TestSetup
    static void setup() {

        Id schoolAccId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Schools Account').getRecordTypeId();

        Account acc = new Account();
        acc.RecordTypeId = schoolAccId;
        acc.Name = 'Testing Tykes Elementary';
        acc.Type = 'Public District';
        insert acc;
        System.debug('Account Inserted - ' + acc);

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
        prod1.Business_Line__c = 'Services';
        prod1.Family = 'Math';
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
        prod2.Business_Line__c = 'Services';
        prod2.Family = 'Math';
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

        Opportunity opp = new Opportunity();
        opp.Name = 'Tykes Elem - Envision Core Offerings';
        opp.CloseDate = Date.Today();
        opp.StageName = 'Prospect';
        opp.AccountId = acc.Id;
        opp.Pricebook2Id = quotePricebook.id;
        insert opp;
        System.debug('Opportunity Inserted - ' + opp);

        List<PricebookEntry> pbeList = new List<PricebookEntry>();
        for (Product2 prod : prodList) {
            // Standard pricebook
            PricebookEntry pbe = new PricebookEntry();
            pbe.Product2Id = prod.Id;
            pbe.Pricebook2Id = testPriceBook.Id;
            pbe.UnitPrice = 17.50;
            pbe.IsActive = true;
            pbe.ProductFamily_Entry__c = true;
            pbeList.add(pbe);

            // Quote pricebook
            PricebookEntry pbe2 = new PricebookEntry();
            pbe2.Product2Id = prod.Id;
            pbe2.Pricebook2Id = quotePricebook.Id;
            pbe2.UnitPrice = 17.50;
            pbe2.IsActive = true;
            pbe2.ProductFamily_Entry__c = true;
            pbeList.add(pbe2);
        }
        
        insert pbeList;
        System.debug('Pricebook Entries Inserted - ' + pbeList);
        
    }

    @IsTest
    static void testController() {
        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
        PricebookEntry pbe1 = [SELECT Id FROM PricebookEntry WHERE Name = 'Test Tykes Math' LIMIT 1];
        PricebookEntry pbe2 = [SELECT Id FROM PricebookEntry WHERE Name = 'Test Tykes Math Pre-Algebra' LIMIT 1];

        // initialize controller
        ApexPages.StandardController sc = new ApexPages.StandardController(opp);
        AddOpptyProductsControllerExtension controller = new AddOpptyProductsControllerExtension(sc);

        // Test for getFilteredPbEntries method
        controller.getFilteredPbEntries();

        System.assert(controller.pbEntrylist.size() > 0, 'Pricebook Entries of ProductFamily__c = true should be loaded');

        // Tests for searchPbEntries method
        controller.searchTerm = 'Test Tykes Math Pre-Algebra';

        controller.searchPbEntries();

        System.assert(controller.searchedPbEntrylist.size() == 1, 'Searched Pricebook Entries should be 1');

        // Tests for moveToReview method
        controller.pbEntrylist[0].selected = true;

        controller.moveToReview();

        System.assert(controller.isReviewStep == true, 'Should be in review step');
        System.assert(controller.oppLineItems.size() == 1, 'Oppty Line Items should be 1');

        // Tests for removeLineItem method
        String testUniqueId = controller.oppLineItems[0].uniqueId;
    
        ApexPages.currentPage().getParameters().put('uniqueId', testUniqueId);
        controller.removeLineItem();

        System.assert(controller.oppLineItems.size() == 0, 'Oppty Line Items should be removed');

        // Tests for saveOppLineItems method
        controller.pbEntrylist[0].selected = true;
        controller.moveToReview();
        controller.oppLineItems[0].opportunityLineItem.Quantity = 10;
        controller.oppLineItems[0].opportunityLineItem.UnitPrice = 100;

        Test.startTest();
        controller.saveOppLineItems();
        Test.stopTest();

        OpportunityLineItem oli = [SELECT Id FROM OpportunityLineItem WHERE OpportunityId =:opp.Id LIMIT 1];
        System.assert(oli != null, 'Oppty Line Item should be inserted');
    }

    @IsTest
    static void testMoveToSelectionAndCancel() {
        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];

        ApexPages.StandardController sc = new ApexPages.StandardController(opp);
        AddOpptyProductsControllerExtension controller = new AddOpptyProductsControllerExtension(sc);

        controller.moveToReview();
        controller.moveToSelection();
        

        System.assert(controller.isReviewStep == false, 'Should be in selection step');

        PageReference pageRef = controller.cancel();
        Test.startTest();
        Test.setCurrentPage(pageRef);
        Test.stopTest();

        System.assertEquals('/' + opp.Id, pageRef.getUrl(), 'Should redirect to Oppty record page');
    }
}