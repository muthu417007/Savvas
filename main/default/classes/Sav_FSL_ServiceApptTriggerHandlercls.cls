/**
* Author: Cognizant Team
* Description: Handler class for Sav_FSL_ServiceAppointTrg
* Date Created: 25-04-2023
* Version: 1.0
*/
public class Sav_FSL_ServiceApptTriggerHandlercls{
    public static Boolean boolStopRun = false;
    /**
    *  Method : Manipulates the Date/Time fields according to Customer Time Zones
    *  Name : convertTimesIntoCustomerTimeZone
    *  param : list<ServiceAppointment> saList
    *  return : void
    */
    public static void convertTimesIntoCustomerTimeZone(List<ServiceAppointment> triggerNew) {
        //recursive check
        if (boolStopRun) return;
        boolStopRun = true;
        Map<String,String> timeZoneMetaMap = new Map<String,String>();
        List<ServiceAppointment> lstSaToUpdate = new List<ServiceAppointment>();        
        
        List<Sav_FSL_TimeZone_Names__mdt> timezone_metadatalist = [SELECT TimeZone_Name__c,MasterLabel from Sav_FSL_TimeZone_Names__mdt];
        if(timezone_metadatalist !=null && !timezone_metadatalist.isEmpty()){
            for(Sav_FSL_TimeZone_Names__mdt tzmdt:timezone_metadatalist){
                timeZoneMetaMap.put(tzmdt.MasterLabel,tzmdt.TimeZone_Name__c);
            }
        }
        List<ServiceAppointment> lstSA = [SELECT Id, AppointmentNumber,Sav_FSL_Service_Type__c ,Sav_FSL_Customer_Time_Zone__c, Sav_FSL_Alternate_DateTime1__c,EarliestStartTime,Sav_FSL_Alternate_Date_Time3__c,
                                          DueDate,Sav_FSL_Alternate_Date_Time2__c
                                          FROM ServiceAppointment 
                                          WHERE Id IN : triggerNew];   
         for (ServiceAppointment sa : lstSA) {
            ServiceAppointment saUpdated = new ServiceAppointment();
            saUpdated.Id = sa.Id;
            if(!String.ISBLANK(sa.Sav_FSL_Customer_Time_Zone__c)){
                system.debug('llllllllll'+sa.Sav_FSL_Service_Type__c);
                String customerTZ = timeZoneMetaMap.get(sa.Sav_FSL_Customer_Time_Zone__c);
                
                // Set these time zones as per your need
                TimeZone customerTimeZone = TimeZone.getTimeZone(customerTZ);
                TimeZone userTimeZone = UserInfo.getTimeZone(); 
             
                Integer offsetToGMT = customerTimeZone.getOffset(DateTime.now());
                Integer offsetToUserTZ = userTimeZone.getOffset(DateTime.now());
                Integer offsetDiff = offsetToUserTZ - offsetToGMT ;
                if(sa.EarliestStartTime!= null){
                    saUpdated.EarliestStartTime = sa.EarliestStartTime.addMinutes(offsetDiff / (1000 * 60));
                }
                if(sa.Sav_FSL_Alternate_Date_Time3__c!= null){
                     saUpdated.Sav_FSL_Alternate_Date_Time3__c = sa.Sav_FSL_Alternate_Date_Time3__c.addMinutes(offsetDiff / (1000 * 60));
                }
                if(sa.Sav_FSL_Alternate_DateTime1__c!= null){
                     saUpdated.Sav_FSL_Alternate_DateTime1__c = sa.Sav_FSL_Alternate_DateTime1__c.addMinutes(offsetDiff / (1000 * 60));
                }
                if(sa.Sav_FSL_Alternate_Date_Time2__c!= null){
                   saUpdated.Sav_FSL_Alternate_Date_Time2__c = sa.Sav_FSL_Alternate_Date_Time2__c.addMinutes(offsetDiff / (1000 * 60)); 
                }
                if(sa.DueDate!= null){
                    saUpdated.DueDate = sa.DueDate.addMinutes(offsetDiff / (1000 * 60));
                }
                
                lstSaToUpdate.add(saUpdated);  
            } 
        }
        if(!lstSaToUpdate.isEmpty()) {
                list<Database.SaveResult> listResult = Database.update(lstSaToUpdate, false);
            }
            system.debug('22222222222222222'+lstSaToUpdate);
    }
      
    /**
*  Method : Gets invoked when the context is After Insert on ServiceAppointment.
*  Name : afterInsert
*  param : list<ServiceAppointment> saList
*  return : void
*/
    
