/*
* Test cases for Order utility class
*/
@isTest 
public class ensxtx_TSTU_SFOrder
{
    @isTest
    public static void test_callReturnMethod()
    {
        SObject testSObject = createTestObjects();
        List<SObject> lineItems = createTestObjectLines();

        Test.startTest();
        ensxtx_UTIL_SFOrder utility = new ensxtx_UTIL_SFOrder();
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
        ensxtx_UTIL_SFOrder utility = new ensxtx_UTIL_SFOrder();
        utility.getSObject(ensxtx_TSTU_SFTestObject.getFakeId(Account.SObjectType));
        utility.getSObject(testSObject.Id);
        utility.getSObject(testSObject.Id);
        utility.getSObject('Quote', 'sapQuoteNumber');
        utility.getSObject('Order', 'sapOrderNumber');
        utility.getSObject('bad SAP Type', 'bad SAP Type');
        Test.stopTest();
    }

    @isTest
    static void test_getSObjectLineItems()
    {
        Test.startTest();
        ensxtx_UTIL_SFOrder utility = new ensxtx_UTIL_SFOrder();
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
        ensxtx_UTIL_SFOrder utility = new ensxtx_UTIL_SFOrder();
        SObject testSObject = createTestObjects();
		utility.getSObjectContacts(null);
		Test.stopTest();
    }

    @isTest
    static void test_getAccountId()
    {
    	Test.startTest();
        ensxtx_UTIL_SFOrder utility = new ensxtx_UTIL_SFOrder();
        SObject testSObject = createTestObjects();
		utility.getAccountId(testSObject);
		Test.stopTest();
    }

    @isTest
    static void test_getCustomerNumber()
    {
    	Test.startTest();
        ensxtx_UTIL_SFOrder utility = new ensxtx_UTIL_SFOrder();
        SObject testSObject = createTestObjects();
		utility.getCustomerNumber(testSObject);
		Test.stopTest();
    }

    @isTest
    static void test_getName()
    {
    	Test.startTest();
        ensxtx_UTIL_SFOrder utility = new ensxtx_UTIL_SFOrder();
        SObject testSObject = createTestObjects();
		utility.getName(testSObject);
		Test.stopTest();
    }

    @isTest
    static void test_getQuoteNumber()
    {
    	Test.startTest();
        ensxtx_UTIL_SFOrder utility = new ensxtx_UTIL_SFOrder();
        SObject testSObject = createTestObjects();
		utility.getQuoteNumber(testSObject);
		Test.stopTest();
    }

    @isTest
    static void test_getOrderNumber()
    {
    	Test.startTest();
        ensxtx_UTIL_SFOrder utility = new ensxtx_UTIL_SFOrder();
        SObject testSObject = createTestObjects();
		utility.getOrderNumber(testSObject);
		Test.stopTest();
    }

    @isTest
    static void test_getContractNumber()
    {
    	Test.startTest();
        ensxtx_UTIL_SFOrder utility = new ensxtx_UTIL_SFOrder();
        SObject testSObject = createTestObjects();
		utility.getContractNumber(testSObject);
		Test.stopTest();
    }

    @isTest
    static void test_getInquiryNumber()
    {
    	Test.startTest();
        ensxtx_UTIL_SFOrder utility = new ensxtx_UTIL_SFOrder();
        SObject testSObject = createTestObjects();
		utility.getInquiryNumber(testSObject);
		Test.stopTest();
    }

    @isTest
    static void test_getCreditMemoNumber()
    {
    	Test.startTest();
        ensxtx_UTIL_SFOrder utility = new ensxtx_UTIL_SFOrder();
        SObject testSObject = createTestObjects();
		utility.getCreditMemoNumber(testSObject);
		Test.stopTest();
    }

    @isTest
    static void test_getDebitMemoNumber()
    {
    	Test.startTest();
        ensxtx_UTIL_SFOrder utility = new ensxtx_UTIL_SFOrder();
        SObject testSObject = createTestObjects();
		utility.getDebitMemoNumber(testSObject);
		Test.stopTest();
    }

    @isTest
    static void test_getReturnOrderNumber()
    {
    	Test.startTest();
        ensxtx_UTIL_SFOrder utility = new ensxtx_UTIL_SFOrder();
        SObject testSObject = createTestObjects();
		utility.getReturnOrderNumber(testSObject);
		Test.stopTest();
    }

