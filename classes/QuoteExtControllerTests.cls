/*
*********************************************************
Class Name       : QuoteExtControllerTests
Created Date     : 4/08/2024  
Author           : Brent Mac - Cognizant
Description      : Out of box Test class for Advanced Approvals: QuoteExtController
Percentage       : 100%

History:
<Date>          <Authors Name>              <Brief Description of Change>
4/08/2024       Brent Mac                   Initial creation
5/09/2024       Frank Berni                 Updated testSubmit and testRecall assert statements, Created testSubmitForApproval method
9/25/2024       Frank Berni                 Updated testSubmit and testSubmitForApproval to resolve Validation rule conflicts
**********************************************************/
@isTest
private class QuoteExtControllerTests {

    
    /*
    *********************************************************
    Method Name    : testSubmit
    Author         : Frank Berni
    Description    : Modified test method for out of box Advanced Approval test method. Asserts for pageRef instead
    ********************************************************
    */
    testMethod static void testSubmit() {
            
            SBQQ__Quote__c quote = new SBQQ__Quote__c();
            quote.isTest__c = true;
            insert quote;

            Test.startTest();
            QuoteExtController con = new QuoteExtController(new ApexPages.StandardController(quote));
            // con.onSubmit();
            PageReference pageRef = con.onSubmit();

            quote = [SELECT ApprovalStatus__c FROM SBQQ__Quote__c WHERE Id = :quote.Id LIMIT 1];
            Test.stopTest();
            
            System.assertEquals('Presented', quote.ApprovalStatus__c);
           //System.assertEquals('/' + quote.Id, pageRef.getUrl(), 'PageReference should point to the correct URL');
        // }
    }
    
    /*
    *********************************************************
    Method Name    : testRecall
    Author         : Frank Berni
    Description    : Modified test method for out of box Advanced Approval test method. Asserts for pageRef instead
    ********************************************************
    */
    testMethod static void testRecall() {
        SBQQ__Quote__c quote = new SBQQ__Quote__c();
        quote.isTest__c = true;
        insert quote;
        
        Test.startTest();
        QuoteExtController con = new QuoteExtController(new ApexPages.StandardController(quote));
        // con.onRecall();
        PageReference pageRef = con.onRecall();

        // quote = [SELECT ApprovalStatus__c FROM SBQQ__Quote__c WHERE Id = :quote.Id LIMIT 1];
        Test.stopTest();
        
        // System.assertEquals('Recalled', quote.ApprovalStatus__c);
        System.assertEquals('/' + quote.Id, pageRef.getUrl(), 'PageReference should point to the correct URL');
    } 

    /*
    *********************************************************
    Method Name    : testSubmitForApproval
    Author         : Frank Berni
    Description    : Tests for submitForApproval in QuoteExtController that returns SBAA__Approval__c records
    ********************************************************
    */
    testMethod static void testSubmitForApproval() {
        SBQQ__Quote__c quote = new SBQQ__Quote__c();
        quote.isTest__c = true;
        insert quote;

        List<Id> quoteIds = new List<Id>{quote.Id};
        Test.startTest();
        List<SBAA__Approval__c> approvals = QuoteExtController.submitForApproval(quoteIds);
        Test.stopTest();

        System.assert(approvals != null, 'Returned Approvals list did not return properly');

    }
}