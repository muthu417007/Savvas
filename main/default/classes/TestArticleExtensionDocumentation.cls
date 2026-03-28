@isTest
public class TestArticleExtensionDocumentation {
    /*
    static testMethod void testDocumentationController(){
        Documentation__kav articleObj = new Documentation__kav(title='Test Documentation Article', summary= 'Test Summary', urlName='TestClass-Documentation-Article');
        insert articleObj;   

        Documentation__kav similaryArticleObj = new Documentation__kav(title='Test Documentation Article', summary= 'Test Summary', urlName='TestClass-Documentation-Similar-Article');
        insert similaryArticleObj;   


        Documentation__DataCategorySelection  productFamilyCategorySelection = new Documentation__DataCategorySelection();
        productFamilyCategorySelection.parentId = articleObj.Id ;
        productFamilyCategorySelection.dataCategoryGroupName = 'Product_Family';
        productFamilyCategorySelection.dataCategoryName= 'Languages';
        insert productFamilyCategorySelection;
        
        
        Documentation__DataCategorySelection  problemDescriptorCategorySelection = new Documentation__DataCategorySelection();
        problemDescriptorCategorySelection.parentId = articleObj.Id ;
        problemDescriptorCategorySelection.dataCategoryGroupName = 'Problem_Descriptor';
        problemDescriptorCategorySelection.dataCategoryName= 'Testing_Issues';
        insert problemDescriptorCategorySelection;

        Documentation__kav latestArticleObj = [SELECT Id, Title, Summary, language, CreatedById, KnowledgeArticleId FROM Documentation__kav WHERE Id = :articleObj.Id];


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
        ArticleExtensionDocumentation controller = new ArticleExtensionDocumentation(ctl);        
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
    

    static testMethod void testDocumentationControllerWithHistory(){
        Documentation__kav articleObj = new Documentation__kav(title='Test Documentation Article', summary= 'Test Summary', urlName='TestClass-Documentation-Article');
        insert articleObj;   
      
        ApexPages.currentPage().getParameters().put('popup', 'true');

        Documentation__kav latestArticleObj = [SELECT Id, Title, Summary, language, CreatedById, KnowledgeArticleId FROM Documentation__kav WHERE Id = :articleObj.Id];
                
        ApexPages.KnowledgeArticleVersionStandardController ctl = 
            new ApexPages.KnowledgeArticleVersionStandardController(latestArticleObj);        
  
        ArticleExtensionDocumentation controller = new ArticleExtensionDocumentation(ctl);              
        KbManagement.PublishingService.publishArticle(latestArticleObj.KnowledgeArticleId, true);
               
        
        KnowledgeArticleVersionHistory[] historyList = controller.getArticleHistory();
        //System.assertEquals(1, historyList.size());
    }    
    
    */
}