    @isTest
    static void test_getStatus()
    {
    	Test.startTest();
        ensxtx_UTIL_SFOrder utility = new ensxtx_UTIL_SFOrder();
        SObject testSObject = createTestObjects();
		utility.getStatus(testSObject);
		Test.stopTest();
    }

    @isTest
    static void test_getOpportunityId()
    {
    	Test.startTest();
        ensxtx_UTIL_SFOrder utility = new ensxtx_UTIL_SFOrder();
        SObject testSObject = createTestObjects();
		utility.getOpportunityId(testSObject);
		Test.stopTest();
    }

    @isTest
    static void test_getOpportunity()
    {
    	Test.startTest();
        ensxtx_UTIL_SFOrder utility = new ensxtx_UTIL_SFOrder();
        SObject testSObject = createTestObjects();
		utility.getOpportunity(testSObject);
		Test.stopTest();
    }

    @isTest
    static void test_getPriceBookId()
    {
    	Test.startTest();
        ensxtx_UTIL_SFOrder utility = new ensxtx_UTIL_SFOrder();
        SObject testSObject = createTestObjects();
		utility.getPriceBookId(null);
		utility.getPriceBookId(testSObject);
		Test.stopTest();
    }

    @isTest
    static void test_getProductId()
    {
    	Test.startTest();
        ensxtx_UTIL_SFOrder utility = new ensxtx_UTIL_SFOrder();
		utility.getProductId(null);
		Test.stopTest();
    }

    @isTest
    static void test_getMaterial()
    {
    	Test.startTest();
        SObject testSObject = createTestObjects();
        ensxtx_UTIL_SFOrder utility = new ensxtx_UTIL_SFOrder();
		utility.getMaterial(testSObject, null);
		Test.stopTest();
    }

    @isTest
    static void test_getItemNumber()
    {
    	Test.startTest();
        ensxtx_UTIL_SFOrder utility = new ensxtx_UTIL_SFOrder();
		utility.getItemNumber(null);
		Test.stopTest();
    }

    @isTest
    static void test_sObjectToSalesDocMapping()
    {
        ensxtx_UTIL_SFOrder utility = new ensxtx_UTIL_SFOrder();
        SObject testSObject = createTestObjects();
        List<SObject> lineItems = createTestObjectLines();
        ensxtx_DS_Document_Detail salesDocDetail = new ensxtx_DS_Document_Detail();
        salesDocDetail.ITEMS = new List<ensxtx_DS_Document_Detail.ITEMS>();
        ensxtx_DS_Document_Detail.ITEMS docItem = new ensxtx_DS_Document_Detail.ITEMS();
        docItem.ItemNumber = '10';
        salesDocDetail.ITEMS.add(docItem);
        ensxtx_DS_SalesDocAppSettings appSettings = new ensxtx_DS_SalesDocAppSettings();
        appSettings.itemNumberIncrement = 10;
        appSettings.sortOrderIncrement = 10;
        appSettings.DefaultDocType = 'OR';
        appSettings.Header = new ensxtx_DS_SalesDocAppSettings.DocumentSetting();
        appSettings.Item = new ensxtx_DS_SalesDocAppSettings.DocumentSetting();
        appSettings.sfInvokeFrom = 'Commerce';

        ensxtx_DS_Document_Detail newSalesDocDetail = utility.sObjectToSalesDocMapping(testSObject, lineItems, salesDocDetail, appSettings);
        testSObject.put('Shipping_Conditions__c', 'AC');
        testSObject.put('SAP_Shipto__c', '0000009');
        testSObject.put('SAP_BillTo__c', '0000009');
        testSObject.put('Sold_To_Customer__c', '0000009');
        newSalesDocDetail = utility.sObjectToSalesDocMapping(testSObject, lineItems, salesDocDetail, appSettings);
        
        appSettings.sfInvokeFrom = null;
        newSalesDocDetail = utility.sObjectToSalesDocMapping(testSObject, lineItems, salesDocDetail, appSettings);
        ensxtx_DS_Document_Detail.ITEMS item = salesDocDetail.ITEMS[0];
        testSObject.put('ensxtx_SAP_SaveSalesDocHeader__c', JSON.serialize(salesDocDetail));
        for (SObject lineItem : lineItems) {
            lineItem.put('ensxtx_SAP_SaveSalesDocItem__c', JSON.serialize(item));
        }
        newSalesDocDetail = utility.sObjectToSalesDocMapping(testSObject, lineItems, salesDocDetail, appSettings);
        salesDocDetail.UsersLanguage = 'New Language';
        testSObject.put('ensxtx_SAP_SaveSalesDocHeader__c', JSON.serialize(salesDocDetail));
        newSalesDocDetail = utility.sObjectToSalesDocMapping(testSObject, lineItems, salesDocDetail, appSettings);
    }

