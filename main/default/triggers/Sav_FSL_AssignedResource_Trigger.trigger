/**
* Author: Cognizant Team
* Description: handle all the events of the AssignedResource object
* Date Created: 27-03-2023
* Version: 1.0
*/

trigger Sav_FSL_AssignedResource_Trigger on AssignedResource (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    
    // To bypass trigger code
    Bypass_Setting__c bypass=Bypass_Setting__c.getInstance();
    if(bypass.Disable_Triggers__c == false){
        
    if(trigger.isAfter && trigger.isInsert){
        Sav_FSL_AssignedResource_TriggerHandler.onAfterInsert(trigger.new);
    }
    
    else if(trigger.isafter && trigger.isdelete){
        Sav_FSL_AssignedResource_TriggerHandler.onAfterDelete(trigger.old);
    }
    
    if(Trigger.isAfter && Trigger.isUpdate){
        Sav_FSL_AssignedResource_TriggerHandler.onAfterUpdate(trigger.new, trigger.OldMap);
    }
    }
}