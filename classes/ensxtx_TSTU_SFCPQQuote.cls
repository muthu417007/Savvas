/*
* Test cases for Quote utility class
*/
@isTest 
public class ensxtx_TSTU_SFCPQQuote
{
    @isTest
    public static void test_callReturnMethod()
    {
        SBQQ__Quote__c testSObject = createTestObjects();

        Test.startTest();
        ensxtx_UTIL_SFCPQQuote utility = new ensxtx_UTIL_SFCPQQuote();
        Map<String, Object> params = new Map<String, Object>();
        params.put('salesDocDetail', new ensxtx_DS_Document_Detail());
        params.put('lineItems', lineItems);
        ensxtx_DS_SalesDocAppSettings appSettings = new ensxtx_DS_SalesDocAppSettings();
        appSettings.itemNumberIncrement = 10;
        appSettings.bomItemNumberIncrement = 1;
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
        ensxtx_UTIL_SFCPQQuote utility = new ensxtx_UTIL_SFCPQQuote();
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
        ensxtx_UTIL_SFCPQQuote utility = new ensxtx_UTIL_SFCPQQuote();
        SBQQ__Quote__c testSObject = createTestObjects();
        utility.getSObjectLineItems(ensxtx_TSTU_SFTestObject.getFakeId(Account.SObjectType));
        utility.getSObjectLineItems(testSObject.Id);
        utility.getSObjectLineItems(testSObject.Id);
        Test.stopTest();
    }

    @isTest
    static void test_getSObjectContacts()
    {
    	Test.startTest();
        ensxtx_UTIL_SFCPQQuote utility = new ensxtx_UTIL_SFCPQQuote();
        SObject testSObject = createTestObjects();
		utility.getSObjectContacts(null);
		Test.stopTest();
    }

    @isTest
    static void test_getAccountId()
    {
    	Test.startTest();
        ensxtx_UTIL_SFCPQQuote utility = new ensxtx_UTIL_SFCPQQuote();
        SObject testSObject = createTestObjects();
		utility.getAccountId(testSObject);
		Test.stopTest();
    }

    @isTest
    static void test_getCustomerNumber()
    {
    	Test.startTest();
        ensxtx_UTIL_SFCPQQuote utility = new ensxtx_UTIL_SFCPQQuote();
        SObject testSObject = createTestObjects();
		utility.getCustomerNumber(testSObject);
		Test.stopTest();
    }

    @isTest
    static void test_getName()
    {
    	Test.startTest();
        ensxtx_UTIL_SFCPQQuote utility = new ensxtx_UTIL_SFCPQQuote();
        SObject testSObject = createTestObjects();
		utility.getName(testSObject);
		Test.stopTest();
    }

    @isTest
    static void test_getQuoteNumber()
    {
    	Test.startTest();
        ensxtx_UTIL_SFCPQQuote utility = new ensxtx_UTIL_SFCPQQuote();
        SObject testSObject = createTestObjects();
		utility.getQuoteNumber(testSObject);
		Test.stopTest();
    }

    @isTest
    static void test_getOrderNumber()
    {
    	Test.startTest();
        ensxtx_UTIL_SFCPQQuote utility = new ensxtx_UTIL_SFCPQQuote();
        SObject testSObject = createTestObjects();
		utility.getOrderNumber(testSObject);
		Test.stopTest();
    }

    @isTest
    static void test_getContractNumber()
    {
    	Test.startTest();
        ensxtx_UTIL_SFCPQQuote utility = new ensxtx_UTIL_SFCPQQuote();
        SObject testSObject = createTestObjects();
		utility.getContractNumber(testSObject);
		Test.stopTest();
    }

    @isTest
    static void test_getInquiryNumber()
    {
    	Test.startTest();
        ensxtx_UTIL_SFCPQQuote utility = new ensxtx_UTIL_SFCPQQuote();
        SObject testSObject = createTestObjects();
		utility.getInquiryNumber(testSObject);
		Test.stopTest();
    }

    @isTest
    static void test_getCreditMemoNumber()
    {
    	Test.startTest();
        ensxtx_UTIL_SFCPQQuote utility = new ensxtx_UTIL_SFCPQQuote();
        SObject testSObject = createTestObjects();
		utility.getCreditMemoNumber(testSObject);
		Test.stopTest();
    }

