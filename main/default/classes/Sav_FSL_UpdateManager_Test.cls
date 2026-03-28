/**
 * ClassName: Sav_FSL_MatchState_Test
 *
 * Description: Test class to cover Sav_FSL_MatchState trigger, Sav_FSL_MatchStateHandler class.
 *
 * Author: CTS team
 * Created Date: 16 FEB 2024
 * Version: v1.0
 * Work no : W-013853
 */
@isTest
public class Sav_FSL_UpdateManager_Test {

 @TestSetup
    private static void makeData(){
        Profile p = [SELECT Id FROM Profile WHERE Name =: Label.ICOM_Professional_Services];
        User testUser = new User(Alias = 'newUser', Email='newuser@testorg.com',
                                 EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US',
                                 LocaleSidKey='en_US', ProfileId = p.Id,
                                 TimeZoneSidKey='America/Los_Angeles', 
                                 Username = UserInfo.getOrganizationId() + System.now().millisecond()+'@test.com');
        insert testUser;
        User testUser1 = new User(Alias = 'newUser1', Email='newuser@testorg.com',
                                  EmailEncodingKey='UTF-8', LastName='Testing2', LanguageLocaleKey='en_US',
                                  LocaleSidKey='en_US', ProfileId = p.Id,
                                  TimeZoneSidKey='America/Los_Angeles', Username = UserInfo.getOrganizationId() + System.now().millisecond()+'@test.com', ManagerId = testUser.Id);
        insert testUser1;

        User testUser2 = new User(Alias = 'newUser2', Email='newuser@testorg.com',
                                 EmailEncodingKey='UTF-8', LastName='Testing3', LanguageLocaleKey='en_US',
                                 LocaleSidKey='en_US', ProfileId = p.Id,
                                 TimeZoneSidKey='America/Los_Angeles', 
                                 Username = UserInfo.getOrganizationId() + System.now().millisecond()+'@test.com');
        insert testUser2;
        
        PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name =: Label.FSL_Consultant_Manager_Permissions];  //FSL_Resource_Permissions
        insert new PermissionSetAssignment(AssigneeId = testUser.id, PermissionSetId = ps.Id);
        insert new PermissionSetAssignment(AssigneeId = testUser1.id, PermissionSetId = ps.Id);

        UserRole role=[SELECT Id from UserRole where name='CEO' Limit 1];
        Profile profile1 = [SELECT Id FROM Profile where Name='System Administrator'];
        User systemAdmin = SavvasVirtualSamplingTestFactory.getUser(profile1.Id);
        systemAdmin.Email='TestAdmin@admin.com.invalid';
        systemAdmin.UserRoleId = role.Id;
        Insert systemAdmin;

        System.runAs(systemAdmin) {
        ServiceResource sR = new ServiceResource();
        sR.Name = testUser1.Alias;
        sR.RelatedRecordId = testUser1.Id;
        sR.Sav_FSL_Service_Resource_Type__c = System.Label.Sav_FSL_Service_resource_Type_FTE;
        sR.ResourceType = System.Label.Sav_FSL_ResourceType_T;
        sR.Sav_FSL_Primary_Role__c = System.Label.Sav_FSL_Primary_Role_CS;
        sR.Sav_FSL_Start_Date__c = system.today(); 
        sR.Sav_FSL_state__c = 'International';
        sR.IsActive = true;
        insert sR;

        }
    }

    	@isTest
    static void testUpdateUser() {
        
       List<User> testUsers = [SELECT Id,Name,ManagerId FROM User WHERE Alias = 'newUser1'OR Alias = 'newUser2'];
        
        User testUser1 = testUsers[0];
        User testUser2 = testUsers[1];

        Test.startTest();
        testUser1.ManagerId = testUser2.Id;
        Update testUser1;
        Test.stopTest();
    }	
}