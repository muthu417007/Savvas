@isTest
global class assetMashupQueryResultMockImpl implements WebServiceMock {
   global void doInvoke(
           Object stub,
           Object request,
           Map<String, Object> response,
           String endpoint,
           String soapAction,
           String requestName,
           String responseNS,
           String responseName,
           String responseType) {
       assetMashupSoapSforceCom.queryResponse_element respElement = 
           new assetMashupSoapSforceCom.queryResponse_element();
       
       response.put('response_x', respElement); 
   }
}