    @isTest
    static void test_getDebitMemoNumber()
    {
    	Test.startTest();
        ensxtx_UTIL_SFCPQQuote utility = new ensxtx_UTIL_SFCPQQuote();
        SObject testSObject = createTestObjects();
		utility.getDebitMemoNumber(testSObject);
		Test.stopTest();
    }

    @isTest
    static void test_getReturnOrderNumber()
    {
    	Test.startTest();
        ensxtx_UTIL_SFCPQQuote utility = new ensxtx_UTIL_SFCPQQuote();
        SObject testSObject = createTestObjects();
		utility.getReturnOrderNumber(testSObject);
		Test.stopTest();
    }

    @isTest
    static void test_getStatus()
    {
    	Test.startTest();
        ensxtx_UTIL_SFCPQQuote utility = new ensxtx_UTIL_SFCPQQuote();
        SObject testSObject = createTestObjects();
		utility.getStatus(testSObject);
		Test.stopTest();
    }

    @isTest
    static void test_getOpportunityId()
    {
    	Test.startTest();
        ensxtx_UTIL_SFCPQQuote utility = new ensxtx_UTIL_SFCPQQuote();
        SObject testSObject = createTestObjects();
		utility.getOpportunityId(testSObject);
		Test.stopTest();
    }

    @isTest
    static void test_getOpportunity()
    {
    	Test.startTest();
        ensxtx_UTIL_SFCPQQuote utility = new ensxtx_UTIL_SFCPQQuote();
        SObject testSObject = createTestObjects();
		utility.getOpportunity(testSObject);
		Test.stopTest();
    }

    @isTest
    static void test_getPriceBookId()
    {
    	Test.startTest();
        ensxtx_UTIL_SFCPQQuote utility = new ensxtx_UTIL_SFCPQQuote();
        SObject testSObject = createTestObjects();
		utility.getPriceBookId(null);
		utility.getPriceBookId(testSObject);
		Test.stopTest();
    }

    @isTest
    static void test_getProductId()
    {
    	Test.startTest();
        ensxtx_UTIL_SFCPQQuote utility = new ensxtx_UTIL_SFCPQQuote();
		utility.getProductId(null);
		Test.stopTest();
    }

    @isTest
    static void test_getMaterial()
    {
    	Test.startTest();
        SObject testSObject = createTestObjects();
        ensxtx_UTIL_SFCPQQuote utility = new ensxtx_UTIL_SFCPQQuote();
		utility.getMaterial(testSObject, null);
		Test.stopTest();
    }

    @isTest
    static void test_getItemNumber()
    {
    	Test.startTest();
        ensxtx_UTIL_SFCPQQuote utility = new ensxtx_UTIL_SFCPQQuote();
		utility.getItemNumber(null);
		Test.stopTest();
    }

    @isTest
    static void test_sObjectToSalesDocMapping()
    {
        ensxtx_UTIL_SFCPQQuote utility = new ensxtx_UTIL_SFCPQQuote();
        SBQQ__Quote__c testSObject = createTestObjects();
        ensxtx_DS_Document_Detail salesDocDetail = new ensxtx_DS_Document_Detail();
        salesDocDetail.SalesDocument = 'SalesDocument';
        ensxtx_DS_SalesDocAppSettings appSettings = new ensxtx_DS_SalesDocAppSettings();
        appSettings.sortOrderIncrement = 10;
        appSettings.itemNumberIncrement = 10;
        appSettings.bomItemNumberIncrement = 1;
        appSettings.DefaultDocType = 'OR';
        appSettings.Header = new ensxtx_DS_SalesDocAppSettings.DocumentSetting();
        appSettings.Item = new ensxtx_DS_SalesDocAppSettings.DocumentSetting();

        ensxtx_DS_Document_Detail newSalesDocDetail = utility.sObjectToSalesDocMapping(testSObject, lineItems, salesDocDetail, appSettings);
        ensxtx_DS_Document_Detail.ITEMS item = salesDocDetail.ITEMS[0];
        testSObject.put('ensxtx_SAP_SaveSalesDocHeader__c', JSON.serialize(salesDocDetail));
        testSObject.put('ensxtx_Sales_Organization__c', 'salesOrg');
        for (SObject lineItem : lineItems) {
            lineItem.put('ensxtx_SAP_SaveSalesDocItem__c', JSON.serialize(item));
        }
        newSalesDocDetail = utility.sObjectToSalesDocMapping(testSObject, lineItems, salesDocDetail, appSettings);
        salesDocDetail.SalesDocument = null;
        newSalesDocDetail = utility.sObjectToSalesDocMapping(testSObject, lineItems, salesDocDetail, appSettings);
        salesDocDetail.UsersLanguage = 'New Language';
        testSObject.put('ensxtx_SAP_SaveSalesDocHeader__c', JSON.serialize(salesDocDetail));
        newSalesDocDetail = utility.sObjectToSalesDocMapping(testSObject, lineItems, salesDocDetail, appSettings);
        newSalesDocDetail = utility.sObjectToSalesDocMapping(testSObject, lineItems, salesDocDetail, appSettings);
    }

