@isTest
public class scc_XiPayIntegrationTest {
    @isTest
    static void testSendPreAuthorizationRequest() {
        // Setup test data
        Map<String, String> tokenResponse = new Map<String, String>();
        tokenResponse.put('expYear', '2025');
        tokenResponse.put('expMonth', '12');
        tokenResponse.put('cardHolderName', 'John Smith');
        tokenResponse.put('cardType', 'VI');
        tokenResponse.put('tokenizedCardNumber', '1234567890123456');
        tokenResponse.put('securityCode', '123');

        Map<String, String> addressDetails = new Map<String, String>();
        addressDetails.put('currencyCode', 'USD');
        addressDetails.put('cardStreet', '123 Main St');
        addressDetails.put('cardCity', 'Anytown');
        addressDetails.put('cardCountry', 'US');
        addressDetails.put('cardState', 'CA');
        addressDetails.put('cardZip', '12345');

        Map<String, Map<String, String>> cardDetails = new Map<String, Map<String, String>>();
        cardDetails.put('tokenResponse', tokenResponse);
        cardDetails.put('addressDetails', addressDetails);

        // Mock Http Response
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

        // Call the method
        Test.startTest();
        Map<String, String> result = scc_XiPayIntegration.sendPreAuthorizationRequest(cardDetails);
        Test.stopTest();

        // Validate the response
        System.assertEquals('Success', result.get('response'));
    }

