@isTest(SeeAllData=true)
public class testcloneQuoteControllerExtension {
    static testMethod void myUnitTest(){
            Account a = new Account(Name='createOpportunityAccount',BillingCity = 'New York');
            database.Saveresult asr =database.insert(a);
            id acctid = asr.getId();
            Opportunity o = new Opportunity (Name='FirstOpportunity');
            ID oid = [select ID from User where userrole.name like '%AGM%' and Profile.Name = 'ICOM Sales Rep' and Isactive=true limit 1 ].id;
            o.ownerid = oid;
            o.Opportunity_Leader__c = oid;
            o.Type = 'New';
            o.Amount = 1;
            o.StageName = 'Prospect';
            o.CloseDate = date.today()+5;
            o.AccountId = acctid;
            database.Saveresult osr =database.insert(o);
            id oppid = osr.getId();
            Opportunity so = new Opportunity (Name='SecondOpportunity');
            so.ownerid = oid;
            so.Opportunity_Leader__c = oid;
            so.Type = 'New';
            so.Amount = 1;
            so.StageName = 'Prospect';
            so.CloseDate = date.today()+5;
            so.AccountId = acctid;
            database.Saveresult osr2 =database.insert(so);
            id newoppid = osr2.getId();
            Contact c = new Contact();
            c.FirstName = 'John';
            c.LastName = 'Doe';
            c.Email = 'John.Doe@pearson.com';
            database.Saveresult csr =database.insert(c);
            id contId = csr.getId();
            OpportunityContactRole oc = new  OpportunityContactRole ();
            oc.OpportunityId = newoppid;
            oc.Role = 'Primary Sales Contact';
            oc.IsPrimary = True;
            oc.ContactId = contId;
            insert oc;
            CameleonCPQ__Quote__c quo = new CameleonCPQ__Quote__c(Name='CreateQuote',CPQOpportunityId__c=o.Id);
            insert quo;
            apexpages.currentpage().getparameters().put('newoppid' ,newoppid );
            cloneQuoteControllerExtension controller = new cloneQuoteControllerExtension(new ApexPages.StandardController(quo));
            PageReference pageRef = controller.getNewQuotePage();      
            string getError = controller.getErrorURL();
        
            // Test Coverage for cloneQuoteChooseOppControllerExtension
            cloneQuoteChooseOppControllerExtension controllerChooseOpp = new cloneQuoteChooseOppControllerExtension(new ApexPages.StandardController(quo));
            PageReference pageRefChooseOpp = controllerChooseOpp.getCloneQuotePage();
    }
        // No Opportunity Contact Roles
        static testMethod void myUnitTest2(){
            Account a = new Account(Name='createOpportunityAccount',BillingCity = 'New York');
            database.Saveresult asr =database.insert(a);
            id acctid = asr.getId();
            Opportunity o = new Opportunity (Name='FirstOpportunity');
            ID oid = [select ID from User where userrole.name like '%AGM%' and Profile.Name = 'ICOM Sales Rep' and Isactive=true limit 1 ].id;
            o.ownerid = oid;
            o.Type = 'New';
            o.Amount = 1;
            o.StageName = 'Prospect';
            o.CloseDate = date.today()+5;
            o.AccountId = acctid;
            database.Saveresult osr =database.insert(o);
            id oppid = osr.getId();
            Opportunity so = new Opportunity (Name='SecondOpportunity');
            so.ownerid = oid;
            so.Type = 'New';
            so.Amount = 1;
            so.StageName = 'Prospect';
            so.CloseDate = date.today()+5;
            so.AccountId = acctid;
            database.Saveresult osr2 =database.insert(so);
            id newoppid = osr2.getId();
            Contact c = new Contact();
            c.FirstName = 'John';
            c.LastName = 'Doe';
            c.Email = 'John.Doe@pearson.com';
            database.Saveresult csr =database.insert(c);
            id contId = csr.getId();
            CameleonCPQ__Quote__c quo = new CameleonCPQ__Quote__c(Name='CreateQuote',CPQOpportunityId__c=o.Id);
            insert quo;
            apexpages.currentpage().getparameters().put('newoppid' ,newoppid );
            cloneQuoteControllerExtension controller = new cloneQuoteControllerExtension(new ApexPages.StandardController(quo));
            PageReference pageRef = controller.getNewQuotePage(); 
            string getError = controller.getErrorURL();
    }
        //Opportunity Already has a Quote
        static testMethod void myUnitTest3(){
            Account a = new Account(Name='createOpportunityAccount',BillingCity = 'New York');
            database.Saveresult asr =database.insert(a);
            id acctid = asr.getId();
            Opportunity o = new Opportunity (Name='FirstOpportunity');
            ID oid = [select ID from User where userrole.name like '%AGM%' and Profile.Name = 'ICOM Sales Rep' and Isactive=true limit 1 ].id;
            o.ownerid = oid;
            o.Type = 'New';
            o.Amount = 1;
            o.StageName = 'Prospect';
            o.CloseDate = date.today()+5;
            o.AccountId = acctid;
            database.Saveresult osr =database.insert(o);
            id oppid = osr.getId();
            Opportunity so = new Opportunity (Name='SecondOpportunity');
            so.ownerid = oid;
            so.Type = 'New';
            so.Amount = 1;
            so.StageName = 'Prospect';
            so.CloseDate = date.today()+5;
            so.AccountId = acctid;
            database.Saveresult osr2 =database.insert(so);
            id newoppid = osr2.getId();
            Contact c = new Contact();
            c.FirstName = 'John';
            c.LastName = 'Doe';
            c.Email = 'John.Doe@pearson.com';
            database.Saveresult csr =database.insert(c);
            id contId = csr.getId();
            OpportunityContactRole oc = new  OpportunityContactRole ();
            oc.OpportunityId = newoppid;
            oc.Role = 'Primary Sales Contact';
            oc.IsPrimary = True;
            oc.ContactId = contId;
            insert oc;
            CameleonCPQ__Quote__c quo = new CameleonCPQ__Quote__c(Name='CreateQuote',CPQOpportunityId__c=o.Id);
            insert quo;
            CameleonCPQ__Quote__c Secondquo = new CameleonCPQ__Quote__c(Name='SecondQuote',CPQOpportunityId__c=so.Id);
            insert Secondquo;
            apexpages.currentpage().getparameters().put('newoppid' ,newoppid );
            cloneQuoteControllerExtension controller = new cloneQuoteControllerExtension(new ApexPages.StandardController(quo));
            PageReference pageRef = controller.getNewQuotePage();      
            string getError = controller.getErrorURL();
    }
}