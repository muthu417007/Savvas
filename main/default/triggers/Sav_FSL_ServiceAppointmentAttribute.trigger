/**
* Author: Cognizant Team
* Description: handle all the events of the Service Appointment Attribute object
* Date Created: 17-06-2023
* Version: 1.0
*/

trigger Sav_FSL_ServiceAppointmentAttribute on Service_Appointment_Attributes__c (after insert) {
    // To bypass trigger code
    Bypass_Setting__c bypass=Bypass_Setting__c.getInstance();
    if(bypass.Disable_Triggers__c == false ){
        if(Trigger.isAfter && Trigger.isInsert) {
            Sav_FSL_ServiceAppointmentAttrHandler.handleAfterInsert(trigger.new);
        }
    }
}