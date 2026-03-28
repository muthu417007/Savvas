/// enosiX Inc. Generated Apex Model
/// Generated On: 5/16/2024 8:25:29 PM
/// SAP Host: From REST Service On: https://savvas--dev3.sandbox.my.salesforce.com
/// CID: From REST Service On: https://savvas--dev3.sandbox.my.salesforce.com
/// Generator Version: 2.5.0.0, Target Framework ensxapp.v1.2

@isTest
private class ensxtx_TST_SFCIDelivery_Search
{

    public class Mockensxtx_SBO_SFCIDelivery_Search implements ensxsdk.EnosixFramework.SearchSBOInitMock, ensxsdk.EnosixFramework.SearchSBOSearchMock
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
        ensxsdk.EnosixFramework.setMock(ensxtx_SBO_SFCIDelivery_Search.class, new Mockensxtx_SBO_SFCIDelivery_Search());
        ensxtx_SBO_SFCIDelivery_Search sbo = new ensxtx_SBO_SFCIDelivery_Search();
        System.assertEquals(ensxtx_SBO_SFCIDelivery_Search.class, sbo.getType(), 'getType() does not match object type.');

        System.assertEquals(null, sbo.initialize(null));
        System.assertEquals(null, sbo.search(null));

        ensxtx_SBO_SFCIDelivery_Search.SFCIDelivery_SC sc = new ensxtx_SBO_SFCIDelivery_Search.SFCIDelivery_SC();
        System.assertEquals(ensxtx_SBO_SFCIDelivery_Search.SFCIDelivery_SC.class, sc.getType(), 'getType() does not match object type.');

        sc.registerReflectionForClass();
        System.assertEquals(null, sc.result);

