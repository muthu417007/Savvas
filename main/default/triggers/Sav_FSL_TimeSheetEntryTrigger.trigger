/**
* Author: Cognizant Team
* Description: handle all the events of the Service Appointment object
* Date Created: 27-03-2023
* Version: 1.0
*/
trigger Sav_FSL_TimeSheetEntryTrigger on TimeSheetEntry (before insert,before update) {
     // if(trigger.isbefore && trigger.isInsert){
     // To bypass trigger code
    Bypass_Setting__c bypass=Bypass_Setting__c.getInstance();
    if(bypass.Disable_Triggers__c == false){
        Sav_FSL_TimeSheetEntryTriggerHandler.beforeInsert(trigger.new);
   // }
    }
}