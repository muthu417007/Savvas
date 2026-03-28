/*
    @Author : Cognizant Team
    @Name : Savvas_SSO_UserProvisioningApi
    @CreateDate : 04-June-2024
    @Description: This class is a RestResource API that exposes user provisioning functionality.
    @ModifiedBy: Cognizant Team
    @ModifiedDate: 02-July-2024
    @Ticket Number: W-014598
*/
@RestResource(urlMapping='/ssoUserProvisioning')
global without sharing class Savvas_SSO_UserProvisioningApi {
    // Wrapper class for API Request Body
    public class APIRequestBody {
        public String firstName;
        public String lastName;
        public String email;
        public String accountId;
        public String appName;
    }
    // Wrapper class for API Response Body
    public class APIResponseBody {
        public string statusMsg;
        public Integer statusCode;
        public String email;
    }
    /*
    *  Method Name : postSSOUserProvisioningRequest
    *  Description : Performs user provisioning on POST request
    *  param : NA
    *  return : void
    */
    @HttpPost
    global static void postSSOUserProvisioningRequest(){
        RestRequest req = RestContext.request;
        RestResponse response = RestContext.response;
        // response.addHeader('Access-Control-Allow-Origin', Label.Savvas_SSO_Url_To_Whitelist);
        // response.addHeader('Access-Control-Allow-Header', 'Origin,X-Requested-With,Content-Type,Accept');
        APIResponseBody responseBody = new APIResponseBody();
        String requestBody;
        Savvas_SSO_IntegrationLogUtility.integrationLogDetailsWrapper logDetails = new Savvas_SSO_IntegrationLogUtility.integrationLogDetailsWrapper();
        logDetails.type = Savvas_SSO_ConstantsUtil.userProvisioninglogType;
        try{
            requestBody = req.requestBody.toString();
            logDetails.requestBody = requestBody;
            APIRequestBody requestDetails = (APIRequestBody)JSON.deserialize(requestBody, APIRequestBody.class);
            if(requestDetails!=null){
                requestDetails.email = (requestDetails.email).trim();
                requestDetails.appName = (requestDetails.appName).trim();
                requestDetails.accountId = (requestDetails.accountId).trim();
                requestDetails.firstName = (requestDetails.firstName).trim();
                requestDetails.lastName = (requestDetails.lastName).trim();
                // Try to Fetch User using email address in request body.
                List<User> userList = Savvas_SSO_UserProvisioningHelper.getUserList(requestDetails.email);
                if(!userList.isEmpty()){
                    // If user found, call updateUserAccess method from helper class.
                    Savvas_SSO_UserProvisioningHelper.LogDetailsWrapper ldw = Savvas_SSO_UserProvisioningHelper.updateUserAccess(userList[0], requestDetails.appName);
                    // On success of updateUserAccess.
                    if(ldw.status){
                        responseBody.statusMsg = Savvas_SSO_ConstantsUtil.successUserRegLog;
                        responseBody.statusCode = 1;
                        logDetails.status = Savvas_SSO_ConstantsUtil.success;
                    }
                    // On Duplicate User access request
                    else if(ldw.message == Savvas_SSO_ConstantsUtil.duplicateAccessFailLog){
                        responseBody.statusMsg = Savvas_SSO_ConstantsUtil.duplicateAccessFailLog;
                        responseBody.statusCode = 3;
                        logDetails.status = Savvas_SSO_ConstantsUtil.error;
                    }
                    // On User Provisioning Failures
                    else{
                        responseBody.statusMsg = Savvas_SSO_ConstantsUtil.failedUserRegLog;
                        responseBody.statusCode = 0;
                        logDetails.status = Savvas_SSO_ConstantsUtil.error;
                    }
                    logDetails.contactId = userList[0].ContactId;
                    logDetails.contactEmail = requestDetails.email;
                    logDetails.internalStatus = ldw.message;
                    responseBody.email = EncodingUtil.urlEncode(requestDetails.email, 'UTF-8');
                    String body = JSON.serializePretty(responseBody);
                    response.responseBody = Blob.valueOf(body);
                }
                // If user not found with email address in request body.
                else{
                    // Try to fetch valid contact with accountId and email address from request body.
                    List<Contact> contactList = Savvas_SSO_UserProvisioningHelper.getContactList(requestDetails.email, requestDetails.accountId, null);
                    if(!contactList.isEmpty()){
                        // If contact found call registerNewUser from helper class.
                        Savvas_SSO_UserProvisioningHelper.LogDetailsWrapper ldw = Savvas_SSO_UserProvisioningHelper.registerNewUser(requestDetails.email, requestDetails.firstName, requestDetails.lastName, contactList[0], requestDetails.appName);
                        // On succcess of registerNewUser
                        if(ldw.status){
                            responseBody.statusMsg = Savvas_SSO_ConstantsUtil.successUserRegLog;
                            responseBody.statusCode = 1;
                            logDetails.status = Savvas_SSO_ConstantsUtil.success;
                        }
                        // On User Access Failures
                        else{
                            responseBody.statusMsg = Savvas_SSO_ConstantsUtil.failedUserRegLog;
                            responseBody.statusCode = 0;
                            logDetails.status = Savvas_SSO_ConstantsUtil.error;
                        }
                        logDetails.contactId = contactList[0].Id;
                        logDetails.contactEmail = requestDetails.email;
                        logDetails.internalStatus = ldw.message;
                        responseBody.email = EncodingUtil.urlEncode(requestDetails.email, 'UTF-8');
                        String body = JSON.serializePretty(responseBody);
                        response.responseBody = Blob.valueOf(body);
                    }
                    // If valid contact is not found with email address and AccountId in request body.
                    else{
                        responseBody.statusMsg = Savvas_SSO_ConstantsUtil.contactNotFoundLog;
                        responseBody.statusCode = 2;
                        responseBody.email = EncodingUtil.urlEncode(requestDetails.email, 'UTF-8');
                        logDetails.status = Savvas_SSO_ConstantsUtil.error;
                        logDetails.internalStatus = Savvas_SSO_ConstantsUtil.contactNotFoundLog;
                        logDetails.contactEmail = requestDetails.email;
                        String body = JSON.serializePretty(responseBody);
                        response.responseBody = Blob.valueOf(body);
                    }
                }
                // If Integration logs are enabled - Create a new integration log
                if(Boolean.valueOf(Label.Savvas_Insert_Logs)){
                    logDetails.responseBody=(response.responseBody).toString().length()>1000?((response.responseBody).toString()).subString(0,1000):(response.responseBody).toString();
                    Savvas_SSO_IntegrationLogUtility.createIntegrationLogs(logDetails.type,logDetails.requestBody, logDetails.responseBody, logDetails.status, logDetails.internalStatus, logDetails.contactId, logDetails.contactEmail);
                }
            }
        }
        // On unhandled exceptions
        catch(Exception ex){
            response.statusCode = 500;
            responseBody.statusMsg = Savvas_SSO_ConstantsUtil.apiErrorLog;
            String body = JSON.serializePretty(responseBody);
            response.responseBody = Blob.valueOf(body);
            logDetails.responseBody = JSON.serialize(responseBody);
            logDetails.internalStatus = ex.getLineNumber() + ': ' + ex.getMessage();
            logDetails.status = Savvas_SSO_ConstantsUtil.error;
            Savvas_SSO_IntegrationLogUtility.createIntegrationLogs(logDetails.type,logDetails.requestBody, logDetails.responseBody, logDetails.status, logDetails.internalStatus, logDetails.contactId, logDetails.contactEmail);
        }
    }
}