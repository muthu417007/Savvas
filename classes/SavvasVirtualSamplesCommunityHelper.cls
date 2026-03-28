/*
@Author : Cognizant Team
@Name : SavvasVirtualSamplesCommunityHelper
@CreateDate : 7-Aug-2023
@Description: This class is helper class for for SavvasVirtualSamplesCommunityHelper Version: 1.0
@ModifiedBy: Cognizant Team
@ModifiedDate: 02-Nov-2023
@Ticket Number: VS-0024,VS-0025
*/

public without sharing class SavvasVirtualSamplesCommunityHelper{
    
    /*
*  Method Name : fetchFooterDetails
*  Description : getting the Savvas_VS_Community_Footer__mdt records
*  param : None
*  return : List of Savvas_VS_Community_Footer__mdt records
*/
    public static List <Savvas_VS_Community_Footer__mdt> fetchFooterDetails() {
        try{
            List<Savvas_VS_Community_Footer__mdt> metadata = new List<Savvas_VS_Community_Footer__mdt>();
            metadata=[SELECT DeveloperName,Id, MasterLabel,Footer_Copyright_Details__c,Label,Footer_Link__c,Parent_Label__c,Top_Sequence__c,Bottom_Sequence__c 
                      FROM Savvas_VS_Community_Footer__mdt
                      ORDER BY Top_Sequence__c,Bottom_Sequence__c ASC];
            return metadata;
        }
        catch (Exception e) {
            SavvasVirtualSampleLogsUtilty.createApplicationLogs(e,UserInfo.getUserId());
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    
    /*
*  Method Name : getContent
*  Description : getting the content from the CMS content types for the required components. 
*  param : contentId, page, pageSize, language and filterby.
*  return : CMS content
*/
    
    public static Map<String, ConnectApi.ManagedContentNodeValue> getContent(ContentDetails contentDetails) {
        try {
            Map<String, ConnectApi.ManagedContentNodeValue> contentBody = new Map<String, ConnectApi.ManagedContentNodeValue>();
            String networkId;
            if(!Test.isRunningTest()){
                networkId= Network.getNetworkId();
            }else{
                networkId=[Select Id from Network where Name = 'Savvas Sample Resources'].Id;
            }
            Map<String,String> contentData = new Map<String,String>();
            ConnectApi.ManagedContentVersionCollection allManagedContent = ConnectApi.ManagedContent.getAllManagedContent(
                networkId,0,15, contentDetails.language, contentDetails.filterby);
            for(ConnectApi.ManagedContentVersion items: allManagedContent.items){
                ConnectApi.ManagedContentNodeValue title;
                if(contentDetails.filterby=='news'){
                    title = items.contentNodes.get('title');
                }
                else if(contentDetails.filterby=='savvas_CMS_Default_Side_Banner'){
                    title = items.contentNodes.get('SideBannerDetailsDefault');
                }
                else if(contentDetails.filterby=='savvas_Virtual_CMS_Side_Banner'){
                    title = items.contentNodes.get('SideBannerDetails');
                }
                String titleValue = (title.toString()).substringBetween('value=', ']'); 
                if(titleValue == contentDetails.contentId){
                    contentData.put(items.contentKey, titleValue);
                }
            }
            ConnectApi.ManagedContentVersionCollection contentCollection = ConnectApi.ManagedContent.getManagedContentByContentKeys(
                networkId,new List<String>(contentData.keySet()),0,15, contentDetails.language, contentDetails.filterby,false);
            for(ConnectApi.ManagedContentVersion items: contentCollection.items){
                contentBody.putAll(items.contentNodes);
            }
            return contentBody;
        } catch (ConnectApi.ConnectApiException e) {
            SavvasVirtualSampleLogsUtilty.createApplicationLogs(e,UserInfo.getUserId());
            throw new AuraHandledException(e.getMessage());
        }
    }
    /*
*  Method Name : fetchCssFileFromAttachment
*  Description : getting the required uploaded css file from the Savvas Virtual Samples Css library and
*                and implementing the same for the required lwc component.
*  param : None
*  return : Css file for the required lwc component. 
*/
    public static string fetchCssFileFromAttachment(String title){
        try {
            return [SELECT VersionDataUrl
                    FROM ContentVersion
                    WHERE Title =: title 
                    AND IsLatest = true
                    AND FileExtension='css' 
                    ORDER BY createdDate DESC  
                    LIMIT 1].VersionDataUrl ;     
        } catch (Exception e) {
            SavvasVirtualSampleLogsUtilty.createApplicationLogs(e,UserInfo.getUserId());
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    /*
*  Method Name : callFlow
*  Description : calling the flow based on Asset Clicks
*  param : flowDetails
*  return : None
*/
    @AuraEnabled
    public static void callFlow(FlowDetails flowDetails){
        try{
            Map<String, Object> Params = new Map<String, Object>();
            Params.put('sitecoreAsset_name', flowDetails.sampleAssetName);
            Params.put('sitecoreAsset_SitecoreId', flowDetails.sampleAssetSitecoreId);
            Params.put('virtualsample_ProgramName', flowDetails.virtualsampleProgramName);
            
            Flow.Interview.Savvas_VS_2_0_Create_Asset_Tracking_Records_from_Asset_Clicks flow = new Flow.Interview.Savvas_VS_2_0_Create_Asset_Tracking_Records_from_Asset_Clicks(Params); 
            flow.start();
            if(Test.isRunningTest()){
                throw new AuraHandledException('Flow Exception');
            }
        }catch(Exception e) {
            SavvasVirtualSampleLogsUtilty.createApplicationLogs(e,UserInfo.getUserId());
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    public class FlowDetails{
        @AuraEnabled
        public String sampleAssetName{get;set;}
        @AuraEnabled
        public String sampleAssetSitecoreId{get;set;}
        @AuraEnabled
        public String virtualsampleProgramName{get;set;}
    }
    public class ContentDetails{
        @AuraEnabled
        public String contentId{get;set;}
        @AuraEnabled
        public Integer page{get;set;}
        @AuraEnabled
        public Integer pageSize{get;set;}
        @AuraEnabled
        public String language{get;set;}
        @AuraEnabled
        public String filterby{get;set;}
    }
}