@isTest
public class ensxtx_TSTE_CPQ_QuoteCalculationServV2 {
    public class Mockensxtx_SBO_EnosixPricing_Detail implements
        ensxsdk.EnosixFramework.DetailSBOInitMock,
        ensxsdk.EnosixFramework.DetailSBOCommandMock,
        ensxsdk.EnosixFramework.DetailSBOGetMock,
        ensxsdk.EnosixFramework.DetailSBOSaveMock
    {
        private boolean success = true;

        public void setSuccess(boolean successful)
        {
            this.success = successful;
        }

        private boolean throwException = false;

        public void setThrowException(boolean throwException)
        {
            this.throwException = throwException;
        }

        public ensxsdk.EnosixFramework.DetailObject executeInitialize(ensxsdk.EnosixFramework.DetailObject initialState) 
        { 
            return null;
        }
        
        public ensxsdk.EnosixFramework.DetailObject executeCommand(String command, ensxsdk.EnosixFramework.DetailObject obj) 
        { 
            if (throwException)
            {
                throw new ensxtx_ENSX_Exceptions.SimulationException();
            }
            return this.executeGetDetail(obj);
        }

        public ensxsdk.EnosixFramework.DetailObject executeGetDetail(object key) 
        { 
            ensxtx_SBO_EnosixPricing_Detail.EnosixOpportunityPricing result = new ensxtx_SBO_EnosixPricing_Detail.EnosixOpportunityPricing();           
            result.setSuccess(success);
            
            ensxtx_SBO_EnosixPricing_Detail.ITEMS topItem1 = new ensxtx_SBO_EnosixPricing_Detail.ITEMS();
            topItem1.ItemNumber = '10';
            topItem1.Material = 'MAT0';
            topItem1.HigherLevelItemNumber = '0';
            topItem1.CostInDocCurrency = 5;
            topItem1.OrderQuantity = 1;
            topItem1.NetItemPrice = 10;
            
            ensxtx_SBO_EnosixPricing_Detail.ITEMS childItem1 = new ensxtx_SBO_EnosixPricing_Detail.ITEMS();
            childItem1.ItemNumber = '11';
            childItem1.Material = 'MAT1';
            childItem1.HigherLevelItemNumber = '10';
            childItem1.CostInDocCurrency = 6;
            childItem1.OrderQuantity = 1;
            childItem1.NetItemPrice = 10;

            ensxtx_SBO_EnosixPricing_Detail.ITEMS childItem2 = new ensxtx_SBO_EnosixPricing_Detail.ITEMS();
            childItem2.ItemNumber = '12';
            childItem2.Material = 'MAT2';
            childItem2.HigherLevelItemNumber = '10';
            childItem2.CostInDocCurrency = 5;
            childItem2.OrderQuantity = 2;
            childItem2.NetItemPrice = 10;

            ensxtx_SBO_EnosixPricing_Detail.ITEMS childItem3 = new ensxtx_SBO_EnosixPricing_Detail.ITEMS();
            childItem3.ItemNumber = '13';
            childItem3.Material = 'MAT2';
            childItem3.HigherLevelItemNumber = '10';
            childItem3.CostInDocCurrency = 5;
            childItem3.OrderQuantity = 2;
            childItem3.NetItemPrice = 10;

            ensxtx_SBO_EnosixPricing_Detail.ITEMS childItem4 = new ensxtx_SBO_EnosixPricing_Detail.ITEMS();
            childItem4.ItemNumber = '14';
            childItem4.Material = 'MAT2';
            childItem4.HigherLevelItemNumber = '10';
            childItem4.CostInDocCurrency = 5;
            childItem4.OrderQuantity = 2;
            childItem4.NetItemPrice = 10;
            
            ensxtx_SBO_EnosixPricing_Detail.ITEMS childItem5 = new ensxtx_SBO_EnosixPricing_Detail.ITEMS();
            childItem5.ItemNumber = '15';
            childItem5.Material = 'MAT3';
            childItem5.HigherLevelItemNumber = '14';
            childItem5.CostInDocCurrency = 5;
            childItem5.OrderQuantity = 2;
            childItem5.NetItemPrice = 10;
            
            ensxtx_SBO_EnosixPricing_Detail.ITEMS childItem6 = new ensxtx_SBO_EnosixPricing_Detail.ITEMS();
            childItem6.ItemNumber = '16';
            childItem6.Material = 'MAT3';
            childItem6.HigherLevelItemNumber = '14';
            childItem6.CostInDocCurrency = 5;
            childItem6.OrderQuantity = 2;
            childItem6.NetItemPrice = 10;
            
            ensxtx_SBO_EnosixPricing_Detail.ITEMS topItem2 = new ensxtx_SBO_EnosixPricing_Detail.ITEMS();
            topItem2.ItemNumber = '30';
            topItem2.Material = 'MAT0';
            topItem2.HigherLevelItemNumber = '0';
            topItem2.CostInDocCurrency = 5;
            topItem2.OrderQuantity = 1;
            topItem2.NetItemPrice = 10;
            
            ensxtx_SBO_EnosixPricing_Detail.ITEMS childItem7 = new ensxtx_SBO_EnosixPricing_Detail.ITEMS();
            childItem7.ItemNumber = '21';
            childItem7.Material = 'MAT1';
            childItem7.HigherLevelItemNumber = '30';
            childItem7.CostInDocCurrency = 6;
            childItem7.OrderQuantity = 1;
            childItem7.NetItemPrice = 10;

            ensxtx_SBO_EnosixPricing_Detail.ITEMS childItem8 = new ensxtx_SBO_EnosixPricing_Detail.ITEMS();
            childItem8.ItemNumber = '22';
            childItem8.Material = 'MAT2';
            childItem8.HigherLevelItemNumber = '30';
            childItem8.CostInDocCurrency = 5;
            childItem8.OrderQuantity = 2;
            childItem8.NetItemPrice = 10;

            ensxtx_SBO_EnosixPricing_Detail.ITEMS childItem9 = new ensxtx_SBO_EnosixPricing_Detail.ITEMS();
            childItem9.ItemNumber = '23';
            childItem9.Material = 'MAT2';
            childItem9.HigherLevelItemNumber = '30';
            childItem9.CostInDocCurrency = 5;
            childItem9.OrderQuantity = 2;
            childItem9.NetItemPrice = 10;

            result.ITEMS.add(topItem1);
            result.ITEMS.add(childItem1);
            result.ITEMS.add(childItem2);
            result.ITEMS.add(childItem3);
            result.ITEMS.add(childItem4);
            result.ITEMS.add(childItem5);
            result.ITEMS.add(childItem6);
            result.ITEMS.add(topItem2);
            result.ITEMS.add(childItem7);
            result.ITEMS.add(childItem8);
            result.ITEMS.add(childItem9);

            ensxtx_SBO_EnosixPricing_Detail.ITEMS_SCHEDULE itemSched = new ensxtx_SBO_EnosixPricing_Detail.ITEMS_SCHEDULE();
        	itemSched.ItemNumber = '10';
        	itemSched.ConfirmedQuantity = 1;
        	result.ITEMS_SCHEDULE.add(itemSched);

            ensxtx_SBO_EnosixPricing_Detail.CONDITIONS itemCond = new ensxtx_SBO_EnosixPricing_Detail.CONDITIONS();
            itemCond.ConditionItemNumber = '1';
            itemCond.ConditionType = 'TEST';
            itemCond.Rate = 2;
            result.CONDITIONS.add(itemCond);
            ensxtx_SBO_EnosixPricing_Detail.CONDITIONS itemCond2 = new ensxtx_SBO_EnosixPricing_Detail.CONDITIONS();
            itemCond2.ConditionItemNumber = '1';
            itemCond2.ConditionType = 'SECOND';
            itemCond2.Rate = 10;
            result.CONDITIONS.add(itemCond2);
            
            return result;
        }

        public ensxsdk.EnosixFramework.DetailObject executeSave(ensxsdk.EnosixFramework.DetailObject obj) { 
            ensxtx_SBO_EnosixPricing_Detail.EnosixOpportunityPricing result = new ensxtx_SBO_EnosixPricing_Detail.EnosixOpportunityPricing();
            result.setSuccess(success);
            return result;
        }
    }

