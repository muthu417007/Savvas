/**
 * @description       : Controller for handling the Query of the Custom Action 'Add Products'
 * @author            : Ryan Schmitt
 * @group             : 
 * @last modified on  : 08-17-2022
 * @last modified by  : Ryan Schmitt
 * Modifications Log
 * Ver   Date         Author         Modification
 * 1.0   08-09-2022   Ryan Schmitt   Initial Version
**/
public class openWebPageController {
    @AuraEnabled
    //Query to find the Custom Action in CPQ called 'Add Products'.  This will be used to dynamically grab the custom action ID for Quote Creation Flow
    public static Id getCustomAction() {
        SBQQ__CustomAction__c customAction;
        customAction = [SELECT Id FROM SBQQ__CustomAction__c WHERE Name = 'Add Products' LIMIT 1];
        return customAction.Id;
    }
}