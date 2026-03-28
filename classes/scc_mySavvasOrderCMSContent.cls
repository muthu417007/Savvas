public without sharing class scc_mySavvasOrderCMSContent {
/*
*  Method Name : getContent
*  Description : getting the content from the CMS content types for the required components. 
*  param : contentId, page, pageSize, language and filterby.
*  return : CMS content
*/
    public static Map<String, ConnectApi.ManagedContentNodeValue> getContentData(ContentDetails contentDetails) {
   
      try {
            Map<String, ConnectApi.ManagedContentNodeValue> contentBody = new Map<String, ConnectApi.ManagedContentNodeValue>();
            String networkId;
            if(!Test.isRunningTest()){ 
                networkId= Network.getNetworkId();     
            }else{
                system.debug('test');
            networkId=[Select Id from Network where Name = 'Savvas Sample Resources'].Id;
            }
            system.debug('networkID'+networkId);
            Map<String,String> contentData = new Map<String,String>();
          ConnectApi.ManagedContentVersionCollection allManagedContent = ConnectApi.ManagedContent.getAllManagedContent(
                networkId,0,15, contentDetails.language, contentDetails.filterby);
			//ConnectApi.ManagedContentVersionCollection allManagedContent = ConnectApi.ManagedContent.getAllManagedContent(networkId,0,15,'en_US', 'Document');
            system.debug('allManagedContent'+allManagedContent);
          
            for(ConnectApi.ManagedContentVersion items: allManagedContent.items){
                ConnectApi.ManagedContentNodeValue title;
                system.debug('entered line 23'+allManagedContent);
            // if(contentDetails.filterby=='Sfcc_CMS_Alert_Content'){
                    title = items.contentNodes.get('SideBannerDetails');
              //  }

            }
       ConnectApi.ManagedContentVersionCollection contentCollection = ConnectApi.ManagedContent.getManagedContentByContentKeys(
                networkId,new List<String>(contentData.keySet()),0,15, contentDetails.language, contentDetails.filterby,false);
            for(ConnectApi.ManagedContentVersion items: contentCollection.items){
                contentBody.putAll(items.contentNodes);
            }
            return contentBody;
       } 
        catch (ConnectApi.ConnectApiException e) {
           SavvasVirtualSampleLogsUtilty.createApplicationLogs(e,UserInfo.getUserId());
            throw new AuraHandledException(e.getMessage());
            
        } 
    }

        public class ContentDetails{
        @AuraEnabled
        public String contentId {get;set;}
        @AuraEnabled
        public Integer page {get;set;}
        @AuraEnabled
        public Integer pageSize {get;set;}
        @AuraEnabled
        public String language {get;set;}
        @AuraEnabled
        public String filterby {get;set;}
    }
    }