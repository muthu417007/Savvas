/**
 * ClassName: Sav_FSL_MatchState_Test
 *
 * Description: Test class to cover Sav_FSL_MatchState trigger, Sav_FSL_MatchStateHandler class.
 *
 * Author: CTS team
 * Created Date: 9 FEB 2024
 * Version: v1.0
 * Work no : W-013853
 */

@isTest
public class Sav_FSL_MatchState_Test {
    
 @TestSetup
    private static void makeData(){
        Profile p = [SELECT Id FROM Profile WHERE Name =: Label.ICOM_Professional_Services];
        User testUser = new User(Alias = 'newUser', Email='newuser@testorg.com',
                                 EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                                 LocaleSidKey='en_US', ProfileId = p.Id,
                                 TimeZoneSidKey='America/Los_Angeles', 
                                 Username = UserInfo.getOrganizationId() + System.now().millisecond()+'@test.com');
        insert testUser;
        User testUser1 = new User(Alias = 'newUser1', Email='newuser@testorg.com',
                                  EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                                  LocaleSidKey='en_US', ProfileId = p.Id,
                                  TimeZoneSidKey='America/Los_Angeles', Username = UserInfo.getOrganizationId() + System.now().millisecond()+'@test.com', ManagerId = testUser.Id);
        insert testUser1;
        
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

        OperatingHours oH = new OperatingHours();
        oH.Name = System.Label.Sav_FSL_OpH_Mountain;
        insert oH;
        
        ServiceTerritory territory = new ServiceTerritory();
        territory.Name = System.Label.Sav_FSL_territory_Mountain_West;
        territory.OperatingHoursId = oH.Id;
        territory.IsActive = true;
        insert territory;
        }
    }
    
    
	@isTest
    static void testUpdateServiceTerritorymember() {
        
      // User testUser = [SELECT Id,Name FROM User WHERE Alias = 'newUser'];
        
        ServiceResource sr = [SELECT Id,Sav_FSL_state__c from ServiceResource where Name = 'newUser1'];
        String territoryId = [SELECT Id from ServiceTerritory where Name =: System.Label.Sav_FSL_territory_Mountain_West limit 1].ID;

        // Create ServiceTerritoryMember records
        List<ServiceTerritoryMember> sRTMList = new List<ServiceTerritoryMember>();
        
            ServiceTerritoryMember sRTM = new ServiceTerritoryMember();
         	sRTM.ServiceResourceId = sr.Id;
            sRTM.TerritoryType = 'R';
            sRTM.State ='CA';
        	sRTM.ServiceTerritoryId = territoryId;
        	sRTM.EffectiveStartDate = System.today()-365;
            sRTM.EffectiveEndDate = System.today()+365;
            sRTMList.add(sRTM);

        Test.startTest();

        insert sRTMList;
        // Retrieve updated ServiceResource records
        List<ServiceResource> updatedSRList = [SELECT Id, Sav_FSL_state__c FROM ServiceResource WHERE Id =: sRTM.id];
        // Assert that the state of ServiceResource records has been updated
        for(ServiceResource srl : updatedSRList) {
            // Assuming the state is updated to 'New State' in the test method
            System.assertEquals('CA', sr.Sav_FSL_state__c, 'ServiceResource state should be updated');
        }
        Test.stopTest();
    }	
}