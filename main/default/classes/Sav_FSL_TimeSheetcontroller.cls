/* -----------------------------------------------------------------------------------------------------------------------
Name:        Sav_FSL_TimeSheetcontroller
Description: This is controller class for the Time Sheet entry functionality
Date         Version  Author             Summary of Changes
-----------  -------  -----------------  ------------------------------------------------------------------------------
06/11/2023     1.0     FSL Team      Initial Release
-------------------------------------------------------------------------------------------------------------------------- */
public class Sav_FSL_TimeSheetcontroller {
     /*
Method Name :fetchAccountsOptions
Parameters :searchString,selectedAccountId
Output : To get the account names on account lookup combobox
Description : If search with account name it will fetch the accounts from this method based on search

*/
    @AuraEnabled
    public static List<Account> fetchAccountsOptions(String searchString, String selectedAccountId) {
        if(selectedAccountId!=null && selectedAccountId!=''){
            return [SELECT Name, Id,Inactive_Flag__c FROM Account WHERE Id=:selectedAccountId LIMIT 1];
        }else{
            //List<String> lstIntegrationUsers = new List<String>{'Integration User','Integration User2'};
            List<String> lstIntegrationUsers = Label.FSL_TimeSheetAccountSearchExceptionOwnerUsers.split(',');
            //List<String> lstAccountTypes = new List<String>{'Catholic School', 'Diocese', 'Private School', 'Public District', 'Public School', 'State DOE', 'State School', 'Sub-District', 'School Mgmt Co'};
            List<String> lstAccountTypes = Label.FSL_TimeSheetAccountSearchIncludeedTypes.split(',');
            Integer enrollmentLimit = Integer.valueOf(Label.FSL_TimeSheetAccountSearchEnrollmentLowerLimit);
            String strActiveStatus = 'Active';
            if(searchString!=null && searchString!=''){
                //String queryString = 'SELECT Name, Id,Inactive_Flag__c FROM Account WHERE Inactive_Flag__c!=true AND NAME LIKE \'%' +String.escapeSingleQuotes(searchString)+'%\'ORDER BY Name ASC LIMIT 10';
                String queryString = 'SELECT Name, Id,Inactive_Flag__c FROM Account WHERE CreatedDate >= 2010-01-01T00:00:00.00Z AND Owner.Name Not IN :lstIntegrationUsers AND Type IN :lstAccountTypes AND Account_Status__c=:strActiveStatus AND Inactive_Flag__c!=true AND NAME LIKE \'%' +String.escapeSingleQuotes(searchString)+'%\' ORDER BY Name ASC LIMIT 10';
                return Database.query(queryString);
            }else{
                return [SELECT Name, Id,Inactive_Flag__c FROM Account WHERE CreatedDate >= 2010-01-01T00:00:00.00Z AND Owner.Name Not IN :lstIntegrationUsers AND Type IN :lstAccountTypes AND Account_Status__c=:strActiveStatus AND Inactive_Flag__c!=true ORDER BY Name ASC LIMIT 10];
            }
        }
    }
       
