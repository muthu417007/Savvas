/**************************************************************************************** 
* @Class Name  - scc_documents_RADAR_Controller_Test
* @description - Test class for scc_documents_RADAR_Controller
* @Created By  - Vaibhav Saptal (Cognizant)
* @Created On - 2024-06-08
* ***************************************************************************************/ 
@istest
public class scc_documents_RADAR_Controller_Test {
/**
*  Description: test Class Method for all the methods of scc_documents_RADAR_Controller
*  @name: testClassMethod
*  @param:No parameters.
*  @return:No return
*  @throws exception- 
*/     
    @isTest
    static void testClassMethod(){
        Account acc= scc_TestDataFactory.accountCreation('testAccount4');
        Contact con = scc_TestDataFactory.contactCreation( acc.Id, 'firstname4', 'testlastname4', 'testemail1@abc.com');
        Contact con1 = scc_TestDataFactory.contactCreation( acc.Id, 'firstname4', 'testlastname4', 'testemail1@abc.com');
        Profile pd2 = [Select id From profile where name = 'MySavvasOrders Profile' limit 1]; 
        Profile pd1 = [Select id From profile where name = 'Savvas External Users Base Profile' limit 1]; 
        
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
        
        test.startTest();
        Map<String, String> requestData = new Map<String, String>{'documentNumber' => '10000', 'opeartion' => 'Invoice','emailId' =>'','Combined' =>'N','IncludePOD' =>'N','accountNumber' =>'','month' => '','year'=>''};
        Map<String, String> requestData1 = new Map<String, String>{'documentNumber' => '10000', 'opeartion' => 'Invoice & Proof of Delivery (if available)','emailId' =>'','Combined' =>'N','IncludePOD' =>'N','accountNumber' =>'','month' => '','year'=>''};
        Map<String, String> requestData2 = new Map<String, String>{'documentNumber' => '10000', 'opeartion' => 'Proof of Delivery (if available)','emailId' =>'','Combined' =>'N','IncludePOD' =>'N','accountNumber' =>'','month' => '','year'=>''};
        Map<String, String> requestData3 = new Map<String, String>{'documentNumber' => '10000', 'opeartion' => 'Debit Memo','emailId' =>'','Combined' =>'N','IncludePOD' =>'N','accountNumber' =>'','month' => '','year'=>''};
        Map<String, String> requestData4 = new Map<String, String>{'documentNumber' => '10000', 'opeartion' => 'Credit Memo','emailId' =>'','Combined' =>'N','IncludePOD' =>'N','accountNumber' =>'','month' => '','year'=>''};
        Map<String, String> requestData5 = new Map<String, String>{'documentNumber' => '10000', 'opeartion' => 'Statement','emailId' =>'','Combined' =>'N','IncludePOD' =>'N','accountNumber' =>'123345','month' => 'January','year'=>'Current year'};
        Map<String, String> requestData6 = new Map<String, String>{'documentNumber' => '10000', 'opeartion' => 'Statement','emailId' =>'','Combined' =>'N','IncludePOD' =>'N','accountNumber' =>'123345','month' => 'January','year'=>'Last year'};
        Map<String, String> requestData7 = new Map<String, String>{'documentNumber' => '10000', 'opeartion' => 'Statement','emailId' =>'','Combined' =>'N','IncludePOD' =>'N','accountNumber' =>'123345','month' => 'January','year'=>'Prior year'};

 
      
        Test.setMock(HttpCalloutMock.class,new RadarOAuthMock());
        Test.setMock(HttpCalloutMock.class,new RadarResponseMock());
		System.assertNotEquals(null,scc_documents_RADAR_Controller.generateRADARRequest(requestData));
        System.assertNotEquals(null,scc_documents_RADAR_Controller.generateRADARRequest(requestData1));
        System.assertNotEquals(null,scc_documents_RADAR_Controller.generateRADARRequest(requestData2));
        System.assertNotEquals(null,scc_documents_RADAR_Controller.generateRADARRequest(requestData3));
        System.assertNotEquals(null,scc_documents_RADAR_Controller.generateRADARRequest(requestData4));
        System.assertNotEquals(null,scc_documents_RADAR_Controller.generateRADARRequest(requestData5));
        System.assertNotEquals(null,scc_documents_RADAR_Controller.generateRADARRequest(requestData6));
        System.assertNotEquals(null,scc_documents_RADAR_Controller.generateRADARRequest(requestData7));
   		
        System.runAs(testUser1) {
            Test.setMock(HttpCalloutMock.class,new RadarOAuthMock());
            Test.setMock(HttpCalloutMock.class,new RadarResponseMock());
            System.assertNotEquals(null,scc_documents_RADAR_Controller.generateRADARRequest(requestData));
            System.assertNotEquals(null,scc_documents_RADAR_Controller.generateRADARRequest(requestData1));
            System.assertNotEquals(null,scc_documents_RADAR_Controller.generateRADARRequest(requestData2));
            System.assertNotEquals(null,scc_documents_RADAR_Controller.generateRADARRequest(requestData3));
            System.assertNotEquals(null,scc_documents_RADAR_Controller.generateRADARRequest(requestData4));
            System.assertNotEquals(null,scc_documents_RADAR_Controller.generateRADARRequest(requestData5));
            System.assertNotEquals(null,scc_documents_RADAR_Controller.generateRADARRequest(requestData6));
            System.assertNotEquals(null,scc_documents_RADAR_Controller.generateRADARRequest(requestData7));
        }
        
        System.runAs(testUser2) {
            Test.setMock(HttpCalloutMock.class,new RadarOAuthMock());
            Test.setMock(HttpCalloutMock.class,new RadarResponseMock());
            System.assertNotEquals(null,scc_documents_RADAR_Controller.generateRADARRequest(requestData));
            System.assertNotEquals(null,scc_documents_RADAR_Controller.generateRADARRequest(requestData1));
            System.assertNotEquals(null,scc_documents_RADAR_Controller.generateRADARRequest(requestData2));
            System.assertNotEquals(null,scc_documents_RADAR_Controller.generateRADARRequest(requestData3));
            System.assertNotEquals(null,scc_documents_RADAR_Controller.generateRADARRequest(requestData4));
            System.assertNotEquals(null,scc_documents_RADAR_Controller.generateRADARRequest(requestData5));
            System.assertNotEquals(null,scc_documents_RADAR_Controller.generateRADARRequest(requestData6));
            System.assertNotEquals(null,scc_documents_RADAR_Controller.generateRADARRequest(requestData7));
        }
        
        test.stopTest();
    }
/**
*  Description: testClassMethod to cover exceptions of generateRADARRequest and performRADARCallout   
*  @name: getRadarTest_Exception
*  @param:No parameters.
*  @return:No return
*  @throws exception- 
*/      
    @isTest
    static void getRadarTest_Exception() {
        Test.startTest();
        try {
            scc_documents_RADAR_Controller.generateRADARRequest(null);           
        } catch (AuraHandledException e) {
            System.assertEquals(e.getMessage().contains('abcd'), false);
        }
        try {
            scc_documents_RADAR_Controller abc = new scc_documents_RADAR_Controller();
            abc.performRADARCallout(null);           
        } catch (AuraHandledException e) {
            System.assertEquals(e.getMessage().contains('abcd'), false);
        }        
        Test.stopTest();
    }    
    
    
        //Mock class for OAuth token response
    public class RadarOAuthMock implements HttpCalloutMock
    {
        public HttpResponse respond(HttpRequest req)
        {
            HttpResponse res =new HttpResponse();
            res.setHeader('Content-Type','application/json');
            res.setBody('{"access_token":"5cMTjfHO5ZkM_6hACm_RkE5cljwSu0VjHvjnkvU5qLfCUpUeDoSSJuZqQNbR5C8-nk8zpqwxdSST2efM6aX7R8rUwOguWFKwHoZ0fr25YFDnVGba8KFjm0-XIrmJJVic-s7Fd0sq1kajHlQTd6S5e9pBj5IpueCin3t8W-j5oZVke6A0v3tGYGqumEHIi-mmPhHQps8C2XIXiUivA2YWSYyaxkc9Fw5yJx5APbraWyChQpWjug9mY5FPBudVZk2aP9-6wCUG2BaL2Uw-wyQoYohDhDKQggjaSRyuQRO7BxM","token_type":"bearer","expires_in":119}');
            res.setStatusCode(200);
            return res;
            
        }
    }
    
        //Mock class for Radar traking response
    public class RadarResponseMock implements HttpCalloutMock
    {
        public HttpResponse respond(HttpRequest req)
        {
           HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"DocumentNumber":"4027015275","DocType":"02","DocumentDate":"2023-08-04","Filename":"4027015275_Invoice_2023-08-04.pdf","Filestreams":"asdfghjkk","PODFilename":null,"PODFilstreams":null,"Message":null}');
            res.setStatusCode(200);
            return res;
            
        }
    }
    
    
}