    @isTest
    static void test_setItemNumbers()
    {
    	Test.startTest();
        ensxtx_UTIL_SFCPQQuote utility = new ensxtx_UTIL_SFCPQQuote();
        Map<String, Integer> itemNumberMap = new Map<String, Integer>();
        itemNumberMap.put('itemNumber', 0);
        itemNumberMap.put('bomItemNumber', 0);

        utility.setItemNumbers(new ensxtx_DS_Document_Detail.ITEMS(), itemNumberMap, 10, 1, true, new Set<Integer>());
        utility.setItemNumbers(new ensxtx_DS_Document_Detail.ITEMS(), itemNumberMap, 10, 1, false, new Set<Integer>());
		Test.stopTest();
    }

    @isTest
    static void test_salesDocMappingToSObject()
    {
    	Test.startTest();
        ensxtx_UTIL_SFCPQQuote utility = new ensxtx_UTIL_SFCPQQuote();
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
        ensxtx_UTIL_SFCPQQuote utility = new ensxtx_UTIL_SFCPQQuote();
        SObject testSObject = createTestObjects();
        ensxtx_DS_Document_Detail.ITEMS item = new ensxtx_DS_Document_Detail.ITEMS();
        item.ItemConfigurations = new List<ensxtx_DS_Document_Detail.CONFIG>();
        ensxtx_DS_Document_Detail.CONFIG config = new ensxtx_DS_Document_Detail.CONFIG();
        item.ItemConfigurations.add(config);
        item.ItemTexts = new List<ensxtx_DS_Document_Detail.TEXTS>();
        ensxtx_DS_Document_Detail.TEXTS text = new ensxtx_DS_Document_Detail.TEXTS();
        item.ItemTexts.add(text);
        Map<String,Map<String,Object>> lineItemsMap = new Map<String,Map<String,Object>>();
        Map<String,Object> objectMap = new Map<String,Object>();
        objectMap.put('materialEntry', new PricebookEntry());
        item.ItemNumber = '10';
        item.HigherLevelItemNumber ='000000';
        objectMap.put('salesDocItem', item);
        lineItemsMap.put('1', objectMap);
		utility.salesDocLineItemMappingToSObject(testSObject, new ensxtx_DS_SalesDocAppSettings(), lineItemsMap);
        SBQQ__QuoteLine__c sfLineItem = new SBQQ__QuoteLine__c();
        sfLineItem.ensxtx_SAP_Configuration__c = JSON.serialize(new ensxtx_DS_Document_Detail.CPQ_VC_ITEM_CONFIGURATION());
        objectMap.put('sfLineItem', sfLineItem);
        lineItemsMap.put('1', objectMap);
		utility.salesDocLineItemMappingToSObject(testSObject, new ensxtx_DS_SalesDocAppSettings(), lineItemsMap);
        objectMap.put('clearSfLineItem', sfLineItem);
        lineItemsMap.put('1', objectMap);
		utility.salesDocLineItemMappingToSObject(testSObject, new ensxtx_DS_SalesDocAppSettings(), lineItemsMap);
		Test.stopTest();
    }

