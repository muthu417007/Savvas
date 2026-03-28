/*
@Author : Cognizant Team
@Name : Savvas_SSO_TestDataFactory 
@CreateDate : 04-June-2024
@Description: This class is test factory class for all test class
@ModifiedBy: Cognizant Team
@ModifiedDate: 04-June-2024
@Ticket Number: W-014599, W-014600
*/ 
@isTest
public without sharing class Savvas_SSO_TestDataFactory {

    /*
    *  Method Name : createAccount
    *  Description : creating test Account
    *  param : none
    *  return : Account
    */
    public Account createAccount() {
            Account portalAcc = new Account(Name = 'Test Account');
            insert portalAcc;
            return portalAcc;
        }
    
    public Account createAccountwithShipAddress() {
            Account portalAcc = new Account();
        	portalAcc.Name = 'Test Account';
        	portalAcc.ShippingCity = 'test';
        	portalAcc.ShippingStreet = 'test';
        	portalAcc.ShippingState = 'test';
        	portalAcc.ShippingPostalCode = 'test';
        	portalAcc.ShippingCountry = 'test';
            insert portalAcc;
            return portalAcc;
        }
        
        /*
        *  Method Name : createContact
        *  Description : creating test Contact
        *  param : none
        *  return : Contact
        */
        public Contact createContact(Id accId) {
            Contact portalCon = new Contact();
            portalCon.FirstName = 'Test';
            portalCon.LastName = 'Contact'+Integer.valueOf((Math.random()));
            portalCon.AccountId = accId;
            portalCon.Email = 'test@cognizant.com';            
            insert portalCon;
            return portalCon;
        }
        
        /*
        *  Method Name : createUser
        *  Description : creating test System Admin User 
        *  param : none
        *  return : User
        */
    public User createUser(){
            User newUser= new User(FirstName='Test', Username='testUserToRunAs@test.com' + String.valueOf(Math.random()), 
                                    LastName='Test', Email='testUser@test.com', 
                                    Alias= (String.valueOf(Math.random())).substring(0, 8), TimeZoneSidKey='America/Chicago', LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1',
                                    ProfileId = [SELECT Id FROM Profile WHERE Name='System Administrator'].Id, 
                                    UserRoleId = [SELECT Id from UserRole where Name = 'Marketing'].Id, isActive = true,
                                    LanguageLocaleKey='en_US');
            insert newUser;
            return newUser;
        }
    
    /*
        *  Method Name : createUser
        *  Description : creating test Portal User
        *  param : none
        *  return : User
        */
    public User createPortalUser(Contact con) {
    User portalUser= new User(
                FirstName='Test', 
                Username='testUser@test.com',
                LastName='Test', 
                Email='testUser@test.com', 
                Alias= (String.valueOf(Math.random())).substring(0, 8), 
                TimeZoneSidKey='America/Chicago', 
                LocaleSidKey='en_US',
                EmailEncodingKey='ISO-8859-1',
                ProfileId = [SELECT Id FROM Profile WHERE Name= 'Savvas External Users Base Profile'].Id, 
                isActive = true,
                LanguageLocaleKey='en_US', 
                contactId = con.Id
            );
            insert portalUser;
    		return portalUser;
    }
    
    /*
        *  Method Name : createPSAssignment
        *  Description : creating Savvas_Worktext_Subscription_Permissions permission set assignment for user
        *  param : User
        *  return : void
        */
    public void createPSAssignment(User psUser) {
        System.runAs(psUser) {
            PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'Savvas_Worktext_Subscription_Permissions'];
            insert new PermissionSetAssignment(AssigneeId = psUser.Id, PermissionSetId = ps.Id);
    }
    }
    
    /*
        *  Method Name : createPSAssignment
        *  Description : creating Savvas_Worktext_Subscription_Permissions permission set assignment for user
        *  param : User
        *  return : void
        */
    public void createCCPSAssignment(User portalUser) {
            PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'Savvas_Customer_Care_External_Users_Permissions'];
                insert new PermissionSetAssignment(AssigneeId = portalUser.id, PermissionSetId = ps.Id);
    }
    
    /*
        *  Method Name : createCustomSetting
        *  Description : creating an instance for custom setting
        *  param : User
        *  return : void
        */
    public void createSavvasCustomSetting() {
        Id profileId = [SELECT Id from Profile where Name = 'Savvas External Users Base Profile'].Id;
        SavvasSSORegistrationSettings__c dummySetting = new SavvasSSORegistrationSettings__c();
		dummySetting.TimeZone__c = 'America/Chicago';
        dummySetting.EmailEncoding__c = 'ISO-8859-1';
        dummySetting.LanguageLocale__c = 'en_US';
        dummySetting.ProfileId__c = profileId;
        dummySetting.Locale__c = 'en_US';
		insert dummySetting;
    }
    
    /*
        *  Method Name : createCommunityCustomSetting
        *  Description : creating an instance for custom setting for Customer care community
        *  param : void
        *  return : void
        */
    public void createCommunityCustomSetting() {
        Id profileId = [SELECT Id from Profile where Name = 'Savvas External Users Base Profile'].Id;
        CommunityRegistrationSettings__c dummySetting = new CommunityRegistrationSettings__c();
		dummySetting.TimeZone__c = 'America/Chicago';
        dummySetting.EmailEncoding__c = 'ISO-8859-1';
        dummySetting.LanguageLocale__c = 'en_US';
        dummySetting.ProfileId__c = profileId;
        dummySetting.Locale__c = 'en_US';
		insert dummySetting;
    }
	
    /*
        *  Method Name : createErrorCustomSetting
        *  Description : creating an instance for custom error setting for PortalUtils
        *  param : void
        *  return : void
        */
	public void createErrorCustomSetting() {
        ErrorLoggingSettings__c dummySetting = new ErrorLoggingSettings__c();
        dummySetting.enabled__c = true;
		insert dummySetting;
    }
    
    /*
        *  Method Name : createCase
        *  Description : creating test cases
        *  param : contact Id
        *  return : case
        */
    public Case createCase(Id testContact) {
        Case testCase = new Case();
        testCase.ContactId = testContact;
        insert testCase;
        List<Case> caseInserted = [Select CaseNumber from Case where Id =:testCase.Id limit 1];
        return caseInserted[0];
    }
}