/**
  *  Controller class to redirect Flow based article to the right flow 
  *  Based on Flow_Name__c for an article.  
  */
public with sharing class  ArticleExtensionDecisionTree{

    /* Holds the current Flow based article.
    public final Flow__kav article;
    
    // Constructor to initiate current article.
    public ArticleExtensionDecisionTree(ApexPages.KnowledgeArticleVersionStandardController stdController) {
            this.article = (Flow__kav)stdController.getRecord();
    }
                 
    
    // Method to redirect to approproate flow. 
    public PageReference redirectInternal()
    {
        // No redirect if article is null or flow_name__c is not defined for an article.
        if(this.article==null || this.article.get('Flow_Name__c') == null)
        {
            return null;
        }
        
       String flowName = (String)this.article.get('Flow_Name__c');
       String url = '/flow/' + flowName;
       if(settingsMap.get(flowName) != null)
       {
          String internalPageName = ((DecisionTreeArticleTypePageSettings__c)settingsMap.get(flowName)).InternalPageName__c;
           if(internalPageName !=null && internalPageName !=''){
            url = '/apex/' + internalPageName;
           }
       }

       PageReference p = new PageReference(url);
       p.setRedirect(true);
      return p;
    }
    
    private Map<String,DecisionTreeArticleTypePageSettings__c> settingsMap {
    get {
      if (settingsMap == null) settingsMap = DecisionTreeArticleTypePageSettings__c.getAll();
      return settingsMap;
    }
    private set;
   }
    
    
    // Method to redirect to approproate VF Wrapper to display in sites. 
    public String getDynamicFlowPage()
    {
        // No redirect if article is null or flow_name__c is not defined for an article.
        if(this.article==null || this.article.get('Flow_Name__c') == null)
        {
            return null;
        }
       String flowName = (String)this.article.get('Flow_Name__c');
       if(settingsMap.get(flowName) ==null)
       {
           return null;
       }
       return ((DecisionTreeArticleTypePageSettings__c)settingsMap.get(flowName)).ExternalPageName__c;
    }  */  
}