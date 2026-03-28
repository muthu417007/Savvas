@isTest
public class TestCDSupportFlowController {
    
    static testMethod void testGetScreenName(){
        PageReference pageRef = Page.CDSupportFlowPublic;
        Test.setCurrentPage(pageRef);
        CDSupportFlowController cdSupportFlowController = 
            new CDSupportFlowController();
        // There is no way now to initiate a flow from apex - hence it is not possible to test the not null situation for myflow variable.
        System.assertEquals(cdSupportFlowController.getScreenName(), '');
    }

}