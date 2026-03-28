@isTest
public class TestArticleExtensionFAQ {
    /*
    static testMethod void testFAQController(){
        FAQ__kav articleObj = new FAQ__kav(title='Test FAQ Article', summary= 'Test Summary', urlName='TestClass-FAQ-Article');
        insert articleObj;   

        FAQ__kav similaryArticleObj = new FAQ__kav(title='Test FAQ Article', summary= 'Test Summary', urlName='TestClass-FAQ-Similar-Article');
        insert similaryArticleObj;   


        FAQ__DataCategorySelection  productFamilyCategorySelection = new FAQ__DataCategorySelection();
        productFamilyCategorySelection.parentId = articleObj.Id ;
        productFamilyCategorySelection.dataCategoryGroupName = 'Product_Family';
        productFamilyCategorySelection.dataCategoryName= 'Languages';
        insert productFamilyCategorySelection;
        
        
        FAQ__DataCategorySelection  problemDescriptorCategorySelection = new FAQ__DataCategorySelection();
        problemDescriptorCategorySelection.parentId = articleObj.Id ;
        problemDescriptorCategorySelection.dataCategoryGroupName = 'Problem_Descriptor';
        problemDescriptorCategorySelection.dataCategoryName= 'Testing_Issues';
        insert problemDescriptorCategorySelection;

        FAQ__kav latestArticleObj = [SELECT Id, Title, Summary, language, CreatedById, KnowledgeArticleId FROM FAQ__kav WHERE Id = :articleObj.Id];


        Case c = new Case();
        c.subject= 'Testing Case Subject';
        c.description = 'Testing Case Description';
        c.Platform__c = 'SuccessMaker';
        insert c;
        String caseId = c.id;
         
        ApexPages.currentPage().getParameters().put('caseID', caseId);
        ApexPages.currentPage().getParameters().put('popup', 'false');

                
        ApexPages.KnowledgeArticleVersionStandardController ctl = 
            new ApexPages.KnowledgeArticleVersionStandardController(latestArticleObj);        
        ArticleExtensionFAQ controller = new ArticleExtensionFAQ(ctl);        
        controller.attachToCase();
        
        
        System.assertEquals(articleObj.id, controller.articleVersion.Id);
 
        System.assertEquals(2, controller.getNumOfCreatedArticleByAuthor());
        
        CaseArticle[] caseArticleList = controller.getCasesAttached();
        
        System.assertEquals(1, caseArticleList.size());
        
        System.assertEquals(2, controller.getNumOfCreatedArticleByAuthor());

        KnowledgeArticleVersion[] similarArticles = controller.getSimilarArticles();
//        System.assertEquals(1, similarArticles.size());


        KnowledgeArticleVersionHistory[] historyList = controller.getArticleHistory();
        System.assertEquals(0, historyList.size());

        KbManagement.PublishingService.publishArticle(latestArticleObj.KnowledgeArticleId, true);
        
        historyList = controller.getArticleHistory();
        System.assertEquals(0, historyList.size());
       
    }
    

    static testMethod void testFAQControllerWithHistory(){
        FAQ__kav articleObj = new FAQ__kav(title='Test FAQ Article', summary= 'Test Summary', urlName='TestClass-FAQ-Article');
        insert articleObj;   
        ApexPages.currentPage().getParameters().put('popup', 'true');

        FAQ__kav latestArticleObj = [SELECT Id, Title, Summary, language, CreatedById, KnowledgeArticleId FROM FAQ__kav WHERE Id = :articleObj.Id];
                
        ApexPages.KnowledgeArticleVersionStandardController ctl = 
            new ApexPages.KnowledgeArticleVersionStandardController(latestArticleObj);        
        ArticleExtensionFAQ controller = new ArticleExtensionFAQ(ctl);        
        
        KbManagement.PublishingService.publishArticle(latestArticleObj.KnowledgeArticleId, true);
        
        KnowledgeArticleVersionHistory[] historyList = controller.getArticleHistory();
       // System.assertEquals(1, historyList.size());

    }    
    
    */
}