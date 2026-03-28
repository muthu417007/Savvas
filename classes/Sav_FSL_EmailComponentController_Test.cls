/**
* Author: Cognizant Team
* Description: W-013981, W-013981,Test class for coverage of Sav_FSL_EmailComponentController Apex class
* Date Created: 4 FEB 2024
* Version: 1.0
*/
@isTest private class Sav_FSL_EmailComponentController_Test {
	@TestSetup
    private static void makeData(){
        Profile p = [SELECT Id FROM Profile WHERE Name =: Label.ICOM_Professional_Services];
       
        User testUser1 = new User(Alias = 'newUser1', Email='newuser@testorg.com',
                                  EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                                  LocaleSidKey='en_US', ProfileId = p.Id,
                                  TimeZoneSidKey='America/Los_Angeles', Username = UserInfo.getOrganizationId() + System.now().millisecond()+'@test.com');
        insert testUser1;
        User testUser = new User(Alias = 'newUser', Email='newuser@testorg.com',
                                 EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                                 LocaleSidKey='en_US', ProfileId = p.Id,
                                 TimeZoneSidKey='America/Los_Angeles', ManagerId = testUser1.Id,
                                 Username = UserInfo.getOrganizationId() + System.now().millisecond()+'@test.com');
        insert testUser;
        PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name =: Label.FSL_Consultant_Manager_Permissions];  //FSL_Resource_Permissions
        insert new PermissionSetAssignment(AssigneeId = testUser.id, PermissionSetId = ps.Id);
        insert new PermissionSetAssignment(AssigneeId = testUser1.id, PermissionSetId = ps.Id);
        
    }
    
    @isTest private static void testEmailComponentController(){
        User testUser = [SELECT Id,Name FROM User WHERE Alias = 'newUser'];   
        Account acc = new Account(Name='test acc',billingcity = 'New York', OwnerId =testUser.Id);
        insert acc;
        contact testContact = new contact (firstName='test',LastName = 'userContact', CurrencyIsoCode = 'USD',AccountId = acc.Id, Email='test@test.com');
		insert testContact;
        
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
        
        
        ServiceAppointment SA = new ServiceAppointment();
        SA.ParentRecordId = wo.Id;
        SA.Status = 'Ready to Schedule';
        SA.Sav_FSL_Service_Type__c = System.Label.Sav_FSL_Service_Type_PIE;
        SA.Sav_FSL_Delivery_Mode__c = 'Onsite';
        SA.Sav_FSL_Estimated_Number_of_Attendees__c = 10;
        SA.Sav_FSL_Requested_Delivery_Date__c = system.today();
        SA.SchedStartTime = system.now()+1;
        SA.SchedEndTime = system.now()+1;
        SA.DueDate = system.now()+10;
        SA.Sav_FSL_Customer_Time_Zone__c = 'Central';
        SA.Sav_FSL_Grade_Level_s__c = 'K';
        SA.Street = 'NY';
        SA.EarliestStartTime = system.today();
        SA.ServiceTerritoryId = territory.Id;
        SA.Sav_FSL_Alternate_Date_Time3__c = system.today()+4;
        SA.Sav_FSL_Delivery_Mode__c = 'Onsite';
        SA.Sav_FSL_SA_Program__c = '';
        SA.Sav_FSL_Service_Type__c ='Pilot - Support';
        SA.Opportunity__c = oppId;
        SA.Description = '';
        SA.ContactId = testContact.Id;
        insert SA;

        
        
        User testUser1 = [SELECT Id,Name FROM User WHERE Alias = 'newUser1']; 

        AssignedResource assgnRes = new AssignedResource();
        assgnRes.ServiceAppointmentId = SA.Id;
        assgnRes.ServiceResourceId = sR.Id;
        assgnRes.Sav_FSL_Manager__c = testUser1.Id;
        assgnRes.Sav_FSL_Requires_Manager_Approval_SR__c = FALSE;
        assgnRes.Sav_FSL_ServiceResourceUser__c = testUser.Id;
        assgnRes.Sav_FSL_Territory_match__c = TRUE;
        
        insert assgnRes;
        
        list<ProcessInstanceWorkitem> workItems = [
            SELECT Id, ProcessInstanceId 
            FROM ProcessInstanceWorkitem 
            WHERE ProcessInstance.TargetObjectId = :assgnRes.Id limit 1];

        if(workItems.isEmpty()){
        // Create an approval request for the test record
        Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
        req.setComments('Submitting request for approval.');
        req.setObjectId(assgnRes.Id);

        // Submit the approval request
        Approval.ProcessResult result = Approval.process(req);

        // Verify the result
        System.assert(result.isSuccess(), 'Failed to submit for approval');
        }

        Test.startTest();
       // ProcessInstanceWorkitem testWorkItem = new ProcessInstanceWorkitem();
        Sav_FSL_EmailComponentController testController = new Sav_FSL_EmailComponentController();
        testController.recId = assgnRes.id;
        String step = testController.managerEmail;
        AssignedResource result = testController.showAR;
        Test.stopTest();
    }
    
}