/*
*********************************************************
Class Name       : Sbqq_QuoteLine_Trigger
Created Date     : 12/02/2024  
Author           : Brent Mac - Cognizant
                   Frank Berni - Cognizant
Description      : Trigger for the SBQQ__QuoteLine__c object

History:
<Date>          <Authors Name>              <Brief Description of Change>
12/02/2024       Brent Mac                   Initial creation: Ticket W-016653 
**********************************************************/
trigger Sbqq_QuoteLine_Trigger on SBQQ__QuoteLine__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {

        if(Trigger.isBefore && Trigger.isDelete) {
            // Calls handler to prevent non-admin users from deleting quote lines when quote is not in "Draft" status
            Sbqq_QuoteLine_TriggerHandler.beforeDeleteMethod(Trigger.old);
        }
        
}