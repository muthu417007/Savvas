/**
 * An apex page controller that supports self registration of users in communities that allow self registration
 * 
 * @date 2014-08-26
 * @author Wojciech Migas
 * @Modified Date 2024-08-06
 * @Modified By Cognizant Team
 * @Ticket Number: W-014716
 */
@IsTest
public with sharing class CommunitiesSelfRegControllerTest {
    
    @isTest public static void shouldCreateNewUserAndRedirectToLandingPage() {
        UserRole role=[SELECT Id from UserRole where name='CEO' Limit 1];
        Profile profile = [SELECT Id FROM Profile where Name='System Administrator'];
        User systemAdmin = SavvasVirtualSamplingTestFactory.getUser(profile.Id);
        systemAdmin.UserRoleId = role.Id;
        Insert systemAdmin;
        System.runAs(systemAdmin){
            PortalTestHelper.setEnv();
            Contact contactVar = PortalTestHelper.createContacts(1)[0];
            insert contactVar;
            Case caseVar = PortalTestHelper.createCases(1, contactVar.Id)[0];
            insert caseVar;
            caseVar = [SELECT CaseNumber FROM Case WHERE Id =: caseVar.Id];
    
            CommunitiesSelfRegController controller = new CommunitiesSelfRegController();
            controller.firstName = contactvar.firstName;
            controller.lastName =  contactvar.lastName;
            controller.email = contactVar.Email;
            controller.casenumber = caseVar.CaseNumber;
                
            Integer noOfUsersBefore = (Integer)[SELECT count(id) no FROM User where firstName = :contactVar.firstName and lastName = :contactVar.lastName].get(0).get('no');        
    
            system.debug('***[CommunitiesSelfRegControllerTest - noOfUsersBefore: ]' + noOfUsersBefore);
        
            System.Test.startTest();
            PageReference pr = controller.registerUser();
            System.Test.stopTest();
            
            Integer noOfUsersAfter = (Integer)[SELECT count(id) no FROM User  where firstName = :contactVar.firstName and lastName = :contactVar.lastName].get(0).get('no');
    
            system.debug('***[CommunitiesSelfRegControllerTest - noOfUsersAfter: ]' + noOfUsersAfter);
    
            List<User> users = [SELECT ContactId,firstName, lastName FROM User WHERE ContactId =: contactVar.Id];
      
            system.assertEquals(null, pr);
        }
    }

    @isTest public static void shouldPopulateCaseNumberFromUrl() {
        PortalTestHelper.setEnv();
        Contact contactVar = PortalTestHelper.createContacts(1)[0];
        insert contactVar;
        Case caseVar = PortalTestHelper.createCases(1, contactVar.Id)[0];
        insert caseVar;
        caseVar = [SELECT CaseNumber FROM Case WHERE Id =: caseVar.Id];

        ApexPages.currentPage().getParameters().put('caseNumber', caseVar.CaseNumber);
        CommunitiesSelfRegController controller = new CommunitiesSelfRegController();
        System.assertEquals(caseVar.CaseNumber, controller.casenumber, 'Case number should be populated from url');
    }

    @isTest public static void shouldReturnErrorCannotFindCase() {
        PortalTestHelper.setEnv();
        Contact contactVar = PortalTestHelper.createContacts(1)[0];
        insert contactVar;

        CommunitiesSelfRegController controller = new CommunitiesSelfRegController();
        controller.firstName = contactvar.firstName;
        controller.lastName =  contactvar.lastName;
        controller.email = contactVar.Email;
        controller.casenumber = 'RaNdOmStRiNg';

        Integer noOfUsersBefore = getUserCount(contactVar);        

        System.Test.startTest();
        PageReference pr = controller.registerUser();
        System.Test.stopTest();

        Integer noOfUsersAfter = getUserCount(contactVar);
        System.assertEquals(null, pr, 'User should stay on the same page');
        System.assertEquals(noOfUsersBefore, noOfUsersAfter, 'New user should not be created');
        Boolean isValidMessage = false;
        for (ApexPages.Message msg: ApexPages.getMessages()) {
            if ('<font color="red"><b>There is no case matching given case number and email address.<b></font>' == msg.getSummary() && ApexPages.Severity.ERROR == msg.getSeverity()) {
                isValidMessage = true;
            }
        }
        System.assert(isValidMessage, 'Missing or invalid page message');
    }
    
    @isTest public static void shouldReturnErrorInternalUser() {
        PortalTestHelper.setEnv();
        Contact contactVar = PortalTestHelper.createContacts(1)[0];
        insert contactVar;

        CommunitiesSelfRegController controller = new CommunitiesSelfRegController();
        controller.firstName = contactvar.firstName;
        controller.lastName =  contactvar.lastName;
        controller.email = 'Test.user@pearson.com';
        controller.casenumber = 'RaNdOmStRiNg';

        Integer noOfUsersBefore = getUserCount(contactVar);        

        System.Test.startTest();
        PageReference pr = controller.registerUser();
        System.Test.stopTest();

        Integer noOfUsersAfter = getUserCount(contactVar);
        System.assertEquals(null, pr, 'User should stay on the same page');
        System.assertEquals(noOfUsersBefore, noOfUsersAfter, 'New user should not be created');
        Boolean isValidMessage = false;
        for (ApexPages.Message msg: ApexPages.getMessages()) {
            if ('<font color="red"><b>Pearson Employees: If you submitted a case on behalf of your customer, and your email address is attached to the case email, you must enter through your Salesforce account. If you do not have a Salesforce account, talk to your manager about requesting access.<b></font>' == msg.getSummary() && ApexPages.Severity.ERROR == msg.getSeverity()) {
                isValidMessage = true;
            }
        }
        System.assert(isValidMessage, 'Missing or invalid page message');
    }
    
    /*SSO Implementation Changes*/
    @isTest public static void shouldAssignPSUserAlreadyExists() {
        UserRole role=[SELECT Id from UserRole where name='CEO' Limit 1];
        Profile profile = [SELECT Id FROM Profile where Name='System Administrator'];
        User systemAdmin = SavvasVirtualSamplingTestFactory.getUser(profile.Id);
        systemAdmin.UserRoleId = role.Id;
        Insert systemAdmin;
        System.runAs(systemAdmin){
            PortalTestHelper.setEnv();
            Contact contactVar = PortalTestHelper.createContacts(1)[0];
            insert contactVar;
            User u = PortalTestHelper.createPortalUser(contactVar);
            Case caseVar = PortalTestHelper.createCases(1, contactVar.Id)[0];
            insert caseVar;
            caseVar = [SELECT CaseNumber FROM Case WHERE Id =: caseVar.Id];
    
            CommunitiesSelfRegController controller = new CommunitiesSelfRegController();
            controller.firstName = contactvar.firstName;
            controller.lastName =  contactvar.lastName;
            controller.email = contactVar.Email;
            controller.casenumber = caseVar.CaseNumber;
    
            Integer noOfUsersBefore = getUserCount(contactVar);        
    
            System.Test.startTest();
            PageReference pr = controller.registerUser();
            System.Test.stopTest();
    
            Integer noOfUsersAfter = getUserCount(contactVar);
            System.assertEquals(noOfUsersBefore, noOfUsersAfter, 'New user should not be created');
            List<PermissionSetAssignment> psaList = [SELECT PermissionSet.Name, Assignee.Id FROM PermissionSetAssignment WHERE PermissionSet.Name = 'Savvas_Customer_Care_External_Users_Permissions' AND Assignee.Id =: u.Id];
            System.assert(!psaList.isEmpty(), 'PS is not assigned');
          }
    }

    /*SSO Implementation Changes*/
    @isTest public static void shouldReturnUserAlreadyExists() {
        UserRole role=[SELECT Id from UserRole where name='CEO' Limit 1];
        Profile profile = [SELECT Id FROM Profile where Name='System Administrator'];
        User systemAdmin = SavvasVirtualSamplingTestFactory.getUser(profile.Id);
        systemAdmin.UserRoleId = role.Id;
        Insert systemAdmin;
        System.runAs(systemAdmin){
            PortalTestHelper.setEnv();
            Contact contactVar = PortalTestHelper.createContacts(1)[0];
            insert contactVar;
            User u = PortalTestHelper.createPortalUser(contactVar);
            PermissionSet permSet = [SELECT id FROM PermissionSet WHERE Name=: Label.Savvas_Customer_Care_Permissions];
            PermissionSetAssignment pemSetAss = new PermissionSetAssignment (PermissionSetId=permSet.Id, AssigneeId=u.Id);
            insert pemSetAss;
            Case caseVar = PortalTestHelper.createCases(1, contactVar.Id)[0];
            insert caseVar;
            caseVar = [SELECT CaseNumber FROM Case WHERE Id =: caseVar.Id];
    
            CommunitiesSelfRegController controller = new CommunitiesSelfRegController();
            controller.firstName = contactvar.firstName;
            controller.lastName =  contactvar.lastName;
            controller.email = contactVar.Email;
            controller.casenumber = caseVar.CaseNumber;
    
            Integer noOfUsersBefore = getUserCount(contactVar);        
    
            System.Test.startTest();
            PageReference pr = controller.registerUser();
            System.Test.stopTest();
    
            Integer noOfUsersAfter = getUserCount(contactVar);
            System.assertEquals(noOfUsersBefore, noOfUsersAfter, 'New user should not be created');
            Boolean isValidMessage = false;
            for (ApexPages.Message msg: ApexPages.getMessages()) {
                if (msg.getSummary().startsWith('<font color="red"><b>User already exists, if you forgot password, please use this') && ApexPages.Severity.ERROR == msg.getSeverity()) {
                    isValidMessage = true;
                }
            }
            System.assert(isValidMessage, 'Missing or invalid page message');
          }
    }

    @isTest public static void shouldGenerateUniqueNickNameAndCreateUser() {
        UserRole role=[SELECT Id from UserRole where name='CEO' Limit 1];
        Profile profile = [SELECT Id FROM Profile where Name='System Administrator'];
        User systemAdmin = SavvasVirtualSamplingTestFactory.getUser(profile.Id);
        systemAdmin.UserRoleId = role.Id;
        Insert systemAdmin;
        System.runAs(systemAdmin){
            PortalTestHelper.setEnv();
            List<Contact> contacts = PortalTestHelper.createContacts(2);
            insert contacts;
            User u = PortalTestHelper.createPortalUser(contacts[0]);
            Contact contactVar = contacts[1];
            User tmpUserObj = PortalUtils.createPortalUserFromContact(contactVar);
            u.CommunityNickName = tmpUserObj.CommunityNickName;
            System.runAs(u) {
                update u;
            }
            Case caseVar = PortalTestHelper.createCases(1, contactVar.Id)[0];
            insert caseVar;
            caseVar = [SELECT CaseNumber FROM Case WHERE Id =: caseVar.Id];
    
            CommunitiesSelfRegController controller = new CommunitiesSelfRegController();
            controller.firstName = contactvar.firstName;
            controller.lastName =  contactvar.lastName;
            controller.email = contactVar.Email;
            controller.casenumber = caseVar.CaseNumber;
    
            Integer noOfUsersBefore = (Integer)[SELECT count(id) no FROM User  where firstName = :contactVar.firstName and lastName = :contactVar.lastName].get(0).get('no');        
    
            System.Test.startTest();
            PageReference pr = controller.registerUser();
            System.Test.stopTest();
    
            Integer noOfUsersAfter = (Integer)[SELECT count(id) no FROM User where firstName = :contactVar.firstName and lastName = :contactVar.lastName].get(0).get('no');
            List<User> users = [SELECT ContactId FROM User WHERE ContactId =: contactVar.Id];
            System.assertEquals(null, pr);
        }
    }

    /**
     * That error is possible only from UT because lastname field is reuqired in visualforce page
     */
    @isTest public static void shouldReturnUnexpectedErrorContactLastNameIsRequired() {
        PortalTestHelper.setEnv();
        Contact contactVar = PortalTestHelper.createContacts(1)[0];
        insert contactVar;
        Case caseVar = PortalTestHelper.createCases(1, contactVar.Id)[0];
        insert caseVar;
        caseVar = [SELECT CaseNumber FROM Case WHERE Id =: caseVar.Id];

        CommunitiesSelfRegController controller = new CommunitiesSelfRegController();
        controller.firstName = contactvar.firstName;
        controller.email = contactVar.Email;
        controller.casenumber = caseVar.CaseNumber;

        Integer noOfUsersBefore = getUserCount(contactVar);        

        System.Test.startTest();
        PageReference pr = controller.registerUser();
        System.Test.stopTest();

        Integer noOfUsersAfter = getUserCount(contactVar);
        System.assertEquals(null, pr, 'User should stay on the same page');
        System.assertEquals(noOfUsersBefore, noOfUsersAfter, 'New user should not be created');
        Boolean isValidMessage = false;
        for (ApexPages.Message msg: ApexPages.getMessages()) {
            if ('An unexpected error occured. Please try again.' == msg.getSummary() && ApexPages.Severity.ERROR == msg.getSeverity()) {
                isValidMessage = true;
            }
        }
        System.assert(isValidMessage, 'Missing or invalid page message');
    }    
    
    private static integer getUserCount(contact c) {
    	return (Integer)[SELECT count(id) no FROM User where lastName = :c.lastName].get(0).get('no');
    }
    
}