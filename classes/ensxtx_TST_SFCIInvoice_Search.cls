/// enosiX Inc. Generated Apex Model
/// Generated On: 5/16/2024 8:41:41 PM
/// SAP Host: From REST Service On: https://savvas--dev3.sandbox.my.salesforce.com
/// CID: From REST Service On: https://savvas--dev3.sandbox.my.salesforce.com
/// Generator Version: 2.5.0.0, Target Framework ensxapp.v1.2

@isTest
private class ensxtx_TST_SFCIInvoice_Search
{

    public class Mockensxtx_SBO_SFCIInvoice_Search implements ensxsdk.EnosixFramework.SearchSBOInitMock, ensxsdk.EnosixFramework.SearchSBOSearchMock
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
        ensxsdk.EnosixFramework.setMock(ensxtx_SBO_SFCIInvoice_Search.class, new Mockensxtx_SBO_SFCIInvoice_Search());
        ensxtx_SBO_SFCIInvoice_Search sbo = new ensxtx_SBO_SFCIInvoice_Search();
        System.assertEquals(ensxtx_SBO_SFCIInvoice_Search.class, sbo.getType(), 'getType() does not match object type.');

        System.assertEquals(null, sbo.initialize(null));
        System.assertEquals(null, sbo.search(null));

        ensxtx_SBO_SFCIInvoice_Search.SFCIInvoice_SC sc = new ensxtx_SBO_SFCIInvoice_Search.SFCIInvoice_SC();
        System.assertEquals(ensxtx_SBO_SFCIInvoice_Search.SFCIInvoice_SC.class, sc.getType(), 'getType() does not match object type.');

        sc.registerReflectionForClass();
        System.assertEquals(null, sc.result);

