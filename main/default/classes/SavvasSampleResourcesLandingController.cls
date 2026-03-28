/*
@Author : Cognizant Team
@Name : SavvasSampleResourcesLandingController
@CreateDate : 11-Jan-2023
@Description: This class gets called on the landing page of Savvas Learning Portal. 
@ModifiedBy: Cognizant Team
@ModifiedDate: 02-Nov-2023
@Ticket Number: VS-0014,VS-0033,VS-0034
*/
public without sharing class SavvasSampleResourcesLandingController {
    /*
@Author : Cognizant Team
@name : updateAssetDescription
@Description : Method to get ContentAccess records related to logged in user.
*/
    @AuraEnabled
    public Static void updateAssetDescription(String collectionName){
        SavvasVirtualSampleLogsUtilty.LogDetailsWrapper logDetails = new SavvasVirtualSampleLogsUtilty.LogDetailsWrapper();
        List<Sitecore_Asset__c> sitecoreAssetList = new List<Sitecore_Asset__c>();
        List<Collection_Access__c> collectionAccessList = new List<Collection_Access__c>();
        List<Sitecore_Asset__c> sitecoreAssetListToUpdate = new List<Sitecore_Asset__c>();
        List<collectionDetails> collectionDetailsList = new List<collectionDetails>();
        List<collectionDetails> collectionDetail = new List<collectionDetails>();
        Map<String,Collection_Access__c> collectionAccessMap = new Map<String,Collection_Access__c>();
        Map<String,Sitecore_Asset__c> sitecoreAssetMap = new Map<String,Sitecore_Asset__c>();
        List<Sitecore_Asset__c> sitecoreAssetToInsert = new List<Sitecore_Asset__c>();
        Set<String> assetDescriptionIds = new Set<String>();
        try{
            sitecoreAssetList= SavvasVirtualSamplesSAssetSelector.getSitecoreAssetByCAName(collectionName);
            String responseBody='';
            HttpResponse response;
            if(Test.isRunningTest()){
                if(String.isBlank(collectionName)){
                        throw new AuraHandledException('Exception');
                    }  
            }
            if(!sitecoreAssetList.isEmpty()){
                for(Sitecore_Asset__c eachRecord: sitecoreAssetList){
                    Collection_Access__c collectionRecord = new Collection_Access__c(
                        Id = eachRecord.Collection_Access__c,Collection_Item_Id__c = eachRecord.Collection_Access__r.Collection_Item_Id__c,
                        Program_Description__c = eachRecord.Collection_Access__r.Program_Description__c);
                    collectionAccessMap.put(eachRecord.Collection_Access__r.Collection_Item_Id__c,collectionRecord);
                    sitecoreAssetMap.put(eachRecord.Sitecore_Id__c,eachRecord);
                    assetDescriptionIds.add(eachRecord.Collection_Access__r.Collection_Item_Id__c);
                }
                
                logDetails.type = 'Program/Asset Update';
                logDetails.requestBody = JSON.serialize(assetDescriptionIds);        
                response= SavvasVirtualSamplesAPIUtility.generateRequest('Sitecore',JSON.serialize(assetDescriptionIds),'POST',NULL);     
                if(!Test.isRunningTest()){
                    logDetails.responseBody = (response.getBody()).length()>1000?(response.getBody()).subString(0,1000):response.getBody();
                    logDetails.contactId = sitecoreAssetList[0].contact__c;
                    if(response.getStatusCode()==200) {
                        responseBody = response.getBody();
                    }
                }
                else{
                    logDetails.responseBody ='test';
                    responseBody='[ {"collection_itemId": "f77c3866-1575-4254-a416-f14af4195340","program_desc": "Program Description","collectionDetails": [{"asset_itemId": "7628fe94-7a84-4aeb-b536-19c8c31156fc","assetName": "Digital Guide","assetURL": "https://slcl-p-001-delivery.sitecorecontenthub.cloud/api/public/content/33270?v=bf32f3f7","thumbnailId": "https://slcl-p-001-delivery.sitecorecontenthub.cloud/api/public/content/33395?v=d73a207e","product_desc": "This is a description placeholder, no more then 2 lines of text.","usage_desc": "3D Issue NCA Asset"},{"asset_itemId": "227f5750-f1b6-41db-8579-cf1430a0af32","assetName": "Parent/Student Walkthrough","assetURL": "https://slcl-p-001-delivery.sitecorecontenthub.cloud/api/public/content/33326?v=ba1ae667","thumbnailId": "https://slcl-p-001-delivery.sitecorecontenthub.cloud/api/public/content/33400?v=3788dcc8","product_desc": "This is a description placeholder, no more then 2 lines of text.","usage_desc": "3D Issue NCA Asset"},{"asset_itemId": "e0989e56-804c-4d6d-a8de-201abd960303","assetName": "Program Overview","assetURL": "https://slcl-p-001-delivery.sitecorecontenthub.cloud/api/public/content/32134?v=24b90fd4","thumbnailId": "https://slcl-p-001-delivery.sitecorecontenthub.cloud/api/public/content/33395?v=a83ee6de","product_desc": "This is a description placeholder, no more then 2 lines of text.","usage_desc": "3D Issue NCA Asset"},{"asset_itemId": "9f5aff32-f4ce-4bad-af70-c7e36abe0147","assetName": "Scope & Sequence","assetURL": "https://slcl-p-001-delivery.sitecorecontenthub.cloud/api/public/content/32134?v=24b90fd4","thumbnailId": "https://slcl-p-001-delivery.sitecorecontenthub.cloud/api/public/content/33400?v=0bdee997","product_desc": "This is a description placeholder, no more then 2 lines of text.","usage_desc": "3D Issue NCA Asset"},{"asset_itemId": "82f312bf-c640-48e1-be1f-593c92cb01bc","assetName": "3D Issue Program Overview","assetURL": "","thumbnailId": "https://slcl-p-001-delivery.sitecorecontenthub.cloud/api/public/content/33395?v=1da66b63","product_desc": "3D Issue NCA Asset","usage_desc": "3D Issue NCA Asset"},{"asset_itemId": "bceb4871-cac3-46a8-8026-9c3db22465a1","assetName": "Flipbook Language Awareness Handbook","assetURL": "","thumbnailId": "https://slcl-p-001-delivery.sitecorecontenthub.cloud/api/public/content/33400?v=e3bfea8e","product_desc": "Flipbook NCA Asset","usage_desc": "3D Issue NCA Asset"},{"asset_itemId": "7e50872b-7066-4582-8ad2-2992015ffe58","assetName": "Flip page - Algebra 1 - Student Edition","assetURL": "","thumbnailId": "https://slcl-p-001-delivery.sitecorecontenthub.cloud/api/public/content/33400?v=e3bfea8e","product_desc": "Flip Page NCA Asset","usage_desc": "3D Issue NCA Asset"},{"asset_itemId": "7c84965f-7db3-4d95-a8ab-ba35c21d29e7","assetName": "SCO Overview handbook","assetURL": "","thumbnailId": "https://slcl-p-001-delivery.sitecorecontenthub.cloud/api/public/content/33395?v=1da66b63","product_desc": "SCO NCA Asset","usage_desc": "3D Issue NCA Asset"}] } ]';
                    logDetails.responseBody = responseBody.subString(0,1000);
                }
                if(String.isNotBlank(responseBody)){
                    List<descriptionDetails> responseData = (List<descriptionDetails>)JSON.deserialize(responseBody, List<descriptionDetails>.class);
                    if(!responseData.isEmpty()){
                        for(descriptionDetails details : responseData){
                            if(String.isNotBlank(details.program_desc)&&String.isNotEmpty(details.program_desc)){
                                if(!collectionAccessMap.isEmpty()){
                                    if(collectionAccessMap.containsKey((details.collection_itemId))){
                                        Collection_Access__c collectionRecord = new Collection_Access__c(
                                            Id = collectionAccessMap.get(details.collection_itemId).Id,Program_Description__c = details.program_desc);
                                        collectionAccessList.add(collectionRecord);
                                    }
                                }
                            }
                            
                            if(!(details.collectionDetails).isEmpty()){
                                collectionDetail=new List<collectionDetails>();
                                collectionDetail.addAll(details.collectionDetails);
                            }
                            if(!collectionDetail.isEmpty()){
                                Integer count=0;
                                for(collectionDetails detail: collectionDetail){
                                    if(!sitecoreAssetMap.isEmpty()){
                                        collectionDetail[count].collectionId = collectionAccessMap.get(details.collection_itemId).Id;
                                    }
                                    count=count+1;
                                }
                                collectionDetailsList.addAll(collectionDetail);
                            }
                        }
                        if(!collectionDetailsList.isEmpty()){
                            for(collectionDetails details: collectionDetailsList){
                                if(!sitecoreAssetMap.isEmpty()){
                                    if(sitecoreAssetMap.containsKey((details.asset_itemId))){
                                        Sitecore_Asset__c sitecoreAssetRecord = new Sitecore_Asset__c(
                                            Id = sitecoreAssetMap.get(details.asset_itemId).Id,Name = details.assetName,
                                            Usage_Description__c = String.isNotBlank(details.usage_desc)?details.usage_desc:NULL);
                                        sitecoreAssetListToUpdate.add(sitecoreAssetRecord);
                                    }
                                    else if(!sitecoreAssetMap.containsKey(details.asset_itemId)){
                                        if(String.isNotBlank(details.collectionId)){
                                            Sitecore_Asset__c newSARecord = new Sitecore_Asset__c(Collection_Access__c = details.collectionId,
                                                                                                  Entity_Id__c = String.isNotBlank(details.entityId)?details.entityId:null,Name = details.assetName,
                                                                                                  Thumbnail_Id__c = details.thumbnailId,Asset_Url__c = details.assetURL,Contact__c = sitecoreAssetList[0].contact__c,
                                                                                                  Usage_Description__c = String.isNotBlank(details.usage_desc)?details.usage_desc:NULL,Sitecore_Id__c = details.asset_itemId);
                                            sitecoreAssetToInsert.add(newSARecord);
                                        }
                                    }
                                }
                            }
                        }
                        if(!collectionAccessList.isEmpty()){
                            List<Database.SaveResult> result = Database.update(collectionAccessList);
                        }
                        if(!sitecoreAssetListToUpdate.isEmpty()){
                            List<Database.SaveResult> sitecoreAssetResult = Database.update(sitecoreAssetListToUpdate);
                        }
                        if(!sitecoreAssetToInsert.isEmpty()){
                            List<Database.SaveResult> sitecoreAssetInsertResult = Database.insert(sitecoreAssetToInsert);
                        }
                    }
                }
                if(Boolean.valueOf(Label.Savvas_Insert_Logs)){
                    logDetails.status = 'Success';
                    logDetails.contactId = sitecoreAssetList[0].contact__c;
                    SavvasVirtualSampleLogsUtilty.createIntegrationLogs(logDetails);
                }
                
            }
        }
        catch(Exception e){
            logDetails.status = 'Error';
            SavvasVirtualSampleLogsUtilty.createIntegrationLogs(logDetails);
            throw new AuraHandledException('An error occured : '+e.getMessage());
        }
    }
    
    /*
@Author : Cognizant Team
@name : getSitecoreAsset
@Description : Method to get ContentAccess records related to logged in user.
*/   
    @AuraEnabled
    public Static Map<String,List<CollectionData>> getSitecoreAsset(String collectionName){
        Map<String,List<CollectionData>> contentDetails = new Map<String,List<CollectionData>>();
        List<Sitecore_Asset__c> sitecoreAssetList = new List<Sitecore_Asset__c>();
        try{
            sitecoreAssetList= SavvasVirtualSamplesSAssetSelector.getSitecoreAssetByCAName(collectionName);
            if(!sitecoreAssetList.isEmpty()){
                for(Sitecore_Asset__c eachRecord: sitecoreAssetList){
                    CollectionData details = new CollectionData();
                    if(contentDetails.isEmpty()){
                        contentDetails.put(eachRecord.Collection_Access__r.Name,new List<CollectionData>());
                        details.programDescription = String.isNotBlank(eachRecord.Collection_Access__r.Program_Description__c)?(eachRecord.Collection_Access__r.Program_Description__c):NULL;
                        details.showProgramDescription = String.isNotBlank(details.programDescription)?TRUE:FALSE;
                    }
                    details.entityId = eachRecord.Entity_Id__c;
                    details.thumbnailId = String.isNotBlank(eachRecord.Thumbnail_Id__c)?eachRecord.Thumbnail_Id__c:NULL;
                    details.assetName = eachRecord.Name;
                    details.entityDescription = String.isNotBlank(eachRecord.Usage_Description__c)?(eachRecord.Usage_Description__c):NULL;
                    details.showEntityDescription = String.isNotBlank(details.entityDescription)?TRUE:FALSE;
                    details.assetURL = eachRecord.Asset_Url__c;
                    details.asset_itemId = eachRecord.Sitecore_Id__c;
                    details.showProgramDescription = (contentDetails.get(eachRecord.Collection_Access__r.Name).isEmpty()&&details.showProgramDescription==true)?TRUE:FALSE;
                    contentDetails.get(eachRecord.Collection_Access__r.Name).add(details);
                }
            }
        }
        catch(Exception e){
            SavvasVirtualSampleLogsUtilty.createApplicationLogs(e,UserInfo.getUserId());
            throw new AuraHandledException('An error occured : '+e.getMessage());
        }
        return contentDetails;
    }
    /*
@Author : Cognizant Team
@name : authenticateDam
@Description : Method to get tokenId for accessing DAM.
*/  
    @AuraEnabled
    public static String authenticateDam(String entityId){
        final Blob CRYPTOKEY = Blob.valueOf(Label.EncryptionKey);
        String responseBody='';
        HttpResponse response;
        try{
            String body = (Crypto.decryptWithManagedIV('AES128',CRYPTOKEY,EncodingUtil.base64Decode(Label.DAM_Credentials))).toString();
            String responseToken;
            response= SavvasVirtualSamplesAPIUtility.generateRequest('DAM_Authentication',body,'POST',NULL);  
            if(!Test.isRunningTest()){
                if(response.getStatusCode()==200) {
                    responseToken = response.getBody();
                }
            }
            else{
                responseToken='{"token": "0d8578c83a0244cca52c6375e0971ffa"}';
            }
            if(responseToken!=null){
                Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(responseToken);
                String responseData=String.valueOf(result.get('token'));
                if(String.isNotBlank(responseData)){
                    responseBody = getAssetUsingEntityId(responseData,entityId);
                }
            }
        }
        catch(Exception e){
            SavvasVirtualSampleLogsUtilty.createApplicationLogs(e,UserInfo.getUserId());
            throw new AuraHandledException('An error occured : '+e.getMessage());
        }
        return responseBody;
    }
    /*
@Author : Cognizant Team
@name : getAssetUsingEntityId
@Description : Method to get Asset details based on Entitiy Id
*/  
    @AuraEnabled
    public static String getAssetUsingEntityId(String tokenId,String entityId){
        SavvasVirtualSampleLogsUtilty.LogDetailsWrapper logDetails = new SavvasVirtualSampleLogsUtilty.LogDetailsWrapper();
        List<User> userList = SavvasVirtualSampleUserSelector.getUserById();
        User userDetails = userList.isEmpty()?NULL:userList[0];
        String responseBody='';
        List<String> entityIds = new List<String>();
        entityIds.add(entityId);
        HTTPResponse res;
        String endPoint = Label.Dam_Endpoint+ entityIds[0];
        try{
            HttpResponse response= SavvasVirtualSamplesAPIUtility.generateRequest(endPoint,NULL,'GET',tokenId); 
            if(!Test.isRunningTest()){
                logDetails.responseBody = response.getBody().length()>1000?(response.getBody()).subString(0,1000):response.getBody();
                if(response.getStatusCode()==200) {
                    responseBody = response.getBody();
                }
            }
            else{
                logDetails.responseBody = 'TEST';
                responseBody='{ "id": 33020, "identifier": "oj0m1D6RMUG-pzg74YON5Q exception", "cultures": [ "en-US" ], "properties": { "ISBN": null, "FileName": "Sample 1.pdf", "Title": "Sample 1.pdf", "Description": {}, "ProgramName": null, "ChiliType": null, "Asset.ExplicitApprovalRequired": false, "Asset.HasComplexRightsProfiles": null, "Asset.DrmComplexity": null, "Asset.Copyright": null, "ReasonForStatus": null, "VisionDescription": null, "VisionOcrText": null, "SitecoreMLStatus": null, "ImageSimilarityTags": null, "FileSize": 0.03, "FileProperties": { "properties": { "filesize": 0.03, "filesizebytes": "34824", "filename": "Sample 1.pdf", "width": "612", "height": "792", "group": "Documents", "extension": "pdf", "content_type": "application/pdf", "colorspace": "sRGB", "pages": "1", "creator": "Ranjan, Rajeev (Cognizant)" } }, "ApprovedBy": "rajeev.ranjan@savvas.com", "ApprovalDate": "2022-12-02T16:19:22.2158469Z", "ReasonForRejection": null, "ArchivedBy": null, "ArchivalDate": null, "HasDuplicate": true, "IsDraft": null, "MainFile": { "locations": { "local": [ "local-16c516be16d3439bbece10d59fea1ecc" ] }, "properties": { "filesize": 0.03, "filesizebytes": "34824", "filename": "Sample 1.pdf", "width": "612", "height": "792", "group": "Documents", "extension": "pdf", "content_type": "application/pdf", "colorspace": "sRGB", "pages": "1", "creator": "Ranjan, Rajeev (Cognizant)" } }, "AlternateFile": { "locations": { "local": [ "local-16c516be16d3439bbece10d59fea1ecc" ] } }, "Renditions": { "metadata": { "status": "completed", "properties": { "content_type": "application/json", "filesizebytes": "1307" }, "locations": { "local": [ "local-f1c7df63df8f487db1d6a5b91e558ddf" ] }, "sticky": true }, "pdf": { "status": "completed", "locations": { "local": [ "local-7feb9b2568404a399e74ec252608eb75" ] }, "sticky": true }, "txt": { "status": "completed", "locations": { "local": [ "local-f63532b4bfb64afbbb00e0c2eb414968" ] }, "sticky": true }, "preview": { "status": "completed", "properties": { "width": "612", "height": "792", "content_type": "image/jpeg", "filesizebytes": "8445" }, "locations": { "local": [ "local-79b3e91366724310b3c263e7a1522f42" ] } }, "preview_download": { "status": "completed", "properties": { "width": "612", "height": "792", "content_type": "image/jpeg", "filesizebytes": "8445" }, "locations": { "local": [ "local-5c959c60b1c244e198be945c83e9a161" ] } }, "thumbnail": { "status": "completed", "properties": { "width": "116", "height": "150", "content_type": "image/jpeg", "filesizebytes": "1012" }, "locations": { "local": [ "local-83de1f8fe0fd4f77bec8cf64b36233e2" ] } }, "bigthumbnail": { "status": "completed", "properties": { "width": "700", "height": "350", "content_type": "image/jpeg", "filesizebytes": "8446" }, "locations": { "local": [ "local-1185773bd1f54a0db06fd424a9968d07" ] } }, "thumbnail_cropped": { "status": "completed", "properties": { "width": "200", "height": "200", "content_type": "image/jpeg", "filesizebytes": "1312" }, "locations": { "local": [ "local-17c88a073c024568a60ff0f57e93d7c6" ] } } }, "Structure": null, "Digest": "0xb6b6d626c81a656b315c410c853c970bba14a6c4", "ExtraRenditions": null, "AverageRating": null, "VirusScanResult": { "identifier": "Ok", "labels": { "en-US": "Ok" } }, "IsCheckedOut": null, "IsCheckingIn": null, "IsDiscarding": null, "TemplateProperties": null, "CheckedOutIn": null, "RenditionsPurged": null, "DeletedOn": null, "RenditionsAccessTier": null, "VideoAI.Language": null, "SubtitleLanguage": null, "PublishStatus": null, "PublishStatusDetails": null }, "relations": { "AssetTypeToAsset": { "inherits_security": true, "self": { "href": "https://slcl-p-001.sitecorecontenthub.cloud/api/entities/33020/relations/AssetTypeToAsset" } }, "LocalizationToAsset": { "inherits_security": true, "self": { "href": "https://slcl-p-001.sitecorecontenthub.cloud/api/entities/33020/relations/LocalizationToAsset" } }, "FinalLifeCycleStatusToAsset": { "parent": { "properties": { "StatusValue": "Approved" }, "href": "https://slcl-p-001.sitecorecontenthub.cloud/api/entities/544" }, "inherits_security": true, "self": { "href": "https://slcl-p-001.sitecorecontenthub.cloud/api/entities/33020/relations/FinalLifeCycleStatusToAsset" } }, "UserProfileToAvatar": { "href": "https://slcl-p-001.sitecorecontenthub.cloud/api/entities/33020/relations/UserProfileToAvatar" }, "UserProfileToMasterAvatar": { "href": "https://slcl-p-001.sitecorecontenthub.cloud/api/entities/33020/relations/UserProfileToMasterAvatar" }, "PortalFeatureToAsset": { "href": "https://slcl-p-001.sitecorecontenthub.cloud/api/entities/33020/relations/PortalFeatureToAsset" }, "ContentRepositoryToAsset": { "parents": [ { "properties": { "ClassificationName": "Standard" }, "href": "https://slcl-p-001.sitecorecontenthub.cloud/api/entities/734" } ], "inherits_security": true, "self": { "href": "https://slcl-p-001.sitecorecontenthub.cloud/api/entities/33020/relations/ContentRepositoryToAsset" } }, "AssetMediaToAsset": { "parent": { "properties": { "ClassificationName": "pdf", "TaxonomyLabel": { "en-US": "pdf" } }, "href": "https://slcl-p-001.sitecorecontenthub.cloud/api/entities/1057" }, "inherits_security": true, "self": { "href": "https://slcl-p-001.sitecorecontenthub.cloud/api/entities/33020/relations/AssetMediaToAsset" } }, "M.NewsItemToMasterAsset": { "href": "https://slcl-p-001.sitecorecontenthub.cloud/api/entities/33020/relations/M.NewsItemToMasterAsset" }, "EntityGenerationTemplateToAsset": { "href": "https://slcl-p-001.sitecorecontenthub.cloud/api/entities/33020/relations/EntityGenerationTemplateToAsset" }, "AssetToWhereUsed": { "href": "https://slcl-p-001.sitecorecontenthub.cloud/api/entities/33020/relations/AssetToWhereUsed" }, "SitecoreSiteToAsset": { "href": "https://slcl-p-001.sitecorecontenthub.cloud/api/entities/33020/relations/SitecoreSiteToAsset" }, "AssetToUsage": { "href": "https://slcl-p-001.sitecorecontenthub.cloud/api/entities/33020/relations/AssetToUsage" }, "AssetToPageComponent": { "href": "https://slcl-p-001.sitecorecontenthub.cloud/api/entities/33020/relations/AssetToPageComponent" }, "OriginalLifeCycleStatusToAsset": { "href": "https://slcl-p-001.sitecorecontenthub.cloud/api/entities/33020/relations/OriginalLifeCycleStatusToAsset" }, "DRM.UsageRightsRequest.UsageRightsRequestToAsset": { "href": "https://slcl-p-001.sitecorecontenthub.cloud/api/entities/33020/relations/DRM.UsageRightsRequest.UsageRightsRequestToAsset" }, "DRM.Contract.ContractToAsset": { "href": "https://slcl-p-001.sitecorecontenthub.cloud/api/entities/33020/relations/DRM.Contract.ContractToAsset" }, "DRM.Restricted.RestrictedToAsset": { "href": "https://slcl-p-001.sitecorecontenthub.cloud/api/entities/33020/relations/DRM.Restricted.RestrictedToAsset" }, "DRM.RightsProfile.RightsProfileToAsset": { "href": "https://slcl-p-001.sitecorecontenthub.cloud/api/entities/33020/relations/DRM.RightsProfile.RightsProfileToAsset" }, "AssetToParallelApprove": { "href": "https://slcl-p-001.sitecorecontenthub.cloud/api/entities/33020/relations/AssetToParallelApprove" }, "AssetToLike": { "href": "https://slcl-p-001.sitecorecontenthub.cloud/api/entities/33020/relations/AssetToLike" }, "TagToAsset": { "href": "https://slcl-p-001.sitecorecontenthub.cloud/api/entities/33020/relations/TagToAsset" }, "VisionColorToAsset": { "href": "https://slcl-p-001.sitecorecontenthub.cloud/api/entities/33020/relations/VisionColorToAsset" }, "MasterFile": { "children": [ { "href": "https://slcl-p-001.sitecorecontenthub.cloud/api/entities/33022" } ], "inherits_security": true, "self": { "href": "https://slcl-p-001.sitecorecontenthub.cloud/api/entities/33020/relations/MasterFile" } }, "FileHistory": { "href": "https://slcl-p-001.sitecorecontenthub.cloud/api/entities/33020/relations/FileHistory" }, "AssetToDraftAsset": { "href": "https://slcl-p-001.sitecorecontenthub.cloud/api/entities/33020/relations/AssetToDraftAsset" }, "AssetToSelfLocalizations": { "href": "https://slcl-p-001.sitecorecontenthub.cloud/api/entities/33020/relations/AssetToSelfLocalizations" }, "AssetToPublicLink": { "href": "https://slcl-p-001.sitecorecontenthub.cloud/api/entities/33020/relations/AssetToPublicLink" }, "CollectionToAsset": { "href": "https://slcl-p-001.sitecorecontenthub.cloud/api/entities/33020/relations/CollectionToAsset" }, "MediaMatrixToAsset": { "href": "https://slcl-p-001.sitecorecontenthub.cloud/api/entities/33020/relations/MediaMatrixToAsset" }, "PublicationToPackageAsset": { "href": "https://slcl-p-001.sitecorecontenthub.cloud/api/entities/33020/relations/PublicationToPackageAsset" }, "PublicationToImageAsset": { "href": "https://slcl-p-001.sitecorecontenthub.cloud/api/entities/33020/relations/PublicationToImageAsset" }, "PageComponentToAsset": { "href": "https://slcl-p-001.sitecorecontenthub.cloud/api/entities/33020/relations/PageComponentToAsset" }, "PageComponentToAllowedAssets": { "href": "https://slcl-p-001.sitecorecontenthub.cloud/api/entities/33020/relations/PageComponentToAllowedAssets" }, "TaskToAssetDeliverables": { "href": "https://slcl-p-001.sitecorecontenthub.cloud/api/entities/33020/relations/TaskToAssetDeliverables" }, "BlockToAssetBrief": { "href": "https://slcl-p-001.sitecorecontenthub.cloud/api/entities/33020/relations/BlockToAssetBrief" }, "BlockToAssetDeliverables": { "href": "https://slcl-p-001.sitecorecontenthub.cloud/api/entities/33020/relations/BlockToAssetDeliverables" }, "BlockToMasterAsset": { "href": "https://slcl-p-001.sitecorecontenthub.cloud/api/entities/33020/relations/BlockToMasterAsset" }, "DeliverablesLifecycleStatusToAsset": { "inherits_security": true, "self": { "href": "https://slcl-p-001.sitecorecontenthub.cloud/api/entities/33020/relations/DeliverablesLifecycleStatusToAsset" } }, "BlockCollectionToAsset": { "href": "https://slcl-p-001.sitecorecontenthub.cloud/api/entities/33020/relations/BlockCollectionToAsset" }, "BlockReviewToAsset": { "href": "https://slcl-p-001.sitecorecontenthub.cloud/api/entities/33020/relations/BlockReviewToAsset" }, "BlockReviewLifecycleStatusToAsset": { "parents": [], "inherits_security": true, "self": { "href": "https://slcl-p-001.sitecorecontenthub.cloud/api/entities/33020/relations/BlockReviewLifecycleStatusToAsset" } }, "ChiliPublicationToImageAsset": { "href": "https://slcl-p-001.sitecorecontenthub.cloud/api/entities/33020/relations/ChiliPublicationToImageAsset" }, "ChiliPublicationToDocumentAsset": { "href": "https://slcl-p-001.sitecorecontenthub.cloud/api/entities/33020/relations/ChiliPublicationToDocumentAsset" }, "AssetToDiscussion": { "href": "https://slcl-p-001.sitecorecontenthub.cloud/api/entities/33020/relations/AssetToDiscussion" }, "CheckedOutBy": { "href": "https://slcl-p-001.sitecorecontenthub.cloud/api/entities/33020/relations/CheckedOutBy" }, "RoleProxyToAsset": { "href": "https://slcl-p-001.sitecorecontenthub.cloud/api/entities/33020/relations/RoleProxyToAsset" }, "ChiliPublicationToAsset": { "href": "https://slcl-p-001.sitecorecontenthub.cloud/api/entities/33020/relations/ChiliPublicationToAsset" }, "AssetToLinkedAsset": { "href": "https://slcl-p-001.sitecorecontenthub.cloud/api/entities/33020/relations/AssetToLinkedAsset" }, "ContentCollectionToMasterAsset": { "href": "https://slcl-p-001.sitecorecontenthub.cloud/api/entities/33020/relations/ContentCollectionToMasterAsset" }, "UserToDeletedAsset": { "href": "https://slcl-p-001.sitecorecontenthub.cloud/api/entities/33020/relations/UserToDeletedAsset" }, "CmpCampaignToAsset": { "href": "https://slcl-p-001.sitecorecontenthub.cloud/api/entities/33020/relations/CmpCampaignToAsset" }, "CmpCampaignToMasterAsset": { "href": "https://slcl-p-001.sitecorecontenthub.cloud/api/entities/33020/relations/CmpCampaignToMasterAsset" }, "CmpContentToLinkedAsset": { "href": "https://slcl-p-001.sitecorecontenthub.cloud/api/entities/33020/relations/CmpContentToLinkedAsset" }, "CmpContentToBriefAsset": { "href": "https://slcl-p-001.sitecorecontenthub.cloud/api/entities/33020/relations/CmpContentToBriefAsset" }, "CmpContentToMasterLinkedAsset": { "href": "https://slcl-p-001.sitecorecontenthub.cloud/api/entities/33020/relations/CmpContentToMasterLinkedAsset" }, "ContentVersionToLinkedAsset": { "href": "https://slcl-p-001.sitecorecontenthub.cloud/api/entities/33020/relations/ContentVersionToLinkedAsset" }, "ContentVersionToMasterLinkedAsset": { "href": "https://slcl-p-001.sitecorecontenthub.cloud/api/entities/33020/relations/ContentVersionToMasterLinkedAsset" }, "TemplateAssetToThemes": { "href": "https://slcl-p-001.sitecorecontenthub.cloud/api/entities/33020/relations/TemplateAssetToThemes" }, "ThemeToLogo": { "href": "https://slcl-p-001.sitecorecontenthub.cloud/api/entities/33020/relations/ThemeToLogo" }, "ThemeToFavicon": { "href": "https://slcl-p-001.sitecorecontenthub.cloud/api/entities/33020/relations/ThemeToFavicon" }, "ThemeToWebPushNotificationIcon": { "href": "https://slcl-p-001.sitecorecontenthub.cloud/api/entities/33020/relations/ThemeToWebPushNotificationIcon" }, "PCMBrandToAsset": { "href": "https://slcl-p-001.sitecorecontenthub.cloud/api/entities/33020/relations/PCMBrandToAsset" }, "PCMBrandToMasterAsset": { "href": "https://slcl-p-001.sitecorecontenthub.cloud/api/entities/33020/relations/PCMBrandToMasterAsset" }, "PCMProductFamilyToAsset": { "href": "https://slcl-p-001.sitecorecontenthub.cloud/api/entities/33020/relations/PCMProductFamilyToAsset" }, "PCMProductFamilyToMasterAsset": { "href": "https://slcl-p-001.sitecorecontenthub.cloud/api/entities/33020/relations/PCMProductFamilyToMasterAsset" }, "PCMProductToAsset": { "href": "https://slcl-p-001.sitecorecontenthub.cloud/api/entities/33020/relations/PCMProductToAsset" }, "PCMProductToMasterAsset": { "href": "https://slcl-p-001.sitecorecontenthub.cloud/api/entities/33020/relations/PCMProductToMasterAsset" }, "PCMCatalogToAsset": { "href": "https://slcl-p-001.sitecorecontenthub.cloud/api/entities/33020/relations/PCMCatalogToAsset" }, "PCMCatalogToMasterAsset": { "href": "https://slcl-p-001.sitecorecontenthub.cloud/api/entities/33020/relations/PCMCatalogToMasterAsset" }, "VideoAIPeopleToAsset": { "href": "https://slcl-p-001.sitecorecontenthub.cloud/api/entities/33020/relations/VideoAIPeopleToAsset" }, "VideoAITopicToAsset": { "href": "https://slcl-p-001.sitecorecontenthub.cloud/api/entities/33020/relations/VideoAITopicToAsset" }, "VideoAILabelToAsset": { "href": "https://slcl-p-001.sitecorecontenthub.cloud/api/entities/33020/relations/VideoAILabelToAsset" }, "AssetToSubtitleAsset": { "href": "https://slcl-p-001.sitecorecontenthub.cloud/api/entities/33020/relations/AssetToSubtitleAsset" } }, "created_by": { "href": "https://slcl-p-001.sitecorecontenthub.cloud/api/entities/32931", "title": "The user who created the entity" }, "created_on": "2022-12-02T16:18:29.6335614Z", "modified_by": { "href": "https://slcl-p-001.sitecorecontenthub.cloud/api/entities/32931", "title": "The user who last modified the entity" }, "modified_on": "2022-12-06T17:36:52.3151604Z", "entitydefinition": { "href": "https://slcl-p-001.sitecorecontenthub.cloud/api/entitydefinitions/M.Asset", "title": "The entity definition for this entity" }, "copy": { "href": "https://slcl-p-001.sitecorecontenthub.cloud/api/entities/33020/copy", "title": "Copy this entity" }, "permissions": { "href": "https://slcl-p-001.sitecorecontenthub.cloud/api/entities/33020/permissions", "title": "The permissions on this entity" }, "lifecycle": { "href": "https://slcl-p-001.sitecorecontenthub.cloud/api/entities/33020/lifecycle", "title": "The lifecycle action for this entity." }, "saved_selections": { "href": "https://slcl-p-001.sitecorecontenthub.cloud/api/entities/33020/savedselections", "title": "The saved selections this entity belongs to" }, "roles": { "href": "https://slcl-p-001.sitecorecontenthub.cloud/api/entities/33020/roles", "title": "Roles for this entity" }, "annotations": { "href": "https://slcl-p-001.sitecorecontenthub.cloud/api/entities/33020/annotations", "title": "Annotations for this entity" }, "is_root_taxonomy_item": false, "is_path_root": false, "inherits_security": true, "is_system_owned": false, "version": 13, "self": { "href": "https://slcl-p-001.sitecorecontenthub.cloud/api/entities/33020" }, "renditions": { "downloadPreview": [ { "href": "https://slcl-p-001-delivery.sitecorecontenthub.cloud/api/delivery/local-5c959c60b1c244e198be945c83e9a161?intent=Download&expires=2023-01-25T14%3A39%3A46.7216843%2B00%3A00&entityid=33020&userid=33124&rendition=downloadPreview&signature=rO1BMESh9qw" } ], "downloadAlternative": [ { "href": "https://slcl-p-001-delivery.sitecorecontenthub.cloud/api/delivery/local-16c516be16d3439bbece10d59fea1ecc?intent=Download&expires=2023-01-25T14%3A39%3A46.7279938%2B00%3A00&entityid=33020&userid=33124&rendition=downloadAlternative&signature=oOc8fz0KqJ4" } ], "preview": [ { "href": "https://slcl-p-001-delivery.sitecorecontenthub.cloud/api/delivery/local-79b3e91366724310b3c263e7a1522f42?expires=2023-01-25T14%3A39%3A46.7282342%2B00%3A00&entityid=33020&userid=33124&rendition=preview&signature=P9HUhp96bBo" } ], "metadata": [ { "href": "https://slcl-p-001-delivery.sitecorecontenthub.cloud/api/delivery/local-f1c7df63df8f487db1d6a5b91e558ddf?expires=2023-01-25T14%3A39%3A46.7282992%2B00%3A00&entityid=33020&userid=33124&rendition=metadata&signature=4MAUs8AqoXM" } ], "thumbnail": [ { "href": "https://slcl-p-001-delivery.sitecorecontenthub.cloud/api/delivery/local-17c88a073c024568a60ff0f57e93d7c6?expires=2023-01-25T14%3A39%3A46.7283790%2B00%3A00&entityid=33020&userid=33124&rendition=thumbnail&signature=oIn06ztwZhU" } ], "bigthumbnail": [ { "href": "https://slcl-p-001-delivery.sitecorecontenthub.cloud/api/delivery/local-1185773bd1f54a0db06fd424a9968d07?expires=2023-01-25T14%3A39%3A46.7284367%2B00%3A00&entityid=33020&userid=33124&rendition=bigthumbnail&signature=r_te3sqOq6w" } ], "downloadExtractedContent": [ { "href": "https://slcl-p-001-delivery.sitecorecontenthub.cloud/api/delivery/local-f63532b4bfb64afbbb00e0c2eb414968?intent=Download&expires=2023-01-25T14%3A39%3A46.7284892%2B00%3A00&entityid=33020&userid=33124&rendition=downloadExtractedContent&signature=ddQH0JzyTvY" } ], "pdf": [ { "href": "https://slcl-p-001-delivery.sitecorecontenthub.cloud/api/delivery/local-7feb9b2568404a399e74ec252608eb75?intent=Stream&expires=2023-01-25T14%3A39%3A46.7285413%2B00%3A00&entityid=33020&userid=33124&rendition=pdf&signature=ZixYdtcJQLw" } ], "downloadOriginal": [ { "href": "https://slcl-p-001-delivery.sitecorecontenthub.cloud/api/delivery/local-16c516be16d3439bbece10d59fea1ecc?intent=Download&expires=2023-01-25T14%3A39%3A46.7285953%2B00%3A00&entityid=33020&userid=33124&rendition=downloadOriginal&signature=dSCWmOKodsQ" } ] } }';
                    if(entityId==null){
                        throw new AuraHandledException('Exception');
                    }  
            }
            logDetails.type = 'Entity Access';
            logDetails.requestBody = endPoint;        
            logDetails.contactId = String.isNotBlank(userDetails.ContactId)?userDetails.ContactId:NULL;
            if(Boolean.valueOf(Label.Savvas_Insert_Logs)){
                logDetails.status = 'Success';
                SavvasVirtualSampleLogsUtilty.createIntegrationLogs(logDetails);
            }
        }
        catch(Exception e){
            logDetails.status = 'Error';
            SavvasVirtualSampleLogsUtilty.createIntegrationLogs(logDetails);
            throw new AuraHandledException('An error occured : '+e.getMessage());
        }
        return responseBody;
    }
    
    /*
@Author : Cognizant Team
@name : generateAccessToken
@Description : Method to generate Access token
*/  
    
    @AuraEnabled
    public static String generateAccessToken(String sitecoreId){
        Blob encryptedData;
        try{
            String sessionId = UserInfo.getSessionId();
            final Blob CRYPTOKEY = Blob.valueOf(Label.EncryptionKey);
            Blob dataToEncrypt = Blob.valueOf(sessionId);
            encryptedData = Crypto.encryptWithManagedIV('AES128', CRYPTOKEY, dataToEncrypt);
            List<User> userList = SavvasVirtualSampleUserSelector.getUserById();
            User userRecord = userList.isEmpty()?NULL:userList[0];
            List<Sitecore_Asset__c> sitecoreAssetList = SavvasVirtualSamplesSAssetSelector.getSitecoreAssetById(sitecoreId,userRecord.contactId);
            Sitecore_Asset__c sitecoreAsset = sitecoreAssetList.isEmpty()?NULL:sitecoreAssetList[0];
            if(String.isNotBlank(sitecoreAsset.Id)){
                sitecoreAsset.Is_SF_Launched__c = true;
                update sitecoreAsset;
            }
        }
        catch(Exception e){
            SavvasVirtualSampleLogsUtilty.createApplicationLogs(e,UserInfo.getUserId());
            throw new AuraHandledException('An error occured : '+e.getMessage());
        }
        return encodingUtil.urlEncode(encodingUtil.base64Encode(encryptedData), 'UTF-8');
    }
    
    public class CollectionData{
        @AuraEnabled
        public String assetName{get;set;}
        @AuraEnabled
        public String entityId{get;set;}
        @AuraEnabled
        public String thumbnailId{get;set;}
        @AuraEnabled
        public String programDescription{get;set;}
        @AuraEnabled
        public String entityDescription{get;set;}
        @AuraEnabled
        public String assetURL{get;set;}
        @AuraEnabled
        public String asset_itemId{get;set;}
        @AuraEnabled
        public Boolean showProgramDescription{get;set;}
        @AuraEnabled
        public Boolean showEntityDescription{get;set;}
    }
    public class descriptionDetails{
        @AuraEnabled
        public String collection_itemId{get;set;}
        @AuraEnabled
        public String program_desc{get;set;}
        @AuraEnabled
        public List<collectionDetails> collectionDetails{get;set;}
    }
    public class collectionDetails{
        @AuraEnabled
        public String asset_itemId{get;set;}
        @AuraEnabled
        public String assetName{get;set;}
        @AuraEnabled
        public String entityId{get;set;}
        @AuraEnabled
        public String assetURL{get;set;}
        @AuraEnabled
        public String thumbnailId{get;set;}
        @AuraEnabled
        public String product_desc{get;set;}
        @AuraEnabled
        public String usage_desc{get;set;}
        @AuraEnabled
        public String collectionId{get;set;}
    }
}