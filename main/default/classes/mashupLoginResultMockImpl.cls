@isTest
global class mashupLoginResultMockImpl implements WebServiceMock {
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
       mashupSoapSforceCom.loginResponse_element respElement = 
           new mashupSoapSforceCom.loginResponse_element();
       
       response.put('response_x', respElement); 
   }
}