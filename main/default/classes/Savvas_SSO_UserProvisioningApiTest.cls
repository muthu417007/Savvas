/*
    @Author : Cognizant Team
    @Name : Savvas_SSO_UserProvisioningApiTest
    @CreateDate : 13-June-2024
    @Description: This class is a test class for Savvas_SSO_UserProvisioningApi
    @ModifiedBy: Cognizant Team
    @ModifiedDate: 02-July-2024
    @Ticket Number: W-014598
*/
@isTest
public class Savvas_SSO_UserProvisioningApiTest {
    
    
    //User registration failed - duplicate access
    @isTest
    static void testExistingUserUpdateAccess1() {
        
        
        Savvas_SSO_TestDataFactory factory = new Savvas_SSO_TestDataFactory();
            Account testAccount = factory.createAccount();
            Contact testContact = factory.createContact(testAccount.Id);
        	User portalUser = factory.createPortalUser(testContact);
            factory.createPSAssignment(portalUser);
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestUri = '/services/apexrest/ssoUserProvisioning';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{"firstName":"Test","lastName":"Test0","email":"testUser@test.com","accountId":"' + testAccount.Id + '", "appName":"Worktext_Subscription"}');
        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        Savvas_SSO_UserProvisioningApi.postSSOUserProvisioningRequest();
        Test.stopTest();

        String responseBody = res.responseBody.toString();
        Savvas_SSO_UserProvisioningApi.APIResponseBody responseDetails = (Savvas_SSO_UserProvisioningApi.APIResponseBody)JSON.deserialize(responseBody, Savvas_SSO_UserProvisioningApi.APIResponseBody.class);
        System.debug(responseBody);
        System.assertNotEquals(null, responseBody);
        System.assertEquals(3, responseDetails.statusCode);
    }
    
    //Contact not found
    @isTest
    static void testExistingUserUpdateAccess2() {
        
        Savvas_SSO_TestDataFactory factory = new Savvas_SSO_TestDataFactory();
            Account testAccount = factory.createAccount();
            Contact testContact = factory.createContact(testAccount.Id);
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestUri = '/services/apexrest/ssoUserProvisioning';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{"firstName":"Test","lastName":"Test0","email":"testUser@test.com","accountId":"", "appName":"Worktext_Subscription"}');
        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        Savvas_SSO_UserProvisioningApi.postSSOUserProvisioningRequest();
        Test.stopTest();

        String responseBody = res.responseBody.toString();
        Savvas_SSO_UserProvisioningApi.APIResponseBody responseDetails = (Savvas_SSO_UserProvisioningApi.APIResponseBody)JSON.deserialize(responseBody, Savvas_SSO_UserProvisioningApi.APIResponseBody.class);
        System.debug(responseBody);
        System.assertNotEquals(null, responseBody);
        System.assertEquals(2, responseDetails.statusCode);
    }
    
    //User Registration Success
    @isTest
    static void testExistingUserUpdateAccess3() {
        
        Savvas_SSO_TestDataFactory factory = new Savvas_SSO_TestDataFactory();
            User runAsUser = factory.createUser();
        System.runAs(runAsUser){
             Account testAccount = factory.createAccount();
             Contact testContact = factory.createContact(testAccount.Id);
             User portalUser = factory.createPortalUser(testContact);
                          
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestUri = '/services/apexrest/ssoUserProvisioning';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{"firstName":"Test","lastName":"Test0","email":"testUser@test.com","accountId":"' + testAccount.Id + '", "appName":"Worktext_Subscription"}');
        RestContext.request = req;
        RestContext.response = res;
        
            Test.startTest();
            Savvas_SSO_UserProvisioningApi.postSSOUserProvisioningRequest();
            Test.stopTest();
        
        String responseBody = res.responseBody.toString();
        Savvas_SSO_UserProvisioningApi.APIResponseBody responseDetails = (Savvas_SSO_UserProvisioningApi.APIResponseBody)JSON.deserialize(responseBody, Savvas_SSO_UserProvisioningApi.APIResponseBody.class);
        System.debug(responseBody);
        System.assertNotEquals(null, responseBody);
        System.assertEquals(1, responseDetails.statusCode);
        }
    }
    
