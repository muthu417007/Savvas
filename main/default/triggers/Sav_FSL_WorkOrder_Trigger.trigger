/**
* Author: Cognizant Team
* Description: handle all the events of the WorkOrder object
* Date Created: 27-03-2023
* Version: 1.0
*/

trigger Sav_FSL_WorkOrder_Trigger on WorkOrder (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    // To bypass trigger code
    Bypass_Setting__c bypass=Bypass_Setting__c.getInstance();
    if(bypass.Disable_Triggers__c == false){
     
         if(Trigger.isAfter && Trigger.isInsert) {
        Sav_FSL_WorkOrderTriggerHandler.onAfterInsert(trigger.new);
    }
    }
}