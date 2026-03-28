/*
*********************************************************
Class Name       : QuoteRecallControllerTests
Created Date     : 5/09/2024  
Author           : Brent Mac - Cognizant
Description      : Out of box Test class for Advanced Approvals: QuoteRecallController
Percentage       : 100%

History:
<Date>          <Authors Name>              <Brief Description of Change>
4/09/2024       Brent Mac                   Initial creation
5/10/2024       Frank Berni                 Updated testSubmitForApproval method
**********************************************************/
@isTest
private class QuoteRecallControllerTests {
    
    /*
    *********************************************************
    Method Name    : testSubmitForApproval
    Author         : Brent Mac + Frank Berni
    Description    : Tests for submitForApproval in QuoteRecallController that returns SBAA__Approval__c records
    ********************************************************
    */
    testMethod static void testSubmitForApproval() {
        SBQQ__Quote__c quote = new SBQQ__Quote__c();
        String comments = 'Recalling Nevermind';
        insert quote;
        List<Id> quoteIds = new List<Id>{quote.Id};
        Test.startTest();
        QuoteRecallController con = new QuoteRecallController(new ApexPages.StandardController(quote));

        List<SBAA__Approval__c> approvals = QuoteRecallController.submitForApproval(quoteIds);
        Test.stopTest();

        System.assert(con != null, 'QuoteRecallController not set up properly');
        System.assert(approvals != null, 'Recalled Approvals list did not return properly');

    }
    
}