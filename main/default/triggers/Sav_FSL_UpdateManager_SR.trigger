/*W-013853 : To update Service resource's Manager picklist field(custom picklist used to show on gantt chart) 
* Author: Cognizant Team
* Description: handle before insert & before update events of the Service Resource object
* Date Created: 2 FEB 2024
* Version: 1.0
*/
trigger Sav_FSL_UpdateManager_SR on ServiceResource (before insert,before update) {
    // To bypass trigger code
    Bypass_Setting__c bypass=Bypass_Setting__c.getInstance(); 
    if(bypass.Disable_Triggers__c == false){  
        if(trigger.isBefore && trigger.isInsert || trigger.isBefore && trigger.isUpdate){
        Sav_FSL_UpdateManagerHandler_SR.updateServiceResource(trigger.New);
    }
    }
}