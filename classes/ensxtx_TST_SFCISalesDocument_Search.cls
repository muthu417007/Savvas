/// enosiX Inc. Generated Apex Model
/// Generated On: 5/16/2024 8:03:18 PM
/// SAP Host: From REST Service On: https://savvas--dev3.sandbox.my.salesforce.com
/// CID: From REST Service On: https://savvas--dev3.sandbox.my.salesforce.com
/// Generator Version: 2.5.0.0, Target Framework ensxapp.v1.2

@isTest
private class ensxtx_TST_SFCISalesDocument_Search
{

    public class Mockensxtx_SBO_SFCISalesDocument_Search implements ensxsdk.EnosixFramework.SearchSBOInitMock, ensxsdk.EnosixFramework.SearchSBOSearchMock
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
        ensxsdk.EnosixFramework.setMock(ensxtx_SBO_SFCISalesDocument_Search.class, new Mockensxtx_SBO_SFCISalesDocument_Search());
        ensxtx_SBO_SFCISalesDocument_Search sbo = new ensxtx_SBO_SFCISalesDocument_Search();
        System.assertEquals(ensxtx_SBO_SFCISalesDocument_Search.class, sbo.getType(), 'getType() does not match object type.');

        System.assertEquals(null, sbo.initialize(null));
        System.assertEquals(null, sbo.search(null));

        ensxtx_SBO_SFCISalesDocument_Search.SFCISalesDocument_SC sc = new ensxtx_SBO_SFCISalesDocument_Search.SFCISalesDocument_SC();
        System.assertEquals(ensxtx_SBO_SFCISalesDocument_Search.SFCISalesDocument_SC.class, sc.getType(), 'getType() does not match object type.');

        sc.registerReflectionForClass();
        System.assertEquals(null, sc.result);