    @isTest
    static public void test_doPost()
    {
        string TEST_JSON = '{}';
        ensxtx_UTIL_AppSettings.settingsMap.put(ensxtx_UTIL_AppSettings.Prefix + ensxtx_UTIL_AppSettings.CPQV2 + ensxtx_UTIL_AppSettings.Suffix, (Map<String, Object>)JSON.deserializeUntyped(TEST_JSON));
        ensxtx_UTIL_AppSettings.settingsMap.put(ensxtx_UTIL_AppSettings.Prefix + ensxtx_UTIL_AppSettings.VC + ensxtx_UTIL_AppSettings.Suffix, (Map<String, Object>)JSON.deserializeUntyped('{}'));

        Mockensxtx_SBO_EnosixPricing_Detail sbo = new Mockensxtx_SBO_EnosixPricing_Detail();
        ensxsdk.EnosixFramework.setMock(ensxtx_SBO_EnosixPricing_Detail.class, sbo);

        Test.startTest();
        String response = ensxtx_ENSX_CPQ_QuoteCalculationServV2.doPost(JSON.serialize(new SBQQ__Quote__c()), JSON.serialize(new List<SBQQ__QuoteLine__c>()), true);
        response = ensxtx_ENSX_CPQ_QuoteCalculationServV2.doPost('Bad Data', null, true);

        createTestObjects();
        response = ensxtx_ENSX_CPQ_QuoteCalculationServV2.doPost(JSON.serialize(quote), JSON.serialize(qlList), false);
        Test.stopTest();
    }
    
