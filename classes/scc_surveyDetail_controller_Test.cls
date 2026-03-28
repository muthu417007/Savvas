@isTest
public class scc_surveyDetail_controller_Test {
    @isTest
    public static void getSurveyInvitationLinkTest(){
        String surveyLink = scc_surveyDetail_controller.getSurveyInvitationLink();
        System.assertNotEquals(null,surveyLink);
    }

}