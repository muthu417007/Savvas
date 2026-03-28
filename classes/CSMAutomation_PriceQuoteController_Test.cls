/**
* @File Name : CSMAutomation_PriceQuoteController_Test.cls
* @Description :
* @Author :
* @Last Modified By :
* @Last Modified On : September 18, 2024
* @Modification Log :
*==============================================================================
* Ver | Date | Author | Modification
*==============================================================================
* 1.0 | September 18, 2024 |   | Initial Version
**/
@isTest
public class CSMAutomation_PriceQuoteController_Test {
    
    static testMethod void getStatusPicklistValues() { 
        
        Id schoolAccId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Schools Account').getRecordTypeId();
        Account acc = new Account();
        acc.RecordTypeId = schoolAccId;
        acc.Name = 'Testing Tykes Elementary';
        acc.Type = 'Public District';
        insert acc;
        Product2 productA1 = new Product2();
        productA1.Name = 'Product A ';
        productA1.IsActive = true;
        productA1.SBQQ__DefaultQuantity__c = 1;
        productA1.ProductCode = '123456789123'; 
        
        insert productA1;
        
        
        SBQQ__Quote__c quote = new SBQQ__Quote__c();
        quote.SBQQ__Primary__c = true;
        //quote.Free_Amount__c = 200;
        //quote.Paid_Amount__c = 200;
        //quote.Shipping_and_Handling_Amount__c = 200;
        //quote.Quote_NetTotal__c = 200;
        insert quote;
        
        opportunity op = new opportunity();
        op.Name = 'Test Opp';
        op.StageName = 'Prospect';
        op.CloseDate = date.today();
        op.AccountId = acc.Id;
        op.Discipline__c = 'Humanities';
        op.Discipline_and_Grade_Band__c = 'Humanities 6-8';
        op.SBQQ__PrimaryQuote__c = quote.id;
        
        //op.primary
        insert op;
        
        quote.SBQQ__Opportunity2__c = op.id;
        update quote;
        
        
        
        QuoteLineProgram__c qtlinePrgrm = new QuoteLineProgram__c();
        qtlinePrgrm.Name = 'Test';
        qtlinePrgrm.Quote__c = quote.Id;
        
        
        insert qtlinePrgrm;
        
        SBQQ__QuoteLine__c quoteLine = new SBQQ__QuoteLine__c();
        quoteLine.Paid_Quantity__c = 25;
        quoteLine.ProgramName__c = 'Test';
        //quoteLine.Total_Quantity__c = 100;
        quoteLine.SBQQ__ListPrice__c = 100;
        quoteLine.SBQQ__Description__c = 'Description';
        quoteLine.SBQQ__Quote__c = quote.id;
        quoteLine.ProgramGroup__c = qtlinePrgrm.id;
        //
        SBQQ__QuoteLine__c qlA1 = new SBQQ__QuoteLine__c();
        qlA1.SBQQ__Product__c = productA1.Id;
        qlA1.SBQQ__Description__c = 'Description';
        qlA1.Paid_Quantity__c = 25;
        qlA1.ProgramName__c = 'Test';
        qlA1.ProgramGroup__c = qtlinePrgrm.id;
        qlA1.SBQQ__Quote__c = quote.Id;
        // qlA1.SBQQ__PricebookEntryId__c = pbeA1.Id;
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
        
        insert qlA1;
        system.debug('qlA1'+qlA1);
        
        //insert quoteLine;
        
        
        Test.StartTest();
        CSMAutomation_PriceQuoteController.getQuoteDetails(op.id);
        CSMAutomation_PriceQuoteController.getQuoteLinesData(op.id);
        Test.StopTest();
        
        
        
        
        
        
    }
}