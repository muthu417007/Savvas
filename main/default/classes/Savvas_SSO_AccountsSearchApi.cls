/*
    @Author : Cognizant Team
    @Name : Savvas_SSO_AccountsSearchApi
    @CreateDate : 11-June-2024
    @Description: This class is a RestResource API that exposes School/Dealer Accounts searching utility.
    @ModifiedBy: Cognizant Team
    @ModifiedDate: 02-July-2024
    @Ticket Number: W-015367, W-015375
*/
@RestResource(urlMapping='/accountsSearch')
global without sharing class Savvas_SSO_AccountsSearchApi {
    // Wrapper class for API Request Body
    public class APIRequestBody {
        public String email;
        public String appName;
    }
    // Wrapper class for API Response Body
    public class APIResponseBody {
        public string statusMsg;
        public Integer statusCode;
        public List<Savvas_SSO_AccountsSearchHelper.AccountWrapper> accounts;
        public String email;
        public String firstName;
        public String lastName;
    }
    /*
    *  Method Name : postSSOAccountsApiRequest
    *  Description : Fetch Accounts to return in the Account Search response to Cold Fusion
    *  param : NA
    *  return : void
    */
    @HttpPost
    global static void postSSOAccountsApiRequest(){
        RestRequest req = RestContext.request;
        RestResponse response = RestContext.response;
        // response.addHeader('Access-Control-Allow-Origin', Label.Savvas_SSO_Url_To_Whitelist);
        // response.addHeader('Access-Control-Allow-Header', 'Origin,X-Requested-With,Content-Type,Accept');
        APIResponseBody responseBody = new APIResponseBody();
        String requestBody;
        Savvas_SSO_IntegrationLogUtility.integrationLogDetailsWrapper logDetails = new Savvas_SSO_IntegrationLogUtility.integrationLogDetailsWrapper();
        logDetails.type = Savvas_SSO_ConstantsUtil.accountsSearchLogType;
        try{
            requestBody = req.requestBody.toString();
            logDetails.requestBody = requestBody;
            APIRequestBody requestDetails = (APIRequestBody)JSON.deserialize(requestBody, APIRequestBody.class);
            if(requestDetails!=null){
                requestDetails.email = (requestDetails.email).trim();
                requestDetails.appName = (requestDetails.appName).trim();
                // Try to fetch Contacts related to Email in requestBody
                Savvas_SSO_AccountsSearchHelper.ContactWrapper contactWrapper = Savvas_SSO_AccountsSearchHelper.getContactList(requestDetails.email, requestDetails.appName);
                if(!contactWrapper.contactList.isEmpty()){
                    // Try to fetch the map<AccountId,accountName>
                    List<Savvas_SSO_AccountsSearchHelper.AccountWrapper> accounts = Savvas_SSO_AccountsSearchHelper.getAccounts(contactWrapper.contactList);
                    if(!accounts.isEmpty()){
                        // If map<AccountId,accountName> is successfully created.
                        responseBody.statusMsg = contactWrapper.userFound?'EXISTING_VS_USER_FOUND':Savvas_SSO_ConstantsUtil.accountFound;
                        responseBody.statusCode = contactWrapper.userFound?2:1;
                        responseBody.accounts = accounts;
                        responseBody.email = contactWrapper.contactList.get(0).Email;
                        responseBody.firstName = contactWrapper.contactList.get(0).FirstName;
                        responseBody.lastName = contactWrapper.contactList.get(0).LastName;
                        logDetails.status = Savvas_SSO_ConstantsUtil.success;
                        logDetails.internalStatus = contactWrapper.userFound?'EXISTING_VS_USER_FOUND':Savvas_SSO_ConstantsUtil.accountFound;
                        logDetails.contactId = contactWrapper.contactList.get(0).Id;
                    }
                    else{
                        // If map<AccountId,accountName> could not be created.
                        responseBody.statusMsg = Savvas_SSO_ConstantsUtil.accountNotFoundLog;
                        responseBody.statusCode = 0;
                        responseBody.email = EncodingUtil.urlEncode(requestDetails.email, 'UTF-8');
                        logDetails.status = Savvas_SSO_ConstantsUtil.error;
                        logDetails.internalStatus =  Savvas_SSO_ConstantsUtil.accountNotFoundLog;
                    }
                }
                else{
                    // If Contact records could not be found with supplied Email Address.
                    responseBody.statusMsg = Savvas_SSO_ConstantsUtil.contactNotFoundLog;
                    responseBody.statusCode = 0;
                    responseBody.email = EncodingUtil.urlEncode(requestDetails.email, 'UTF-8');
                    logDetails.status = Savvas_SSO_ConstantsUtil.error;
                    logDetails.internalStatus =  Savvas_SSO_ConstantsUtil.contactNotFoundLog;
                }
                logDetails.contactEmail = requestDetails.email;
                String body = JSON.serializePretty(responseBody);
                response.responseBody = Blob.valueOf(body);
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