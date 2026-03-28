/*
@Author : Cognizant Team
@Name : SavvasDigitalSamplesService
@CreateDate : 23-Jan-2023
@Description: This class gets called when User submits Registration Form
@ModifiedBy: Cognizant Team
@ModifiedDate: 02-Nov-2023
@Ticket Number: VS-0011,VS-0022
@This class has been deprecated as part of SSO project to accomodate the new account contact validation logic as per new requirements. 
User story number for reference: W-015376
New Class for reference : SavvasVirtualSampleUserProvisioning
*/
//@RestResource(urlMapping='/userregistration/*')
global without sharing class SavvasDigitalSamplesService {
    /*
@Author : Cognizant Team
@name : validateContact
@Description : Method to validate if contact exists and send response
*/   
/*    @HttpPost
    global static void validateContact() {
        RestRequest req = RestContext.request;
        RestResponse response = RestContext.response;
        APIResponseBody responseBody = new APIResponseBody();
        SavvasVirtualSampleLogsUtilty.LogDetailsWrapper logDetails = new SavvasVirtualSampleLogsUtilty.LogDetailsWrapper();
        String requestBody;
        String contactId;
        try {
            requestBody = req.requestBody.toString();
            APIRequestBody requestDetails = (APIRequestBody)JSON.deserialize(requestBody, APIRequestBody.class);
            if(requestDetails != null) {    
                logDetails.type = 'User Registration';
                logDetails.requestBody = requestBody;        
                response.addHeader('Access-Control-Allow-Origin', Label.Pardot_Url_To_Whitelist);
                response.addHeader('Access-Control-Allow-Header', 'Origin,X-Requested-With,Content-Type,Accept');
                requestDetails.email = (requestDetails.email).trim();
                List<Contact> contactList;
                contactList = SavvasVirtualSampleContactSelector.getContactByEmail(requestDetails.email);
                //if contact not found 'contact system admin' else check collection access and user
                if(contactList.isEmpty()) {
                    responseBody.statusMsg = 'CONTACT_NOT_FOUND';
                    responseBody.contactValidation = false;
                    responseBody.statusCode = 0;
                    String body = JSON.serializePretty(responseBody);
                    response.responseBody = Blob.valueOf(body);
                } 
                else {
                    contactId = contactList[0].Id;
                    responseBody.statusMsg = 'CONTACT_FOUND';
                    responseBody.contactValidation = true;
                    List<user> userList;
                    List<Collection_Access__c> collectionAccess;
                    List<Collection_Access__c> collectionAccessList;
                    userList = SavvasVirtualSampleUserSelector.getUserByContact(contactList[0].Id);
                    collectionAccess = SavvasVirtualSamplesCAccessSelector.getCAListByContact(contactList[0].Id,requestDetails.collectionId);
                    collectionAccessList = SavvasVirtualSamplesCAccessSelector.getCAListByName(contactList[0].Id,requestDetails.collectionId);
                    //If active user doesnt exists and have collection access
                    if(userList.isEmpty() && (!collectionAccess.isEmpty()|| !collectionAccessList.isEmpty())){
                        responseBody.statusMsg = 'CONTACT_SYSTEM_ADMINISTRATOR';
                        responseBody.statusCode = 4;
                    }
                    //if no active user exists
                    else if(userList.isEmpty()){
                        responseBody.statusMsg='NEW_USER_REGISTERED';   
                        responseBody.statusCode = 1;
                    }
                    if(requestDetails.programType =='1.0'){
                        set<String> siteCoreIds = new set<String>();
                        List<Sitecore_Asset__c> assetsList = new List<Sitecore_Asset__c>();
                        Integer existingAssetsCount;
                        if(String.isBlank(String.valueOf(responseBody.statusCode))){
                            for(CollectionDetails eachRecord: requestDetails.CollectionDetails){
                                siteCoreIds.add(eachRecord.asset_itemId);
                            }
                            if(!collectionAccessList.isEmpty()){
                                assetsList = SavvasVirtualSamplesSAssetSelector.getsitecoreAssetsByContactId(collectionAccessList[0].Id,contactList[0].Id);
                                if(!assetsList.isEmpty()){
                                    for(Sitecore_Asset__c eachAsset: assetsList){
                                        if(siteCoreIds.contains(eachAsset.Sitecore_Id__c)){
                                            siteCoreIds.remove(eachAsset.Sitecore_Id__c);
                                        }
                                    }
                                }
                            }
                            existingAssetsCount = siteCoreIds.size();
                            //if active user exists and new collection access
                            if((existingAssetsCount > 0 && !assetsList.isEmpty())||collectionAccessList.isEmpty()){
                                responseBody.statusMsg='EXISTING_USER_ACCESS_UPDATED';   
                                responseBody.statusCode = 3;
                            }
                            //if active user exists and duplicate access
                            else{
                                responseBody.statusMsg='DUPLICATE_ACCESS_UPDATE_REQUEST';
                                responseBody.statusCode = 2;
                            }
                        }
                        String body = JSON.serializePretty(responseBody);
                        response.responseBody = Blob.valueOf(body);
                        if(responseBody.statusCode!=2){
                            if((existingAssetsCount > 0 && !assetsList.isEmpty()) || (userList.isEmpty() && (!collectionAccess.isEmpty()|| !collectionAccessList.isEmpty()))) {
                                SavvasDigitalSamplesUserRegistration.updateUserAccess(contactList[0].Id, requestBody,TRUE);
                            } else if(responseBody.statusCode!=4) {
                                SavvasDigitalSamplesUserRegistration.registerNewUser(contactList[0].Id, requestBody);
                                SavvasDigitalSamplesUserRegistration.updateUserAccess(contactList[0].Id, requestBody,FALSE);
                            }
                        }
                    }
                    else if(requestDetails.programType == '2.0'){
                        if(String.isBlank(String.valueOf(responseBody.statusCode))){
                            if(!collectionAccessList.isEmpty()){
                                responseBody.statusMsg='DUPLICATE_ACCESS_UPDATE_REQUEST';
                                responseBody.statusCode = 2;
                            }
                            else if(collectionAccessList.isEmpty()){
                                responseBody.statusMsg='EXISTING_USER_ACCESS_UPDATED';   
                                responseBody.statusCode = 3;
                            }
                        }
                        String body = JSON.serializePretty(responseBody);
                        response.responseBody = Blob.valueOf(body);
                        if(responseBody.statusCode!=2){
                            if(!userList.isEmpty()&&collectionAccessList.isEmpty()) {
                                if(userList[0].Profile.Name != Label.Savvas_Sample_Resources_Profile){
                                    SavvasDigitalSamplesUserRegistration.registerNewUser(contactList[0].Id, requestBody);
                                    SavvasDigitalSamplesUserRegistration.updateUserAccess(contactList[0].Id, requestBody,TRUE); 
                                }
                                else{
                                    SavvasDigitalSamplesUserRegistration.updateUserAccess(contactList[0].Id, requestBody,TRUE); 
                                }
                            } else if(responseBody.statusCode == 1 ) {
                                SavvasDigitalSamplesUserRegistration.registerNewUser(contactList[0].Id, requestBody);
                                SavvasDigitalSamplesUserRegistration.updateUserAccess(contactList[0].Id, requestBody,FALSE);
                            }
                        }
                    }
                    if(Boolean.valueOf(Label.Savvas_Insert_Logs)){
                        system.debug('response.responseBody--->'+response.responseBody);
                        logDetails.responseBody =(response.responseBody).toString().length()>1000?((response.responseBody).toString()).subString(0,1000):(response.responseBody).toString();
                        logDetails.status = 'Success';
                        logDetails.contactId = contactList.isEmpty()?NULL:contactList[0].Id;
                        SavvasVirtualSampleLogsUtilty.createIntegrationLogs(logDetails);
                    }
                }
            }
        } 
        catch (Exception ex) {
            response.statusCode = 500;
            responseBody.statusMsg = 'AN ERROR OCCURED. PLEASE CONTACT YOUR ORG ADMIN. Error---> '+ex.getMessage();
            responseBody.contactValidation = false;
            String body = JSON.serializePretty(responseBody);
            response.responseBody = Blob.valueOf(body);
            logDetails.responseBody =JSON.serialize(responseBody);
            logDetails.status = 'Error';
            logDetails.contactId = contactId;
            SavvasVirtualSampleLogsUtilty.createIntegrationLogs(logDetails);
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
        public boolean contactValidation;
        public string statusMsg;
        public Integer statusCode;
    }*/
}