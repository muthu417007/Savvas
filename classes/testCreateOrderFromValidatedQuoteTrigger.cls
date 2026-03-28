@isTest(SeeAllData=true)
public class testCreateOrderFromValidatedQuoteTrigger {
    static testMethod void myUnitTest() {
        Account a = new Account(Name='createorderfromquotetest',billingcity = 'New York');
        database.Saveresult asr =database.insert(a);
        id acctid = asr.getId();
        
        Account_Addresses__c aadd = new Account_Addresses__c(Account__c = a.id,Address_Type__c = 'Deliver To');     
        insert aadd;
        Contact c = new Contact();
        c.FirstName = 'John';
        c.LastName = 'Doe';
        //c.Email = 'John.Doe@pearson.com';  6-21-2019 charles.teague@pearson.com to accomodate data validation rule.
        c.Email = 'John.Doe@notarealemail1234.net';
        c.accountid = a.id;
        database.Saveresult csr =database.insert(c);
        id contId = csr.getId();

        date tomorrow = system.today()+1;
         ID oid = [select ID from User where userrole.name like '%AGM%' and Profile.Name = 'ICOM Sales Rep' and Isactive=true limit 1 ].id;
        Opportunity o = new Opportunity(AccountId=acctid,Name='createorderfromquotetest', StageName='Short List',Discipline_and_Grade_Band__c = 'Intervention 6-8', CloseDate=tomorrow,ownerid = oid);
        database.Saveresult osr =database.insert(o);
        id oppid = osr.getId();
        CameleonCPQ__Quote__c q = new CameleonCPQ__Quote__c();
        q.CameleonCPQ__AccountId__c = acctid;
        q.CPQOpportunityId__c = oppid;
        q.Name='createorderfromquotetest';
        q.PONumber__c = '12345';
        database.Saveresult qsr =database.insert(q);
        id quoteid = qsr.getId();
        CameleonQuoteLineItem__c i = new CameleonQuoteLineItem__c();
        i.Cameleon_Quote__c = quoteid;
        i.Net_Price__c = 1;
        i.Quantity__c = 3;
        i.ERP_Supplier__c = 'Oracle_EBS';
        insert i;
        CameleonQuoteLineItem__c i2 = new CameleonQuoteLineItem__c();
        i2.Cameleon_Quote__c = quoteid;
        i2.Net_Price__c = 1;
        i2.Quantity__c = 3;
        i2.ERP_Supplier__c = 'SAP_USK12';
        insert i2;
        
        CameleonQuoteLineItemSite__c qlis = new CameleonQuoteLineItemSite__c (Quote_Line_Item__c = i.id);
        qlis.Account__c = a.id;
        qlis.Site_Address__c = aadd.id;
        qlis.Site_Contact__c = c.id;
        qlis.Quantity__c = 1;
        insert qlis;

        
        q.CameleonCPQ__Status__c = 'Validated';
        q.OrderValidationApprovalsReceived__c = True;
        q.OrderValidationChecklistComplete__c = True;
        q.OrderValidationCreditAppAccepted__c = True;        
        q.OrderValidationPOReviewComplete__c = True;
        q.OrderValidationQuoteReviewComplete__c = True;      
        update q;   
        
    }
    static testMethod void myUnitTest1() {
        Account a = new Account(Name='createorder2fromquotetest',billingcity = 'New York');
        database.Saveresult asr =database.insert(a);
        id acctid = asr.getId();
        
        Account_Addresses__c aadd = new Account_Addresses__c(Account__c = a.id,Address_Type__c = 'Deliver To');     
        insert aadd;
        Contact c = new Contact();
        c.FirstName = 'Jane';
        c.LastName = 'Doe';
        //c.Email = 'Jane.Doe@pearson.com';  6-21-2019 charles.teague@pearson.com to accomodate data validation rule.
        c.Email = 'Jane.Doe@notarealemail1234.net';
        c.accountid = a.id;
        database.Saveresult csr =database.insert(c);
        id contId = csr.getId();

        date tomorrow = system.today()+1;
        ID oid = [select ID from User where userrole.name like '%AGM%' and Profile.Name = 'ICOM Sales Rep' and Isactive=true limit 1 ].id;
        Opportunity o = new Opportunity(AccountId=acctid,Name='createorder2fromquotetest', StageName='Short List',Discipline_and_Grade_Band__c = 'Intervention 6-8', CloseDate=tomorrow,ownerid = oid);
        database.Saveresult osr =database.insert(o);
        id oppid = osr.getId();
        CameleonCPQ__Quote__c q = new CameleonCPQ__Quote__c();
        q.CameleonCPQ__AccountId__c = acctid;
        q.CPQOpportunityId__c = oppid;
        q.Name='createorderfromquotetest';
        q.PONumber__c = '12345';
        database.Saveresult qsr =database.insert(q);
        id quoteid = qsr.getId();
        CameleonQuoteLineItem__c i = new CameleonQuoteLineItem__c();
        i.Cameleon_Quote__c = quoteid;
        i.Net_Price__c = 1;
        i.Quantity__c = 3;
        i.ERP_Supplier__c = 'SAP_USK12';
        insert i;
                
        q.CameleonCPQ__Status__c = 'Validated';
        q.OrderValidationApprovalsReceived__c = True;
        q.OrderValidationChecklistComplete__c = True;
        q.OrderValidationCreditAppAccepted__c = True;        
        q.OrderValidationPOReviewComplete__c = True;
        q.OrderValidationQuoteReviewComplete__c = True;      
        update q;  
        q.Sent_to_OASIS__c = True;
        update q;
        
    }
}