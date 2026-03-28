/// enosiX Inc. Generated Apex Model
/// Generated On: 5/16/2024 5:03:00 PM
/// SAP Host: From REST Service On: https://savvas--dev3.sandbox.my.salesforce.com
/// CID: From REST Service On: https://savvas--dev3.sandbox.my.salesforce.com
/// Generator Version: 2.5.0.0, Target Framework ensxapp.v1.2

@isTest
public with sharing class ensxtx_TST_SFCIInvoice_Detail
{
    public class Mockensxtx_SBO_SFCIInvoice_Detail implements
        ensxsdk.EnosixFramework.DetailSBOInitMock,
        ensxsdk.EnosixFramework.DetailSBOCommandMock,
        ensxsdk.EnosixFramework.DetailSBOGetMock,
        ensxsdk.EnosixFramework.DetailSBOSaveMock
    {
        public ensxsdk.EnosixFramework.DetailObject executeInitialize(ensxsdk.EnosixFramework.DetailObject initialState) { return null; }
        public ensxsdk.EnosixFramework.DetailObject executeCommand(String command, ensxsdk.EnosixFramework.DetailObject obj) { return null; }
        public ensxsdk.EnosixFramework.DetailObject executeGetDetail(object key) { return null; }
        public ensxsdk.EnosixFramework.DetailObject executeSave(ensxsdk.EnosixFramework.DetailObject obj) { return null; }
    }

    @isTest
    static void testSBO()
    {
        ensxtx_SBO_SFCIInvoice_Detail sbo = new ensxtx_SBO_SFCIInvoice_Detail();
        ensxsdk.EnosixFramework.setMock(ensxtx_SBO_SFCIInvoice_Detail.class, new Mockensxtx_SBO_SFCIInvoice_Detail());
        System.assertEquals(null, sbo.initialize(null));
        System.assertEquals(null, sbo.command(null, null));
        System.assertEquals(null, sbo.getDetail(null));
        System.assertEquals(null, sbo.save(null));
    }

    @isTest
    static void testSFCIInvoice()
    {
        ensxtx_SBO_SFCIInvoice_Detail.SFCIInvoice result = new ensxtx_SBO_SFCIInvoice_Detail.SFCIInvoice();
        System.assertEquals(ensxtx_SBO_SFCIInvoice_Detail.SFCIInvoice.class, result.getType(), 'getType() does not match object type.');

        result.registerReflectionForClass();

        result.BillingDocument = 'X';
        System.assertEquals('X', result.BillingDocument);

        result.BillingType = 'X';
        System.assertEquals('X', result.BillingType);

        result.BillingTypeDescription = 'X';
        System.assertEquals('X', result.BillingTypeDescription);

        result.CompanyCode = 'X';
        System.assertEquals('X', result.CompanyCode);

        result.CompanyCodeName = 'X';
        System.assertEquals('X', result.CompanyCodeName);

        result.SalesOrganization = 'X';
        System.assertEquals('X', result.SalesOrganization);

        result.SalesOrgDescription = 'X';
        System.assertEquals('X', result.SalesOrgDescription);

        result.BillingDate = Date.valueOf('2020-12-31');
        System.assertEquals(Date.valueOf('2020-12-31'), result.BillingDate);

        result.ShipDate = Date.valueOf('2020-12-31');
        System.assertEquals(Date.valueOf('2020-12-31'), result.ShipDate);

        result.SalesOrderNumber = 'X';
        System.assertEquals('X', result.SalesOrderNumber);

        result.Payer = 'X';
        System.assertEquals('X', result.Payer);

        result.PayerName = 'X';
        System.assertEquals('X', result.PayerName);

        result.SoldToParty = 'X';
        System.assertEquals('X', result.SoldToParty);

        result.SoldToName = 'X';
        System.assertEquals('X', result.SoldToName);

        result.ShipToParty = 'X';
        System.assertEquals('X', result.ShipToParty);

        result.ShipToName = 'X';
        System.assertEquals('X', result.ShipToName);

        result.TrackingNumber = 'X';
        System.assertEquals('X', result.TrackingNumber);

        result.PaymentMethod = 'X';
        System.assertEquals('X', result.PaymentMethod);

        result.PaymentMethodDescription = 'X';
        System.assertEquals('X', result.PaymentMethodDescription);

        result.TermsofPaymentKey = 'X';
        System.assertEquals('X', result.TermsofPaymentKey);

        result.PaymentTermsDescription = 'X';
        System.assertEquals('X', result.PaymentTermsDescription);

        result.NetOrderValue = 1.5;
        System.assertEquals(1.5, result.NetOrderValue);

        result.TaxAmount = 1.5;
        System.assertEquals(1.5, result.TaxAmount);

        result.SalesDocumentCurrency = 'X';
        System.assertEquals('X', result.SalesDocumentCurrency);

        result.CreatedBy = 'X';
        System.assertEquals('X', result.CreatedBy);

        result.CreateDate = Date.valueOf('2020-12-31');
        System.assertEquals(Date.valueOf('2020-12-31'), result.CreateDate);

        result.BillingStatus = 'X';
        System.assertEquals('X', result.BillingStatus);

        result.BillingStatusDescription = 'X';
        System.assertEquals('X', result.BillingStatusDescription);

        result.GrossAmount = 1.5;
        System.assertEquals(1.5, result.GrossAmount);

        result.ActualInvoicedQuantity = 1.5;
        System.assertEquals(1.5, result.ActualInvoicedQuantity);

        result.NetProduct = 1.5;
        System.assertEquals(1.5, result.NetProduct);

        result.Discount = 1.5;
        System.assertEquals(1.5, result.Discount);

        result.Transportation = 1.5;
        System.assertEquals(1.5, result.Transportation);

        //Test child collections
        System.assertNotEquals(null,result.ITEMS.getAsList());
        System.assertNotEquals(null,result.CONDITIONS.getAsList());
        System.assertNotEquals(null,result.USER_DEFINED.getAsList());
        System.assertNotEquals(null,result.ITEM_USER_DEFINED.getAsList());
    }

    @isTest
    static void testITEMS()
    {
        ensxtx_SBO_SFCIInvoice_Detail.ITEMS childObj = new ensxtx_SBO_SFCIInvoice_Detail.ITEMS();
        System.assertEquals(ensxtx_SBO_SFCIInvoice_Detail.ITEMS.class,childObj.getType(),'getType() does not match object type.');

        childObj.registerReflectionForClass();
        childObj.ItemNumber = 'X';
        System.assertEquals('X', childObj.ItemNumber);

        childObj.Material = 'X';
        System.assertEquals('X', childObj.Material);

        childObj.ItemDescription = 'X';
        System.assertEquals('X', childObj.ItemDescription);

        childObj.ActualInvoicedQuantity = 1.5;
        System.assertEquals(1.5, childObj.ActualInvoicedQuantity);

        childObj.SalesUnit = 'X';
        System.assertEquals('X', childObj.SalesUnit);

        childObj.Plant = 'X';
        System.assertEquals('X', childObj.Plant);

        childObj.PlantDescription = 'X';
        System.assertEquals('X', childObj.PlantDescription);

        childObj.NetOrderValue = 1.5;
        System.assertEquals(1.5, childObj.NetOrderValue);

        childObj.TaxAmount = 1.5;
        System.assertEquals(1.5, childObj.TaxAmount);

        childObj.ItemGrossAmount = 1.5;
        System.assertEquals(1.5, childObj.ItemGrossAmount);

        childObj.NetProduct = 1.5;
        System.assertEquals(1.5, childObj.NetProduct);

        childObj.Discount = 1.5;
        System.assertEquals(1.5, childObj.Discount);

        childObj.Transportation = 1.5;
        System.assertEquals(1.5, childObj.Transportation);

        childObj.ISBN = 'X';
        System.assertEquals('X', childObj.ISBN);

        List<string> keyFields = new List<string>{ 'EnosixObjKey','iindex' };
    
        List<string> keys = childObj.getKeyFields();
        for(Integer i = 0; i < keys.size(); i++)
        {
            system.assertEquals(keyFields[i],keys[i]);
        }
    }
    @isTest
    static void testCONDITIONS()
    {
        ensxtx_SBO_SFCIInvoice_Detail.CONDITIONS childObj = new ensxtx_SBO_SFCIInvoice_Detail.CONDITIONS();
        System.assertEquals(ensxtx_SBO_SFCIInvoice_Detail.CONDITIONS.class,childObj.getType(),'getType() does not match object type.');

        childObj.registerReflectionForClass();
        childObj.ConditionNumber = 'X';
        System.assertEquals('X', childObj.ConditionNumber);

        childObj.ConditionItemNumber = 'X';
        System.assertEquals('X', childObj.ConditionItemNumber);

        childObj.StepNumber = 'X';
        System.assertEquals('X', childObj.StepNumber);

        childObj.ConditionCounter = 'X';
        System.assertEquals('X', childObj.ConditionCounter);

        childObj.ConditionType = 'X';
        System.assertEquals('X', childObj.ConditionType);

        childObj.ConditionTypeName = 'X';
        System.assertEquals('X', childObj.ConditionTypeName);

        childObj.Rate = 1.5;
        System.assertEquals(1.5, childObj.Rate);

        childObj.RateUnit = 'X';
        System.assertEquals('X', childObj.RateUnit);

        childObj.ConditionPricingUnit = 1.5;
        System.assertEquals(1.5, childObj.ConditionPricingUnit);

        childObj.ConditionUnit = 'X';
        System.assertEquals('X', childObj.ConditionUnit);

        childObj.ConditionValue = 1.5;
        System.assertEquals(1.5, childObj.ConditionValue);

        childObj.SalesDocumentCurrency = 'X';
        System.assertEquals('X', childObj.SalesDocumentCurrency);

        childObj.CondValueforCumulationFields = 1.5;
        System.assertEquals(1.5, childObj.CondValueforCumulationFields);

        childObj.CondCurrencyforCumulationFlds = 'X';
        System.assertEquals('X', childObj.CondCurrencyforCumulationFlds);

        childObj.ConditionStatistics = true;
        System.assertEquals(true, childObj.ConditionStatistics);

        childObj.KRECH = 'X';
        System.assertEquals('X', childObj.KRECH);

        childObj.KMANU = 'X';
        System.assertEquals('X', childObj.KMANU);

        List<string> keyFields = new List<string>{ 'EnosixObjKey','iindex' };
    
        List<string> keys = childObj.getKeyFields();
        for(Integer i = 0; i < keys.size(); i++)
        {
            system.assertEquals(keyFields[i],keys[i]);
        }
    }
    @isTest
    static void testUSER_DEFINED()
    {
        ensxtx_SBO_SFCIInvoice_Detail.USER_DEFINED childObj = new ensxtx_SBO_SFCIInvoice_Detail.USER_DEFINED();
        System.assertEquals(ensxtx_SBO_SFCIInvoice_Detail.USER_DEFINED.class,childObj.getType(),'getType() does not match object type.');

        childObj.registerReflectionForClass();
        childObj.FIELD = 'X';
        System.assertEquals('X', childObj.FIELD);

        childObj.VALUE = 'X';
        System.assertEquals('X', childObj.VALUE);

        List<string> keyFields = new List<string>{ 'EnosixObjKey','iindex' };
    
        List<string> keys = childObj.getKeyFields();
        for(Integer i = 0; i < keys.size(); i++)
        {
            system.assertEquals(keyFields[i],keys[i]);
        }
    }
    @isTest
    static void testITEM_USER_DEFINED()
    {
        ensxtx_SBO_SFCIInvoice_Detail.ITEM_USER_DEFINED childObj = new ensxtx_SBO_SFCIInvoice_Detail.ITEM_USER_DEFINED();
        System.assertEquals(ensxtx_SBO_SFCIInvoice_Detail.ITEM_USER_DEFINED.class,childObj.getType(),'getType() does not match object type.');

        childObj.registerReflectionForClass();
        childObj.ItemNumber = 'X';
        System.assertEquals('X', childObj.ItemNumber);

        childObj.FIELD = 'X';
        System.assertEquals('X', childObj.FIELD);

        childObj.VALUE = 'X';
        System.assertEquals('X', childObj.VALUE);

        List<string> keyFields = new List<string>{ 'EnosixObjKey','iindex' };
    
        List<string> keys = childObj.getKeyFields();
        for(Integer i = 0; i < keys.size(); i++)
        {
            system.assertEquals(keyFields[i],keys[i]);
        }
    }
}