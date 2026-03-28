@isTest(SeeAllData=true)
public class testQuoteRefreshClass {
     static testMethod void myUnitTest() {
        Account a = new Account(Name='AccountName');
        database.Saveresult asr =database.insert(a);
        id acctid = asr.getId();
    
        Account_Addresses__c aadd = new Account_Addresses__c(Account__c = a.id,Address_Type__c = 'Deliver To');     
        insert aadd;
        Contact c = new Contact();
        c.FirstName = 'John';
        c.LastName = 'Doe';
        //c.Email = 'John.Doe@pearson.com'; 6-21-2019 charles.teague@pearson.com to accomodate data validation rule.
        c.Email = 'John.Doe@notarealemail1234.net';
        c.accountid = a.id;
        database.Saveresult csr =database.insert(c);
        id contId = csr.getId();

        date tomorrow = system.today()+1;
        ID oid = [select ID from User where userrole.name like '%AGM%' and Profile.Name = 'ICOM Sales Rep' and Isactive=true limit 1 ].id;
        Opportunity o = new Opportunity(AccountId=acctid,Name='OppquoteRefreshtest',Discipline_and_Grade_Band__c = 'Intervention 6-8', StageName='Short List', CloseDate=tomorrow,Amount=10,Total_Contract_Value__c=10,ownerid=oid);
        database.Saveresult osr =database.insert(o);
        id oppid = osr.getId();
        CameleonCPQ__Quote__c q = new CameleonCPQ__Quote__c();
        q.CameleonCPQ__AccountId__c = acctid;
        q.CPQOpportunityId__c = oppid;
        q.Name='quoteRefreshtest';
        database.Saveresult qsr =database.insert(q);
        id quoteid = qsr.getId();
        
        CameleonCPQ__QuoteRelease__c qr = new CameleonCPQ__QuoteRelease__c ();
        qr.Name = 'QuoteRelease1';
        qr.CameleonCPQ__AccountId__c = acctid;
        qr.CameleonCPQ__QuoteId__c = quoteid;
        qr.CameleonCPQ__ReleaseNumber__c = 1;
        insert qr;
        
        Decimal DecimalRelease = qr.CameleonCPQ__ReleaseNumber__c;
        String ReleaseNumber = string.valueof(DecimalRelease.intValue());
        //CPQQuoteRefresher.refresh(quoteid, ReleaseNumber, 'RefreshQuote'); 

        CameleonCPQ__Quote__c quote = new CameleonCPQ__Quote__c();
        quote.Id = quoteid;
        quote.CameleonCPQ__ActiveRelease__c = qr.CameleonCPQ__ReleaseNumber__c;
      
        List<CameleonCPQ__Quote__c> quotes= new List<CameleonCPQ__Quote__c>();
        quotes.add(quote);

        CPQQuoteRefresher.synchronizeQuotes(quotes);
     
     }

}