@isTest(SeeAllData=true)
public class PROSReleaseControllerTest {
    @isTest
    private static void testGetReleasesList(){
        String quoId;
        String reId1;
        String reId2;
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt', Email='standarduser@savvas.com',
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = p.Id,
        TimeZoneSidKey='America/Los_Angeles',
         UserName='testUser@savvas.com');
         System.runAs(u) {
            // The following code runs as user 'u'
            System.debug('Current User: ' + UserInfo.getUserName());
            System.debug('Current Profile: ' + UserInfo.getProfileId());
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
            final CameleonCPQ__QuoteRelease__c newRelease2 = new CameleonCPQ__QuoteRelease__c(Name='TEST RELEASE', CameleonCPQ__ReleaseNumber__c=2, CameleonCPQ__QuoteId__c = quo.Id);
            insert newRelease2;
            reId2=newRelease2.Id;
            CameleonCPQ__QuoteContent__c newQuoteContent = new CameleonCPQ__QuoteContent__c(CameleonCPQ__QuoteId__c = quo.Id);
             insert newQuoteContent; 
   
        Test.startTest();
        Test.setMock(WebServiceMock.class, new PROSCAMCPQWSMockImpl());
        List<CameleonCPQ__QuoteRelease__c> resList =PROSReleaseController.getReleasesList(quoId);
        System.assertEquals(resList.size(),2);

        Test.setMock(WebServiceMock.class, new PROSCAMCPQWSMockImpl());

        PROSReleaseController.CPQInfo cpqInfo = PROSReleaseController.setActiveReleaseAndGetStatus(reId1);

        CameleonCPQ__QuoteContent__c[] qc = [SELECT Id FROM CameleonCPQ__QuoteContent__c where CameleonCPQ__QuoteId__c=:quoId];
        System.assert(qc!=null && qc.size() > 0);
        Attachment[] att = [SELECT Id, Body FROM Attachment WHERE ParentId=:qc[0].Id AND Name LIKE '%_content' LIMIT 1];
        System.assert(att!=null && att.size() > 0);
        CameleonCPQ.CPQParser quoteParser = new CameleonCPQ.CPQParser(att[0].Body);
        CameleonCPQ.CPQParser.Quote quote = quoteParser.getQuote();
        Double rel = Double.valueOf(quote.getRelease()!=null ? quote.getRelease() : '0');
        System.assertNotEquals(null, cpqInfo.objectId);
        // System.assertEquals(null, cpqInfo.cpqErr);
        Test.stopTest();
    }   



    }
}