@isTest
public class testOppUpdFrmEmailController {
    
    @testSetup static void setup() {
        // Create common test accounts and Opportunities
        List<account> acclist = new List<account>();
        Account[] accts = TestDataFactory.createAccountsWithOppsAndCont(7,1,0);
        List<Opportunity> oppList=new list<Opportunity>();
        
        for(Opportunity o:[Select Id,Name from Opportunity where accountId =:accts]){
            o.Name='BBB - '+o.Name;
            o.Discipline_and_Grade_Band__c = 'Intervention 6-8';
            oppList.add(o);
        }
        update oppList;
        
        // Query the product family pricebook
        Pricebook2 standardPricebook = new Pricebook2(Id = Test.getStandardPricebookId(),IsActive = true);  
        // Run an update DML on the Pricebook2 record
        // This is the weird workaround that enables IsStandard to become true
        // on the PricebookEntry record
        update standardPricebook;
        
        // Create new products
        list<Product2> prodList=new list<Product2>();
        Product2 iLitProd= new Product2(Name='Test iLit', ProductCode='TestiLit',isActive=true);
        prodList.add(iLitProd);
        for(Integer i=0;i<2;i++){
            Product2 prod= new Product2(Name='Test Product'+i, ProductCode='Product'+i,isActive=true);
            prodList.add(prod);
        }
        
        insert prodList;
        
        // Add Product to standard price book
        list<PricebookEntry> standardPBE=new list<PricebookEntry>();
        for(integer n=0;n<prodList.size();n++){
            PricebookEntry prodFamilyProd = new PricebookEntry(
                Pricebook2Id = standardPricebook.Id, Product2Id = prodList[n].Id,
                UnitPrice = 10000*(n+1), IsActive = true);
            standardPBE.add(prodFamilyProd);
            
        }
        insert standardPBE;
    }
    
    public static testMethod void testUpdOppWithoutProductSuccess() {
        // setup controller object
        OpportunityUpdateFrmEmailController objconfirm = new OpportunityUpdateFrmEmailController();
        // Get list of test account using a SOQL query
        list<Account> acctList = [SELECT Id FROM Account];
        //Get list of opportunities
        list <Opportunity> testOppList = [SELECT Id, StageName,Amount,Description,closeDate,Has_Quote__c FROM Opportunity WHERE accountId IN :acctList];
        //List of stages that BBB use
        list <string> BBBOppStages=new list<string>{'Qualified','Needs Assesment','Presentation','Proposal','Commitment','Closed Won','Closed Lost'};
        
        // Loop that create's an email message with different opportunity stages
        for(Integer i=0;i<BBBOppStages.size();i++){
            // Create a new email, envelope object
            Messaging.InboundEmail email = new Messaging.InboundEmail();
            Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();
            objconfirm.handleInboundEmail(email, envelope);
            testOppList[i].Discipline_and_Grade_Band__c = 'Intervention 6-8';
            
            email.subject = 'Notice of Update on Opportunity';
            
            
            email.plainTextBody = 'The Following Opportunity Record has been an Updated in Our Salesforce Database.~\n'+
                'Account: TEST - Stony Point Partner~\n'+
                'Opportunity: Testy Testers Center -~\n'+
                'Opportunity Main Contact: Stony Point, (770) 309-8026, mike.harris@stonyp.com~\n'+
                'Current Stage: '+BBBOppStages[i]+'~\n'+
                'Probability: 80%~\n'+
                'Current Close Date: 01/26/2018~\n'+
                'Amount: $55,000.99~\n'+
                'Renewal Letter Attached: 1~\n'+
                'Learning Services Opp ID: '+ testOppList[i].Id+'~\n'+
                'Opportunity Owner: Brian Rhodes~\n'+
                'Owner\'s Email: brian.rhodes@bbbedu.com~\n'+
                'BBB Opportunity ID: 0064100000S3ZK0~\n'+
                'Link to Opportunity in the Portal: '+URL.getSalesforceBaseURL().toExternalForm()+'/'+ testOppList[i].Id + '~\n';
              	envelope.fromAddress = 'romer.pasag@Pearson.com';
            
            Messaging.InboundEmailResult result = objconfirm.handleInboundEmail(email, envelope);
            System.assertEquals( result.success  ,true);
        }
    }
    
    public static testMethod void testUpdOppWithOneProdSuccess() {
        // setup controller object
        OpportunityUpdateFrmEmailController objconfirm = new OpportunityUpdateFrmEmailController();
        
        // Get a test account by using a SOQL query
        Account acct = [SELECT Id FROM Account WHERE Name='TestAccount1' LIMIT 1];
        Opportunity testOpp = [SELECT Id, StageName,Amount,Description,closeDate,Has_Quote__c
                               FROM Opportunity
                               WHERE accountId=:acct.Id limit 1];
        
        testOpp.Discipline_and_Grade_Band__c = 'Intervention 6-8';
        
        PricebookEntry pbe1 =[select id, name,pricebook2Id,product2Id from pricebookentry where name like '%Test iLit%' limit 1];
        if(pbe1!=null){
            OpportunityLineItem oli = new OpportunityLineItem(OpportunityId=testOpp.Id, PricebookEntryId=pbe1.Id,UnitPrice=10000,Quantity=1);
            insert oli;                                       
        }
        
        // Create a new email, envelope object and Attachment
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();
        objconfirm.handleInboundEmail(email, envelope);
        
        email.subject = 'Notice of Update on Opportunity';
        email.plainTextBody = 'The Following Opportunity Record has been an Updated in Our Salesforce Database.~\n'+
            'Account: TEST - Stony Point Partner~\n'+
            'Opportunity: Testy Testers Center -~\n'+
            'Opportunity Main Contact: Stony Point, (770) 309-8026, mike.harris@stonyp.com~\n'+
            'Current Stage: Needs Assesment~\n'+
            'Probability: 80%~\n'+
            'Current Close Date: 01/26/2018~\n'+
            'Amount: $55,000.99~\n'+
            'Renewal Letter Attached: 1~\n'+
            'Learning Services Opp ID: '+ testOpp.Id+'~\n'+
            'Opportunity Owner: Brian Rhodes~\n'+
            'Owner\'s Email: brian.rhodes@bbbedu.com~\n'+
            'BBB Opportunity ID: 0064100000S3ZK0~\n'+
            'Link to Opportunity in the Portal: '+URL.getSalesforceBaseURL().toExternalForm()+'/'+ testOpp.Id+'~\n';
        envelope.fromAddress = 'romer.pasag@Pearson.com';
        
        Messaging.InboundEmailResult result = objconfirm.handleInboundEmail(email, envelope);
        System.assertEquals( result.success  ,true);
        
    }
    
