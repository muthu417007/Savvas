/**************************************************************************************** 
* @Class Name  - scc_documents_RADAR_Controller
* @description - class to perform API callout and get response data
* @Created By  - Vaibhav Saptal (Cognizant)
* @Created On - 2024-06-08
* ***************************************************************************************/ 
public with sharing class scc_documents_RADAR_Controller {
    public String userName;
    public String password; 
    public String grantType; 
    public String method;
    public String endPoint; 
    public String tokenURL;
    public String requestString;
    public String contactId='';
    public String contactEmail='';
    public String userType='';
    public String userID='';
    public static List<Integration_Logs__c> radarIntegrationLogs = new List<Integration_Logs__c>();
    public String entryPoint = scc_constantHelper.RADAR_ENTRY_POINT;   
/**
*  Description: This is constructor for class to get api credentials and user details.    
*  @name: scc_documents_RADAR_Controller
*  @param:No parameters.
*  @return:No return
*  @throws exception- 
*/    
    public scc_documents_RADAR_Controller(){
        try{
            List<scc_Integration_Setting__mdt> apiCallCreds = [SELECT Id, DeveloperName, Grant_Type__c, MasterLabel, Label,Language, NamespacePrefix, Password__c, QualifiedApiName,scc_Endpoint_URL__c,scc_Merchant_Guid__c,scc_Method_Type__c,scc_Packet_Xml__c, scc_Shared_Key__c,User_Name__c,scc_Token_URL__c
                                                               FROM scc_Integration_Setting__mdt
                                                               WHERE DeveloperName = 'Radar_Api_Call'];
            userName = apiCallCreds[0].User_Name__c;
            password = apiCallCreds[0].Password__c;
            grantType= apiCallCreds[0].Grant_Type__c;
            endPoint = apiCallCreds[0].scc_Endpoint_URL__c;
            tokenURL = apiCallCreds[0].scc_Token_URL__c;
            
            List<User> usr = [SELECT ID,Email, Profile.Name, IsEmployee__c,Contact.Id, Contact.AccountID,Contact.Email,Contact.Account.SAP_Account_Id__c, contact.name, contact.Account.name FROM User WHERE Id = :UserInfo.getUserId()];            
            
            if(usr[0].Profile.Name ==scc_constantHelper.SAVVAS_EXTERNAL_USERS_BASE_PROFILE){
                contactId = usr[0].Contact.Id;
                contactEmail = usr[0].Contact.Email;
                userType = scc_constantHelper.EXTERNAL_USER;
            }else if(usr[0].Profile.Name ==scc_constantHelper.MY_SAVVAS_ORDERS_PROFILE){
                contactEmail = scc_constantHelper.MYSAVVASORDERS_GUEST_USER;
                userType = scc_constantHelper.GUEST_USER;
            }else{
                contactEmail = '';
                userType = scc_constantHelper.INTERNAL_USER;
                userID = usr[0].ID;
            } 
            
        }catch(Exception e){
            System.debug(scc_constantHelper.EXCEPTION_TYPE_CAUGHT+ e.getTypeName());    
            System.debug(scc_constantHelper.MESSAGE+ e.getMessage());    
            System.debug(scc_constantHelper.CAUSE+ e.getCause());    // returns null
            System.debug(scc_constantHelper.LINE_NUMBER + e.getLineNumber());    
            System.debug(scc_constantHelper.STACK_RACE+ e.getStackTraceString());
        }            
    }
    
/**
*  Description: This method gnerates request for radar      
*  @name: generateRADARRequest
*  @param:requestData map as parameter which takes values like docType,accountNumber,month etc.
*  @return: pdf Content
*  @throws exception- 
*/    
    @AuraEnabled
    public Static String generateRADARRequest(Map<String,String> requestData){
        try{
            String DocumentNumber = requestData.get('documentNumber');
            String docType;
            Integer accountNumber;
            String month;
            String year;
            String includePOD = 'N';            
            if(requestData.get('opeartion') == scc_constantHelper.INVOICE){
                docType = '02';
            }else if(requestData.get('opeartion') == scc_constantHelper.INVOICE_AND_POD){
                docType = '02';
                includePOD = 'Y';
            }else if(requestData.get('opeartion') == scc_constantHelper.POD){
                docType = 'PD';
            }else if(requestData.get('opeartion') == scc_constantHelper.STATEMENT){
                docType = '01';
                accountNumber = Integer.valueOf(requestData.get('accountNumber'));
                month = requestData.get('month');                
                if(requestData.get('year') =='Current year'){
                    year = String.valueOf(System.today().year());
                }else if(requestData.get('year') =='Last year'){
                    year = String.valueOf(System.today().year()-1);
                }else if(requestData.get('year') =='Prior year'){
                    year = String.valueOf(System.today().year()-2);
                }                
            }else if(requestData.get('opeartion') == scc_constantHelper.DEBIT_MEMO){
                docType = 'DM';
            }else if(requestData.get('opeartion') == scc_constantHelper.CREDIT_MEMO){
                docType = '03';
            }            
            String emailId = requestData.get('emailId');
            String combined = requestData.get('Combined');            
            String requestString ='{"DocumentNumber":"'+documentNumber+'","DocType":"'+docType+'","EmailID":"'+emailId+'","Combined":"'+combined+'","IncludePOD":"'+includePOD+'","AccountNumber":'+accountNumber+',"Month":"'+month+'","Year":"'+year+'"}';
            system.debug('Request is'+requestString);
            scc_documents_RADAR_Controller makeIt = new scc_documents_RADAR_Controller();
            String pdfContent = makeIt.performRADARCallout(requestString); 
            return pdfContent;
        }catch(Exception e){
            System.debug(scc_constantHelper.EXCEPTION_TYPE_CAUGHT+ e.getTypeName());    
            System.debug(scc_constantHelper.MESSAGE+ e.getMessage());    
            System.debug(scc_constantHelper.CAUSE+ e.getCause());    // returns null
            System.debug(scc_constantHelper.LINE_NUMBER + e.getLineNumber());    
            System.debug(scc_constantHelper.STACK_RACE+ e.getStackTraceString());
            return '';
        }        
    }
/**
*  Description: This method gnerates request for radar      
*  @name: performRADARCallout
*  @param:request String
*  @return: pdf Content for generateRADARRequest
*  @throws exception- 
*/    
    public String performRADARCallout(String requestString){
        HttpResponse response ;
        try{
            String token = getRADARToken();
            Http http1 = new Http();    
            HttpRequest request = new HttpRequest();
            request.setMethod('POST');
            request.setHeader('Content-Type','application/json');
            request.setHeader('Authorization', 'Bearer '+token);
            request.setTimeout(120000);
            request.setEndpoint(endPoint);
            request.setBody(requestString);
            response = http1.send(request);
            system.debug('Response is'+response.getBody());
            Map<String,Object> map_results = (Map<String,Object>) JSON.deserializeUntyped(response.getBody());
            String content = (String)map_results.get('Filestreams');
            
            if(Boolean.valueOf(Label.scc_Insert_Logs)){
                createIntegrationLogs('RADAR',requestString,response.getBody(),'Success',String.valueOf(response.getStatusCode()),contactId,contactEmail,true,userType,userID,entryPoint);
            }
            
            return content;
        }catch(Exception e){
            System.debug(scc_constantHelper.EXCEPTION_TYPE_CAUGHT+ e.getTypeName());    
            System.debug(scc_constantHelper.MESSAGE+ e.getMessage());    
            System.debug(scc_constantHelper.CAUSE+ e.getCause());    // returns null
            System.debug(scc_constantHelper.LINE_NUMBER + e.getLineNumber());    
            System.debug(scc_constantHelper.STACK_RACE+ e.getStackTraceString());
            if(Boolean.valueOf(Label.scc_Insert_Logs)){
                if(response !=null){
                    createIntegrationLogs('RADAR',requestString,String.isBlank(response.getBody())?'NULL':response.getBody(),'Error',e.getLineNumber() + ': ' + e.getMessage(),contactId,contactEmail,true,userType,userID,entryPoint);                        
                }else{
                    createIntegrationLogs('RADAR',requestString,'','Error',e.getLineNumber() + ': ' + e.getMessage(),contactId,contactEmail,true,userType,userID,entryPoint);                                                
                }
            }
            return '';
        }
    }
    
    /**
*  Description: This method gnerates request for radar      
*  @name: getRADARToken
*  @param:No parameters
*  @return: token for radar request api call
*  @throws exception- 
*/    
    public String getRADARToken(){
        HTTPResponse res;
        HttpRequest req;
        String requestBody;
        try{
            req = new HttpRequest();
            req.setEndpoint(tokenURL);
            req.setMethod('POST');
            req.setHeader('Content-Type', 'application/JSON');
            requestBody = 'username='+userName+'&password='+password+'&grant_type='+grantType;		
            req.setBody(requestBody);
            Http http = new Http();
            res = http.send(req);
            System.debug(res.getBody());
            Map<String,Object> map_results = (Map<String,Object>) JSON.deserializeUntyped(res.getBody());
            String token = (String)map_results.get('access_token');
            if(Boolean.valueOf(Label.scc_Insert_Logs)){
                createIntegrationLogs('RADAR',requestBody,res.getBody(),'Success',String.valueOf(res.getStatusCode()),contactId,contactEmail,false,userType,userID,entryPoint);            
            }
            return token;
        }catch(Exception e){
            System.debug(scc_constantHelper.EXCEPTION_TYPE_CAUGHT+ e.getTypeName());    
            System.debug(scc_constantHelper.MESSAGE+ e.getMessage());    
            System.debug(scc_constantHelper.CAUSE+ e.getCause());    // returns null
            System.debug(scc_constantHelper.LINE_NUMBER + e.getLineNumber());    
            System.debug(scc_constantHelper.STACK_RACE+ e.getStackTraceString()); 
            if(Boolean.valueOf(Label.scc_Insert_Logs)){
                if(res !=null){
                    createIntegrationLogs('RADAR',requestBody,String.isBlank(res.getBody())?'NULL':res.getBody(),'Error',e.getLineNumber() + ': ' + e.getMessage(),contactId,contactEmail,false,userType,userID,entryPoint);              
                }else{
                    createIntegrationLogs('RADAR',requestBody,'','Error',e.getLineNumber() + ': ' + e.getMessage(),contactId,contactEmail,false,userType,userID,entryPoint);                                      
                }
            }            	
            return '';
        }
    }
    
/**
*  Description: This method creates Integration Logs    
*  @name: createIntegrationLogs
*  @param:parameters like logType,requestBody etc.
*  @return: void
*  @throws exception- 
*/    
    public static void createIntegrationLogs(String logType, String requestBody, String responseBody, String status, String internalStatus, String contactId, String contactEmail,Boolean insertNow,String userType,String userID,String entryPoint){
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
            radarIntegrationLogs.add(integrationLog);
            if(insertNow == true){
                scc_IntegrationLogs_Helper.createSFCCIntegrationLogs(JSON.serialize(radarIntegrationLogs));
            }
        }catch(Exception e){
            System.debug(scc_constantHelper.EXCEPTION_TYPE_CAUGHT+ e.getTypeName());    
            System.debug(scc_constantHelper.MESSAGE+ e.getMessage());    
            System.debug(scc_constantHelper.CAUSE+ e.getCause());    // returns null
            System.debug(scc_constantHelper.LINE_NUMBER + e.getLineNumber());    
            System.debug(scc_constantHelper.STACK_RACE+ e.getStackTraceString()); 
        }
    }
}