/* -----------------------------------------------------------------------------------------------------------------------
Name:        PROSCustomCloneCtrlTest
Description: This is test class for the PROSCustomCloneCtrl apex class
Date         Version  Author             Summary of Changes
-----------  -------  -----------------  ------------------------------------------------------------------------------
09/12/2021     1.0     Initial Dev       This fuctionality is initiated from Clone Quote button on CameleonCPQ__Quote__c object
-------------------------------------------------------------------------------------------------------------------------- */
@isTest(SeeAllData=true)
public  class PROSCustomCloneCtrlTest {
    @IsTest
    static void validateOppTest(){
        String quoId;
        String reId1;
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt', Email='standarduser@savvas.com',
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = p.Id,
        TimeZoneSidKey='America/Los_Angeles',
        UserName='testUser@savvas.com');
        System.runAs(u) {
            Account acc = new Account(Name='test acc',billingcity = 'New York');
            insert acc;
            Opportunity opp = new Opportunity(Name = 'test Opportunity', AccountId = acc.Id, 
            StageName = 'Prospect', CloseDate = Date.today(), CurrencyIsoCode = 'USD');
            insert opp;
            CameleonCPQ__Quote__c quo = new CameleonCPQ__Quote__c(Name = 'test quo', CPQOpportunityId__c = opp.Id,CameleonCPQ__AccountId__c = acc.Id);
            insert quo;
            quoId=quo.Id;
            final CameleonCPQ__QuoteRelease__c newRelease1 = new CameleonCPQ__QuoteRelease__c(Name='TEST RELEASE', CameleonCPQ__ReleaseNumber__c=1, CameleonCPQ__QuoteId__c = quo.Id);
            insert newRelease1;
            reId1=newRelease1.Id;
            CameleonCPQ__QuoteContent__c newQuoteContent = new CameleonCPQ__QuoteContent__c(CameleonCPQ__QuoteId__c = quo.Id);
            insert newQuoteContent; 
            Test.startTest();
                try{
                    PROSCustomCloneCtrl.validateOpp(opp.id);
                }
                catch(Exception e){
                    System.assert(e.getMessage().contains('The Opportunity must have primary contact'));
                }
                try {
                    Contact contact = new Contact(FirstName='Testing', LastName='Testing', Email='standarduser@savvas.com');
                    insert contact;
                    Opportunity opp2 = new Opportunity(Name = 'test Opportunity', AccountId = acc.Id, ContactId=contact.id,
                    StageName = 'Prospect', CloseDate = Date.today(), CurrencyIsoCode = 'USD');
                    insert opp2;
                    CameleonCPQ__Quote__c quo2 = new CameleonCPQ__Quote__c(Name = 'test quo', CPQOpportunityId__c = opp2.Id,CameleonCPQ__AccountId__c = acc.Id);
                    insert quo2;
                    PROSCustomCloneCtrl.validateOpp(opp2.id);

                } catch (Exception e) {
                    System.debug('FOOT ' +e.getMessage());
                    System.assert(e.getMessage().contains('The Opportunity has an associated quote already'));
                }
            Test.stopTest();
        }
    }

    @IsTest
    static void cloneQuoteContentTest(){
        String quoId;
        String reId1;
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt', Email='standarduser@savvas.com',
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = p.Id,
        TimeZoneSidKey='America/Los_Angeles',
        UserName='testUser@savvas.com');
        System.runAs(u) {
            Account acc = new Account(Name='test acc',billingcity = 'New York');
            insert acc;
            Opportunity opp = new Opportunity(Name = 'test Opportunity', AccountId = acc.Id, 
            StageName = 'Prospect', CloseDate = Date.today(), CurrencyIsoCode = 'USD');
            insert opp;
            Opportunity opp2 = new Opportunity(Name = 'test Opportunity', AccountId = acc.Id, 
            StageName = 'Prospect', CloseDate = Date.today(), CurrencyIsoCode = 'USD');
            insert opp2;
            CameleonCPQ__Quote__c quo = new CameleonCPQ__Quote__c(Name = 'test quo', CPQOpportunityId__c = opp.Id,CameleonCPQ__AccountId__c = acc.Id);
            insert quo;
            CameleonCPQ__Quote__c quo2 = new CameleonCPQ__Quote__c(Name = 'test quo', CPQOpportunityId__c = opp2.Id,CameleonCPQ__AccountId__c = acc.Id);
            insert quo2;
            final CameleonCPQ__QuoteRelease__c newRelease1 = new CameleonCPQ__QuoteRelease__c(Name='TEST RELEASE', CameleonCPQ__ReleaseNumber__c=1, CameleonCPQ__QuoteId__c = quo.Id);
            insert newRelease1;
            reId1=newRelease1.Id;
            CameleonCPQ__QuoteContent__c newQuoteContent = new CameleonCPQ__QuoteContent__c(CameleonCPQ__QuoteId__c = quo.Id);
            insert newQuoteContent;
            CameleonQuoteLineItem__c lineItem1 = new CameleonQuoteLineItem__c();
            lineItem1.Cameleon_Quote__c = quo.Id;
            lineItem1.Net_Price__c = 1;
            lineItem1.Quantity__c = 3;
            lineItem1.ERP_Supplier__c = 'SAP_USK12';
            insert lineItem1;

            CameleonQuoteLineItem__c lineItem2 = new CameleonQuoteLineItem__c();
            lineItem2.Cameleon_Quote__c = quo.Id;
            lineItem2.Net_Price__c = 5;
            lineItem2.Quantity__c = 5;
            lineItem2.ERP_Supplier__c = 'SAP_USK12';
            insert lineItem2; 
            Test.startTest();
                //PROSCustomCloneCtrl.CPQInfo cpqInfo =
                PROSCustomCloneCtrl.cloneQuoteContent(quo.Id,quo2.Id,'1',true);
            Test.stopTest();
        }
    }
}