    static SBQQ__Quote__c quote;
    static List<SBQQ__QuoteLine__c> qlList;

    private static void createTestObjects()
    {
        SBQQ.TriggerControl.disable();

        ensxtx_DS_SalesDocAppSettings appSettings = new ensxtx_DS_SalesDocAppSettings();
        appSettings.Header = new ensxtx_DS_SalesDocAppSettings.DocumentSetting();
        appSettings.item = new ensxtx_DS_SalesDocAppSettings.DocumentSetting();
        appSettings.itemNumberIncrement = 100;
        appSettings.SBODetailType = 'Pricing';
        appSettings.SAPDocType = 'Quote';

        List<Product2> prodList = new List<Product2>();
        Product2 prod0 = ensxtx_TSTU_SFTestObject.createTestProduct2();
        prod0.put(ensxtx_UTIL_SFProduct.MaterialFieldName, null);
        prodList.add(prod0);

        Product2 prod1 = ensxtx_TSTU_SFTestObject.createTestProduct2();
        prod1.SBQQ__ExternallyConfigurable__c = true;
        String configurableMaterialField = ensxtx_UTIL_SFProduct.getConfigurableMaterialField();
        if (String.isNotEmpty(configurableMaterialField)) prod1.put(configurableMaterialField, true);
        prodList.add(prod1);

        Product2 prod2 = ensxtx_TSTU_SFTestObject.createTestProduct2();
        prod2.SBQQ__ExternallyConfigurable__c = true;
        if (String.isNotEmpty(configurableMaterialField)) prod2.put(configurableMaterialField, true);
        prodList.add(prod2);
        ensxtx_TSTU_SFTestObject.upsertWithRetry(prodList);

        SBQQ__ProductFeature__c newProductFeature = new SBQQ__ProductFeature__c();
        newProductFeature.put('Name', 'SAP BoM');
        newProductFeature.put('SBQQ__Number__c', 999);
        newProductFeature.put('SBQQ__MinOptionCount__c', 0);
        newProductFeature.put('SBQQ__OptionSelectionMethod__c', 'Dynamic');
        newProductFeature.put('SBQQ__ConfiguredSKU__c', prod1.Id);
        newProductFeature.put('SBQQ__Category__c', 'SAP BoM');
        ensxtx_TSTU_SFTestObject.upsertWithRetry(newProductFeature);

        List<Object> optionsList = new List<Object>();
        Map<String, Object> optMap = new Map<String, Object>();
        SBQQ__ProductOption__c opt = new SBQQ__ProductOption__c();
        opt.SBQQ__OptionalSKU__c = prod1.Id;
        opt.SBQQ__Number__c = 1;
        ensxtx_TSTU_SFTestObject.upsertWithRetry(opt);
        optMap.put('optionId',opt.Id);
        optionsList.add(optMap);
        String optionsListJSON = JSON.serialize(optionsList);

        Id pricebookId = ensxtx_UTIL_Pricebook.getStandardPriceBookId();

        Account account = ensxtx_TSTU_SFTestObject.createTestAccount();
        account.AccountNumber = 'Test';
        ensxtx_TSTU_SFTestObject.upsertWithRetry(account);

        quote = ensxtx_TSTU_SFCPQQuote.createTestQuote();
        quote.SBQQ__Account__c = account.Id;
        quote.SBQQ__PriceBook__c = pricebookId;
        quote.ensxtx_Ship_To_Number__c = 'ShipTo';
        quote.ensxtx_Bill_To_Number__c = 'BillTo';
        quote.ensxtx_Payer_Number__c = 'Payer';
        ensxtx_TSTU_SFTestObject.upsertWithRetry(quote);
        ensxtx_UTIL_SFCPQQuote utility = new ensxtx_UTIL_SFCPQQuote();
        quote = (SBQQ__Quote__c) utility.getSObject(quote.Id);
        quote.SBQQ__PriceBook__c = pricebookId;

        ensxtx_TSTU_SFTestObject.upsertWithRetry(quote);

        qlList = new List<SBQQ__QuoteLine__c>();
        SBQQ__QuoteLine__c qli1 = ensxtx_TSTU_SFCPQQuote.createTestQuoteLine();
        qli1.SBQQ__Quote__c = quote.Id;
        qli1.SBQQ__Number__c = 1;
        qli1.SBQQ__Product__c = prod2.Id;
        qli1.ensxtx_SAP_Item_Number__c = '100';
        qlList.add(qli1);

        ensxtx_DS_Document_Detail.CPQ_VC_ITEM_CONFIGURATION conf = new ensxtx_DS_Document_Detail.CPQ_VC_ITEM_CONFIGURATION();
        conf.ParentLineItem = 1;

        SBQQ__ProductFeature__c productFeature = new SBQQ__ProductFeature__c();
        productFeature.put('Name', 'SAP BoM');
        productFeature.put('SBQQ__Number__c', 999);
        productFeature.put('SBQQ__MinOptionCount__c', 0);
        productFeature.put('SBQQ__OptionSelectionMethod__c', 'Dynamic');
        productFeature.put('SBQQ__Category__c', 'SAP BoM');
        ensxtx_TSTU_SFTestObject.upsertWithRetry(productFeature);

        SBQQ__QuoteLine__c qli2 = ensxtx_TSTU_SFCPQQuote.createTestQuoteLine();
        qli2.SBQQ__Quote__c = quote.Id;
        qli2.SBQQ__Number__c = 2;
        qli2.SBQQ__Product__c = prod1.Id;
        qli2.ensxtx_SAP_Configuration__c = JSON.serialize(conf);
        qli2.ensxtx_SAP_Item_Number__c = '101';
        qli2.SBQQ__DynamicOptionId__c = productFeature.Id + ':';
        qlList.add(qli2);

        conf.ParentLineItem = 2;
        SBQQ__QuoteLine__c qli3 = ensxtx_TSTU_SFCPQQuote.createTestQuoteLine();
        qli3.SBQQ__Quote__c = quote.Id;
        qli3.SBQQ__Number__c = 3;
        qli3.SBQQ__Product__c = prod2.Id;
        qli3.ensxtx_SAP_Configuration__c = JSON.serialize(conf);
        qli3.ensxtx_SAP_Item_Number__c = '102';
        qli3.SBQQ__DynamicOptionId__c = productFeature.Id + ':';
        qlList.add(qli3);

        SBQQ__QuoteLine__c qli4 = ensxtx_TSTU_SFCPQQuote.createTestQuoteLine();
        qli4.SBQQ__Quote__c = quote.Id;
        qli4.SBQQ__Number__c = 4;
        qli4.SBQQ__Product__c = prod2.Id;
        qli4.ensxtx_SAP_Configuration__c = JSON.serialize(conf);
        qli4.ensxtx_SAP_Item_Number__c = '103';
        qli4.SBQQ__DynamicOptionId__c = productFeature.Id + ':';
        qlList.add(qli4);

        SBQQ__QuoteLine__c qli5 = ensxtx_TSTU_SFCPQQuote.createTestQuoteLine();
        qli5.SBQQ__Quote__c = quote.Id;
        qli5.SBQQ__Number__c = 5;
        qli5.SBQQ__Product__c = prod0.Id;
        qlList.add(qli5);

        conf.ParentLineItem = 5;

        SBQQ__QuoteLine__c qli6 = ensxtx_TSTU_SFCPQQuote.createTestQuoteLine();
        qli6.SBQQ__Quote__c = quote.Id;
        qli6.SBQQ__Number__c = 6;
        qli6.SBQQ__Product__c = prod2.Id;
        qli6.ensxtx_SAP_Item_Number__c = '200';
        qli6.ensxtx_SAP_Configuration__c = JSON.serialize(conf);
        qlList.add(qli6);

        conf.ParentLineItem = 6;

        SBQQ__QuoteLine__c qli7 = ensxtx_TSTU_SFCPQQuote.createTestQuoteLine();
        qli7.SBQQ__Quote__c = quote.Id;
        qli7.SBQQ__Number__c = 7;
        qli7.SBQQ__Product__c = prod1.Id;
        qli7.ensxtx_SAP_Item_Number__c = '201';
        qli7.SBQQ__DynamicOptionId__c = productFeature.Id + ':';
        qli7.ensxtx_SAP_Configuration__c = JSON.serialize(conf);
        qlList.add(qli7);

        conf.ParentLineItem = 5;

        SBQQ__QuoteLine__c qli8 = ensxtx_TSTU_SFCPQQuote.createTestQuoteLine();
        qli8.SBQQ__Quote__c = quote.Id;
        qli8.SBQQ__Number__c = 8;
        qli8.SBQQ__Product__c = prod1.Id;
        qli8.ensxtx_SAP_Item_Number__c = '300';
        qli8.ensxtx_SAP_Configuration__c = JSON.serialize(conf);
        qlList.add(qli8);

        conf.ParentLineItem = 8;

        SBQQ__QuoteLine__c qli9 = ensxtx_TSTU_SFCPQQuote.createTestQuoteLine();
        qli9.SBQQ__Quote__c = quote.Id;
        qli9.SBQQ__Number__c = 9;
        qli9.SBQQ__Product__c = prod1.Id;
        qli9.ensxtx_SAP_Configuration__c = JSON.serialize(conf);
        qli9.ensxtx_SAP_Item_Number__c = '301';
        qli9.SBQQ__DynamicOptionId__c = productFeature.Id + ':';
        qli9.ensxtx_SAP_Configuration__c = JSON.serialize(conf);
        qlList.add(qli9);

        conf.ParentLineItem = null;

        SBQQ__QuoteLine__c qli10 = ensxtx_TSTU_SFCPQQuote.createTestQuoteLine();
        qli10.SBQQ__Quote__c = quote.Id;
        qli10.SBQQ__Number__c = 10;
        qli10.SBQQ__Product__c = prod0.Id;
        qlList.add(qli10);

        conf.ParentLineItem = 10;

        SBQQ__QuoteLine__c qli11 = ensxtx_TSTU_SFCPQQuote.createTestQuoteLine();
        qli11.SBQQ__Quote__c = quote.Id;
        qli11.SBQQ__Number__c = 11;
        qli11.SBQQ__Product__c = prod1.Id;
        qli11.ensxtx_SAP_Item_Number__c = '400';
        qli11.ensxtx_SAP_Configuration__c = JSON.serialize(conf);
        qlList.add(qli11);

        conf.ParentLineItem = 11;

        SBQQ__QuoteLine__c qli12 = ensxtx_TSTU_SFCPQQuote.createTestQuoteLine();
        qli12.SBQQ__Quote__c = quote.Id;
        qli12.SBQQ__Number__c = 12;
        qli12.SBQQ__Product__c = prod1.Id;
        qli12.ensxtx_SAP_Item_Number__c = '401';
        qli12.ensxtx_SAP_Configuration__c = JSON.serialize(conf);
        qlList.add(qli12);

        SBQQ__QuoteLine__c qliNew = ensxtx_TSTU_SFCPQQuote.createTestQuoteLine();
        qliNew.SBQQ__Quote__c = quote.Id;
        qliNew.SBQQ__Number__c = 13;
        qliNew.SBQQ__Product__c = prod1.Id;
        qliNew.ensxtx_SAP_Item_Number__c = '500';

        ensxtx_TSTU_SFTestObject.upsertWithRetry(qlList);

        qli2.put('SBQQ__RequiredBy__c', qli1.Id);
        qli3.put('SBQQ__RequiredBy__c', qli2.Id);
        qli4.put('SBQQ__RequiredBy__c', qli1.Id);
        qli6.put('SBQQ__RequiredBy__c', qli5.Id);
        qli7.put('SBQQ__RequiredBy__c', qli6.Id);
        qli8.put('SBQQ__RequiredBy__c', qli5.Id);
        qli9.put('SBQQ__RequiredBy__c', qli8.Id);
        qli11.put('SBQQ__RequiredBy__c', qli10.Id);
        qli12.put('SBQQ__RequiredBy__c', qli11.Id);
        
        ensxtx_DS_Document_Detail.CONFIG chars = new ensxtx_DS_Document_Detail.CONFIG();
        chars.CharacteristicID = 'TEST';
        chars.CharacteristicName = 'TEST';
        chars.CharacteristicValue = 'TEST';
        chars.UserModified = true;

        List<ensxtx_DS_Document_Detail.CONFIG> lstChars = new List<ensxtx_DS_Document_Detail.CONFIG>();
        lstChars.add(chars);

        conf = new ensxtx_DS_Document_Detail.CPQ_VC_ITEM_CONFIGURATION();
        conf.plant = 'PLANT';
        conf.materialNumber = 'TEST';
        conf.selectedCharacteristics = lstChars;
        conf.SalesDocumentCurrency = 'TEST';
        conf.OrderQuantity = 0;

        SBQQ.TriggerControl.enable();
    }    

}