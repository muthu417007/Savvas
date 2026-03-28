@isTest
public class TestArticleExtensionDecisionTree {
    /*
    static testMethod void testRedirectInternalNull(){
        Flow__kav flowArticleObj = new Flow__kav();
        ApexPages.KnowledgeArticleVersionStandardController ctl = 
            new ApexPages.KnowledgeArticleVersionStandardController(flowArticleObj);        
        ArticleExtensionDecisionTree dtController = new ArticleExtensionDecisionTree(ctl);
        PageReference pageRef = dtController.redirectInternal();
        System.assertEquals(null, pageRef);
    }
 
    static testMethod void testRedirectInternalWithFlow(){
        String flowName = 'CD_Support';
        Flow__kav flowArticleObj = new Flow__kav();
        flowArticleObj.Flow_Name__c = flowName;
        ApexPages.KnowledgeArticleVersionStandardController ctl = 
            new ApexPages.KnowledgeArticleVersionStandardController(flowArticleObj);        
        ArticleExtensionDecisionTree dtController = new ArticleExtensionDecisionTree(ctl);
        PageReference pageRef = dtController.redirectInternal();
        System.assertEquals('/flow/' + flowName, pageRef.getUrl());
    }
    
 
    static testMethod void testRedirectInternalWithCustomPage(){
        String flowName = 'CD_Support';
        Flow__kav flowArticleObj = new Flow__kav();
        flowArticleObj.Flow_Name__c = flowName;
        
        DecisionTreeArticleTypePageSettings__c setting = new DecisionTreeArticleTypePageSettings__c();
        setting.Name = flowName;
        setting.InternalPageName__c = flowName + '_Internal';
        insert setting;
        
        ApexPages.KnowledgeArticleVersionStandardController ctl = 
            new ApexPages.KnowledgeArticleVersionStandardController(flowArticleObj);        
        ArticleExtensionDecisionTree dtController = new ArticleExtensionDecisionTree(ctl);
        PageReference pageRef = dtController.redirectInternal();
        System.assertEquals('/apex/' + flowName + '_Internal', pageRef.getUrl());
    }
    
    static testMethod void testGetDynamicFlowPageNull(){
        Flow__kav flowArticleObj = new Flow__kav();
        ApexPages.KnowledgeArticleVersionStandardController ctl = 
            new ApexPages.KnowledgeArticleVersionStandardController(flowArticleObj);        
        ArticleExtensionDecisionTree dtController = new ArticleExtensionDecisionTree(ctl);
        String pageName = dtController.getDynamicFlowPage();
        System.assertEquals(null, pageName);
    }
    
    static testMethod void testGetDynamicFlowPageNoSettings(){
        String flowName = 'CD_Support';
        Flow__kav flowArticleObj = new Flow__kav();
        flowArticleObj.Flow_Name__c = flowName;
        
        
        ApexPages.KnowledgeArticleVersionStandardController ctl = 
            new ApexPages.KnowledgeArticleVersionStandardController(flowArticleObj);        
        ArticleExtensionDecisionTree dtController = new ArticleExtensionDecisionTree(ctl);
        String pageName = dtController.getDynamicFlowPage();
        System.assertEquals(null, pageName);
    }
 
     static testMethod void testGetDynamicFlowPage(){
        String flowName = 'CD_Support';
        Flow__kav flowArticleObj = new Flow__kav();
        flowArticleObj.Flow_Name__c = flowName;
        
        DecisionTreeArticleTypePageSettings__c setting = new DecisionTreeArticleTypePageSettings__c();
        setting.Name = flowName;
        setting.ExternalPageName__c = flowName + '_External';
        insert setting;
        
        ApexPages.KnowledgeArticleVersionStandardController ctl = 
            new ApexPages.KnowledgeArticleVersionStandardController(flowArticleObj);        
        ArticleExtensionDecisionTree dtController = new ArticleExtensionDecisionTree(ctl);
        String pageName = dtController.getDynamicFlowPage();
        System.assertEquals(flowName + '_External', pageName);
    }   */
    
}