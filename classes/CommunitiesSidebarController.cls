public with sharing class CommunitiesSidebarController {
    /*
     We use wrapper class to provide custom url to recent item
     */
    public class recentItem {
        public String url {get; protected set;}
        public String name {get; protected set;}
        public String type {get; protected set;}
        public Id objId {get; protected set;}
        public recentItem(RecentlyViewed rv, Map<Id, KnowledgeArticleVersion> kavMap) {
            this.name = rv.Name;
            this.type = rv.Type;
            String idPrefix = String.valueOf(rv.Id).left(3);
            if (idPrefix == '001') {
            //Account
                this.url = Site.getBaseCustomUrl() + Page.CommunitiesAccountDetail.getUrl() + '?id=' + rv.Id;
            } else if (idPrefix == '003') {
            //Contact
                this.url = Site.getBaseCustomUrl() + Page.CommunitiesContactDetail.getUrl() + '?id=' + rv.Id;
            } else if (idPrefix == '500') {
            //Case
                this.url = Site.getBaseCustomUrl() + Page.CommunitiesCaseDetail.getUrl() + '?id=' + rv.Id;
            } else if (idPrefix.left(1) == 'k') {
            //article
                if (kavMap.containsKey(rv.Id)) {
                    KnowledgeArticleVersion kav = kavMap.get(rv.Id);
                   // this.url = Site.getBaseCustomUrl() + '/articles/' + kav.articleType.substringBeforeLast('__ka')+   '/'  + kav.UrlName + '/';
                     this.url = Site.getBaseCustomUrl() + '/articles/'   + kav.UrlName + '/';
                }
            } else {
            //Other
                this.url = Site.getBaseCustomUrl() + '/' + rv.Id;
            }             
        }
    }

    public List<recentItem> getRecentItems() {
        List<recentItem> recentItems = new List<recentItem>();
        List<RecentlyViewed> RecentlyViewedList = [SELECT Id, Type, Name FROM RecentlyViewed WHERE LastViewedDate !=null ORDER BY LastViewedDate DESC LIMIT 20];
        Set<Id> articleIds = new Set<Id>();
        for (RecentlyViewed rv : RecentlyViewedList) {
            if (String.valueOf(rv.Id).left(1) == 'k') {
                articleIds.add(rv.Id);
            }

        }
        Map<Id, KnowledgeArticleVersion> kavMap = new Map<Id, KnowledgeArticleVersion>();
        if (articleIds.size()>0) {
            //List<KnowledgeArticleVersion> articleList = [SELECT KnowledgeArticleId, Id, articleType, UrlName 
            List<KnowledgeArticleVersion> articleList = [SELECT KnowledgeArticleId, Id, UrlName 
                FROM KnowledgeArticleVersion
                WHERE PublishStatus='Online'
                AND IsLatestVersion=true
                AND KnowledgeArticleId = :articleIds];
                for(KnowledgeArticleVersion kav : articleList) {
                    kavMap.put(kav.KnowledgeArticleId, kav);
                }
        }
        for (RecentlyViewed rv : RecentlyViewedList) {
            recentItems.add(new recentItem(rv, kavMap));
        }
        return recentItems;
    }

    public CommunitiesSidebarController() {

    }
}