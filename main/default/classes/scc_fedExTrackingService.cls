/**************************************************************************************** 
* @Class Name  - scc_fedExTrackingService
* @description - class to perform API callout and get response data
* @Created By  - CTS-Varshaa
* @Created On - 2024-05-31
* ***************************************************************************************/ 
public with sharing class scc_fedExTrackingService {
    
    public static List<Integration_Logs__c> fedexIntegrationLogs = new List<Integration_Logs__c>();
    public static string contactId='';
    public static string contactEmail='';
    public static String userType='';
    public static String userID='';
    public static String entryPoint = scc_constantHelper.FEDEX_ENTRY_POINT;
    
/**
*  Description: This method gnerates request for Fedex      
*  @name: getTrackingDetails
*  @param: tracking ID as a parameter
*  @return: Fedex Tracking Details
*  @throws exception- 
*/
    
    @AuraEnabled
    public static string getTrackingDetails(String scc_Trackingid)
    {  
        String requestString;
        String jsonResponseData;
        HttpResponse response;        
        try {            
            List<User> usr = [SELECT ID,Email, Profile.Name, IsEmployee__c,Contact.Id, Contact.AccountID,Contact.Email,Contact.Account.SAP_Account_Id__c, contact.name, contact.Account.name FROM User WHERE Id = :UserInfo.getUserId()];
            if(usr[0].Profile.Name ==scc_constantHelper.SAVVAS_EXTERNAL_USERS_BASE_PROFILE){
                contactId = usr[0].Contact.Id;
                contactEmail = usr[0].Contact.Email;
                userType = scc_constantHelper.EXTERNAL_USER;
            }else if(usr[0].Profile.Name ==scc_constantHelper.MY_SAVVAS_ORDERS_PROFILE){
                contactEmail = scc_constantHelper.MYSAVVASORDERS_GUEST_USER;
                userType = scc_constantHelper.GUEST_USER;
            }else{
                contactEmail ='';
                userType = scc_constantHelper.INTERNAL_USER;
                userID = usr[0].ID;
            } 
            String token = getFedexToken();            
            Http http1 = new Http();    
            HttpRequest request = new HttpRequest();
            request.setMethod('POST');
            request.setHeader('Content-Type','application/json');
            request.setHeader('Authorization', 'Bearer '+token);
            request.setTimeout(120000);
            request.setEndpoint(System.Label.scc_Fedex_Request_Endpoint);
            requestString ='{"trackingInfo":[{"trackingNumberInfo":{"trackingNumber":'+scc_Trackingid+'}}],"includeDetailedScans":true}';
            request.setBody(requestString);
            response = http1.send(request);
            
            if(response.getStatusCode() != 200 && response.getStatusCode() !=201){
                jsonResponseData = response.getBody();
                if(Boolean.valueOf(Label.scc_Insert_Logs)){
                    createIntegrationLogs('Fedex',requestString,response.getBody(),'Error',String.valueOf(response.getStatusCode()),contactId,contactEmail,true,userType);
                }
                throw new AuraHandledException('Failed to get fedex data :'+response.getBody()); 

            }else{

                jsonResponseData = response.getBody();
                if(Boolean.valueOf(Label.scc_Insert_Logs)){
                    createIntegrationLogs('Fedex',requestString,response.getBody(),'Success',String.valueOf(response.getStatusCode()),contactId,contactEmail,true,userType);
                }
            }
            return jsonResponseData;
        } 
        catch (Exception e) 
        {
            System.debug(scc_constantHelper.EXCEPTION_TYPE_CAUGHT+ e.getTypeName());    
            System.debug(scc_constantHelper.MESSAGE+ e.getMessage());    
            System.debug(scc_constantHelper.CAUSE+ e.getCause());    // returns null
            System.debug(scc_constantHelper.LINE_NUMBER + e.getLineNumber());    
            System.debug(scc_constantHelper.STACK_RACE+ e.getStackTraceString());
            if(Boolean.valueOf(Label.scc_Insert_Logs)){
                if(response !=null){
                    createIntegrationLogs('Fedex',requestString,String.isBlank(response.getBody())?'NULL':response.getBody(),'Error',e.getLineNumber() + ': ' + e.getMessage(),contactId,contactEmail,true,userType); 
                }else{
                    createIntegrationLogs('Fedex',requestString,'','Error',e.getLineNumber() + ': ' + e.getMessage(),contactId,contactEmail,true,userType);                         
                }
            }
            return '';
        }
        
    }
    
    /**
*  Description: This method gnerates request for radar      
*  @name: getFedexToken
*  @param:No parameters
*  @return: token for fedex request api call
*  @throws exception- 
*/    
    
    public static String getFedexToken(){
        String REQUEST_BODY;
        HttpRequest req;
        HttpResponse res;
        try{
            String CONSUMER_KEY = System.Label.scc_consumerKey;
            String CONSUMER_SECRET = System.Label.scc_consumerSecret;
            REQUEST_BODY='grant_type=client_credentials&client_id='+CONSUMER_KEY+'&client_secret='+CONSUMER_SECRET;            
            req = new HttpRequest();
            req.setEndpoint(System.Label.scc_Fedex_Token_Endpoint);
            req.setMethod('POST');                          
            req.setBody(REQUEST_BODY);
            req.setTimeout(30000);
            Http http = new Http();              
            res = http.send(req);                
            String respString = res.getbody();              
            Map<String,Object> map_results = (Map<String,Object>) JSON.deserializeUntyped(res.getBody());  
            String token = (String)map_results.get('access_token');
            if(Boolean.valueOf(Label.scc_Insert_Logs)){
                createIntegrationLogs('Fedex',REQUEST_BODY,res.getBody(),'Success',String.valueOf(res.getStatusCode()),contactId,contactEmail,false,userType);              
            }
            return token;
        }catch (Exception e){
            System.debug(scc_constantHelper.EXCEPTION_TYPE_CAUGHT+ e.getTypeName());    
            System.debug(scc_constantHelper.MESSAGE+ e.getMessage());    
            System.debug(scc_constantHelper.CAUSE+ e.getCause());    // returns null
            System.debug(scc_constantHelper.LINE_NUMBER + e.getLineNumber());    
            System.debug(scc_constantHelper.STACK_RACE+ e.getStackTraceString());
            if(Boolean.valueOf(Label.scc_Insert_Logs)){
                if(res !=null){
                    createIntegrationLogs('Fedex',REQUEST_BODY,String.isBlank(res.getBody())?'NULL':res.getBody(),'Error',e.getLineNumber() + ': ' + e.getMessage(),contactId,contactEmail,false,userType);
                }else{
                    createIntegrationLogs('Fedex',REQUEST_BODY,'','Error',e.getLineNumber() + ': ' + e.getMessage(),contactId,contactEmail,false,userType);
                }
            }
            return '';
        }
        
    }
    
    /**
*  Description: This method creates Integration Logs    
*  @name: createIntegrationLogs
*  @param:parameters like logType,requestBody etc.
*  @return: token for radar request api call
*  @throws exception- 
*/    
    
    public static void createIntegrationLogs(String logType, String requestBody, String responseBody, String status, String internalStatus, String contactId, String contactEmail,Boolean insertNow,String userType){
        try{
            Integration_Logs__c integrationLog = new Integration_Logs__c(
                Type__c = logType,
                Request_Body__c = requestBody,
                Response_Body__c = responseBody.toString().length()>1000 ? responseBody.toString().subString(0,1000) : responseBody.toString(),
                Status__c = status,
                Internal_Status__c = internalStatus,
                contact__c = String.isBlank(contactId)?NULL:contactId,
                Contact_Email__c = contactEmail,
                scc_User_Type__c = userType,
                User__c = String.isBlank(userID)?NULL:userID,
                Entry_Point__c = entryPoint
            );
            
            fedexIntegrationLogs.add(integrationLog);
            
            if(insertNow == true){
                scc_IntegrationLogs_Helper.createSFCCIntegrationLogs(JSON.serialize(fedexIntegrationLogs));
            }
        }catch(Exception e){
            System.debug(scc_constantHelper.EXCEPTION_TYPE_CAUGHT+ e.getTypeName());    
            System.debug(scc_constantHelper.MESSAGE+ e.getMessage());    
            System.debug(scc_constantHelper.CAUSE+ e.getCause());    // returns null
            System.debug(scc_constantHelper.LINE_NUMBER + e.getLineNumber());    
            System.debug(scc_constantHelper.STACK_RACE+ e.getStackTraceString());
            throw new AuraHandledException('Failed to insert integration log :'+e.getMessage()+e.getCause());
        }
    }    
}