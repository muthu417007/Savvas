/******************************************************************************** 
* Description: Test class for RPASAPPriceCheckController
*********************************************************************************/
@isTest
private class RPASAPPriceCheckControllerTest {
    @testSetup static void setupmethod() {
         List<OrderLineItem__c> oliList= new List<OrderLineItem__c>();
            Account acc1=new Account();
            acc1.Name='TestAcc';
            acc1.type='College';
            insert acc1;
            
            Contact con1=new Contact();
            con1.LastName='TestConLast';
            con1.FirstName='One';
            con1.AccountId=acc1.Id;
            
            Order__c order = new Order__c(Account__c=acc1.Id, RPA_Bill_to_SAP_Account__c = '0002320601', RPA_Ship_to_SAP_Account__c ='0002320601');
            insert order;
        
            orderlineitem__c lineitem = new orderlineitem__c(Order__c = order.Id, Ordered_Item__c = '9781418310875', ItemQuantity__c = 1, Price__c = 120.0);
            oliList.add(lineitem);
            orderlineitem__c lineitem1 = new orderlineitem__c(Order__c = order.Id, Ordered_Item__c = '9781418307646', Free_Item_Quantity__c = 2, Price__c = 110.0);
            oliList.add(lineitem1);

            insert oliList; 
    }
    
    @isTest
    static void testGetSAPPricingDetails() {
       
        Order__c order = [SELECT Id, Account__c, RPA_Bill_to_SAP_Account__c, RPA_Ship_to_SAP_Account__c  FROM Order__c LIMIT 1][0];
        RPASAPPriceCheckController.flowInputs testInput=new RPASAPPriceCheckController.flowInputs();
        testInput.Order= order;
        testInput.selectedOLIs= [SELECT Id, Order__c, Ordered_Item__c, ItemQuantity__c, Price__c, Free_Item_Quantity__c FROM orderlineitem__c];
        
        system.debug(testInput);
            
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setBody(getMockRespBody('0'));
        mockResponse.setStatusCode(200);
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(mockResponse, true));
        Test.startTest();
        List<RPASAPPriceCheckController.FlowOutput> result = RPASAPPriceCheckController.getSAPPricingDetails(new List<RPASAPPriceCheckController.flowInputs>{testInput});
        Test.stopTest();
        System.assertEquals(1, result.size());
        
        RPASAPPriceCheckController.FlowOutput output = result[0];
        List<Integration_Logs__c> integrationLogs = [SELECT Id, Order__c, Request_Body__c, Response_Body__c, Status__c, Type__c FROM Integration_Logs__c];
        System.assertEquals(1, integrationLogs.size());
        Integration_Logs__c integrationLog = integrationLogs[0];
        System.assertEquals(order.Id, integrationLog.Order__c);
    }
    
    @isTest
    static void testGetSAPPricingDetailsError() {
       
        Order__c order = [SELECT Id, Account__c, RPA_Bill_to_SAP_Account__c, RPA_Ship_to_SAP_Account__c  FROM Order__c LIMIT 1][0];
        RPASAPPriceCheckController.flowInputs testInput=new RPASAPPriceCheckController.flowInputs();
        testInput.Order= order;
        testInput.selectedOLIs= [SELECT Id, Order__c, Ordered_Item__c, ItemQuantity__c, Price__c, Free_Item_Quantity__c FROM orderlineitem__c];
        
        system.debug(testInput);
            
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setBody(getMockRespBody('2'));
        mockResponse.setStatusCode(200);
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(mockResponse, true));
        Test.startTest();
        List<RPASAPPriceCheckController.FlowOutput> result = RPASAPPriceCheckController.getSAPPricingDetails(new List<RPASAPPriceCheckController.flowInputs>{testInput});
        Test.stopTest();
        System.assertEquals(1, result.size());
        
        RPASAPPriceCheckController.FlowOutput output = result[0];
        List<Integration_Logs__c> integrationLogs = [SELECT Id, Order__c, Request_Body__c, Response_Body__c, Status__c, Type__c FROM Integration_Logs__c];
        System.assertEquals(1, integrationLogs.size());
        Integration_Logs__c integrationLog = integrationLogs[0];
        System.assertEquals(order.Id, integrationLog.Order__c);
    }
    
     @isTest
    static void testGetSAPPricingDetailsException() {
        Order__c order = [SELECT Id, Account__c, RPA_Bill_to_SAP_Account__c, RPA_Ship_to_SAP_Account__c  FROM Order__c LIMIT 1][0];
        RPASAPPriceCheckController.flowInputs testInput=new RPASAPPriceCheckController.flowInputs();
        testInput.Order= order;
        testInput.selectedOLIs= [SELECT Id, Order__c, Ordered_Item__c, ItemQuantity__c, Free_Item_Quantity__c, Price__c FROM orderlineitem__c];
          
        system.debug(testInput);
        
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setBody(getMockRespBody('2'));
        mockResponse.setStatusCode(200);
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(mockResponse, false));
        Test.startTest();
        List<RPASAPPriceCheckController.FlowOutput> result = RPASAPPriceCheckController.getSAPPricingDetails(new List<RPASAPPriceCheckController.flowInputs>{testInput});
        Test.stopTest();
    }
    
    
    private class MockHttpResponseGenerator implements HttpCalloutMock {
        private HttpResponse response;
        Boolean  isMockResponseSuccessful;
        
        public MockHttpResponseGenerator(HttpResponse response, Boolean  isMockResponseSuccessful) {
            this.response = response;
            this.isMockResponseSuccessful = isMockResponseSuccessful;
        }
        
        public HttpResponse respond(HttpRequest request) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'text/plain');
            if(isMockResponseSuccessful)
            {
                res.setBody(getMockRespBody('2'));
            	res.setStatusCode(200);
            }
            else{
                CalloutException e = (CalloutException)CalloutException.class.newInstance();
                e.setMessage('Unauthorized endpoint, please check Setup->Security->Remote site settings.');
                throw e;
            } 
            return res;
        }
    }
    
    private static String getMockRespBody(String code){
        String resXML = '<?xml version="1.0" encoding="utf-8"?>'+
'<ResponsePricingData xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'+
    '<Header>'+
        '<RequestID>a0a0W00000LwtzHQAuR_202002192022502_0</RequestID>'+
        '<MessageCode>'+code+'</MessageCode>'+
        '<MessageDescription>Success</MessageDescription>'+
    '</Header>'+
    '<Detail>'+
        '<Item>'+
            '<ISBN>9781418310875:1418310875</ISBN>'+
            '<ContractPrice>120.97</ContractPrice>'+
            '<ShippingHandlingAmount>0.00</ShippingHandlingAmount>'+
            '<StatusCode>24</StatusCode>'+
            '<StatusDescription>Contract Price is Available</StatusDescription>'+
        '</Item>'+
        '<Item>'+
            '<ISBN>9781418307646:1418307646</ISBN>'+
            '<ContractPrice>66.97</ContractPrice>'+
            '<ShippingHandlingAmount>0.00</ShippingHandlingAmount>'+
            '<StatusCode>24</StatusCode>'+
            '<StatusDescription>Contract Price is Available</StatusDescription>'+
        '</Item>'+
            '<Item>'+
            '<ISBN>0000000123690:0000123690</ISBN>'+
            '<ContractPrice/>'+
            '<ShippingHandlingAmount/>'+
            '<StatusCode>22</StatusCode>'+
            '<StatusDescription>Invalid ISBN in request xml</StatusDescription>'+
        '</Item>'+
        '</Detail>'+
		'</ResponsePricingData>';
        
        return resXML;
    }    
}