/*
    @Author : Cognizant Team
    @Name : Savvas_SSO_IntegrationLogUtility
    @CreateDate : 11-June-2024
    @Description: This class is an utility class to create Integration Log records in SF.
    @ModifiedBy: Cognizant Team
    @ModifiedDate: 02-July-2024
    @Ticket Number: W-015367, W-015375, W-014598
*/
public with sharing class Savvas_SSO_IntegrationLogUtility {
    // Wrapper Class - IntegrationLogDetailsWrapper
    public class IntegrationLogDetailsWrapper{
        public String type;
        public String responseBody;
        public String requestBody;
        public String status;
        public String contactId;
        public String contactEmail;
        public String internalStatus;
    }
    /*
    *  Method Name : createIntegrationLogs
    *  Description : Method to create Integration Logs
    *  param : logType, requestBody, responseBody, status, internalStatus, contactId
    *  return : void
    */
    @future
    public static void createIntegrationLogs(String logType, String requestBody, String responseBody, String status, String internalStatus, String contactId, String contactEmail){
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
}