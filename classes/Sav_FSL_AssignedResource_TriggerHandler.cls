/**
* Author: Cognizant Team
* Description: Handler class for Sav_FSL_AssignedResource_Trigger
* Date Created: 25-04-2023
* Version: 1.0
*/

public class Sav_FSL_AssignedResource_TriggerHandler {
    
    /**
*  Method : Gets invoked when the context is After Insert on AssignedResource.
*  Name : onAfterInsert
*  param : list<AssignedResource> listTriggerNew
*  return : void
*/
    
    public static void onAfterInsert(list<AssignedResource> listTriggerNew){
        system.debug('AFTERINSERTAR');
        Set<Id> resourceId = new Set<Id>();
        set<id> setSerAppoIds = new set<id>();
        set<Id> oldresourceId = new set<Id>();
        set<Id> oldSAId = new set<Id>();
        Map<id,string> resourceIdMAP = new Map<id,string>();
        List<ServiceResource> srLst = new List<ServiceResource>();
        List<ServiceResource> oldsrLst = new List<ServiceResource>();
        List<TimeSheet> lstTSInsert = new List<TimeSheet>();
        Map<id,string> mapSAResourceId = new Map<id,string>();
        Map<Id,Id> servicerReourceUserIDMAP = new Map<Id,Id>();
        for(AssignedResource asgnRes : listTriggerNew){
            resourceId.add(asgnRes.ServiceResourceId);
            setSerAppoIds.add(asgnRes.ServiceAppointmentId);
            mapSAResourceId.put(asgnRes.ServiceAppointmentId, asgnRes.ServiceResourceId);
            resourceIdMAP.put(asgnRes.ServiceAppointmentId,asgnRes.ServiceResource.RelatedRecordId);
          
        }
        
        List<ServiceAppointment> serviceApptLst = [Select id,Status,AccountId,Account.Id,Account.Name,AppointmentNumber,ParentRecordId, Subject,SchedStartTime, 
                                                   SchedEndTime from ServiceAppointment  
                                                   WHERE id=:setSerAppoIds and SchedStartTime!=null and SchedEndTime!=null and Status!=:Label.Sav_FSL_Canceled];
        List<TimeSheet> exisitingTS = [Select id,OwnerId,Service_Appointment__c,EndDate,StartDate from TimeSheet where Service_Appointment__c=:setSerAppoIds];
        List<AssignedResource> onsiteARLst = [Select Id, ServiceAppointment.Sav_FSL_Delivery_Mode__c  from AssignedResource where ServiceAppointment.Sav_FSL_Delivery_Mode__c =:Label.Sav_FSL_Onsite and ServiceResourceId IN :resourceId and createdDate = THIS_MONTH];
        List<AssignedResource> virtualARLst = [Select Id, ServiceAppointment.Sav_FSL_Delivery_Mode__c  from AssignedResource where (ServiceAppointment.Sav_FSL_Delivery_Mode__c =:Label.Sav_FSL_Virtual OR ServiceAppointment.Sav_FSL_Delivery_Mode__c =:Label.Sav_FSL_Blended OR ServiceAppointment.Sav_FSL_Delivery_Mode__c =:Label.Sav_FSL_Asynchronous) and ServiceResourceId IN :resourceId and createdDate = THIS_MONTH];
        List<ServiceResource> serResLst = new List<ServiceResource>();
        serResLst = [SELECT Id, RelatedRecordId, Name, Onsite_Session_Count__c, Virtual_Session_Count__c FROM ServiceResource WHERE Id IN :resourceId];
        if(serResLst.size() > 0 && !serResLst.isEmpty()){
            for(ServiceResource sr: serResLst){
                servicerReourceUserIDMAP.put(sr.id, sr.RelatedRecordId);
                sr.Onsite_Session_Count__c = onsiteARLst.size();
                sr.Virtual_Session_Count__c = virtualARLst.size();
                srLst.add(sr);
            }
            //update srLst;
            if(!srLst.isEmpty()) {
                list<Database.SaveResult> serviceresource_list = Database.update(srLst, false);
            }   
        }
        
        if(serviceApptLst.size() > 0 && !serviceApptLst.isEmpty() && exisitingTS.isEmpty()){
            for(ServiceAppointment saAppt:serviceApptLst){
                TimeSheet ts = new TimeSheet();
                ts.StartDate = saAppt.SchedStartTime.date();
                Date weekDt = ts.StartDate;
                Date startOfWeek = weekDt.toStartofWeek();  
                Date endOfWeek = startOfWeek.addDays(6);
                ts.EndDate = endOfWeek;//saAppt.SchedEndTime.date();
                ts.ServiceResourceId = mapSAResourceId.get(saAppt.id);                       
                if(saAppt.AccountId!=null)
                    ts.Account__c = saAppt.AccountId; 
                ts.Sav_FSL_Account_Name__c = saAppt.Account.Name;
                ts.ServiceAppointmentSubject__c = saAppt.Subject;
                ts.Service_Appointment__c = saAppt.id;
                ts.Work_Order__c = saAppt.ParentRecordId;
                ts.Sav_FSL_Section__c = System.Label.Sav_FSL_SA;
                ts.OwnerId = servicerReourceUserIDMAP.get(ts.ServiceResourceId);//resourceIdMAP.get(saAppt.id);
                lstTSInsert.add(ts);
            }
            if(!lstTSInsert.isEmpty() && lstTSInsert.size()> 0) {
                list<Database.SaveResult> timesheet_list = Database.insert(lstTSInsert, false);
            } 
            
        }
    }
    
