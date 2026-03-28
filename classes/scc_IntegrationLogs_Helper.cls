/**************************************************************************************** 
* @Class Name  - scc_IntegrationLogs_Helper
* @description - class to Insert Integration Logs
* @Created By  - Vaibhav Saptal (Cognizant)
* @Created On - 2024-08-23
* ***************************************************************************************/ 
public without sharing class scc_IntegrationLogs_Helper {
    /*
*  Method Name : createSFCCIntegrationLogs
*  Description : Method to create Integration Logs
*  param : Strigified list of logs
*  return : void
*/
    
    @future
    public static void createSFCCIntegrationLogs(String ListOfLogs){
        try{
            List<Integration_Logs__c> ListOfLogs1 = (List<Integration_Logs__c>) JSON.deserialize(ListOfLogs,List<Integration_Logs__c>.class);
            if(Boolean.valueOf(Label.scc_Insert_Logs)){
                Insert ListOfLogs1;
            }
        }catch(Exception e){
            System.debug(scc_constantHelper.EXCEPTION_TYPE_CAUGHT+ e.getTypeName());    
            System.debug(scc_constantHelper.MESSAGE+ e.getMessage());    
            System.debug(scc_constantHelper.CAUSE+ e.getCause());    // returns null
            System.debug(scc_constantHelper.LINE_NUMBER + e.getLineNumber());    
            System.debug(scc_constantHelper.STACK_RACE+ e.getStackTraceString());
        }
    }
    
    /*
*  Method Name : createIntegrationLogsLWC
*  Description : Method to create Integration Logs
*  param : logType, requestBody, responseBody, status, internalStatus, contactId etc.
*  return : void
*/
    
    @AuraEnabled
    public static void createIntegrationLogsLWC(String logType, String requestBody, String responseBody, String status, String internalStatus){
        try{
            String contactId='';
            String contactEmail='';
            String userType='';
            String userID='';
            List<User> usr = [SELECT ID,Email, Profile.Name, IsEmployee__c,Contact.Id, Contact.AccountID,Contact.Email,Contact.Account.SAP_Account_Id__c, contact.name, contact.Account.name FROM User WHERE Id = :UserInfo.getUserId()]; 
            if(usr[0].Profile.Name =='Savvas External Users Base Profile'){
                contactId = usr[0].Contact.Id;
                contactEmail = usr[0].Contact.Email;
                userType = 'External User';
            }else if(usr[0].Profile.Name =='MySavvasOrders Profile'){
                contactEmail = 'MySavvasOrders Guest User';
                userType = 'Guest User';
            }else{
                contactEmail = '';
                userType = 'Internal User';
                userID = usr[0].ID;
            } 
            createIntegrationLogs(logType, requestBody, responseBody, status,internalStatus,contactId, contactEmail,userType);
        }catch(Exception e){
            System.debug(scc_constantHelper.EXCEPTION_TYPE_CAUGHT+ e.getTypeName());    
            System.debug(scc_constantHelper.MESSAGE+ e.getMessage());    
            System.debug(scc_constantHelper.CAUSE+ e.getCause());    // returns null
            System.debug(scc_constantHelper.LINE_NUMBER + e.getLineNumber());    
            System.debug(scc_constantHelper.STACK_RACE+ e.getStackTraceString());
        }
    }
    /*
*  Method Name : createIntegrationLogsLWC1
*  Description : Method to create Integration Logs
*  param : logType, requestBody, responseBody, status, internalStatus, contactId etc.
*  return : void
*/    
    @AuraEnabled
    public static void createIntegrationLogsLWC1(String logType, String requestBody, String responseBody, String status, String internalStatus,String entryPoint){
        try{
            String contactId='';
            String contactEmail='';
            String userType='';
            String userID='';
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
            
            if(Boolean.valueOf(Label.scc_Insert_Logs)){
                createIntegrationLogs1(logType, requestBody, responseBody, status,internalStatus,contactId, contactEmail,userType,entryPoint);
            } 
            
        }catch(Exception e){
            System.debug(scc_constantHelper.EXCEPTION_TYPE_CAUGHT+ e.getTypeName());    
            System.debug(scc_constantHelper.MESSAGE+ e.getMessage());    
            System.debug(scc_constantHelper.CAUSE+ e.getCause());    // returns null
            System.debug(scc_constantHelper.LINE_NUMBER + e.getLineNumber());    
            System.debug(scc_constantHelper.STACK_RACE+ e.getStackTraceString());
        }
    }
    
    /*
*  Method Name : createIntegrationLogs
*  Description : Method to create Integration Logs
*  param : logType, requestBody, responseBody, status, internalStatus, contactId
*  return : void
*/
    @future
    public static void createIntegrationLogs(String logType, String requestBody, String responseBody, String status, String internalStatus, String contactId, String contactEmail,String userType){
        try{
            Integration_Logs__c integrationLog = new Integration_Logs__c(
                Type__c = logType,
                Request_Body__c = requestBody,
                Response_Body__c = responseBody.toString().length()>1000 ? responseBody.toString().subString(0,1000) : responseBody.toString(),
                Status__c = status,
                Internal_Status__c = internalStatus,
                contact__c = String.isBlank(contactId)?NULL:contactId,
                scc_User_Type__c = userType,
                Contact_Email__c = contactEmail
            );
            
            if(Boolean.valueOf(Label.scc_Insert_Logs)){
                Insert integrationLog;
            }
        }catch(Exception e){
            System.debug(scc_constantHelper.EXCEPTION_TYPE_CAUGHT+ e.getTypeName());    
            System.debug(scc_constantHelper.MESSAGE+ e.getMessage());    
            System.debug(scc_constantHelper.CAUSE+ e.getCause());    // returns null
            System.debug(scc_constantHelper.LINE_NUMBER + e.getLineNumber());    
            System.debug(scc_constantHelper.STACK_RACE+ e.getStackTraceString());
        }
    }  
    
    @future
    public static void createIntegrationLogs1(String logType, String requestBody, String responseBody, String status, String internalStatus, String contactId, String contactEmail,String userType,String entryPoint){
        try{
            Integration_Logs__c integrationLog = new Integration_Logs__c(
                Type__c = logType,
                Request_Body__c = requestBody,
                Response_Body__c = responseBody.toString().length()>1000 ? responseBody.toString().subString(0,1000) : responseBody.toString(),
                Status__c = status,
                Internal_Status__c = internalStatus,
                contact__c = String.isBlank(contactId)?NULL:contactId,
                scc_User_Type__c = userType,
                Contact_Email__c = contactEmail,
                Entry_Point__c = entryPoint
            );
            
            if(Boolean.valueOf(Label.scc_Insert_Logs)){
                Insert integrationLog;
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