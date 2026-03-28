/*
 *  Author: Salesforce Services
 *  Description: Trigger on Case
 */
trigger CaseTrigger on Case (before insert, before update) {
  if(Trigger.isBefore && Trigger.isInsert) {
    // Article attachment validation is no longer required by the business so commenting out the code
    //CaseTriggerHandler.handleBeforeInsert(Trigger.new);
  }
  if(Trigger.isBefore && Trigger.isUpdate) {
    //CaseTriggerHandler.handleBeforeUpdate(Trigger.old,Trigger.new);
  }
  
  /* else if(Trigger.isAfter && Trigger.isUpdate) {
    CaseTriggerHandler.handleAfterInsert(Trigger.old,Trigger.new);
  }*/
}