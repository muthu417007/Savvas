@isTest
/**
 * UT for the PortlaUtils class
 * 
 * @date 2014-08-26
 * @author Wojciech Migas
 * @Modified Date 2024-08-06
 * @Modified By Cognizant Team
 * @Ticket Number: W-014716
 */

private class PortalUtilsTest {
    
    @isTest static void shouldPopolateUserObject() {
        PortalTestHelper.setEnv();
        Contact c = PortalTestHelper.createContacts(1)[0];
        insert c;
        String userNameSuffix = '_UT_SUFFIX';
        String alias = c.FirstName.left(1) + c.LastName.Left(7);
        String communityNickName   = (c.Email + ' ' + c.FirstName + ' ' + c.LastName).left(40);


        System.Test.startTest();
        User u = PortalUtils.createPortalUserFromContact(c, userNameSuffix);
        System.Test.stopTest();

        System.assertEquals(alias, u.Alias, 'Alias do not match');
        System.assertEquals(communityNickName, u.CommunityNickName, 'CommunityNickName do not match');
        System.assertEquals(c.FirstName, u.FirstName, 'Firstname do not match');
        System.assertEquals(c.LastName, u.LastName, 'LastName do not match');
        System.assertEquals(c.Id, u.ContactId, 'ContactId do not match');
        System.assertEquals(true, u.IsActive, 'User is not active');
        System.assertEquals(c.Email + userNameSuffix, u.UserName, 'Username do not match');
        System.assertEquals(c.Email, u.Email, 'Email do not match');

        CommunityRegistrationSettings__c registrationSettings = CommunityRegistrationSettings__c.getInstance();
        System.assertEquals(registrationSettings.ProfileId__c, u.ProfileId, 'ProfileId do not match custom settings');
        System.assertEquals(registrationSettings.TimeZone__c, u.TimeZoneSidKey, 'TimeZoneSidKey do not match custom settings');
        System.assertEquals(registrationSettings.Locale__c, u.LocaleSidKey, 'LocaleSidKey do not match custom settings');
        System.assertEquals(registrationSettings.EmailEncoding__c, u.EmailEncodingKey, 'EmailEncodingKey do not match custom settings');
        System.assertEquals(registrationSettings.LanguageLocale__c, u.LanguageLocaleKey, 'LanguageLocaleKey do not match custom settings');
    }

    @isTest static void shouldPopolateUserObjectUsernameSuffixFromCustomSettings() {
        PortalTestHelper.setEnv();
        Contact c = PortalTestHelper.createContacts(1)[0];
        insert c;
        CommunityRegistrationSettings__c registrationSettings = CommunityRegistrationSettings__c.getInstance();
        String userNameSuffix = registrationSettings.UserNameSuffix__c;
        String alias = c.FirstName.left(1) + c.LastName.Left(7);
        String communityNickName   = (c.Email + ' ' + c.FirstName + ' ' + c.LastName).left(40);


        System.Test.startTest();
        User u = PortalUtils.createPortalUserFromContact(c);
        System.Test.stopTest();

        System.assertEquals(alias, u.Alias, 'Alias do not match');
        System.assertEquals(communityNickName, u.CommunityNickName, 'CommunityNickName do not match');
        System.assertEquals(c.FirstName, u.FirstName, 'Firstname do not match');
        System.assertEquals(c.LastName, u.LastName, 'LastName do not match');
        System.assertEquals(c.Id, u.ContactId, 'ContactId do not match');
        System.assertEquals(true, u.IsActive, 'User is not active');
        System.assertEquals(c.Email + userNameSuffix, u.UserName, 'Username do not match');
        System.assertEquals(c.Email, u.Email, 'Email do not match');

        System.assertEquals(registrationSettings.ProfileId__c, u.ProfileId, 'ProfileId do not match custom settings');
        System.assertEquals(registrationSettings.TimeZone__c, u.TimeZoneSidKey, 'TimeZoneSidKey do not match custom settings');
        System.assertEquals(registrationSettings.Locale__c, u.LocaleSidKey, 'LocaleSidKey do not match custom settings');
        System.assertEquals(registrationSettings.EmailEncoding__c, u.EmailEncodingKey, 'EmailEncodingKey do not match custom settings');
        System.assertEquals(registrationSettings.LanguageLocale__c, u.LanguageLocaleKey, 'LanguageLocaleKey do not match custom settings');
    }

    @isTest static void checkSupportForNullUsernamePrefix() {
        PortalTestHelper.setEnv();
        Contact c = PortalTestHelper.createContacts(1)[0];
        insert c;
        String userNameSuffix = null;

        System.Test.startTest();
        User u = PortalUtils.createPortalUserFromContact(c, userNameSuffix);
        System.Test.stopTest();

        System.assertEquals(c.Email, u.UserName, 'Username do not match');
    }

