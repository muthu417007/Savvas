@isTest()
public class ServiceAppointmentTest {
    
    @TestSetup
    private static void makeData(){
        
        Profile p = [SELECT Id FROM Profile WHERE Name =: Label.ICOM_Professional_Services];
        
        User testUser = new User(Alias = 'user', Email='newuser@testorg.com',
                                 EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                                 LocaleSidKey='en_US', ProfileId = p.Id,
                                 TimeZoneSidKey='America/Los_Angeles',Username = UserInfo.getOrganizationId() + System.now().millisecond()+'@managertest.com');
        
        insert testUser;
        
        User testUser1 = new User(Alias = 'user1', Email='newuser@testorg.com',
                                 EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                                 LocaleSidKey='en_US', ProfileId = p.Id,
                                 TimeZoneSidKey='America/Los_Angeles',Username = UserInfo.getOrganizationId() + System.now().millisecond()+'@managertest.com');
        
        insert testUser1;
        
        PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name =: Label.FSL_Consultant_Manager_Permissions];
        insert new PermissionSetAssignment(AssigneeId = testUser.id, PermissionSetId = ps.Id);
        insert new PermissionSetAssignment(AssigneeId = testUser1.id, PermissionSetId = ps.Id);
        
         // Test WorkOrder
       /* WorkOrder testWorkOrder = new WorkOrder(Subject = 'Test Work Order');
        insert testWorkOrder;
        ServiceResource sR = new ServiceResource();
        sR.Name = testUser.Name;
        sR.RelatedRecordId = testUser.Id;
        sR.Sav_FSL_Service_Resource_Type__c =System.Label.Sav_FSL_Service_resource_Type_FTE;
        sR.ResourceType = System.Label.Sav_FSL_ResourceType_T;
        sR.Sav_FSL_Primary_Role__c = System.Label.Sav_FSL_Primary_Role_CS;
        sR.Sav_FSL_Start_Date__c = system.today(); 
        sR.IsActive = true;
        insert sR;
        
         // Test ServiceAppointment
        ServiceAppointment testServiceAppointment = new ServiceAppointment(
            ParentRecordId = testWorkOrder.Id,
            //Opportunity__c = opp.Id,
            Sav_FSL_Service_Type__c = System.Label.Sav_FSL_Service_Type_Prog_Act_Paid, 
            Sav_FSL_SA_Program__c = System.Label.Sav_FSL_SA_Program_enVision_Math,Sav_FSL_Requested_Delivery_Date__c = Date.today(),
            SchedEndTime=system.now().addHours(6),
            SchedStartTime= system.now(),
            Service_Delivery_Address__c = 'Test Address', 
            Sav_FSL_Created_from_SSR_Form__c=TRUE,
            Status = 'Ready to Schedule');
        insert testServiceAppointment;
		 AssignedResource assgnRes = new AssignedResource();
        assgnRes.ServiceAppointmentId = testServiceAppointment.Id;
        assgnRes.ServiceResourceId = sR.Id;
        
        insert assgnRes;*/
        
       
    }
    
    static testMethod void testAfterInsert() {
        FSL.GlobalAPIS.addStatusTransition('Ready to Schedule', 'Scheduled');
        FSL.GlobalAPIS.addStatusTransition('Scheduled', 'Canceled');
        FSL.GlobalAPIS.addStatusTransition('Ready to Schedule', 'Canceled');
        FSL.GlobalAPIS.addStatusTransition('Scheduled', 'Proposed');
        FSL.GlobalAPIS.addStatusTransition('Proposed', 'Scheduled');
        FSL.GlobalAPIS.addStatusTransition('Proposed', 'Canceled');
        // Test Account
        Account testAccount = new Account(Name = 'Test Account', BillingCity='Arizona');
        insert testAccount;
        
        // Test WorkOrder
        WorkOrder testWorkOrder = new WorkOrder(Subject = 'Test Work Order', AccountId = testAccount.Id);
        insert testWorkOrder;
        
        
        User testUser = [SELECT Id,Name FROM User WHERE Alias = 'user'][0];
        User testUser1 = [SELECT Id,Name FROM User WHERE Alias = 'user1'][0];
        
        Opportunity opp = new Opportunity(Name = 'test Opportunity', AccountId = testAccount.Id, 
                                          StageName = 'Prospect', CloseDate = Date.today(), CurrencyIsoCode = 'USD', Opportunity_Leader__c = testUser.Id );
        insert opp;
        
        ServiceResource sR = new ServiceResource();
        sR.Name = testUser.Name;
        sR.RelatedRecordId = testUser.Id;
        sR.Sav_FSL_Service_Resource_Type__c =System.Label.Sav_FSL_Service_resource_Type_FTE;
        sR.ResourceType = System.Label.Sav_FSL_ResourceType_T;
        sR.Sav_FSL_Primary_Role__c = System.Label.Sav_FSL_Primary_Role_CS;
        sR.Sav_FSL_Start_Date__c = system.today(); 
        sR.IsActive = true;
        insert sR;
        
        ServiceResource sR1 = new ServiceResource();
        sR1.Name = testUser1.Name;
        sR1.RelatedRecordId = testUser1.Id;
        sR1.Sav_FSL_Service_Resource_Type__c = System.Label.Sav_FSL_Service_resource_Type_FTE;
        sR1.ResourceType = System.Label.Sav_FSL_ResourceType_A;
        sR1.Sav_FSL_Primary_Role__c = System.Label.Sav_FSL_Primary_Role_CS;
        sR1.Sav_FSL_Start_Date__c = system.today(); 
        sR1.IsActive = true;
        insert sR1;
        
        OperatingHours oH = new OperatingHours();
        oH.Name = System.Label.Sav_FSL_OpH_Mountain;
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
        
        
        Service_Appointment_Attributes__c saa = new Service_Appointment_Attributes__c(Work_Order__c = testWorkOrder.Id);
        insert saa;

        // Test ServiceAppointment
        ServiceAppointment testServiceAppointment = new ServiceAppointment(
            ParentRecordId = testWorkOrder.Id,
            Opportunity__c = opp.Id,
           // Sav_FSL_Service_Type__c = System.Label.Sav_FSL_Service_Type_Prog_Act_Paid, 
            Sav_FSL_SA_Program__c = System.Label.Sav_FSL_SA_Program_enVision_Math,
            Sav_FSL_Requested_Delivery_Date__c = Date.today(),
            SchedEndTime=system.now().addHours(6),
            SchedStartTime= system.now(),
            Service_Delivery_Address__c = 'Test Address', 
            Sav_FSL_Created_from_SSR_Form__c=TRUE,
            Sav_FSL_Customer_Time_Zone__c = 'Arizona',
            Sav_FSL_Service_Type__c='Sales - Presentation',
            Sav_FSL_Alternate_Date_Time3__c =system.now()+ 10,
            Sav_FSL_Alternate_DateTime1__c =system.now() + 11,
            Sav_FSL_Alternate_Date_Time2__c=system.now() + 12,
            Status = 'Ready to Schedule');
        insert testServiceAppointment;
        
        ServiceAppointment testServiceAppointment1 = new ServiceAppointment(
            ParentRecordId = testWorkOrder.Id,
            Opportunity__c = opp.Id,
           // Sav_FSL_Service_Type__c = System.Label.Sav_FSL_Service_Type_Prog_Act_Paid, 
            Sav_FSL_SA_Program__c = System.Label.Sav_FSL_SA_Program_enVision_Math,
            Sav_FSL_Requested_Delivery_Date__c = Date.today(),
            SchedEndTime=system.now().addHours(6),
            SchedStartTime= system.now(),
            Service_Delivery_Address__c = 'Test Address', 
            Sav_FSL_Created_from_SSR_Form__c=TRUE,
            Sav_FSL_Customer_Time_Zone__c = 'Arizona',
            Sav_FSL_Service_Type__c='Sales - Presentation',
            Sav_FSL_Alternate_Date_Time3__c =system.now()+ 10,
            Sav_FSL_Alternate_DateTime1__c =system.now() + 11,
            Sav_FSL_Alternate_Date_Time2__c=system.now() + 12,
            Status = System.Label.Sav_FSL_Scheduled);
        insert testServiceAppointment1;
        
        TimeSheet ts = new TimeSheet();
        ts.StartDate = system.today();
        ts.EndDate = system.today() + 1;
        ts.ServiceResourceId = sR.Id;
        ts.Service_Appointment__c = testServiceAppointment.Id;
        insert ts;
        
        AssignedResource assgnRes = new AssignedResource();
        assgnRes.ServiceAppointmentId = testServiceAppointment.Id;
        assgnRes.ServiceResourceId = sR.Id;
        
        insert assgnRes;
        
        testServiceAppointment.Status = 'Canceled';
        update testServiceAppointment; 
        
    }
    
    static testMethod void testAfterUpdate() {
        FSL.GlobalAPIS.addStatusTransition('Ready to Schedule', 'Scheduled');
        FSL.GlobalAPIS.addStatusTransition('Scheduled', 'Proposed');
        FSL.GlobalAPIS.addStatusTransition('Proposed', 'Scheduled');
       // FSL.GlobalAPIS.addStatusTransition('Scheduled', 'Canceled');
        
        // Test Account
        Account testAccount = new Account(Name = 'Test Account', BillingCity='Arizona');
        insert testAccount;
        
        // Test WorkOrder
        WorkOrder testWorkOrder = new WorkOrder(Subject = 'Test Work Order', AccountId = testAccount.Id);
        insert testWorkOrder;
        
        
        User testUser = [SELECT Id,Name FROM User WHERE Alias = 'user'];
        User testUser1 = [SELECT Id,Name FROM User WHERE Alias = 'user1'][0];
        
        Opportunity opp = new Opportunity(Name = 'test Opportunity', AccountId = testAccount.Id, 
                                          StageName = 'Prospect', CloseDate = Date.today(), CurrencyIsoCode = 'USD', Opportunity_Leader__c = testUser.Id );
        insert opp;
        
        ServiceResource sR = new ServiceResource();
        sR.Name = testUser.Name;
        sR.RelatedRecordId = testUser.Id;
        sR.Sav_FSL_Service_Resource_Type__c = System.Label.Sav_FSL_Service_resource_Type_FTE;
        sR.ResourceType = 'T';
        sR.Sav_FSL_Primary_Role__c = System.Label.Sav_FSL_Primary_Role_CS;
        sR.Sav_FSL_Start_Date__c = system.today(); 
        sR.IsActive = true;
        insert sR;
        
        ServiceResource sR1 = new ServiceResource();
        sR1.Name = testUser1.Name;
        sR1.RelatedRecordId = testUser1.Id;
        sR1.Sav_FSL_Service_Resource_Type__c = System.Label.Sav_FSL_Service_resource_Type_FTE;
        sR1.ResourceType = System.Label.Sav_FSL_ResourceType_A;
        sR1.Sav_FSL_Primary_Role__c = System.Label.Sav_FSL_Primary_Role_CS;
        sR1.Sav_FSL_Start_Date__c = system.today(); 
        sR1.IsActive = true;
        insert sR1;
        
        OperatingHours oH = new OperatingHours();
        oH.Name = System.Label.Sav_FSL_OpH_Mountain;
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
        
        
        Service_Appointment_Attributes__c saa = new Service_Appointment_Attributes__c(Work_Order__c = testWorkOrder.Id);
        insert saa;
        
        // Test ServiceAppointment
        ServiceAppointment testServiceAppointment1 = new ServiceAppointment(
            ParentRecordId = testWorkOrder.Id,
            Opportunity__c = opp.Id,
            Sav_FSL_Service_Type__c = System.Label.Sav_FSL_Service_Type_Prog_Act_Paid,
            Sav_FSL_SA_Program__c = System.Label.Sav_FSL_SA_Program_enVision_Math,Sav_FSL_Requested_Delivery_Date__c = Date.today(),
            Sav_FSL_Alternate_DateTime1__c = DateTime.now(),
            Sav_FSL_Alternate_Date_Time2__c = DateTime.now().addHours(1),
            Sav_FSL_Alternate_Date_Time3__c = DateTime.now().addHours(2),
            SchedEndTime=DateTime.now().addHours(6),
            SchedStartTime=DateTime.now(),
            Service_Delivery_Address__c = 'Test Address', 
            Sav_FSL_Created_from_SSR_Form__c=TRUE,
            Status = 'Scheduled');

        insert testServiceAppointment1;
        
              
        TimeSheet ts = new TimeSheet();
        ts.StartDate = system.today();
        ts.EndDate = system.today() + 1;
        ts.ServiceResourceId = sR.Id;
        ts.Service_Appointment__c = testServiceAppointment1.Id;
        insert ts;
        
   
        //testServiceAppointment1.SchedStartTime=DateTime.now().addHours(2);
       // testServiceAppointment1.SchedEndTime=DateTime.now().addHours(6);
       // testServiceAppointment1.SchedStartTime=DateTime.now();
       // update testServiceAppointment1; 
        AssignedResource assgnRes = new AssignedResource();
        assgnRes.ServiceAppointmentId = testServiceAppointment1.Id;
        assgnRes.ServiceResourceId = sR.Id;
        
        insert assgnRes;
       testServiceAppointment1.SchedStartTime=DateTime.now().addHours(2);
       // testServiceAppointment1.SchedEndTime=DateTime.now().addHours(6);
       // testServiceAppointment1.SchedStartTime=DateTime.now();
        update testServiceAppointment1; 
    }
        static testMethod void testAfterUpdates() {
        FSL.GlobalAPIS.addStatusTransition('Ready to Schedule', 'Scheduled');
        FSL.GlobalAPIS.addStatusTransition('Scheduled', 'Proposed');
        FSL.GlobalAPIS.addStatusTransition('Proposed', 'Scheduled');
       // FSL.GlobalAPIS.addStatusTransition('Scheduled', 'Canceled');
        
        // Test Account
        Account testAccount = new Account(Name = 'Test Account', BillingCity='Arizona');
        insert testAccount;
        
        // Test WorkOrder
        WorkOrder testWorkOrder = new WorkOrder(Subject = 'Test Work Order', AccountId = testAccount.Id);
        insert testWorkOrder;
        
        
        User testUser = [SELECT Id,Name FROM User WHERE Alias = 'user'];
        User testUser1 = [SELECT Id,Name FROM User WHERE Alias = 'user1'][0];
        
        Opportunity opp = new Opportunity(Name = 'test Opportunity', AccountId = testAccount.Id, 
                                          StageName = 'Prospect', CloseDate = Date.today(), CurrencyIsoCode = 'USD', Opportunity_Leader__c = testUser.Id );
        insert opp;
        
        ServiceResource sR = new ServiceResource();
        sR.Name = testUser.Name;
        sR.RelatedRecordId = testUser.Id;
        sR.Sav_FSL_Service_Resource_Type__c = System.Label.Sav_FSL_Service_resource_Type_FTE;
        sR.ResourceType = 'T';
        sR.Sav_FSL_Primary_Role__c = System.Label.Sav_FSL_Primary_Role_CS;
        sR.Sav_FSL_Start_Date__c = system.today(); 
        sR.IsActive = true;
        insert sR;
        
        ServiceResource sR1 = new ServiceResource();
        sR1.Name = testUser1.Name;
        sR1.RelatedRecordId = testUser1.Id;
        sR1.Sav_FSL_Service_Resource_Type__c = System.Label.Sav_FSL_Service_resource_Type_FTE;
        sR1.ResourceType = System.Label.Sav_FSL_ResourceType_A;
        sR1.Sav_FSL_Primary_Role__c = System.Label.Sav_FSL_Primary_Role_CS;
        sR1.Sav_FSL_Start_Date__c = system.today(); 
        sR1.IsActive = true;
        insert sR1;
        
        OperatingHours oH = new OperatingHours();
        oH.Name = System.Label.Sav_FSL_OpH_Mountain;
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
        
        
        Service_Appointment_Attributes__c saa = new Service_Appointment_Attributes__c(Work_Order__c = testWorkOrder.Id);
        insert saa;
        
        // Test ServiceAppointment
        ServiceAppointment testServiceAppointment1 = new ServiceAppointment(
            ParentRecordId = testWorkOrder.Id,
            Opportunity__c = opp.Id,
            Sav_FSL_Service_Type__c = System.Label.Sav_FSL_Service_Type_Prog_Act_Paid,
            Sav_FSL_SA_Program__c = System.Label.Sav_FSL_SA_Program_enVision_Math,Sav_FSL_Requested_Delivery_Date__c = Date.today(),
            Sav_FSL_Alternate_DateTime1__c = DateTime.now(),
            Sav_FSL_Alternate_Date_Time2__c = DateTime.now().addHours(1),
            Sav_FSL_Alternate_Date_Time3__c = DateTime.now().addHours(2),
            SchedEndTime=DateTime.now().addHours(6),
            SchedStartTime=DateTime.now(),
            Service_Delivery_Address__c = 'Test Address', 
            Sav_FSL_Created_from_SSR_Form__c=TRUE,
            Status = 'Scheduled');
        insert testServiceAppointment1;
        AssignedResource assgnRes = new AssignedResource();
        assgnRes.ServiceAppointmentId = testServiceAppointment1.Id;
        assgnRes.ServiceResourceId = sR.Id;
        insert assgnRes;
       testServiceAppointment1.SchedStartTime=DateTime.now().addHours(2);
        update testServiceAppointment1;
       testServiceAppointment1.Sav_FSL_Customer_Time_Zone__c='Other';
        update testServiceAppointment1; 		
    }
 
    
}