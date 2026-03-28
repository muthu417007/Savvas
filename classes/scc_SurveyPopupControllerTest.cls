@isTest
public class scc_SurveyPopupControllerTest {
    
    @isTest
    static void testGetSurveyPopupVisibility() {
        // Query the custom metadata record
        scc_surveyModalVisibility__mdt settings = [
           SELECT scc_surveyModalVisibility__c FROM  scc_surveyModalVisibility__mdt LIMIT 1];
       

        // Check if we retrieved a record for testing
        System.assertNotEquals(null, settings, 'Expected to find a custom metadata record.');

        // Call the method being tested
        Boolean result = scc_SurveyPopupController.getSurveyPopupVisibility();

        // Assert that the returned value matches the expected value from the custom metadata
        System.assertEquals(settings.scc_surveyModalVisibility__c, result, 'The returned value should match the custom metadata value.');
    }
}