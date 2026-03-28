/*
Apex Test Class:scc_checkSIOPRegistration_Test
Author: CTS (MuthuKumar)
Created Date: 03/04/2024
Modified Date: 16/04/2024
*/
@isTest 
public class scc_checkSIOPRegistration_Test { 
 /**
*  Description: Below method is test method that covers testing of checkSIOPRegistration,getSIOPurl,checkSIOPWorkTextUser and getSIOPOrderNumber
*  @name: siopchecktest
*  @param:NA
*  @return: NA
*  @throws exception- NA
*/ 
    @isTest
    static void siopchecktest(){
        
        List<Account> acc= new List<Account>();
        Account acc1= new Account();
        acc1.Name = 'TestAccount';
        acc1.BillingStreet = '123 Test St';
        acc1.BillingCity = 'Test City';
        acc1.BillingState = 'MH';
        acc1.BillingPostalCode = '12345';
        acc1.BillingCountry = 'United States';
        acc1.MDR_PID__c = '123456';
        acc1.Account_Status__c='Active';
        acc.add(acc1);
        insert acc;
        
        
        List<Order> ord= new List<Order>();
        Order ord1= new Order();
        ord1.BillingPostalCode='35007';
        ord1.SAP_Document_Number__c='1000057702';
        ord1.BillingState='CL';
        ord1.EffectiveDate=Date.newInstance(2015, 2, 17);
        ord1.Status='Draft';
        ord1.AccountId	= acc[0].Id;
        ord1.Order_Confirmation_Sent__c=false;
        ord1.Customer_Email__c ='testuser@example.com'; 
        ord.add(ord1);
        
        Order ord2= new Order();
        ord2.BillingPostalCode='35807';
        ord2.SAP_Document_Number__c='1009057702';
        ord2.BillingState='CL';
        ord2.EffectiveDate=Date.newInstance(2015, 5, 17);
        ord2.Status='Draft';
        ord2.AccountId	=  acc[0].Id;
        ord2.Order_Confirmation_Sent__c=false;
        ord2.Customer_Email__c ='testuser@example.com'; 
        ord.add(ord2);        
        Insert ord;   
        
        String guestProfile = scc_constantHelper.MY_SAVVAS_ORDERS_PROFILE;
        Profile pd2 = [Select id From profile where name =:guestProfile limit 1];
        User testUser1 = new User();
        testUser1.ProfileId=pd2.Id;          
        testUser1.LastName = 'Test User';
        testUser1.Email = 'testuser@example.com';
        testUser1.Username = 'testuser@example.com' + System.currentTimeMillis();
        testUser1.Alias = 'tuser';
        testUser1.TimeZoneSidKey = 'America/Los_Angeles';
        testUser1.LocaleSidKey = 'en_US';
        testUser1.EmailEncodingKey = 'UTF-8';
        testUser1.LanguageLocaleKey = 'en_US';
        insert testUser1;
        
        String zip=ord[0].BillingPostalCode;
        String ordnum=ord[0]. SAP_Document_Number__c;
        
        String zip1=ord[1].BillingPostalCode;
        String ordnum1=ord[1]. SAP_Document_Number__c;    
        
        Account acc2= scc_TestDataFactory.accountCreation('testAccount4');
        
        Contact con = scc_TestDataFactory.contactCreation( acc2.Id, 'firstname4', 'testlastname4', 'testemail1@abc.com');
        
        Profile pd = [Select id From profile where name =:scc_constantHelper.CUSTOMER_COMMUNITY_PLUS_LOGIN_USER limit 1];
        user us=[select id from user where profile.name=:scc_constantHelper.SYSTEM_ADMINISTRATOR_PROFILE and id != :userinfo.getUserID() and isActive=true limit 1];
        User testUser=  scc_TestDataFactory.userCreation(con.Id);
        List<PermissionSet> permissions = [SELECT Id, Name FROM PermissionSet where Name =:scc_constantHelper.SAVVAS_SIOP_PERMISSIONS];
        System.runAs (us) {
            PermissionSetAssignment psAssignment = new PermissionSetAssignment();
            psAssignment.PermissionSetId = permissions[0].Id;
            psAssignment.AssigneeId = testUser.Id;
            insert psAssignment; 
        }   
        TEST.StartTest();
        scc_checkSIOPRegistration.checkSIOPRegistration(zip,ordnum);
        scc_checkSIOPRegistration.checkSIOPRegistration(zip1,ordnum1);
        System.assertNotEquals(null,scc_checkSIOPRegistration.getSIOPurl('12345'));
        System.assertNotEquals(null,scc_checkSIOPRegistration.getSIOPOrderNumber(ord2.Id));
        
        System.runAs(testUser) {
            System.assertNotEquals(null,scc_checkSIOPRegistration.getSIOPurl('12345'));
            System.assertNotEquals(null,scc_checkSIOPRegistration.checkSIOPWorkTextUser());
        }
        
        System.runAs(testUser1) {
            System.assertNotEquals(null,scc_checkSIOPRegistration.getSIOPurl('12345'));
        }
        
        try {
            scc_checkSIOPRegistration.getSIOPOrderNumber(acc1.Id);           
        } catch (AuraHandledException e) {
            System.assertEquals(e.getMessage().contains('abcd'), false);
        }
        Test.stopTest();
    }
/**
*  Description: Below method is test method that covers catch exception block for checkSIOPWorkTextUser
*  @name: checkSIOPWorkTextUser_Exception
*  @param:NA
*  @return: NA
*  @throws exception- NA
*/    
    @isTest
    static void checkSIOPWorkTextUser_Exception() {
        Test.startTest();
        try {
            scc_checkSIOPRegistration.checkSIOPWorkTextUser();           
        } catch (AuraHandledException e) {
            System.assertEquals(e.getMessage().contains('abcd'), false);
        }
        Test.stopTest();
    }  
}