/*
    @Author : Cognizant Team
    @Name : Savvas_SSO_AccountsSearchApiTest
    @CreateDate : 08-June-2024
    @Description: This class is a test class for Savvas_SSO_AccountsSearchApi
    @ModifiedBy: Cognizant Team
    @ModifiedDate: 02-July-2024
    @Ticket Number: W-014598
*/
@isTest
public class Savvas_SSO_AccountsSearchApiTest { 
    
    //contactList is empty
    @isTest
    public static void postSSOAccountsApiRequestTest1() {
        Savvas_SSO_TestDataFactory factory = new Savvas_SSO_TestDataFactory();
        Account testAccount = factory.createAccountwithShipAddress();
        testAccount.Account_Status__c = 'Active';
        update testAccount;
        Contact testContact = factory.createContact(testAccount.Id);
        testContact.UCID__c = 'test';
        testContact.Inactive__c = false;
        update testContact;
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestUri = '/services/apexrest/ssoAccountsSearch';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{"email":"testUser@test.com", "appName":"WktxtSub"}');
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        Savvas_SSO_AccountsSearchApi.postSSOAccountsApiRequest();
        Test.stopTest();
        
        String responseBody = res.responseBody.toString();
        Savvas_SSO_AccountsSearchApi.APIResponseBody responseDetails = (Savvas_SSO_AccountsSearchApi.APIResponseBody)JSON.deserialize(responseBody, Savvas_SSO_AccountsSearchApi.APIResponseBody.class);
        System.debug(responseBody);
        System.assertNotEquals(null, responseBody);
        System.assertEquals(0, responseDetails.statusCode);
    }
    
    //contactList is not empty
    @isTest
    public static void postSSOAccountsApiRequestTest2() {
        Savvas_SSO_TestDataFactory factory = new Savvas_SSO_TestDataFactory();
        Account testAccount = factory.createAccountwithShipAddress();
        testAccount.Account_Status__c = 'Active';
        update testAccount;
        Contact testContact = factory.createContact(testAccount.Id);
        testContact.UCID__c = 'test';
        testContact.Inactive__c = false;
        update testContact;
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestUri = '/services/apexrest/ssoAccountsSearch';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{"email":"test@cognizant.com", "appName":"WktxtSub"}');
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        Savvas_SSO_AccountsSearchApi.postSSOAccountsApiRequest();
        Test.stopTest();
        
        String responseBody = res.responseBody.toString();
        Savvas_SSO_AccountsSearchApi.APIResponseBody responseDetails = (Savvas_SSO_AccountsSearchApi.APIResponseBody)JSON.deserialize(responseBody, Savvas_SSO_AccountsSearchApi.APIResponseBody.class);
        System.debug(responseBody);
        System.assertNotEquals(null, responseBody);
        System.assertEquals(1, responseDetails.statusCode);
    }
    
    //exception in Savvas_SSO_AccountsSearchApi
    @isTest
    public static void postSSOAccountsApiRequestTest3() {
        Savvas_SSO_TestDataFactory factory = new Savvas_SSO_TestDataFactory();
            Account testAccount = factory.createAccountwithShipAddress();
            Contact testContact = factory.createContact(testAccount.Id);
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestUri = '/services/apexrest/ssoAccountsSearch';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{"email":null, "appName":"WktxtSub"}');
        RestContext.request = req;
        RestContext.response = res;
        
        try{
            Test.startTest();
            Savvas_SSO_AccountsSearchApi.postSSOAccountsApiRequest();
            Test.stopTest();
        }
        catch(Exception e) {
            system.debug(e);
        }
        
        String responseBody = res.responseBody.toString();
        Savvas_SSO_AccountsSearchApi.APIResponseBody responseDetails = (Savvas_SSO_AccountsSearchApi.APIResponseBody)JSON.deserialize(responseBody, Savvas_SSO_AccountsSearchApi.APIResponseBody.class);
        System.debug(responseBody);
        System.assertNotEquals(null, responseBody);
        System.assertEquals(null, responseDetails.statusCode);
    }
    
