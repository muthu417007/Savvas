@isTest
global class implOppMashupLoginResultMockImpl implements WebServiceMock {
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
       implOppMashupSoapSforceCom.loginResponse_element respElement = 
           new implOppMashupSoapSforceCom.loginResponse_element();
       
       response.put('response_x', respElement); 
   }
}