    @isTest
    static void test_compareSAPSimulateVsSObject()
    {
    	Test.startTest();
        ensxtx_DS_Document_Detail salesDocDetail = new ensxtx_DS_Document_Detail();
        ensxtx_DS_Document_Detail salesDocDetailFromSF = new ensxtx_DS_Document_Detail();
        ensxtx_UTIL_SFCPQQuote utility = new ensxtx_UTIL_SFCPQQuote();
        ensxtx_DS_Document_Detail.ITEMS item1 = new ensxtx_DS_Document_Detail.ITEMS();
        item1.ItemNumber = '10';
        item1.HigherLevelItemNumber = '0';
        item1.Material = 'Mat1';
        item1.MaterialEntered = 'Mat1';
        item1.isPriceEditable = false;
        item1.NetItemPrice = 1;
        item1.CostInDocCurrency = 1;
        item1.OrderQuantity = 1;
        ensxtx_DS_Document_Detail.ITEMS item2 = new ensxtx_DS_Document_Detail.ITEMS();
        item2.ItemNumber = '20';
        item2.HigherLevelItemNumber = '0';
        item2.Material = 'Mat2';
        item2.MaterialEntered = 'Mat2';
        item2.NetItemPrice = 1;
        item2.CostInDocCurrency = 1;
        item2.OrderQuantity = 1;
        ensxtx_DS_Document_Detail.ITEMS sfIitem1 = new ensxtx_DS_Document_Detail.ITEMS();
        sfIitem1.ItemNumber = '10';
        sfIitem1.HigherLevelItemNumber = '0';
        sfIitem1.Material = 'Mat1';
        sfIitem1.MaterialEntered = 'Mat1';
        sfIitem1.isPriceEditable = false;
        sfIitem1.NetItemPrice = 2;
        sfIitem1.CostInDocCurrency = 2;
        sfIitem1.OrderQuantity = 2;
        ensxtx_DS_Document_Detail.ITEMS sfIitem2 = new ensxtx_DS_Document_Detail.ITEMS();
        sfIitem2.ItemNumber = '20';
        sfIitem2.HigherLevelItemNumber = '0';
        sfIitem2.Material = 'Mat3';
        sfIitem2.MaterialEntered = 'Mat3';
        sfIitem2.NetItemPrice = 1;
        sfIitem2.CostInDocCurrency = 1;
        sfIitem2.OrderQuantity = 1;
        salesDocDetail.ITEMS.add(item1);
        salesDocDetail.ITEMS.add(item2);
        salesDocDetailFromSF.ITEMS.add(sfIitem1);
        salesDocDetailFromSF.ITEMS.add(sfIitem2);
		utility.compareSAPSimulateVsSObject(salesDocDetail, salesDocDetailFromSF, new ensxtx_DS_SalesDocAppSettings());
        sfIitem1.OrderQuantity = 1;
		utility.compareSAPSimulateVsSObject(salesDocDetail, salesDocDetailFromSF, new ensxtx_DS_SalesDocAppSettings());
        sfIitem1.CostInDocCurrency = 1;
        sfIitem1.OrderQuantity = 2;
		utility.compareSAPSimulateVsSObject(salesDocDetail, salesDocDetailFromSF, new ensxtx_DS_SalesDocAppSettings());
        sfIitem1.NetItemPrice = 1;
        sfIitem1.CostInDocCurrency = 2;
		utility.compareSAPSimulateVsSObject(salesDocDetail, salesDocDetailFromSF, new ensxtx_DS_SalesDocAppSettings());
        sfIitem1.NetItemPrice = 2;
        sfIitem1.CostInDocCurrency = 1;
        sfIitem1.OrderQuantity = 1;
		utility.compareSAPSimulateVsSObject(salesDocDetail, salesDocDetailFromSF, new ensxtx_DS_SalesDocAppSettings());
        sfIitem1.NetItemPrice = 1;
        sfIitem1.CostInDocCurrency = 2;
        sfIitem1.OrderQuantity = 1;
		utility.compareSAPSimulateVsSObject(salesDocDetail, salesDocDetailFromSF, new ensxtx_DS_SalesDocAppSettings());
        sfIitem1.NetItemPrice = 1;
        sfIitem1.CostInDocCurrency = 1;
        sfIitem1.OrderQuantity = 2;
		utility.compareSAPSimulateVsSObject(salesDocDetail, salesDocDetailFromSF, new ensxtx_DS_SalesDocAppSettings());
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
        ensxtx_UTIL_SFCPQQuote utility = new ensxtx_UTIL_SFCPQQuote();
		utility.mapCustomPricingToSalesDoc(salesDocDetail, new ensxtx_DS_SalesDocAppSettings());
		Test.stopTest();
    }