    @isTest
    public static void postSSOAccountsApiRequestTest4() {
        Savvas_SSO_TestDataFactory factory = new Savvas_SSO_TestDataFactory();
        Account testAccount = factory.createAccountwithShipAddress();
        testAccount.Account_Status__c = 'Active';
        update testAccount;
        Contact testContact = factory.createContact(testAccount.Id);
        testContact.UCID__c = 'test';
        testContact.Inactive__c = false;
        update testContact;
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestUri = '/services/apexrest/ssoAccountsSearch';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{"email":"test@cognizant.com", "appName":"LICALL"}');
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        Savvas_SSO_AccountsSearchApi.postSSOAccountsApiRequest();
        Test.stopTest();
        
        String responseBody = res.responseBody.toString();
        Savvas_SSO_AccountsSearchApi.APIResponseBody responseDetails = (Savvas_SSO_AccountsSearchApi.APIResponseBody)JSON.deserialize(responseBody, Savvas_SSO_AccountsSearchApi.APIResponseBody.class);
        System.debug(responseBody);
        System.assertNotEquals(null, responseBody);
        System.assertEquals(0, responseDetails.statusCode);
    }
    
    @isTest
    public static void postSSOAccountsApiRequestTest5() {
        Savvas_SSO_TestDataFactory factory = new Savvas_SSO_TestDataFactory();
        Account testAccount = factory.createAccountwithShipAddress();
        testAccount.Account_Status__c = 'Active';
        update testAccount;
        Contact testContact = factory.createContact(testAccount.Id);
        testContact.UCID__c = 'test';
        testContact.Inactive__c = false;
        update testContact;
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestUri = '/services/apexrest/ssoAccountsSearch';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{"email":"test@cognizant.com", "appName":"test"}');
        RestContext.request = req;
        RestContext.response = res;
        
        try{
            Test.startTest();
            Savvas_SSO_AccountsSearchApi.postSSOAccountsApiRequest();
            Test.stopTest();
        }
        catch(Exception e) {
            System.debug(e.getMessage());
        }
        
        String responseBody = res.responseBody.toString();
        Savvas_SSO_AccountsSearchApi.APIResponseBody responseDetails = (Savvas_SSO_AccountsSearchApi.APIResponseBody)JSON.deserialize(responseBody, Savvas_SSO_AccountsSearchApi.APIResponseBody.class);
        System.debug(responseBody);
        System.assertNotEquals(null, responseBody);
        System.assertEquals(0, responseDetails.statusCode);
    }
    
    @isTest
    public static void postSSOAccountsApiRequestTest6() {
        Savvas_SSO_TestDataFactory factory = new Savvas_SSO_TestDataFactory();
        Account testAccount = factory.createAccountwithShipAddress();
        testAccount.Account_Status__c = 'Active';
        update testAccount;
        Contact testContact = factory.createContact(testAccount.Id);
        testContact.UCID__c = 'test';
        testContact.Inactive__c = false;
        update testContact;
        User testUser = factory.createPortalUser(testContact);
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestUri = '/services/apexrest/ssoAccountsSearch';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{"email":"testUser@test.com", "appName":"VS"}');
        RestContext.request = req;
        RestContext.response = res;
        
        try{
            Test.startTest();
            Savvas_SSO_AccountsSearchApi.postSSOAccountsApiRequest();
            Test.stopTest();
        }
        catch(Exception e) {
            System.debug(e.getMessage());
        }
        
        String responseBody = res.responseBody.toString();
        Savvas_SSO_AccountsSearchApi.APIResponseBody responseDetails = (Savvas_SSO_AccountsSearchApi.APIResponseBody)JSON.deserialize(responseBody, Savvas_SSO_AccountsSearchApi.APIResponseBody.class);
        System.debug(responseBody);
        System.assertNotEquals(null, responseBody);
        System.assertEquals(0, responseDetails.statusCode);
    }
}