    public static void afterInsert(List<ServiceAppointment> saList){
        system.debug('afterInsert>>>>');
        List<ServiceAppointment> saLst = new List<ServiceAppointment>();
        List<Id> saIdLst = new List<Id>();
        saLst = [select id, AppointmentNumber, ParentRecordId, Sav_FSL_Service_Type__c, Sav_FSL_SA_Program__c, Account.Name from ServiceAppointment where id IN :saList];
        if(!saLst.isEmpty()){
            for(ServiceAppointment sa: saLst){
                system.debug('sa>>>>');
                sa.Subject = sa.AppointmentNumber+'_'+sa.Account.Name+'_'+sa.Sav_FSL_Service_Type__c+'_'+sa.Sav_FSL_SA_Program__c;
                saIdLst.add(sa.Id);
            }}
        if(!saIdLst.isEmpty()) {
            list<Database.SaveResult> listResult = Database.update(saLst, false);
        }
        List<ServiceAppointment> newServAppLst = new List<ServiceAppointment>();
        List<Service_Appointment_Attributes__c> SAALst = new List<Service_Appointment_Attributes__c>();
        
        newServAppLst = [select id, AppointmentNumber, ParentRecordId, Sav_FSL_Service_Type__c, Sav_FSL_SA_Program__c, Account.Name, Sav_FSL_Created_from_SSR_Form__c, ContactId, Sav_FSL_Requested_Delivery_Date__c, Sav_FSL_Alternate_DateTime1__c, Sav_FSL_Alternate_Date_Time2__c, Sav_FSL_Alternate_Date_Time3__c, Service_Delivery_Address__c from ServiceAppointment where id IN :saList AND Sav_FSL_Created_from_SSR_Form__c = TRUE];
        if(newServAppLst.size() > 0 && !newServAppLst.isEmpty()){
            Integer SaSize = newServAppLst.size();
            Id workOrderId = newServAppLst[0].ParentRecordId;
            system.debug('workOrderId>>>'+workOrderId);
            SAALst = [Select Id, Name, Work_Order__c, Work_Order__r.Sav_FSL_Services_Scheduling_Request__c, Service_Appointment__c, Services_Scheduling_Request__c, Sav_FSL_Alternate_Delivery_Dates1__c, Sav_FSL_Alternate_Delivery_Dates2__c, Sav_FSL_Alternate_Delivery_Dates3__c, Customer_Contact__c, Sav_FSL_Requested_Delivery_Dates__c, Sav_FSL_Service_Delivery_Address__c FROM Service_Appointment_Attributes__c where Work_Order__c = : workOrderId AND Service_Appointment__r.Id = null ORDER BY createdDate Limit :SaSize];
            System.debug('SAALst>>'+SAALst);
            if(SAALst.size() > 0 && !SAALst.isEmpty()){
                for(Service_Appointment_Attributes__c saa : SAALst){
                    saa.Service_Appointment__c = saIdLst[0];
                    saa.Services_Scheduling_Request__c = saa.Work_Order__r.Sav_FSL_Services_Scheduling_Request__c;
                    saIdLst.remove(0);
                }
            }
            
            if(SAALst.size() > 0 && !SAALst.isEmpty()){
                list<Database.SaveResult> update_saalist = Database.update(SAALst, false);
            }
            
        } 
    }
    
    /**
*  Method : Gets invoked when the context is After Update on ServiceAppointment.
*  Name : afterUpdateOnSA
*  param : List<ServiceAppointment> saList , Map<Id,ServiceAppointment> mapOldSA
*  return : void
*/
    
