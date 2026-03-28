/// enosiX Inc. Generated Apex Model
/// Generated On: 8/5/2020 5:36:05 PM
/// SAP Host: From REST Service On: https://platform-force-5128-dev-ed.cs95.my.salesforce.com
/// CID: From REST Service On: https://platform-force-5128-dev-ed.cs95.my.salesforce.com
/// Generator Version: 2.5.0.0, Target Framework ensxapp.v1.2

@isTest
private class ensxtx_TST_EnosixVendor_Search
{

    public class Mockensxtx_SBO_EnosixVendor_Search implements ensxsdk.EnosixFramework.SearchSBOInitMock, ensxsdk.EnosixFramework.SearchSBOSearchMock
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
        ensxsdk.EnosixFramework.setMock(ensxtx_SBO_EnosixVendor_Search.class, new Mockensxtx_SBO_EnosixVendor_Search());
        ensxtx_SBO_EnosixVendor_Search sbo = new ensxtx_SBO_EnosixVendor_Search();
        System.assertEquals(ensxtx_SBO_EnosixVendor_Search.class, sbo.getType(), 'getType() does not match object type.');

        System.assertEquals(null, sbo.initialize(null));
        System.assertEquals(null, sbo.search(null));

        ensxtx_SBO_EnosixVendor_Search.EnosixVendor_SC sc = new ensxtx_SBO_EnosixVendor_Search.EnosixVendor_SC();
        System.assertEquals(ensxtx_SBO_EnosixVendor_Search.EnosixVendor_SC.class, sc.getType(), 'getType() does not match object type.');

        sc.registerReflectionForClass();
        System.assertEquals(null, sc.result);

        System.assertNotEquals(null, sc.VENDOR);

    }
    
    
    @isTest
    static void testVENDOR()
    {
        ensxtx_SBO_EnosixVendor_Search.VENDOR childObj = new ensxtx_SBO_EnosixVendor_Search.VENDOR();
        System.assertEquals(ensxtx_SBO_EnosixVendor_Search.VENDOR.class, childObj.getType(),'getType() does not match object type.');

        childObj.registerReflectionForClass();
        childObj.FromVendor = 'X';
        System.assertEquals('X', childObj.FromVendor);

        childObj.ToVendor = 'X';
        System.assertEquals('X', childObj.ToVendor);

        childObj.Name = 'X';
        System.assertEquals('X', childObj.Name);

        childObj.Name2 = 'X';
        System.assertEquals('X', childObj.Name2);


    }

    @isTest
    static void testEnosixVendor_SR()
    {
        ensxtx_SBO_EnosixVendor_Search.EnosixVendor_SR sr = new ensxtx_SBO_EnosixVendor_Search.EnosixVendor_SR();

        sr.registerReflectionForClass();

        System.assertEquals(ensxtx_SBO_EnosixVendor_Search.EnosixVendor_SR.class, sr.getType(), 'getType() does not match object type.');

        System.assertNotEquals(null, sr.getResults());
    }


    @isTest
    static void testSEARCHRESULT()
    {
        ensxtx_SBO_EnosixVendor_Search.SEARCHRESULT childObj = new ensxtx_SBO_EnosixVendor_Search.SEARCHRESULT();
        System.assertEquals(ensxtx_SBO_EnosixVendor_Search.SEARCHRESULT.class, childObj.getType(),'getType() does not match object type.');

        childObj.registerReflectionForClass();
        ensxtx_SBO_EnosixVendor_Search.SEARCHRESULT_COLLECTION childObjCollection = new ensxtx_SBO_EnosixVendor_Search.SEARCHRESULT_COLLECTION();
        System.assertNotEquals(null, childObjCollection.getAsList());

        childObj.Vendor = 'X';
        System.assertEquals('X', childObj.Vendor);

        childObj.Name = 'X';
        System.assertEquals('X', childObj.Name);

        childObj.Name2 = 'X';
        System.assertEquals('X', childObj.Name2);

        childObj.Street = 'X';
        System.assertEquals('X', childObj.Street);

        childObj.City = 'X';
        System.assertEquals('X', childObj.City);

        childObj.PostalCode = 'X';
        System.assertEquals('X', childObj.PostalCode);

        childObj.Region = 'X';
        System.assertEquals('X', childObj.Region);

        childObj.Country = 'X';
        System.assertEquals('X', childObj.Country);

        childObj.POBox = 'X';
        System.assertEquals('X', childObj.POBox);

        childObj.TelephoneNumber = 'X';
        System.assertEquals('X', childObj.TelephoneNumber);

        childObj.VendorAccountGroup = 'X';
        System.assertEquals('X', childObj.VendorAccountGroup);

        childObj.Language = 'X';
        System.assertEquals('X', childObj.Language);

        childObj.EmailAddress = 'X';
        System.assertEquals('X', childObj.EmailAddress);


    }

}