    @isTest
    static void test_mapChildBomFields()
    {
    	Test.startTest();
        ensxtx_DS_Document_Detail salesDocDetail = new ensxtx_DS_Document_Detail();
        ensxtx_DS_Document_Detail salesDocDetailFromSF = new ensxtx_DS_Document_Detail();
        ensxtx_DS_Document_Detail.ITEMS item1 = new ensxtx_DS_Document_Detail.ITEMS();
        item1.ItemNumber = '10';
        item1.HigherLevelItemNumber = '0';
        item1.Material = 'Mat1';
        item1.MaterialEntered = 'Mat1';
        item1.OrderQuantity = 1;
        ensxtx_DS_Document_Detail.ITEMS item2 = new ensxtx_DS_Document_Detail.ITEMS();
        item2.ItemNumber = '20';
        item2.HigherLevelItemNumber = '10';
        item2.Material = 'Mat2';
        item2.MaterialEntered = 'Mat2';
        item2.OrderQuantity = 1;
        ensxtx_DS_Document_Detail.ITEMS item3 = new ensxtx_DS_Document_Detail.ITEMS();
        item3.ItemNumber = '30';
        item3.HigherLevelItemNumber = '10';
        item3.Material = 'Mat3';
        item3.MaterialEntered = 'Mat3';
        item3.OrderQuantity = 1;
        salesDocDetail.ITEMS.add(item1);
        salesDocDetail.ITEMS.add(item2);
        salesDocDetail.ITEMS.add(item3);
        ensxtx_DS_Document_Detail.ITEMS item4 = new ensxtx_DS_Document_Detail.ITEMS();
        item4.ItemNumber = '10';
        item4.HigherLevelItemNumber = '0';
        item4.Material = 'Mat1';
        item4.MaterialEntered = 'Mat1';
        item4.OrderQuantity = 2;
        ensxtx_DS_Document_Detail.ITEMS item5 = new ensxtx_DS_Document_Detail.ITEMS();
        item5.ItemNumber = '20';
        item5.HigherLevelItemNumber = '10';
        item5.Material = 'Mat2';
        item5.MaterialEntered = 'Mat2';
        item5.OrderQuantity = 2;
        ensxtx_DS_Document_Detail.ITEMS item6 = new ensxtx_DS_Document_Detail.ITEMS();
        item6.ItemNumber = '30';
        item6.HigherLevelItemNumber = '10';
        item6.Material = 'Mat4';
        item6.MaterialEntered = 'Mat4';
        item6.OrderQuantity = 2;
        salesDocDetailFromSF.ITEMS.add(item4);
        salesDocDetailFromSF.ITEMS.add(item5);
        salesDocDetailFromSF.ITEMS.add(item6);
        ensxtx_UTIL_SFCPQQuote utility = new ensxtx_UTIL_SFCPQQuote();
		utility.mapChildBomFields(salesDocDetail, salesDocDetailFromSF, new ensxtx_DS_SalesDocAppSettings());
		Test.stopTest();
    }

    private static List<SObject> lineItems = new List<SObject>();
    private static SBQQ__Quote__c createTestObjects()
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

        Account account = ensxtx_TSTU_SFTestObject.createTestAccount();
        account.AccountNumber = 'Test';
        ensxtx_TSTU_SFTestObject.upsertWithRetry(account);

        SBQQ.TriggerControl.disable();
        SBQQ__Quote__c quote = ensxtx_TSTU_SFCPQQuote.createTestQuote();
        quote.SBQQ__Account__c = account.Id;
        quote.SBQQ__Opportunity2__c = opp.Id;
        quote.SBQQ__PriceBook__c = pricebookId;
        quote.ensxtx_Ship_To_Number__c = 'ShipTo';
        quote.ensxtx_Bill_To_Number__c = 'BillTo';
        quote.ensxtx_Payer_Number__c = 'Payer';
        ensxtx_TSTU_SFTestObject.upsertWithRetry(quote);
        quote = [SELECT Id, SBQQ__Opportunity2__c, SBQQ__Account__c, ensxtx_SAP_Quote_Number__c FROM SBQQ__Quote__c WHERE Id = :quote.Id];
        quote.SBQQ__PriceBook__c = pricebookId;
        ensxtx_TSTU_SFTestObject.upsertWithRetry(quote);

        Product2 product = ensxtx_TSTU_SFTestObject.createTestProduct2();
        product.put(ensxtx_UTIL_SFProduct.MaterialFieldName, 'SAPMaterial');
        ensxtx_TSTU_SFTestObject.upsertWithRetry(product);

