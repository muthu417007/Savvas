public class ManagerTimesheetController {
    public class TimesheetWrapper{
        @AuraEnabled public List<TimeSheet> timesheetList;
        @AuraEnabled public String message;
        @AuraEnabled public String userName;
    } 
    
    /*
Method Name :retrieveTimesheetRecords
Parameters :None
Output : To return the account records
Description : 

*/
    @AuraEnabled
    public static TimesheetWrapper retrieveTimesheetRecords(){
        TimesheetWrapper tw = new TimesheetWrapper();
        
        String queryString =    'SELECT TimeSheetNumber, Comments__c,ServiceResource.Name, ServiceResourceId, Sav_FSL_Activity__c, Sav_FSL_Activity_Type__c, Sav_FSL_Discipline__c, Account__r.Name, Account__r.Id, ServiceAppointmentSubject__c, Service_Appointment__c, StartDate, EndDate, TotalDurationInHours, Sav_FSL_Approval_Requested_On__c, Status, ServiceResource.RelatedRecord.Manager.Id, ServiceResource.RelatedRecord.Manager.Name '+
            'FROM TimeSheet ' +
            'WHERE ServiceResource.RelatedRecord.Manager.Id=\''+UserInfo.getUserId()+'\' AND (Status=\'Submitted\')';
        List<TimeSheet> timesheetList = Database.query(queryString);
        if(timesheetList.size()>0){
            tw.message = System.Label.Sav_FSL_Success;
            tw.timesheetList = timesheetList;
            tw.userName = UserInfo.getUserName();
        }
        else{
            tw.message = System.Label.Sav_FSL_No_records_found;
        }
        return tw;
        
    }
    /*
Method Name :getServiceResourceUser
Parameters :serviceResourceId
Output : To return the Service resource user from the TimeSheet 
Description : 

*/
    @AuraEnabled
    public static String getServiceResourceUser(String serviceResourceId){
        String resourceUser;
        
        String queryString =  'SELECT ServiceResourceId,ServiceResource.RelatedRecordId  FROM TimeSheet WHERE ServiceResourceId = :serviceResourceId';
        List<TimeSheet> timesheetList = Database.query(queryString);
        if(timesheetList.size()>0){
            resourceUser = timesheetList[0].ServiceResource.RelatedRecordId;
        }
        return resourceUser;
        
    }
    
    /*
Method Name :approveTimesheet
Parameters :idList
Output : Manager approves the timesheet and the status will be 'Approved'.
Description : 

*/
    @AuraEnabled
    public static Boolean approveTimesheet(List<String> idList){
        try{
            List<TimeSheet> timesheetList = [ SELECT Id, Status FROM TimeSheet WHERE Id IN :idList];
            List<ProcessInstanceWorkitem> workItems = [ SELECT Id, ProcessInstanceId 
                                                       FROM ProcessInstanceWorkitem 
                                                       WHERE ProcessInstance.TargetObjectId IN :idList ];
            if(workItems.size()>0){
                List<Approval.ProcessWorkitemRequest> requests = new List<Approval.ProcessWorkitemRequest>();
                for(ProcessInstanceWorkitem workItem : workItems){
                    Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
                    req.setWorkitemId(workItem.Id);
                    req.setAction(System.Label.Sav_FSL_Approve);
                    req.setComments(System.Label.Sav_FSL_Approved_by_Manager);
                    requests.add(req);
                }
                Boolean flag=true;
                Approval.ProcessResult[] processResults = Approval.process(requests);
                for (Integer x=0;x<processResults.size();x++){
                    if(!processResults[x].isSuccess()){
                        flag=false;
                    }
                }
                if(flag){
                    List<TimeSheet> updateList = new List<TimeSheet>();
                    if(!timesheetList.isEmpty()){
                        for(TimeSheet t : timesheetList){
                            t.Sav_FSL_Manager_Rejection_Comments__c='';
                            t.Status=System.Label.Sav_FSL_Approved;
                            updateList.add(t);
                        }
                    }
                    //  update updateList;
                    if(!updateList.isEmpty()) {
                        list<Database.SaveResult> listResult_update = Database.update(updateList, false);
                    }
                    return true;
                }
                else{
                    return false;
                }
            }else{
                return false;
            }
        }catch (Exception e){
            return false;
        }
    }
    /*
Method Name :rejectTimesheet
Parameters :idList,rejectionComments
Output : Manager rejects the timesheet and the status will be 'Rejected'.
Description : 

*/
    @AuraEnabled
    public static Boolean rejectTimesheet(List<String> idList, String rejectionComments){
        try{
            List<TimeSheet> timesheetList = [ SELECT Id, Status,Sav_FSL_Manager_Rejection_Comments__c FROM TimeSheet WHERE Id IN :idList];
            List<ProcessInstanceWorkitem> workItems = [ SELECT Id, ProcessInstanceId 
                                                       FROM ProcessInstanceWorkitem 
                                                       WHERE ProcessInstance.TargetObjectId IN :idList ];
            if(workItems.size()>0){
                List<Approval.ProcessWorkitemRequest> requests = new List<Approval.ProcessWorkitemRequest>();
                for(ProcessInstanceWorkitem workItem : workItems){
                    Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
                    req.setWorkitemId(workItem.Id);
                    req.setAction(System.Label.Sav_FSL_Reject);
                    req.setComments(System.Label.Sav_FSL_Rejected_by_Manager + rejectionComments);
                    requests.add(req);
                }
                Boolean flag=true;
                Approval.ProcessResult[] processResults = Approval.process(requests);
                for (Integer x=0;x<processResults.size();x++){
                    if(!processResults[x].isSuccess()){
                        flag=false;
                    }
                }
                if(flag){
                    List<TimeSheet> updateList = new List<TimeSheet>();
                    if(!timesheetList.isEmpty()){
                        for(TimeSheet t : timesheetList){
                            t.Sav_FSL_Manager_Rejection_Comments__c=rejectionComments;
                            t.Status=System.Label.Sav_FSL_Rejected;
                            updateList.add(t);
                        }
                    }
                    if(!updateList.isEmpty()) {
                        list<Database.SaveResult> listResult_update = Database.update(updateList, false);
                    }
                    return true;
                }
                else{
                    return false;
                }
            }else{
                return false;
            }
        }catch (Exception e){
            return false;
        }
    }
}