    public static void afterUpdateOnSA(List<ServiceAppointment> saList , Map<Id,ServiceAppointment> mapOldSA){
        Set<Id> lstSa = new Set<Id>();
        Set<Id> setSA = new Set<Id>();
        Set<Id> setWO = new Set<ID>();
        Map<id,string> mapSASRID = new Map<id,string>();
        Map<id,string> resourceIdMAP = new Map<id,string>();
        Set<Id> saCanceledIDS = new Set<Id>();
        system.debug('entered into SA update');
        for(ServiceAppointment sa : saList){
           ServiceAppointment oldSa = mapOldSA.get(sa.Id);
             system.debug('oldSa.Status '+oldSa.Status);
            system.debug('sa.Status '+sa.Status);
            if ((sa.Status != System.Label.Sav_FSL_Canceled && oldSa.Status != sa.Status) || (oldSa.SchedStartTime != sa.SchedStartTime)) {
                lstSa.add(sa.Id);
            }
            if(sa.Status == System.Label.Sav_FSL_Canceled){
                saCanceledIDS.add(sa.Id);
            }
        }
        system.debug('lstSa '+lstSa);
        if(lstSa!=null && !lstSa.isEmpty()){
            List<AssignedResource> lstAR = [Select id,ServiceAppointmentId,ServiceAppointment.ParentRecordId,ServiceAppointment.AppointmentNumber,ServiceResourceId,ServiceResource.RelatedRecordId from AssignedResource where ServiceAppointmentId=:lstSa];
            if(lstAR.size() > 0 && !lstAR.isEmpty()){
                for(AssignedResource asr:lstAR){
                    setSA.add(asr.ServiceAppointmentId);
                    mapSASRID.put(asr.ServiceAppointmentId, asr.ServiceResourceId);
                    resourceIdMAP.put(asr.ServiceAppointmentId,asr.ServiceResource.RelatedRecordId);
                }
            }
            Map<id,string> mapWOSubject = new Map<id,string>();
            Map<id,string> mapAccId = new Map<id,string>();
            Map<id,string> mapAccName = new Map<id,string>();
            set<Id> existingSAID = new set<Id>();
            Map<Id,Id> serviceApptWithTSMAP = new Map<Id,Id>();
            List<TimeSheet> exisitingTS = [Select id,OwnerId,Service_Appointment__c,EndDate,StartDate from TimeSheet where Service_Appointment__c=:setSA];
            system.debug('SAexisitingTS '+exisitingTS);            
            if(!exisitingTS.isEmpty() && exisitingTS.size()>0){
                for(TimeSheet exts:exisitingTS){
                    serviceApptWithTSMAP.put(exts.Service_Appointment__c,exts.id);
                    existingSAID.add(exts.Service_Appointment__c);
                }
            }            
            List<TimeSheet> lstTSUpdate = new List<TimeSheet>();
            List<TimeSheet> lstTSAfterUpdate = new List<TimeSheet>();
            for(ServiceAppointment sa:[Select id,Status,AccountId,Account.Id,Account.Name,AppointmentNumber,ParentRecordId, Subject,SchedStartTime, 
                                       SchedEndTime from ServiceAppointment  
                                       WHERE id=:setSA and SchedStartTime!=null and SchedEndTime!=null and Status !=:Label.Sav_FSL_Canceled]){
                                           if(!existingSAID.contains(sa.Id)){
                                               system.debug('SAIFexistingSAID '+existingSAID);
                                               TimeSheet ts = new TimeSheet();
                                               ts.StartDate = sa.SchedStartTime.date();
                                               Date weekDt = ts.StartDate;
                                               Date startOfWeek = weekDt.toStartofWeek();  
                                               Date endOfWeek = startOfWeek.addDays(6);
                                               ts.EndDate = endOfWeek;
                                               ts.ServiceResourceId = mapSASRID.get(sa.id);                       
                                               if(sa.AccountId!=null)
                                                   ts.Account__c = sa.AccountId; 
                                               ts.Sav_FSL_Account_Name__c = sa.Account.Name;
                                               ts.ServiceAppointmentSubject__c = sa.Subject;
                                               ts.Service_Appointment__c = sa.id;
                                               ts.Work_Order__c = sa.ParentRecordId;
                                               ts.Sav_FSL_Section__c = System.Label.Sav_FSL_SA;
                                               ts.OwnerId = resourceIdMAP.get(sa.id);
                                               lstTSUpdate.add(ts);
                                               system.debug('SAlstTSUpdate '+lstTSUpdate);
                                           }
                                           else{
                                                if(mapOldSA.containskey(sa.id) && mapOldSA.get(sa.id).SchedStartTime !=sa.SchedStartTime){
                                                    TimeSheet updateTimeSheetRec = new Timesheet();
                                                   updateTimeSheetRec.id = serviceApptWithTSMAP.get(sa.id);
                                                   updateTimeSheetRec.StartDate = sa.SchedStartTime.date();
                                                   updateTimeSheetRec.ServiceResourceId = mapSASRID.get(sa.id);
                                                   Date weekDt = updateTimeSheetRec.StartDate;
                                                   Date startOfWeek = weekDt.toStartofWeek(); 
                                                   Date endOfWeek = startOfWeek.addDays(6);
                                                   if(sa.AccountId!=null)
                                                       updateTimeSheetRec.Account__c = sa.AccountId;  
                                                   updateTimeSheetRec.EndDate = endOfWeek;
                                                   updateTimeSheetRec.OwnerId = resourceIdMAP.get(sa.id);
                                                   lstTSAfterUpdate.add(updateTimeSheetRec); 
                                               }
                                           }
                                       }
           
            if(lstTSUpdate.size()>0 && !lstTSUpdate.isEmpty()){
                list<Database.SaveResult> list_ts_insert = Database.insert(lstTSUpdate, false);
            }
            
            if(lstTSAfterUpdate.size()>0 && !lstTSAfterUpdate.isEmpty()){
                list<Database.SaveResult> list_ts_afterupdate = Database.update(lstTSAfterUpdate, false);
            }            
        }
        if(saCanceledIDS!=null && !saCanceledIDS.isEmpty()){
            List<TimeSheet> deleteTS = [Select id,Service_Appointment__c,EndDate,StartDate from TimeSheet where Service_Appointment__c=:saCanceledIDS];
            if(deleteTS!=null && deleteTS.size()>0){ delete deleteTS;
            }
        }
        
    }    
    /** W-013515 changes
*  Method : Gets invoked when the context is Before Update on ServiceAppointment.
*  Name : updateCustomerStartEndDate
*  param : List<ServiceAppointment> updSAList , Map<Id,ServiceAppointment> oldSAMap
*  return : void
*/
public static void updateCustomerStartEndDate(List<ServiceAppointment> updSAList,Map<Id,ServiceAppointment> oldSAMap){
        Map<String,String> timeZoneMetaMap = new Map<String,String>();
        List<ServiceAppointment> SAListToUpd = new List<ServiceAppointment>();
        List<Sav_FSL_TimeZone_Names__mdt> timezone_metadatalist = [SELECT TimeZone_Name__c,MasterLabel from Sav_FSL_TimeZone_Names__mdt];
        if(timezone_metadatalist !=null && !timezone_metadatalist.isEmpty()){
            for(Sav_FSL_TimeZone_Names__mdt tzmdt:timezone_metadatalist){
                timeZoneMetaMap.put(tzmdt.MasterLabel,tzmdt.TimeZone_Name__c);
            }
        }
        for(ServiceAppointment sa : updSAList) {
            if(sa.Sav_FSL_Customer_Time_Zone__c!= null && !String.ISBLANK(sa.Sav_FSL_Customer_Time_Zone__c) && 
               ((sa.Sav_FSL_Customer_Time_Zone__c != oldSAMap.get(sa.Id).Sav_FSL_Customer_Time_Zone__c ||
                sa.Status != oldSAMap.get(sa.Id).Status ||
                sa.EarliestStartTime != oldSAMap.get(sa.Id).EarliestStartTime ||
                sa.Sav_FSL_Alternate_Date_Time3__c != oldSAMap.get(sa.Id).Sav_FSL_Alternate_Date_Time3__c ||
                sa.SchedStartTime != oldSAMap.get(sa.Id).SchedStartTime) ||
                sa.SchedEndTime != oldSAMap.get(sa.Id).SchedEndTime) && 
                sa.Sav_FSL_Customer_Time_Zone__c != 'Other'){
                    
                String customerTZ = timeZoneMetaMap.get(sa.Sav_FSL_Customer_Time_Zone__c);
                TimeZone customerTimeZone = TimeZone.getTimeZone(customerTZ);
                TimeZone userTimeZone = UserInfo.getTimeZone(); 
             
                Integer offsetToGMT = customerTimeZone.getOffset(DateTime.now());
                Integer offsetToUserTZ = userTimeZone.getOffset(DateTime.now());
                Integer offsetDiff = offsetToGMT - offsetToUserTZ ;
                
                    if( sa.Status == System.Label.Sav_FSL_On_Hold || 
                    sa.Status == System.Label.Sav_FSL_Ready_to_Schedule ||
                    sa.Status == System.Label.Sav_FSL_Escalated){                       
                    if(sa.EarliestStartTime != null){
                        sa.Customer_Start_Date_Time__c = sa.EarliestStartTime.addMinutes(offsetDiff / (1000 * 60)).format('h:mm a ');
                    }
                    else{
                        sa.Customer_Start_Date_Time__c = null;
                    }
                    if(sa.Sav_FSL_Alternate_Date_Time3__c != null){
                        sa.Customer_End_Date_Time__c = sa.Sav_FSL_Alternate_Date_Time3__c.addMinutes(offsetDiff / (1000 * 60)).format('h:mm a ');
                    }
                    else{
                        sa.Customer_End_Date_Time__c = null;
                    }                   
                    
                }
                else if(sa.Status == System.Label.Sav_FSL_Scheduled || 
                        sa.Status == System.Label.Sav_FSL_Completed){
                        if(sa.SchedStartTime != null){
                            sa.Customer_Start_Date_Time__c = sa.SchedStartTime.addMinutes(offsetDiff / (1000 * 60)).format('h:mm a ');
                        }
                        else{                           
                            sa.Customer_Start_Date_Time__c = null;
                        }
                        if(sa.SchedEndTime != null){
                            sa.Customer_End_Date_Time__c = sa.SchedEndTime.addMinutes(offsetDiff / (1000 * 60)).format('h:mm a ');
                        }
                        else{                           
                            sa.Customer_End_Date_Time__c = null;
                        }
                }
            }
                
            else if((String.ISBLANK(sa.Sav_FSL_Customer_Time_Zone__c) || sa.Sav_FSL_Customer_Time_Zone__c == 'Other') && sa.Sav_FSL_Customer_Time_Zone__c != oldSAMap.get(sa.Id).Sav_FSL_Customer_Time_Zone__c){
                         sa.Customer_Start_Date_Time__c = null;
                         sa.Customer_End_Date_Time__c = null;
            }   
        }
}
/** W-013515 changes
*  Method : Gets invoked when the context is Before Insert on ServiceAppointment.
*  Name : beforeInsertCustomerDatesUpdate
*  param : List<ServiceAppointment> triggerNew
*  return : void
*/

