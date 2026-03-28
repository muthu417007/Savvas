/**************************************************************************************** 
* @Class Name  - scc_fedExTrackingServiceTest
* @description - class to perform API callout and get response data
* @Reason - test class for scc_fedExTrackingService
* @Created By  - CTS-Varshaa
* @Created On - 2024-05-31
* ***************************************************************************************/ 
@isTest
public class scc_fedExTrackingServiceTest {
/**
*  Description: This method is testmethod for getTrackingDetails apex method      
*  @name: getTrackingDetailsTest
*  @param: NA
*  @return: NA
*  @throws exception- NA
*/    
    @isTest
    static void getTrackingDetailsTest(){
        Account acc= scc_TestDataFactory.accountCreation('testAccount4');
        Contact con = scc_TestDataFactory.contactCreation( acc.Id, 'firstname4', 'testlastname4', 'testemail1@abc.com');
        Contact con1 = scc_TestDataFactory.contactCreation( acc.Id, 'firstname4', 'testlastname4', 'testemail1@abc.com');
        Profile pd2 = [Select id From profile where name = :scc_constantHelper.MY_SAVVAS_ORDERS_PROFILE limit 1]; 
        Profile pd1 = [Select id From profile where name = :scc_constantHelper.SAVVAS_EXTERNAL_USERS_BASE_PROFILE limit 1]; 
        
        List<User> usr = new List<User>();
        User testUser1 = new User();
        testUser1.ProfileId=pd2.Id;          
        testUser1.LastName = 'Test User';
        testUser1.Email = 'testuser@example.com';
        testUser1.Username = 'testuser@example.com' + System.currentTimeMillis();
        testUser1.Alias = 'tuser';
        testUser1.TimeZoneSidKey = 'America/Los_Angeles';
        testUser1.LocaleSidKey = 'en_US';
        testUser1.EmailEncodingKey = 'UTF-8';
        testUser1.LanguageLocaleKey = 'en_US';
        usr.add(testUser1);
        
        User testUser2 = new User();
        testUser2.ProfileId=pd1.Id;          
        testUser2.LastName = 'Test User';
        testUser2.Email = 'testuser@example.com';
        testUser2.Username = 'testuser1@example.com' + System.currentTimeMillis();
        testUser2.Alias = 'tuser';
        testUser2.TimeZoneSidKey = 'America/Los_Angeles';
        testUser2.LocaleSidKey = 'en_US';
        testUser2.EmailEncodingKey = 'UTF-8';
        testUser2.LanguageLocaleKey = 'en_US';
        testUser2.ContactId = con1.Id;
        usr.add(testUser2);
        insert usr;
        
        Test.startTest();
        String testTrackingId = '641434655270';   			
        Test.setMock(HttpCalloutMock.class,new FedExOAuthMock());
        Test.setMock(HttpCalloutMock.class,new FedExTrackingMock());
        String response = scc_fedExTrackingService.getTrackingDetails(testTrackingId);
        System.assertNotEquals(testTrackingId, null,'test');
        
        System.runAs(testUser1) {
            String testTrackingId1 = '6414346552701';   			
            Test.setMock(HttpCalloutMock.class,new FedExOAuthMock());
            Test.setMock(HttpCalloutMock.class,new FedExTrackingMock());
            String response1 = scc_fedExTrackingService.getTrackingDetails(testTrackingId1);
            System.assertNotEquals(testTrackingId1, null,'test');
        }
        
        System.runAs(testUser2) {
            String testTrackingId2 = '6414346552701';   			
            Test.setMock(HttpCalloutMock.class,new FedExOAuthMock());
            Test.setMock(HttpCalloutMock.class,new FedExTrackingMock());
            String response2 = scc_fedExTrackingService.getTrackingDetails(testTrackingId2);
            System.assertNotEquals(testTrackingId2, null,'test');
        }
        
        Test.stopTest();
        
    }
    
    //Mock class for OAuth token response
    public class FedExOAuthMock implements HttpCalloutMock
    {
        public HttpResponse respond(HttpRequest req)
        {
            HttpResponse res =new HttpResponse();
            res.setHeader('Content-Type','application/json');
            res.setBody('{"access_token":"test_access_token","token_type":"bearer","expires_in":3600}');
            res.setStatusCode(200);
            return res;
            
        }
    }
    //Mock class for FedEx traking response
    public class FedExTrackingMock implements HttpCalloutMock
    {
        public HttpResponse respond(HttpRequest req)
        {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"transactionId": "12345", "output": {"completeTrackResults": [{"trackResults": [{"trackingNumber": "123456789012", "statusDetail": {"description": "Shipment information sent to FedEx"}}]}]}}');
            if(req.getBody().contains('641434655270')){
                res.setStatusCode(200); 
            }else{
                res.setStatusCode(400);  
            }
            return res;
            
        }
    }
/**
*  Description: This method is testmethod for getTrackingDetails apex method      
*  @name: testGetTrackingDetailsSuccess
*  @param: NA
*  @return: NA
*  @throws exception- NA
*/    
    @isTest
    static void testGetTrackingDetailsSuccess() {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(200, '{"trackingInfo":[{"trackingNumberInfo":{"trackingNumber":"12345"}}]}'));
        String result = scc_fedExTrackingService.getTrackingDetails('12345');
        System.assertNotEquals(null, result);
        System.assert(result.contains('trackingNumber'));
    }
    
/**
*  Description: This method is testmethod for getTrackingDetails apex method      
*  @name: testGetTrackingDetailsError
*  @param: NA
*  @return: NA
*  @throws exception- NA
*/
    @isTest
    static void testGetTrackingDetailsError() {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(500, 'Internal Server Error'));
        try {
            String result = scc_fedExTrackingService.getTrackingDetails('12345');
        } catch (AuraHandledException e) {
            System.assert(e.getMessage().contains('Failed to get fedex data'));
        }
    }
    
    private class MockHttpResponseGenerator implements HttpCalloutMock {
        private Integer statusCode;
        private String responseBody;
        public MockHttpResponseGenerator(Integer statusCode, String responseBody) {
            this.statusCode = statusCode;
            this.responseBody = responseBody;
        }
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(statusCode);
            res.setBody(responseBody);
            return res;
        }
    }        
}