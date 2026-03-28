@isTest
public class TestAccountPlanController {
    
    public static testMethod void testAccPlancontrollerNoAccId() {
        PageReference pageRef = Page.AccountPlanPage;
        Test.setCurrentPage(pageRef);        
        Test.startTest();
        AccountPlanController controller = new AccountPlanController();
        Test.stopTest();
    }
    
    public static testMethod void testAccPlancontrollerSuccessDefaults() {
        
        List<account> acclist = new List<account>();
        Account[] accts = TestDataFactory.createAccountsWithOppsAndCont(3,0,0);
        list<Account_Planning__c> accPlanList;
        
        PageReference pageRef = Page.AccountPlanPage;
        Test.setCurrentPage(pageRef);
        
        ApexPages.currentPage().getParameters().put('id', accts[0].Id);//Pass Id to page
        
        Test.startTest();
        AccountPlanController controller = new AccountPlanController();
        controller.accId=accts[0].Id;
        Schema.DescribeFieldResult fieldResult = Account_Planning__c.Discipline_and_Grade_Band__c.getDescribe();
        List<Schema.PicklistEntry> ple=fieldResult.getPicklistValues();
        List<Account_Planning__c> apList=new list<Account_planning__c>();
        List<String> gradeLevel=new List<String>();
        List<SelectOption> rating=controller.getStatus();
        List<SelectOption> yearValue=controller.getMostRecentPurchaseYear();
        for( Schema.PicklistEntry pickListVal : ple){
            gradeLevel.add(pickListVal.getLabel());
        }
        
        for(String gl:gradeLevel){
            accountPlanController.apWrapper apWrap=new accountPlanController.apWrapper(gl);
            controller.apWrapMap.put(gl,apWrap);
        }
        for(accountPlanController.apWrapper a:controller.apWrapMap.values()){
            controller.AccountPlans.add(a);
            
        }
        
        boolean planComplete = controller.currentYearPlanComplete;
        planComplete = true;
        controller.currentYearPlanComplete = planComplete;
        string acctNotes = controller.accPlanStatusAndNotes.Account_Plan_Notes__c;
        acctNotes = 'testing';
        controller.accPlanStatusAndNotes.Account_Plan_Notes__c = acctNotes;
        
        
        controller.save();
        list<Account_Planning__c> accPlanInserted=new list<Account_Planning__c>([Select ID, Name,Year__c,Discipline_and_Grade_Band__c,Company_Account__c,Rating__c,LobAndYear__c,Most_Recent_Purchase__c,Revenue_Potential__c,Product_Name__c from Account_Planning__c where Account__c=:accts[0].Id]);
        system.assertEquals(gradeLevel.size() * 3,accPlanInserted.size()); //12 May 2022 - Replaced Expected value from 42 to GradeLevel.size()*3, which is the total number of picklist values on Discipline and grade field multipled by number of Accounts (Accountnum parameter)
        Test.stopTest();
    }
    
