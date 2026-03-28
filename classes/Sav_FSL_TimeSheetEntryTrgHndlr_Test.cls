@isTest
public class Sav_FSL_TimeSheetEntryTrgHndlr_Test {
    public static testmethod void testmethodBeforeInsertTE() {
        List<TimeSheetEntry> lstTimeSheetEntry = new List<TimeSheetEntry>();
        ServiceResource serviceResourceRec = new ServiceResource();
        serviceResourceRec.IsActive = true;
        serviceResourceRec.Name = 'TestUser';
        serviceResourceRec.RelatedRecordId = UserInfo.getUserId();
        insert serviceResourceRec;
        
        TimeSheet timesheetRec = new TimeSheet();
        timesheetRec.StartDate = date.today();
        timesheetRec.EndDate = date.today();
        timesheetRec.ServiceResourceId = serviceResourceRec.Id;
        insert timesheetRec;
        TimeSheetEntry timeSheetEntry = new TimeSheetEntry();
        timeSheetEntry.TimeSheetId = timesheetRec.Id;
        timeSheetEntry.StartTime = date.today();
        timeSheetEntry.EndTime = date.today();
        timeSheetEntry.Sav_Duration__c = 2.25;
        insert timeSheetEntry;
        lstTimeSheetEntry.add(timeSheetEntry);
        Test.startTest();
        Sav_FSL_TimeSheetEntryTriggerHandler.beforeInsert(lstTimeSheetEntry);
        Test.stopTest();
        
        
        
    } 
     public static testmethod void testmethodToBeforeInsertTE() {
        List<TimeSheetEntry> lstTimeSheetEntry = new List<TimeSheetEntry>();
        ServiceResource serviceResourceRec = new ServiceResource();
        serviceResourceRec.IsActive = true;
        serviceResourceRec.Name = 'TestUser';
        serviceResourceRec.RelatedRecordId = UserInfo.getUserId();
        insert serviceResourceRec;
        
        TimeSheet timesheetRec = new TimeSheet();
        timesheetRec.StartDate = date.today();
        timesheetRec.EndDate = date.today();
        timesheetRec.ServiceResourceId = serviceResourceRec.Id;
        insert timesheetRec;
        TimeSheetEntry timeSheetEntry = new TimeSheetEntry();
        timeSheetEntry.TimeSheetId = timesheetRec.Id;
        timeSheetEntry.StartTime = date.today();
        timeSheetEntry.EndTime = date.today();
        timeSheetEntry.Sav_Duration__c = 2.75;
        insert timeSheetEntry;
        lstTimeSheetEntry.add(timeSheetEntry);
        Test.startTest();
        Sav_FSL_TimeSheetEntryTriggerHandler.beforeInsert(lstTimeSheetEntry);
        Test.stopTest();
    }
 public static testmethod void testmethodNegativeBeforeInsertTE() {
        List<TimeSheetEntry> lstTimeSheetEntry = new List<TimeSheetEntry>();
        ServiceResource serviceResourceRec = new ServiceResource();
        serviceResourceRec.IsActive = true;
        serviceResourceRec.Name = 'TestUser';
        serviceResourceRec.RelatedRecordId = UserInfo.getUserId();
        insert serviceResourceRec;
        
        TimeSheet timesheetRec = new TimeSheet();
        timesheetRec.StartDate = date.today();
        timesheetRec.EndDate = date.today();
        timesheetRec.ServiceResourceId = serviceResourceRec.Id;
        insert timesheetRec;
        TimeSheetEntry timeSheetEntry = new TimeSheetEntry();
        timeSheetEntry.TimeSheetId = timesheetRec.Id;
        timeSheetEntry.StartTime = date.today();
        timeSheetEntry.EndTime = date.today();
        timeSheetEntry.Sav_Duration__c = 2.50;
        insert timeSheetEntry;
        lstTimeSheetEntry.add(timeSheetEntry);
        Test.startTest();
        Sav_FSL_TimeSheetEntryTriggerHandler.beforeInsert(lstTimeSheetEntry);
        Test.stopTest();
    }    
}