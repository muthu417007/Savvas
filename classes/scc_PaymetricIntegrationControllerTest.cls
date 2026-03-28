/*********************************************************** 
* @Class Name  - scc_PaymetricIntegrationControllerTest
* @description - Test class for scc_PaymetricIntegrationControllerTest
* @Created By  - CTS (Dhiyaneshwari Karthikeyan)
* @Created On - 2024-05-31
* **********************************************************/ 
@IsTest
public class scc_PaymetricIntegrationControllerTest {

    @IsTest
    static void testGetCountrysOptions() {
        List<ZVC__Country_Phone_Code__c> countries = new List<ZVC__Country_Phone_Code__c>{
            new ZVC__Country_Phone_Code__c(Name= 'IND', ZVC__Country_Code__c = 'India', CurrencyIsoCode = 'USD'),
            new ZVC__Country_Phone_Code__c(Name= 'DE',ZVC__Country_Code__c = 'Germany', CurrencyIsoCode = 'USD')
        };
        insert countries;
        Test.startTest();
        String result = scc_PaymetricIntegrationController.getCountrysOptions();
        Test.stopTest();
        List<scc_PaymetricIntegrationController.getCountrysOptionsWrapper> resultList = 
            (List<scc_PaymetricIntegrationController.getCountrysOptionsWrapper>) JSON.deserialize(result, List<scc_PaymetricIntegrationController.getCountrysOptionsWrapper>.class);
        System.assertEquals(2, resultList.size());
        System.assertEquals('India', resultList[1].label);
        System.assertEquals('IND', resultList[1].value);
        System.assertEquals('Germany', resultList[0].label);
        System.assertEquals('DE', resultList[0].value);
    }

    @IsTest
    static void testGetStatesOptions() {
        List<SCC_StateInfo__c> states = new List<SCC_StateInfo__c>{
            new SCC_StateInfo__c(Name = 'California', State_Code__c = 'CA', CurrencyIsoCode = 'USD'),
            new SCC_StateInfo__c(Name = 'Texas', State_Code__c = 'TX', CurrencyIsoCode = 'USD')
        };
        insert states;

        Test.startTest();
        String result = scc_PaymetricIntegrationController.getStatesOptions('USD');
        Test.stopTest();

        List<scc_PaymetricIntegrationController.geStatesOptionsWrapper> resultList = 
            (List<scc_PaymetricIntegrationController.geStatesOptionsWrapper>) JSON.deserialize(result, List<scc_PaymetricIntegrationController.geStatesOptionsWrapper>.class);
        
        System.assertEquals(2, resultList.size());
        System.assertEquals('California', resultList[0].label);
        System.assertEquals('CA', resultList[0].value);
        System.assertEquals('Texas', resultList[1].label);
        System.assertEquals('TX', resultList[1].value);
    }

    @IsTest
    static void testGetAccessToken() {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        Test.startTest();
        Map<String, String> result = scc_PaymetricIntegrationController.getAccessToken();
        Test.stopTest();
    }

    @IsTest
    static void testGetCreditCardToken() {
        Account acc= scc_TestDataFactory.accountCreation('testAccount1');
        Account acc1= scc_TestDataFactory.accountCreation('testAccount1');
        
        Contact cont = new Contact();
        cont.AccountId = acc.id;
        cont.LastName = 'Testing';
        cont.Email = 'abc@xyz.com';
        cont.FirstName = 'Test';
        insert cont;
        
        Contact cont1 = new Contact();
        cont1.AccountId = acc.id;
        cont1.LastName = 'Testing';
        cont1.Email = 'abc@xyz.com';
        cont1.FirstName = 'Test';
        insert cont1;
                
        WebStore webStr = new WebStore();
        webStr.Name = 'MySavvasOrders';
        webStr.PricingStrategy = 'LowestPrice';
        insert webStr;
        
        List<User> userList = new List<User>();        
        Profile pd = [Select id From profile where name = 'Customer Community Login User' limit 1];        
        user u= new User(contactID=cont.id, Alias = 'ruser', Email='standardistuser6@testorg.com', 
                              EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                              LocaleSidKey='en_US', ProfileId= pd.Id, 
                              TimeZoneSidKey='America/Los_Angeles', UserName='standarduser1@testorg.com'); 
        userList.add(u);
        user u1= new User(contactID=cont1.id, Alias = 'ruser', Email='standardistuser6@testorg.com', 
                              EmailEncodingKey='UTF-8', LastName='TestingUser', LanguageLocaleKey='en_US', 
                              LocaleSidKey='en_US', ProfileId= pd.Id, 
                              TimeZoneSidKey='America/Los_Angeles', UserName='standarduser123@testorg.com'); 
        userList.add(u1);
        insert userList;
        
        WebCart activeCart =scc_TestDataFactory.webCartCreation( acc.Id, userList[0].Id, webStr.Id);
		activeCart.API_Source__c = 'Rubicon';
        activeCart.Coupon_Discount__c = -10.54;
        activeCart.Shipping_Amount__c = 1.20;
        update activeCart;
        
        WebCart activeCart1 =scc_TestDataFactory.webCartCreation( acc1.Id, userList[1].Id, webStr.Id);
        activeCart.API_Source__c = 'PNP';
        activeCart1.Coupon_Discount__c = -10.54;
        activeCart1.Shipping_Amount__c = 1.20;
        update activeCart1;
        
        Map<String, String> addressDetails = new Map<String, String>();
        addressDetails.put('currencyCode', 'USD');
        addressDetails.put('cardStreet', '123 Main St');
        addressDetails.put('cardCity', 'Anytown');
        addressDetails.put('cardCountry', 'US');
        addressDetails.put('cardState', 'CA');
        addressDetails.put('cardZip', '12345');
        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

        Test.startTest();
        Map<String, String> cartResult = scc_PaymetricIntegrationController.getGuestCartDetails(activeCart.Id, acc.Id);
        Map<String, String> cartResult1 = scc_PaymetricIntegrationController.getGuestCartDetails(activeCart1.Id, acc.Id);
        Map<String, String> result = scc_PaymetricIntegrationController.getCreditCardToken('TestAccessToken', 'TestSignature', 'TestMerchantGuid', true, addressDetails, activeCart.Id);
        Test.stopTest();

        System.assertEquals('VI', result.get('cardType'));
        System.assertEquals('1', result.get('expMonth'));
        System.assertEquals('2030', result.get('expYear'));
        System.assertEquals('1234567890123456', result.get('tokenizedCardNumber'));
        System.assertEquals('TEST USER', result.get('cardHolderName'));
        System.assertEquals('123', result.get('securityCode'));
    }
    
