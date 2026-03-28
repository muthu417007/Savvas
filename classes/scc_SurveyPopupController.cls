public  class scc_SurveyPopupController {

      @AuraEnabled
    public static Boolean getSurveyPopupVisibility() {
        // Query the Custom Metadata Type for SurveySettings__mdt
        scc_surveyModalVisibility__mdt settings = [SELECT scc_surveyModalVisibility__c FROM  scc_surveyModalVisibility__mdt LIMIT 1];
        
        // Return the value of Enable_Survey_Popup__c (true/false)
        return settings.scc_surveyModalVisibility__c;
    }
}