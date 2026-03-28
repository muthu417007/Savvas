/*
* Test cases for opportunity utility class
*/
@isTest 
public class ensxtx_TSTU_SFWebCart
{
    @isTest
    public static void test_callReturnMethod()
    {
        SObject testSObject = createTestObjects();

        Test.startTest();
        ensxtx_UTIL_SFWebCart utility = new ensxtx_UTIL_SFWebCart();
        Map<String, Object> params = new Map<String, Object>();
        params.put('salesDocDetail', new ensxtx_DS_Document_Detail());
        params.put('lineItems', lineItems);
        ensxtx_DS_SalesDocAppSettings appSettings = new ensxtx_DS_SalesDocAppSettings();
        appSettings.itemNumberIncrement = 10;
        appSettings.sortOrderIncrement = 10;
        appSettings.DefaultDocType = 'OR';
        appSettings.Header = new ensxtx_DS_SalesDocAppSettings.DocumentSetting();
        appSettings.Item = new ensxtx_DS_SalesDocAppSettings.DocumentSetting();
        params.put('appSettings', appSettings);

        utility.callReturnMethod('CustomLineQuery', params);
        utility.callReturnMethod('mapLineItemsFromSObject', params);
        utility.callReturnMethod('badMethod', params);
        Test.stopTest();
    }

    @isTest
    public static void test_getSObject()
    {
        SObject testSObject = createTestObjects();

        Test.startTest();
        ensxtx_UTIL_SFWebCart utility = new ensxtx_UTIL_SFWebCart();
        utility.getSObject(ensxtx_TSTU_SFTestObject.getFakeId(Account.SObjectType));
        utility.getSObject(testSObject.Id);
        utility.getSObject(testSObject.Id);
        utility.getSObject('Quote', 'sapQuoteNumber');
        utility.getSObject('Order', 'sapOrderNumber');
        utility.getSObject('Contract', 'sapContractNumber');
        utility.getSObject('bad SAP Type', 'bad SAP Type');
        Test.stopTest();
    }

    @isTest
    static void test_getSObjectLineItems()
    {
        Test.startTest();
        ensxtx_UTIL_SFWebCart utility = new ensxtx_UTIL_SFWebCart();
        SObject testSObject = createTestObjects();
        utility.getSObjectLineItems(ensxtx_TSTU_SFTestObject.getFakeId(Account.SObjectType));
        utility.getSObjectLineItems(testSObject.Id);
        utility.getSObjectLineItems(testSObject.Id);
        Test.stopTest();
    }

    @isTest
    static void test_getSObjectContacts()
    {
    	Test.startTest();
        ensxtx_UTIL_SFWebCart utility = new ensxtx_UTIL_SFWebCart();
        SObject testSObject = createTestObjects();
		utility.getSObjectContacts(testSObject.Id);
		utility.getSObjectContacts(null);
		Test.stopTest();
    }

    @isTest
    static void test_getAccountId()
    {
    	Test.startTest();
        ensxtx_UTIL_SFWebCart utility = new ensxtx_UTIL_SFWebCart();
        SObject testSObject = createTestObjects();
		utility.getAccountId(testSObject);
		Test.stopTest();
    }

    @isTest
    static void test_getCustomerNumber()
    {
    	Test.startTest();
        ensxtx_UTIL_SFWebCart utility = new ensxtx_UTIL_SFWebCart();
        SObject testSObject = createTestObjects();
		utility.getCustomerNumber(testSObject);
		Test.stopTest();
    }

    @isTest
    static void test_getName()
    {
    	Test.startTest();
        ensxtx_UTIL_SFWebCart utility = new ensxtx_UTIL_SFWebCart();
        SObject testSObject = createTestObjects();
		utility.getName(testSObject);
		Test.stopTest();
    }

    @isTest
    static void test_getQuoteNumber()
    {
    	Test.startTest();
        ensxtx_UTIL_SFWebCart utility = new ensxtx_UTIL_SFWebCart();
        SObject testSObject = createTestObjects();
		utility.getQuoteNumber(testSObject);
		Test.stopTest();
    }

    @isTest
    static void test_getOrderNumber()
    {
    	Test.startTest();
        ensxtx_UTIL_SFWebCart utility = new ensxtx_UTIL_SFWebCart();
        SObject testSObject = createTestObjects();
		utility.getOrderNumber(testSObject);
		Test.stopTest();
    }

