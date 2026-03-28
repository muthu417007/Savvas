/*
*Test class for ensxtx_UTIL_SFProduct
*/
@isTest
private class ensxtx_TSTU_SFProduct
{
    @isTest
    static void test_getProductById()
    {
        Product2 prod = ensxtx_TSTU_SFTestObject.createTestProduct2();
        ensxtx_TSTU_SFTestObject.upsertWithRetry(prod);

        Test.startTest();
        Product2 fetched1 = ensxtx_UTIL_SFProduct.getProductById(prod.Id);
        Product2 fetched2 = ensxtx_UTIL_SFProduct.getProductById(prod.Id, new List<String> { 'Name', '', null });
        Product2 fetched3 = ensxtx_UTIL_SFProduct.getProductById(null);
        Test.stopTest();

        System.assertEquals(prod.Name, fetched1.Name);
        System.assertEquals(prod.Id, fetched1.Id);

        System.assertEquals(prod.Name, fetched2.Name);
        System.assertEquals(prod.Id, fetched2.Id);

        System.assertEquals(null, fetched3);
    }

    @isTest
    public static void test_getConfigurableMaterialField()
    {
        String fieldName = ensxtx_UTIL_SFProduct.getConfigurableMaterialField();
    }

    @isTest
    public static void test_getBOMMaterialField()
    {
        String fieldName = ensxtx_UTIL_SFProduct.getBOMMaterialField();
    }

    @isTest
    static void test_isProductLinkedToMaterial()
    {

        List<Product2> newProdList = new List<Product2>();

        Product2 prod = ensxtx_TSTU_SFTestObject.createTestProduct2();
        newProdList.add(prod);

        Product2 prod2 = ensxtx_TSTU_SFTestObject.createTestProduct2();
        prod2.put(ensxtx_UTIL_SFProduct.MaterialFieldName, null);
        newProdList.add(prod2);

        ensxtx_TSTU_SFTestObject.upsertWithRetry(newProdList);

        System.assertEquals(false, ensxtx_UTIL_SFProduct.isProductLinkedToMaterial(null));
        System.assert(ensxtx_UTIL_SFProduct.isProductLinkedToMaterial(prod));
        System.assertEquals(false, ensxtx_UTIL_SFProduct.isProductLinkedToMaterial(prod2));
    }

    @isTest
    static void test_getProductByMaterialNumber()
    {
        Product2 prod = ensxtx_TSTU_SFTestObject.createTestProduct2();
        ensxtx_TSTU_SFTestObject.upsertWithRetry(prod);

        Product2 fetched1 = ensxtx_UTIL_SFProduct.getProductByMaterialNumber((String) prod.get(ensxtx_UTIL_SFProduct.MaterialFieldName));

        System.assertEquals(prod.Id, fetched1.Id);
    }

    @isTest
    static void test_getValueFromProductField()
    {
        Product2 prod = ensxtx_TSTU_SFTestObject.createTestProduct2();
        ensxtx_UTIL_SFProduct.getValueFromProductField(null, '', 'Error');
        ensxtx_UTIL_SFProduct.getValueFromProductField(prod, 'BadFieldName', 'Error');
        ensxtx_UTIL_SFProduct.getValueFromProductField(prod, 'Name', 'Error');
        prod.Name = null;
        ensxtx_UTIL_SFProduct.getValueFromProductField(prod, 'Name', 'Error');
    }

    @isTest
    static void test_setProductMaterialNumber()
    {
        Product2 prod = ensxtx_TSTU_SFTestObject.createTestProduct2();
        ensxtx_TSTU_SFTestObject.upsertWithRetry(prod);

        ensxtx_UTIL_SFProduct.setProductMaterialNumber(prod, '1234');

        System.assertEquals('1234', prod.get(ensxtx_UTIL_SFProduct.MaterialFieldName));
    }

    @isTest
    static void test_getProductByFields() {
        Product2 product = ensxtx_TSTU_SFTestObject.createTestProduct2();
        ensxtx_TSTU_SFTestObject.upsertWithRetry(product);
        string sField = 'Name';
        List<String> vals = new List<String> {product.Name};
        List<STring> fields = new List<String> {
            'name',
            'productcode',
            'description'};
        Map<Id, Product2> prods = ensxtx_UTIL_SFProduct.getProductsByField(sField, vals, fields);
    }

    @isTest
    static void test_sObjectToSalesDocMapping()
    {
        Account acct = ensxtx_TSTU_SFTestObject.createTestAccount();
        acct.put(ensxtx_UTIL_SFAccount.CustomerFieldName, 'custNo');
        ensxtx_TSTU_SFTestObject.upsertWithRetry(acct);

        Product2 pObj = ensxtx_TSTU_SFTestObject.createTestProduct2();
        pObj.put(ensxtx_UTIL_SFProduct.MaterialFieldName, 'SAPMat1');
        ensxtx_TSTU_SFTestObject.upsertWithRetry(pObj);
        ensxtx_UTIL_SFProduct.ProductInfo prodInfo = new ensxtx_UTIL_SFProduct.ProductInfo();
        prodInfo.prodId = pObj.Id;
        List<String> prodInfoList = new List<String>{JSON.serialize(prodInfo)};

        ensxtx_DS_Document_Detail salesDocDetail = new ensxtx_DS_Document_Detail();
        ensxtx_DS_SalesDocAppSettings appSettings = new ensxtx_DS_SalesDocAppSettings();
        appSettings.itemNumberIncrement = 10;
        appSettings.sortOrderIncrement = 10;
        appSettings.DefaultDocType = 'OR';
        appSettings.Header = new ensxtx_DS_SalesDocAppSettings.DocumentSetting();
        appSettings.Item = new ensxtx_DS_SalesDocAppSettings.DocumentSetting();
        Map<String, String> productSalesFieldsMap = new Map<String, String>();
        productSalesFieldsMap.put('Header:SoldToParty', 'Test');
        productSalesFieldsMap.put('Sales:SalesOrganization', 'Test');
        ensxtx_DS_Document_Detail newSalesDocDetail = ensxtx_UTIL_SFProduct.sObjectToSalesDocMapping(acct.Id, prodInfoList, JSON.serialize(productSalesFieldsMap), salesDocDetail, appSettings);
    }
}