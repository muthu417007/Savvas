/*
    @Author : Cognizant Team
    @Name : Savvas_SSO_FederationIdUtilityTest
    @CreateDate : 04-June-2024
    @Description: This class is a test class for Savvas_SSO_FederationIdUtility
    @ModifiedBy: Cognizant Team
    @ModifiedDate: 02-July-2024
    @Ticket Number: W-014598
*/
@isTest
public class Savvas_SSO_FederationIdUtilityTest {
    @testSetup
    static void setupTestData() {
        System.runAs(new User(Id = UserInfo.getUserId())){
     		// Query existing profiles
            Profile testProfile = [SELECT Id FROM Profile WHERE Name = 'Savvas External Users Base Profile' LIMIT 1];
    
            // Query existing Account
            Savvas_SSO_TestDataFactory factory = new Savvas_SSO_TestDataFactory();
            Account account = factory.createAccount();
            factory.createSavvasCustomSetting();
    
            // Create contacts
            Contact contact1 = new Contact(FirstName= 'Test', LastName = 'Test1', email='test101@example.com', AccountId=account.Id);
            Contact contact2 = new Contact(FirstName= 'Test', LastName = 'Test2', email='test102@example.com', AccountId=account.Id);
            Contact contact3 = new Contact(FirstName= 'Test', LastName = 'Test3', email='test103@example.com', AccountId=account.Id);
            insert new List<Contact> { contact1, contact2, contact3 };
    
            // Setup test users
            User user1 = new User(
                ProfileId = testProfile.Id,
                Alias = 'test1',
                Email = 'test101@example.com',
                EmailEncodingKey = 'UTF-8',
                LastName = 'Test1',
                LanguageLocaleKey = 'en_US',
                LocaleSidKey = 'en_US',
                TimeZoneSidKey = 'America/Los_Angeles',
                UserName = 'test101@example.com',
                ContactId = contact1.Id
            );
            User user2 = new User(
                ProfileId = testProfile.Id,
                Alias = 'test2',
                Email = 'test102@example.com',
                EmailEncodingKey = 'UTF-8',
                LastName = 'Test2',
                LanguageLocaleKey = 'en_US',
                LocaleSidKey = 'en_US',
                TimeZoneSidKey = 'America/Los_Angeles',
                UserName = 'test102@example.com',
                ContactId = contact2.Id
            );
            insert new List<User> { user1, user2 };   
    	}
    }

    @isTest
    static void testSetFederationId() {
        	Profile testProfile = [SELECT Id FROM Profile WHERE Name = 'Savvas External Users Base Profile' LIMIT 1];
            // Retrieve the test users
            List<User> newUsers = [SELECT Id, Email, ProfileId, FederationIdentifier, IsActive, IsPortalEnabled FROM User WHERE Email IN ('test101@example.com', 'test102@example.com', 'test103@example.com')];
    
            // Call the method under test
             Savvas_SSO_FederationIdUtility.setFederationId(newUsers);
    
            // Verify the results
            for (User user : newUsers) {
                if (user.ProfileId == testProfile.Id) {
                    System.assertEquals(user.Email, user.FederationIdentifier, 'FederationIdentifier should be set to the user email');
                } else {
                    System.assertEquals(null, user.FederationIdentifier, 'FederationIdentifier should not be set for users with a different profile Id');
                }
            }
        }

    @isTest
    static void testUpdateFederationId() {
    		Profile testProfile = [SELECT Id FROM Profile WHERE Name = 'Savvas External Users Base Profile' LIMIT 1];
            // Retrieve the test users and set them as inactive
            List<User> updatedUsers = [SELECT Id, Email, ProfileId, FederationIdentifier, IsActive, IsPortalEnabled FROM User WHERE Email IN ('test101@example.com', 'test102@example.com')];
            for (User user : updatedUsers) {
                user.IsActive = false;
                user.IsPortalEnabled = false;
            }
            update updatedUsers;
    
            // Call the method under test
             Savvas_SSO_FederationIdUtility.updateFederationId(updatedUsers);
    
            // Verify the results
            List<User> results = [SELECT FederationIdentifier, ProfileId FROM User WHERE Email IN ('test101@example.com', 'test102@example.com')];
            for (User user : results) {
                if (user.ProfileId == testProfile.Id) {
                    System.assertEquals(null, user.FederationIdentifier, 'FederationIdentifier should be null for inactive users');
                } 
            }
        }
}