    @isTest
    static void test_getContractNumber()
    {
    	Test.startTest();
        ensxtx_UTIL_SFWebCart utility = new ensxtx_UTIL_SFWebCart();
        SObject testSObject = createTestObjects();
		utility.getContractNumber(testSObject);
		Test.stopTest();
    }

    @isTest
    static void test_getInquiryNumber()
    {
    	Test.startTest();
        ensxtx_UTIL_SFWebCart utility = new ensxtx_UTIL_SFWebCart();
        SObject testSObject = createTestObjects();
		utility.getInquiryNumber(testSObject);
		Test.stopTest();
    }

    @isTest
    static void test_getCreditMemoNumber()
    {
    	Test.startTest();
        ensxtx_UTIL_SFWebCart utility = new ensxtx_UTIL_SFWebCart();
        SObject testSObject = createTestObjects();
		utility.getCreditMemoNumber(testSObject);
		Test.stopTest();
    }

    @isTest
    static void test_getDebitMemoNumber()
    {
    	Test.startTest();
        ensxtx_UTIL_SFWebCart utility = new ensxtx_UTIL_SFWebCart();
        SObject testSObject = createTestObjects();
		utility.getDebitMemoNumber(testSObject);
		Test.stopTest();
    }

    @isTest
    static void test_getReturnOrderNumber()
    {
    	Test.startTest();
        ensxtx_UTIL_SFWebCart utility = new ensxtx_UTIL_SFWebCart();
        SObject testSObject = createTestObjects();
		utility.getReturnOrderNumber(testSObject);
		Test.stopTest();
    }

    @isTest
    static void test_getStatus()
    {
    	Test.startTest();
        ensxtx_UTIL_SFWebCart utility = new ensxtx_UTIL_SFWebCart();
        SObject testSObject = createTestObjects();
		utility.getStatus(testSObject);
		Test.stopTest();
    }

    @isTest
    static void test_getOpportunityId()
    {
    	Test.startTest();
        ensxtx_UTIL_SFWebCart utility = new ensxtx_UTIL_SFWebCart();
        SObject testSObject = createTestObjects();
		utility.getOpportunityId(testSObject);
		Test.stopTest();
    }

    @isTest
    static void test_getPriceBookId()
    {
    	Test.startTest();
        ensxtx_UTIL_SFWebCart utility = new ensxtx_UTIL_SFWebCart();
        SObject testSObject = createTestObjects();
		utility.getPriceBookId(null);
		utility.getPriceBookId(testSObject);
		Test.stopTest();
    }

    @isTest
    static void test_getProductId()
    {
    	Test.startTest();
        ensxtx_UTIL_SFWebCart utility = new ensxtx_UTIL_SFWebCart();
		utility.getProductId(null);
		Test.stopTest();
    }

    @isTest
    static void test_getMaterial()
    {
    	Test.startTest();
        SObject testSObject = createTestObjects();
        ensxtx_UTIL_SFWebCart utility = new ensxtx_UTIL_SFWebCart();
		utility.getMaterial(testSObject, null);
		Test.stopTest();
    }

    @isTest
    static void test_getItemNumber()
    {
    	Test.startTest();
        ensxtx_UTIL_SFWebCart utility = new ensxtx_UTIL_SFWebCart();
		utility.getItemNumber(null);
		Test.stopTest();
    }

    @isTest
    static void test_sObjectToSalesDocMapping()
    {
        ensxtx_UTIL_SFWebCart utility = new ensxtx_UTIL_SFWebCart();
        SObject testSObject = createTestObjects();
        ensxtx_DS_Document_Detail salesDocDetail = new ensxtx_DS_Document_Detail();
        ensxtx_DS_SalesDocAppSettings appSettings = new ensxtx_DS_SalesDocAppSettings();
        appSettings.itemNumberIncrement = 10;
        appSettings.sortOrderIncrement = 10;
        appSettings.DefaultDocType = 'OR';
        appSettings.Header = new ensxtx_DS_SalesDocAppSettings.DocumentSetting();
        appSettings.Item = new ensxtx_DS_SalesDocAppSettings.DocumentSetting();

        ensxtx_DS_Document_Detail newSalesDocDetail = utility.sObjectToSalesDocMapping(testSObject, lineItems, salesDocDetail, appSettings);
        ensxtx_DS_Document_Detail.ITEMS item = salesDocDetail.ITEMS[0];
        newSalesDocDetail = utility.sObjectToSalesDocMapping(testSObject, lineItems, salesDocDetail, appSettings);
        salesDocDetail.UsersLanguage = 'New Language';
        lineItems[0].put('ensxtx_SAP_Item_JSON__c', JSON.serialize(new List<ensxtx_DS_Document_Detail.ITEMS>{item}));
        newSalesDocDetail = utility.sObjectToSalesDocMapping(testSObject, lineItems, salesDocDetail, appSettings);
    }

