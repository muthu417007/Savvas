/*
@Author : Cognizant Team
@Name : Savvas_SSO_LandingPageControllerTest
@CreateDate : 04-June-2024
@Description: This class is test class for Savvas_SSO_LandingPageController
@ModifiedBy: Cognizant Team
@ModifiedDate: 04-June-2024
@Ticket Number: W-014599
*/
@isTest
public class Savvas_SSO_LandingPageControllerTest {
    
    /*
    *  Method Name : getUserAppAccessDataTest
    *  Description : test getUserAppAccessData method
    *  param : none
    *  return : none
    */   
    @isTest
    public static void getUserAppAccessDataTest() {
            Savvas_SSO_TestDataFactory factory = new Savvas_SSO_TestDataFactory();
            Account testAccount = factory.createAccount();
            Contact testContact = factory.createContact(testAccount.Id);
        	User portalUser = factory.createPortalUser(testContact);
            system.runAs(portalUser) {
                
               	factory.createCCPSAssignment(portalUser);
                
                Test.startTest();
                List<Savvas_SSO_LandingPageController.MetadataWrapper> result = Savvas_SSO_LandingPageController.getUserAppAccessData();
                System.assertNotEquals(null, result);
                System.assertEquals(1, result[0].appSequence);
                Test.stopTest();
            }
    }

}