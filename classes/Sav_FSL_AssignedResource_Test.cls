/**
* Author: Cognizant Team
* Description: Test class for coverage of Sav_FSL_AssignedResource_Trigger and Sav_FSL_AssignedResource_TriggerHandler Apex class
* Date Created: 25-04-2023
* Version: 1.0
* Version: 2.0 (commented line 170 for W-013853 | Date : 8 MAR 2024)
*/

@isTest
public class Sav_FSL_AssignedResource_Test {
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
                                  TimeZoneSidKey='America/Los_Angeles', Username = UserInfo.getOrganizationId() + System.now().millisecond()+'@test.com');
        insert testUser1;
        
        PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name =: Label.FSL_Consultant_Manager_Permissions];  //FSL_Resource_Permissions
        insert new PermissionSetAssignment(AssigneeId = testUser.id, PermissionSetId = ps.Id);
        insert new PermissionSetAssignment(AssigneeId = testUser1.id, PermissionSetId = ps.Id);
        
    }
    
    static testMethod void AddResource() {
        FSL.GlobalAPIS.addStatusTransition('Ready to Schedule', 'Scheduled');
        FSL.GlobalAPIS.addStatusTransition('Scheduled', 'Canceled');
        FSL.GlobalAPIS.addStatusTransition('Ready to Schedule', 'Canceled');
        FSL.GlobalAPIS.addStatusTransition('Scheduled', 'Proposed');
        FSL.GlobalAPIS.addStatusTransition('Proposed', 'Scheduled');
        FSL.GlobalAPIS.addStatusTransition('Proposed', 'Canceled');
        
        User testUser = [SELECT Id,Name FROM User WHERE Alias = 'newUser'];
        User testUser1 = [SELECT Id,Name FROM User WHERE Alias = 'newUser1'];
        
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
        
        ServiceResource sR1 = new ServiceResource();
        sR1.Name = testUser1.Name;
        sR1.RelatedRecordId = testUser1.Id;
        sR1.Sav_FSL_Service_Resource_Type__c = System.Label.Sav_FSL_Service_resource_Type_FTE;
        sR1.ResourceType =System.Label.Sav_FSL_ResourceType_A;
        sR1.Sav_FSL_Primary_Role__c = System.Label.Sav_FSL_Primary_Role_CS;
        sR1.Sav_FSL_Start_Date__c = system.today(); 
        sR1.IsActive = true;
        insert sR1;
        
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
        
        ServiceTerritoryMember serTerrMember1 = new ServiceTerritoryMember();
        serTerrMember1.ServiceResourceId	= sR1.Id;
        serTerrMember1.ServiceTerritoryId = territory.Id;
        serTerrMember1.TerritoryType = System.Label.Sav_FSL_TerritoryType_P;
        serTerrMember1.EffectiveStartDate = system.now() - 10 ;
        insert serTerrMember1;
        
        WorkOrder wo = new WorkOrder();
        wo.Sav_FSL_Order_Date__c =  System.today();
        wo.Sav_FSL_Opportunity__c = oppId;
        wo.AccountId = accId;
        wo.RecordTypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByName().get('Learning Services').getRecordTypeId();
        wo.Sav_FSL_Service_Type__c = System.Label.Sav_FSL_Service_Type_PIE;
        wo.Sav_FSL_Program__c = System.Label.Sav_FSL_Program_AP_Math;
        insert wo;
        
        ServiceAppointment SA = new ServiceAppointment();
        SA.ParentRecordId = wo.Id;
        SA.Status = 'Scheduled';
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
        
        ServiceAppointment SA1 = new ServiceAppointment();
        SA1.ParentRecordId = wo.Id;
        SA1.Status = 'Scheduled';
        SA1.Sav_FSL_Service_Type__c = System.Label.Sav_FSL_Service_Type_PIE;
        SA1.Sav_FSL_Delivery_Mode__c = 'Virtual';
        SA1.Sav_FSL_Estimated_Number_of_Attendees__c = 10;
        SA1.Sav_FSL_Requested_Delivery_Date__c = system.today();
        SA1.SchedStartTime = system.now()+1;
        SA1.SchedEndTime = system.now()+1;
        SA1.DueDate = system.now()+10;
        SA1.EarliestStartTime = system.today();
        SA1.ServiceTerritoryId = territory.Id;
        //SA.AccountId = accId;
        SA1.Opportunity__c = oppId;
        insert SA1;
        
        test.startTest();
        AssignedResource assgnRes = new AssignedResource();
        assgnRes.ServiceAppointmentId = SA.Id;
        assgnRes.ServiceResourceId = sR.Id;
        
        insert assgnRes;
        
        
        AssignedResource assgnRes1 = new AssignedResource();
        assgnRes1.ServiceAppointmentId = SA1.Id;
        assgnRes1.ServiceResourceId = sR.Id;
        
        insert assgnRes1;
        
        
        
        TimeSheet ts = new TimeSheet();
        ts.StartDate = system.today();
        ts.EndDate = system.today() + 1;
        ts.ServiceResourceId = sR1.Id;
        ts.Service_Appointment__c = SA1.Id;
        insert ts;
        
        assgnRes1.ServiceResourceId = sR1.Id;
        try{
            update assgnRes1;
        }catch(exception ex){}
        
        
        delete assgnRes;
        
       // delete assgnRes1;
        
        test.stopTest();
    }
}