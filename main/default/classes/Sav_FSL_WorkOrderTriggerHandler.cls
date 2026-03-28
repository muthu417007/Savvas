/**
* Author: Cognizant Team
* Description: Handler class for Sav_FSL_WorkOrder_Trigger
* Date Created: 25-04-2023
* Version: 1.0
*/
public without sharing class Sav_FSL_WorkOrderTriggerHandler {
   
     /**
    *  Method : Gets invoked when the context is After Insert on WorkOrder.
    *  Name : onAfterInsert
    *  param : list<Workorder> listTriggerNew
    *  return : void
    */
    public static void onAfterInsert(list<WorkOrder> listTriggerNew) {
        List<WorkOrder> workOrdersToUpdate = new List<WorkOrder>();
        if(!checkRecursive.inFutureContext) { 
            checkRecursive.inFutureContext = true;
            List<WorkOrder> listOfWorkOrders = new List<WorkOrder>();
            listOfWorkOrders = [select id, WorkOrderNumber, Sav_FSL_Service_Type__c, Sav_FSL_Purchase_Order__c, Account.Name, Sav_FSL_Material_Number_Title__c, Sav_FSL_Program__c from WorkOrder where id IN :listTriggerNew ];
            
            if(!listOfWorkOrders.isEmpty()){
                for(WorkOrder wo: listOfWorkOrders){
                    if((wo.Sav_FSL_Service_Type__c == System.Label.Sav_FSL_Service_Type_Prof_Dev_ImplEssnt || wo.Sav_FSL_Service_Type__c == System.Label.Sav_FSL_ProfDevJobEmbeddedServices  || wo.Sav_FSL_Service_Type__c == System.Label.Sav_FSL_Service_Type_Prog_Act_Paid || wo.Sav_FSL_Service_Type__c == System.Label.Sav_FSL_Service_Type_PD || wo.Sav_FSL_Service_Type__c == System.Label.Sav_FSL_Service_Type_PIE) && wo.Sav_FSL_Purchase_Order__c != null){
                        wo.Subject = wo.WorkOrderNumber+'_'+wo.Sav_FSL_Purchase_Order__c+'_'+wo.Account.Name+'_'+wo.Sav_FSL_Material_Number_Title__c ;
                    }
                    else if ((wo.Sav_FSL_Service_Type__c == System.Label.Sav_FSL_Service_Type_Prof_Dev_ImplEssnt || wo.Sav_FSL_Service_Type__c == System.Label.Sav_FSL_ProfDevJobEmbeddedServices  || wo.Sav_FSL_Service_Type__c == System.Label.Sav_FSL_Service_Type_Prog_Act_Paid || wo.Sav_FSL_Service_Type__c == System.Label.Sav_FSL_Service_Type_PD || wo.Sav_FSL_Service_Type__c == System.Label.Sav_FSL_Service_Type_PIE) && wo.Sav_FSL_Purchase_Order__c == null){
                        wo.Subject = wo.WorkOrderNumber+'_'+wo.Account.Name+'_'+wo.Sav_FSL_Material_Number_Title__c ;
                    }
                    else{
                        wo.Subject = wo.WorkOrderNumber+'_'+wo.Account.Name+'_'+wo.Sav_FSL_Service_Type__c+'_'+wo.Sav_FSL_Program__c;
                    }
                    workOrdersToUpdate.add(wo);
                }
                
                if(!workOrdersToUpdate.isEmpty()) {
                    list<Database.SaveResult> listResult = Database.update(workOrdersToUpdate, false);
                }
            } 
        }
    }
}