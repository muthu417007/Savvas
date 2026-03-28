@isTest(SeeAllData=true)
public class testnewQuoteProxyControllerExtension{
        static testMethod void myUnitTest() {
            Account a = new Account(Name='createOpportunityAccount',BillingCity = 'New York');
            database.Saveresult asr =database.insert(a);
            id acctid = asr.getId();
            Opportunity o = new Opportunity (Name='createOpportunity');
            ID oid = [select ID from User where userrole.name like '%AGM%' and Profile.Name = 'ICOM Sales Rep' and Isactive=true limit 1 ].id;
            o.ownerid = oid;
            o.Type = 'New';
            o.Amount = 1;
            o.StageName = 'Prospect';
            o.CloseDate = date.today()+5;
            database.Saveresult osr =database.insert(o);
            id oppid = osr.getId();
            Contact c = new Contact();
            c.FirstName = 'John';
            c.LastName = 'Doe';
            c.Email = 'John.Doe@pearson.com';
            database.Saveresult csr =database.insert(c);
            id contId = csr.getId();
            OpportunityContactRole oc = new  OpportunityContactRole ();
            oc.OpportunityId = oppid;
            oc.Role = 'Primary Sales Contact';
            oc.IsPrimary = True;
            oc.ContactId = contId;
            insert oc;
            CameleonCPQ__Quote__c cq = new CameleonCPQ__Quote__c(Name='CreateQuote',CPQOpportunityId__c=o.Id);
            insert cq;

            newQuoteProxyControllerExtension controller = new newQuoteProxyControllerExtension(new ApexPages.StandardController(o));
            PageReference pageRef = controller.getNewQuotePage();      
            string getError = controller.getErrorURL();
            string getErrorText = controller.getErrorText();
        }
        
        static testMethod void myUnitTest2() {
            Account a = new Account(Name='createOpportunityAccount',BillingCity = 'New York');
            database.Saveresult asr =database.insert(a);
            id acctid = asr.getId();
            Opportunity o = new Opportunity (Name='createOpportunity');
            ID oid = [select ID from User where userrole.name like '%AGM%' and Profile.Name = 'ICOM Sales Rep' and Isactive=true limit 1 ].id;
            o.ownerid = oid;
            o.Type = 'New';
            o.Amount = 1;
            o.StageName = 'Prospect';
            o.CloseDate = date.today()+5;
            database.Saveresult osr =database.insert(o);
            id oppid = osr.getId();
            CameleonCPQ__Quote__c cq = new CameleonCPQ__Quote__c(Name='CreateQuote',CPQOpportunityId__c=o.Id);
            insert cq;

            newQuoteProxyControllerExtension controller = new newQuoteProxyControllerExtension(new ApexPages.StandardController(o));
         }
         
          static testMethod void myUnitTest3() {
            Account a = new Account(Name='createOpportunityAccount',BillingCity = 'New York');
            database.Saveresult asr =database.insert(a);
            id acctid = asr.getId();
            Opportunity o = new Opportunity (Name='createOpportunity');
            ID oid = [select ID from User where userrole.name like '%AGM%' and Profile.Name = 'ICOM Sales Rep' and Isactive=true limit 1 ].id;
            o.ownerid = oid;
            o.Type = 'New';
            o.Amount = 1;
            o.StageName = 'Prospect';
            o.CloseDate = date.today()+5;
            database.Saveresult osr =database.insert(o);
            id oppid = osr.getId();
            CameleonCPQ__Quote__c cq = new CameleonCPQ__Quote__c(Name='CreateQuote',CPQOpportunityId__c=o.Id);
            insert cq;
            Contact c = new Contact();
            c.FirstName = 'John';
            c.LastName = 'Doe';
            c.Email = 'John.Doe@pearson.com';
            database.Saveresult csr =database.insert(c);
            id contId = csr.getId();
            OpportunityContactRole oc = new  OpportunityContactRole ();
            oc.OpportunityId = oppid;
            oc.Role = 'Primary Sales Contact';
            oc.IsPrimary = True;
            oc.ContactId = contId;
            insert oc;
            CameleonCPQ__Quote__c cq0 = new CameleonCPQ__Quote__c(Name='CreateQuote',CPQOpportunityId__c=o.Id);
            insert cq0;
            CameleonCPQ__Quote__c cq1 = new CameleonCPQ__Quote__c(Name='CreateQuote2',CPQOpportunityId__c=o.Id);
            insert cq1;

            newQuoteProxyControllerExtension controller = new newQuoteProxyControllerExtension(new ApexPages.StandardController(o));
         }
            static testMethod void myUnitTest4() {
            Account a = new Account(Name='createOpportunityAccount',BillingCity = 'New York');
            database.Saveresult asr =database.insert(a);
            id acctid = asr.getId();
            Opportunity o = new Opportunity (Name='createOpportunity');
            o.Type = 'New';
            o.Amount = 1;
            o.StageName = 'Prospect';
            o.CloseDate = date.today()+5;
            database.Saveresult osr =database.insert(o);
            id oppid = osr.getId();
            Contact c = new Contact();
            c.FirstName = 'John';
            c.LastName = 'Doe';
            c.Email = 'John.Doe@pearson.com';
            database.Saveresult csr =database.insert(c);
            id contId = csr.getId();
            OpportunityContactRole oc = new  OpportunityContactRole ();
            oc.OpportunityId = oppid;
            oc.Role = 'Primary Sales Contact';
            oc.IsPrimary = True;
            oc.ContactId = contId;
            insert oc;
            //CameleonCPQ__Quote__c cq = new CameleonCPQ__Quote__c(Name='CreateQuote',CPQOpportunityId__c=o.Id);
            //insert cq;

            newQuoteProxyControllerExtension controller = new newQuoteProxyControllerExtension(new ApexPages.StandardController(o));
        }
}