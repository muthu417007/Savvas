@istest
public class ManagerTimesheetController_Test {
   
    @TestSetup
    static void setUpData(){
        Profile p = [SELECT Id FROM Profile WHERE Name =: Label.ICOM_Professional_Services];
        
        User testUser = new User(Alias = 'newUser', Email='newuser@testorg.com',
                                 EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                                 LocaleSidKey='en_US', ProfileId = p.Id,
                                 TimeZoneSidKey='America/Los_Angeles',Username = UserInfo.getOrganizationId() + System.now().millisecond()+'@test.com');
        User userManager = new User(Alias = 'user', Email='newuser@testorg.com',
                                 EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                                 LocaleSidKey='en_US', ProfileId = p.Id,
                                 TimeZoneSidKey='America/Los_Angeles',Username = UserInfo.getOrganizationId() + System.now().millisecond()+'@managertest.com');
        
        insert testUser;
        insert userManager;
        User currentUser = [SELECT id FROM User WHERE Id = :UserInfo.getUserId()];
        
        testUser.ManagerId = userManager.Id;
        update testUser;
        
        PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name =: Label.FSL_Consultant_Permissions];
        insert new PermissionSetAssignment(AssigneeId = testUser.id, PermissionSetId = ps.Id);
        PermissionSet ps1 = [SELECT Id FROM PermissionSet WHERE Name =: Label.FSL_Consultant_Manager_Permissions];
        insert new PermissionSetAssignment(AssigneeId = userManager.id, PermissionSetId = ps1.Id);
        System.runAs(currentUser){
            ServiceResource sR = new ServiceResource();
            sR.Name = 'Test Resource';
            sR.RelatedRecordId = testUser.Id;
            sR.Sav_FSL_Service_Resource_Type__c = System.Label.Sav_FSL_Service_resource_Type_FTE;
            sR.ResourceType = System.Label.Sav_FSL_ResourceType_T;
            sR.Sav_FSL_Primary_Role__c = System.Label.Sav_FSL_Primary_Role_CS;
            sR.Sav_FSL_Start_Date__c = system.today(); 
            sR.IsActive = true;
            insert sR;
            Account acc = new Account(Name='test acc',billingcity = 'New York', OwnerId =testUser.Id);
            insert acc;
            TimeSheet timeSheetRecord = new TimeSheet();
            timeSheetRecord.StartDate = system.today();
            timeSheetRecord.EndDate = system.today();
            timeSheetRecord.ServiceResourceId = sR.Id;
            timeSheetRecord.Status = System.Label.Sav_FSL_timesheet_status_submitted;
            insert timeSheetRecord;
            
            
        }
    }
    
     @istest
    public static void retrieveTimesheetRecordsNoRecords(){
        String serviceResource = [SELECT Id FROM ServiceResource][0].Id; 
        ManagerTimesheetController.retrieveTimesheetRecords();
        ManagerTimesheetController.getServiceResourceUser(serviceResource);     
    }
    @istest
    public static void retrieveTimesheetNoRecords(){
        String serviceResource = [SELECT Id FROM ServiceResource][0].Id; 
        TimeSheet timeSheetRecord = new TimeSheet();
        timeSheetRecord.StartDate = system.today();
        timeSheetRecord.EndDate = system.today();
        timeSheetRecord.ServiceResourceId = serviceResource;
        timeSheetRecord.Status = System.Label.Sav_FSL_timesheet_status_submitted;
        insert timeSheetRecord;
        timeSheetRecord.status = 'New';
        update timeSheetRecord;
        ManagerTimesheetController.retrieveTimesheetRecords();
    }
    
    @istest
    public static void retrieveTimesheetRecords(){
        User userForTimesheets = [SELECT Id FROM User where Alias = 'newUser'][0];
        User managerUser = [SELECT Id FROM User where Alias = 'user'][0];
        String serviceResource = [SELECT Id FROM ServiceResource][0].Id; 
           
        TimeSheet timeSheetRecord = new TimeSheet();
        timeSheetRecord.StartDate = system.today();
        timeSheetRecord.EndDate = system.today();
        timeSheetRecord.ServiceResourceId = serviceResource;
        timeSheetRecord.Status = System.Label.Sav_FSL_timesheet_status_submitted;
        insert timeSheetRecord;
        ManagerTimesheetController.TimesheetWrapper tw = new ManagerTimesheetController.TimesheetWrapper();
        System.runAs(managerUser){
            Test.startTest();
            tw = ManagerTimesheetController.retrieveTimesheetRecords();
            String resourceUser = ManagerTimesheetController.getServiceResourceUser(serviceResource);
            Test.stopTest();
        }   
    }
    
    @istest
    public static void approveTimesheet(){
        User userForTimesheets = [SELECT Id, ManagerId FROM User where Alias = 'newUser'][0];
        String serviceResource = [SELECT Id FROM ServiceResource][0].Id; 
        List<string> tsids = new List<string>();
        System.runAs(userForTimesheets){
            TimeSheet timeSheetRecord = new TimeSheet();
            timeSheetRecord.StartDate = system.today();
            timeSheetRecord.EndDate = system.today();
            timeSheetRecord.ServiceResourceId = serviceResource;
            timeSheetRecord.Status = System.Label.Sav_FSL_timesheet_status_submitted;
            insert timeSheetRecord;
           
            tsids.add(timeSheetRecord.Id);
             // Create an approval request for the account
            Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
            req1.setComments('Submitting request for approval.');
            req1.setObjectId(timeSheetRecord.id);
            // Submit on behalf of a specific submitter
            req1.setSubmitterId(userForTimesheets.Id);
            req1.setNextApproverIds(new Id[] {userForTimesheets.ManagerId});  
            // Submit the record to specific process and skip the criteria evaluation
            req1.setSkipEntryCriteria(true);
                // Submit the approval request for the account
                Approval.ProcessResult result = Approval.process(req1);
                // Verify the result
            System.assert(result.isSuccess());}
            test.startTest();
            boolean status =  ManagerTimesheetController.approveTimesheet(tsids);
            test.stopTest();
    }
    @istest
    public static void approveTimesheet2(){
        User userForTimesheets = [SELECT Id, ManagerId FROM User where Alias = 'newUser'][0];
        String serviceResource = [SELECT Id FROM ServiceResource][0].Id; 
        List<string> tsids = new List<string>();
        System.runAs(userForTimesheets){
            TimeSheet timeSheetRecord = new TimeSheet();
            timeSheetRecord.StartDate = system.today();
            timeSheetRecord.EndDate = system.today();
            timeSheetRecord.ServiceResourceId = serviceResource;
            timeSheetRecord.Status = System.Label.Sav_FSL_timesheet_status_submitted;
            insert timeSheetRecord;
            tsids.add(timeSheetRecord.Id);
             // Create an approval request for the account
            Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
            req1.setComments('Submitting request for approval.');
            req1.setObjectId(timeSheetRecord.id);
            // Submit on behalf of a specific submitter
            req1.setSubmitterId(userForTimesheets.Id);
            req1.setNextApproverIds(new Id[] {userForTimesheets.ManagerId});  
            // Submit the record to specific process and skip the criteria evaluation
            req1.setSkipEntryCriteria(true);
                // Submit the approval request for the account
            Approval.ProcessResult result = Approval.process(req1);
            // Verify the result
            System.assert(result.isSuccess());}
            test.startTest();
            boolean status =  ManagerTimesheetController.approveTimesheet(tsids);
            List<String> nulllst = new List<string>();
        	boolean status2 =  ManagerTimesheetController.approveTimesheet(nulllst);
            test.stopTest();

    }
    
    @istest
    public static void rejectTimesheet(){
        User userForTimesheets = [SELECT Id, ManagerId FROM User where Alias = 'newUser'][0];
        String serviceResource = [SELECT Id FROM ServiceResource][0].Id; 
        List<string> tsids = new List<string>();
        System.runAs(userForTimesheets){
            TimeSheet timeSheetRecord = new TimeSheet();
            timeSheetRecord.StartDate = system.today();
            timeSheetRecord.EndDate = system.today();
            timeSheetRecord.ServiceResourceId = serviceResource;
            timeSheetRecord.Status = System.Label.Sav_FSL_timesheet_status_submitted;
            insert timeSheetRecord;
            
            tsids.add(timeSheetRecord.Id);
             // Create an approval request for the account
            Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
            req1.setComments('Submitting request for approval.');
            req1.setObjectId(timeSheetRecord.id);
            // Submit on behalf of a specific submitter
            req1.setSubmitterId(userForTimesheets.Id);
            req1.setNextApproverIds(new Id[] {userForTimesheets.ManagerId});  
            // Submit the record to specific process and skip the criteria evaluation
            req1.setSkipEntryCriteria(true);
                // Submit the approval request for the account
            Approval.ProcessResult result = Approval.process(req1);
            // Verify the result
            System.assert(result.isSuccess());}
            test.startTest();
            boolean status =  ManagerTimesheetController.rejectTimesheet(tsids, 'test rejection');
            test.stopTest();
        
        
    }
    @istest
    public static void rejectTimesheet2(){
        User userForTimesheets = [SELECT Id, ManagerId FROM User where Alias = 'newUser'][0];
        String serviceResource = [SELECT Id FROM ServiceResource][0].Id; 
        List<string> tsids = new List<string>();
        System.runAs(userForTimesheets){
            TimeSheet timeSheetRecord = new TimeSheet();
            timeSheetRecord.StartDate = system.today();
            timeSheetRecord.EndDate = system.today();
            timeSheetRecord.ServiceResourceId = serviceResource;
            timeSheetRecord.Status = System.Label.Sav_FSL_timesheet_status_submitted;
            timeSheetRecord.Sav_FSL_Manager_Rejection_Comments__c='test rejection';
            insert timeSheetRecord;
            
            tsids.add(timeSheetRecord.Id);
             // Create an approval request for the account
            Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
            req1.setComments('Submitting request for approval.');
            req1.setObjectId(timeSheetRecord.id);
            // Submit on behalf of a specific submitter
            req1.setSubmitterId(userForTimesheets.Id);
            req1.setNextApproverIds(new Id[] {userForTimesheets.ManagerId});  
            // Submit the record to specific process and skip the criteria evaluation
            req1.setSkipEntryCriteria(true);
                // Submit the approval request for the account
            Approval.ProcessResult result = Approval.process(req1);
            // Verify the result
            System.assert(result.isSuccess());}
            test.startTest();
            boolean status =  ManagerTimesheetController.rejectTimesheet(tsids, 'test rejection');
            List<String> nulllst = new List<string>();
        	boolean status2 =  ManagerTimesheetController.rejectTimesheet(nulllst,'test');
            test.stopTest();
        
    }
}