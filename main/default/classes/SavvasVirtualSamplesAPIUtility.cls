/*
@Author : Cognizant Team
@Name : SavvasVirtualSamplesAPIUtility
@CreateDate : 17-Oct-2023
@Description: This class is helper class for API Utility
@ModifiedBy: Cognizant Team
@ModifiedDate: 02-Nov-2023
@Ticket Number: VS-0014
*/
public without sharing class SavvasVirtualSamplesAPIUtility {
    /*
    *  Method Name : generateRequest
    *  Description : generating Http request
    *  param : endPoint,body,method,tokenId
    *  return : HttpResponse
    */
    public static HttpResponse generateRequest(String endPoint, String body,String method,String tokenId){
        HttpResponse response;
        try{
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            if(method == 'POST'){
                request.setMethod('POST');
            }
            if(method == 'GET'){
                request.setMethod('GET');
            }
            if(endPoint == 'Sitecore'){
                request.setEndpoint('callout:Sitecore'); 
            }
            if(endPoint == 'DAM_Authentication'){
                request.setEndpoint('callout:DAM_Authentication');
            }
            if(endPoint.startsWith(Label.Dam_Endpoint)){
                request.setEndpoint(endPoint);
                request.setHeader('X-Auth-Token', tokenId);
                request.setHeader('X-Impersonate', 'sfcommunity.user');
            }
            request.setHeader('Content-Type', 'application/json');
            request.setHeader('Accept','application/json');
            if(String.isNotBlank(body)){
                request.setBody(body);
            }
            response = Test.isRunningTest()?NULL:http.send(request);    
            
        }
        catch(Exception e){throw new AuraHandledException('An error occured : '+e.getMessage());}
        return response;
        
    }
}