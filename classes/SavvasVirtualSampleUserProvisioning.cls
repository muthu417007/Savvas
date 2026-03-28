/*
@Author : Cognizant Team
@Name : SavvasVirtualSampleUserProvisioning
@CreateDate : 12-Aug-2023
@Description: This class ivoked when User submits Registration Form
@ModifiedBy: Cognizant Team
@ModifiedDate: 16-Aug-2024
@Ticket Number: W-014602,W-015376
*/
@RestResource(urlMapping='/userregistration')
global without sharing class SavvasVirtualSampleUserProvisioning {
    /*
    @Author : Cognizant Team
    @name : validateContact
    @Description : Method to validate if contact exists and send response
    @param : NA
    @return : NA
    */   
    @HttpPost
    global static void validateContact() {
        RestRequest req = RestContext.request;
        RestResponse response = RestContext.response;
        APIResponseBody responseBody = new APIResponseBody();
        SavvasVirtualSampleLogsUtilty.LogDetailsWrapper logDetails = new SavvasVirtualSampleLogsUtilty.LogDetailsWrapper();
        String requestBody;
        String contactId;
        try{
            requestBody = req.requestBody.toString();
            APIRequestBody requestDetails = (APIRequestBody)JSON.deserialize(requestBody, APIRequestBody.class);
            if(requestDetails != null) {  
                logDetails.type = 'User Registration';
                logDetails.requestBody = requestBody;        
                response.addHeader('Access-Control-Allow-Origin', Label.Pardot_Url_To_Whitelist);
                response.addHeader('Access-Control-Allow-Header', 'Origin,X-Requested-With,Content-Type,Accept');
                requestDetails.email = (requestDetails.email).trim();
                requestDetails.accountId = (requestDetails.accountId).trim();
                List<User> userList = SavvasVirtualSampleUserSelector.getUserList(requestDetails.email);
                if(!userList.isEmpty()){
                    //if user's account is same as in request body
                    if(requestDetails.accountId == userList[0].AccountId && userList[0].AccountId!= null){
                        //call helper method
                        SavvasVirtualSampleUserProvHelper.LogDetailsWrapper ldw = SavvasVirtualSampleUserProvHelper.updateUserAccess(userList[0],requestBody);
                        //on existing user registration
                        if(ldw.status && ldw.message == 'EXISTING_USER_ACCESS_UPDATED'){
                            responseBody.statusMsg = 'EXISTING_USER_ACCESS_UPDATED';
                            responseBody.statusCode = 3;
                        }
                        //on duplicate user registration
                        else if (ldw.status && ldw.message == 'DUPLICATE_ACCESS_UPDATE_REQUEST') {
                            responseBody.statusMsg = 'DUPLICATE_ACCESS_UPDATE_REQUEST';
                            responseBody.statusCode = 2;
                        }
                        //for other faliures
                        else if(!ldw.status){
                            responseBody.statusMsg = 'CONTACT_SYSTEM_ADMINISTRATOR';
                            responseBody.statusCode = 4;
                        }
                        responseBody.contactValidation = true;
                        logDetails.contactId = userList[0].ContactId;
                        logDetails.internalStatus = ldw.message;
                        String body = JSON.serializePretty(responseBody);
                        response.responseBody = Blob.valueOf(body);
                    }
                    else{
                        //if user's account is different from request body
                        responseBody.statusMsg = 'CONTACT_SYSTEM_ADMINISTRATOR';
                        responseBody.statusCode = 4;
                        responseBody.contactValidation = true;
                        logDetails.contactId = userList[0].ContactId;
                        logDetails.internalStatus = 'USER_EXISTS_UNDER_DIFFERENT_SCHOOL';
                        String body = JSON.serializePretty(responseBody);
                        response.responseBody = Blob.valueOf(body);
                    }
                }
                //user does not exists
                else{
                    List<Contact> contactList = SavvasVirtualSampleContactSelector.getContactBySchoolId(requestDetails.email, requestDetails.accountId);
                    //if contact matches
                    if(!contactList.isEmpty()){
                        contactId = contactList[0].Id;
                        responseBody.statusMsg = 'CONTACT_FOUND';
                        responseBody.contactValidation = true;
                        SavvasVirtualSampleUserProvHelper.LogDetailsWrapper ldw = SavvasVirtualSampleUserProvHelper.registerNewUser(contactList[0],requestBody);
                        // On succcess of registerNewUser
                        if(ldw.status){
                            responseBody.statusMsg = 'NEW_USER_REGISTERED';
                            responseBody.statusCode = 1;
                            responseBody.contactValidation = true;
                        }
                        // On faliures of registerNewUser
                        else {
                            responseBody.statusMsg = 'CONTACT_SYSTEM_ADMINISTRATOR';
                            responseBody.statusCode = 4;  
                            responseBody.contactValidation = true;
                            logDetails.internalStatus = ldw.message;
                        }

                        logDetails.contactId = contactList[0].Id;
                        logDetails.internalStatus = ldw.message;
                        String body = JSON.serializePretty(responseBody);
                        response.responseBody = Blob.valueOf(body);
                    }
                    else{
                        //if contact does not matches
                        responseBody.statusMsg = 'CONTACT_NOT_FOUND';
                        responseBody.contactValidation = false;
                        responseBody.statusCode = 0;
                        logDetails.internalStatus = 'CONTACT_NOT_FOUND';
                        String body = JSON.serializePretty(responseBody);
                        response.responseBody = Blob.valueOf(body);
                    }
                }
                if(Boolean.valueOf(Label.Savvas_Insert_Logs)){
                    logDetails.responseBody =(response.responseBody).toString().length()>1000?((response.responseBody).toString()).subString(0,1000):(response.responseBody).toString();
                    logDetails.status = 'Success';
                    logDetails.contactEmail = requestDetails.email;
                    SavvasVirtualSampleLogsUtilty.createIntegrationLogsWithStatus(logDetails.type,logDetails.requestBody, logDetails.responseBody, logDetails.status, logDetails.internalStatus, logDetails.contactId,logDetails.contactEmail);
                }
            }
        }
        catch (Exception ex) {
            response.statusCode = 500;
            responseBody.statusMsg = 'AN ERROR OCCURED. PLEASE CONTACT YOUR ORG ADMIN. Error---> '+ex.getMessage() + ' '+ex.getLineNumber();
            responseBody.contactValidation = false;
            String body = JSON.serializePretty(responseBody);
            response.responseBody = Blob.valueOf(body);
            logDetails.responseBody =JSON.serialize(responseBody);
            logDetails.status = 'Error';
            logDetails.internalStatus = ex.getLineNumber() + ': ' + ex.getMessage();
            SavvasVirtualSampleLogsUtilty.createIntegrationLogsWithStatus(logDetails.type,logDetails.requestBody, logDetails.responseBody, logDetails.status, logDetails.internalStatus, logDetails.contactId,logDetails.contactEmail);
        }

    }
    public class APIRequestBody {
        public string firstName;
        public string lastName;
        public string email;
        public string productOfInterest;
        public string collectionName;
        public String program_desc;
        public String collection_itemId;
        public String collectionId;
        public String programType;
        public String campaignId;//W-013769
        public String userRole;//W-013769
        public List<collectionDetails> collectionDetails;
        public String accountId;//W-015376 added accountId in request of SchoolFinder API
        public String accountName;//W-015376 added accountName in request of SchoolFinder API
    }
    public class collectionDetails {
        public string assetName;
        public string entityId;
        public string thumbnailId;
        public string assetUrl;
        public string usage_desc;
        public string asset_itemId;
    }
    public class APIResponseBody {
        public Boolean contactValidation;
        public String statusMsg;
        public Integer statusCode;
    }
}