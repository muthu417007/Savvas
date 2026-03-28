/// enosiX Inc. Generated Apex Model
/// Generated On: 5/17/2022 9:38:35 AM
/// SAP Host: From REST Service On: https://ability-customization-5216-dev-ed.cs90.my.salesforce.com
/// CID: From REST Service On: https://ability-customization-5216-dev-ed.cs90.my.salesforce.com
/// Generator Version: 2.5.0.0, Target Framework ensxapp.v1.2

@isTest
private class ensxtx_TST_EnosixBOConfigValue_Search
{

    public class Mockensxtx_SBO_EnosixBOConfigValue_Search implements ensxsdk.EnosixFramework.SearchSBOInitMock, ensxsdk.EnosixFramework.SearchSBOSearchMock
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
        ensxsdk.EnosixFramework.setMock(ensxtx_SBO_EnosixBOConfigValue_Search.class, new Mockensxtx_SBO_EnosixBOConfigValue_Search());
        ensxtx_SBO_EnosixBOConfigValue_Search sbo = new ensxtx_SBO_EnosixBOConfigValue_Search();
        System.assertEquals(ensxtx_SBO_EnosixBOConfigValue_Search.class, sbo.getType(), 'getType() does not match object type.');

        System.assertEquals(null, sbo.initialize(null));
        System.assertEquals(null, sbo.search(null));

        ensxtx_SBO_EnosixBOConfigValue_Search.EnosixBOConfigValue_SC sc = new ensxtx_SBO_EnosixBOConfigValue_Search.EnosixBOConfigValue_SC();
        System.assertEquals(ensxtx_SBO_EnosixBOConfigValue_Search.EnosixBOConfigValue_SC.class, sc.getType(), 'getType() does not match object type.');

        sc.registerReflectionForClass();
        System.assertEquals(null, sc.result);

        System.assertNotEquals(null, sc.SEARCHPARAMS);

    }
    
    
    @isTest
    static void testSEARCHPARAMS()
    {
        ensxtx_SBO_EnosixBOConfigValue_Search.SEARCHPARAMS childObj = new ensxtx_SBO_EnosixBOConfigValue_Search.SEARCHPARAMS();
        System.assertEquals(ensxtx_SBO_EnosixBOConfigValue_Search.SEARCHPARAMS.class, childObj.getType(),'getType() does not match object type.');

        childObj.registerReflectionForClass();
        childObj.CustomizingID = 'X';
        System.assertEquals('X', childObj.CustomizingID);

        childObj.BusinessObject = 'X';
        System.assertEquals('X', childObj.BusinessObject);


    }

    @isTest
    static void testEnosixBOConfigValue_SR()
    {
        ensxtx_SBO_EnosixBOConfigValue_Search.EnosixBOConfigValue_SR sr = new ensxtx_SBO_EnosixBOConfigValue_Search.EnosixBOConfigValue_SR();

        sr.registerReflectionForClass();

        System.assertEquals(ensxtx_SBO_EnosixBOConfigValue_Search.EnosixBOConfigValue_SR.class, sr.getType(), 'getType() does not match object type.');

        System.assertNotEquals(null, sr.getResults());
    }


    @isTest
    static void testSEARCHRESULT()
    {
        ensxtx_SBO_EnosixBOConfigValue_Search.SEARCHRESULT childObj = new ensxtx_SBO_EnosixBOConfigValue_Search.SEARCHRESULT();
        System.assertEquals(ensxtx_SBO_EnosixBOConfigValue_Search.SEARCHRESULT.class, childObj.getType(),'getType() does not match object type.');

        childObj.registerReflectionForClass();
        ensxtx_SBO_EnosixBOConfigValue_Search.SEARCHRESULT_COLLECTION childObjCollection = new ensxtx_SBO_EnosixBOConfigValue_Search.SEARCHRESULT_COLLECTION();
        System.assertNotEquals(null, childObjCollection.getAsList());

        childObj.CustomizingID = 'X';
        System.assertEquals('X', childObj.CustomizingID);

        childObj.BusinessObject = 'X';
        System.assertEquals('X', childObj.BusinessObject);

        childObj.BusinessObjectTransaction = 'X';
        System.assertEquals('X', childObj.BusinessObjectTransaction);

        childObj.VariableType = 'X';
        System.assertEquals('X', childObj.VariableType);

        childObj.VariableName = 'X';
        System.assertEquals('X', childObj.VariableName);

        childObj.VariableCount = 'X';
        System.assertEquals('X', childObj.VariableCount);

        childObj.Sign = 'X';
        System.assertEquals('X', childObj.Sign);

        childObj.Option = 'X';
        System.assertEquals('X', childObj.Option);

        childObj.Low = 'X';
        System.assertEquals('X', childObj.Low);

        childObj.High = 'X';
        System.assertEquals('X', childObj.High);


    }

}