    public static void beforeInsertCustomerDatesUpdate(List<ServiceAppointment> triggerNew) {
        Datetime earliestStart = null;
        Datetime reqEnddate = null;
        Map<String,String> timeZoneMetaMap = new Map<String,String>();
        List<ServiceAppointment> lstSaToUpdate = new List<ServiceAppointment>();        
        
        List<Sav_FSL_TimeZone_Names__mdt> timezone_metadatalist = [SELECT TimeZone_Name__c,MasterLabel from Sav_FSL_TimeZone_Names__mdt];
        if(timezone_metadatalist !=null && !timezone_metadatalist.isEmpty()){
            for(Sav_FSL_TimeZone_Names__mdt tzmdt:timezone_metadatalist){
                timeZoneMetaMap.put(tzmdt.MasterLabel,tzmdt.TimeZone_Name__c);
            }
        }  
         for (ServiceAppointment sa : triggerNew) {
            String customerTZ = timeZoneMetaMap.get(sa.Sav_FSL_Customer_Time_Zone__c);
            earliestStart = sa.EarliestStartTime;
            reqEnddate = sa.Sav_FSL_Alternate_Date_Time3__c;
            // Set these time zones as per your need
            if(!String.ISBLANK(customerTZ) && sa.Sav_FSL_Customer_Time_Zone__c != 'Other'){
                TimeZone customerTimeZone = TimeZone.getTimeZone(customerTZ);
                TimeZone userTimeZone = UserInfo.getTimeZone(); 

                Integer offsetToGMT = customerTimeZone.getOffset(DateTime.now());
                Integer offsetToUserTZ = userTimeZone.getOffset(DateTime.now());
                Integer offsetDiff = offsetToGMT - offsetToUserTZ ;
            
                //Added W-013515 changes starts
                if(!String.ISBLANK(sa.Sav_FSL_Customer_Time_Zone__c) &&
                        (sa.Status == System.Label.Sav_FSL_On_Hold || 
                        sa.Status == System.Label.Sav_FSL_Ready_to_Schedule ||
                        sa.Status == System.Label.Sav_FSL_Escalated)){
                            if(sa.EarliestStartTime != null && String.ISBLANK(sa.Customer_Start_Date_Time__c)){
        sa.Customer_Start_Date_Time__c = sa.EarliestStartTime.addMinutes(offsetDiff / (1000 * 60)).format('h:mm a ');
                            }
                            if(sa.Sav_FSL_Alternate_Date_Time3__c != null && String.ISBLANK(sa.Customer_End_Date_Time__c)){
                                sa.Customer_End_Date_Time__c = sa.Sav_FSL_Alternate_Date_Time3__c.addMinutes(offsetDiff / (1000 * 60)).format('h:mm a ');
                            }
                        }
                else if(!String.ISBLANK(sa.Sav_FSL_Customer_Time_Zone__c) &&
                        (sa.Status == System.Label.Sav_FSL_Scheduled || 
                        sa.Status == System.Label.Sav_FSL_Completed)){
                        offsetDiff = offsetToGMT - offsetToUserTZ ;
                        if(sa.SchedStartTime != null){
                            sa.Customer_Start_Date_Time__c = sa.SchedStartTime.addMinutes(offsetDiff / (1000 * 60)).format('h:mm a ');
                        }
                        if(sa.SchedEndTime != null){
                            sa.Customer_End_Date_Time__c = sa.SchedEndTime.addMinutes(offsetDiff / (1000 * 60)).format('h:mm a ');
                        }
                }   
                //Added W-013515 changes ends   
            }
         }
     }
}