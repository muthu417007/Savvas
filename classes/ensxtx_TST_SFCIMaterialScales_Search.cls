/// enosiX Inc. Generated Apex Model
/// Generated On: 9/12/2023 9:30:14 PM
/// SAP Host: From REST Service On: https://computing-computing-1408-dev-ed.scratch.my.salesforce.com
/// CID: From REST Service On: https://computing-computing-1408-dev-ed.scratch.my.salesforce.com
/// Generator Version: 2.5.0.0, Target Framework ensxapp.v1.2

@isTest
private class ensxtx_TST_SFCIMaterialScales_Search
{

    public class Mockensxtx_SBO_SFCIMaterialScales_Search implements ensxsdk.EnosixFramework.SearchSBOInitMock, ensxsdk.EnosixFramework.SearchSBOSearchMock
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
        ensxsdk.EnosixFramework.setMock(ensxtx_SBO_SFCIMaterialScales_Search.class, new Mockensxtx_SBO_SFCIMaterialScales_Search());
        ensxtx_SBO_SFCIMaterialScales_Search sbo = new ensxtx_SBO_SFCIMaterialScales_Search();
        System.assertEquals(ensxtx_SBO_SFCIMaterialScales_Search.class, sbo.getType(), 'getType() does not match object type.');

        System.assertEquals(null, sbo.initialize(null));
        System.assertEquals(null, sbo.search(null));

        ensxtx_SBO_SFCIMaterialScales_Search.SFCIMaterialScales_SC sc = new ensxtx_SBO_SFCIMaterialScales_Search.SFCIMaterialScales_SC();
        System.assertEquals(ensxtx_SBO_SFCIMaterialScales_Search.SFCIMaterialScales_SC.class, sc.getType(), 'getType() does not match object type.');

        sc.registerReflectionForClass();
        System.assertEquals(null, sc.result);

        System.assertNotEquals(null, sc.SEARCHPARAMS);

    }
    
    
    @isTest
    static void testSEARCHPARAMS()
    {
        ensxtx_SBO_SFCIMaterialScales_Search.SEARCHPARAMS childObj = new ensxtx_SBO_SFCIMaterialScales_Search.SEARCHPARAMS();
        System.assertEquals(ensxtx_SBO_SFCIMaterialScales_Search.SEARCHPARAMS.class, childObj.getType(),'getType() does not match object type.');

        childObj.registerReflectionForClass();
        childObj.SalesOrganization = 'X';
        System.assertEquals('X', childObj.SalesOrganization);

        childObj.DistributionChannel = 'X';
        System.assertEquals('X', childObj.DistributionChannel);

        childObj.Division = 'X';
        System.assertEquals('X', childObj.Division);

        childObj.SalesDocumentType = 'X';
        System.assertEquals('X', childObj.SalesDocumentType);

        childObj.Material = 'X';
        System.assertEquals('X', childObj.Material);

        childObj.CustomerNumber = 'X';
        System.assertEquals('X', childObj.CustomerNumber);

        childObj.ConditionType = 'X';
        System.assertEquals('X', childObj.ConditionType);

        childObj.SalesUnit = 'X';
        System.assertEquals('X', childObj.SalesUnit);


    }

    @isTest
    static void testSFCIMaterialScales_SR()
    {
        ensxtx_SBO_SFCIMaterialScales_Search.SFCIMaterialScales_SR sr = new ensxtx_SBO_SFCIMaterialScales_Search.SFCIMaterialScales_SR();

        sr.registerReflectionForClass();

        System.assertEquals(ensxtx_SBO_SFCIMaterialScales_Search.SFCIMaterialScales_SR.class, sr.getType(), 'getType() does not match object type.');

        System.assertNotEquals(null, sr.getResults());
    }


    @isTest
    static void testSEARCHRESULT()
    {
        ensxtx_SBO_SFCIMaterialScales_Search.SEARCHRESULT childObj = new ensxtx_SBO_SFCIMaterialScales_Search.SEARCHRESULT();
        System.assertEquals(ensxtx_SBO_SFCIMaterialScales_Search.SEARCHRESULT.class, childObj.getType(),'getType() does not match object type.');

        childObj.registerReflectionForClass();
        ensxtx_SBO_SFCIMaterialScales_Search.SEARCHRESULT_COLLECTION childObjCollection = new ensxtx_SBO_SFCIMaterialScales_Search.SEARCHRESULT_COLLECTION();
        System.assertNotEquals(null, childObjCollection.getAsList());

        childObj.ConditionNumber = 'X';
        System.assertEquals('X', childObj.ConditionNumber);

        childObj.SequenceNumber = 'X';
        System.assertEquals('X', childObj.SequenceNumber);

        childObj.FromValue = 1.5;
        System.assertEquals(1.5, childObj.FromValue);

        childObj.ToValue = 1.5;
        System.assertEquals(1.5, childObj.ToValue);

        childObj.ConditionUnit = 'X';
        System.assertEquals('X', childObj.ConditionUnit);

        childObj.Rate = 1.5;
        System.assertEquals(1.5, childObj.Rate);

        childObj.FieldCurrency = 'X';
        System.assertEquals('X', childObj.FieldCurrency);


    }

}