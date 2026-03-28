@isTest
public class TestArticleExtensionStepSet {
    /*
    static testMethod void testStepSetController(){
        Step_Set__kav articleObj = new Step_Set__kav(title='Test StepSet Article', summary= 'Test Summary', urlName='TestClass-StepSet-Article');
        insert articleObj;   

        Step_Set__kav similaryArticleObj = new Step_Set__kav(title='Test StepSet Article', summary= 'Test Summary', urlName='TestClass-StepSet-Similar-Article');
        insert similaryArticleObj;   


        Step_Set__DataCategorySelection  productFamilyCategorySelection = new Step_Set__DataCategorySelection();
        productFamilyCategorySelection.parentId = articleObj.Id ;
        productFamilyCategorySelection.dataCategoryGroupName = 'Product_Family';
        productFamilyCategorySelection.dataCategoryName= 'Languages';
        insert productFamilyCategorySelection;
        
        
        Step_Set__DataCategorySelection  problemDescriptorCategorySelection = new Step_Set__DataCategorySelection();
        problemDescriptorCategorySelection.parentId = articleObj.Id ;
        problemDescriptorCategorySelection.dataCategoryGroupName = 'Problem_Descriptor';
        problemDescriptorCategorySelection.dataCategoryName= 'Testing_Issues';
        insert problemDescriptorCategorySelection;

        Step_Set__kav latestArticleObj = [SELECT Id, Title, Summary, language, CreatedById, KnowledgeArticleId FROM Step_Set__kav WHERE Id = :articleObj.Id];


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
        ArticleExtensionStepSet controller = new ArticleExtensionStepSet(ctl);        
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
    

    static testMethod void testStepSetControllerWithHistory(){
        Step_Set__kav articleObj = new Step_Set__kav(title='Test StepSet Article', summary= 'Test Summary', urlName='TestClass-StepSet-Article');
        insert articleObj;   
      
        ApexPages.currentPage().getParameters().put('popup', 'true');

        Step_Set__kav latestArticleObj = [SELECT Id, Title, Summary, language, CreatedById, KnowledgeArticleId FROM Step_Set__kav WHERE Id = :articleObj.Id];
                
        ApexPages.KnowledgeArticleVersionStandardController ctl = 
            new ApexPages.KnowledgeArticleVersionStandardController(latestArticleObj);        
  
        ArticleExtensionStepSet controller = new ArticleExtensionStepSet(ctl);              
        KbManagement.PublishingService.publishArticle(latestArticleObj.KnowledgeArticleId, true);
               
        
        KnowledgeArticleVersionHistory[] historyList = controller.getArticleHistory();
      //  System.assertEquals(1, historyList.size());
    }
*/
}