@isTest(SeeAllData=true)
public class testCreateOrderFromReleasedQuote {
	
    static testMethod void quoteWithSiteOrderCreationSucceeds() {
    	
        Account acct = new Account(Name='createorderfromquotetest',billingcity = 'New York');
        database.Saveresult asr = database.insert(acct);
        id acctid = asr.getId();
        Account_Addresses__c acctAddr = new Account_Addresses__c(Account__c = acct.id,Address_Type__c = 'Deliver To');     
        insert acctAddr;

        Account acct_2 = new Account(Name='createorderfromquotetest_2',billingcity = 'Newark');
        database.Saveresult asr_2 = database.insert(acct_2);
        id acctid_2 = asr_2.getId();
        Account_Addresses__c acctAddr_2 = new Account_Addresses__c(Account__c = acct_2.id,Address_Type__c = 'Deliver To');     
        insert acctAddr_2;
        
        Contact cntct = new Contact();
        cntct.FirstName = 'John';
        cntct.LastName = 'Doe';
        cntct.Email = 'John.Doe@notarealemail12345.com';
        cntct.accountid = acct.id;
        database.Saveresult csr = database.insert(cntct);
        id cntctId = csr.getId();

        date tomorrow = system.today()+1;
        id oid = [select ID from User where userrole.name like '%AGM%' and Profile.Name = 'ICOM Sales Rep' and Isactive=true limit 1 ].id;
        Opportunity o = new Opportunity(AccountId=acctid, Name='createorderfromquotetest', Discipline_and_Grade_Band__c = 'Intervention 6-8', StageName='Short List', CloseDate=tomorrow,ownerid = oid);
        database.Saveresult osr = database.insert(o);
        
        id oppid = osr.getId();
        CameleonCPQ__Quote__c testQuote = new CameleonCPQ__Quote__c();
        testQuote.CameleonCPQ__AccountId__c = acctid;
        testQuote.CPQOpportunityId__c = oppid;
        testQuote.CameleonCPQ__Status__c = 'Accepted'; 
        testQuote.OrderValidationApprovalsReceived__c = True;
        testQuote.OrderValidationChecklistComplete__c = True;
        testQuote.OrderValidationCreditAppAccepted__c = True;        
        testQuote.OrderValidationPOReviewComplete__c = True;
        testQuote.OrderValidationQuoteReviewComplete__c = True;       
        testQuote.Name='createorderfromquotetest';
        testQuote.PONumber__c = '12345';
        database.Saveresult qsr = database.insert(testQuote);      
        id testQuoteId = qsr.getId();
        
        // create Quote Release
        CameleonCPQ__QuoteRelease__c quoteRelease = new CameleonCPQ__QuoteRelease__c();
        quoteRelease.CameleonCPQ__QuoteId__c = testQuoteId;
        quoteRelease.CameleonCPQ__ReleaseNumber__c = 1;
        quoteRelease.CameleonCPQ__Status__c = 'Accepted';
        database.SaveResult quoteReleaseSaveResult = database.insert(quoteRelease);
        id quoteReleaseId = quoteReleaseSaveResult.getId();

        List<CameleonCPQ__QuoteRelease__c> activeReleases = new List<CameleonCPQ__QuoteRelease__c>([select Id, Active__c, CameleonCPQ__ReleaseNumber__c, 
                                                                                                   Order__c, CameleonCPQ__QuoteId__c 
                                                                                                   from CameleonCPQ__QuoteRelease__c 
                                                                                                   where CameleonCPQ__QuoteId__c =: testQuoteId 
                                                                                                   and Active__c = true]);
        CameleonCPQ__QuoteRelease__c quoteActiveRelease = activeReleases.get(0);

    
        CameleonQuoteLineItem__c lineItem1 = new CameleonQuoteLineItem__c();
        lineItem1.Cameleon_Quote__c = testQuoteId;
        lineItem1.Net_Price__c = 1;
        lineItem1.Quantity__c = 3;
        lineItem1.ERP_Supplier__c = 'SAP_USK12';
        insert lineItem1;

        CameleonQuoteLineItem__c lineItem2 = new CameleonQuoteLineItem__c();
        lineItem2.Cameleon_Quote__c = testQuoteId;
        lineItem2.Net_Price__c = 5;
        lineItem2.Quantity__c = 5;
        lineItem2.ERP_Supplier__c = 'SAP_USK12';
        insert lineItem2;
        
        CameleonQuoteLineItem__c lineItem3 = new CameleonQuoteLineItem__c();
        lineItem3.Cameleon_Quote__c = testQuoteId;
        lineItem3.Account__c = acct.id;
        lineItem3.Net_Price__c = 10;
        lineItem3.Quantity__c = 20;
        lineItem3.ERP_Supplier__c = 'SAP_USK12';
        insert lineItem3;


        integer lineItemCount = 0;
        lineItemCount = ([select count() from CameleonQuoteLineItem__c where Cameleon_Quote__c = :testQuoteId]);
        system.debug(' lineItem1 id is: ' + lineItem1.id + ' sitesQuantityRollup: ' + lineItem1.Sites_Quantity_Roll_Up__c);
     
        CameleonQuoteLineItemSite__c qlis = new CameleonQuoteLineItemSite__c (Quote_Line_Item__c = lineItem1.id);
        qlis.Account__c = acct.id;
        qlis.Site_Address__c = acctAddr.id;
        qlis.Site_Contact__c = cntctId;
        qlis.Quantity__c = 1;
        insert qlis;
        
        CameleonQuoteLineItemSite__c qlis_2 = new CameleonQuoteLineItemSite__c (Quote_Line_Item__c = lineItem2.id);
        qlis_2.Account__c = acct_2.id;
        qlis_2.Site_Address__c = acctAddr_2.id;
        qlis_2.Site_Contact__c = cntctId;
        qlis_2.Quantity__c = 2;
        insert qlis_2;
        
        system.debug(' -- testCreateOrderFromReleasedQuote at call: ReleaseId: ' + quoteActiveRelease.Id + ' isActive: ' + quoteActiveRelease.Active__c + ' number: ' + quoteActiveRelease.CameleonCPQ__ReleaseNumber__c);

        List<CameleonCPQ__QuoteRelease__c> quoteReleasesToProcess = new List<CameleonCPQ__QuoteRelease__c>();
        quoteReleasesToProcess.add(quoteActiveRelease);
        
        CPQQuoteMgr.createOrderFromReleasedQuote(quoteReleasesToProcess);
        
        List<Order__c> createdOrders = new List<Order__c>([select Id, Account__c, Cameleon_Quote__c, Quote_Release__c, 
                                                           LineItemCount__c from Order__c where Cameleon_Quote__c =: testQuoteId]);

        system.assertEquals(1, createdOrders.size(),'Expected Order was not created');
        
        Order__c createdOrder = createdOrders.get(0);
        system.assertEquals(3, createdOrder.LineItemCount__c,'Order LineItemCount__c is not expected 3');
        
    }
    
}