/*
@Author : Cognizant Team
@Name : SavvasDigitalSamplesUserRegistration
@CreateDate : 11-Jan-2023
@Description: This class gets called to create User, CollectionAccess and SitecoreAsset
@ModifiedBy: Cognizant Team
@ModifiedDate: 02-Nov-2023
@Ticket Number: VS-0011
@This class has been deprecated as part of SSO project to accomodate the new account contact validation logic as per new requirements. 
User story number for reference: W-015376
New Class for reference : SavvasVirtualSampleUserProvisioning, SavvasVirtualSampleUserProvHelper
*/
public without sharing class SavvasDigitalSamplesUserRegistration {
    /*
@Author : Cognizant Team
@name : registerNewUser
@Description : Method to create contacts
*/   
/*    @future
    public static void registerNewUser(Id contactId, string requestBody) {
        try{
            if(String.isNotBlank(contactId)&&String.isNotBlank(requestBody)){
                List<PermissionSetAssignment> listPSAssignment = new  List<PermissionSetAssignment>();
                Map<Id,PermissionSetAssignment> mapOfPermissionSetAssignment = new Map<Id,PermissionSetAssignment>();
                SavvasDigitalSamplesService.APIRequestBody requestDetails = (SavvasDigitalSamplesService.APIRequestBody)JSON.deserialize(requestBody, SavvasDigitalSamplesService.APIRequestBody.class);                
                String profileName = Label.Savvas_Sample_Resources_Profile;
                Profile profileId = [SELECT Id FROM Profile WHERE Name=: profileName];
                PermissionSet permSet = [SELECT id FROM PermissionSet WHERE Name=: profileName.replaceAll(' ', '_')];
                list<User> listofUsers = SavvasVirtualSampleUserSelector.getUserByContact(contactId);
                //Contact exists, User doesn't exists. Create User and send welcome Email
                if(listofUsers.isEmpty()){
                    list<User> listOfNewUsers = new list<User>();
                    list<PermissionSetAssignment> listOfPSAs = new  list<PermissionSetAssignment>();
                    List<Contact> contactRecord= SavvasVirtualSampleContactSelector.getContactById(contactId);
                    if(!contactRecord.isEmpty()){
                        User newUser = new User(contactId=contactId, username=requestDetails.email, firstname=contactRecord[0].firstName,
                                                lastname=contactRecord[0].lastName, email=(requestDetails.email).trim(),
                                                alias = string.valueof(contactRecord[0].firstName.substring(0,1) + contactRecord[0].lastName.substring(0,1)), 
                                                profileid = profileId.Id, emailencodingkey='UTF-8',
                                                languagelocalekey='en_US', localesidkey='en_US', 
                                                timezonesidkey='America/Los_Angeles');
                        listOfNewUsers.add(newUser);
                        List<Id> userIds = new List<Id>();
                        if(!listOfNewUsers.isEmpty()){
                            List<Database.saveresult> srList = Database.insert(listOfNewUsers);
                            for (Database.SaveResult sr : srList) {
                                if (sr.isSuccess()) {
                                    userIds.add(sr.getId());
                                }
                                if(!userIDs.isEmpty() && !Test.isRunningTest()){
                                    System.resetPasswordWithEmailTemplate(userIds[0], true, Label.Savvas_Sample_Resources_Welcome_Mail);
                                }
                            }
                        }
                    }
                }
                //Contact and User exists.
                else if(!listofUsers.isEmpty()){
                    List<Id> userIds = new List<Id>();
                    for(PermissionSetAssignment eachRecord:SavvasVirtualSamplePSASelector.getPSAByUserId(permSet.Id,listOfUsers))
                    {
                        mapOfPermissionSetAssignment.put(eachRecord.AssigneeId,eachRecord);
                    }
                    EmailTemplate notificaitonTemplate = [SELECT Id from EmailTemplate 
                                                          WHERE Name =: Label.Savvas_Sample_Resources_Access_Notification_Template];
                    List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
                    for(User eachUser:listofUsers){
                        userIds.add(eachUser.Id);
                        if(!mapOfPermissionSetAssignment.containsKey(eachUser.Id) && mapOfPermissionSetAssignment.isEmpty() && eachUser.profileId != profileId.Id){  
                            PermissionSetAssignment pubSetAss = new PermissionSetAssignment(PermissionSetId = permSet.Id, AssigneeId = eachUser.Id);
                            listPSAssignment.add(pubSetAss);
                        }
                        else if(!mapOfPermissionSetAssignment.isEmpty()){
                            if(mapOfPermissionSetAssignment.get(eachUser.Id).Assignee.ProfileId != profileId.Id && mapOfPermissionSetAssignment.get(eachUser.Id).PermissionSet.Id != permSet.Id){
                                PermissionSetAssignment pubSetAss = new PermissionSetAssignment(PermissionSetId = permSet.Id, AssigneeId = eachUser.Id);
                                listPSAssignment.add(pubSetAss);
                            }
                        }
                    }
                    if(!listPSAssignment.isEmpty()){
                        if(Schema.sObjectType.PermissionSetAssignment.isCreateable()){
                            insert listPSAssignment;
                        }
                        Messaging.sendEmail(mails);
                    }
                }
            }
        }
        catch(Exception e){
            SavvasVirtualSampleLogsUtilty.createApplicationLogs(e,UserInfo.getUserId());
        }
    }*/
    /*
@Author : Cognizant Team
@name : updateUserAccess
@Description : Method to create collectionAccess and SitecoreAssets
*/   
  /*  @future
    public static void updateUserAccess(Id contactId, string requestBody,Boolean isUpdate) {
        try{
            SavvasDigitalSamplesService.APIRequestBody requestDetails = (SavvasDigitalSamplesService.APIRequestBody)JSON.deserialize(requestBody, SavvasDigitalSamplesService.APIRequestBody.class);                
            List<SavvasDigitalSamplesService.collectionDetails> collectionData = requestDetails.collectionDetails;
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
            if(requestDetails.programType=='1.0'){
                //NCA-19***Create map for each data against unique sitecore id** 
                for(SavvasDigitalSamplesService.collectionDetails eachRecord: collectionData){
                    assetItemIdVsEntityMap.put(eachRecord.asset_itemId,eachRecord.entityId);
                    assetItemIdVsThumbnailIdMap.put(eachRecord.asset_itemId,eachRecord.thumbnailId);
                    assetItemIdVsAssetNameMap.put(eachRecord.asset_itemId,eachRecord.assetName);
                    assetItemIdVsAssetUrlMap.put(eachRecord.asset_itemId,eachRecord.assetUrl);
                    assetItemIdVsUsageDescriptionMap.put(eachRecord.asset_itemId,eachRecord.usage_desc);
                }
                if(isUpdate){
                    if(!userRecord.isEmpty()){
                        userId = userRecord[0].Id;
                    }
                    list<Collection_Access__c> collectionAccessList = SavvasVirtualSamplesCAccessSelector.getCAListByName(contactId,requestDetails.collectionId);
                    if(!collectionAccessList.isEmpty()){
                        collectionId = collectionAccessList[0].Id;
                        //NCA-19** Remove existing values against sitecore id if data matched with sitecore id in SF**
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
                        collectionAccessToInsert.add(newCollectionAccess);
                        
                        if(Schema.sObjectType.Collection_Access__c.isCreateable() && !collectionAccessToInsert.isEmpty()){
                            Insert collectionAccessToInsert;
                        }
                        
                        collectionId=collectionAccessToInsert[0].Id;
                        
                        if(!userRecord.isEmpty()){
                            userId = userRecord[0].Id;
                            sendEmail=true;
                        }
                        
                    }  
                    else{
                        collectionId=collectionAccessList[0].Id;
                    }
                    
                }
                //NCA-19**Create Sitecore asset records**
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
                EmailTemplate notificaitonTemplate = [SELECT Id FROM EmailTemplate
                                                      WHERE Name =: Label.Savvas_Sample_Resources_Access_Notification_Template];
                List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
                Messaging.SingleEmailMessage mail = Messaging.renderStoredEmailTemplate(notificaitonTemplate.Id, userId,userId);
                String body = mail.getHtmlBody();
                body = body.replace('programName', requestDetails.productOfInterest);
                body = body.replace('communityName',Label.Savvas_Community_Name);
                String subject = mail.getSubject();
                subject = subject.replaceAll('programName',requestDetails.productOfInterest);
                subject = subject.replaceAll('communityName',Label.Savvas_Community_Name);
                mail.setSubject(subject);
                mail.setTargetObjectId(userId);
                mail.setSaveAsActivity(false);
                mail.setHtmlBody(body);
                mails.add(mail);
                Messaging.sendEmail(mails);
            }
        }
        catch(Exception e){
            SavvasVirtualSampleLogsUtilty.createApplicationLogs(e,UserInfo.getUserId());
        }
    }*/
}