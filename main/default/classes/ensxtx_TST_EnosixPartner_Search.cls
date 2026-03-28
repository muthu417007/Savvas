/// enosiX Inc. Generated Apex Model
/// Generated On: 12/14/2020 12:00:36 PM
/// SAP Host: From REST Service On: https://business-customization-9542-dev-ed.cs97.my.salesforce.com
/// CID: From REST Service On: https://business-customization-9542-dev-ed.cs97.my.salesforce.com
/// Generator Version: 2.5.0.0, Target Framework ensxapp.v1.2

@isTest
private class ensxtx_TST_EnosixPartner_Search
{

    public class Mockensxtx_SBO_EnosixPartner_Search implements ensxsdk.EnosixFramework.SearchSBOInitMock, ensxsdk.EnosixFramework.SearchSBOSearchMock
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
        ensxsdk.EnosixFramework.setMock(ensxtx_SBO_EnosixPartner_Search.class, new Mockensxtx_SBO_EnosixPartner_Search());
        ensxtx_SBO_EnosixPartner_Search sbo = new ensxtx_SBO_EnosixPartner_Search();
        System.assertEquals(ensxtx_SBO_EnosixPartner_Search.class, sbo.getType(), 'getType() does not match object type.');

        System.assertEquals(null, sbo.initialize(null));
        System.assertEquals(null, sbo.search(null));

        ensxtx_SBO_EnosixPartner_Search.EnosixPartner_SC sc = new ensxtx_SBO_EnosixPartner_Search.EnosixPartner_SC();
        System.assertEquals(ensxtx_SBO_EnosixPartner_Search.EnosixPartner_SC.class, sc.getType(), 'getType() does not match object type.');

        sc.registerReflectionForClass();
        System.assertEquals(null, sc.result);

        System.assertNotEquals(null, sc.SEARCHPARAMS);

    }
    
    
    @isTest
    static void testSEARCHPARAMS()
    {
        ensxtx_SBO_EnosixPartner_Search.SEARCHPARAMS childObj = new ensxtx_SBO_EnosixPartner_Search.SEARCHPARAMS();
        System.assertEquals(ensxtx_SBO_EnosixPartner_Search.SEARCHPARAMS.class, childObj.getType(),'getType() does not match object type.');

        childObj.registerReflectionForClass();
        childObj.CustomerNumber = 'X';
        System.assertEquals('X', childObj.CustomerNumber);

        childObj.SalesOrganization = 'X';
        System.assertEquals('X', childObj.SalesOrganization);

        childObj.DistributionChannel = 'X';
        System.assertEquals('X', childObj.DistributionChannel);

        childObj.Division = 'X';
        System.assertEquals('X', childObj.Division);

        childObj.PartnerFunction = 'X';
        System.assertEquals('X', childObj.PartnerFunction);

        childObj.PartnerFunctionInternal = 'X';
        System.assertEquals('X', childObj.PartnerFunctionInternal);


    }

    @isTest
    static void testEnosixPartner_SR()
    {
        ensxtx_SBO_EnosixPartner_Search.EnosixPartner_SR sr = new ensxtx_SBO_EnosixPartner_Search.EnosixPartner_SR();

        sr.registerReflectionForClass();

        System.assertEquals(ensxtx_SBO_EnosixPartner_Search.EnosixPartner_SR.class, sr.getType(), 'getType() does not match object type.');

        System.assertNotEquals(null, sr.getResults());
    }


    @isTest
    static void testSEARCHRESULT()
    {
        ensxtx_SBO_EnosixPartner_Search.SEARCHRESULT childObj = new ensxtx_SBO_EnosixPartner_Search.SEARCHRESULT();
        System.assertEquals(ensxtx_SBO_EnosixPartner_Search.SEARCHRESULT.class, childObj.getType(),'getType() does not match object type.');

        childObj.registerReflectionForClass();
        ensxtx_SBO_EnosixPartner_Search.SEARCHRESULT_COLLECTION childObjCollection = new ensxtx_SBO_EnosixPartner_Search.SEARCHRESULT_COLLECTION();
        System.assertNotEquals(null, childObjCollection.getAsList());

        childObj.SalesOrganization = 'X';
        System.assertEquals('X', childObj.SalesOrganization);

        childObj.SalesOrganizationName = 'X';
        System.assertEquals('X', childObj.SalesOrganizationName);

        childObj.DistributionChannel = 'X';
        System.assertEquals('X', childObj.DistributionChannel);

        childObj.DistributionChannelName = 'X';
        System.assertEquals('X', childObj.DistributionChannelName);

        childObj.Division = 'X';
        System.assertEquals('X', childObj.Division);

        childObj.DivisionName = 'X';
        System.assertEquals('X', childObj.DivisionName);

        childObj.PartnerFunction = 'X';
        System.assertEquals('X', childObj.PartnerFunction);

        childObj.PartnerFunctionInternal = 'X';
        System.assertEquals('X', childObj.PartnerFunctionInternal);

        childObj.PartnerFunctionName = 'X';
        System.assertEquals('X', childObj.PartnerFunctionName);

        childObj.PartnerNumber = 'X';
        System.assertEquals('X', childObj.PartnerNumber);

        childObj.PartnerName = 'X';
        System.assertEquals('X', childObj.PartnerName);

        childObj.VendorNumber = 'X';
        System.assertEquals('X', childObj.VendorNumber);

        childObj.VendorName = 'X';
        System.assertEquals('X', childObj.VendorName);

        childObj.ContactNumber = 'X';
        System.assertEquals('X', childObj.ContactNumber);

        childObj.ContactFirstName = 'X';
        System.assertEquals('X', childObj.ContactFirstName);

        childObj.ContactLastName = 'X';
        System.assertEquals('X', childObj.ContactLastName);

        childObj.PersonnelNumber = 'X';
        System.assertEquals('X', childObj.PersonnelNumber);

        childObj.PersonnelFirstName = 'X';
        System.assertEquals('X', childObj.PersonnelFirstName);

        childObj.PersonnelLastName = 'X';
        System.assertEquals('X', childObj.PersonnelLastName);

        childObj.HouseNumber = 'X';
        System.assertEquals('X', childObj.HouseNumber);

        childObj.Street = 'X';
        System.assertEquals('X', childObj.Street);

        childObj.City = 'X';
        System.assertEquals('X', childObj.City);

        childObj.District = 'X';
        System.assertEquals('X', childObj.District);

        childObj.PostalCode = 'X';
        System.assertEquals('X', childObj.PostalCode);

        childObj.Region = 'X';
        System.assertEquals('X', childObj.Region);

        childObj.Country = 'X';
        System.assertEquals('X', childObj.Country);

        childObj.DefaultPartner = true;
        System.assertEquals(true, childObj.DefaultPartner);


    }

}