	private class MockHttpResponseGenerator implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            // Create a fake response
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/xml');
            res.setBody('<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns="http://Paymetric/XiPaySoap30/message/">' +
                        '<soapenv:Header/>' +
                        '<soapenv:Body>' +
                            '<ns:SoapOpResponse>' +
                                '<ns:SoapOpResult>' +
                                    '<ns:packets>' +
                                        '<ns:ITransactionHeader>' +
                                            '<ns:StatusCode>100</ns:StatusCode>' +
                                            '<ns:AVSCode>I3</ns:AVSCode>' +
                        					'<ns:TransactionID>12345678</ns:TransactionID>' +
                                            '<ns:Message>104 Successful Action Requested - Successful transaction.</ns:Message>' +
                                            '<ns:InfoItems>' +
                                                '<ns:InfoItem>' +
                                                    '<ns:Key>TR_CARD_CIDRESPCODE</ns:Key>' +
                                                    '<ns:Value>M</ns:Value>' +
                                                '</ns:InfoItem>' +
                                            '</ns:InfoItems>' +
                                        '</ns:ITransactionHeader>' +
                                    '</ns:packets>' +
                                '</ns:SoapOpResult>' +
                            '</ns:SoapOpResponse>' +
                        '</soapenv:Body>' +
                    '</soapenv:Envelope>');
            res.setStatusCode(200);
            return res;
    	}
    }
    
    @isTest
    static void testSendPreAuthorizationRequest1() {
        // Setup test data
        Map<String, String> tokenResponse = new Map<String, String>();
        tokenResponse.put('expYear', '2025');
        tokenResponse.put('expMonth', '12');
        tokenResponse.put('cardHolderName', 'John Smith');
        tokenResponse.put('cardType', 'VI');
        tokenResponse.put('tokenizedCardNumber', '1234567890123456');
        tokenResponse.put('securityCode', '123');

        Map<String, String> addressDetails = new Map<String, String>();
        addressDetails.put('currencyCode', 'USD');
        addressDetails.put('cardStreet', '123 Main St');
        addressDetails.put('cardCity', 'Anytown');
        addressDetails.put('cardCountry', 'US');
        addressDetails.put('cardState', 'CA');
        addressDetails.put('cardZip', '12345');

        Map<String, Map<String, String>> cardDetails = new Map<String, Map<String, String>>();
        cardDetails.put('tokenResponse', tokenResponse);
        cardDetails.put('addressDetails', addressDetails);

        // Mock Http Response
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator1());

        // Call the method
        Test.startTest();
        Map<String, String> result = scc_XiPayIntegration.sendPreAuthorizationRequest(cardDetails);
        Test.stopTest();

        // Validate the response
        System.assertEquals('Card Validation FALSEure - Please re-enter card details.', result.get('response'));
    }
    
    private class MockHttpResponseGenerator1 implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            // Create a fake response
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/xml');
            res.setBody('<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns="http://Paymetric/XiPaySoap30/message/">' +
                        '<soapenv:Header/>' +
                        '<soapenv:Body>' +
                            '<ns:SoapOpResponse>' +
                                '<ns:SoapOpResult>' +
                                    '<ns:packets>' +
                                        '<ns:ITransactionHeader>' +
                                            '<ns:StatusCode>100</ns:StatusCode>' +
                                            '<ns:AVSCode>I3</ns:AVSCode>' +
                        					'<ns:TransactionID>12345678</ns:TransactionID>' +
                                            '<ns:Message>104 Successful Action Requested - Successful transaction.</ns:Message>' +
                                            '<ns:InfoItems>' +
                                                '<ns:InfoItem>' +
                                                    '<ns:Key>TR_CARD_CIDRESPCODE</ns:Key>' +
                                                    '<ns:Value>N</ns:Value>' +
                                                '</ns:InfoItem>' +
                                            '</ns:InfoItems>' +
                                        '</ns:ITransactionHeader>' +
                                    '</ns:packets>' +
                                '</ns:SoapOpResult>' +
                            '</ns:SoapOpResponse>' +
                        '</soapenv:Body>' +
                    '</soapenv:Envelope>');
            res.setStatusCode(200);
            return res;
    	}
    }
    
    @isTest
    static void testSendPreAuthorizationRequest2() {
        // Setup test data
        Map<String, String> tokenResponse = new Map<String, String>();
        tokenResponse.put('expYear', '2025');
        tokenResponse.put('expMonth', '12');
        tokenResponse.put('cardHolderName', 'John Smith');
        tokenResponse.put('cardType', 'VI');
        tokenResponse.put('tokenizedCardNumber', '1234567890123456');
        tokenResponse.put('securityCode', '123');

        Map<String, String> addressDetails = new Map<String, String>();
        addressDetails.put('currencyCode', 'USD');
        addressDetails.put('cardStreet', '123 Main St');
        addressDetails.put('cardCity', 'Anytown');
        addressDetails.put('cardCountry', 'US');
        addressDetails.put('cardState', 'CA');
        addressDetails.put('cardZip', '12345');

        Map<String, Map<String, String>> cardDetails = new Map<String, Map<String, String>>();
        cardDetails.put('tokenResponse', tokenResponse);
        cardDetails.put('addressDetails', addressDetails);

        // Mock Http Response
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator2());

        // Call the method
        Test.startTest();
        Map<String, String> result = scc_XiPayIntegration.sendPreAuthorizationRequest(cardDetails);
        Test.stopTest();

        // Validate the response
        System.assertEquals('Something went wrong.', result.get('response'));
    }
    
    private class MockHttpResponseGenerator2 implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            // Create a fake response
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/xml');
            res.setBody('<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns="http://Paymetric/XiPaySoap30/message/">' +
                        '<soapenv:Header/>' +
                        '<soapenv:Body>' +
                            '<ns:SoapOpResponse>' +
                                '<ns:SoapOpResult>' +
                                    '<ns:packets>' +
                                        '<ns:ITransactionHeader>' +
                                            '<ns:StatusCode>-100</ns:StatusCode>' +
                                            '<ns:AVSCode>I3</ns:AVSCode>' +
                        					'<ns:TransactionID>12345678</ns:TransactionID>' +
                                            '<ns:Message>Something went wrong.</ns:Message>' +
                                            '<ns:InfoItems>' +
                                                '<ns:InfoItem>' +
                                                    '<ns:Key>TR_CARD_CIDRESPCODE</ns:Key>' +
                                                    '<ns:Value>N</ns:Value>' +
                                                '</ns:InfoItem>' +
                                            '</ns:InfoItems>' +
                                        '</ns:ITransactionHeader>' +
                                    '</ns:packets>' +
                                '</ns:SoapOpResult>' +
                            '</ns:SoapOpResponse>' +
                        '</soapenv:Body>' +
                    '</soapenv:Envelope>');
            res.setStatusCode(200);
            return res;
    	}
    }
    
    @isTest
    static void testSendPreAuthorizationRequest3() {
        // Setup test data
        Map<String, String> tokenResponse = new Map<String, String>();
        tokenResponse.put('expYear', '2025');
        tokenResponse.put('expMonth', '12');
        tokenResponse.put('cardHolderName', 'John Smith');
        tokenResponse.put('cardType', 'VI');
        tokenResponse.put('tokenizedCardNumber', '1234567890123456');
        tokenResponse.put('securityCode', '123');

        Map<String, String> addressDetails = new Map<String, String>();
        addressDetails.put('currencyCode', 'USD');
        addressDetails.put('cardStreet', '123 Main St');
        addressDetails.put('cardCity', 'Anytown');
        addressDetails.put('cardCountry', 'US');
        addressDetails.put('cardState', 'CA');
        addressDetails.put('cardZip', '12345');

        Map<String, Map<String, String>> cardDetails = new Map<String, Map<String, String>>();
        cardDetails.put('tokenResponse', tokenResponse);
        cardDetails.put('addressDetails', addressDetails);

        // Mock Http Response
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator3());

        // Call the method
        Test.startTest();
        Map<String, String> result = scc_XiPayIntegration.sendPreAuthorizationRequest(cardDetails);
        Test.stopTest();

        // Validate the response
        System.assertEquals('Credit Card Address Validation FALSEure - Please re-enter address and zip/postal code.', result.get('response'));
    }
    
    private class MockHttpResponseGenerator3 implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            // Create a fake response
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/xml');
            res.setBody('<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns="http://Paymetric/XiPaySoap30/message/">' +
                        '<soapenv:Header/>' +
                        '<soapenv:Body>' +
                            '<ns:SoapOpResponse>' +
                                '<ns:SoapOpResult>' +
                                    '<ns:packets>' +
                                        '<ns:ITransactionHeader>' +
                                            '<ns:StatusCode>100</ns:StatusCode>' +
                                            '<ns:AVSCode>N2</ns:AVSCode>' +
                        					'<ns:TransactionID>12345678</ns:TransactionID>' +
                                            '<ns:Message>Something went wrong.</ns:Message>' +
                                            '<ns:InfoItems>' +
                                                '<ns:InfoItem>' +
                                                    '<ns:Key>TR_CARD_CIDRESPCODE</ns:Key>' +
                                                    '<ns:Value>N</ns:Value>' +
                                                '</ns:InfoItem>' +
                                            '</ns:InfoItems>' +
                                        '</ns:ITransactionHeader>' +
                                    '</ns:packets>' +
                                '</ns:SoapOpResult>' +
                            '</ns:SoapOpResponse>' +
                        '</soapenv:Body>' +
                    '</soapenv:Envelope>');
            res.setStatusCode(200);
            return res;
    	}
    }
    
    @isTest static void checkXiIntegrationTest(){
        // Set mock callout class
        
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
                // Setup test data
        Map<String, String> tokenResponse = new Map<String, String>();
        tokenResponse.put('expYear', '2025');
        tokenResponse.put('expMonth', '12');
        tokenResponse.put('cardHolderName', 'John Smith');
        tokenResponse.put('cardType', 'VI');
        tokenResponse.put('tokenizedCardNumber', '1234567890123456');
        tokenResponse.put('securityCode', '123');

        Map<String, String> addressDetails = new Map<String, String>();
        addressDetails.put('currencyCode', 'USD');
        addressDetails.put('cardStreet', '123 Main St');
        addressDetails.put('cardCity', 'Anytown');
        addressDetails.put('cardCountry', 'US');
        addressDetails.put('cardState', 'CA');
        addressDetails.put('cardZip', '12345');

        Map<String, Map<String, String>> cardDetails = new Map<String, Map<String, String>>();
        cardDetails.put('tokenResponse', tokenResponse);
        cardDetails.put('addressDetails', addressDetails);

        // Mock Http Response
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator2());
        
        Test.startTest();             
        System.runAs(testUser1) {
			Map<String, String> result1 = scc_XiPayIntegration.sendPreAuthorizationRequest(cardDetails);
        }
        
        System.runAs(testUser2) {
			Map<String, String> result2 = scc_XiPayIntegration.sendPreAuthorizationRequest(cardDetails);
        }
        Test.stopTest();
        
    }

}