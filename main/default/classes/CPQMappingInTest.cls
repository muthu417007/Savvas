@isTest(seeAllData=true)
public with sharing class CPQMappingInTest {

  static testMethod void test()
  {
        String quoteName = 'TEST_CAM_QUOTE';
        Account a = new Account();
        a.Name = 'TEstAccount';
        a.BillingState = 'NY';
        a.BillingCountry = 'United States';
        a.BillingCity = 'New York';
        insert a;
      
        ID oid = [select ID from User where userrole.name like '%AGM%' and Profile.Name = 'ICOM Sales Rep' limit 1 ].id;
        Opportunity o = new Opportunity();
        o.Name = 'Test Opportunity';
       
        o.Type = 'New';
        o.Amount = 1;
        o.CloseDate = System.today();
        o.ForecastCategoryName = 'Omitted';
        o.StageName = 'Prospect';
        o.LeadSource = 'Cold Contact';
        o.ownerid = oid;
       
        insert o;
        
        CameleonCPQ__Quote__c quote = new CameleonCPQ__Quote__c();
        quote.name = quoteName;
        quote.CPQOpportunityId__c = o.Id;
       quote.CameleonCPQ__AccountId__c = a.Id;
        insert quote;
        
    CPQMappingIn cpqMappingIn = new CPQMappingIn();
    cpqMappingIn.getCPQCustomSettings(quote.Id);
  }
}