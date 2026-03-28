@isTest
public class Sav_FSL_TimeSheetcontroller_Test {
    @TestSetup
    private static void makeData(){
        Profile p = [SELECT Id FROM Profile WHERE Name =: Label.ICOM_Professional_Services];
        
        User testUser = new User(Alias = 'newUser', Email='newuser@testorg.com',
                                 EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                                 LocaleSidKey='en_US', ProfileId = p.Id,
                                 TimeZoneSidKey='America/Los_Angeles', Username = UserInfo.getOrganizationId() + System.now().millisecond()+'@test.com');
        insert testUser;
        
        
        PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name =: Label.FSL_Consultant_Manager_Permissions];
        insert new PermissionSetAssignment(AssigneeId = testUser.id, PermissionSetId = ps.Id);
        
    }
    static testMethod void controllermethod1() {
        User testUser = [SELECT Id,Name FROM User WHERE Alias = 'newUser'];
        System.runAs(new user (ID=userinfo.getUserId())){
            Account acc = new Account(Name='test acc',billingcity = 'New York', OwnerId =testUser.Id);
            insert acc;
            
            ServiceResource sR = new ServiceResource();
            sR.Name = System.Label.Sav_FSL_SR_Test_Resource;
            sR.RelatedRecordId = testUser.Id;
            sR.Sav_FSL_Service_Resource_Type__c = System.Label.Sav_FSL_Service_resource_Type_FTE;
            sR.ResourceType = System.Label.Sav_FSL_ResourceType_T;
            sR.Sav_FSL_Primary_Role__c = System.Label.Sav_FSL_Primary_Role_CS;
            sR.Sav_FSL_Start_Date__c = system.today(); 
            sR.IsActive = true;
            insert sR;
            
            
            string emptyName = '';
            string testName = 'RandomAccount';
            string Accname =  acc.Name;
            string accId = acc.Id;
            string nullId;
            Sav_FSL_TimeSheetcontroller.fetchAccountsOptions(Accname, accId);
            Sav_FSL_TimeSheetcontroller.fetchAccountsOptions(emptyName, nullId);
            Sav_FSL_TimeSheetcontroller.fetchAccountsOptions(testName, accId);
            Sav_FSL_TimeSheetcontroller.fetchAccountsOptions(Accname, nullId);
            Sav_FSL_TimeSheetcontroller.getMetadata();
            
            Sav_FSL_TimeSheetcontroller.getWOActivityType();
            
            Sav_FSL_TimeSheetcontroller.getWODisciplines();
            
            TimeSheet ts = new TimeSheet();
            ts.StartDate = system.today();
            ts.EndDate = system.today();
            ts.ServiceResourceId = sR.Id;
            ts.Status = 'Saved';
            insert ts;
            
            List<TimeSheet> tsLst = new List<TimeSheet>();
            tsLst = [Select id FROM TimeSheet where ServiceResourceId=:sR.Id];
            
            List<Id> tsIdLst = new List<Id>();
            tsIdLst.add(ts.Id);
            
            string statusValue = 'save';
            string userId = string.valueOf(testUser.Id);
            string strDate = string.valueOf(ts.StartDate);
            string endDate = string.valueOf(ts.EndDate);
            string recId = string.valueOf(ts.Id);
            
            Sav_FSL_TimeSheetcontroller.getTimeSheets(userId, strDate, endDate);
            
            Sav_FSL_TimeSheetcontroller.createOthersTS(userId, strDate, endDate);
            
            Sav_FSL_TimeSheetcontroller.wireTimeSheetOthers(userId, strDate, endDate);
            
            TimeSheetEntry tse = new TimeSheetEntry();
            tse.TimeSheetId = ts.Id;
            tse.StartTime = system.now();
            tse.EndTime = system.now() +1 ;
            insert tse;
            
            List<TimeSheetEntry> tseLst = new List<TimeSheetEntry>();
            tseLst = [Select Id, TimeSheetId from TimeSheetEntry where TimeSheetId = :ts.Id];
            
            Sav_FSL_TimeSheetcontroller.saveTimesheetEntries(tseLst);
            
            Sav_FSL_TimeSheetcontroller.saveTimesheets(tsLst, statusValue, strDate, endDate,null);
            
            Sav_FSL_TimeSheetcontroller.getUserId();
            
            Sav_FSL_TimeSheetcontroller.deleteTimeSheet(userId, strDate, endDate, recId);
        }
    }
    static testMethod void saveTimesheets() {
        List<TimeSheet> lstTimeSheets = new List<TimeSheet>();
        User testUser = [SELECT Id,Name FROM User WHERE Alias = 'newUser'];
        System.runAs(new user (ID=userinfo.getUserId())){
            Account acc = new Account(Name='test acc',billingcity = 'New York', OwnerId =testUser.Id);
            insert acc;
            
            ServiceResource sR = new ServiceResource();
            sR.Name = 'Test Resource';
            sR.RelatedRecordId = testUser.Id;
            sR.Sav_FSL_Service_Resource_Type__c = System.Label.Sav_FSL_Service_resource_Type_FTE;
            sR.ResourceType = System.Label.Sav_FSL_ResourceType_T;
            sR.Sav_FSL_Primary_Role__c = System.Label.Sav_FSL_Primary_Role_CS;
            sR.Sav_FSL_Start_Date__c = system.today(); 
            sR.IsActive = true;
            insert sR;
            
            TimeSheet ts = new TimeSheet();
            ts.StartDate = date.today();
            ts.Enddate = date.today();
            ts.Status = 'New';
            ts.Sav_FSL_Sunday__c='2';
            ts.Sav_FSL_Monday__c = '2';
            ts.Sav_FSL_Tuesday__c= '2';
            ts.Sav_FSL_Wednesday__c= '2';
            ts.Sav_FSL_Thursday__c= '2';
            ts.Sav_FSL_Friday__c= '2';
            ts.Sav_FSL_Saturday__c= '2';
            ts.ServiceResourceId = sR.Id;
            ts.Account__c = acc.Id;
            ts.Comments__c = 'test';
            ts.Sav_FSL_Activity__c = 'ADMIN';
            ts.Sav_FSL_Activity_Type__c = 'Admin';
            ts.Sav_FSL_Discipline__c = 'COP';
            ts.Sav_FSL_State__c = 'COP';
            ts.Sav_FSL_Territory__c = 'COP';
            ts.Sav_FSL_Break_During_Delivery_Of__c = 'COP';
            ts.Sav_FSL_Account_Name__c = acc.id;
            ts.Sav_FSL_activityTypeOptions__c = 'Admin';
            insert ts;
            lstTimeSheets.add(ts);
            string strDate = string.valueOf(ts.StartDate);
            string endDate = string.valueOf(ts.EndDate);
            Test.startTest();
            Sav_FSL_TimeSheetcontroller.saveTimesheets(lstTimeSheets, 'submit', strDate,endDate,null);
            Test.stopTest();
        }
    }
    static testMethod void saveTimesheetEntries() {
        List<TimeSheet> lstTimeSheets = new List<TimeSheet>();
        User testUser = [SELECT Id,Name FROM User WHERE Alias = 'newUser'];
        System.runAs(new user (ID=userinfo.getUserId())){
            Account acc = new Account(Name='test acc',billingcity = 'New York', OwnerId =testUser.Id);
            insert acc;
            
            ServiceResource sR = new ServiceResource();
            sR.Name = 'Test Resource';
            sR.RelatedRecordId = testUser.Id;
            sR.Sav_FSL_Service_Resource_Type__c = System.Label.Sav_FSL_Service_resource_Type_FTE;
            sR.ResourceType = System.Label.Sav_FSL_ResourceType_T;
            sR.Sav_FSL_Primary_Role__c =  System.Label.Sav_FSL_Primary_Role_CS;
            sR.Sav_FSL_Start_Date__c = system.today(); 
            sR.IsActive = true;
            insert sR;
            
            TimeSheet ts = new TimeSheet();
            ts.StartDate = date.today();
            ts.Enddate = date.today();
            ts.Status = 'New';
            ts.Sav_FSL_Sunday__c='2';
            ts.Sav_FSL_Monday__c = '2';
            ts.Sav_FSL_Tuesday__c= '2';
            ts.Sav_FSL_Wednesday__c= '2';
            ts.Sav_FSL_Thursday__c= '2';
            ts.Sav_FSL_Friday__c= '2';
            ts.Sav_FSL_Saturday__c= '2';
            ts.ServiceResourceId = sR.Id;
            ts.Account__c = acc.Id;
            ts.Comments__c = 'test';
            ts.Sav_FSL_Activity__c = 'ADMIN';
            ts.Sav_FSL_Activity_Type__c = 'Admin';
            ts.Sav_FSL_Discipline__c = 'COP';
            ts.Sav_FSL_State__c = 'COP';
            ts.Sav_FSL_Territory__c = 'COP';
            ts.Sav_FSL_Break_During_Delivery_Of__c = 'COP';
            ts.Sav_FSL_Account_Name__c = acc.id;
            ts.Sav_FSL_activityTypeOptions__c = 'Admin';
            insert ts;
            lstTimeSheets.add(ts);
            List<TimeSheetEntry> lstTimesheetEntry = new List<TimeSheetEntry>();
            TimeSheetEntry tse = new TimeSheetEntry();
            tse.TimeSheetId = ts.Id;
            tse.Sav_Duration__c = 2;
            tse.StartTime = system.now();
            //insert tse;
            lstTimesheetEntry.add(tse);   
            Test.startTest();
            Sav_FSL_TimeSheetcontroller.saveTimesheetEntries(lstTimesheetEntry);
            Test.stopTest();
        }
    }
    static testMethod void saveTimesheetEntriesOne() {
        List<TimeSheet> lstTimeSheets = new List<TimeSheet>();
        User testUser = [SELECT Id,Name FROM User WHERE Alias = 'newUser'];
        System.runAs(new user (ID=userinfo.getUserId())){
            Account acc = new Account(Name='test acc',billingcity = 'New York', OwnerId =testUser.Id);
            insert acc;
            
            ServiceResource sR = new ServiceResource();
            sR.Name = 'Test Resource';
            sR.RelatedRecordId = testUser.Id;
            sR.Sav_FSL_Service_Resource_Type__c = System.Label.Sav_FSL_Service_resource_Type_FTE;
            sR.ResourceType = System.Label.Sav_FSL_ResourceType_T;
            sR.Sav_FSL_Primary_Role__c =  System.Label.Sav_FSL_Primary_Role_CS;
            sR.Sav_FSL_Start_Date__c = system.today(); 
            sR.IsActive = true;
            insert sR;
            List<ID> lstTS = new List<ID>();
            TimeSheet ts = new TimeSheet();
            ts.ServiceResourceId = sR.id;
            ts.StartDate = date.today();
            ts.Enddate = date.today();
            ts.Status = 'New';
            ts.Sav_FSL_Sunday__c='2';
            insert ts;
            lstTS.add(ts.id);
            // ts.Sav_FSL_Sunday__c='2';
            //  update ts;
            lstTimeSheets.add(ts);
            List<TimeSheetEntry> lstTimesheetEntry = new List<TimeSheetEntry>();
            TimeSheetEntry tse = new TimeSheetEntry();
            tse.TimeSheetId = ts.Id;
            tse.Sav_Duration__c = 2;
            tse.StartTime = system.now();
            insert tse;
            TimeSheetEntry tses = new TimeSheetEntry();
            tses.TimeSheetId = ts.Id;
            tses.Sav_Duration__c = 4;
            tses.StartTime = datetime.now().addDays(-2);
            insert tses;
            tses.Sav_Duration__c = 8.0;
            //  update tses;
            
            // lstTimesheetEntry.add(tse);   
            
            List<TimeSheetEntry> lstTimeSheetEntry1 = [Select id,TimeSheetId,Sav_Duration__c,StartTime from TimeSheetEntry where TimeSheetId=:ts.id];
            tses.Sav_Duration__c = 8.0;
            // update tses;                                           
            lstTimesheetEntry.add(tses); 
            Test.startTest();
            Sav_FSL_TimeSheetcontroller.saveTimesheetEntries(lstTimesheetEntry);
            Test.stopTest();
        }
    }  
}