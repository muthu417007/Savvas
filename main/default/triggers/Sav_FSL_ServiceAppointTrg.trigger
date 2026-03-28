/**
* Author: Cognizant Team
* Description: Updated 'convertTimesIntoCustomerTimeZone' as part of W-013515. 
               Update Customer Start date/End Date fields during record creation and update based on 
			   i) Scheduled Start/End date for Scheduled or Completed status.
			   ii) Earliest Start Permitted and Requested Delivery End Date for On Hold, Ready to Schedule, or Escalated status
* Date Updated: 27-09-2023
* Version: 1.1

* Author: Cognizant Team
* Description: handle all the events of the Service Appointment object
* Date Created: 27-03-2023
* Version: 1.0
*/

trigger Sav_FSL_ServiceAppointTrg on ServiceAppointment (after insert, after update, before update,before insert) {
    // To bypass trigger code
    Bypass_Setting__c bypass=Bypass_Setting__c.getInstance(); 
    if(bypass.Disable_Triggers__c == false){  
    if(trigger.isAfter && trigger.isInsert){
        Sav_FSL_ServiceApptTriggerHandlercls.afterInsert(trigger.new);
        Sav_FSL_ServiceApptTriggerHandlercls.convertTimesIntoCustomerTimeZone(trigger.new);
    }
    if(trigger.isAfter && trigger.isUpdate){
        Sav_FSL_ServiceApptTriggerHandlercls.afterUpdateOnSA(trigger.new, trigger.OldMap);
    }
    //W-013515 changes starts
    if(trigger.isBefore && trigger.isInsert){
        Sav_FSL_ServiceApptTriggerHandlercls.beforeInsertCustomerDatesUpdate(trigger.new);
    }
	if(trigger.isBefore && trigger.isUpdate){
		Sav_FSL_ServiceApptTriggerHandlercls.updateCustomerStartEndDate(trigger.new, trigger.OldMap);
	}
    //W-013515 changes ends
    }
    
}