    public static testMethod void testUpdOppMultipleProdSuccess() {
        // setup controller object
        OpportunityUpdateFrmEmailController objconfirm = new OpportunityUpdateFrmEmailController();
        
        // Get a test account by using a SOQL query
        Account acct = [SELECT Id FROM Account WHERE Name='TestAccount1' LIMIT 1];
        Opportunity testOpp = [SELECT Id, StageName,Amount,Description,closeDate,Has_Quote__c
                               FROM Opportunity
                               WHERE accountId=:acct.Id limit 1];
        
        testOpp.Discipline_and_Grade_Band__c = 'Intervention 6-8';
        
        List<OpportunityLineItem> oliList=new List<OpportunityLineItem>();
        for(PricebookEntry pbe:[select id, name,pricebook2Id,product2Id from pricebookentry where name like '%Test%']){
            OpportunityLineItem oli = new OpportunityLineItem(OpportunityId=testOpp.Id, PricebookEntryId=pbe.Id,UnitPrice=10000,Quantity=1);
            oliList.add(oli);                                   
        }
        insert oliList;
    
        // Create a new email, envelope object and Attachment
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();
        objconfirm.handleInboundEmail(email, envelope);
        
        email.subject = 'Notice of Update on Opportunity';
        email.plainTextBody = 'The Following Opportunity Record has been an Updated in Our Salesforce Database.~\n'+
            'Account: TEST - Stony Point Partner~\n'+
            'Opportunity: Testy Testers Center -~\n'+
            'Opportunity Main Contact: Stony Point, (770) 309-8026, mike.harris@stonyp.com~\n'+
            'Current Stage: Needs Assesment~\n'+
            'Probability: 80%~\n'+
            'Current Close Date: 01/26/2018~\n'+
            'Amount: $55,000.99~\n'+
            'Renewal Letter Attached: 1~\n'+
            'Learning Services Opp ID: '+ testOpp.Id+'~\n'+
            'Opportunity Owner: Brian Rhodes~\n'+
            'Owner\'s Email: brian.rhodes@bbbedu.com~\n'+
            'BBB Opportunity ID: 0064100000S3ZK0~\n'+
            'Link to Opportunity in the Portal: '+URL.getSalesforceBaseURL().toExternalForm()+'/'+ testOpp.Id+'~\n';
        envelope.fromAddress = 'romer.pasag@Pearson.com';
        
        Messaging.InboundEmailResult result = objconfirm.handleInboundEmail(email, envelope);
        System.assertEquals( result.success  ,true);
        
    }
    
    public static testMethod void testUpdOppInvalidOppId() {
        // setup controller object
        OpportunityUpdateFrmEmailController objconfirm = new OpportunityUpdateFrmEmailController();
        
        // Get the first test account by using a SOQL query
        Account acct = [SELECT Id FROM Account WHERE Name='TestAccount2' LIMIT 1];
        Opportunity testOpp = [SELECT Id, StageName,Amount,Description,closeDate,Has_Quote__c
                               FROM Opportunity
                               WHERE accountId=:acct.Id limit 1];
        
        // Create a new email, envelope object and Attachment
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();
        objconfirm.handleInboundEmail(email, envelope);
        
        email.subject = 'Notice of Update on Opportunity';
        email.plainTextBody = 'The Following Opportunity Record has been an Updated in Our Salesforce Database.~\n'+
            'Account: TEST - Stony Point Partner~\n'+
            'Opportunity: Testy Testers Center -~\n'+
            'Opportunity Main Contact: Stony Point, (770) 309-8026, mike.harris@stonyp.com~\n'+
            'Current Stage: Final Negotiation~\n'+
            'Probability: 80%~\n'+
            'Current Close Date: 01/26/2018~\n'+
            'Amount: $55,000.99~\n'+
            'Renewal Letter Attached: 1~\n'+
            'Learning Services Opp ID: 006123456789012~\n'+
            'Opportunity Owner: Brian Rhodes~\n'+
            'Owner\'s Email: brian.rhodes@bbbedu.com~\n'+
            'BBB Opportunity ID: 0064100000S3ZK0~\n'+
            'Link to Opportunity in the Portal: '+URL.getSalesforceBaseURL().toExternalForm()+'/0064100000S3ZK0~\n';
        envelope.fromAddress = 'romer.pasag@Pearson.com';
        
        Messaging.InboundEmailResult result = objconfirm.handleInboundEmail(email, envelope);
        System.assertEquals( result.success  ,true);
        
    }
}