    public static testMethod void testAccPlancontrollerSuccessUpdate() {
        
        List<account> acclist = new List<account>();
        Account[] accts = TestDataFactory.createAccountsWithOppsAndCont(3,0,0);
        list<Account_Planning__c> accPlanList;
        accts[1].enrollment__c=1000;
        update accts[1];  
        accts[2].type='Competitor';
        update accts[2];  
        
        PageReference pageRef = Page.AccountPlanPage;
        Test.setCurrentPage(pageRef);
        
        ApexPages.currentPage().getParameters().put('id', accts[1].Id);//Pass Id to page
        
        Test.startTest();
        AccountPlanController controller = new AccountPlanController();
        controller.accId=accts[1].Id;
        Schema.DescribeFieldResult fieldResult = Account_Planning__c.Discipline_and_Grade_Band__c.getDescribe();
        List<Schema.PicklistEntry> ple=fieldResult.getPicklistValues();
        List<Account_Planning__c> apList=new list<Account_planning__c>();
        List<String> gradeLevel=new List<String>();
        for( Schema.PicklistEntry pickListVal : ple){
            gradeLevel.add(pickListVal.getLabel());
        }
        
        for(String gl:gradeLevel){
            accountPlanController.apWrapper apWrap=new accountPlanController.apWrapper(gl);
            controller.apWrapMap.put(gl,apWrap);
        }
        for(accountPlanController.apWrapper a:controller.apWrapMap.values()){
            controller.AccountPlans.add(a);
            
        }
        controller.save();
        list<Account_Planning__c> accPlanToUpdate=new list<Account_Planning__c>([Select ID, Name,Year__c,Discipline_and_Grade_Band__c,Company_Account__c,Rating__c,LobAndYear__c,Most_Recent_Purchase__c,Revenue_Potential__c,Product_Name__c from Account_Planning__c where Account__c=:accts[1].Id]);
        system.assertEquals(gradeLevel.size() * 3,accPlanToUpdate.size()); //12 May 2022 - Replaced Expected value from 42 to GradeLevel.size()*3, which is the total number of picklist values on Discipline and grade field multipled by number of Accounts (Accountnum parameter)
        
        Product2 prod=new Product2(Name='Test Product',ProductType__c='Competitor');
        insert prod;
        controller.lobValues();
        
        For(accountPlanController.apWrapper ap:controller.AccountPlans){
            ap.year1Rating='Possible Adoption';
            ap.year2Rating='Possible Adoption';
            ap.year3Rating='Possible Adoption';
            ap.accPurchasingPattern.Company_Account__c=accts[2].Id;
            ap.accPurchasingPattern.Most_Recent_Purchase__c='2017';
            ap.accPurchasingPattern.Product_Name__c=prod.Id;
            
        }
        controller.save();
        controller.getAccPlans();
        For(accountPlanController.apWrapper ap:controller.AccountPlans){
            ap.year1Rating='Unknown';
            ap.year2Rating='No Adoption';
            ap.year3Rating='No Adoption';
            
        }
        controller.save();
        controller.createOpp();
        Test.stopTest();
    }
    public static testMethod void testAccPlancontrollerSuccessLoadValues() {
        
        List<account> acclist = new List<account>();
        Account[] accts = TestDataFactory.createAccountsWithOppsAndCont(3,0,0);
        list<Account_Planning__c> accPlanList;
        Integer rand = Math.round(Math.random()*1000);
        list <user> newUserList=new list<user>();
        for(Integer u=0;u<2;u++){
            User newUser = new User(
                ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
                LastName = 'last',
                Email = 'puser'+rand+'@pearson.com.test'+u,
                Username = 'puser'+rand+'@pearson.com.test'+u + System.currentTimeMillis(),
                CompanyName = 'TEST',
                Title = 'title',
                Alias = 'alias',
                TimeZoneSidKey = 'America/Los_Angeles',
                EmailEncodingKey = 'UTF-8',
                LanguageLocaleKey = 'en_US',
                LocaleSidKey = 'en_US'     
            );
            if(u==1){
                newUser.ManagerId=newUserList[0].Id;
            }
            newUserList.add(newUser);
        }
        insert newUserList;
        accts[2].ownerId=newUserList[1].Id;
        update accts[2];
        PageReference pageRef = Page.AccountPlanPage;
        System.runas(newUserList[1]){
            Test.setCurrentPage(pageRef);
            accountteammember atm=new accountteammember(accountId=accts[2].Id,userId=UserInfo.getUserId());
            insert atm;
            Product2 prod=new Product2(Name='Test Product',ProductType__c='Competitor');
            insert prod;
            integer cy=0;
            if(System.Today().month()<6){
                cy=System.Today().year();
            }else{
                cy=System.Today().year()+1;
            }
            Account_Planning__c ap=new account_planning__c(
                Account__c=accts[2].Id,
                Discipline_and_Grade_Band__c='Humanities 6-8',
                year__c=string.valueof(cy),         
                Rating__c='Possible Adoption',
                Most_Recent_Purchase__c='2016',
                Revenue_Potential__c=10000000
            );
            insert ap;       
            ApexPages.currentPage().getParameters().put('id', accts[2].Id);//Pass Id to page
            
            Test.startTest();
            AccountPlanController controller = new AccountPlanController();
            controller.accId=accts[2].Id;
            controller.getAccPlans();
            Test.stopTest();
        }
    }
    
    public static testMethod void testAccPlancontrollerUpdateDefaults() {
        
        List<account> acclist = new List<account>();
        Account[] accts = TestDataFactory.createAccountsWithOppsAndCont(3,0,0);
        list<Account_Planning__c> accPlanList;
        accts[0].enrollment__c=1000;
        update accts[0];
        
        PageReference pageRef = Page.AccountPlanPage;
        Test.setCurrentPage(pageRef);
        
        ApexPages.currentPage().getParameters().put('id', accts[0].Id);//Pass Id to page
        
        Test.startTest();
        AccountPlanController controller = new AccountPlanController();
        controller.accId=accts[0].Id;
        Schema.DescribeFieldResult fieldResult = Account_Planning__c.Discipline_and_Grade_Band__c.getDescribe();
        List<Schema.PicklistEntry> ple=fieldResult.getPicklistValues();
        List<Account_Planning__c> apList=new list<Account_planning__c>();
        List<String> gradeLevel=new List<String>();
        List<SelectOption> rating=controller.getStatus();
        List<SelectOption> yearValue=controller.getMostRecentPurchaseYear();
        for( Schema.PicklistEntry pickListVal : ple){
            gradeLevel.add(pickListVal.getLabel());
        }
        
        for(String gl:gradeLevel){
            accountPlanController.apWrapper apWrap=new accountPlanController.apWrapper(gl);
            controller.apWrapMap.put(gl,apWrap);
        }
        for(accountPlanController.apWrapper a:controller.apWrapMap.values()){
            a.year1Rating='Possible Adoption';
            a.year2Rating='Possible Adoption';
            a.year3Rating='Possible Adoption';
            controller.AccountPlans.add(a);
            
        }
        controller.save();
        list<Account_Planning__c> accPlanInserted=new list<Account_Planning__c>([Select ID, Name,Year__c,Discipline_and_Grade_Band__c,Company_Account__c,Rating__c,LobAndYear__c,Most_Recent_Purchase__c,Revenue_Potential__c,Product_Name__c from Account_Planning__c where Account__c=:accts[0].Id]);
        system.assertEquals(gradeLevel.size() * 3,accPlanInserted.size()); //12 May 2022 - Replaced Expected value from 42 to GradeLevel.size()*3, which is the total number of picklist values on Discipline and grade field multipled by number of Accounts (Accountnum parameter)
        Test.stopTest();
    }
}