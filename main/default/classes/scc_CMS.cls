public without sharing class scc_CMS {
    
    @AuraEnabled(cacheable=false)
    public static List<CMSContent> getCMSContentByContentKey(String ContentKey){
        try{
            
            system.debug('ContentKey: '+ContentKey);
            
            String channelId = ConnectApi.ManagedContent.getAllDeliveryChannels(0, 1).channels[0].channelId;
            system.debug('channelId: '+channelId);
            
            ConnectApi.ManagedContentCollectionItems data = ConnectApi.ManagedContentDelivery.getCollectionItemsForChannel(channelId, ContentKey, NULL);
            List<CMSContent> CMSContents = getCollectionCMSContent(data, channelId);

            system.debug('return data: '+CMSContents);
            return CMSContents;
            
        }catch(Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    public static List<CMSContent> getCollectionCMSContent(ConnectApi.ManagedContentCollectionItems data, String channelId) {
        try {
            
            List<CMSContent> CMSContents = new List<CMSContent>();
            
            CMSContent CMSContentObj = new CMSContent();
            CMSContentObj.contentKey = data.collectionKey;
            CMSContentObj.contentType = data.collectionType.fullyQualifiedName;
            CMSContentObj.mainTitle = data.title;
            //CMSContentObj.unauthenticatedUrl = data.urlName;
            
            list<ContentItem> ContentItemsObjList = new list<ContentItem> ();
            for(ConnectApi.ManagedContentCollectionItem item: data.items){
                ContentItem ContentItemObj = new ContentItem();
                ContentItemObj.key = item.id;
                ContentItemObj.title = item.name;
                ConnectApi.ManagedContentDeliveryDocument newsData = ConnectApi.ManagedContentDelivery.getManagedContentForChannel(channelId, item.id, true);
                String.ValueOf(newsData?.contentBody?.get('body'));
                ContentItemObj.body = String.ValueOf(newsData?.contentBody?.get('body'));
                ContentItemsObjList.add(ContentItemObj);
            }

            CMSContentObj.ContentItems = ContentItemsObjList;
            CMSContents.add(CMSContentObj);        
            
            return CMSContents;
        }catch(Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    public class CMSContent {
        @AuraEnabled public string contentKey {get; set;}
        @AuraEnabled public string contentType {get; set;}
        @AuraEnabled public String mainTitle {get; set;}
        @AuraEnabled public list<ContentItem> ContentItems {get; set;}
    }
    public class ContentItem {
        @AuraEnabled public string key {get; set;}
        @AuraEnabled public String title {get; set;}
        @AuraEnabled public String body {get; set;}
    }
    
}