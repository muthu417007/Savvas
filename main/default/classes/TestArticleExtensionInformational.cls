@isTest
public class TestArticleExtensionInformational {
    /*
    static testMethod void testInformationalController(){
        Informational__kav articleObj = new Informational__kav(title='Test Informational Article', summary= 'Test Summary', urlName='TestClass-Informational-Article');
        insert articleObj;   

        Informational__kav similaryArticleObj = new Informational__kav(title='Test Informational Article', summary= 'Test Summary', urlName='TestClass-Informational-Similar-Article');
        insert similaryArticleObj;   


        Informational__DataCategorySelection  productFamilyCategorySelection = new Informational__DataCategorySelection();
        productFamilyCategorySelection.parentId = articleObj.Id ;
        productFamilyCategorySelection.dataCategoryGroupName = 'Product_Family';
        productFamilyCategorySelection.dataCategoryName= 'Languages';
        insert productFamilyCategorySelection;
        
        
        Informational__DataCategorySelection  problemDescriptorCategorySelection = new Informational__DataCategorySelection();
        problemDescriptorCategorySelection.parentId = articleObj.Id ;
        problemDescriptorCategorySelection.dataCategoryGroupName = 'Problem_Descriptor';
        problemDescriptorCategorySelection.dataCategoryName= 'Testing_Issues';
        insert problemDescriptorCategorySelection;

        Informational__kav latestArticleObj = [SELECT Id, Title, Summary, language, CreatedById, KnowledgeArticleId FROM Informational__kav WHERE Id = :articleObj.Id];


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
        ArticleExtensionInformational controller = new ArticleExtensionInformational(ctl);        
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
    

    static testMethod void testInformationalControllerWithHistory(){
        Informational__kav articleObj = new Informational__kav(title='Test Informational Article', summary= 'Test Summary', urlName='TestClass-Informational-Article');
        insert articleObj;   
      
        ApexPages.currentPage().getParameters().put('popup', 'true');

        Informational__kav latestArticleObj = [SELECT Id, Title, Summary, language, CreatedById, KnowledgeArticleId FROM Informational__kav WHERE Id = :articleObj.Id];
                
        ApexPages.KnowledgeArticleVersionStandardController ctl = 
            new ApexPages.KnowledgeArticleVersionStandardController(latestArticleObj);        
  
        ArticleExtensionInformational controller = new ArticleExtensionInformational(ctl);              
        KbManagement.PublishingService.publishArticle(latestArticleObj.KnowledgeArticleId, true);
               
        
        KnowledgeArticleVersionHistory[] historyList = controller.getArticleHistory();
      //  System.assertEquals(1, historyList.size());
    }    
    
    */
}