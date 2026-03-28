/*********************************************************** 
* @Class Name  - scc_welcomeEmailTrigger_Test
* @description - Test class for scc_welcomeEmailTrigger
* @Created By  - CTS-Muthukumar
* @Created On - 2024-10-26
* **********************************************************/ 
@isTest
public class scc_welcomeEmailTrigger_Test {
    @isTest
    static void testUserCreate() {
        // Get the Profile Id
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Savvas External Users Base Profile' LIMIT 1];  
        Account acc= scc_TestDataFactory.accountCreation('testAccount121');
        Contact con = scc_TestDataFactory.contactCreation( acc.Id, 'firstname11', 'testlastname11', 'testemail+01@abc.com');
        scc_EnableUserAdmins__c adminuser= new scc_EnableUserAdmins__c(
        	SetupOwnerId=UserInfo.getUserId(),
            Trigger_welcome_email__c= true
        );
        insert adminuser;
        User testUser = new User(
            FirstName = 'Test',
            LastName = 'User',
            Email = 'testuser@test.com',
            Username = 'testuser' + DateTime.now().getTime() + '@test.com',
            Alias = 'tuser',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            ProfileId = p.Id,
            ContactId=con.Id,
            checkStatusPriceAvailability__c = true
        );
        
       Test.startTest();        
        insert testUser;   
        Test.stopTest();
      
    }


}