        SBQQ__ProductFeature__c productFeature = new SBQQ__ProductFeature__c();
        productFeature.put('Name', 'SAP BoM');
        productFeature.put('SBQQ__Number__c', 999);
        productFeature.put('SBQQ__MinOptionCount__c', 0);
        productFeature.put('SBQQ__OptionSelectionMethod__c', 'Dynamic');
        productFeature.put('SBQQ__Category__c', 'SAP BoM');
        ensxtx_TSTU_SFTestObject.upsertWithRetry(productFeature);

        List<SBQQ__QuoteLine__c> qlList = new List<SBQQ__QuoteLine__c>();
        SBQQ__QuoteLine__c ql1 = createTestObjectLines();
        ql1.SBQQ__Number__c = 1;
        ql1.SBQQ__Quote__c = quote.Id;
        ql1.SBQQ__Product__c = product.Id;
        ql1.ensxtx_Created_SAP_Item_Number__c = '10';
        qlList.add(ql1);
        SBQQ__QuoteLine__c ql2 = createTestObjectLines();
        ql2.SBQQ__Number__c = 3;
        ql2.SBQQ__Quote__c = quote.Id;
        ql2.SBQQ__Product__c = product.Id;
        ql2.SBQQ__DynamicOptionId__c = productFeature.Id + ':';
        qlList.add(ql2);
        SBQQ__QuoteLine__c ql3 = createTestObjectLines();
        ql3.SBQQ__Number__c = 4;
        ql3.SBQQ__Quote__c = quote.Id;
        ql3.SBQQ__Product__c = product.Id;
        ql3.ensxtx_SAP_Item_Number__c = null;
        qlList.add(ql3);
        ensxtx_TSTU_SFTestObject.upsertWithRetry(qlList);
        qlList.clear();
        SBQQ__QuoteLine__c ql4 = createTestObjectLines();
        ql4.SBQQ__Number__c = 2;
        ql4.SBQQ__Quote__c = quote.Id;
        ql4.SBQQ__RequiredBy__c = ql1.Id;
        ql4.SBQQ__Product__c = product.Id;
        ql4.ensxtx_Created_SAP_Item_Number__c = '10';
        qlList.add(ql4);
        SBQQ__QuoteLine__c ql5 = createTestObjectLines();
        ql5.SBQQ__Number__c = 5;
        ql5.SBQQ__Quote__c = quote.Id;
        ql5.SBQQ__RequiredBy__c = ql3.Id;
        ql5.SBQQ__Product__c = product.Id;
        ql5.ensxtx_Created_SAP_Item_Number__c = '10';
        qlList.add(ql5);
        ensxtx_TSTU_SFTestObject.upsertWithRetry(qlList);

        SBQQ.TriggerControl.enable();

        ensxtx_UTIL_SFCPQQuote utility = new ensxtx_UTIL_SFCPQQuote();
        lineItems = utility.getSObjectLineItems(quote.Id).values();
        return (SBQQ__Quote__c) utility.getSObject(quote.Id);
    }

    private static SBQQ__QuoteLine__c createTestObjectLines()
    {
        SBQQ__QuoteLine__c qli = ensxtx_TSTU_SFCPQQuote.createTestQuoteLine();
        qli.SBQQ__Number__c = 1;
		qli.SBQQ__Quantity__c = 10;
		qli.SBQQ__ListPrice__c = .95;
		qli.SBQQ__Description__c = 'test Desciption';
        qli.SBQQ__Discount__c = 10;
        qli.SBQQ__MarkupAmount__c = 5;
        qli.SBQQ__NetPrice__c = .95;
        qli.ensxtx_SAP_Item_Number__c = '1';
        qli.ensxtx_SAP_Configuration__c = 
            '{"plant":"plant",' + 
            '"OrderQuantity":1,' + 
            '"materialNumber":"Material1",' + 
            '"selectedCharacteristics":[{"Atwrt":"Atwrt","Atnam":"Atnam","UserModified":true,"CharacteristicID":"1"}]}';
        return qli;
    }

    public static SBQQ__Quote__c createTestQuote()
    {
        SBQQ__Quote__c quote = new SBQQ__Quote__c();
        return quote;
    }

    public static SBQQ__QuoteLine__c createTestQuoteLine()
    {
        SBQQ__QuoteLine__c quoteLine = new SBQQ__QuoteLine__c();
        return quoteLine;
    }
}