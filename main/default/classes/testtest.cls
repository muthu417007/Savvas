@isTest
public class testtest {
    @isTest
    static void testClassMethod(){
        Account acc= scc_TestDataFactory.accountCreation('testAccount3');
        Contact con = scc_TestDataFactory.contactCreation( acc.Id, 'firstname3', 'testlastname3', 'testemail@abc.com');
        User testUser= scc_TestDataFactory.userCreation(con.Id);
        User testUser1 = [SELECT Id FROM User WHERE Email = 'testuser@example.com' LIMIT 1];
        
         System.runAs(testUser){
              Scc_RegistrationFormController.verifyRegistration('firstname','lastname','testemail@abc.com','12345','testAccount3');
		 }
      
    }
        @isTest
    static void testClassMethod2(){
         Account acc1= scc_TestDataFactory.accountCreation('testAccount4');
        Contact con1 = scc_TestDataFactory.contactCreation( acc1.Id, 'firstname4', 'testlastname4', 'testemail44@abc.com');
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'Savvas External Users Base Profile' LIMIT 1];
           User testUserr = new User();
    		testUserr.ProfileId=profileId.Id;          
            testUserr.LastName = 'Test User';
            testUserr.Email = 'testuser@example.com';
            testUserr.Username = 'testuser@example.com' + System.currentTimeMillis();
            testUserr.Alias = 'tuser';
            testUserr.TimeZoneSidKey = 'America/Los_Angeles';
            testUserr.LocaleSidKey = 'en_US';
            testUserr.EmailEncodingKey = 'UTF-8';
            testUserr.LanguageLocaleKey = 'en_US';
            testUserr.ContactId=con1.id;
        insert testUserr;
          System.runAs(testUserr){
              Scc_RegistrationFormController.verifyRegistration('firstname','lastname','testemail44@abc.com','12345','testAccount4');
		 }       
    }
}