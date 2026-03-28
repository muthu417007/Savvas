@isTest
global class implOppMashupQueryResultMockImpl implements WebServiceMock {
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
       implOppMashupSoapSforceCom.queryResponse_element respElement = 
           new implOppMashupSoapSforceCom.queryResponse_element();
       
       response.put('response_x', respElement); 
   }
}