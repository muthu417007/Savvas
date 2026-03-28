/*
*********************************************************
Class Name       : SbqqQuoteTrigger
Created Date     : 6/10/2024  
Author           : Frank Berni - Cognizant
Description      : Trigger for the SBQQ__Quote__c object

History:
<Date>          <Authors Name>              <Brief Description of Change>
6/10/2024       Frank Berni                 Initial creation: Ticket W-014653 
**********************************************************/
trigger SbqqQuoteTrigger on SBQQ__Quote__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {

    // After Update context
    if(Trigger.isAfter && Trigger.isUpdate) {
        SbqqQuoteTriggerHandler.afterUpdateMethod(Trigger.new, Trigger.oldMap);
    }

}