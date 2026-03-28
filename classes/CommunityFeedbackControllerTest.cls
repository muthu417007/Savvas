@isTest
private class CommunityFeedbackControllerTest {

    static testMethod void myUnitTest() {

        PageReference pr = Page.CommunitiesFeedback;
        Test.setCurrentPage(pr);   
            	
    	ApexPages.StandardController ctrl = new ApexPages.StandardController(new Community_Feedback__c());
        CommunityFeedbackController ctl = new CommunityFeedbackController(ctrl );
        // error - some field must be completed
        ctl.save();
        ctl.fbInfo.Suggestions__c = 'test';
        ctl.save();
    	
    }
}