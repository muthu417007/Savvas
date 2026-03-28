/*
Apex Class:scc_sendUserExistEmail_Test
Author: CTS (MuthuKumar)
Created Date: 19/06/2024
Reason: test class for scc_sendUserExistEmail
Modified Date: 
*/
@isTest
public class scc_sendUserExistEmail_Test {
    /**
*  Description: This method for send email to user      
*  @name: sendUserExistEmailtest
*  @param:NA
*  @return: NA
*  @throws exception- 
*/
    @isTest
    static void sendUserExistEmailtest(){
        Account acc= scc_TestDataFactory.accountCreation('testAccount4');
        
        Contact con = scc_TestDataFactory.contactCreation( acc.Id, 'firstname4', 'testlastname4', 'testemail1@abc.com');
        String customerCommunityProfile = scc_constantHelper.CUSTOMER_COMMUNITY_PLUS_LOGIN_USER;
        Profile pd = [Select id From profile where name =:customerCommunityProfile limit 1];
        String guestProfile = scc_constantHelper.CUSTOMER_COMMUNITY_PLUS_LOGIN_USER;
        Profile pd2 = [Select id From profile where name =:guestProfile limit 1];
        String sysAdminProfile = scc_constantHelper.SYSTEM_ADMINISTRATOR_PROFILE;
        user us=[select id from user where profile.name=:sysAdminProfile and id != :userinfo.getUserID() and isActive=true limit 1];
        
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
        testUser1.ContactId = con.Id;
        insert testUser1;
        
        System.runAs(testUser1) {
            TEST.StartTest();         
            System.assertEquals(0, Limits.getEmailInvocations(), 'No emails should be sent');
            scc_sendUserExistEmail.SendEmailUserExistEmail('testemail1@abc.com');  
            System.assertEquals(1, Limits.getEmailInvocations(), 'Emails should be sent');
            Test.stopTest();
        }        
    }
}