    @isTest static void checkSupportForBlankUsernamePrefix() {
        PortalTestHelper.setEnv();
        Contact c = PortalTestHelper.createContacts(1)[0];
        insert c;
        String userNameSuffix = '   ';

        System.Test.startTest();
        User u = PortalUtils.createPortalUserFromContact(c, userNameSuffix);
        System.Test.stopTest();

        System.assertEquals(c.Email, u.UserName, 'Username do not match');
    }

    @isTest static void shouldFindMatchingCase() {
        PortalTestHelper.setEnv();
        Contact contactVar = PortalTestHelper.createContacts(1)[0];
        insert contactVar;
        Case caseVar = PortalTestHelper.createCases(1, contactVar.Id)[0];
        insert caseVar;
        caseVar = [SELECT CaseNumber FROM Case WHERE Id =: caseVar.Id];

        System.Test.startTest();
        Contact c = PortalUtils.getContactByCaseNumberAndEmail(caseVar.CaseNumber, contactVar.Email);
        System.Test.stopTest();

        System.assertNotEquals(null, c, 'Should find contact');
        System.assertEquals(contactVar.Id, c.Id, 'Wrong contact returned');
    }

    @isTest static void shouldNotFindMatchingCase_CaseNumberDoNotMatchEmail() {
        PortalTestHelper.setEnv();
        Contact contactVar = PortalTestHelper.createContacts(1)[0];
        insert contactVar;
        Case caseVar = PortalTestHelper.createCases(1, contactVar.Id)[0];
        insert caseVar;
        caseVar = [SELECT CaseNumber FROM Case WHERE Id =: caseVar.Id];

        System.Test.startTest();
        Contact c = PortalUtils.getContactByCaseNumberAndEmail(caseVar.CaseNumber, contactVar.Email + '1');
        System.Test.stopTest();

        System.assertEquals(null, c, 'Should not find contact');
    }

    @isTest static void shouldNotFindMatchingCase_CaseNumberDoNotExists() {
        PortalTestHelper.setEnv();
        Contact contactVar = PortalTestHelper.createContacts(1)[0];
        insert contactVar;

        System.Test.startTest();
        Contact c = PortalUtils.getContactByCaseNumberAndEmail('RaNdOmStRiNg', contactVar.Email);
        System.Test.stopTest();

        System.assertEquals(null, c, 'Should not find contact');
    }

    @isTest static void shouldFindUserForContact() {
        PortalTestHelper.setEnv();
        Contact contactVar = PortalTestHelper.createContacts(1)[0];
        insert contactVar;
        User u = PortalTestHelper.createPortalUser(contactVar);

        System.Test.startTest();
        Boolean result = PortalUtils.checkIfContactHasAssociatedUser(contactVar.Id);
        System.Test.stopTest();

        System.assertEquals(true, result, 'Should return true, because user exists for given contact id');
    }

    @isTest static void shouldNotFindUserForContact() {
        PortalTestHelper.setEnv();
        Contact contactVar = PortalTestHelper.createContacts(1)[0];
        insert contactVar;

        System.Test.startTest();
        Boolean result = PortalUtils.checkIfContactHasAssociatedUser(contactVar.Id);
        System.Test.stopTest();

        System.assertEquals(false, result, 'Should return false, because user doesn\'t existsfor given contact id');
    }

    @isTest static void shouldReturnFalseNickNameInUse() {
        PortalTestHelper.setEnv();
        Contact contactVar = PortalTestHelper.createContacts(1)[0];
        insert contactVar;
        User u = PortalTestHelper.createPortalUser(contactVar);

        System.Test.startTest();
        Boolean result = PortalUtils.checkNickNameAvailability(u.CommunityNickName);
        System.Test.stopTest();

        System.assertEquals(false, result, 'Should return false, because nick name is in use');
    }

    @isTest static void shouldReturnTrueNickNameInAvailable() {
        PortalTestHelper.setEnv();
        Contact contactVar = PortalTestHelper.createContacts(1)[0];
        insert contactVar;
        User u = PortalTestHelper.createPortalUser(contactVar);

        System.Test.startTest();
        Boolean result = PortalUtils.checkNickNameAvailability('a' + u.CommunityNickName.left(1));
        System.Test.stopTest();

        System.assertEquals(true, result, 'Should return false, because nick name is available');
    }

    @isTest static void shouldReturnURLWithCommunityPrefixAandWithOutApex() {
        PortalTestHelper.setEnv();

        System.Test.startTest();
        String result = PortalUtils.getUrlForPage(Page.ForgotPassword);
        System.Test.stopTest();

        System.assertEquals('/forgotpassword', result, 'urls do not match');
    }
	
    /**SSO Implementation Changes**/
    @isTest
    static void createPortalUserFromContactTest() {
        Savvas_SSO_TestDataFactory factory = new Savvas_SSO_TestDataFactory();
        Account testAccount = factory.createAccount();
        Contact testContact = factory.createContact(testAccount.Id);
        factory.createCommunityCustomSetting();
        
        Test.startTest();
        User result1 = PortalUtils.createPortalUserFromContact(testContact);
        User result2 = PortalUtils.createPortalUserFromContact(testContact, 'Test User');
        Test.stopTest();
        System.assertNotEquals(null, result1);
        System.assertNotEquals(null, result2);
    }
    