    @IsTest
    static void testGetCreditCardToken1() {
        Account acc= scc_TestDataFactory.accountCreation('testAccount1');
        
        Contact cont = new Contact();
        cont.AccountId = acc.id;
        cont.LastName = 'Testing';
        cont.Email = 'abc@xyz.com';
        cont.FirstName = 'Test';
        insert cont;
                
        WebStore webStr = new WebStore();
        webStr.Name = 'MySavvasOrders';
        webStr.PricingStrategy = 'LowestPrice';
        insert webStr;
        
        Profile pd = [Select id From profile where name = 'Savvas External Users Base Profile' limit 1];
        List<User> userList = new List<User>();
        user u= new User(contactID=cont.id, Alias = 'ruser', Email='standardistuser6@testorg.com', 
                              EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                              LocaleSidKey='en_US', ProfileId= pd.Id, 
                              TimeZoneSidKey='America/Los_Angeles', UserName='standarduser1@testorg.com'); 
        userList.add(u);
        insert userList;
        
        WebCart activeCart =scc_TestDataFactory.webCartCreation( acc.Id, userList[0].Id, webStr.Id);
        activeCart.CurrencyIsoCode = 'USD';
        activeCart.BillingCity = 'Anytown';
        activeCart.BillingCountry = 'United States';
        activeCart.BillingStreet = '123 Main St';
        activeCart.BillingState = 'CA';
        activeCart.BillingPostalCode = '12345';
        update activeCart;
        
        ZVC__Country_Phone_Code__c code =new ZVC__Country_Phone_Code__c();
        code.ZVC__Country_Code__c = 'United States';
        code.Name = 'US';
        insert code;        
        Map<String, String> addressDetails = new Map<String, String>();        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

        Test.startTest();
        Map<String, String> result = scc_PaymetricIntegrationController.getCreditCardToken('TestAccessToken', 'TestSignature', 'TestMerchantGuid', false, addressDetails, activeCart.Id);
       	System.runAs(u) {
        	Map<String, String> result1 = scc_PaymetricIntegrationController.getCreditCardToken('TestAccessToken', 'TestSignature', 'TestMerchantGuid', false, addressDetails, activeCart.Id);
        }
        Test.stopTest();

        System.assertEquals('VI', result.get('cardType'));
        System.assertEquals('1', result.get('expMonth'));
        System.assertEquals('2030', result.get('expYear'));
        System.assertEquals('1234567890123456', result.get('tokenizedCardNumber'));
        System.assertEquals('TEST USER', result.get('cardHolderName'));
        System.assertEquals('123', result.get('securityCode'));
    }
	
    @isTest static void checkGetTokenTest(){
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
        
        Test.startTest();      
        System.runAs(testUser1) {
			Map<String, String> result = scc_PaymetricIntegrationController.getAccessToken();
        }
        
        System.runAs(testUser2) {
 			Map<String, String> result = scc_PaymetricIntegrationController.getAccessToken();
        }
        Test.stopTest();        
    }
    
    private class MockHttpResponseGenerator implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/xml');
            
            if(req.getEndpoint().contains('diecomm/AccessToken')) {
                res.setBody('<?xml version="1.0"?>' +
                            '<AccessTokenResponsePacket>' +
                            '<ResponsePacket>' +
                            '<MerchantGuid>TestMerchantGuid</MerchantGuid>' +
                            '<AccessToken>TestAccessToken</AccessToken>' +
                            '<Signature>TestSignature</Signature>' +
                            '</ResponsePacket>' +
                            '</AccessTokenResponsePacket>');
            } else if(req.getEndpoint().contains('ResponsePacket')) {
                res.setBody('<?xml version="1.0" encoding="UTF-8"?>' +
                            '<PaymetricResponse>' +
                            '<Fields>' +
                            '<FormField><Name>Card Type</Name><Value>VI</Value></FormField>' +
                            '<FormField><Name>Expiration Month</Name><Value>1</Value></FormField>' +
                            '<FormField><Name>Expiration Year</Name><Value>2030</Value></FormField>' +
                            '<FormField><Name>Card Number</Name><Value>1234567890123456</Value></FormField>' +
                            '<FormField><Name>Card Holder Name</Name><Value>TEST USER</Value></FormField>' +
                            '<FormField><Name>Card Security Code</Name><Value>123</Value></FormField>' +
                            '</Fields>' +
                            '</PaymetricResponse>');
            }else if(req.getEndpoint().contains('XiPay30WS')) {
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
            }
            
            res.setStatusCode(200);
            return res;
        }
    }
}