        System.assertNotEquals(null, sc.SEARCHPARAMS);
        System.assertNotEquals(null, sc.DELIVERYTYPE);
        System.assertNotEquals(null, sc.CUSTOM);

    }
    
    
    @isTest
    static void testSEARCHPARAMS()
    {
        ensxtx_SBO_SFCIDelivery_Search.SEARCHPARAMS childObj = new ensxtx_SBO_SFCIDelivery_Search.SEARCHPARAMS();
        System.assertEquals(ensxtx_SBO_SFCIDelivery_Search.SEARCHPARAMS.class, childObj.getType(),'getType() does not match object type.');

        childObj.registerReflectionForClass();
        childObj.Route = 'X';
        System.assertEquals('X', childObj.Route);

        childObj.MeansOfTransportID = 'X';
        System.assertEquals('X', childObj.MeansOfTransportID);

        childObj.FromCreateDate = Date.valueOf('2020-12-31');
        System.assertEquals(Date.valueOf('2020-12-31'), childObj.FromCreateDate);

        childObj.ToCreateDate = Date.valueOf('2020-12-31');
        System.assertEquals(Date.valueOf('2020-12-31'), childObj.ToCreateDate);

        childObj.DeliveryDateFrom = Date.valueOf('2020-12-31');
        System.assertEquals(Date.valueOf('2020-12-31'), childObj.DeliveryDateFrom);

        childObj.DeliveryDateTo = Date.valueOf('2020-12-31');
        System.assertEquals(Date.valueOf('2020-12-31'), childObj.DeliveryDateTo);

        childObj.DeliveryFrom = 'X';
        System.assertEquals('X', childObj.DeliveryFrom);

        childObj.DeliveryTo = 'X';
        System.assertEquals('X', childObj.DeliveryTo);

        childObj.SoldToParty = 'X';
        System.assertEquals('X', childObj.SoldToParty);

        childObj.ShipToParty = 'X';
        System.assertEquals('X', childObj.ShipToParty);

        childObj.ShippingPoint = 'X';
        System.assertEquals('X', childObj.ShippingPoint);

        childObj.ShippingConditions = 'X';
        System.assertEquals('X', childObj.ShippingConditions);

        childObj.DeliveryPriority = 'X';
        System.assertEquals('X', childObj.DeliveryPriority);

        childObj.BillofLading = 'X';
        System.assertEquals('X', childObj.BillofLading);

        childObj.PGIDateFrom = Date.valueOf('2020-12-31');
        System.assertEquals(Date.valueOf('2020-12-31'), childObj.PGIDateFrom);

        childObj.PGIDateTo = Date.valueOf('2020-12-31');
        System.assertEquals(Date.valueOf('2020-12-31'), childObj.PGIDateTo);

        childObj.Username = 'X';
        System.assertEquals('X', childObj.Username);

        childObj.X_Open = true;
        System.assertEquals(true, childObj.X_Open);

        childObj.X_Picked = true;
        System.assertEquals(true, childObj.X_Picked);

        childObj.X_Packed = true;
        System.assertEquals(true, childObj.X_Packed);

        childObj.X_PGIed = true;
        System.assertEquals(true, childObj.X_PGIed);


    }

    @isTest
    static void testDELIVERYTYPE()
    {
        ensxtx_SBO_SFCIDelivery_Search.DELIVERYTYPE childObj = new ensxtx_SBO_SFCIDelivery_Search.DELIVERYTYPE();
        System.assertEquals(ensxtx_SBO_SFCIDelivery_Search.DELIVERYTYPE.class, childObj.getType(),'getType() does not match object type.');

        childObj.registerReflectionForClass();
        ensxtx_SBO_SFCIDelivery_Search.DELIVERYTYPE_COLLECTION childObjCollection = new ensxtx_SBO_SFCIDelivery_Search.DELIVERYTYPE_COLLECTION();
        System.assertNotEquals(null, childObjCollection.getAsList());

        childObj.DeliveryType = 'X';
        System.assertEquals('X', childObj.DeliveryType);


    }

    @isTest
    static void testCUSTOM()
    {
        ensxtx_SBO_SFCIDelivery_Search.CUSTOM childObj = new ensxtx_SBO_SFCIDelivery_Search.CUSTOM();
        System.assertEquals(ensxtx_SBO_SFCIDelivery_Search.CUSTOM.class, childObj.getType(),'getType() does not match object type.');

        childObj.registerReflectionForClass();
        ensxtx_SBO_SFCIDelivery_Search.CUSTOM_COLLECTION childObjCollection = new ensxtx_SBO_SFCIDelivery_Search.CUSTOM_COLLECTION();
        System.assertNotEquals(null, childObjCollection.getAsList());

        childObj.FIELD = 'X';
        System.assertEquals('X', childObj.FIELD);

        childObj.VALUE = 'X';
        System.assertEquals('X', childObj.VALUE);


    }

    @isTest
    static void testSFCIDelivery_SR()
    {
        ensxtx_SBO_SFCIDelivery_Search.SFCIDelivery_SR sr = new ensxtx_SBO_SFCIDelivery_Search.SFCIDelivery_SR();

        sr.registerReflectionForClass();

        System.assertEquals(ensxtx_SBO_SFCIDelivery_Search.SFCIDelivery_SR.class, sr.getType(), 'getType() does not match object type.');

        System.assertNotEquals(null, sr.getResults());
    }


    @isTest
    static void testSEARCHRESULT()
    {
        ensxtx_SBO_SFCIDelivery_Search.SEARCHRESULT childObj = new ensxtx_SBO_SFCIDelivery_Search.SEARCHRESULT();
        System.assertEquals(ensxtx_SBO_SFCIDelivery_Search.SEARCHRESULT.class, childObj.getType(),'getType() does not match object type.');

        childObj.registerReflectionForClass();
        ensxtx_SBO_SFCIDelivery_Search.SEARCHRESULT_COLLECTION childObjCollection = new ensxtx_SBO_SFCIDelivery_Search.SEARCHRESULT_COLLECTION();
        System.assertNotEquals(null, childObjCollection.getAsList());

        childObj.Delivery = 'X';
        System.assertEquals('X', childObj.Delivery);

        childObj.Route = 'X';
        System.assertEquals('X', childObj.Route);

        childObj.MeansOfTransportID = 'X';
        System.assertEquals('X', childObj.MeansOfTransportID);

        childObj.BillofLading = 'X';
        System.assertEquals('X', childObj.BillofLading);

        childObj.CreateDate = Date.valueOf('2020-12-31');
        System.assertEquals(Date.valueOf('2020-12-31'), childObj.CreateDate);

        childObj.DeliveryDate = Date.valueOf('2020-12-31');
        System.assertEquals(Date.valueOf('2020-12-31'), childObj.DeliveryDate);

        childObj.PGIDate = Date.valueOf('2020-12-31');
        System.assertEquals(Date.valueOf('2020-12-31'), childObj.PGIDate);

        childObj.DeliveryType = 'X';
        System.assertEquals('X', childObj.DeliveryType);

        childObj.DeliveryTypeText = 'X';
        System.assertEquals('X', childObj.DeliveryTypeText);

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

        childObj.ShippingPoint = 'X';
        System.assertEquals('X', childObj.ShippingPoint);

        childObj.ShippingConditions = 'X';
        System.assertEquals('X', childObj.ShippingConditions);

        childObj.DeliveryPriority = 'X';
        System.assertEquals('X', childObj.DeliveryPriority);

        childObj.NetOrderValue = 1.5;
        System.assertEquals(1.5, childObj.NetOrderValue);

        childObj.SalesDocumentCurrency = 'X';
        System.assertEquals('X', childObj.SalesDocumentCurrency);

        childObj.DeliveryStatus = 'X';
        System.assertEquals('X', childObj.DeliveryStatus);

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