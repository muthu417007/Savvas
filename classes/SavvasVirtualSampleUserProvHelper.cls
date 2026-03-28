/*
    @Author : Cognizant Team
    @Name : SavvasVirtualSampleUserProvHelper
    @CreateDate : 12-Aug-2024
    @Description: Helper class for SavvasVirtualSampleUserProvisioning class
    @ModifiedBy: Cognizant Team
    @ModifiedDate: 16-Aug-2024
    @Ticket Number: W-013769,W-014602,W-015376
*/
public without sharing class SavvasVirtualSampleUserProvHelper {
    
    /*
    @Author : Cognizant Team
    @name : registerNewUser
    @Description : Create new user send email and assign permission set
    @param : contact record, string of request body 
    @return : LogDetailsWrapper record

    */   
    public static LogDetailsWrapper registerNewUser(Contact contactRecord, string requestBody) {
        SavvasVirtualSampleUserProvisioning.APIRequestBody requestDetails = (SavvasVirtualSampleUserProvisioning.APIRequestBody)JSON.deserialize(requestBody, SavvasVirtualSampleUserProvisioning.APIRequestBody.class); 
        LogDetailsWrapper ldw = new LogDetailsWrapper();
        try{
            List<Collection_Access__c> collectionAccess = SavvasVirtualSamplesCAccessSelector.getCAListByContact(contactRecord.Id,requestDetails.collectionId);
            List<Collection_Access__c> collectionAccessList = SavvasVirtualSamplesCAccessSelector.getCAListByName(contactRecord.Id,requestDetails.collectionId);
            
            if((requestDetails.programType == '1.0') && (!collectionAccess.isEmpty() || !collectionAccessList.isEmpty())){
                set<String> siteCoreIds = new set<String>();
                List<Sitecore_Asset__c> assetsList = new List<Sitecore_Asset__c>();
                Integer existingAssetsCount;
                for(SavvasVirtualSampleUserProvisioning.CollectionDetails eachRecord: requestDetails.CollectionDetails){
                    siteCoreIds.add(eachRecord.asset_itemId);
                }
                if(!collectionAccessList.isEmpty()){
                    assetsList = SavvasVirtualSamplesSAssetSelector.getsitecoreAssetsByContactId(collectionAccessList[0].Id,contactRecord.Id);
                    if(!assetsList.isEmpty()){
                        for(Sitecore_Asset__c eachAsset: assetsList){
                            if(siteCoreIds.contains(eachAsset.Sitecore_Id__c)){
                                siteCoreIds.remove(eachAsset.Sitecore_Id__c);
                            }
                        }
                    }
                }
                existingAssetsCount = siteCoreIds.size();
                //if collection acess is already exists for 1.0 update existing assets
                if((existingAssetsCount > 0 && !assetsList.isEmpty()) || (!collectionAccess.isEmpty() || !collectionAccessList.isEmpty())){
                    ldw.message = 'CONTACT_SYSTEM_ADMINISTRATOR';
                    ldw.status = false;  
                    //update existing sitecore assets
                    createCollectionAccess(contactRecord.Id,requestBody,TRUE,FALSE);
                }
            }
            //if collection acess is already exists for 2.0
            else if (requestDetails.programType == '2.0' && (!collectionAccess.isEmpty() || !collectionAccessList.isEmpty())){
                ldw.message = 'CONTACT_SYSTEM_ADMINISTRATOR';
                ldw.status = false;  
            }
            //if no collection access record cretae user
            if(collectionAccess.isEmpty() && collectionAccessList.isEmpty()){                             
                Profile profileId = [SELECT Id FROM Profile WHERE Name=: Label.Savvas_Single_Sign_On_Profile];
                
                User newUser = new User(contactId=contactRecord.Id, username=requestDetails.email, firstname=contactRecord.firstName,
                                        lastname=contactRecord.lastName, email=(requestDetails.email).trim(),
                                        alias = string.valueof(contactRecord.firstName.substring(0,1) + contactRecord.lastName.substring(0,1)), 
                                        profileid = profileId.Id, emailencodingkey='UTF-8',
                                        languagelocalekey='en_US', localesidkey='en_US', 
                                        timezonesidkey='America/Los_Angeles');
                    
                Database.SaveResult sr = Database.insert(newUser);  
                if(sr.isSuccess()){
                    String userId = sr.getId();
                    //W-014602 -Add PS to new user and send welcome email
                   Boolean pSAStatus = permSetAssignment(newUser);
                    if(pSAStatus){
                        System.resetPasswordWithEmailTemplate(userId, true, Label.Savvas_Sample_Resources_Welcome_Mail);
                        ldw.message = 'NEW_USER_REGISTERED';
                        ldw.status = true;  
                        //update collection access
                        createCollectionAccess(contactRecord.Id,requestBody,FALSE,TRUE);      // added new flag isNewUser
                    }
                    else{
                        ldw.message = 'PS_ASSIGNMENT_FAILED';
                        ldw.status = false;                        
                    }
                }
                else{
                    ldw.message = 'USER_REGISTRATION_FAILED';
                    ldw.status = false;
                }
            }
            return ldw; 
        }
        catch(Exception e){
            ldw.message = e.getLineNumber() + ': ' + e.getMessage();
            ldw.status = false;
            return ldw;
        }
    }

    /*
    @Author : Cognizant Team
    @name : updateUserAccess
    @Description : update Permission Set Assignment and send email
    @param : user record, string of request body 
    @return : LogDetailsWrapper record
    */  
    public static LogDetailsWrapper updateUserAccess(User user, string requestBody){
        LogDetailsWrapper ldw = new LogDetailsWrapper();
        SavvasVirtualSampleUserProvisioning.APIRequestBody requestDetails = (SavvasVirtualSampleUserProvisioning.APIRequestBody)JSON.deserialize(requestBody, SavvasVirtualSampleUserProvisioning.APIRequestBody.class);
        try{
            List<Collection_Access__c> collectionAccess = SavvasVirtualSamplesCAccessSelector.getCAListByContact(user.ContactId,requestDetails.collectionId);
            List<Collection_Access__c> collectionAccessList = SavvasVirtualSamplesCAccessSelector.getCAListByName(user.ContactId,requestDetails.collectionId);
            ldw.contactValidation = true;
            ldw.message = 'CONTACT_FOUND';

            //PS Assignment
            Boolean pSAStatus = permSetAssignment(user);
            if(pSAStatus){
                if(requestDetails.programType =='1.0'){
                    set<String> siteCoreIds = new set<String>();
                    List<Sitecore_Asset__c> assetsList = new List<Sitecore_Asset__c>();
                    Integer existingAssetsCount;
                    for(SavvasVirtualSampleUserProvisioning.CollectionDetails eachRecord: requestDetails.CollectionDetails){
                        siteCoreIds.add(eachRecord.asset_itemId);
                    }
                    if(!collectionAccessList.isEmpty()){
                        assetsList = SavvasVirtualSamplesSAssetSelector.getsitecoreAssetsByContactId(collectionAccessList[0].Id,user.ContactId);
                        if(!assetsList.isEmpty()){
                            for(Sitecore_Asset__c eachAsset: assetsList){
                                if(siteCoreIds.contains(eachAsset.Sitecore_Id__c)){
                                    siteCoreIds.remove(eachAsset.Sitecore_Id__c);
                                }
                            }
                        }
                    }
                    existingAssetsCount = siteCoreIds.size();
                    //if active user exists with existing 1.0 sitecorecore assets
                    if((existingAssetsCount > 0 && !assetsList.isEmpty())){
                        ldw.message = 'EXISTING_USER_ACCESS_UPDATED';
                        ldw.status = true;  
                        createCollectionAccess(user.ContactId,requestBody,TRUE,FALSE);   // added new flag isNewUser
                    }
                    //if active user exists and new collection access
                    else if(collectionAccessList.isEmpty()){
                        ldw.message = 'EXISTING_USER_ACCESS_UPDATED';
                        ldw.status = true; 
                        createCollectionAccess(user.ContactId,requestBody,FALSE,FALSE); // added new flag isNewUser
                    }
                    //if active user exists and duplicate access
                    else{
                        ldw.message = 'DUPLICATE_ACCESS_UPDATE_REQUEST';
                        ldw.status = true;
                    }
                }
                else if (requestDetails.programType == '2.0'){
                    //if active user exists and duplicate access
                    if(!collectionAccessList.isEmpty()){
                        ldw.message = 'DUPLICATE_ACCESS_UPDATE_REQUEST';
                        ldw.status = true;
                    }
                    //if active user exists and new collection access
                    else if(collectionAccessList.isEmpty()){               
                        ldw.message = 'EXISTING_USER_ACCESS_UPDATED';
                        ldw.status = true;
                        createCollectionAccess(user.ContactId,requestBody,TRUE,FALSE); // added new flag isNewUser
                    }
                }
            }
            else{
                ldw.message = 'PS_ASSIGNMENT_FAILED';
                ldw.status = false;  
            }
            return ldw;
        }
        catch(Exception e){
            ldw.message = e.getLineNumber() + ': ' + e.getMessage();
                ldw.status = false;
                return ldw;
        }
    }

    /*
    @Author : Cognizant Team
    @name : createCollectionAccess
    @Description : Method to update collection access and sitecore records
    @param : contact id, string of request body , isUpadte, isNewUser
    @return : NA
    */  
    @future
    public static void createCollectionAccess(Id contactId, string requestBody,Boolean isUpdate, Boolean isNewUser){
        try{
            SavvasVirtualSampleUserProvisioning.APIRequestBody requestDetails = (SavvasVirtualSampleUserProvisioning.APIRequestBody)JSON.deserialize(requestBody, SavvasVirtualSampleUserProvisioning.APIRequestBody.class);                
            List<SavvasVirtualSampleUserProvisioning.collectionDetails> collectionData = requestDetails.collectionDetails;
            List<Sitecore_Asset__c> sitecoreAssetToInsert = new List<Sitecore_Asset__c>();
            List<Collection_Access__c> collectionAccessToInsert = new List<Collection_Access__c>();
            Map<String,String> assetItemIdVsEntityMap = new Map<String,String>();
            Map<String,String> assetItemIdVsThumbnailIdMap = new Map<String,String>();
            Map<String,String> assetItemIdVsAssetNameMap = new Map<String,String>();
            Map<String,String> assetItemIdVsAssetUrlMap = new Map<String,String>();
            Map<String,String> assetItemIdVsUsageDescriptionMap = new Map<String,String>();
            List<Virtual_Samples_Program__c> virtualSample = new List<Virtual_Samples_Program__c>();
            String profileName = Label.Savvas_Sample_Resources_Profile;
            String collectionId='';
            String userId='';
            Boolean sendEmail=false;
            List<User> userRecord = SavvasVirtualSampleUserSelector.getUserByContact(contactId);
            User user;
            if(requestDetails.programType=='1.0'){
                //NCA-19***Create map for each data against unique sitecore id**// 
                for(SavvasVirtualSampleUserProvisioning.collectionDetails eachRecord: collectionData){
                    assetItemIdVsEntityMap.put(eachRecord.asset_itemId,eachRecord.entityId);
                    assetItemIdVsThumbnailIdMap.put(eachRecord.asset_itemId,eachRecord.thumbnailId);
                    assetItemIdVsAssetNameMap.put(eachRecord.asset_itemId,eachRecord.assetName);
                    assetItemIdVsAssetUrlMap.put(eachRecord.asset_itemId,eachRecord.assetUrl);
                    assetItemIdVsUsageDescriptionMap.put(eachRecord.asset_itemId,eachRecord.usage_desc);
                }
                if(isUpdate){
                    if(!userRecord.isEmpty()){
                        userId = userRecord[0].Id;
                        user = userRecord[0];
                    }
                    list<Collection_Access__c> collectionAccessList = SavvasVirtualSamplesCAccessSelector.getCAListByName(contactId,requestDetails.collectionId);
                    if(!collectionAccessList.isEmpty()){
                        collectionId = collectionAccessList[0].Id;
                        //NCA-19** Remove existing values against sitecore id if data matched with sitecore id in SF**//
                        for(Sitecore_Asset__c eachAsset: SavvasVirtualSamplesSAssetSelector.getSitecoreAssetByCA(collectionAccessList[0].Id)){
                            
                            if(assetItemIdVsAssetNameMap.containsKey(eachAsset.Sitecore_Id__c)){
                                assetItemIdVsEntityMap.remove(eachAsset.Sitecore_Id__c);
                                assetItemIdVsThumbnailIdMap.remove(eachAsset.Sitecore_Id__c);
                                assetItemIdVsAssetNameMap.remove(eachAsset.Sitecore_Id__c);
                                assetItemIdVsAssetUrlMap.remove(eachAsset.Sitecore_Id__c);
                                assetItemIdVsUsageDescriptionMap.remove(eachAsset.Sitecore_Id__c);
                            }
                            
                        }
                    }
                }
                else{
                    list<Collection_Access__c> collectionAccessList;
                    collectionAccessList = SavvasVirtualSamplesCAccessSelector.getCAListByName(contactId,requestDetails.collectionId);
                    
                    if(collectionAccessList.isEmpty()){
                        Collection_Access__c newCollectionAccess =  new Collection_Access__c();
                        newCollectionAccess.Name = requestDetails.productOfInterest;
                        newCollectionAccess.Access_Granted_On__c = Date.today();
                        newCollectionAccess.Access_Valid_Till__c = Date.today().addDays(Integer.valueOf(Label.Savvas_Learning_Access_Limit));
                        newCollectionAccess.Contact__c = contactId;
                        newCollectionAccess.Collection_Item_Id__c = requestDetails.collection_itemId;
                        newCollectionAccess.Collection_Id__c = requestDetails.collectionId;
                        newCollectionAccess.Program_Type__c = requestDetails.programType;
                        newCollectionAccess.Campaign_Id__c = String.isNotBlank(requestDetails.campaignId)?requestDetails.campaignId:null;//W-013769
                        newCollectionAccess.User_Role__c = requestDetails.userRole;//W-013769
                        collectionAccessToInsert.add(newCollectionAccess);
                        
                        if(Schema.sObjectType.Collection_Access__c.isCreateable() && !collectionAccessToInsert.isEmpty()){
                            Insert collectionAccessToInsert;
                        }
                        
                        collectionId=collectionAccessToInsert[0].Id;
                        
                        if(!userRecord.isEmpty() && !isNewUser){ // added new flag isNewUser
                            userId = userRecord[0].Id;
                            sendEmail=true;
                        }
                        
                    }  
                    else{
                        collectionId=collectionAccessList[0].Id;
                    }
                    
                }
                //NCA-19**Create Sitecore asset records**//
                for(String asset_itemId : assetItemIdVsAssetNameMap.keySet()){
                    Sitecore_Asset__c newSARecord = new Sitecore_Asset__c();
                    newSARecord.Collection_Access__c = collectionId;
                    newSARecord.Entity_Id__c = assetItemIdVsEntityMap.get(asset_itemId);
                    newSARecord.Name = assetItemIdVsAssetNameMap.get(asset_itemId);
                    newSARecord.Thumbnail_Id__c = assetItemIdVsThumbnailIdMap.get(asset_itemId);
                    newSARecord.Asset_Url__c = assetItemIdVsAssetUrlMap.get(asset_itemId);
                    newSARecord.Contact__c = contactId;
                    newSARecord.Usage_Description__c = assetItemIdVsUsageDescriptionMap.get(asset_itemId);
                    newSARecord.Sitecore_Id__c = asset_itemId;
                    sitecoreAssetToInsert.add(newSARecord);
                }
                
                if(!sitecoreAssetToInsert.isEmpty() && Schema.sObjectType.Sitecore_Asset__c.isCreateable()){
                    insert sitecoreAssetToInsert;
                }
            }
            else if(requestDetails.programType=='2.0'){
                virtualSample = SavvasVirtualSampleVSPSelector.getVSPByCollection(requestDetails.collectionId);
                if(!userRecord.isEmpty()){
                    userId = userRecord[0].Id;
                    user = userRecord[0];
                }
                Collection_Access__c newCollectionAccess =  new Collection_Access__c();
                newCollectionAccess.Access_Granted_On__c = Date.today();
                if(virtualSample.isEmpty()){
                    newCollectionAccess.Name = requestDetails.productOfInterest;
                    newCollectionAccess.Access_Valid_Till__c = Date.today().addDays(Integer.valueOf(Label.Savvas_Learning_Access_Limit));
                }
                else{
                    newCollectionAccess.Name = virtualSample[0].Name;
                    newCollectionAccess.Access_Valid_Till__c = Date.today().addDays(Integer.valueOf(virtualSample[0].Program_Sample_Expiry__c));    
                }
                newCollectionAccess.Contact__c = contactId;
                newCollectionAccess.Collection_Item_Id__c = requestDetails.collection_itemId;
                newCollectionAccess.Collection_Id__c = requestDetails.collectionId;
                newCollectionAccess.Program_Type__c = requestDetails.programType;
                newCollectionAccess.Campaign_Id__c = String.isNotBlank(requestDetails.campaignId)?requestDetails.campaignId:null;//W-013769
                newCollectionAccess.User_Role__c = requestDetails.userRole;//W-013769
                collectionAccessToInsert.add(newCollectionAccess);
                if(Schema.sObjectType.Collection_Access__c.isCreateable() && !collectionAccessToInsert.isEmpty()){
                    Insert collectionAccessToInsert;
                }
            }
            if(sendEmail || isUpdate){
                EmailTemplate notificaitonTemplate = [
                                                      SELECT Id, DeveloperName, Subject, htmlValue 
                                                      FROM EmailTemplate
                                                      WHERE Name =: Label.Savvas_Sample_Resources_Access_Notification_Template];
                OrgWideEmailAddress[] owea = [
                                            SELECT Id from OrgWideEmailAddress 
                                             WHERE Address =: System.Label.Savvas_SSO_OrgWideEmailAddress 
                                             LIMIT 1
                                             ];
                if(!owea.isEmpty() && notificaitonTemplate!=null && user.ContactId!=null && user.Email!=null && user.FirstName!=null){
                    List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
                    Messaging.SingleEmailMessage mail = Messaging.renderStoredEmailTemplate(notificaitonTemplate.Id, userId,userId);
                    String body = mail.getHtmlBody();
                    body = body.replace('programName', requestDetails.productOfInterest);
                    body = body.replace('communityName',Label.Savvas_Community_Name);
                    String subject = mail.getSubject();
                    subject = subject.replaceAll('programName',requestDetails.productOfInterest);
                    subject = subject.replaceAll('communityName',Label.Savvas_Community_Name);
                    mail.setOrgWideEmailAddressId(owea.get(0).Id);
                    mail.setUseSignature(false); 
                    mail.setBccSender(false); 
                    mail.toAddresses = new String[]{user.Email};
                    mail.setSubject(subject);
                    mail.setTargetObjectId(userId);
                    mail.setSaveAsActivity(false);
                    mail.setHtmlBody(body);
                    mails.add(mail);
                    Messaging.sendEmail(mails);
                }
            }
        }
        catch(Exception e){
            SavvasVirtualSampleLogsUtilty.createApplicationLogs(e,UserInfo.getUserId());
        }
 
    }

    /*
    @Author : Cognizant Team
    @name : permSetAssignment
    @Description : assign permission set to user
    @param : user record
    @return : Boolean
    */  
    public static Boolean permSetAssignment(User user){
        List<PermissionSet> psIdList = [ SELECT Id 
                                        FROM PermissionSet 
                                        WHERE Name =: Label.Savvas_Sample_Resources_Permission_Set 
                                        LIMIT 1
                                    ];
        if(!psIdList.isEmpty()){
            List<PermissionSetAssignment> userPSAList = [ SELECT PermissionSetId 
                                                        FROM PermissionSetAssignment 
                                                        WHERE AssigneeId =:user.Id 
                                                        AND PermissionSet.Id =: psIdList[0].Id
                                                        ];
            //if PS is not assigned                                            
            if (userPSAList.isEmpty()){
                PermissionSetAssignment appPsa = new PermissionSetAssignment(PermissionSetId = psIdList[0].Id, AssigneeId = user.Id);
                Database.SaveResult sr = Database.insert(appPsa);
                if(sr.isSuccess()){
                    update user;
                    return true;     
                }
                else{
                    return false;
                }
            }
            //if PS is already assigned
            else{
                return true;
            }
        }
        return false;
    }


    // Wrapper class - LogDetailsWrapper
    public class LogDetailsWrapper{
        public String message;
        public Boolean status;
        public Boolean contactValidation;
    } 
}