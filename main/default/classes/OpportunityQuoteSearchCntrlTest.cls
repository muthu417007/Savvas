/* -----------------------------------------------------------------------------------------------------------------------
Name:        OpportunityQuoteSearchCntrlTest
Description: This is test class for OpportunityQuoteSearchCntrl.
Date         Version  Author             Summary of Changes
-----------  -------  -----------------  ------------------------------------------------------------------------------
06/02/2022     1.0     Smitha Prabhu      Initial Release
-------------------------------------------------------------------------------------------------------------------------- */
@isTest
public class OpportunityQuoteSearchCntrlTest {
    @testsetup
    public static void testsetUp(){
        Account acc = new Account(name = 'Test');
        insert acc;
        
        Case objCase = new Case(accountId = acc.Id, subject ='User Offboarding started for test', Description='Hi Team,The following employee is being offboarded: Name: test User ID: VBOSWTO Email Address: thomas.taylor@savvas.com');
        insert objCase;
        
       Integer year = system.today().year();
        Date d1 = Date.valueOf(year+'-09-30');
        year+=1;
        Date d2 = Date.valueOf(year+'-09-30');
        
        CameleonCPQ__Quote__c objQuote = new CameleonCPQ__Quote__c(CameleonCPQ__AccountId__c = acc.Id, CPQ_Future_Pricing_Date__c = d1);
        insert objQuote;
        
        CameleonCPQ__Quote__c objQuote2 = new CameleonCPQ__Quote__c(CameleonCPQ__AccountId__c = acc.Id, CPQ_Future_Pricing_Date__c = d2);
        insert objQuote2;
        
        CameleonCPQ__QuoteRelease__c newRelease1 = new CameleonCPQ__QuoteRelease__c(Name='TEST RELEASE', CameleonCPQ__ReleaseNumber__c=1, CameleonCPQ__QuoteId__c = objQuote.Id);
        insert newRelease1;
        
        CameleonCPQ__QuoteRelease__c newRelease2 = new CameleonCPQ__QuoteRelease__c(Name='TEST RELEASE2', CameleonCPQ__ReleaseNumber__c=2, CameleonCPQ__QuoteId__c = objQuote2.Id);
        insert newRelease2;
        
        Order__c objOrder = new Order__c(Cameleon_Quote__c = objQuote.Id, Account__c = acc.Id);
        insert objOrder;
        
        Order__c objOrder2 = new Order__c(Cameleon_Quote__c = objQuote2.Id, Account__c = acc.Id);
        insert objOrder2;
    }
    
	@isTest(seeAllData = false)
    static void getOrdersTest()
    {
        String accId = [SELECT Id FROM Account LIMIT 1].Id;
        Test.startTest();
        	system.assert(OpportunityQuoteSearchCntrl.getOrders(accId).size() > 0);
        Test.stopTest();
    }
}