    @isTest
    static void test_getCPQQuoteObject()
    {
    	Test.startTest();
        ensxtx_UTIL_SFOrder utility = new ensxtx_UTIL_SFOrder();
        SObject testSObject = createTestObjects();
        utility.getCPQQuoteObject(testSObject.Id);
		Test.stopTest();
    }

    @isTest
    static void test_getCPQQuoteLineObjects()
    {
    	Test.startTest();
        ensxtx_UTIL_SFOrder utility = new ensxtx_UTIL_SFOrder();
        SObject testSObject = createTestObjects();
        Set<Id> cpqQuoteLineIdSet = new Set<Id>();
        cpqQuoteLineIdSet.add(testSObject.Id);
        utility.getCPQQuoteLineObjects(cpqQuoteLineIdSet);
		Test.stopTest();
    }

    @isTest
    static void test_mapItemConfiguration()
    {
    	Test.startTest();
        ensxtx_UTIL_SFOrder utility = new ensxtx_UTIL_SFOrder();
        utility.mapItemConfiguration(JSON.serialize(new ensxtx_DS_Document_Detail.CPQ_VC_ITEM_CONFIGURATION()), new ensxtx_DS_Document_Detail.ITEMS());
		Test.stopTest();
    }

    @isTest
    static void test_setItemNumbers()
    {
    	Test.startTest();
        ensxtx_UTIL_SFOrder utility = new ensxtx_UTIL_SFOrder();
        Map<String, Integer> itemNumberMap = new Map<String, Integer>();
        itemNumberMap.put('itemNumber', 0);
        itemNumberMap.put('bomItemNumber', 0);
        utility.setItemNumbers(new ensxtx_DS_Document_Detail.ITEMS(), itemNumberMap, 0, true);
        utility.setItemNumbers(new ensxtx_DS_Document_Detail.ITEMS(), itemNumberMap, 0, false);
		Test.stopTest();
    }

    @isTest
    static void test_salesDocMappingToSObject()
    {
    	Test.startTest();
        ensxtx_UTIL_SFOrder utility = new ensxtx_UTIL_SFOrder();
        SObject testSObject = createTestObjects();
        ensxtx_DS_Document_Detail salesDocDetail = new ensxtx_DS_Document_Detail();
        salesDocDetail.SalesDocument = 'SalesDocument';
        salesDocDetail.IsSuccess = true;
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
        ensxtx_UTIL_SFOrder utility = new ensxtx_UTIL_SFOrder();
        SObject testSObject = createTestObjects();
        Map<String,Map<String,Object>> lineItemsMap = new Map<String,Map<String,Object>>();
        Map<String,Object> objectMap = new Map<String,Object>();
        objectMap.put('materialEntry', new PricebookEntry());
        ensxtx_DS_Document_Detail.ITEMS docItem = new ensxtx_DS_Document_Detail.ITEMS();
        docItem.ItemNumber = '10';
        objectMap.put('salesDocItem', docItem);
        lineItemsMap.put('1', objectMap);
        ensxtx_DS_SalesDocAppSettings appSettings = new ensxtx_DS_SalesDocAppSettings();
        appSettings.skipAddedLineValidation = false;
		utility.salesDocLineItemMappingToSObject(testSObject, appSettings, lineItemsMap);
        objectMap.put('sfLineItem', new OrderItem());
        lineItemsMap.put('1', objectMap);
		utility.salesDocLineItemMappingToSObject(testSObject, appSettings, lineItemsMap);
		Test.stopTest();
    }

