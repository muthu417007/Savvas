/*
@Author : Cognizant Team
@Name : SavvasVirtualSamplingCommunityHelper
@CreateDate : 10-Aug-2023
@Description: This class is helper class for savvas sample resources community
@ModifiedBy: Cognizant Team
@ModifiedDate: 18-Sep-2024
@Ticket Number: VS-0012, VS-0013
*/
public without sharing class SavvasVirtualSamplingCommunityHelper {
    /*
    *  Method Name : getProgramDetails
    *  Description : getting all the Program Details
    *  param : None
    *  return : All Program Details
    */
    public static ProgramContainer getProgramDetails(){
        List<ProgramDetails> prgrmDetail= new List<ProgramDetails>();
        ProgramContainer allProgramDetails = new ProgramContainer();
        Set<String> collectionIds = new Set<String>();
        List<Collection_Access__c> collectionList= new List<Collection_Access__c>();
        Map<String,Map<String,Decimal>> gradeDetails = new Map<String,Map<String,Decimal>>();
        Map<String,ProgramBannerDetails> programBannerData = new Map<String,ProgramBannerDetails>();
        Map<String,Map<String,set<String>>> resourceTypeDetails = new Map<String,Map<String,set<String>>>();
        Map<String,Map<String,Map<String,List<AssetDetails>>>> assetDetails= new Map<String,Map<String,Map<String,List<AssetDetails>>>>();
        try{
            List<User> user = SavvasVirtualSampleUserSelector.getUserList(UserInfo.getUserEmail());
            collectionList = SavvasVirtualSamplesCAccessSelector.getCollectionAccessList(user[0].AccountId); //W-015376: added AccountId as part of SSO Implementation
            if(!collectionList.isEmpty()){
                for(Collection_Access__c eachRecord : collectionList)
                {
                    ProgramDetails detail = new ProgramDetails();
                    detail.id = eachRecord.Id;
                    detail.name = eachRecord.Name;
                    Integer expiry = System.today().daysBetween(eachRecord.Access_Valid_Till__c);
                    String expiryMessage = (Label.Savvas_Virtual_Sample_Program_Expiry).replace('expiry',String.valueOf(expiry));
                    detail.expiry = (expiry)>0?expiryMessage:Label.Savvas_Virtual_Sample_Expiry_Message;
                    detail.isExpired = expiry>0?false:true;
                    detail.isVirtualSample = (eachRecord.Program_Type__c=='2.0')?true:false;
                    if(expiry>0 && eachRecord.Program_Type__c == '2.0'){
                        collectionIds.add(eachRecord.Collection_Id__c);
                    }
                    prgrmDetail.add(detail);
                }
                if(!prgrmDetail.isEmpty()){
                    allProgramDetails.programList = prgrmDetail;
                }
                if(!collectionIds.isEmpty()){
                    for(Samples_Category_Asset__c eachRecord :SavvasVirtualSamplesSCAssetSelector.getSampleCategoryAssetByCollectionId(collectionIds)){
                        if(gradeDetails.isEmpty()){
                            gradeDetails.put(eachRecord.Sample_Category_Name__r.Parent_Program__r.Name,new Map<String,Decimal>());
                            gradeDetails.get(eachRecord.Sample_Category_Name__r.Parent_Program__r.Name).put(eachRecord.Sample_Category_Name__r.Name,eachRecord.Sample_Category_Name__r.Sequence__c);
                        }
                        else{
                            if(gradeDetails.containsKey(eachRecord.Sample_Category_Name__r.Parent_Program__r.Name)){
                                if(!gradeDetails.get(eachRecord.Sample_Category_Name__r.Parent_Program__r.Name).containsKey(eachRecord.Sample_Category_Name__r.Name)){
                                    gradeDetails.get(eachRecord.Sample_Category_Name__r.Parent_Program__r.Name).put(eachRecord.Sample_Category_Name__r.Name,eachRecord.Sample_Category_Name__r.Sequence__c);
                                }
                            }
                            else{
                                gradeDetails.put(eachRecord.Sample_Category_Name__r.Parent_Program__r.Name,new Map<String,Decimal>());
                                gradeDetails.get(eachRecord.Sample_Category_Name__r.Parent_Program__r.Name).put(eachRecord.Sample_Category_Name__r.Name,eachRecord.Sample_Category_Name__r.Sequence__c);
                            }
                        }
                        if(assetDetails.isEmpty()){
                            assetDetails.put(eachRecord.Sample_Category_Name__r.Parent_Program__r.Name,new Map<String,Map<String,List<AssetDetails>>>());
                            assetDetails.get(eachRecord.Sample_Category_Name__r.Parent_Program__r.Name).put(eachRecord.Sample_Category_Name__r.Name,new Map<String,List<AssetDetails>>());
                            assetDetails.get(eachRecord.Sample_Category_Name__r.Parent_Program__r.Name).get(eachRecord.Sample_Category_Name__r.Name).put(eachRecord.Asset_Name__r.Resource_Type__c,new List<AssetDetails>());
                            AssetDetails assetData = new AssetDetails();
                            assetData = getAssetDetails(eachRecord);
                            assetDetails.get(eachRecord.Sample_Category_Name__r.Parent_Program__r.Name).get(eachRecord.Sample_Category_Name__r.Name).get(eachRecord.Asset_Name__r.Resource_Type__c).add(assetData);
                        }
                        else{
                            if(assetDetails.containsKey(eachRecord.Sample_Category_Name__r.Parent_Program__r.Name)){
                                if(assetDetails.get(eachRecord.Sample_Category_Name__r.Parent_Program__r.Name).containsKey(eachRecord.Sample_Category_Name__r.Name)){
                                    if(assetDetails.get(eachRecord.Sample_Category_Name__r.Parent_Program__r.Name).get(eachRecord.Sample_Category_Name__r.Name).containsKey(eachRecord.Asset_Name__r.Resource_Type__c)){
                                        AssetDetails assetData = new AssetDetails();
                                        assetData = getAssetDetails(eachRecord);
                                        assetDetails.get(eachRecord.Sample_Category_Name__r.Parent_Program__r.Name).get(eachRecord.Sample_Category_Name__r.Name).get(eachRecord.Asset_Name__r.Resource_Type__c).add(assetData);
                                    }
                                    else{
                                        assetDetails.get(eachRecord.Sample_Category_Name__r.Parent_Program__r.Name).get(eachRecord.Sample_Category_Name__r.Name).put(eachRecord.Asset_Name__r.Resource_Type__c,new List<AssetDetails>());
                                        AssetDetails assetData = new AssetDetails();
                                        assetData = getAssetDetails(eachRecord);
                                        assetDetails.get(eachRecord.Sample_Category_Name__r.Parent_Program__r.Name).get(eachRecord.Sample_Category_Name__r.Name).get(eachRecord.Asset_Name__r.Resource_Type__c).add(assetData);
                                    }
                                }
                                else{
                                    assetDetails.get(eachRecord.Sample_Category_Name__r.Parent_Program__r.Name).put(eachRecord.Sample_Category_Name__r.Name,new Map<String,List<AssetDetails>>());
                                    assetDetails.get(eachRecord.Sample_Category_Name__r.Parent_Program__r.Name).get(eachRecord.Sample_Category_Name__r.Name).put(eachRecord.Asset_Name__r.Resource_Type__c,new List<AssetDetails>());
                                    AssetDetails assetData = new AssetDetails();
                                    assetData = getAssetDetails(eachRecord);
                                    assetDetails.get(eachRecord.Sample_Category_Name__r.Parent_Program__r.Name).get(eachRecord.Sample_Category_Name__r.Name).get(eachRecord.Asset_Name__r.Resource_Type__c).add(assetData);
                                }
                            }
                            else{
                                assetDetails.put(eachRecord.Sample_Category_Name__r.Parent_Program__r.Name,new Map<String,Map<String,List<AssetDetails>>>());
                                assetDetails.get(eachRecord.Sample_Category_Name__r.Parent_Program__r.Name).put(eachRecord.Sample_Category_Name__r.Name,new Map<String,List<AssetDetails>>());
                                assetDetails.get(eachRecord.Sample_Category_Name__r.Parent_Program__r.Name).get(eachRecord.Sample_Category_Name__r.Name).put(eachRecord.Asset_Name__r.Resource_Type__c,new List<AssetDetails>());
                                AssetDetails assetData = new AssetDetails();
                                assetData = getAssetDetails(eachRecord);
                                assetDetails.get(eachRecord.Sample_Category_Name__r.Parent_Program__r.Name).get(eachRecord.Sample_Category_Name__r.Name).get(eachRecord.Asset_Name__r.Resource_Type__c).add(assetData);
                            }
                        }
                        if(programBannerData.isEmpty()){
                            programBannerData.put(eachRecord.Sample_Category_Name__r.Parent_Program__r.Name,getProgramBannerDetails(eachRecord));
                        }
                        else if(!programBannerData.containsKey(eachRecord.Sample_Category_Name__r.Parent_Program__r.Name)){
                            programBannerData.put(eachRecord.Sample_Category_Name__r.Parent_Program__r.Name,getProgramBannerDetails(eachRecord));
                        }
                    }
                    if(assetDetails.size()>0){
                        allProgramDetails.AssetDetails = AssetDetails;
                    }
                    if(!gradeDetails.isEmpty()){
                            allProgramDetails.gradeDetails = gradeDetails;
                        }
                    if(!programBannerData.isEmpty()){
                        allProgramDetails.programBannerData = programBannerData;
                    }
                }
            }
            else{
                throw new AuraHandledException('No Data to return');                        
            }
        }
        catch(Exception e){
            SavvasVirtualSampleLogsUtilty.createApplicationLogs(e,UserInfo.getUserId());
            throw new AuraHandledException('An error occured : '+e.getMessage());
        }
        return allProgramDetails;
    }
    /*
    *  Method Name : getAssetDetails
    *  Description : getting the Asset Details
    *  param : sampleCategoryAsset
    *  return : Asset Details
    */
    public static AssetDetails getAssetDetails(Samples_Category_Asset__c sampleCategoryAsset){
        AssetDetails assetData = new AssetDetails();
        try{
            assetData.assetItemId = sampleCategoryAsset.Asset_Name__r.Sitecore_Id__c;
            assetData.assetId = sampleCategoryAsset.Asset_Name__c;
            assetData.assetName = sampleCategoryAsset.Asset_Name__r.Display_Title__c;
            assetData.entityId = sampleCategoryAsset.Asset_Name__r.Entity_Id__c;
            assetData.assetURL = sampleCategoryAsset.Asset_Name__r.Asset_Url__c;
            assetData.thumbnailId = sampleCategoryAsset.Asset_Name__r.Thumbnail_URL__c;
            assetData.usageDesc = sampleCategoryAsset.Asset_Name__r.usage_Description__c;
            assetData.assetType = sampleCategoryAsset.Asset_Name__r.Asset_Type__c;
            assetData.lastModified = sampleCategoryAsset.LastModifiedDate;
            assetData.sequence = sampleCategoryAsset.Sequence__c!=null?sampleCategoryAsset.Sequence__c:NULL;
            assetData.isVideoAsset = sampleCategoryAsset.Asset_Name__r.Video_Asset__c;
            assetData.virtualsamplookup=sampleCategoryAsset.Asset_Name__r.Virtual_Samples_Program__r.Name;
        }
        catch(Exception e){
            SavvasVirtualSampleLogsUtilty.createApplicationLogs(e,UserInfo.getUserId());
        }
        return assetData;
    }
    /*
    *  Method Name : getProgramBannerDetails
    *  Description : getting the Program Banner Details
    *  param : sampleCategoryAsset
    *  return : Program Banner Details
    */
    public static ProgramBannerDetails getProgramBannerDetails(Samples_Category_Asset__c sampleCategoryAsset){
        ProgramBannerDetails programBanner = new ProgramBannerDetails();
        programBanner.programName=sampleCategoryAsset.Sample_Category_Name__r.Parent_Program__r.Name;
        programBanner.programDescription = sampleCategoryAsset.Sample_Category_Name__r.Parent_Program__r.Program_Description__c;
        programBanner.programBannerImageURL = sampleCategoryAsset.Sample_Category_Name__r.Parent_Program__r.Program_Banner_Image_URL__c;
        programBanner.programBannerSourceURL = sampleCategoryAsset.Sample_Category_Name__r.Parent_Program__r.Program_Banner_Source_URL__c;
        programBanner.programRightBanner = sampleCategoryAsset.Sample_Category_Name__r.Parent_Program__r.Program_Right_Banner__c;
        return programBanner;
    }
    
    public class ProgramContainer{
        @AuraEnabled
        public List<ProgramDetails> programList{get;set;}
        @AuraEnabled //Map<Program,Map<Grade,Sequence>>
        Public Map<String,Map<String,Decimal>> gradeDetails{get;set;}
        @AuraEnabled
        public Map<String,ProgramBannerDetails> programBannerData{get;set;}
        @AuraEnabled //Map<ProgramName,Map<Grade,Map<ResourceType,List<AssetDetails>>>>
        public Map<String,Map<String,Map<String,List<AssetDetails>>>> assetDetails{get;set;} 
    }
    
    public class ProgramDetails{
        @AuraEnabled
        public String id{get;set;}
        @AuraEnabled
        public String expiry{get;set;}
        @AuraEnabled
        public Boolean isExpired{get;set;}
        @AuraEnabled
        public String name{get;set;}
        @AuraEnabled
        public Boolean isVirtualSample{get;set;}
    }
    
    public class ProgramBannerDetails{
        @AuraEnabled
        public String programDescription{get;set;}
        @AuraEnabled
        public String programBannerImageURL{get;set;}
        @AuraEnabled
        public String programBannerSourceURL{get;set;}
        @AuraEnabled
        public string programRightBanner{get;set;}
        @AuraEnabled
        public string programName{get;set;}
    }
    
    public class AssetDetails{
        @AuraEnabled
        public String assetItemId{get;set;}
        @AuraEnabled
        public String assetId{get;set;}
        @AuraEnabled
        public String assetName{get;set;}
        @AuraEnabled
        public String entityId{get;set;}
        @AuraEnabled
        public String assetURL{get;set;}
        @AuraEnabled
        public String thumbnailId{get;set;}
        @AuraEnabled
        public String usageDesc{get;set;}
        @AuraEnabled
        public String assetType{get;set;}
        @AuraEnabled
        public Decimal sequence{get;set;}
        @AuraEnabled
        public DateTime lastModified{get;set;}
        @AuraEnabled
        public Boolean isVideoAsset{get;set;}
        @AuraEnabled
        public String virtualsamplookup{get;set;}
    }
}