    @isTest
    static void test_salesDocMappingToSObject()
    {
    	Test.startTest();
        ensxtx_UTIL_SFWebCart utility = new ensxtx_UTIL_SFWebCart();
        SObject testSObject = createTestObjects();
        ensxtx_DS_Document_Detail salesDocDetail = new ensxtx_DS_Document_Detail();
        salesDocDetail.SalesDocument = 'SalesDocument';
        salesDocDetail.IsSuccess = false;
        salesDocDetail.SBOHeaderConditions = new List<ensxtx_DS_Document_Detail.CONDITIONS>();
        salesDocDetail.SBOHeaderConditions.add(new ensxtx_DS_Document_Detail.CONDITIONS());
        salesDocDetail.ITEMS = new List<ensxtx_DS_Document_Detail.ITEMS>();
        ensxtx_DS_Document_Detail.ITEMS item = new ensxtx_DS_Document_Detail.ITEMS();
        item.SBOItemConditions = new List<ensxtx_DS_Document_Detail.CONDITIONS>();
        item.SBOItemConditions.add(new ensxtx_DS_Document_Detail.CONDITIONS());
        salesDocDetail.ITEMS.add(item);

        ensxtx_UTIL_PageMessages.addMessage(null, null);

        ensxtx_DS_SalesDocAppSettings appSettings = new ensxtx_DS_SalesDocAppSettings();
        appSettings.SAPDocType = 'Quote';
		utility.salesDocMappingToSObject(testSObject, salesDocDetail, appSettings);
        appSettings.SAPDocType = 'Order';
		utility.salesDocMappingToSObject(testSObject, salesDocDetail, appSettings);
        appSettings.SAPDocType = 'Contract';
		utility.salesDocMappingToSObject(testSObject, salesDocDetail, appSettings);
        appSettings.SAPDocType = 'Credit Memo';
		utility.salesDocMappingToSObject(testSObject, salesDocDetail, appSettings);
        appSettings.SAPDocType = 'Debit Memo';
		utility.salesDocMappingToSObject(testSObject, salesDocDetail, appSettings);
        appSettings.SAPDocType = 'Inquiry';
		utility.salesDocMappingToSObject(testSObject, salesDocDetail, appSettings);
        appSettings.SAPDocType = 'Return Order';
		utility.salesDocMappingToSObject(testSObject, salesDocDetail, appSettings);
		Test.stopTest();
    }

    @isTest
    static void test_salesDocLineItemMappingToSObject()
    {
    	Test.startTest();
        ensxtx_UTIL_SFWebCart utility = new ensxtx_UTIL_SFWebCart();
        SObject testSObject = createTestObjects();
        Map<String,Map<String,Object>> lineItemsMap = new Map<String,Map<String,Object>>();
        Map<String,Object> objectMap = new Map<String,Object>();
        objectMap.put('materialEntry', new PricebookEntry());
        ensxtx_DS_Document_Detail.ITEMS docItem = new ensxtx_DS_Document_Detail.ITEMS();
        docItem.ItemNumber = '10';
        objectMap.put('salesDocItem', docItem);
        lineItemsMap.put('1', objectMap);
		utility.salesDocLineItemMappingToSObject(testSObject, new ensxtx_DS_SalesDocAppSettings(), lineItemsMap);
        objectMap.put('sfLineItem', lineItems[0]);
        lineItemsMap.put('1', objectMap);
		utility.salesDocLineItemMappingToSObject(testSObject, new ensxtx_DS_SalesDocAppSettings(), lineItemsMap);
		Test.stopTest();
    }