    @isTest
    static void test_compareSAPSimulateVsSObject()
    {
    	Test.startTest();
        ensxtx_UTIL_SFOrder utility = new ensxtx_UTIL_SFOrder();
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
        ensxtx_UTIL_SFOrder utility = new ensxtx_UTIL_SFOrder();
		utility.mapCustomPricingToSalesDoc(salesDocDetail, new ensxtx_DS_SalesDocAppSettings());
		Test.stopTest();
    }

    @isTest
    static void test_mapChildBomFields()
    {
    	Test.startTest();
        ensxtx_UTIL_SFOrder utility = new ensxtx_UTIL_SFOrder();
		utility.mapChildBomFields(new ensxtx_DS_Document_Detail(), new ensxtx_DS_Document_Detail(), new ensxtx_DS_SalesDocAppSettings());
		Test.stopTest();
    }

    private static Order createTestObjects()
    {
        Id pricebookId = ensxtx_UTIL_Pricebook.getStandardPriceBookId();
        Opportunity opp = ensxtx_TSTU_SFTestObject.createTestOpportunity();
        opp.Name = 'TEST OPP';
        opp.CloseDate = Date.today();
        opp.StageName = 'Prospect';
        opp.Pricebook2Id = pricebookId;
        ensxtx_TSTU_SFTestObject.upsertWithRetry(opp);
        opp = [SELECT Id, Pricebook2Id FROM Opportunity WHERE Id = :opp.Id];
        opp.Pricebook2Id = pricebookId;
        ensxtx_TSTU_SFTestObject.upsertWithRetry(opp);

        Order order = ensxtx_TSTU_SFOrder.createTestOrder(opp);
        order.Name = 'TEST ORDER';
        order.OpportunityId = opp.Id;
        order.Pricebook2Id = pricebookId;
        order.EffectiveDate = Date.today();
        order.Status = 'Draft';
        order.SAP_Shipto__c = '111';
        order.SAP_BillTo__c = '111';
        order.License_Partner__c = '111';
        order.Warehouse_text__c = 'warehouse';
        order.Attention_Shipping__c = 'attention';
        order.Attention_Billing__c = 'attention';
        order.Shipping_instruction__c = 'shipping';
        order.Customer_Service_Comments__c = 'customer';
        order.Special_EDI_Instructions__c = 'special';
        order.Has_One_Time_Ship__c = true;
        ensxtx_TSTU_SFTestObject.upsertWithRetry(order);
        order = [SELECT Id, Pricebook2Id FROM Order WHERE Id = :order.Id];
        order.Pricebook2Id = pricebookId;
        ensxtx_TSTU_SFTestObject.upsertWithRetry(order);

        ensxtx_UTIL_SFOrder utility = new ensxtx_UTIL_SFOrder();
        return (Order) utility.getSObject(order.Id);
    }

    private static List<SObject> createTestObjectLines()
    {
        OrderItem orderItem = ensxtx_TSTU_SFOrder.createTestOrderItem();
		orderItem.Quantity = 10;
		orderItem.UnitPrice = .95;
		orderItem.Description = 'test Desciption';
        orderItem.ensxtx_SAP_Item_Number__c = '000010';
        Map <String, Object> orderItemMap = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(orderItem));
        Product2 prod = ensxtx_TSTU_SFTestObject.createTestProduct2();
        orderItemMap.put('Product2', prod);
        return new List<SObject>{orderItem, (OrderItem) JSON.deserialize(JSON.serialize(orderItemMap), OrderItem.class)};
    }

    public static Order createTestOrder(Opportunity opp)
    {
        Account acct = ensxtx_TSTU_SFTestObject.createTestAccount();
        if (String.isNotEmpty(opp.AccountId)) acct.Id = opp.AccountId;
        ensxtx_TSTU_SFTestObject.upsertWithRetry(acct);

        Order order = new Order();
        order.AccountId = acct.Id;
        order.Status = 'Draft';
        order.Name = 'TestOrder';
        order.EffectiveDate = Date.today();
        return order;
    }

    public static OrderItem createTestOrderItem() {
        OrderItem opportunityLineItemObj = new OrderItem();
        return opportunityLineItemObj;
    }
}