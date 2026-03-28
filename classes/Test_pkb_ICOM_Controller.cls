@isTest
public class Test_pkb_ICOM_Controller {
/*

    // Test the regular params from standard pkb_controller.
    static testMethod void testController() {
        pkb_Controller refCon = new pkb_Controller();

        PageReference p;
        p = new PageReference('/');
        p.getParameters().put(refCon.queryParam, 'foor');
        p.getParameters().put(refCon.languageParam, 'en_US');
        p.getParameters().put(refCon.categoryParam, '');
        p.getParameters().put(pkb_ICOM_Controller.ARTICLE_TYPE_PARAM, '');
        p.getParameters().put(pkb_Controller.CONTACT_US_PARAM, '');
        Test.setCurrentPage(p);
        pkb_ICOM_Controller pkbCon = new pkb_ICOM_Controller(new ApexPages.StandardController(new KnowledgeArticle()));
        System.assertNotEquals(pkbCon.allSearchParams, null);
    }

    // Test the articleTypeParm
    static testMethod void testArticleTypeParam() {
        PageReference p;
        p = new PageReference('/');
        p.getParameters().put(pkb_ICOM_Controller.ARTICLE_TYPE_PARAM, 'StepSet');
        Test.setCurrentPage(p);
        pkb_ICOM_Controller pkbCon = new pkb_ICOM_Controller(new ApexPages.StandardController(new KnowledgeArticle()));
        System.assertEquals(pkbCon.allSearchParams, 'at=StepSet');
        System.assertEquals(pkbCon.articleType, 'StepSet');
    }*/
}