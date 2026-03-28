/// enosiX Inc. Generated Apex Model
/// Generated On: 8/28/2023 1:35:03 PM
/// SAP Host: From REST Service On: https://site-platform-5752-dev-ed.scratch.my.salesforce.com
/// CID: From REST Service On: https://site-platform-5752-dev-ed.scratch.my.salesforce.com
/// Generator Version: 2.5.0.0, Target Framework ensxapp.v1.2

@isTest
private class ensxtx_TST_SFCISalesDocOutput_Search
{

    public class Mockensxtx_SBO_SFCISalesDocOutput_Search implements ensxsdk.EnosixFramework.SearchSBOInitMock, ensxsdk.EnosixFramework.SearchSBOSearchMock
    {
        public ensxsdk.EnosixFramework.SearchContext executeInitialize(ensxsdk.EnosixFramework.SearchContext sc)
        {
            return null;
        }
        public ensxsdk.EnosixFramework.SearchContext executeSearch(ensxsdk.EnosixFramework.SearchContext sc)
        {
            return null;
        }
    }

    @isTest
    static void testSBO()
    {
        ensxsdk.EnosixFramework.setMock(ensxtx_SBO_SFCISalesDocOutput_Search.class, new Mockensxtx_SBO_SFCISalesDocOutput_Search());
        ensxtx_SBO_SFCISalesDocOutput_Search sbo = new ensxtx_SBO_SFCISalesDocOutput_Search();
        System.assertEquals(ensxtx_SBO_SFCISalesDocOutput_Search.class, sbo.getType(), 'getType() does not match object type.');

        System.assertEquals(null, sbo.initialize(null));
        System.assertEquals(null, sbo.search(null));

        ensxtx_SBO_SFCISalesDocOutput_Search.SFCISalesDocOutput_SC sc = new ensxtx_SBO_SFCISalesDocOutput_Search.SFCISalesDocOutput_SC();
        System.assertEquals(ensxtx_SBO_SFCISalesDocOutput_Search.SFCISalesDocOutput_SC.class, sc.getType(), 'getType() does not match object type.');

        sc.registerReflectionForClass();
        System.assertEquals(null, sc.result);

        System.assertNotEquals(null, sc.SEARCHPARAMS);
        System.assertNotEquals(null, sc.OUTPUT_TYPE);

    }
    
    
    @isTest
    static void testSEARCHPARAMS()
    {
        ensxtx_SBO_SFCISalesDocOutput_Search.SEARCHPARAMS childObj = new ensxtx_SBO_SFCISalesDocOutput_Search.SEARCHPARAMS();
        System.assertEquals(ensxtx_SBO_SFCISalesDocOutput_Search.SEARCHPARAMS.class, childObj.getType(),'getType() does not match object type.');

        childObj.registerReflectionForClass();
        childObj.SalesDocument = 'X';
        System.assertEquals('X', childObj.SalesDocument);

        childObj.OutputApplication = 'X';
        System.assertEquals('X', childObj.OutputApplication);


    }

    @isTest
    static void testOUTPUT_TYPE()
    {
        ensxtx_SBO_SFCISalesDocOutput_Search.OUTPUT_TYPE childObj = new ensxtx_SBO_SFCISalesDocOutput_Search.OUTPUT_TYPE();
        System.assertEquals(ensxtx_SBO_SFCISalesDocOutput_Search.OUTPUT_TYPE.class, childObj.getType(),'getType() does not match object type.');

        childObj.registerReflectionForClass();
        ensxtx_SBO_SFCISalesDocOutput_Search.OUTPUT_TYPE_COLLECTION childObjCollection = new ensxtx_SBO_SFCISalesDocOutput_Search.OUTPUT_TYPE_COLLECTION();
        System.assertNotEquals(null, childObjCollection.getAsList());

        childObj.ConditionType = 'X';
        System.assertEquals('X', childObj.ConditionType);

        childObj.X_GetPDF = true;
        System.assertEquals(true, childObj.X_GetPDF);


    }

    @isTest
    static void testSFCISalesDocOutput_SR()
    {
        ensxtx_SBO_SFCISalesDocOutput_Search.SFCISalesDocOutput_SR sr = new ensxtx_SBO_SFCISalesDocOutput_Search.SFCISalesDocOutput_SR();

        sr.registerReflectionForClass();

        System.assertEquals(ensxtx_SBO_SFCISalesDocOutput_Search.SFCISalesDocOutput_SR.class, sr.getType(), 'getType() does not match object type.');

        System.assertNotEquals(null, sr.getResults());
    }


    @isTest
    static void testSEARCHRESULT()
    {
        ensxtx_SBO_SFCISalesDocOutput_Search.SEARCHRESULT childObj = new ensxtx_SBO_SFCISalesDocOutput_Search.SEARCHRESULT();
        System.assertEquals(ensxtx_SBO_SFCISalesDocOutput_Search.SEARCHRESULT.class, childObj.getType(),'getType() does not match object type.');

        childObj.registerReflectionForClass();
        ensxtx_SBO_SFCISalesDocOutput_Search.SEARCHRESULT_COLLECTION childObjCollection = new ensxtx_SBO_SFCISalesDocOutput_Search.SEARCHRESULT_COLLECTION();
        System.assertNotEquals(null, childObjCollection.getAsList());

        childObj.SalesDocument = 'X';
        System.assertEquals('X', childObj.SalesDocument);

        childObj.ConditionType = 'X';
        System.assertEquals('X', childObj.ConditionType);

        childObj.ConditionTypeDescription = 'X';
        System.assertEquals('X', childObj.ConditionTypeDescription);

        childObj.Language = 'X';
        System.assertEquals('X', childObj.Language);

        childObj.PDF_B64STR = 'X';
        System.assertEquals('X', childObj.PDF_B64STR);


    }

}