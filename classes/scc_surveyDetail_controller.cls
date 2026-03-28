public class scc_surveyDetail_controller {
    @AuraEnabled
    public static string getSurveyInvitationLink(){
       	List<scc_survey_Details__mdt> surveyDetails = [select label, Is_Active__c from scc_survey_Details__mdt where Is_Active__c=true LIMIT 1];
        List<SurveyInvitation> SurveyInvitationList = [select InvitationLink from SurveyInvitation where community.Name='Savvas Single Sign On' and survey.Name=:surveyDetails[0].label LIMIT 1];
        if(!SurveyInvitationList.isEmpty()){
            return SurveyInvitationList[0].InvitationLink;
        }
        return null;
    }
}