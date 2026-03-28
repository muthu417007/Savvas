@isTest
public class TestArticleExtensionMediaPresentation {
    /*
    static testMethod void testMediaPresentationController(){
        Media_Presentation__kav articleObj = new Media_Presentation__kav(title='Test MediaPresentation Article', summary= 'Test Summary', urlName='TestClass-MediaPresentation-Article');
        insert articleObj;   

        Media_Presentation__kav similaryArticleObj = new Media_Presentation__kav(title='Test MediaPresentation Article', summary= 'Test Summary', urlName='TestClass-MediaPresentation-Similar-Article');
        insert similaryArticleObj;   


        Media_Presentation__DataCategorySelection  productFamilyCategorySelection = new Media_Presentation__DataCategorySelection();
        productFamilyCategorySelection.parentId = articleObj.Id ;
        productFamilyCategorySelection.dataCategoryGroupName = 'Product_Family';
        productFamilyCategorySelection.dataCategoryName= 'Languages';
        insert productFamilyCategorySelection;
        
        
        Media_Presentation__DataCategorySelection  problemDescriptorCategorySelection = new Media_Presentation__DataCategorySelection();
        problemDescriptorCategorySelection.parentId = articleObj.Id ;
        problemDescriptorCategorySelection.dataCategoryGroupName = 'Problem_Descriptor';
        problemDescriptorCategorySelection.dataCategoryName= 'Testing_Issues';
        insert problemDescriptorCategorySelection;

        Media_Presentation__kav latestArticleObj = [SELECT Id, Title, Summary, language, CreatedById, KnowledgeArticleId FROM Media_Presentation__kav WHERE Id = :articleObj.Id];


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
        ArticleExtensionMediaPresentation controller = new ArticleExtensionMediaPresentation(ctl);        
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
    

    static testMethod void testMediaPresentationControllerWithHistory(){
        Media_Presentation__kav articleObj = new Media_Presentation__kav(title='Test MediaPresentation Article', summary= 'Test Summary', urlName='TestClass-MediaPresentation-Article');
        insert articleObj;   
      
        ApexPages.currentPage().getParameters().put('popup', 'true');

        Media_Presentation__kav latestArticleObj = [SELECT Id, Title, Summary, language, CreatedById, KnowledgeArticleId FROM Media_Presentation__kav WHERE Id = :articleObj.Id];
                
        ApexPages.KnowledgeArticleVersionStandardController ctl = 
            new ApexPages.KnowledgeArticleVersionStandardController(latestArticleObj);        
  
        ArticleExtensionMediaPresentation controller = new ArticleExtensionMediaPresentation(ctl);              
        KbManagement.PublishingService.publishArticle(latestArticleObj.KnowledgeArticleId, true);
               
        
        KnowledgeArticleVersionHistory[] historyList = controller.getArticleHistory();
       // System.assertEquals(1, historyList.size());
    }    
    
    */
}