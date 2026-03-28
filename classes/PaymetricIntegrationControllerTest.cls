@IsTest
public class PaymetricIntegrationControllerTest {

    @IsTest
    static void testGetCountrysOptions() {
        List<ZVC__Country_Phone_Code__c> countries = new List<ZVC__Country_Phone_Code__c>{
            new ZVC__Country_Phone_Code__c(Name= 'India', ZVC__Country_Code__c = 'India', CurrencyIsoCode = 'USD'),
            new ZVC__Country_Phone_Code__c(Name= 'Germany',ZVC__Country_Code__c = 'Germany', CurrencyIsoCode = 'USD')
        };
        insert countries;

        Test.startTest();
        String result = PaymetricIntegrationController.getCountrysOptions();
        Test.stopTest();

        List<PaymetricIntegrationController.getCountrysOptionsWrapper> resultList = 
            (List<PaymetricIntegrationController.getCountrysOptionsWrapper>) JSON.deserialize(result, List<PaymetricIntegrationController.getCountrysOptionsWrapper>.class);
        
        System.assertEquals(2, resultList.size());
        System.assertEquals('India', resultList[0].label);
        System.assertEquals('USD', resultList[0].value);
        System.assertEquals('Germany', resultList[1].label);
        System.assertEquals('USD', resultList[1].value);
    }

    @IsTest
    static void testGetStatesOptions() {
        List<SCC_StateInfo__c> states = new List<SCC_StateInfo__c>{
            new SCC_StateInfo__c(Name = 'California', State_Code__c = 'CA', CurrencyIsoCode = 'USD'),
            new SCC_StateInfo__c(Name = 'Texas', State_Code__c = 'TX', CurrencyIsoCode = 'USD')
        };
        insert states;

        Test.startTest();
        String result = PaymetricIntegrationController.getStatesOptions('USD');
        Test.stopTest();

        List<PaymetricIntegrationController.geStatesOptionsWrapper> resultList = 
            (List<PaymetricIntegrationController.geStatesOptionsWrapper>) JSON.deserialize(result, List<PaymetricIntegrationController.geStatesOptionsWrapper>.class);
        
        System.assertEquals(2, resultList.size());
        System.assertEquals('California', resultList[0].label);
        System.assertEquals('CA', resultList[0].value);
        System.assertEquals('Texas', resultList[1].label);
        System.assertEquals('TX', resultList[1].value);
    }

    @IsTest
    static void testGetAccessToken() {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

        /*scc_Integration_Setting__mdt testMetadata = new scc_Integration_Setting__mdt(
            scc_Packet_Xml__c = 'TestPacket',
            scc_Shared_Key__c = 'TestKey',
            scc_Merchant_Guid__c = 'TestMerchantGuid',
            scc_Named_Credential__c = 'TestNamedCredential',
            scc_Method_Type__c = 'POST'
        );
        insert testMetadata;*/

        Test.startTest();
        Map<String, String> result = PaymetricIntegrationController.getAccessToken();
        Test.stopTest();

        //System.assertEquals('TestAccessToken', result.get('accessToken'));
        //System.assertEquals('TestMerchantGuid', result.get('merchantGuid'));
        //System.assertEquals('TestSignature', result.get('signature'));
    }

    @IsTest
    static void testGetCreditCardToken() {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

        Test.startTest();
        Map<String, String> result = PaymetricIntegrationController.getCreditCardToken('TestAccessToken', 'TestSignature', 'TestMerchantGuid');
        Test.stopTest();

        System.assertEquals('vi', result.get('cardType'));
        System.assertEquals('1', result.get('expMonth'));
        System.assertEquals('2030', result.get('expYear'));
        System.assertEquals('1234567890123456', result.get('tokenizedCardNumber'));
        System.assertEquals('Test', result.get('cardHolderName'));
        System.assertEquals('123', result.get('securityCode'));
    }

    private class MockHttpResponseGenerator implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/xml');
            
            if(req.getEndpoint().contains('Paymetric_API')) {
                res.setBody('<?xml version="1.0"?>' +
                            '<AccessTokenResponsePacket>' +
                            '<ResponsePacket>' +
                            '<MerchantGuid>TestMerchantGuid</MerchantGuid>' +
                            '<AccessToken>TestAccessToken</AccessToken>' +
                            '<Signature>TestSignature</Signature>' +
                            '</ResponsePacket>' +
                            '</AccessTokenResponsePacket>');
            } else if(req.getEndpoint().contains('Credit_Card_Token_API')) {
                res.setBody('<?xml version="1.0" encoding="UTF-8"?>' +
                            '<PaymetricResponse>' +
                            '<Fields>' +
                            '<FormField><Name>Card Type</Name><Value>vi</Value></FormField>' +
                            '<FormField><Name>Expiration Month</Name><Value>1</Value></FormField>' +
                            '<FormField><Name>Expiration Year</Name><Value>2030</Value></FormField>' +
                            '<FormField><Name>Card Number</Name><Value>1234567890123456</Value></FormField>' +
                            '<FormField><Name>Card Holder Name</Name><Value>Test</Value></FormField>' +
                            '<FormField><Name>Card Security Code</Name><Value>123</Value></FormField>' +
                            '</Fields>' +
                            '</PaymetricResponse>');
            }
            
            res.setStatusCode(200);
            return res;
        }
    }
}