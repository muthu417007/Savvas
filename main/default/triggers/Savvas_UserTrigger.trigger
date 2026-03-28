/*W-013853 : To update Service resource's Manager picklist field(custom picklist used to show on gantt chart) 
* Author: Cognizant Team
* Description: handle after insert & after update events of the User object
* Date Created: 15 FEB 2024
* Date Modified: 12-08-2024
* Version: 1.0
*/
trigger Savvas_UserTrigger on User (before insert, before update, after insert, after update) {
    // To bypass trigger code
    Bypass_Setting__c bypass = Bypass_Setting__c.getInstance();     
    if (bypass.Disable_Triggers__c == false) {  
        if (trigger.isBefore && trigger.isInsert) {
            Savvas_SSO_FederationIdUtility.setFederationId(trigger.new);
        }
        if (trigger.isBefore && trigger.isUpdate) {
            Savvas_SSO_FederationIdUtility.updateFederationId(trigger.new);
        }
        if (trigger.isAfter && (trigger.isInsert || trigger.isUpdate)) {
            Sav_FSL_UpdateManagerHandler.updateServiceResource(trigger.newMap);
        }
    }
    
        /****************************************************************************************
		* @description - Trigger to send welcome email if SFCC user was created by internal admin
        * @Created By  - CTS-Muthukumar
        * @Created On - 2024-10-30
        * ***************************************************************************************/ 
        if(trigger.isAfter && trigger.isInsert){
            scc_sendWelcomeEmail.sendWelcomeEmailNewUser(Trigger.new);     
        }
}