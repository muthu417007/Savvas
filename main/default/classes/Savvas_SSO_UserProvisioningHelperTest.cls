/*
    @Author : Cognizant Team
    @Name : Savvas_SSO_UserProvisioningHelperTest
    @CreateDate : 13-June-2024
    @Description: This class is a test class for Savvas_SSO_UserProvisioningHelper
    @ModifiedBy: Cognizant Team
    @ModifiedDate: 02-July-2024
    @Ticket Number: W-014598
*/
@isTest
    public class Savvas_SSO_UserProvisioningHelperTest {
    
    @isTest
    public static void getUserListTest() {
        Savvas_SSO_TestDataFactory factory = new Savvas_SSO_TestDataFactory();
        User testUser = factory.createUser();
        System.runAs(testUser){
        	Account testAccount = factory.createAccount();
            Test.startTest();
            List<User> result = Savvas_SSO_UserProvisioningHelper.getUserList('testUser@test.com');
            System.assertNotEquals(null, result);
            Test.stopTest();
        }
    }
    
    @isTest
    public static void getContactListTest() {
        Savvas_SSO_TestDataFactory factory = new Savvas_SSO_TestDataFactory();
        User testUser = factory.createUser();
        System.runAs(testUser){
        	Account testAccount = factory.createAccount();
            Test.startTest();
            List<Contact> result = Savvas_SSO_UserProvisioningHelper.getContactList('testUser@test.com', testAccount.Id, null);
            System.assertNotEquals(null, result);
            Test.stopTest();
        }
    }
        
    //PSAssignment is empty and EmailStatus is false
    @isTest
    public static void updateUserAccessTest1() {
        Savvas_SSO_TestDataFactory factory = new Savvas_SSO_TestDataFactory();
        User testUser = factory.createUser();
            Test.startTest();
            Savvas_SSO_UserProvisioningHelper.LogDetailsWrapper result = Savvas_SSO_UserProvisioningHelper.updateUserAccess(testUser, 'Worktext_Subscription');
            System.assertNotEquals(null, result);
        	Test.stopTest();
    }
        
    @isTest
    public static void updateUserAccessTest4() {
        Savvas_SSO_TestDataFactory factory = new Savvas_SSO_TestDataFactory();
        User testUser = factory.createUser();
            Test.startTest();
            Savvas_SSO_UserProvisioningHelper.LogDetailsWrapper result = Savvas_SSO_UserProvisioningHelper.updateUserAccess(testUser, 'Worktext');
            System.assertNotEquals(null, result);
        	Test.stopTest();
    }
    
    //Exception at create PSAssignment
    @isTest
    public static void updateUserAccessTest2() {
        Savvas_SSO_TestDataFactory factory = new Savvas_SSO_TestDataFactory();
        Account testAccount = factory.createAccount();
        Contact testContact = factory.createContact(testAccount.Id);
        User portalUser = factory.createPortalUser(testContact);
            Test.startTest();
            Savvas_SSO_UserProvisioningHelper.LogDetailsWrapper result = Savvas_SSO_UserProvisioningHelper.updateUserAccess(portalUser, 'Worktext_Subscription');
            System.assertNotEquals(null, result);
        	Test.stopTest();
    }
    
    //PSAssignment is empty
    @isTest
    public static void updateUserAccessTest3() {
        Savvas_SSO_TestDataFactory factory = new Savvas_SSO_TestDataFactory();
        Account testAccount = factory.createAccount();
        Contact testContact = factory.createContact(testAccount.Id);
        User portalUser = factory.createPortalUser(testContact);
        	factory.createPSAssignment(portalUser);
            Test.startTest();
            Savvas_SSO_UserProvisioningHelper.LogDetailsWrapper result = Savvas_SSO_UserProvisioningHelper.updateUserAccess(portalUser, 'Worktext_Subscription');
            System.assertNotEquals(null, result);
        	Test.stopTest();
    }
    
    @isTest
    public static void sendNotificationEmailTest() {
        Savvas_SSO_TestDataFactory factory = new Savvas_SSO_TestDataFactory();
        Account testAccount = factory.createAccount();
        Contact testContact = factory.createContact(testAccount.Id);
        User portalUser = factory.createPortalUser(testContact);
        Test.startTest();
            Boolean result = Savvas_SSO_UserProvisioningHelper.sendNotificationEmail(portalUser, 'Savvas_Worktext_Subscription_Access_Notification_Email');
            System.assertNotEquals(null, result);
        	Test.stopTest();
    }
    
    @isTest
    public static void registerNewUserTest1() {
        Savvas_SSO_TestDataFactory factory = new Savvas_SSO_TestDataFactory();
        User testUser = factory.createUser();
        System.runAs(testUser) {
            Account testAccount = factory.createAccount();
        	Contact testContact = factory.createContact(testAccount.Id);
        	factory.createSavvasCustomSetting();
        	Test.startTest();
            Savvas_SSO_UserProvisioningHelper.LogDetailsWrapper result = Savvas_SSO_UserProvisioningHelper.registerNewUser('testUser@test.com', 'Test', 'Test', testContact, 'Worktext_Subscription');
            System.assertNotEquals(null, result);
            Test.stopTest();
        }
    }
        @isTest
        public static void registerNewUserTest2() {
            Savvas_SSO_TestDataFactory factory = new Savvas_SSO_TestDataFactory();
            User testUser = factory.createUser();
            System.runAs(testUser) {
                Account testAccount = factory.createAccount();
                Contact testContact = factory.createContact(testAccount.Id);
                factory.createSavvasCustomSetting();
                Test.startTest();
                Savvas_SSO_UserProvisioningHelper.LogDetailsWrapper result = Savvas_SSO_UserProvisioningHelper.registerNewUser('testUser@test.com', 'Test', 'Test', testContact, 'Worktext');
                System.assertNotEquals(null, result);
                Test.stopTest();
            }
        }
        
        @isTest
        public static void registerNewUserTest3() {
            Savvas_SSO_TestDataFactory factory = new Savvas_SSO_TestDataFactory();
            User testUser = factory.createUser();
            System.runAs(testUser) {
                Account testAccount = factory.createAccount();
                Contact testContact = factory.createContact(testAccount.Id);
                Test.startTest();
                Savvas_SSO_UserProvisioningHelper.LogDetailsWrapper result = Savvas_SSO_UserProvisioningHelper.registerNewUser('testUser@test.com', 'Test', 'Test', testContact, 'Worktext');
                System.assertNotEquals(null, result);
                Test.stopTest();
            }
        }
        
        @isTest
    	public static void registerNewUserExceptionTest() {
            try {
            Savvas_SSO_TestDataFactory factory = new Savvas_SSO_TestDataFactory();
                Account testAccount = factory.createAccount();
                Contact testContact = factory.createContact(testAccount.Id);
                factory.createSavvasCustomSetting();
                Test.startTest();
                Savvas_SSO_UserProvisioningHelper.LogDetailsWrapper result = Savvas_SSO_UserProvisioningHelper.registerNewUser('testUser@test.com', 'Test', 'Test', testContact, 'Worktext_Subscription');
                System.assertNotEquals(null, result);
                Test.stopTest();
            }
            catch(Exception e) {
                System.debug(e);
            }
    }
}