        System.assertNotEquals(null, sc.SEARCHPARAMS);
        System.assertNotEquals(null, sc.BILLINGTYPE);
        System.assertNotEquals(null, sc.CUSTOM);

    }
    
    
    @isTest
    static void testSEARCHPARAMS()
    {
        ensxtx_SBO_SFCIInvoice_Search.SEARCHPARAMS childObj = new ensxtx_SBO_SFCIInvoice_Search.SEARCHPARAMS();
        System.assertEquals(ensxtx_SBO_SFCIInvoice_Search.SEARCHPARAMS.class, childObj.getType(),'getType() does not match object type.');

        childObj.registerReflectionForClass();
        childObj.FromSalesDocumentNumber = 'X';
        System.assertEquals('X', childObj.FromSalesDocumentNumber);

        childObj.ToSalesDocumentNumber = 'X';
        System.assertEquals('X', childObj.ToSalesDocumentNumber);

        childObj.SalesOrganization = 'X';
        System.assertEquals('X', childObj.SalesOrganization);

        childObj.Payer = 'X';
        System.assertEquals('X', childObj.Payer);

        childObj.SoldToParty = 'X';
        System.assertEquals('X', childObj.SoldToParty);

        childObj.BillingDateFrom = Date.valueOf('2020-12-31');
        System.assertEquals(Date.valueOf('2020-12-31'), childObj.BillingDateFrom);

        childObj.BillingDateTo = Date.valueOf('2020-12-31');
        System.assertEquals(Date.valueOf('2020-12-31'), childObj.BillingDateTo);

        childObj.FromCreateDate = Date.valueOf('2020-12-31');
        System.assertEquals(Date.valueOf('2020-12-31'), childObj.FromCreateDate);

        childObj.ToCreateDate = Date.valueOf('2020-12-31');
        System.assertEquals(Date.valueOf('2020-12-31'), childObj.ToCreateDate);

        childObj.CreatedBy = 'X';
        System.assertEquals('X', childObj.CreatedBy);


    }

    @isTest
    static void testBILLINGTYPE()
    {
        ensxtx_SBO_SFCIInvoice_Search.BILLINGTYPE childObj = new ensxtx_SBO_SFCIInvoice_Search.BILLINGTYPE();
        System.assertEquals(ensxtx_SBO_SFCIInvoice_Search.BILLINGTYPE.class, childObj.getType(),'getType() does not match object type.');

        childObj.registerReflectionForClass();
        ensxtx_SBO_SFCIInvoice_Search.BILLINGTYPE_COLLECTION childObjCollection = new ensxtx_SBO_SFCIInvoice_Search.BILLINGTYPE_COLLECTION();
        System.assertNotEquals(null, childObjCollection.getAsList());

        childObj.BillingType = 'X';
        System.assertEquals('X', childObj.BillingType);


    }

    @isTest
    static void testCUSTOM()
    {
        ensxtx_SBO_SFCIInvoice_Search.CUSTOM childObj = new ensxtx_SBO_SFCIInvoice_Search.CUSTOM();
        System.assertEquals(ensxtx_SBO_SFCIInvoice_Search.CUSTOM.class, childObj.getType(),'getType() does not match object type.');

        childObj.registerReflectionForClass();
        ensxtx_SBO_SFCIInvoice_Search.CUSTOM_COLLECTION childObjCollection = new ensxtx_SBO_SFCIInvoice_Search.CUSTOM_COLLECTION();
        System.assertNotEquals(null, childObjCollection.getAsList());

        childObj.FIELD = 'X';
        System.assertEquals('X', childObj.FIELD);

        childObj.VALUE = 'X';
        System.assertEquals('X', childObj.VALUE);


    }

    @isTest
    static void testSFCIInvoice_SR()
    {
        ensxtx_SBO_SFCIInvoice_Search.SFCIInvoice_SR sr = new ensxtx_SBO_SFCIInvoice_Search.SFCIInvoice_SR();

        sr.registerReflectionForClass();

        System.assertEquals(ensxtx_SBO_SFCIInvoice_Search.SFCIInvoice_SR.class, sr.getType(), 'getType() does not match object type.');

        System.assertNotEquals(null, sr.getResults());
    }


    @isTest
    static void testSEARCHRESULT()
    {
        ensxtx_SBO_SFCIInvoice_Search.SEARCHRESULT childObj = new ensxtx_SBO_SFCIInvoice_Search.SEARCHRESULT();
        System.assertEquals(ensxtx_SBO_SFCIInvoice_Search.SEARCHRESULT.class, childObj.getType(),'getType() does not match object type.');

        childObj.registerReflectionForClass();
        ensxtx_SBO_SFCIInvoice_Search.SEARCHRESULT_COLLECTION childObjCollection = new ensxtx_SBO_SFCIInvoice_Search.SEARCHRESULT_COLLECTION();
        System.assertNotEquals(null, childObjCollection.getAsList());

        childObj.BillingDocument = 'X';
        System.assertEquals('X', childObj.BillingDocument);

        childObj.BillingType = 'X';
        System.assertEquals('X', childObj.BillingType);

        childObj.BillingTypeDescription = 'X';
        System.assertEquals('X', childObj.BillingTypeDescription);

        childObj.CompanyCode = 'X';
        System.assertEquals('X', childObj.CompanyCode);

        childObj.CompanyCodeName = 'X';
        System.assertEquals('X', childObj.CompanyCodeName);

        childObj.SalesOrganization = 'X';
        System.assertEquals('X', childObj.SalesOrganization);

        childObj.SalesOrgDescription = 'X';
        System.assertEquals('X', childObj.SalesOrgDescription);

        childObj.BillingDate = Date.valueOf('2020-12-31');
        System.assertEquals(Date.valueOf('2020-12-31'), childObj.BillingDate);

        childObj.ShipDate = Date.valueOf('2020-12-31');
        System.assertEquals(Date.valueOf('2020-12-31'), childObj.ShipDate);

        childObj.SalesOrderNumber = 'X';
        System.assertEquals('X', childObj.SalesOrderNumber);

        childObj.Payer = 'X';
        System.assertEquals('X', childObj.Payer);

        childObj.PayerName = 'X';
        System.assertEquals('X', childObj.PayerName);

        childObj.SoldToParty = 'X';
        System.assertEquals('X', childObj.SoldToParty);

        childObj.SoldToName = 'X';
        System.assertEquals('X', childObj.SoldToName);

        childObj.ShipToParty = 'X';
        System.assertEquals('X', childObj.ShipToParty);

        childObj.ShipToName = 'X';
        System.assertEquals('X', childObj.ShipToName);

        childObj.TrackingNumber = 'X';
        System.assertEquals('X', childObj.TrackingNumber);

        childObj.NetOrderValue = 1.5;
        System.assertEquals(1.5, childObj.NetOrderValue);

        childObj.TaxAmount = 1.5;
        System.assertEquals(1.5, childObj.TaxAmount);

        childObj.SalesDocumentCurrency = 'X';
        System.assertEquals('X', childObj.SalesDocumentCurrency);

        childObj.CreatedBy = 'X';
        System.assertEquals('X', childObj.CreatedBy);

        childObj.CreateDate = Date.valueOf('2020-12-31');
        System.assertEquals(Date.valueOf('2020-12-31'), childObj.CreateDate);

        childObj.BillingStatus = 'X';
        System.assertEquals('X', childObj.BillingStatus);

        childObj.BillingStatusDescription = 'X';
        System.assertEquals('X', childObj.BillingStatusDescription);

        childObj.GrossAmount = 1.5;
        System.assertEquals(1.5, childObj.GrossAmount);

        childObj.CUSTOM01 = 'X';
        System.assertEquals('X', childObj.CUSTOM01);

        childObj.CUSTOM02 = 'X';
        System.assertEquals('X', childObj.CUSTOM02);

        childObj.CUSTOM03 = 'X';
        System.assertEquals('X', childObj.CUSTOM03);

        childObj.CUSTOM04 = 'X';
        System.assertEquals('X', childObj.CUSTOM04);

        childObj.CUSTOM05 = 'X';
        System.assertEquals('X', childObj.CUSTOM05);

        childObj.CUSTOM06 = 'X';
        System.assertEquals('X', childObj.CUSTOM06);

        childObj.CUSTOM07 = 'X';
        System.assertEquals('X', childObj.CUSTOM07);

        childObj.CUSTOM08 = 'X';
        System.assertEquals('X', childObj.CUSTOM08);

        childObj.CUSTOM09 = 'X';
        System.assertEquals('X', childObj.CUSTOM09);

        childObj.CUSTOM10 = 'X';
        System.assertEquals('X', childObj.CUSTOM10);


    }

}