    //no contact found
    @isTest
    static void testNewUserRegistration() {
        
        Savvas_SSO_TestDataFactory factory = new Savvas_SSO_TestDataFactory();
        	User newUser = factory.createUser();
        System.runAs(newUser){
            Account testAccount = factory.createAccount();
            Contact testContact = factory.createContact(testAccount.Id);
            //User testUser = factory.createUser(testContact.Id);
            factory.createSavvasCustomSetting();
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestUri = '/services/apexrest/ssoUserProvisioning';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{"firstName":"Test","lastName":"Test0","email":"test1@cognizant.com","accountId":"' + testAccount.Id + '","appName":"Worktext_Subscription"}');
        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        Savvas_SSO_UserProvisioningApi.postSSOUserProvisioningRequest();
        Test.stopTest();

        String responseBody = res.responseBody.toString();
        Savvas_SSO_UserProvisioningApi.APIResponseBody responseDetails = (Savvas_SSO_UserProvisioningApi.APIResponseBody)JSON.deserialize(responseBody, Savvas_SSO_UserProvisioningApi.APIResponseBody.class);
        System.debug(responseBody);
        System.assertNotEquals(null, responseBody);
        System.assertEquals(2, responseDetails.statusCode);
        }
    }
    
    //new user registration
    @isTest
    static void testNewUserRegistration1() {
        
        Savvas_SSO_TestDataFactory factory = new Savvas_SSO_TestDataFactory();
        	User newUser = factory.createUser();
        System.runAs(newUser){
            Account testAccount = factory.createAccount();
            Contact testContact = factory.createContact(testAccount.Id);
            //User testUser = factory.createUser(testContact.Id);
            factory.createSavvasCustomSetting();
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestUri = '/services/apexrest/ssoUserProvisioning';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{"firstName":"Test","lastName":"Test0","email":"test@cognizant.com","accountId":"' + testAccount.Id + '","appName":"Worktext_Subscription"}');
        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        Savvas_SSO_UserProvisioningApi.postSSOUserProvisioningRequest();
        Test.stopTest();

        String responseBody = res.responseBody.toString();
        Savvas_SSO_UserProvisioningApi.APIResponseBody responseDetails = (Savvas_SSO_UserProvisioningApi.APIResponseBody)JSON.deserialize(responseBody, Savvas_SSO_UserProvisioningApi.APIResponseBody.class);
        System.debug(responseBody);
        System.assertNotEquals(null, responseBody);
        System.assertEquals(1, responseDetails.statusCode);
        }
    }
    //exception
    @isTest
    static void testUnhandledException() {
        Savvas_SSO_TestDataFactory factory = new Savvas_SSO_TestDataFactory();
            Account testAccount = factory.createAccount();
            Contact testContact = factory.createContact(testAccount.Id);
            User portalUser = factory.createPortalUser(testContact);
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestUri = '/services/apexrest/ssoUserProvisioning';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{"firstName":testUser.firstName,"lastName":testUser,lastName,"email":testUser.email,"accountId":"", "appName":"Worktext_Subscription"}');
        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        Savvas_SSO_UserProvisioningApi.postSSOUserProvisioningRequest();
        Test.stopTest();

        String responseBody = res.responseBody.toString();
        Savvas_SSO_UserProvisioningApi.APIResponseBody responseDetails = (Savvas_SSO_UserProvisioningApi.APIResponseBody)JSON.deserialize(responseBody, Savvas_SSO_UserProvisioningApi.APIResponseBody.class);
        System.debug(responseBody);
        System.assertNotEquals(null, responseBody);
		System.assertEquals(null, responseDetails.statusCode);
    }
    
}