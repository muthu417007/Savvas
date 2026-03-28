@IsTest

Public class TestOpportunityLeaderUpdate {
    static testmethod void insertOpportunityDiffCreator() {
        Account[] accts = TestDataFactory.createAccountsWithOppsAndCont(1,0,0);
        list<Opportunity> oppListToUpdate=new list<Opportunity>();
        Integer rand=math.round(Math.random()*1000);
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        
        User u1 = new User(Alias = 'User1', Email='firstuser@pearson.com.icom', 
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='firstuser'+rand+'@pearson.com');
        insert u1;
        User u2 = new User(Alias = 'newUser', Email='newuser@pearson.com.icom', 
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='newuser'+rand+'@pearson.com');
        insert u2;
        
        opportunity firstOpp=new Opportunity(Name=accts[0].Name + ' Opportunity ' + rand,
                                       StageName='Prospect',
                                       type='New',
                                       Amount=1000,
                                       Total_Contract_Value__c=1001,
                                       Probability=10,
                                       LeadSource='Employee Referral',
                                       CloseDate=System.today().addMonths(1),
                                       AccountId=accts[0].Id,
                                       Opportunity_Leader__c=u1.id,
                                       ownerid=u1.id,
                                       createdbyid=u2.id
                                       );
        insert firstOpp;
        
    }
    
    static testmethod void insertOpportunityDiffLeader() {
        Account[] accts = TestDataFactory.createAccountsWithOppsAndCont(5,5,0);
        list<Opportunity> oppListToUpdate=new list<Opportunity>();
        Integer rand=math.round(Math.random()*1000);
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        
        User u1 = new User(Alias = 'User1', Email='firstuser@pearson.com.icom', 
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='firstuser'+rand+'@pearson.com');
        insert u1;
        User u2 = new User(Alias = 'newUser', Email='newuser@pearson.com.icom', 
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='newuser'+rand+'@pearson.com');
        insert u2;
        
        
        For(Opportunity opp:[Select ID, Name, ownerId,Opportunity_Leader__c,createdbyId from Opportunity where accountId IN:accts]){
            opp.ownerid=u2.id;
            opp.Discipline_and_Grade_Band__c = 'Intervention 6-8';
            oppListToUpdate.add(opp);
            system.debug(opp);
        }
        update oppListToUpdate;
        
    }
    
    /* Commented out because no longer need to sync Opp with OneCRM
    static testmethod void sharedOpptyOneCRM() {
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        Integer rand=math.round(Math.random()*1000);
        
        User u1 = [select Id from User where Email like 'leslie.wollman-weekley%'];
        User u1 = new User(Alias = 'User1', Email='firstuser@pearson.com.icom', 
        //EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
        //LocaleSidKey='en_US', ProfileId = p.Id, 
        //TimeZoneSidKey='America/Los_Angeles', UserName='firstuser'+rand+'@pearson.com');
        //insert u1;
        
        //Group sf2sfGroup = [select Id from Group where name = 'SF2SF Users'];
       // GroupMember u1member = new GroupMember (GroupId = sf2sfGroup.Id, UserOrGroupId = u1.Id);  
        //insert u1member;
        //
        
        Account[] accts = TestDataFactory.createAccountsWithOppsAndCont(1,1,0);
        list<Opportunity> oppListToUpdate=new list<Opportunity>();
        
        opportunity secondOpp=new Opportunity(Name=accts[0].Name + ' Opportunity ' + rand,
                                       StageName='Prospect',
                                       type='New',
                                       Amount=1000,
                                       Total_Contract_Value__c=1001,
                                       Probability=10,
                                       LeadSource='Employee Referral',
                                       CloseDate=System.today().addMonths(1),
                                       AccountId=accts[0].Id,
                                       Opportunity_Leader__c=u1.id,
                                       ownerid=u1.id,
                                       createdbyid=u1.id
                                       );
        System.RunAs(u1)
        {
             Test.startTest();
            insert secondOpp;
             Test.stopTest();
        }
        
        
    }
    */
    
    
 }