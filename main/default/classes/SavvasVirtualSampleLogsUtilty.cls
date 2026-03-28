/*
@Author : Cognizant Team
@Name : SavvasVirtualSampleLogsUtilty
@CreateDate : 12-Oct-2023
@Description: This class is creating IntegrationLogs and ApplicationLogs
@ModifiedBy: Cognizant Team
@ModifiedDate: 16-Aug-2024
@Ticket Number: VS-0022, W-015376
*/
public without sharing class SavvasVirtualSampleLogsUtilty {
    
    /*
    *  Method Name : createIntegrationLogs
    *  Description : creating IntegrationLogs records
    *  param : logDetails
    *  return : none
    */
    public static void createIntegrationLogs(LogDetailsWrapper logDetails){
        Integration_Logs__c integrationLog = new Integration_Logs__c(Type__c=logDetails.type,
                                                                     Request_Body__c =logDetails.requestBody,
                                                                     Response_Body__c =logDetails.responseBody,
                                                                     Status__c = logDetails.status,
                                                                     contact__c = String.isBlank(logDetails.contactId)?NULL:logDetails.contactId
                                                                    );
           Insert integrationLog;

    }
    
    /*
    *  Method Name : createIntegrationLogsWithStatus
    *  Description : creating IntegrationLogs records
    *  param : logType, requestBody, responseBody, status, internalStatus, contactId, contactEmail
    *  return : none
    *  Ticket Number : W-015376
    */
    @future
    public static void createIntegrationLogsWithStatus(String logType, String requestBody, String responseBody, String status, String internalStatus, String contactId,String contactEmail){
        Integration_Logs__c integrationLog = new Integration_Logs__c(
            Type__c = logType,
            Request_Body__c = requestBody,
            Response_Body__c = responseBody,
            Status__c = status,
            Internal_Status__c = internalStatus,
            contact__c = String.isBlank(contactId)?NULL:contactId,
           	Contact_Email__c = contactEmail
        );
        if(Schema.sObjectType.Integration_Logs__c.isCreateable()){
            Insert integrationLog;
        }
    } 
    /*
    *  Method Name : createApplicationLogs
    *  Description : creating ApplicationLogs records
    *  param : Exception and user Id
    *  return : none
    */
    public static void createApplicationLogs(Exception ex,Id userId){
        Savvas_Application_Logs__c applicationLog = new Savvas_Application_Logs__c(Line_Number__c=ex.getLineNumber(),
                                                                                   Message__c=ex.getMessage(), User__c = userId,
                                                                                   Stack_Trace_String__c=ex.getStackTraceString(),
                                                                                   Type_Name__c=ex.getTypeName());
        Insert applicationLog;
    }
    
    public class LogDetailsWrapper{
        public String type;
        public String responseBody;
        public String requestBody;
        public String status;
        public String contactId;
        public String contactEmail; //W-015376
        public String internalStatus; //W-015376
    }
    
    public class ApplicationLogWrapper{
        public Integer lineNumber;
        public String message;
        public String stackTrace;
        public String typeOfError;
    }
    
}