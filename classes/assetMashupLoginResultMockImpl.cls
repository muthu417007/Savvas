@isTest
global class assetMashupLoginResultMockImpl implements WebServiceMock {
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
       assetMashupSoapSforceCom.loginResponse_element respElement = 
           new assetMashupSoapSforceCom.loginResponse_element();
       
       response.put('response_x', respElement); 
   }
}