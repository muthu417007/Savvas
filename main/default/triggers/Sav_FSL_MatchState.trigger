/*W-013853 : To update Service resource's State picklist field(custom picklist used to show on gantt chart) based on the ServiceTerritporyMember records
* Author: Cognizant Team
* Description:  handle after insert & after update events of the ServiceTerritoryMember object
* Date Created: 2 FEB 2024
* Version: 1.0
*/
trigger Sav_FSL_MatchState on ServiceTerritoryMember (after insert, after update) {
    // To bypass trigger code
    Bypass_Setting__c bypass=Bypass_Setting__c.getInstance(); 
    if(bypass.Disable_Triggers__c == false){     
    if(trigger.isAfter && trigger.isInsert || trigger.isAfter && trigger.isUpdate){
        Sav_FSL_MatchStateHandler.updateServiceResource(trigger.new);
    }
    }
}