    /**
*  Method : Gets invoked when the context is After Delete on AssignedResource.
*  Name : onAfterDelete
*  param : list<AssignedResource> listTriggerOld
*  return : void
*/
    
    public static void onAfterDelete(list<AssignedResource> listTriggerOld){
        Set<Id> resourceId = new Set<Id>();
        set<id> setSerAppoIds = new set<id>();
        set<Id> oldresourceId = new set<Id>();
        set<Id> oldSAId = new set<Id>();
        set<Id> SAId = new set<Id>();
        List<ServiceResource> srLst = new List<ServiceResource>();
        List<ServiceResource> oldsrLst = new List<ServiceResource>();
        
        for(AssignedResource asgnRes : listTriggerOld){
            resourceId.add(asgnRes.ServiceResourceId);
            SAId.add(asgnRes.ServiceAppointmentId);
        }
        List<Event> EvtLst = new List<Event>();
        List<AssignedResource> onsiteARLst = [Select Id, ServiceAppointment.Sav_FSL_Delivery_Mode__c  from AssignedResource where ServiceAppointment.Sav_FSL_Delivery_Mode__c =:Label.Sav_FSL_Onsite and ServiceResourceId IN :resourceId and createdDate = THIS_MONTH];
        List<AssignedResource> virtualARLst = [Select Id, ServiceAppointment.Sav_FSL_Delivery_Mode__c  from AssignedResource where (ServiceAppointment.Sav_FSL_Delivery_Mode__c =:Label.Sav_FSL_Virtual OR ServiceAppointment.Sav_FSL_Delivery_Mode__c =:Label.Sav_FSL_Blended OR ServiceAppointment.Sav_FSL_Delivery_Mode__c =:Label.Sav_FSL_Asynchronous) and ServiceResourceId IN :resourceId and createdDate = THIS_MONTH];
        List<TimeSheet> deleteTS = [Select id,Service_Appointment__c from TimeSheet where Service_Appointment__c=:SAId];
        List<ServiceResource> serResLst = new List<ServiceResource>();

        EvtLst = [Select Id,Subject,whatId from Event where whatId IN :SAId];
        


        serResLst = [SELECT Id, Name, Onsite_Session_Count__c, Virtual_Session_Count__c FROM ServiceResource WHERE Id IN :resourceId];
        if(serResLst.size() > 0 && !serResLst.isEmpty()){
            for(ServiceResource sr: serResLst){
                sr.Onsite_Session_Count__c = onsiteARLst.size();
                sr.Virtual_Session_Count__c = virtualARLst.size();
                srLst.add(sr);
            }
            //update srLst;
            if(!srLst.isEmpty()) {
                list<Database.SaveResult> service_resource_list = Database.update(srLst, false);
            }
        }
        if(deleteTS.size() > 0 && !deleteTS.isEmpty()){
            list<Database.DeleteResult> deleteResults = Database.delete(deleteTS, false);
        }

        if(EvtLst.size() > 0 && !EvtLst.isEmpty()){
          
            list<Database.DeleteResult> deleteResults = Database.delete(EvtLst, false);
        }
    }
    