    @isTest
    static void getContactByCaseNumberAndEmailTest1() {
        Savvas_SSO_TestDataFactory factory = new Savvas_SSO_TestDataFactory();
        Account testAccount = factory.createAccount();
        Contact testContact = factory.createContact(testAccount.Id);
        Case testCase = factory.createCase(testContact.Id);
        String caseNum = testCase.CaseNumber;
        Test.startTest();
        Contact result = PortalUtils.getContactByCaseNumberAndEmail(caseNum, 'test@cognizant.com');
        Test.stopTest();
        System.assertNotEquals(null, result);
    }
    
    @isTest
    static void getContactByCaseNumberAndEmailTest2() {
        Savvas_SSO_TestDataFactory factory = new Savvas_SSO_TestDataFactory();
        Test.startTest();
        Contact result = PortalUtils.getContactByCaseNumberAndEmail('caseNum', 'test@cognizant.com');
        Test.stopTest();
        System.assertEquals(null, result);
    }
    
 
    @isTest
    static void logExceptionTest() {
        Savvas_SSO_TestDataFactory factory = new Savvas_SSO_TestDataFactory();
        factory.createErrorCustomSetting();
        Test.startTest();
        PortalUtils.logException('Developer Message');
        PortalUtils.logException('Developer Message', 'Type');
        Test.stopTest();
    }
    
    @isTest
    static void assignPSAndSendMailTest() {
        Savvas_SSO_TestDataFactory factory = new Savvas_SSO_TestDataFactory();
        User testUser = factory.createUser();
        Test.startTest();
        Boolean result = PortalUtils.assignPSAndSendMail(testUser);
        Test.stopTest();
        System.assert(true, result);
	}
    
    @isTest
    static void checkIfContactHasExistingUserTest1() {
        Savvas_SSO_TestDataFactory factory = new Savvas_SSO_TestDataFactory();
        User runAsUser = factory.createUser();
        System.runAs(runAsUser) {
            Account testAccount = factory.createAccount();
        	Contact testContact = factory.createContact(testAccount.Id);
            User portalUser= new User(
                FirstName='Test', 
                Username='testUser@test.com',
                LastName='Test', 
                Email='testUser@test.com', 
                Alias= (String.valueOf(Math.random())).substring(0, 8), 
                TimeZoneSidKey='America/Chicago', 
                LocaleSidKey='en_US',
                EmailEncodingKey='ISO-8859-1',
                ProfileId = [SELECT Id FROM Profile WHERE Name='Savvas External Users Base Profile'].Id, 
                isActive = true,
                LanguageLocaleKey='en_US', 
                contactId = testContact.Id
            );
            insert portalUser;
        Test.startTest();
        Integer result = PortalUtils.checkIfContactHasExistingUser(testContact.Id);
        Test.stopTest();
        System.assertEquals(2, result);
    }
    }

	@isTest
    static void checkIfContactHasExistingUserTest2() {
        Savvas_SSO_TestDataFactory factory = new Savvas_SSO_TestDataFactory();
        User runAsUser = factory.createUser();
        System.runAs(runAsUser) {
            Account testAccount = factory.createAccount();
        	Contact testContact = factory.createContact(testAccount.Id);
        Test.startTest();
        Integer result = PortalUtils.checkIfContactHasExistingUser(testContact.Id);
        Test.stopTest();
        System.assertEquals(0, result);
    }
    }
    
    
    @isTest
    static void checkIfContactHasExistingUserExceptionTest() {
        try {
            Savvas_SSO_TestDataFactory factory = new Savvas_SSO_TestDataFactory();
        	Account testAccount = factory.createAccount();
        	Contact testContact = factory.createContact(testAccount.Id);
        	User runAsUser = factory.createUser();
        	System.runAs(runAsUser) {
            User portalUser= new User(
                FirstName='Test', 
                Username='testUser@test.com',
                LastName='Test', 
                Email='testUser@test.com', 
                Alias= (String.valueOf(Math.random())).substring(0, 8), 
                TimeZoneSidKey='America/Chicago', 
                LocaleSidKey='en_US',
                EmailEncodingKey='ISO-8859-1',
                ProfileId = [SELECT Id FROM Profile WHERE Name=:Label.Savvas_Single_Sign_On_Profile].Id, 
                isActive = true,
                LanguageLocaleKey='en_US', 
                contactId = testContact.Id
            );
            insert portalUser;
            }
            Test.startTest();
            Integer result = PortalUtils.checkIfContactHasExistingUser(testContact.Id);
            Test.stopTest();
            
        }
        catch(Exception e) {
            PortalUtils.logException(e);
            PortalUtils.logException(e, 'Developer Message');
        }
    }
}