    /*
Method Name : getMetadata
Parameters :
Output : To get the activites category metadata records 
Description : Fetch all the metadata records that are related to activity categories

*/
    @AuraEnabled
    public static List<Sav_Activity_Category__mdt> getMetadata(){
        List<Sav_Activity_Category__mdt> metadataList = [SELECT Activity__c, Label,  Activity_Type__c, Break_During_Delivery_Of__c, Discipline__c, Id, State__c, Territory__c FROM Sav_Activity_Category__mdt where Label!=:Label.Sav_FSL_Resourced_Activity and Label!=:Label.Sav_FSL_SIM_LIVE ORDER BY Label ASC];
        if(metadataList.size()>0){
            return metadataList;
        }else{
            return null;
        }
    }
    /*
Method Name : getWOActivityType
Parameters :
Output : To get the activity- type metadata records 
Description : Fetch all the metadata records that are related to activity type
*/
    @AuraEnabled
    public static List<String> getWOActivityType(){
        List<String> lstActivityType = new List<String>();
            Sav_Activity_Category__mdt activityTypeRec = [Select MasterLabel,Activity_Type__c from Sav_Activity_Category__mdt where MasterLabel=:Label.Sav_FSL_Resourced_Activity];
            if(activityTypeRec!=null)
                lstActivityType =  activityTypeRec.Activity_Type__c.split(','); 
        return lstActivityType;
    }
     /*
Method Name : getWODisciplines
Parameters :
Output : To get the disciplines- type metadata records 
Description : Fetch all the metadata records that are related to Disciplines
*/
    @AuraEnabled
    public static List<String> getWODisciplines(){
        List<String> lstActivityDiscipline = new List<String>();
            Sav_Activity_Category__mdt activityTypeRec = [Select MasterLabel,Activity_Type__c,Discipline__c from Sav_Activity_Category__mdt where MasterLabel=:Label.Sav_FSL_Resourced_Activity];
            if(activityTypeRec!=null)
                lstActivityDiscipline =  activityTypeRec.Discipline__c.split(',');
        return lstActivityDiscipline;
    }
         /*
Method Name : getTimeSheets
Parameters :userId,weekDate,EndDt
Output : based on parameters it will bring the time sheet records
Description : Fetch the timesheet records
*/
    @AuraEnabled
    public static List<TimeSheet> getTimeSheets(String userId,String weekDate,String EndDt) {
        Date weekStDt = Date.valueOf(weekDate);
        Date weekEnDt = Date.valueOf(EndDt);
        ID serviceResourcesId = [select id,RelatedRecordId,IsActive from ServiceResource where RelatedRecordId=:userId and IsActive=true].id;
        List<TimeSheet> lstTimeSheet = new List<TimeSheet>();
        lstTimeSheet = [Select id,StartDate,EndDate,Status,Sav_FSL_activityTypeOptions__c,ServiceAppointmentSubject__c,ServiceResourceId,Sav_FSL_Discipline__c,TotalDurationInHours,Sav_FSL_IsReadOnly__c,Sav_FSL_Activity__c,Sav_FSL_State__c,Sav_FSL_Territory__c,
                        Sav_FSL_Activity_Type__c, Comments__c, Sav_FSL_WorkOrderSubject__c,Sav_FSL_Monday__c,Sav_FSL_Tuesday__c,Sav_FSL_Wednesday__c,Sav_FSL_Thursday__c,Sav_FSL_Friday__c,Sav_FSL_Saturday__c,Sav_FSL_Sunday__c,Sav_FSL_Section__c
                        from TimeSheet where StartDate>=:weekStDt and EndDate<=:weekEnDt and Sav_FSL_Section__c=:Label.Sav_FSL_SA and ServiceResourceId=:serviceResourcesId];
        if(lstTimeSheet.size()>0){
            return lstTimeSheet;
        }
        else
            return null;
    }
     /*
Method Name : createOthersTS
Parameters :userId,startDate,endDate
Output : based on parameters it will create time sheet records
Description : To create the others timesheet records
*/
    @AuraEnabled
    public static List<TimeSheet> createOthersTS(String userID, String startDate, String endDate) {
        List<TimeSheet> lstOthersTS = new List<TimeSheet>();
        Date weekStDt = Date.valueOf(startDate);
        Date weekEnDt = Date.valueOf(endDate);
        ID serviceResourceId = [select id,RelatedRecordId,IsActive from ServiceResource where RelatedRecordId=:userId and IsActive=true].id;
        try {
            TimeSheet othersTSRecord = new TimeSheet();
            othersTSRecord.Sav_FSL_Section__c = System.Label.Sav_FSL_Others;
            othersTSRecord.StartDate = weekStDt;
            othersTSRecord.EndDate = weekEnDt;
            othersTSRecord.ServiceResourceId = serviceResourceId;
           insert othersTSRecord;
             //Database.insert(othersTSRecord, false);
            
        }
        catch (exception ex) {
            system.debug('ex.message '+ex.getMessage());
            system.debug('ex.LineNumber '+ex.getLineNumber());
        }
        lstOthersTS =  [select id,Account__c,Comments__c,StartDate,EndDate,Status,ServiceAppointmentSubject__c,ServiceResourceId,Sav_FSL_Discipline__c,TotalDurationInHours,Sav_FSL_IsReadOnly__c,Sav_FSL_Activity__c,Sav_FSL_State__c,Sav_FSL_Territory__c,
                        Sav_FSL_Activity_Type__c,Sav_FSL_WorkOrderSubject__c,Sav_FSL_Monday__c,Sav_FSL_Tuesday__c,Sav_FSL_Wednesday__c,Sav_FSL_Thursday__c,Sav_FSL_Friday__c,Sav_FSL_Saturday__c,Sav_FSL_Sunday__c,Sav_FSL_Section__c,Sav_FSL_Break_During_Delivery_Of__c,Sav_FSL_activityTypeOptions__c
                        from TimeSheet where StartDate>=:weekStDt and EndDate<=:weekEnDt and Sav_FSL_Section__c=:Label.Sav_FSL_Others and ServiceResourceId=:serviceResourceId];
        return lstOthersTS;
    }
         /*
Method Name : wireTimeSheetOthers
Parameters :serviceResourceUser,startDate,endDate
Output : based on parameters it will return the list others time sheet records
Description : To fetch the others timesheet records
*/
    @AuraEnabled
    public static List<TimeSheet> wireTimeSheetOthers(String serviceResourceUser, String startDate, String endDate) {
        Date weekStDt = Date.valueOf(startDate);
        Date weekEnDt = Date.valueOf(endDate);
        List<TimeSheet> otherList = new List<TimeSheet>();
        ID serviceResourceId = [select id,RelatedRecordId,IsActive from ServiceResource where RelatedRecordId=:serviceResourceUser and IsActive=true].id;
        otherList = [select id,Account__c,Comments__c,Sav_FSL_activityTypeOptions__c,StartDate,EndDate,Status,ServiceAppointmentSubject__c,ServiceResourceId,Sav_FSL_Discipline__c,TotalDurationInHours,Sav_FSL_IsReadOnly__c,Sav_FSL_Activity__c,Sav_FSL_State__c,Sav_FSL_Territory__c,
                     Sav_FSL_Activity_Type__c, Sav_FSL_Account_Name__c, Sav_FSL_WorkOrderSubject__c,Sav_FSL_Monday__c,Sav_FSL_Tuesday__c,Sav_FSL_Wednesday__c,Sav_FSL_Thursday__c,Sav_FSL_Friday__c,Sav_FSL_Saturday__c,Sav_FSL_Sunday__c,Sav_FSL_Section__c,Sav_FSL_Break_During_Delivery_Of__c
                     from TimeSheet where StartDate>=:weekStDt and EndDate<=:weekEnDt and Sav_FSL_Section__c=:Label.Sav_FSL_Others and ServiceResourceId=:serviceResourceId];
        if(otherList.size()>0){
            return otherList;
        }
        else{
            return null;
        }
    }
             /*
Method Name : saveTimesheets
Parameters :timesheets,statusValue
Output : based on parameters it will update the time sheet records
Description : To update the timesheet records
*/
    @AuraEnabled
    public static void saveTimesheets(List<TimeSheet> timesheets,string statusValue, String startDate, String endDate, List<TimeSheetEntry> TimeSheetEntries) {
        try {
            List<Id> setTimeSheetIds = new List<Id>();
            List<TimeSheet> lstTSUpdate = new List<TimeSheet>();
            List<TimeSheetEntry> lstTimeSheetEntry = new  List<TimeSheetEntry>();
            List<TimeSheet> lstTSubmitTS = new List<TimeSheet>();
            Date weekStDt = Date.valueOf(startDate);
            Date weekEnDt = Date.valueOf(endDate);
            if(timesheets.size()>0 && !timesheets.isEmpty()){
                for(TimeSheet ts:timesheets){
                    if(ts.Status != System.Label.Sav_FSL_Submitted && ts.Status != System.Label.Sav_FSL_Approved){
                        TimeSheet tst = new TimeSheet();
                        tst.id = ts.Id;
                        if(statusValue == System.Label.Sav_FSL_save){
                            tst.Status = System.Label.Sav_FSL_Saved;
                        }
                        else{
                            tst.Status = System.Label.Sav_FSL_Submitted;
                        }
                        tst.StartDate = weekStDt;
                        tst.EndDate = weekEnDt;
                        tst.Sav_FSL_IsReadOnly__c = (tst.Status == System.Label.Sav_FSL_Submitted) ? true : false;
                        if(ts.Sav_FSL_Monday__c!=null)
                            tst.Sav_FSL_Monday__c = ts.Sav_FSL_Monday__c;
                        if(ts.Sav_FSL_Tuesday__c!=null)
                            tst.Sav_FSL_Tuesday__c = ts.Sav_FSL_Tuesday__c;  
                        if(ts.Sav_FSL_Wednesday__c!=null)
                            tst.Sav_FSL_Wednesday__c = ts.Sav_FSL_Wednesday__c;  
                        if(ts.Sav_FSL_Thursday__c!=null)
                            tst.Sav_FSL_Thursday__c = ts.Sav_FSL_Thursday__c;  
                        if(ts.Sav_FSL_Friday__c!=null)
                            tst.Sav_FSL_Friday__c = ts.Sav_FSL_Friday__c;  
                        if(ts.Sav_FSL_Saturday__c!=null)
                            tst.Sav_FSL_Saturday__c = ts.Sav_FSL_Saturday__c; 
                        if(ts.Sav_FSL_Sunday__c!=null)
                            tst.Sav_FSL_Sunday__c = ts.Sav_FSL_Sunday__c; 
                        if(ts.Sav_FSL_Activity__c!=null)
                            tst.Sav_FSL_Activity__c = ts.Sav_FSL_Activity__c; 
                        if(ts.Sav_FSL_Activity_Type__c!=null)
                            tst.Sav_FSL_Activity_Type__c = ts.Sav_FSL_Activity_Type__c; 
                        if(ts.Sav_FSL_Discipline__c!=null)
                            tst.Sav_FSL_Discipline__c = ts.Sav_FSL_Discipline__c; 
                        if(ts.Sav_FSL_State__c!=null)
                            tst.Sav_FSL_State__c = ts.Sav_FSL_State__c;
                        if(ts.Sav_FSL_Territory__c!=null)
                            tst.Sav_FSL_Territory__c = ts.Sav_FSL_Territory__c;
                        if(ts.Sav_FSL_Break_During_Delivery_Of__c!=null)
                            tst.Sav_FSL_Break_During_Delivery_Of__c = ts.Sav_FSL_Break_During_Delivery_Of__c;
                        if(ts.Sav_FSL_activityTypeOptions__c!=null)
                            tst.Sav_FSL_activityTypeOptions__c = ts.Sav_FSL_activityTypeOptions__c;
                        if(ts.Sav_FSL_Account_Name__c!=null)
                            tst.Sav_FSL_Account_Name__c = ts.Sav_FSL_Account_Name__c;
                        if(ts.Account__c!=null)
                            tst.Account__c = ts.Account__c;
                        tst.Sav_FSL_Section__c = ts.Sav_FSL_Section__c;
                        tst.Comments__c = ts.Comments__c;
                        if( tst.Status == System.Label.Sav_FSL_Submitted){
                            setTimeSheetIds.add(tst.id);
                            lstTSubmitTS.add(tst);
                        }
                        lstTSUpdate.add(tst);
                    }
                }
                if(lstTSUpdate.size()>0 && !lstTSUpdate.isEMPTY()){
                    update lstTSUpdate;
                }
                if(TimeSheetEntries.isEMPTY()){
                    submitForApproval(setTimeSheetIds);
                }
            }
        } catch (Exception ex) {
            system.debug('Error saving timesheets: ' + ex.getMessage());
        }
    }
/*
Method Name : submitForApproval
Parameters :recordIds
Output : based on parameters it will create the approval process history records for submitted time sheet records
Description : To create the approval process history timesheet records
*/
    @AuraEnabled
    public static void submitForApproval(List<Id> recordIds) {
        List<Approval.ProcessSubmitRequest> requests = new List<Approval.ProcessSubmitRequest>();
        for (Id recordId : recordIds) {
                Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
                req.setObjectId(recordId);
                req.setComments(System.Label.Sav_FSL_Time_Sheet_Submitted);
                req.setProcessDefinitionNameOrId(System.Label.Sav_FSL_Timesheet);
                requests.add(req);
        }
        List<Approval.ProcessResult> results = Approval.process(requests);
    }
/*
Method Name : saveTimesheetEntries
Parameters :TimeSheetEntries
Output : based on parameters it will create the TimeSheetEntry sheet records
Description : To create the TimeSheetEntry records
*/
    @AuraEnabled
    public static void saveTimesheetEntries (List<TimeSheetEntry> TimeSheetEntries) {
        try {
            system.debug('TimeSheetEntries '+TimeSheetEntries);
            List<TimeSheetEntry> lstTSEInsert= new List<TimeSheetEntry>();
            List<TimeSheetEntry> exisitingTSEUpdate= new List<TimeSheetEntry>();
            Set<Id> timesheetid = new Set<Id>();
            List<decimal> dayhours = new List<decimal>();
            List<datetime> starttime = new List<datetime>();
            List<ID> submittedTSApprovalProcess= new List<ID>();
            if(TimeSheetEntries.size()>0 && !TimeSheetEntries.isEmpty()){
                for(TimeSheetEntry tse:TimeSheetEntries){
                    timesheetid.add(tse.TimeSheetId);
                    dayhours.add(tse.Sav_Duration__c);
                    starttime.add(tse.StartTime);
                }
            }
            List<TimeSheetEntry> lstTimeSheetEntry = [Select id,TimeSheetId,Sav_Duration__c,StartTime
                                                      from TimeSheetEntry where TimeSheetId=:TimeSheetId];
      
          
            if (lstTimeSheetEntry.isEmpty()) {
                for(TimeSheetEntry tsentry:TimeSheetEntries){
                    if(tsentry.Sav_Duration__c!=null){
                        TimeSheetEntry tse = new TimeSheetEntry();
                        tse.TimeSheetId = tsentry.TimeSheetId;
                        tse.Sav_Duration__c = tsentry.Sav_Duration__c;
                        tse.StartTime = tsentry.StartTime;
                        lstTSEInsert.add(tse);
                    }
                }
            }
            Set<Id> timeSheetIdsInRecords = new Set<Id>();
            if (lstTimeSheetEntry != null && !lstTimeSheetEntry.isEmpty()){
                for(TimeSheetEntry tsentry:lstTimeSheetEntry){
                    timeSheetIdsInRecords.add(tsentry.TimeSheetId);
                }
            }
            if (lstTimeSheetEntry != null && !lstTimeSheetEntry.isEmpty()){
                for (Id timeSheetIds : timesheetid) {
                    if (!timeSheetIdsInRecords.contains(timeSheetIds)) {
                        for(TimeSheetEntry tsentry:TimeSheetEntries){
                            if(tsentry.TimeSheetId == timeSheetIds && tsentry.Sav_Duration__c!=null){
                                TimeSheetEntry tse = new TimeSheetEntry();
                                tse.TimeSheetId = tsentry.TimeSheetId;
                                tse.Sav_Duration__c = tsentry.Sav_Duration__c;
                                tse.StartTime = tsentry.StartTime;
                                lstTSEInsert.add(tse);
                            }
                        }
                    }
                }
            }
            if (!lstTimeSheetEntry.isEmpty()) {
                for (TimeSheetEntry uitse:TimeSheetEntries) {
                    Boolean foundMatchingRecord = false;
                    for (TimeSheetEntry tse:lstTimeSheetEntry){
                        if (tse.TimeSheetId == uitse.TimeSheetId && tse.Sav_Duration__c!=uitse.Sav_Duration__c && tse.StartTime == uitse.StartTime) {
                            tse.Sav_Duration__c = uitse.Sav_Duration__c;
                            exisitingTSEUpdate.add(tse);
                        }
                        if (tse.StartTime == uitse.StartTime && tse.TimeSheetId == uitse.TimeSheetId) {
                            foundMatchingRecord = true;
                        }
                    }
                    if (!foundMatchingRecord) {
                        TimeSheetEntry tse = new TimeSheetEntry();
                        tse.TimeSheetId = uitse.TimeSheetId;
                        tse.Sav_Duration__c = uitse.Sav_Duration__c;
                        tse.StartTime = uitse.StartTime;
                        lstTSEInsert.add(tse);
                    }
                }
            }
            if (lstTSEInsert.size()>0) {
                insert lstTSEInsert;
               // list<Database.SaveResult> list_tse_insert = Database.insert(lstTSEInsert, false);
            }
            if (exisitingTSEUpdate.size()>0) {
                update exisitingTSEUpdate;
               //list<Database.SaveResult> existing_tse_update = Database.update(exisitingTSEUpdate, false);
            }
            //
           List<Timesheet> submitTSRecords = [select id,Status from Timesheet where id=:TimeSheetId and status='Submitted'];
            system.debug('submitTSRecords<> '+submitTSRecords);
            if(!submitTSRecords.isEmpty()){
                for(Timesheet submitTS:submitTSRecords){
                    submittedTSApprovalProcess.add(submitTS.id);
                }
                // To Call Approval Process
                submitForApproval(submittedTSApprovalProcess);
                
            } 
            
        }
        catch (Exception ex) {
            system.debug('Error saving TimeSheetEntries: ' + ex.getMessage() + ex.getLineNumber());
        }
    }
/*
Method Name : getUserId
Parameters :
Output : to get the logged in user Id
Description : to get the logged in user Id
*/
    @AuraEnabled(cacheable=true)
    public static Id getUserId() {
        return UserInfo.getUserId();
    }
/*
Method Name : deleteTimeSheet
Parameters :userID,startDate,endDate,rowId
Output : to delete the time sheet records 
Description : to delete the time sheet records based on Id
*/
    @AuraEnabled
    public static List<TimeSheet> deleteTimeSheet(String userID, String startDate, String endDate,String rowId) {
        List<TimeSheet> lstOthersTS = new List<TimeSheet>();
        try {
            Date weekStDt = Date.valueOf(startDate);
            Date weekEnDt = Date.valueOf(endDate);
            ID serviceResourceId = [select id,RelatedRecordId,IsActive from ServiceResource where RelatedRecordId=:userID and IsActive=true].id;
            timesheet timesheetdelete = [SELECT Id FROM timesheet WHERE Id = :rowId];
            delete timesheetdelete;
           // Database.DeleteResult timesheet_delete = Database.delete(timesheetdelete, false);
            lstOthersTS =  [select id,Comments__c,Account__c,StartDate,EndDate,Status,ServiceAppointmentSubject__c,ServiceResourceId,Sav_FSL_Discipline__c,TotalDurationInHours,Sav_FSL_IsReadOnly__c,Sav_FSL_Activity__c,Sav_FSL_State__c,Sav_FSL_Territory__c,
                            Sav_FSL_Activity_Type__c,Sav_FSL_WorkOrderSubject__c,Sav_FSL_Monday__c,Sav_FSL_Tuesday__c,Sav_FSL_Wednesday__c,Sav_FSL_Thursday__c,Sav_FSL_Friday__c,Sav_FSL_Saturday__c,Sav_FSL_Sunday__c,Sav_FSL_Section__c,Sav_FSL_Break_During_Delivery_Of__c,Sav_FSL_activityTypeOptions__c
                            from TimeSheet where StartDate>=:weekStDt and EndDate<=:weekEnDt and Sav_FSL_Section__c=:Label.Sav_FSL_Others and ServiceResourceId=:serviceResourceId];  
        } catch (Exception ex) {
            system.debug('Delete TS Record Method '+ ex.getMessage() + ex.getLineNumber());
        }
        if(!lstOthersTS.isempty() && lstOthersTS.size()>0 )
            return lstOthersTS;
        else return null;
    }
}