    /**
*  Method : Gets invoked when the context is After Update on AssignedResource.
*  Name : onAfterUpdate
*  param : list<AssignedResource> listTriggerOld, map<id,AssignedResource> triggerOldMap
*  return : void
*/
    
    public static void onAfterUpdate(list<AssignedResource> listTriggerNew, map<id,AssignedResource> triggerOldMap){
        set<id> serviceAppointmentId = new set<id>();
        Set<Id> resourceId = new Set<Id>();
        Map<Id,Id> serviceApptwithResourceIdMap = new Map<Id,Id>();
        List<TimeSheet> lstTSAfterUpdate = new List<TimeSheet>();
        Map<id,string> resourceIdMAP = new Map<id,string>();
        Map<Id,Id> servicerReourceUserIDMAP = new Map<Id,Id>();
        for(AssignedResource assignedResource: listTriggerNew){
            if(triggerOldMap.get(assignedResource.id).ServiceResourceId!=assignedResource.ServiceResourceId){
                resourceId.add(assignedResource.ServiceResourceId);
                serviceAppointmentId.add(assignedResource.ServiceAppointmentId);
                serviceApptwithResourceIdMap.put(assignedResource.ServiceAppointmentId,assignedResource.ServiceResourceId);
                resourceIdMAP.put(assignedResource.ServiceAppointmentId,assignedResource.ServiceResource.RelatedRecordId);
            } 
        }
        List<ServiceResource> serResLst = new List<ServiceResource>();
        serResLst = [SELECT Id, RelatedRecordId, Name, Onsite_Session_Count__c, Virtual_Session_Count__c FROM ServiceResource WHERE Id IN :resourceId];
        if(serResLst.size() > 0 && !serResLst.isEmpty()){
            for(ServiceResource sr: serResLst){
                servicerReourceUserIDMAP.put(sr.id, sr.RelatedRecordId);
                
            } 
        }
        If(!serviceAppointmentId.isEmpty()){
            Map<Id,Id> serviceApptWithTSMAP = new Map<Id,Id>();
            List<TimeSheet> exisitingTS = [Select id,OwnerId,Service_Appointment__c,ServiceResourceId from TimeSheet where Service_Appointment__c=:serviceAppointmentId];
            for(TimeSheet exts:exisitingTS){
                serviceApptWithTSMAP.put(exts.Service_Appointment__c,exts.id);
            }
            for(ServiceAppointment sa:[Select id,AppointmentNumber,ParentRecordId, Subject,SchedStartTime, 
                                       SchedEndTime from ServiceAppointment  
                                       WHERE id=:serviceAppointmentId and SchedStartTime!=null and SchedEndTime!=null and Status!=:Label.Sav_FSL_Canceled]){
                                           TimeSheet updateTimeSheetRec = new Timesheet();
                                           updateTimeSheetRec.id = serviceApptWithTSMAP.get(sa.id);
                                           updateTimeSheetRec.ServiceResourceId = serviceApptwithResourceIdMap.get(sa.id);
                                           updateTimeSheetRec.OwnerId = servicerReourceUserIDMAP.get(updateTimeSheetRec.ServiceResourceId);//resourceIdMAP.get(sa.id);
                                           lstTSAfterUpdate.add(updateTimeSheetRec);
                                           
                                       }
            if(lstTSAfterUpdate.size()>0 && !lstTSAfterUpdate.isEmpty()){
                // update lstTSAfterUpdate;
                list<Database.SaveResult> lstts_afterupdate = Database.update(lstTSAfterUpdate, false);
            } 
        }
    }
}