/// enosiX Inc. Generated Apex Model
/// Generated On: 4/19/2024 4:25:22 PM
/// SAP Host: From REST Service On: https://savvas--dev3.sandbox.my.salesforce.com
/// CID: From REST Service On: https://savvas--dev3.sandbox.my.salesforce.com
/// Generator Version: 2.5.0.0, Target Framework ensxapp.v1.2

@isTest
private class ensxtx_TST_SFCISalesDocFlow_Search
{

    public class Mockensxtx_SBO_SFCISalesDocFlow_Search implements ensxsdk.EnosixFramework.SearchSBOInitMock, ensxsdk.EnosixFramework.SearchSBOSearchMock
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
        ensxsdk.EnosixFramework.setMock(ensxtx_SBO_SFCISalesDocFlow_Search.class, new Mockensxtx_SBO_SFCISalesDocFlow_Search());
        ensxtx_SBO_SFCISalesDocFlow_Search sbo = new ensxtx_SBO_SFCISalesDocFlow_Search();
        System.assertEquals(ensxtx_SBO_SFCISalesDocFlow_Search.class, sbo.getType(), 'getType() does not match object type.');

        System.assertEquals(null, sbo.initialize(null));
        System.assertEquals(null, sbo.search(null));

        ensxtx_SBO_SFCISalesDocFlow_Search.SFCISalesDocFlow_SC sc = new ensxtx_SBO_SFCISalesDocFlow_Search.SFCISalesDocFlow_SC();
        System.assertEquals(ensxtx_SBO_SFCISalesDocFlow_Search.SFCISalesDocFlow_SC.class, sc.getType(), 'getType() does not match object type.');

        sc.registerReflectionForClass();
        System.assertEquals(null, sc.result);

        System.assertNotEquals(null, sc.SEARCHPARAMS);

    }
    
    
    @isTest
    static void testSEARCHPARAMS()
    {
        ensxtx_SBO_SFCISalesDocFlow_Search.SEARCHPARAMS childObj = new ensxtx_SBO_SFCISalesDocFlow_Search.SEARCHPARAMS();
        System.assertEquals(ensxtx_SBO_SFCISalesDocFlow_Search.SEARCHPARAMS.class, childObj.getType(),'getType() does not match object type.');

        childObj.registerReflectionForClass();
        childObj.SalesDocument = 'X';
        System.assertEquals('X', childObj.SalesDocument);

        childObj.ItemNumber = 'X';
        System.assertEquals('X', childObj.ItemNumber);


    }

    @isTest
    static void testSFCISalesDocFlow_SR()
    {
        ensxtx_SBO_SFCISalesDocFlow_Search.SFCISalesDocFlow_SR sr = new ensxtx_SBO_SFCISalesDocFlow_Search.SFCISalesDocFlow_SR();

        sr.registerReflectionForClass();

        System.assertEquals(ensxtx_SBO_SFCISalesDocFlow_Search.SFCISalesDocFlow_SR.class, sr.getType(), 'getType() does not match object type.');

        System.assertNotEquals(null, sr.getResults());
    }


    @isTest
    static void testSEARCHRESULT()
    {
        ensxtx_SBO_SFCISalesDocFlow_Search.SEARCHRESULT childObj = new ensxtx_SBO_SFCISalesDocFlow_Search.SEARCHRESULT();
        System.assertEquals(ensxtx_SBO_SFCISalesDocFlow_Search.SEARCHRESULT.class, childObj.getType(),'getType() does not match object type.');

        childObj.registerReflectionForClass();
        ensxtx_SBO_SFCISalesDocFlow_Search.SEARCHRESULT_COLLECTION childObjCollection = new ensxtx_SBO_SFCISalesDocFlow_Search.SEARCHRESULT_COLLECTION();
        System.assertNotEquals(null, childObjCollection.getAsList());

        childObj.SalesDocument = 'X';
        System.assertEquals('X', childObj.SalesDocument);

        childObj.ItemNumber = 'X';
        System.assertEquals('X', childObj.ItemNumber);

        childObj.DocumentCategory = 'X';
        System.assertEquals('X', childObj.DocumentCategory);

        childObj.DocumentCategoryText = 'X';
        System.assertEquals('X', childObj.DocumentCategoryText);

        childObj.OriginatingDocument = 'X';
        System.assertEquals('X', childObj.OriginatingDocument);

        childObj.OriginatingItem = 'X';
        System.assertEquals('X', childObj.OriginatingItem);

        childObj.HierarchyLevel = 0;
        System.assertEquals(0, childObj.HierarchyLevel);

        childObj.CustomerNumber = 'X';
        System.assertEquals('X', childObj.CustomerNumber);

        childObj.CreateDate = Date.valueOf('2020-12-31');
        System.assertEquals(Date.valueOf('2020-12-31'), childObj.CreateDate);

        childObj.CreatedBy = 'X';
        System.assertEquals('X', childObj.CreatedBy);

        childObj.DateChanged = Date.valueOf('2020-12-31');
        System.assertEquals(Date.valueOf('2020-12-31'), childObj.DateChanged);

        childObj.ChangedBy = 'X';
        System.assertEquals('X', childObj.ChangedBy);

        childObj.DocumentStatus = 'X';
        System.assertEquals('X', childObj.DocumentStatus);


    }

}