    @isTest
    static void test_compareSAPSimulateVsSObject()
    {
    	Test.startTest();
        ensxtx_UTIL_SFWebCart utility = new ensxtx_UTIL_SFWebCart();
		utility.compareSAPSimulateVsSObject(new ensxtx_DS_Document_Detail(), new ensxtx_DS_Document_Detail(), new ensxtx_DS_SalesDocAppSettings());
		Test.stopTest();
    }

    @isTest
    static void test_mapCustomPricingToSalesDoc()
    {
    	Test.startTest();
        ensxtx_DS_Document_Detail salesDocDetail = new ensxtx_DS_Document_Detail();
        ensxtx_DS_Document_Detail.ITEMS item1 = new ensxtx_DS_Document_Detail.ITEMS();
        item1.ItemNumber = '10';
        item1.HigherLevelItemNumber = '0';
        item1.Material = 'Mat1';
        item1.MaterialEntered = 'Mat1';
        item1.OrderQuantity = 1;
        salesDocDetail.ITEMS.add(item1);
        ensxtx_UTIL_SFWebCart utility = new ensxtx_UTIL_SFWebCart();
		utility.mapCustomPricingToSalesDoc(salesDocDetail, new ensxtx_DS_SalesDocAppSettings());
		Test.stopTest();
    }

    @isTest
    static void test_mapChildBomFields()
    {
    	Test.startTest();
        ensxtx_UTIL_SFWebCart utility = new ensxtx_UTIL_SFWebCart();
		utility.mapChildBomFields(new ensxtx_DS_Document_Detail(), new ensxtx_DS_Document_Detail(), new ensxtx_DS_SalesDocAppSettings());
		Test.stopTest();
    }

    private static List<SObject> lineItems = new List<SObject>();

    private static WebCart createTestObjects()
    {
        Account acct = ensxtx_TSTU_SFTestObject.createTestAccount();
        acct.put(ensxtx_UTIL_SFAccount.CustomerFieldName, 'custNo');
        ensxtx_TSTU_SFTestObject.upsertWithRetry(acct);

        WebCart wcObj = ensxtx_TSTU_SFWebCart.createTestWebCart();
        wcObj.AccountId = acct.Id;
        ensxtx_TSTU_SFTestObject.upsertWithRetry(wcObj);

        CartDeliveryGroup cdgObj = ensxtx_TSTU_SFWebCart.createTestCartDeliveryGroup();
        cdgObj.CartId = wcObj.Id;
        ensxtx_TSTU_SFTestObject.upsertWithRetry(cdgObj);

        Product2 pObj = ensxtx_TSTU_SFTestObject.createTestProduct2();
        pObj.put(ensxtx_UTIL_SFProduct.MaterialFieldName, 'SAPMat1');
        ensxtx_TSTU_SFTestObject.upsertWithRetry(pObj);

        CartItem ciObj = ensxtx_TSTU_SFWebCart.createTestCartItem();
        ciObj.CartId = wcObj.Id;
        ciObj.Type = 'Product';
        ciObj.Product2Id = pObj.Id;
        ciObj.CartDeliveryGroupId = cdgObj.Id;
        ciObj.Quantity = 1;
        ensxtx_TSTU_SFTestObject.upsertWithRetry(ciObj);

        ensxtx_UTIL_SFWebCart utility = new ensxtx_UTIL_SFWebCart();
        Map<Id, SObject> lineItemsMap = utility.getSObjectLineItems(wcObj.Id);
        lineItems = lineItemsMap.values();
        return (WebCart) utility.getSObject(wcObj.Id);
    }

    public static WebCart createTestWebCart()
    {
        WebStore wsObj = new WebStore();
        wsObj.Name = 'Test Store';
        ensxtx_TSTU_SFTestObject.upsertWithRetry(wsObj);

        WebCart wcObj = new WebCart();
        wcObj.Name = 'Test Web Cart';
        wcObj.WebStoreId = wsObj.Id;
        return wcObj;
    }

    public static CartDeliveryGroup createTestCartDeliveryGroup()
    {
        CartDeliveryGroup cdgObj = new CartDeliveryGroup();
        cdgObj.Name = 'Test Cart Delivery Group';
        return cdgObj;
    }

    public static CartItem createTestCartItem()
    {
        CartItem ciObj = new CartItem();
        ciObj.Name = 'Test Cart Item';
        return ciObj;
    }
}