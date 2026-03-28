/**
* Author: Cognizant Team
* Description: W-013923,Test class for coverage of Sav_FSL_ApprovalProcessToReject Apex class
* Date Created: 19 FEB 2024
* Version: 1.0
*/
@isTest 
private class Sav_FSL_ApprovalProcessToReject_Test {
        @TestSetup
    private static void makeData(){
        Profile p = [SELECT Id FROM Profile WHERE Name =: Label.ICOM_Professional_Services];
        User testUser = new User(Alias = 'newUser', Email='newuser@testorg.com',
                                 EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                                 LocaleSidKey='en_US', ProfileId = p.Id,
                                 TimeZoneSidKey='America/Los_Angeles', 
                                 Username = UserInfo.getOrganizationId() + System.now().millisecond()+'@test11.com');
        insert testUser;
        User testUser1 = new User(Alias = 'newUser1', Email='newuser@testorg.com',
                                  EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                                  LocaleSidKey='en_US', ProfileId = p.Id,
                                  TimeZoneSidKey='America/Los_Angeles', Username = UserInfo.getOrganizationId() + System.now().millisecond()+'@test.com');
        insert testUser1;
        
        PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name =: Label.FSL_Consultant_Manager_Permissions];  //FSL_Resource_Permissions
        insert new PermissionSetAssignment(AssigneeId = testUser.id, PermissionSetId = ps.Id);
        insert new PermissionSetAssignment(AssigneeId = testUser1.id, PermissionSetId = ps.Id);
        
    }
    
 @isTest 
    private static void testRejection() { 
     User testUser = [SELECT Id,Name FROM User WHERE Alias = 'newUser'];   
     Account acc = new Account(Name='test acc',billingcity = 'New York', OwnerId =testUser.Id);
        insert acc;
        
        Opportunity opp = new Opportunity(Name = 'test Opportunity', AccountId = acc.Id, 
                                          StageName = 'Prospect', CloseDate = Date.today(), CurrencyIsoCode = 'USD', Opportunity_Leader__c = testUser.Id );
        insert opp;
        
        String accId = [SELECT Id FROM Account][0].Id;
        String oppId = [SELECT Id FROM Opportunity WHERE AccountId = :accId][0].Id;
        
        
        ServiceResource sR = new ServiceResource();
        sR.Name = testUser.Name;
        sR.RelatedRecordId = testUser.Id;
        sR.Sav_FSL_Service_Resource_Type__c = System.Label.Sav_FSL_Service_resource_Type_FTE;
        sR.ResourceType = System.Label.Sav_FSL_ResourceType_T;
        sR.Sav_FSL_Primary_Role__c = System.Label.Sav_FSL_Primary_Role_CS;
        sR.Sav_FSL_Start_Date__c = system.today(); 
        sR.IsActive = true;
        insert sR;
     
        OperatingHours oH = new OperatingHours();
        oH.Name = System.Label.Sav_FSL_OpH_Mountain;
        // oH.TimeZone = '(GMT-06:00) Mountain Daylight Time (America/Denver)';
        insert oH;
        
        ServiceTerritory territory = new ServiceTerritory();
        territory.Name = System.Label.Sav_FSL_territory_Mountain_West;
        territory.OperatingHoursId = oH.Id;
        territory.IsActive = true;
        insert territory;
        
        ServiceTerritoryMember serTerrMember = new ServiceTerritoryMember();
        serTerrMember.ServiceResourceId	= sR.Id;
        serTerrMember.ServiceTerritoryId = territory.Id;
        serTerrMember.TerritoryType = System.Label.Sav_FSL_TerritoryType_P;
        serTerrMember.EffectiveStartDate = system.now() - 10 ;
        insert serTerrMember;
        WorkOrder wo = new WorkOrder();
        wo.Sav_FSL_Order_Date__c =  System.today();
        wo.Sav_FSL_Opportunity__c = oppId;
        wo.AccountId = accId;
        wo.RecordTypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByName().get('Learning Services').getRecordTypeId();
        wo.Sav_FSL_Service_Type__c = System.Label.Sav_FSL_Service_Type_PIE;
        wo.Sav_FSL_Program__c = System.Label.Sav_FSL_Program_AP_Math;
        insert wo;
        
        FSL.GlobalAPIS.addStatusTransition('Ready to Schedule', 'Proposed');
        FSL.GlobalAPIS.addStatusTransition('Proposed', 'Scheduled');
        FSL.GlobalAPIS.addStatusTransition('Scheduled', 'Proposed');
        FSL.GlobalAPIS.addStatusTransition('Proposed', 'Ready to Schedule');
        FSL.GlobalAPIS.addStatusTransition('Ready to Schedule', 'Scheduled');
        FSL.GlobalAPIS.addStatusTransition('Scheduled','Ready to Schedule');
        
        
        ServiceAppointment SA = new ServiceAppointment();
        SA.ParentRecordId = wo.Id;
        SA.Status = 'Ready To Schedule';
        SA.Sav_FSL_Service_Type__c = System.Label.Sav_FSL_Service_Type_PIE;
        SA.Sav_FSL_Delivery_Mode__c = 'Onsite';
        SA.Sav_FSL_Estimated_Number_of_Attendees__c = 10;
        SA.Sav_FSL_Requested_Delivery_Date__c = system.today();
        SA.SchedStartTime = system.now()+1;
        SA.SchedEndTime = system.now()+1;
        SA.DueDate = system.now()+10;
        SA.EarliestStartTime = system.today();
        SA.ServiceTerritoryId = territory.Id;
        //SA.AccountId = accId;
        SA.Opportunity__c = oppId;
        insert SA;
        
        AssignedResource assgnRes = new AssignedResource();
        assgnRes.ServiceAppointmentId = SA.Id;
        assgnRes.ServiceResourceId = sR.Id;
        
        insert assgnRes;
      
     // Create a test AssignedResource record 
	Sav_FSL_ApprovalProcessToReject.ARListAndResponse testARAndResponse = new Sav_FSL_ApprovalProcessToReject.ARListAndResponse(); 
	testARAndResponse.aRList = new List<String>{assgnRes.Id}; 
    testARAndResponse.responseList = new List<String>{'Reject'};
     test.startTest();
     Sav_FSL_ApprovalProcessToReject.rejection(new List<Sav_FSL_ApprovalProcessToReject.ARListAndResponse>{testARAndResponse}); 
     // Add assertions based on your requirements 
     // For example, you may want to check if the rejection was successful 
     // Query the ProcessInstanceWorkitem to verify rejection 
     List<ProcessInstanceWorkitem> workItems = [ SELECT Id, ProcessInstanceId FROM ProcessInstanceWorkitem 
                       							 WHERE ProcessInstance.TargetObjectId = :assgnRes.Id ]; 
        test.stopTest();
 }
}