        System.assertNotEquals(null, sc.SEARCHPARAMS);
        System.assertNotEquals(null, sc.SALESDOCTYPE);
        System.assertNotEquals(null, sc.CHANGED_DATE);
        System.assertNotEquals(null, sc.CUSTOM);

    }
    
    
    @isTest
    static void testSEARCHPARAMS()
    {
        ensxtx_SBO_SFCISalesDocument_Search.SEARCHPARAMS childObj = new ensxtx_SBO_SFCISalesDocument_Search.SEARCHPARAMS();
        System.assertEquals(ensxtx_SBO_SFCISalesDocument_Search.SEARCHPARAMS.class, childObj.getType(),'getType() does not match object type.');

        childObj.registerReflectionForClass();
        childObj.FromSalesDocumentNumber = 'X';
        System.assertEquals('X', childObj.FromSalesDocumentNumber);

        childObj.ToSalesDocumentNumber = 'X';
        System.assertEquals('X', childObj.ToSalesDocumentNumber);

        childObj.SoldToParty = 'X';
        System.assertEquals('X', childObj.SoldToParty);

        childObj.ShipToParty = 'X';
        System.assertEquals('X', childObj.ShipToParty);

        childObj.CustomerPONumber = 'X';
        System.assertEquals('X', childObj.CustomerPONumber);

        childObj.Material = 'X';
        System.assertEquals('X', childObj.Material);

        childObj.TransactionGroup = 'X';
        System.assertEquals('X', childObj.TransactionGroup);

        childObj.FromCreateDate = Date.valueOf('2020-12-31');
        System.assertEquals(Date.valueOf('2020-12-31'), childObj.FromCreateDate);

        childObj.ToCreateDate = Date.valueOf('2020-12-31');
        System.assertEquals(Date.valueOf('2020-12-31'), childObj.ToCreateDate);

        childObj.OpenOnly = true;
        System.assertEquals(true, childObj.OpenOnly);

        childObj.CompletedOnly = true;
        System.assertEquals(true, childObj.CompletedOnly);

        childObj.Username = 'X';
        System.assertEquals('X', childObj.Username);

        childObj.SalesDocumentVersionNumber = 'X';
        System.assertEquals('X', childObj.SalesDocumentVersionNumber);

        childObj.YourReference = 'X';
        System.assertEquals('X', childObj.YourReference);

        childObj.ShipToPurchaseOrderNumber = 'X';
        System.assertEquals('X', childObj.ShipToPurchaseOrderNumber);

        childObj.X_DeliveryBlock = true;
        System.assertEquals(true, childObj.X_DeliveryBlock);

        childObj.X_BillingBlock = true;
        System.assertEquals(true, childObj.X_BillingBlock);

        childObj.X_CreditBlock = true;
        System.assertEquals(true, childObj.X_CreditBlock);


    }

    @isTest
    static void testSALESDOCTYPE()
    {
        ensxtx_SBO_SFCISalesDocument_Search.SALESDOCTYPE childObj = new ensxtx_SBO_SFCISalesDocument_Search.SALESDOCTYPE();
        System.assertEquals(ensxtx_SBO_SFCISalesDocument_Search.SALESDOCTYPE.class, childObj.getType(),'getType() does not match object type.');

        childObj.registerReflectionForClass();
        ensxtx_SBO_SFCISalesDocument_Search.SALESDOCTYPE_COLLECTION childObjCollection = new ensxtx_SBO_SFCISalesDocument_Search.SALESDOCTYPE_COLLECTION();
        System.assertNotEquals(null, childObjCollection.getAsList());

        childObj.SalesDocumentType = 'X';
        System.assertEquals('X', childObj.SalesDocumentType);


    }

    @isTest
    static void testCHANGED_DATE()
    {
        ensxtx_SBO_SFCISalesDocument_Search.CHANGED_DATE childObj = new ensxtx_SBO_SFCISalesDocument_Search.CHANGED_DATE();
        System.assertEquals(ensxtx_SBO_SFCISalesDocument_Search.CHANGED_DATE.class, childObj.getType(),'getType() does not match object type.');

        childObj.registerReflectionForClass();
        childObj.ChangedDateBegin = Date.valueOf('2020-12-31');
        System.assertEquals(Date.valueOf('2020-12-31'), childObj.ChangedDateBegin);

        childObj.ChangedDateEnd = Date.valueOf('2020-12-31');
        System.assertEquals(Date.valueOf('2020-12-31'), childObj.ChangedDateEnd);


    }

    @isTest
    static void testCUSTOM()
    {
        ensxtx_SBO_SFCISalesDocument_Search.CUSTOM childObj = new ensxtx_SBO_SFCISalesDocument_Search.CUSTOM();
        System.assertEquals(ensxtx_SBO_SFCISalesDocument_Search.CUSTOM.class, childObj.getType(),'getType() does not match object type.');

        childObj.registerReflectionForClass();
        ensxtx_SBO_SFCISalesDocument_Search.CUSTOM_COLLECTION childObjCollection = new ensxtx_SBO_SFCISalesDocument_Search.CUSTOM_COLLECTION();
        System.assertNotEquals(null, childObjCollection.getAsList());

        childObj.FIELD = 'X';
        System.assertEquals('X', childObj.FIELD);

        childObj.VALUE = 'X';
        System.assertEquals('X', childObj.VALUE);


    }

    @isTest
    static void testSFCISalesDocument_SR()
    {
        ensxtx_SBO_SFCISalesDocument_Search.SFCISalesDocument_SR sr = new ensxtx_SBO_SFCISalesDocument_Search.SFCISalesDocument_SR();

        sr.registerReflectionForClass();

        System.assertEquals(ensxtx_SBO_SFCISalesDocument_Search.SFCISalesDocument_SR.class, sr.getType(), 'getType() does not match object type.');

        System.assertNotEquals(null, sr.getResults());
    }


    @isTest
    static void testSEARCHRESULT()
    {
        ensxtx_SBO_SFCISalesDocument_Search.SEARCHRESULT childObj = new ensxtx_SBO_SFCISalesDocument_Search.SEARCHRESULT();
        System.assertEquals(ensxtx_SBO_SFCISalesDocument_Search.SEARCHRESULT.class, childObj.getType(),'getType() does not match object type.');

        childObj.registerReflectionForClass();
        ensxtx_SBO_SFCISalesDocument_Search.SEARCHRESULT_COLLECTION childObjCollection = new ensxtx_SBO_SFCISalesDocument_Search.SEARCHRESULT_COLLECTION();
        System.assertNotEquals(null, childObjCollection.getAsList());

        childObj.SalesDocument = 'X';
        System.assertEquals('X', childObj.SalesDocument);

        childObj.CustomerPONumber = 'X';
        System.assertEquals('X', childObj.CustomerPONumber);

        childObj.CreateDate = Date.valueOf('2020-12-31');
        System.assertEquals(Date.valueOf('2020-12-31'), childObj.CreateDate);

        childObj.SalesDocumentType = 'X';
        System.assertEquals('X', childObj.SalesDocumentType);

        childObj.SalesDocumentTypeDescription = 'X';
        System.assertEquals('X', childObj.SalesDocumentTypeDescription);

        childObj.SoldToParty = 'X';
        System.assertEquals('X', childObj.SoldToParty);

        childObj.SoldToName = 'X';
        System.assertEquals('X', childObj.SoldToName);

        childObj.SoldToCity = 'X';
        System.assertEquals('X', childObj.SoldToCity);

        childObj.SoldToRegion = 'X';
        System.assertEquals('X', childObj.SoldToRegion);

        childObj.SoldToRegionDescription = 'X';
        System.assertEquals('X', childObj.SoldToRegionDescription);

        childObj.SoldToCountry = 'X';
        System.assertEquals('X', childObj.SoldToCountry);

        childObj.SoldToCountryDescription = 'X';
        System.assertEquals('X', childObj.SoldToCountryDescription);

        childObj.ShipToParty = 'X';
        System.assertEquals('X', childObj.ShipToParty);

        childObj.ShipToName = 'X';
        System.assertEquals('X', childObj.ShipToName);

        childObj.ShipToCity = 'X';
        System.assertEquals('X', childObj.ShipToCity);

        childObj.ShipToRegion = 'X';
        System.assertEquals('X', childObj.ShipToRegion);

        childObj.ShipToRegionDescription = 'X';
        System.assertEquals('X', childObj.ShipToRegionDescription);

        childObj.ShipToCountry = 'X';
        System.assertEquals('X', childObj.ShipToCountry);

        childObj.ShipToCountryDescription = 'X';
        System.assertEquals('X', childObj.ShipToCountryDescription);

        childObj.NetValueInDocumentCurrency = 1.5;
        System.assertEquals(1.5, childObj.NetValueInDocumentCurrency);

        childObj.TaxAmountInDocumentCurrency = 1.5;
        System.assertEquals(1.5, childObj.TaxAmountInDocumentCurrency);

        childObj.SDDocumentCurrency = 'X';
        System.assertEquals('X', childObj.SDDocumentCurrency);

        childObj.OrderStatus = 'X';
        System.assertEquals('X', childObj.OrderStatus);

        childObj.SalesDocumentVersionNumber = 'X';
        System.assertEquals('X', childObj.SalesDocumentVersionNumber);

        childObj.YourReference = 'X';
        System.assertEquals('X', childObj.YourReference);

        childObj.ShipToPurchaseOrderNumber = 'X';
        System.assertEquals('X', childObj.ShipToPurchaseOrderNumber);

        childObj.TransactionGroup = 'X';
        System.assertEquals('X', childObj.TransactionGroup);

        childObj.DeliveryBlock = 'X';
        System.assertEquals('X', childObj.DeliveryBlock);

        childObj.DeliveryBlockDescription = 'X';
        System.assertEquals('X', childObj.DeliveryBlockDescription);

        childObj.BillingBlock = 'X';
        System.assertEquals('X', childObj.BillingBlock);

        childObj.BillingBlockDescription = 'X';
        System.assertEquals('X', childObj.BillingBlockDescription);

        childObj.CreditBlock = 'X';
        System.assertEquals('X', childObj.CreditBlock);

        childObj.CreditBlockDescription = 'X';
        System.assertEquals('X', childObj.CreditBlockDescription);

        childObj.DeliveryStatus = 'X';
        System.assertEquals('X', childObj.DeliveryStatus);

        childObj.DeliveryStatusDescription = 'X';
        System.assertEquals('X', childObj.DeliveryStatusDescription);

        childObj.TotalQuantity = 1.5;
        System.assertEquals(1.5, childObj.TotalQuantity);

        childObj.GoodsIssuedQuantity = 1.5;
        System.assertEquals(1.5, childObj.GoodsIssuedQuantity);

        childObj.LastChangedDate = Date.valueOf('2020-12-31');
        System.assertEquals(Date.valueOf('2020-12-31'), childObj.LastChangedDate);

        childObj.StartDate = Date.valueOf('2020-12-31');
        System.assertEquals(Date.valueOf('2020-12-31'), childObj.StartDate);

        childObj.EndDate = Date.valueOf('2020-12-31');
        System.assertEquals(Date.valueOf('2020-12-31'), childObj.EndDate);

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

        childObj.TotalItems = 0;
        System.assertEquals(0, childObj.TotalItems);


    }

}