/**
* Author: Cognizant team
* Description: Merging On-Hold Work Orders with New Work Orders on same Account
* Date Created: 03-04-2023
* Version: 1.0
*/

public class Sav_FSL_workOrderMergePOC {
    @InvocableMethod(label='Merge Work Orders on Account Duplicate')
        
    public static void mergeWorkOrders(List<List<WorkOrder>> selectedWorkOrder){
        List<WorkOrder> workOrderToReturn = new List<WorkOrder>();
        WorkOrder masterWorkOrder = new WorkOrder();
        WorkOrder mergeWorkOrder = new WorkOrder();
        List<WorkOrder> WorkOrderListReceived= selectedWorkOrder.get(0);
        for(WorkOrder wo : WorkOrderListReceived){
            if(wo.Status == System.Label.Sav_FSL_New){	
                masterWorkOrder = wo;
            }
            else if(wo.Status == System.Label.Sav_FSL_On_Hold){
                mergeWorkOrder = wo;
            }
        } 
        masterWorkOrder.Sav_FSL_Customer_Time_Zone__c=mergeWorkOrder.Sav_FSL_Customer_Time_Zone__c;
        masterWorkOrder.Sav_FSL_Estimated_Number_of__c=mergeWorkOrder.Sav_FSL_Estimated_Number_of__c;
        masterWorkOrder.Description=mergeWorkOrder.Description;
        masterWorkOrder.Sav_FSL_Grade_Level__c=mergeWorkOrder.Sav_FSL_Grade_Level__c;
        update masterWorkOrder;
                             
        List<Service_Appointment_Attributes__c> listSAA = new List<Service_Appointment_Attributes__c>();
        List<Service_Appointment_Attributes__c> updatelistSAA = new List<Service_Appointment_Attributes__c>();
        listSAA = [Select ID from Service_Appointment_Attributes__c where Work_Order__c =: mergeWorkOrder.Id];
        Service_Appointment_Attributes__c newSAA = new Service_Appointment_Attributes__c();
        
        if(!listSAA.isEmpty()){
        for(Service_Appointment_Attributes__c saa:listSAA){
          saa.Work_Order__c = masterWorkOrder.Id;
          saa.Service_Appointment__c = null;
          updatelistSAA.add(saa);
        }
        }
        if(!updatelistSAA.isEmpty()) {
                list<Database.SaveResult> update_list_saa_result = Database.update(updatelistSAA, false);
              }

        
        List<ServiceAppointment> listSA = new List<ServiceAppointment>();
        List<ServiceAppointment> updatelistSA = new List<ServiceAppointment>();
        listSA = [Select ID,EarliestStartTime,IsCloned__c,DueDate,Service_Delivery_Address__c,Sav_FSL_Requested_Delivery_Date__c,Sav_FSL_Alternate_Date_Time3__c, Sav_FSL_Alternate_DateTime1__c, Sav_FSL_Alternate_Date_Time2__c, ParentRecordId, Opportunity__c,Sav_FSL_Created_from_SSR_Form__c, Sav_FSL_Delivery_Mode__c, Description, Sav_FSL_Service_Type__c,Sav_FSL_Estimated_Number_of_Attendees__c,Sav_FSL_Was_Escalated__c,Sav_FSL_CSAT__c, Sav_FSL_Grade_Level_s__c, ServiceNote, ServiceTerritoryId, Sav_FSL_SA_Program__c, FSL__GanttLabel__c, FSL__GanttColor__c, FSL__InJeopardy__c,FSL__InJeopardyReason__c, FSL__Emergency__c, FSL__Pinned__c    from ServiceAppointment where ParentRecordId =: mergeWorkOrder.Id];
        
        ServiceAppointment newSA = new ServiceAppointment();
        if(!listSAA.isEmpty()){
        for(ServiceAppointment sa:listSA){
        ServiceAppointment saCloneCopy  = sa.clone(false, false, false, false); 
         
        saCloneCopy.ParentRecordId = masterWorkOrder.Id;
        saCloneCopy.Sav_FSL_Created_from_SSR_Form__c = true;
            saCloneCopy.Sav_FSL_Delivery_Mode__c = sa.Sav_FSL_Delivery_Mode__c;
            saCloneCopy.Description = sa.Description;
            saCloneCopy.Sav_FSL_Service_Type__c= sa.Sav_FSL_Service_Type__c;
            saCloneCopy.Sav_FSL_Estimated_Number_of_Attendees__c= sa.Sav_FSL_Estimated_Number_of_Attendees__c;
            saCloneCopy.Sav_FSL_Was_Escalated__c= sa.Sav_FSL_Was_Escalated__c;
            saCloneCopy.Sav_FSL_CSAT__c= sa.Sav_FSL_CSAT__c;
            saCloneCopy.Opportunity__c = sa.Opportunity__c;
            saCloneCopy.Duration= masterWorkOrder.Duration;
            saCloneCopy.Sav_FSL_Grade_Level_s__c= sa.Sav_FSL_Grade_Level_s__c;
            saCloneCopy.ServiceNote= sa.ServiceNote;
            saCloneCopy.ServiceTerritoryId= sa.ServiceTerritoryId;
            saCloneCopy.Sav_FSL_SA_Program__c= sa.Sav_FSL_SA_Program__c;
            saCloneCopy.FSL__GanttLabel__c= sa.FSL__GanttLabel__c;
            saCloneCopy.FSL__GanttColor__c= sa.FSL__GanttColor__c;
            saCloneCopy.FSL__InJeopardy__c= sa.FSL__InJeopardy__c;
            saCloneCopy.FSL__InJeopardyReason__c= sa.FSL__InJeopardyReason__c;
            saCloneCopy.FSL__Emergency__c= sa.FSL__Emergency__c;
            saCloneCopy.FSL__Pinned__c= sa.FSL__Pinned__c;
            saCloneCopy.ISBN13__c= masterWorkOrder.Sav_FSL_ISBN_13__c;
            saCloneCopy.Sav_FSL_Customer_Time_Zone__c= masterWorkOrder.Sav_FSL_Customer_Time_Zone__c;
            saCloneCopy.DueDate = sa.DueDate;
            saCloneCopy.Sav_FSL_Requested_Delivery_Date__c	= sa.Sav_FSL_Requested_Delivery_Date__c;
            saCloneCopy.Sav_FSL_Alternate_Date_Time3__c = sa.Sav_FSL_Alternate_Date_Time3__c;
            saCloneCopy.Sav_FSL_Alternate_DateTime1__c = sa.Sav_FSL_Alternate_DateTime1__c;
            saCloneCopy.Sav_FSL_Alternate_Date_Time2__c = sa.Sav_FSL_Alternate_Date_Time2__c;
            saCloneCopy.Service_Delivery_Address__c = sa.Service_Delivery_Address__c;
   
            saCloneCopy.EarliestStartTime = sa.EarliestStartTime;
            saCloneCopy.IsCloned__c = true;
            
        updatelistSA.add(saCloneCopy);
        }}
        
         list<Database.SaveResult> insert_list_saa_result = Database.insert(updatelistSA, false);  
        workOrderToReturn.add(masterWorkOrder);
         List<ServiceAppointment> replicatedSA = new List<ServiceAppointment>();
        replicatedSA=[Select ID, ParentRecordId from ServiceAppointment where ParentRecordId =: mergeWorkOrder.Id];
        Database.DeleteResult[] replicated_SA = Database.delete(replicatedSA, false);
        Database.DeleteResult merge_workOrder = Database.delete(mergeWorkOrder, false);
 
    }
    
}