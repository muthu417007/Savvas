@isTest
private class OpportunityControllerTest {

    @TestSetup
    private static void makeData(){
        Account acc = new Account(Name='test acc',billingcity = 'New York');
        insert acc;
        Opportunity opp = new Opportunity(Name = 'test Opportunity', AccountId = acc.Id, 
                                          StageName = 'Prospect', CloseDate = Date.today(), CurrencyIsoCode = 'USD');
        insert opp;
    }
    
    @isTest
    private static void testGetRecentOppId(){
        String accId = [SELECT Id FROM Account][0].Id;
        String oppId = OpportunityController.getRecentOppId(accId);
        System.assert(oppId != null, 'Opportunity Id should be returned');
    }
}