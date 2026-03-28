@isTest 
public with sharing class ensxtx_TSTU_CPQ_QuotePricingV2 {
    @testSetup 
    static void setup(){
        UserRole role = new UserRole();
        role.Name = 'Test';
        Database.insert(role);
        Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
        User testUser = new User(
            UserRoleId = role.Id,
            ProfileId = profile1.Id,
            Username = 'User.Test@enosix.com',
            Alias = 'utest',
            Email='User.Test@enosix.com',
            EmailEncodingKey='UTF-8',
            Firstname='Test',
            Lastname='Tester',
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US',
            TimeZoneSidKey='America/Chicago'
        );
        Database.insert(testUser);

        PermissionSetLicense psl1=[SELECT Id from PermissionSetLicense WHERE PermissionSetLicense.MasterLabel='Salesforce CPQ License'];
        insert new PermissionSetLicenseAssign(AssigneeId = testUser.id, PermissionSetLicenseId = psl1.Id);
        PermissionSet ps1 = [SELECT Id FROM PermissionSet WHERE Name = 'ensxtx_enosiX_CPQ_User'];
        insert new PermissionSetAssignment(AssigneeId = testUser.id, PermissionSetId = ps1.Id);
    }      
    
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
            obj.setSuccess(success);
            return this.executeGetDetail(obj);
        }

        public ensxsdk.EnosixFramework.DetailObject executeGetDetail(object key) 
        { 
            if (throwException)
            {
                throw new ensxtx_ENSX_Exceptions.SimulationException();
            }

            ensxtx_SBO_EnosixPricing_Detail.EnosixOpportunityPricing result = new ensxtx_SBO_EnosixPricing_Detail.EnosixOpportunityPricing();           
            result.setSuccess(success);
            
            ensxtx_SBO_EnosixPricing_Detail.ITEMS topItem = new ensxtx_SBO_EnosixPricing_Detail.ITEMS();
            topItem.ItemNumber = '100';
            topItem.Material = 'topItem';
            topItem.MaterialEntered = 'topItem';
            topItem.HigherLevelItemNumber = '0';
            topItem.CostInDocCurrency = 5;
            topItem.OrderQuantity = 1;
            topItem.NetItemPrice = 10;
            topItem.NetOrderValue = 10;
            
            ensxtx_SBO_EnosixPricing_Detail.ITEMS childItem = new ensxtx_SBO_EnosixPricing_Detail.ITEMS();
            childItem.ItemNumber = '101';
            childItem.Material = 'MAT1';
            childItem.MaterialEntered = 'MAT1';
            childItem.HigherLevelItemNumber = '100';
            childItem.BillOfMaterial = '100';
            childItem.CostInDocCurrency = 6;
            childItem.OrderQuantity = 1;
            childItem.NetItemPrice = 10;
            childItem.NetOrderValue = 10;

            ensxtx_SBO_EnosixPricing_Detail.ITEMS childItem2 = new ensxtx_SBO_EnosixPricing_Detail.ITEMS();
            childItem2.ItemNumber = '102';
            childItem2.Material = 'MAT2';
            childItem2.MaterialEntered = 'MAT2';
            childItem2.HigherLevelItemNumber = '100';
            childItem2.BillOfMaterial = '100';
            childItem2.CostInDocCurrency = 5;
            childItem2.OrderQuantity = 2;
            childItem2.NetItemPrice = 10;
            childItem2.NetOrderValue = 10;

            ensxtx_SBO_EnosixPricing_Detail.ITEMS childItem3 = new ensxtx_SBO_EnosixPricing_Detail.ITEMS();
            childItem3.ItemNumber = '103';
            childItem3.Material = 'MAT2';
            childItem3.MaterialEntered = 'MAT2';
            childItem3.HigherLevelItemNumber = '100';
            childItem3.BillOfMaterial = '100';
            childItem3.CostInDocCurrency = 5;
            childItem3.OrderQuantity = 2;
            childItem3.NetItemPrice = 10;
            childItem3.NetOrderValue = 10;

            ensxtx_SBO_EnosixPricing_Detail.ITEMS childItem4 = new ensxtx_SBO_EnosixPricing_Detail.ITEMS();
            childItem4.ItemNumber = '104';
            childItem4.Material = 'MAT2';
            childItem4.MaterialEntered = 'MAT2';
            childItem4.HigherLevelItemNumber = '101';
            childItem4.BillOfMaterial = '101';
            childItem4.CostInDocCurrency = 5;
            childItem4.OrderQuantity = 2;
            childItem4.NetItemPrice = 10;
            childItem4.NetOrderValue = 10;
                        
            ensxtx_SBO_EnosixPricing_Detail.ITEMS topItem2 = new ensxtx_SBO_EnosixPricing_Detail.ITEMS();
            topItem2.ItemNumber = '200';
            topItem2.Material = 'topItem2';
            topItem2.MaterialEntered = 'topItem2';
            topItem2.HigherLevelItemNumber = '0';
            topItem2.CostInDocCurrency = 5;
            topItem2.OrderQuantity = 1;
            topItem2.NetItemPrice = 10;
            topItem2.NetOrderValue = 10;
            
            ensxtx_SBO_EnosixPricing_Detail.ITEMS childItem5 = new ensxtx_SBO_EnosixPricing_Detail.ITEMS();
            childItem5.ItemNumber = '201';
            childItem5.Material = 'MAT1';
            childItem5.MaterialEntered = 'MAT1';
            childItem5.HigherLevelItemNumber = '200';
            childItem5.BillOfMaterial = '200';
            childItem5.CostInDocCurrency = 6;
            childItem5.OrderQuantity = 1;
            childItem5.NetItemPrice = 10;
            childItem5.NetOrderValue = 10;
                        
            ensxtx_SBO_EnosixPricing_Detail.ITEMS topItem3 = new ensxtx_SBO_EnosixPricing_Detail.ITEMS();
            topItem3.ItemNumber = '300';
            topItem3.Material = 'topItem3';
            topItem3.MaterialEntered = 'topItem3';
            topItem3.HigherLevelItemNumber = '0';
            topItem3.CostInDocCurrency = 5;
            topItem3.OrderQuantity = 1;
            topItem3.NetItemPrice = 10;
            topItem3.NetOrderValue = 10;
            
            ensxtx_SBO_EnosixPricing_Detail.ITEMS childItem6 = new ensxtx_SBO_EnosixPricing_Detail.ITEMS();
            childItem6.ItemNumber = '301';
            childItem6.Material = 'MAT1';
            childItem6.MaterialEntered = 'MAT1';
            childItem6.HigherLevelItemNumber = '300';
            childItem6.BillOfMaterial = '300';
            childItem6.CostInDocCurrency = 6;
            childItem6.OrderQuantity = 1;
            childItem6.NetItemPrice = 10;
            childItem6.NetOrderValue = 10;
                        
            ensxtx_SBO_EnosixPricing_Detail.ITEMS topItem4 = new ensxtx_SBO_EnosixPricing_Detail.ITEMS();
            topItem4.ItemNumber = '400';
            topItem4.Material = 'topItem4';
            topItem4.MaterialEntered = 'topItem4';
            topItem4.HigherLevelItemNumber = '0';
            topItem4.CostInDocCurrency = 5;
            topItem4.OrderQuantity = 1;
            topItem4.NetItemPrice = 10;
            topItem4.NetOrderValue = 10;
            
            ensxtx_SBO_EnosixPricing_Detail.ITEMS childItem7 = new ensxtx_SBO_EnosixPricing_Detail.ITEMS();
            childItem7.ItemNumber = '401';
            childItem7.Material = 'MAT1';
            childItem7.MaterialEntered = 'MAT1';
            childItem7.HigherLevelItemNumber = '400';
            childItem7.BillOfMaterial = '400';
            childItem7.CostInDocCurrency = 6;
            childItem7.OrderQuantity = 1;
            childItem7.NetItemPrice = 10;
            childItem7.NetOrderValue = 10;
                        
            ensxtx_SBO_EnosixPricing_Detail.ITEMS topItem5 = new ensxtx_SBO_EnosixPricing_Detail.ITEMS();
            topItem5.ItemNumber = '500';
            topItem5.Material = 'topItem5';
            topItem5.MaterialEntered = 'topItem5';
            topItem5.HigherLevelItemNumber = '0';
            topItem5.CostInDocCurrency = 5;
            topItem5.OrderQuantity = 1;
            topItem5.NetItemPrice = 10;
            topItem5.NetOrderValue = 10;

            result.ITEMS.add(topItem);
            result.ITEMS.add(childItem);
            result.ITEMS.add(childItem2);
            result.ITEMS.add(childItem3);
            result.ITEMS.add(childItem4);
            result.ITEMS.add(topItem2);
            result.ITEMS.add(childItem5);
            result.ITEMS.add(topItem3);
            result.ITEMS.add(childItem6);
            result.ITEMS.add(topItem4);
            result.ITEMS.add(childItem7);
            result.ITEMS.add(topItem5);
            
            ensxtx_SBO_EnosixPricing_Detail.ITEMS_SCHEDULE itemSched = new ensxtx_SBO_EnosixPricing_Detail.ITEMS_SCHEDULE();
        	itemSched.ItemNumber = '100';
        	itemSched.ConfirmedQuantity = 1;
            itemSched.ScheduleLineDate = Date.today();
        	result.ITEMS_SCHEDULE.add(itemSched);

            ensxtx_SBO_EnosixPricing_Detail.CONDITIONS itemCond = new ensxtx_SBO_EnosixPricing_Detail.CONDITIONS();
            itemCond.ConditionItemNumber = '100';
            itemCond.ConditionType = 'TEST';
            itemCond.Rate = 2;
            result.CONDITIONS.add(itemCond);
            ensxtx_SBO_EnosixPricing_Detail.CONDITIONS itemCond2 = new ensxtx_SBO_EnosixPricing_Detail.CONDITIONS();
            itemCond2.ConditionItemNumber = '100';
            itemCond2.ConditionType = 'SECOND';
            itemCond2.Rate = 10;
            result.CONDITIONS.add(itemCond2);
            
            return result;
        }

        public ensxsdk.EnosixFramework.DetailObject executeSave(ensxsdk.EnosixFramework.DetailObject obj) 
        { 
            ensxtx_SBO_EnosixPricing_Detail.EnosixOpportunityPricing result = new ensxtx_SBO_EnosixPricing_Detail.EnosixOpportunityPricing();
            result.setSuccess(success);
            return result;
        }
    }

    @isTest
    static public void test_prepareQuoteAndSimulate()
    {
        User testUser=[SELECT Id from User where Username='User.Test@enosix.com'];
        System.runAs(testUser) {
            string TEST_JSON_CPQ = '{"SBODetailType": "Pricing", "DefaultQuoteLineIncrement": 100, "DefaultSalesDocType": "ZOR", "AddVCBoM": true, "AddNonVCBoM": true, "SkipMissingBoM": false, "Pricing":{' +
                '"Request":{' +
                '"Quote":{"RecordMapping":[{"collection":"header","field":"SoldToParty","defaultValue":"soldToParty","sObjectField":"ensxtx_Sold_To_Number__c"}]},' + 
                '"QuoteLine":{"RecordMapping":[{"collection":"items","field":"OrderQuantity","defaultValue":"","sObjectField":"SBQQ__Quantity__c"}]}},' + 
                '"Response":{' + 
                '"Quote":{"RecordMapping":[]},' + 
                '"QuoteLine":{"RecordMapping":[{"collection":"items","field":"NetItemPrice","sObjectField":"SBQQ__ListPrice__c"}]}}}}';
            ensxtx_UTIL_AppSettings.settingsMap.put(ensxtx_UTIL_AppSettings.Prefix + ensxtx_UTIL_AppSettings.CPQV2 + ensxtx_UTIL_AppSettings.Suffix, (Map<String, Object>)JSON.deserializeUntyped(TEST_JSON_CPQ));

            Mockensxtx_SBO_EnosixPricing_Detail sbo = new Mockensxtx_SBO_EnosixPricing_Detail();
            ensxsdk.EnosixFramework.setMock(ensxtx_SBO_EnosixPricing_Detail.class, sbo);
            createTestObjects();

            Test.startTest();
            ensxtx_UTIL_CPQ_QuotePricingV2.prepareQuoteAndSimulate(quote, qlList);

            Map<String, Object> quoteMap = (Map<String,Object>) JSON.deserializeUntyped(JSON.serialize(quote));
            quoteMap.put('ensxtx_Sold_To_Number__c', '');
            SBQQ__Quote__c quote2 = (SBQQ__Quote__c) JSON.deserialize(JSON.serialize(quoteMap), SBQQ__Quote__c.class);
            ensxtx_UTIL_CPQ_QuotePricingV2.prepareQuoteAndSimulate(quote2, qlList);
            ensxtx_UTIL_CPQ_QuotePricingV2.prepareQuoteAndSimulate(quote, new List<SBQQ__QuoteLine__c>());

            sbo.setThrowException(false);

            Test.stopTest();
        }
    }

    @isTest 
    static void test_buildCharacteristicsTable()
    {
        User testUser=[SELECT Id from User where Username='User.Test@enosix.com'];
        System.runAs(testUser) {
            Test.startTest();
            Map<String, List<String>> vcSummary = new Map<String, List<String>>();
            List<String> values1 = new List<String>();
            values1.add('');
            vcSummary.put('values1', values1);
            List<String> values2 = new List<String>();
            values2.add('');
            values2.add('');
            vcSummary.put('values2', values2);
            ensxtx_UTIL_CPQ_QuotePricingV2.buildCharacteristicsTable(vcSummary);
            Test.stopTest();
        }
    }

    @isTest 
    static void test_getSBOForCPQQuote()
    {
        User testUser=[SELECT Id from User where Username='User.Test@enosix.com'];
        System.runAs(testUser) {
            Mockensxtx_SBO_EnosixPricing_Detail sbo = new Mockensxtx_SBO_EnosixPricing_Detail();
            ensxsdk.EnosixFramework.setMock(ensxtx_SBO_EnosixPricing_Detail.class, sbo);
            Test.startTest();
            string TEST_JSON = '{"Pricing":{' + 
                '"Request":{' +
                '"Quote":{"RecordMapping":[{"collection":"header","field":"SoldToParty","defaultValue":"soldToParty","sObjectField":"ensxtx_Sold_To_Number__c"}]},' + 
                '"QuoteLine":{"RecordMapping":[{"collection":"items","field":"OrderQuantity","defaultValue":"","sObjectField":"SBQQ__Quantity__c"}]}},' + 
                '"Response":{' + 
                '"Quote":{"RecordMapping":[]},' + 
                '"QuoteLine":{"RecordMapping":[{"collection":"items","field":"NetItemPrice","sObjectField":"SBQQ__ListPrice__c"}]}}}}';
            ensxtx_UTIL_AppSettings.settingsMap.put(ensxtx_UTIL_AppSettings.Prefix + ensxtx_UTIL_AppSettings.CPQV2 + ensxtx_UTIL_AppSettings.Suffix, (Map<String, Object>)JSON.deserializeUntyped(TEST_JSON));
            try {
                ensxtx_UTIL_CPQ_QuotePricingV2.getSBOForCPQQuote(new SBQQ__Quote__c(), null, new Map<Id, Product2>(), new Map<Id, SObject>(), false);
            } catch (Exception e) {}
            SBQQ__Quote__c cpqQuote = new SBQQ__Quote__c();
            cpqQuote.ensxtx_Ship_To_Number__c = 'shipToParty';
            Product2 prod = ensxtx_TSTU_CPQ_TestSetup.createProduct2();
            SBQQ__QuoteLine__c cpqQuoteLine = new SBQQ__QuoteLine__c();
            cpqQuoteLine.SBQQ__Product__c = prod.Id;
            cpqQuoteLine.SBQQ__Number__c = 1;
            cpqQuoteLine.ensxtx_SAP_Item_Number__c = '10';
            ensxtx_DS_Document_Detail.CPQ_VC_ITEM_CONFIGURATION itemConfig = new ensxtx_DS_Document_Detail.CPQ_VC_ITEM_CONFIGURATION();
            itemConfig.selectedCharacteristics = new List<ensxtx_DS_Document_Detail.CONFIG>();
            ensxtx_DS_Document_Detail.CONFIG characteristic = new ensxtx_DS_Document_Detail.CONFIG();
            characteristic.UserModified = true;
            characteristic.CharacteristicID = 'CharacteristicID';
            itemConfig.selectedCharacteristics.add(characteristic);
            cpqQuoteLine.ensxtx_SAP_Configuration__c = JSON.serialize(itemConfig);
            List<SBQQ__QuoteLine__c> cpqQuoteLineList = new List<SBQQ__QuoteLine__c>();
            cpqQuoteLineList.add(cpqQuoteLine);

            List<Id> values = new List<Id>();
            values.add(prod.Id);
            List<String> fields = new List<String>();
            String configurableMaterialField = ensxtx_UTIL_SFProduct.getConfigurableMaterialField();
            if (String.isNotEmpty(configurableMaterialField)) fields.add(configurableMaterialField);
            String bomMaterialField = ensxtx_UTIL_SFProduct.getBOMMaterialField();
            if (String.isNotEmpty(bomMaterialField)) fields.add(bomMaterialField);
            Map<Id, Product2> productMap = ensxtx_UTIL_SFProduct.getProductsByField('Id', values, fields);
            Map<String, SBQQ__QuoteLine__c> sapMaterialQuoteLineMap = new Map<String, SBQQ__QuoteLine__c>();
            sapMaterialQuoteLineMap.put('MAT1', new SBQQ__QuoteLine__c());
            sapMaterialQuoteLineMap.put('MAT2', new SBQQ__QuoteLine__c());

            ensxtx_UTIL_CPQ_QuotePricingV2.getSBOForCPQQuote(cpqQuote, cpqQuoteLineList, productMap, new Map<Id, SObject>(), false);
            Test.stopTest();
        }
    }

    @isTest 
    static void test_getSBOForCPQQuoteError()
    {
        User testUser=[SELECT Id from User where Username='User.Test@enosix.com'];
        System.runAs(testUser) {
            Test.startTest();
            string TEST_JSON = '{"Pricing":{' + 
                '"Request":{' +
                '"Quote":{"RecordMapping":[{"collection":"header","field":"SoldToParty","defaultValue":"","sObjectField":"ensxtx_Sold_To_Number__c"}]},' + 
                '"QuoteLine":{"RecordMapping":[{"collection":"items","field":"OrderQuantity","defaultValue":"","sObjectField":"SBQQ__Quantity__c"}]}},' + 
                '"Response":{' + 
                '"Quote":{"RecordMapping":[]},' + 
                '"QuoteLine":{"RecordMapping":[{"collection":"items","field":"NetItemPrice","sObjectField":"SBQQ__ListPrice__c"}]}}}}';
            ensxtx_UTIL_AppSettings.settingsMap.put(ensxtx_UTIL_AppSettings.Prefix + ensxtx_UTIL_AppSettings.CPQV2 + ensxtx_UTIL_AppSettings.Suffix, (Map<String, Object>)JSON.deserializeUntyped(TEST_JSON));
            try {
                ensxtx_UTIL_CPQ_QuotePricingV2.getSBOForCPQQuote(new SBQQ__Quote__c(), null, new Map<Id, Product2>(), new Map<Id, SObject>(), false);
            } catch (Exception e) {}
            Test.stopTest();
        }
    }

    @isTest
    static public void test_processMessage()
    {
        User testUser=[SELECT Id from User where Username='User.Test@enosix.com'];
        System.runAs(testUser) {
            List<Product2> prodList = new List<Product2>();
            Product2 prod1 = ensxtx_TSTU_SFTestObject.createTestProduct2();
            prod1.put(ensxtx_UTIL_SFProduct.MaterialFieldName, 'MAT0');
            prodList.add(prod1);
            ensxtx_TSTU_SFTestObject.upsertWithRetry(prodList);

            SBQQ__QuoteLine__c cpqQuoteLine = new SBQQ__QuoteLine__c();
            cpqQuoteLine.SBQQ__Number__c = 1;
            cpqQuoteLine.ensxtx_SAP_Item_Number__c = '100';
            cpqQuoteLine.SBQQ__Product__c = prod1.Id;
            cpqQuoteLine.ensxtx_SAP_Configuration__c = JSON.serialize(new ensxtx_DS_Document_Detail.CPQ_VC_ITEM_CONFIGURATION());

            List<SBQQ__QuoteLine__c> cpqQuoteLineList = new List<SBQQ__QuoteLine__c>();
            cpqQuoteLineList.add(cpqQuoteLine);

            Test.startTest();
            ensxtx_UTIL_CPQ_QuotePricingV2.processMessage(cpqQuoteLineList, 'Internal error:, 100, Message,', new Map<Id, Product2>());
            Test.stopTest();
        }
    }

    @isTest
    static void test_applyQuoteRequestMappingRules()
    {
        User testUser=[SELECT Id from User where Username='User.Test@enosix.com'];
        System.runAs(testUser) {
            string TEST_JSON = '{"Pricing":{' + 
                '"Request":{' +
                '"Quote":{"RecordMapping":[' + 
                '{"collection":"sales","field":"SalesDocumentType","defaultValue":"SalesDocumentType","sObjectField":"ensxtx_Document_Type__c"},' + 
                '{"collection":"partners","field":"CustomerNumber","partnerFunction":"SP","defaultValue":"soldToParty","sObjectField":"ensxtx_Sold_To_Number__c"},' + 
                '{"collection":"partners","field":"CustomerNumber","partnerFunction":"SP","defaultValue":"soldToParty","sObjectField":"ensxtx_Sold_To_Number__c"},' + 
                '{"collection":"header","field":"SoldToParty","defaultValue":"soldToParty","sObjectField":"ensxtx_Sold_To_Number__c"},' + 
                '{"collection":"conditions","field":"PR00","defaultValue":1,"transform":"conditionRateAsPercent"},' + 
                '{"collection":"conditions","field":"PR00","defaultValue":1,"transform":"conditionRateDiscountAsPercent"},' + 
                '{"collection":"conditions","field":"PR00","defaultValue":1,"transform":"conditionRate"},' + 
                '{"collection":"conditions","field":"PR00","defaultValue":1,"transform":"conditionRateDiscount"},' + 
                '{"collection":"conditions","field":"PR00","defaultValue":1,"transform":"badTransform"},' + 
                '{"collection":"badCollection","field":"badCollection","defaultValue":"badCollection"}]},' + 
                '"QuoteLine":{"RecordMapping":[{"collection":"items","field":"OrderQuantity","defaultValue":"","sObjectField":"SBQQ__Quantity__c"}]}},' + 
                '"Response":{' + 
                '"Quote":{"RecordMapping":[]},' + 
                '"QuoteLine":{"RecordMapping":[{"collection":"items","field":"NetItemPrice","sObjectField":"SBQQ__ListPrice__c"}]}}}}';
            ensxtx_UTIL_AppSettings.settingsMap.put(ensxtx_UTIL_AppSettings.Prefix + ensxtx_UTIL_AppSettings.CPQV2 + ensxtx_UTIL_AppSettings.Suffix, (Map<String, Object>)JSON.deserializeUntyped(TEST_JSON));

            // initialize sObjects
            List<SObject> acctAndQuote = ensxtx_TSTU_CPQ_TestSetup.createAccountQuoteLinked();
            SBQQ__Quote__c cpqQuote = (SBQQ__Quote__c)acctAndQuote[1];
            cpqQuote.ensxtx_Document_Type__c = 'Type';
            cpqQuote.ensxtx_Sales_Organization__c = 'SO';
            cpqQuote.ensxtx_Distribution_Channel__c = 'DC';
            cpqQuote.ensxtx_Division__c = 'DI';
            cpqQuote.ensxtx_Ship_To_Number__c = 'ShipTo';
            cpqQuote.ensxtx_Bill_To_Number__c = 'BillTo';
            cpqQuote.ensxtx_Payer_Number__c = 'Payer';

            ensxtx_DS_Document_Detail salesDocDetail = new ensxtx_DS_Document_Detail();
            salesDocDetail.SoldToParty = 'TEST';
            salesDocDetail.SALES.SalesDocumentType = 'TEST';
            salesDocDetail.SALES.SalesOrganization = 'TEST';
            salesDocDetail.SALES.DistributionChannel = 'TEST';
            salesDocDetail.SALES.Division = 'TEST';
            salesDocDetail.SoldToParty = 'TEST';

            ensxtx_DS_Document_Detail.PARTNERS shipTo = new ensxtx_DS_Document_Detail.PARTNERS();
            shipTo.PartnerFunction = ensxtx_UTIL_Customer.SHIP_TO_PARTNER_CODE;
            shipTo.CustomerNumber = 'TEST';
            salesDocDetail.PARTNERS.add(shipTo);

            Test.startTest();

            ensxtx_UTIL_CPQ_QuotePricingV2.applyQuoteRequestMappingRules(null, salesDocDetail);
            ensxtx_UTIL_CPQ_QuotePricingV2.applyQuoteRequestMappingRules(cpqQuote, salesDocDetail);
            ensxtx_UTIL_CPQ_QuotePricingV2.cpqPricingConfig = null;
            ensxtx_UTIL_AppSettings.settingsMap.put(ensxtx_UTIL_AppSettings.Prefix + ensxtx_UTIL_AppSettings.CPQV2 + ensxtx_UTIL_AppSettings.Suffix, (Map<String, Object>)JSON.deserializeUntyped('{}'));
            ensxtx_UTIL_CPQ_QuotePricingV2.applyQuoteRequestMappingRules(cpqQuote, salesDocDetail);

            Test.stopTest();
        }
    }    

    @isTest
    static void test_applyQuoteLineRequestMappingRules()
    {        
        User testUser=[SELECT Id from User where Username='User.Test@enosix.com'];
        System.runAs(testUser) {
            string TEST_JSON = '{"Pricing":{' + 
                '"Request":{' +
                '"Quote":{"RecordMapping":[{"collection":"header","field":"SoldToParty","defaultValue":"soldToParty","sObjectField":"ensxtx_Sold_To_Number__c"}]},' + 
                '"QuoteLine":{"RecordMapping":[' +
                '{"collection":"items","field":"NetItemPrice","sObjectField":"SBQQ__ListPrice__c"},' +
                '{"collection":"conditions","field":"ZSD6","transform":"conditionValue","sObjectField":"SBQQ__ListPrice__c"},'+
                '{"collection":"conditions","field":"ZSD6","transform":"conditionValueDiscount","sObjectField":"SBQQ__ListPrice__c"},'+
                '{"collection":"conditions","field":"ZSD6","transform":"conditionValuePerItemQuantity","sObjectField":"SBQQ__ListPrice__c"},'+
                '{"collection":"conditions","field":"ZSD6","transform":"conditionValueDiscountPerItemQuantity","sObjectField":"SBQQ__ListPrice__c"},'+
                '{"collection":"conditions","field":"ZSD6","transform":"conditionRateAsPercent","sObjectField":"SBQQ__ListPrice__c"},'+
                '{"collection":"conditions","field":"ZSD6","transform":"conditionRateDiscountAsPercent","sObjectField":"SBQQ__ListPrice__c"},'+
                '{"collection":"conditions","field":"ZSD6","transform":"conditionRate","sObjectField":"SBQQ__ListPrice__c"},'+
                '{"collection":"conditions","field":"ZSD6","transform":"conditionRateDiscount","sObjectField":"SBQQ__ListPrice__c"},'+
                '{"collection":"conditions","field":"ZSD6","transform":"conditionRateUnit","sObjectField":"SBQQ__ListPrice__c"},'+
                '{"collection":"conditions","field":"ZSD6","transform":"unrecognized","sObjectField":"SBQQ__ListPrice__c"}]}},'+
                '"Response":{' + 
                '"Quote":{"RecordMapping":[]},' + 
                '"QuoteLine":{"RecordMapping":[]}}}}';
            ensxtx_UTIL_AppSettings.settingsMap.put(ensxtx_UTIL_AppSettings.Prefix + ensxtx_UTIL_AppSettings.CPQV2 + ensxtx_UTIL_AppSettings.Suffix, (Map<String, Object>)JSON.deserializeUntyped(TEST_JSON));

            SBQQ__QuoteLine__c cpqQuoteLine = new SBQQ__QuoteLine__c();
            cpqQuoteLine.SBQQ__Number__c = 1;
            cpqQuoteLine.SBQQ__Quantity__c = 1;
            cpqQuoteLine.SBQQ__ListPrice__c = 1;
            cpqQuoteLine.ensxtx_SAP_Item_Number__c = '10';
            cpqQuoteLine.ensxtx_SAP_Configuration__c = JSON.serialize(new ensxtx_DS_Document_Detail.CPQ_VC_ITEM_CONFIGURATION());

            List<SBQQ__QuoteLine__c> cpqQuoteLineList = new List<SBQQ__QuoteLine__c>();
            cpqQuoteLineList.add(cpqQuoteLine);

            ensxtx_DS_Document_Detail salesDocDetail = new ensxtx_DS_Document_Detail();
            salesDocDetail.SoldToParty = 'TEST';
            salesDocDetail.SALES.SalesDocumentType = 'TEST';
            salesDocDetail.SALES.SalesOrganization = 'TEST';
            salesDocDetail.SALES.DistributionChannel = 'TEST';
            salesDocDetail.SALES.Division = 'TEST';
            ensxtx_DS_Document_Detail.PARTNERS soldToPartner = new ensxtx_DS_Document_Detail.PARTNERS();
            soldToPartner.PartnerFunction = ensxtx_UTIL_Customer.SOLD_TO_PARTNER_CODE;
            soldToPartner.CustomerNumber = 'TEST';
            salesDocDetail.PARTNERS.add(soldToPartner);

            ensxtx_DS_Document_Detail.PARTNERS shipTo = new ensxtx_DS_Document_Detail.PARTNERS();
            shipTo.PartnerFunction = ensxtx_UTIL_Customer.SHIP_TO_PARTNER_CODE;
            shipTo.CustomerNumber = 'TEST';
            salesDocDetail.PARTNERS.add(shipTo);

            ensxtx_DS_Document_Detail.ITEMS itm = new ensxtx_DS_Document_Detail.ITEMS();
            itm.ItemNumber = '1';
            itm.Material = 'test';
            itm.OrderQuantity = cpqQuoteLine.SBQQ__Quantity__c;
            itm.Materialgroup1 = 'test1';
            itm.Materialgroup2 = 'test2';
            salesDocDetail.Items.add(itm);

            ensxtx_UTIL_CPQ_QuotePricingV2.applyQuoteLineRequestMappingRules(null, salesDocDetail.ITEMS[0]);
            ensxtx_UTIL_CPQ_QuotePricingV2.applyQuoteLineRequestMappingRules(cpqQuoteLine, salesDocDetail.ITEMS[0]);
            ensxtx_UTIL_CPQ_QuotePricingV2.cpqPricingConfig = null;
            ensxtx_UTIL_AppSettings.settingsMap.put(ensxtx_UTIL_AppSettings.Prefix + ensxtx_UTIL_AppSettings.CPQV2 + ensxtx_UTIL_AppSettings.Suffix, (Map<String, Object>)JSON.deserializeUntyped('{}'));
            ensxtx_UTIL_CPQ_QuotePricingV2.applyQuoteLineRequestMappingRules(cpqQuoteLine, salesDocDetail.ITEMS[0]);
        }
    }

    @isTest
    static public void test_updateCPQQuoteForSBOResults()
    {
        User testUser=[SELECT Id from User where Username='User.Test@enosix.com'];
        System.runAs(testUser) {
            string TEST_JSON = '{"Pricing":{' + 
                '"Request":{' +
                '"Quote":{"RecordMapping":[{"collection":"header","field":"SoldToParty","defaultValue":"soldToParty","sObjectField":"ensxtx_Sold_To_Number__c"}]},' + 
                '"QuoteLine":{"RecordMapping":[{"collection":"items","field":"OrderQuantity","defaultValue":"","sObjectField":"SBQQ__Quantity__c"}]}},' + 
                '"Response":{' + 
                '"Quote":{"RecordMapping":[]},' + 
                '"QuoteLine":{"RecordMapping":[{"collection":"items","field":"NetItemPrice","sObjectField":"SBQQ__ListPrice__c"}]}}}}';
            ensxtx_UTIL_AppSettings.settingsMap.put(ensxtx_UTIL_AppSettings.Prefix + ensxtx_UTIL_AppSettings.CPQV2 + ensxtx_UTIL_AppSettings.Suffix, (Map<String, Object>)JSON.deserializeUntyped(TEST_JSON));
            ensxtx_UTIL_AppSettings.settingsMap.put(ensxtx_UTIL_AppSettings.Prefix + ensxtx_UTIL_AppSettings.VC + ensxtx_UTIL_AppSettings.Suffix, (Map<String, Object>)JSON.deserializeUntyped('{}'));

            // initialize sObjects
            List<SObject> acctAndQuote = ensxtx_TSTU_CPQ_TestSetup.createAccountQuoteLinked();
            SBQQ__Quote__c cpqQuote = (SBQQ__Quote__c)acctAndQuote[1];
            ensxtx_DS_Document_Detail salesDocDetail = ensxtx_TSTD_Document_Detail.buildSalesDocDetail();
            salesDocDetail.ITEMS.clear();

            ensxtx_DS_Document_Detail.CONFIG chars = new ensxtx_DS_Document_Detail.CONFIG();
            chars.CharacteristicID = 'TEST';
            chars.CharacteristicName = 'TEST';
            chars.CharacteristicValue = 'TEST';
            chars.UserModified = true;

            List<ensxtx_DS_Document_Detail.CONFIG> lstChars = new List<ensxtx_DS_Document_Detail.CONFIG>();
            lstChars.add(chars);

            ensxtx_DS_Document_Detail.CPQ_VC_ITEM_CONFIGURATION conf = new ensxtx_DS_Document_Detail.CPQ_VC_ITEM_CONFIGURATION();
            conf.plant = 'PLANT';
            conf.materialNumber = 'TEST';
            conf.selectedCharacteristics = lstChars;
            conf.SalesDocumentCurrency = 'TEST';
            conf.OrderQuantity = 0;

            SBQQ__ProductFeature__c productFeature = new SBQQ__ProductFeature__c();
            productFeature.put('Name', 'SAP BoM');
            productFeature.put('SBQQ__Number__c', 999);
            productFeature.put('SBQQ__MinOptionCount__c', 0);
            productFeature.put('SBQQ__OptionSelectionMethod__c', 'Dynamic');
            productFeature.put('SBQQ__Category__c', 'SAP BoM');
            ensxtx_TSTU_SFTestObject.upsertWithRetry(productFeature);
    
            SBQQ__QuoteLine__c cpqQuoteLine1 = new SBQQ__QuoteLine__c();
            cpqQuoteLine1.SBQQ__Number__c = 1;
            cpqQuoteLine1.SBQQ__Quantity__c = 1;
            cpqQuoteLine1.ensxtx_SAP_Configuration__c = JSON.serialize(new ensxtx_DS_Document_Detail.CPQ_VC_ITEM_CONFIGURATION());
            cpqQuoteLine1.ensxtx_SAP_Item_Number__c = '100';
            ensxtx_DS_Document_Detail.ITEMS item1 = new ensxtx_DS_Document_Detail.ITEMS();
            item1.ItemNumber = '100';
            item1.CPQNumber = 1;
            item1.Material = 'topItem';
            item1.MaterialEntered = item1.Material;
            item1.HigherLevelItemNumber = '0';
            item1.BillOfMaterial = null;
            item1.OrderQuantity = 1;
            item1.NetOrderValue = 1;
            item1.CostInDocCurrency = 1;
            salesDocDetail.ITEMS.add(item1);

            conf.ParentLineItem = 1;
            SBQQ__QuoteLine__c cpqQuoteLine2 = new SBQQ__QuoteLine__c();
            cpqQuoteLine2.SBQQ__Number__c = 2;
            cpqQuoteLine2.SBQQ__Quantity__c = 1;
            cpqQuoteLine2.ensxtx_SAP_Configuration__c = JSON.serialize(conf);
            cpqQuoteLine2.ensxtx_SAP_Item_Number__c = '101';
            cpqQuoteLine2.SBQQ__DynamicOptionId__c = productFeature.Id + ':';
            ensxtx_DS_Document_Detail.ITEMS item2 = new ensxtx_DS_Document_Detail.ITEMS();
            item2.ItemNumber = '101';
            item2.CPQNumber = 2;
            item2.Material = 'MAT1';
            item2.MaterialEntered = item2.Material;
            item2.HigherLevelItemNumber = '100';
            item2.BillOfMaterial = '101';
            item2.OrderQuantity = 1;
            item2.NetOrderValue = 1;
            item2.CostInDocCurrency = 1;
            salesDocDetail.ITEMS.add(item2);

            SBQQ__QuoteLine__c cpqQuoteLine3 = new SBQQ__QuoteLine__c();
            cpqQuoteLine3.SBQQ__Number__c = 3;
            cpqQuoteLine3.SBQQ__Quantity__c = 1;
            cpqQuoteLine3.ensxtx_SAP_Configuration__c = JSON.serialize(conf);
            cpqQuoteLine3.ensxtx_SAP_Item_Number__c = '102';
            cpqQuoteLine3.SBQQ__DynamicOptionId__c = productFeature.Id + ':';
            ensxtx_DS_Document_Detail.ITEMS item3 = new ensxtx_DS_Document_Detail.ITEMS();
            item3.ItemNumber = '102';
            item3.CPQNumber = 3;
            item3.Material = 'MAT2';
            item3.MaterialEntered = item3.Material;
            item3.HigherLevelItemNumber = '100';
            item3.BillOfMaterial = '102';
            item3.OrderQuantity = 1;
            item3.NetOrderValue = 1;
            item3.CostInDocCurrency = 1;
            salesDocDetail.ITEMS.add(item3);
            
            SBQQ__QuoteLine__c cpqQuoteLine4 = new SBQQ__QuoteLine__c();
            cpqQuoteLine4.SBQQ__Number__c = 4;
            cpqQuoteLine4.SBQQ__Quantity__c = 1;
            cpqQuoteLine4.ensxtx_SAP_Configuration__c = JSON.serialize(new ensxtx_DS_Document_Detail.CPQ_VC_ITEM_CONFIGURATION());
            cpqQuoteLine4.ensxtx_SAP_Item_Number__c = '200';
            ensxtx_DS_Document_Detail.ITEMS item4 = new ensxtx_DS_Document_Detail.ITEMS();
            item4.ItemNumber = '200';
            item4.CPQNumber = 4;
            item4.Material = 'topItem2';
            item4.MaterialEntered = item4.Material;
            item4.HigherLevelItemNumber = '0';
            item4.BillOfMaterial = null;
            item4.OrderQuantity = 1;
            item4.NetOrderValue = 1;
            item4.CostInDocCurrency = 1;
            salesDocDetail.ITEMS.add(item4);

            conf.ParentLineItem = 4;
            SBQQ__QuoteLine__c cpqQuoteLine5 = new SBQQ__QuoteLine__c();
            cpqQuoteLine5.SBQQ__Number__c = 5;
            cpqQuoteLine5.SBQQ__Quantity__c = 1;
            cpqQuoteLine5.ensxtx_SAP_Configuration__c = JSON.serialize(conf);
            cpqQuoteLine5.ensxtx_SAP_Item_Number__c = '201';
            cpqQuoteLine5.SBQQ__DynamicOptionId__c = productFeature.Id + ':';
            ensxtx_DS_Document_Detail.ITEMS item5 = new ensxtx_DS_Document_Detail.ITEMS();
            item5.ItemNumber = '201';
            item5.CPQNumber = 5;
            item5.Material = 'MAT1';
            item5.MaterialEntered = item5.Material;
            item5.HigherLevelItemNumber = '200';
            item5.BillOfMaterial = '201';
            item5.OrderQuantity = 1;
            item5.NetOrderValue = 1;
            item5.CostInDocCurrency = 1;
            salesDocDetail.ITEMS.add(item5);

            SBQQ__QuoteLine__c cpqQuoteLine6 = new SBQQ__QuoteLine__c();
            cpqQuoteLine6.SBQQ__Number__c = 36;
            cpqQuoteLine6.SBQQ__Quantity__c = 1;
            cpqQuoteLine6.ensxtx_SAP_Configuration__c = JSON.serialize(conf);
            cpqQuoteLine6.ensxtx_SAP_Item_Number__c = '202';
            ensxtx_DS_Document_Detail.ITEMS item6 = new ensxtx_DS_Document_Detail.ITEMS();
            item6.ItemNumber = '202';
            item6.CPQNumber = 6;
            item6.Material = 'MAT1';
            item6.MaterialEntered = item6.Material;
            item6.HigherLevelItemNumber = '201';
            item6.BillOfMaterial = '202';
            item6.OrderQuantity = 1;
            item6.NetOrderValue = 1;
            item6.CostInDocCurrency = 1;
            salesDocDetail.ITEMS.add(item6);

            ensxtx_DS_Document_Detail.ITEMS item7 = new ensxtx_DS_Document_Detail.ITEMS();
            item7.ItemNumber = '203';
            item7.CPQNumber = 9999;
            item7.Material = 'MAT1';
            item7.MaterialEntered = item6.Material;
            item7.HigherLevelItemNumber = '201';
            item7.BillOfMaterial = '203';
            item7.OrderQuantity = 1;
            item7.NetOrderValue = 1;
            item7.CostInDocCurrency = 1;
            salesDocDetail.ITEMS.add(item7);
            
            conf.ParentLineItem = 999;
            SBQQ__QuoteLine__c cpqQuoteLine7 = new SBQQ__QuoteLine__c();
            cpqQuoteLine7.SBQQ__Number__c = 7;
            cpqQuoteLine7.SBQQ__Quantity__c = 1;
            cpqQuoteLine7.ensxtx_SAP_Configuration__c = JSON.serialize(conf);

            conf.ParentLineItem = 7;
            SBQQ__QuoteLine__c cpqQuoteLine8 = new SBQQ__QuoteLine__c();
            cpqQuoteLine8.SBQQ__Number__c = 8;
            cpqQuoteLine8.SBQQ__Quantity__c = 1;
            cpqQuoteLine8.ensxtx_SAP_Configuration__c = JSON.serialize(conf);

            SBQQ__QuoteLine__c cpqQuoteLine9 = new SBQQ__QuoteLine__c();
            cpqQuoteLine9.SBQQ__Number__c = 9;
            cpqQuoteLine9.SBQQ__Quantity__c = 1;
            cpqQuoteLine9.ensxtx_SAP_Configuration__c = JSON.serialize(conf);
            
            SBQQ__QuoteLine__c cpqQuoteLine10 = new SBQQ__QuoteLine__c();
            cpqQuoteLine10.SBQQ__Number__c = 10;
            cpqQuoteLine10.SBQQ__Quantity__c = 1;
            cpqQuoteLine10.ensxtx_SAP_Configuration__c = JSON.serialize(new ensxtx_DS_Document_Detail.CPQ_VC_ITEM_CONFIGURATION());

            conf.ParentLineItem = 11;
            SBQQ__QuoteLine__c cpqQuoteLine11 = new SBQQ__QuoteLine__c();
            cpqQuoteLine11.SBQQ__Number__c = 11;
            cpqQuoteLine11.SBQQ__Quantity__c = 1;
            cpqQuoteLine11.ensxtx_SAP_Configuration__c = JSON.serialize(conf);

            conf.ParentLineItem = 12;
            SBQQ__QuoteLine__c cpqQuoteLine12 = new SBQQ__QuoteLine__c();
            cpqQuoteLine12.SBQQ__Number__c = 12;
            cpqQuoteLine12.SBQQ__Quantity__c = 1;
            cpqQuoteLine12.ensxtx_SAP_Configuration__c = JSON.serialize(conf);

            List<SBQQ__QuoteLine__c> cpqQuoteLineList = new List<SBQQ__QuoteLine__c>();
            cpqQuoteLineList.add(cpqQuoteLine1);
            cpqQuoteLineList.add(cpqQuoteLine2);
            cpqQuoteLineList.add(cpqQuoteLine3);
            cpqQuoteLineList.add(cpqQuoteLine4);
            cpqQuoteLineList.add(cpqQuoteLine5);
            cpqQuoteLineList.add(cpqQuoteLine6);
            cpqQuoteLineList.add(cpqQuoteLine7);
            cpqQuoteLineList.add(cpqQuoteLine8);
            cpqQuoteLineList.add(cpqQuoteLine9);

            // Test affirmative case:
            Test.startTest();

            Map<String, SBQQ__QuoteLine__c> sapMaterialQuoteLineMap = new Map<String, SBQQ__QuoteLine__c>();

            Integer itmTot = salesDocDetail.ITEMS.size();
            Map<String, Product2> newProdMap = new Map<String, Product2>();
            for (Integer itmCnt = 0 ; itmCnt < itmTot ; itmCnt++) {
                ensxtx_DS_Document_Detail.ITEMS item = salesDocDetail.ITEMS[itmCnt];
                Product2 prod = ensxtx_TSTU_SFTestObject.createTestProduct2();
                prod.put(ensxtx_UTIL_SFProduct.MaterialFieldName, item.Material);
                if (String.isNotEmpty(item.Material)) newProdMap.put(item.Material, prod);
            }
            insert newProdMap.values();


            Map<Id, Product2> productMap = new Map<Id, Product2>(newProdMap.values());

            Map<Id, PriceBookEntry> pricebookEntriesMap = new Map<Id, PriceBookEntry>();
            List<String> newProdKeyList = new List<String>(newProdMap.keySet());

            productFeature.put('SBQQ__ConfiguredSKU__c', newProdMap.get(newProdKeyList[3]).Id);
            ensxtx_TSTU_SFTestObject.upsertWithRetry(productFeature);

            Integer prodTot = newProdMap.size();
            Integer qlTot = cpqQuoteLineList.size();
            for (Integer prodCnt = 0 ; prodCnt < prodTot ; prodCnt++) {
                String newProdKey = newProdKeyList[prodCnt];
                Product2 prod = newProdMap.get(newProdKey);
                Map<String, Object> pbeMap = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(new PriceBookEntry()));
                pbeMap.put('Id', ensxtx_TSTU_SFTestObject.getFakeId(PriceBookEntry.SObjectType));
                pbeMap.put('Product2', prod);
                PriceBookEntry pbe = (PriceBookEntry) JSON.deserialize(JSON.serialize(pbeMap), PriceBookEntry.class);
                pricebookEntriesMap.put(pbe.Id, pbe);
            
                for (Integer qlCnt = 0 ; qlCnt < qlTot ; qlCnt++) {
                    SBQQ__QuoteLine__c cpqQuoteLine = cpqQuoteLineList[qlCnt];
                    for (Integer itmCnt = 0 ; itmCnt < itmTot ; itmCnt++) {
                        ensxtx_DS_Document_Detail.ITEMS item = salesDocDetail.ITEMS[itmCnt];
                        if (cpqQuoteLine.ensxtx_SAP_Item_Number__c == item.ItemNumber) {
                            if (newProdKey == item.Material) {
                                cpqQuoteLine.SBQQ__Product__c = prod.Id;
                            }
                        }
                    }
                }
            }

            ensxtx_UTIL_CPQ_QuotePricingV2.updateCPQQuoteForSBOResults(cpqQuote, cpqQuoteLineList, salesDocDetail, productMap, new Map<String, Object>(), false, pricebookEntriesMap);     

            cpqQuoteLineList.add(cpqQuoteLine10);
            cpqQuoteLineList.add(cpqQuoteLine11);
            cpqQuoteLineList.add(cpqQuoteLine12);

            ensxtx_UTIL_CPQ_QuotePricingV2.updateCPQQuoteForSBOResults(cpqQuote, cpqQuoteLineList, salesDocDetail, productMap, new Map<String, Object>(), false, pricebookEntriesMap);     
            Test.stopTest();
        }
    }

    @isTest
    static public void test_mapSalesDocumentItemPricing()
    {
        User testUser=[SELECT Id from User where Username='User.Test@enosix.com'];
        System.runAs(testUser) {
            Test.startTest();
            ensxtx_UTIL_CPQ_QuotePricingV2.mapSalesDocumentItemPricing(new ensxtx_DS_Document_Detail.ITEMS());     
            Test.stopTest();
        }
    }
    
    @isTest
    static void test_applyQuoteResponseMappingRules()
    {
        User testUser=[SELECT Id from User where Username='User.Test@enosix.com'];
        System.runAs(testUser) {
            string TEST_JSON = '{"Pricing":{' + 
                '"Request":{' +
                '"Quote":{"RecordMapping":[{"collection":"header","field":"SoldToParty","defaultValue":"soldToParty","sObjectField":"ensxtx_Sold_To_Number__c"}]},' + 
                '"QuoteLine":{"RecordMapping":[{"collection":"items","field":"OrderQuantity","defaultValue":"","sObjectField":"SBQQ__Quantity__c"}]}},' + 
                '"Response":{' + 
                '"Quote":{"RecordMapping":[' + 
                '{"collection":"header","field":"SoldToParty","defaultValue":"","sObjectField":"ensxtx_Document_Type__c"},' + 
                '{"collection":"conditions","field":"PR00","transform":"conditionRate","sObjectField":"SBQQ__TargetCustomerAmount__c"}]},' + 
                '"QuoteLine":{"RecordMapping":[{"collection":"items","field":"NetItemPrice","sObjectField":"SBQQ__ListPrice__c"}]}}}}';
            ensxtx_UTIL_AppSettings.settingsMap.put(ensxtx_UTIL_AppSettings.Prefix + ensxtx_UTIL_AppSettings.CPQV2 + ensxtx_UTIL_AppSettings.Suffix, (Map<String, Object>)JSON.deserializeUntyped(TEST_JSON));
        
            List<SObject> acctAndQuote = ensxtx_TSTU_CPQ_TestSetup.createAccountQuoteLinked();
            SBQQ__Quote__c cpqQuote = (SBQQ__Quote__c)acctAndQuote[1];

            Test.startTest();

            ensxtx_DS_Document_Detail salesDocDetail = new ensxtx_DS_Document_Detail();
            ensxtx_DS_Document_Detail.ITEMS item = new ensxtx_DS_Document_Detail.ITEMS();
            item.SBOItemConditions = new List<ensxtx_DS_Document_Detail.CONDITIONS>();
            ensxtx_DS_Document_Detail.CONDITIONS itemCond = new ensxtx_DS_Document_Detail.CONDITIONS();
            itemCond.ConditionType = 'TEST';
            itemCond.Rate = 2;
            item.SBOItemConditions.add(itemCond);
            ensxtx_DS_Document_Detail.CONDITIONS itemCond2 = new ensxtx_DS_Document_Detail.CONDITIONS();
            itemCond2.ConditionType = 'SECOND';
            itemCond2.Rate = 10;
            item.SBOItemConditions.add(itemCond2);
            salesDocDetail.ITEMS.add(item);

            ensxtx_UTIL_CPQ_QuotePricingV2.applyQuoteResponseMappingRules(cpqQuote, salesDocDetail, new Map<String, Object>(), true);

            Test.stopTest();
        }
    }

    @isTest
    static void test_transformConditionToValue()
    {
        User testUser=[SELECT Id from User where Username='User.Test@enosix.com'];
        System.runAs(testUser) {
            string TEST_JSON = '{"Pricing":{' + 
                '"Request":{' +
                '"Quote":{"RecordMapping":[{"collection":"header","field":"SoldToParty","defaultValue":"soldToParty","sObjectField":"ensxtx_Sold_To_Number__c"}]},' + 
                '"QuoteLine":{"RecordMapping":[{"collection":"items","field":"OrderQuantity","defaultValue":"","sObjectField":"SBQQ__Quantity__c"}]}},' + 
                '"Response":{' + 
                '"Quote":{"RecordMapping":[]},' + 
                '"QuoteLine":{"RecordMapping":[' +
                '{"collection":"items","field":"NetItemPrice","sObjectField":"SBQQ__ListPrice__c"},' +
                '{"collection":"conditions","field":"ZSD6","transform":"conditionValue","sObjectField":"SBQQ__ListPrice__c"},'+
                '{"collection":"conditions","field":"ZSD6","transform":"conditionValueDiscount","sObjectField":"SBQQ__ListPrice__c"},'+
                '{"collection":"conditions","field":"ZSD6","transform":"conditionValuePerItemQuantity","sObjectField":"SBQQ__ListPrice__c"},'+
                '{"collection":"conditions","field":"ZSD6","transform":"conditionValueDiscountPerItemQuantity","sObjectField":"SBQQ__ListPrice__c"},'+
                '{"collection":"conditions","field":"ZSD6","transform":"conditionRateAsPercent","sObjectField":"SBQQ__ListPrice__c"},'+
                '{"collection":"conditions","field":"ZSD6","transform":"conditionRateDiscountAsPercent","sObjectField":"SBQQ__ListPrice__c"},'+
                '{"collection":"conditions","field":"ZSD6","transform":"conditionRate","sObjectField":"SBQQ__ListPrice__c"},'+
                '{"collection":"conditions","field":"ZSD6","transform":"conditionRateDiscount","sObjectField":"SBQQ__ListPrice__c"},'+
                '{"collection":"conditions","field":"ZSD6","transform":"conditionRateUnit","sObjectField":"SBQQ__ListPrice__c"},'+
                '{"collection":"conditions","field":"ZSD6","transform":"unrecognized","sObjectField":"SBQQ__ListPrice__c"}'+
                ']}}}}';
            ensxtx_UTIL_AppSettings.settingsMap.put(ensxtx_UTIL_AppSettings.Prefix + ensxtx_UTIL_AppSettings.CPQV2 + ensxtx_UTIL_AppSettings.Suffix, (Map<String, Object>)JSON.deserializeUntyped(TEST_JSON));
            ensxtx_UTIL_CPQ_QuotePricingV2.CPQPricingConfig c = (ensxtx_UTIL_CPQ_QuotePricingV2.CPQPricingConfig)ensxtx_UTIL_AppSettings.getSObject(ensxtx_UTIL_AppSettings.CPQV2, 'Pricing',ensxtx_UTIL_CPQ_QuotePricingV2.CPQPricingConfig.class, null);
            List<ensxtx_UTIL_CPQ_QuotePricingV2.CPQPricingConfigMappingRule> rules = c.Response.QuoteLine.RecordMapping;

            List<ensxtx_DS_Document_Detail.CONDITIONS> conditionList = new List<ensxtx_DS_Document_Detail.CONDITIONS>();
            ensxtx_DS_Document_Detail.CONDITIONS condition = new ensxtx_DS_Document_Detail.CONDITIONS();
            condition.ConditionType = 'ZSD6';
            condition.ConditionValue = 1;
            condition.Rate = 1;
            condition.CurrencyKey = 'USD';
            conditionList.add(condition);

            test.startTest();        
            Integer ruleTot = rules.size();
            for (Integer ruleCnt = 0 ; ruleCnt < ruleTot ; ruleCnt++)
            {
                ensxtx_UTIL_CPQ_QuotePricingV2.CPQPricingConfigMappingRule rule = rules[ruleCnt];
                ensxtx_UTIL_CPQ_QuotePricingV2.transformConditionToValue(rule,conditionList,1);
            }       
            test.stopTest();
        }
    }

    @isTest 
    static void test_buildTableForPriceTracing()
    {
        User testUser=[SELECT Id from User where Username='User.Test@enosix.com'];
        System.runAs(testUser) {
            Test.startTest();
            Map<String, List<ensxtx_UTIL_CPQ_QuotePricingV2.PriceTracingTableEntry>> targetFieldPriceTracingTable = new Map<String, List<ensxtx_UTIL_CPQ_QuotePricingV2.PriceTracingTableEntry>>();
            List<ensxtx_UTIL_CPQ_QuotePricingV2.PriceTracingTableEntry> table1 = new List<ensxtx_UTIL_CPQ_QuotePricingV2.PriceTracingTableEntry>();
            ensxtx_UTIL_CPQ_QuotePricingV2.PriceTracingTableEntry value1 = new ensxtx_UTIL_CPQ_QuotePricingV2.PriceTracingTableEntry();
            value1.targetField = 'SBQQ__OriginalPrice__c';
            value1.sourceField = 'PR00';
            value1.targetValueAfter = 3;
            table1.add(value1);
            targetFieldPriceTracingTable.put('table1', table1);
            SBQQ__QuoteLine__c cpqQuoteLine = new SBQQ__QuoteLine__c();
            cpqQuoteLine.SBQQ__Number__c = 1;
            cpqQuoteLine.SBQQ__Quantity__c = 1;
            ensxtx_UTIL_CPQ_QuotePricingV2.buildTableForPriceTracing(targetFieldPriceTracingTable,cpqQuoteLine);
            Test.stopTest();
        }
    }

    @isTest
    static void test_applyQuoteLineResponseMappingRules()
    {
        User testUser=[SELECT Id from User where Username='User.Test@enosix.com'];
        System.runAs(testUser) {
            string TEST_JSON = '{"Pricing":{' + 
                '"Request":{' +
                '"Quote":{"RecordMapping":[{"collection":"header","field":"SoldToParty","defaultValue":"soldToParty","sObjectField":"ensxtx_Sold_To_Number__c"}]},' + 
                '"QuoteLine":{"RecordMapping":[{"collection":"items","field":"OrderQuantity","defaultValue":"","sObjectField":"SBQQ__Quantity__c"}]}},' + 
                '"Response":{' + 
                '"Quote":{"RecordMapping":[]},' + 
                '"QuoteLine":{"RecordMapping":[' +
                '{"collection":"items","field":"NetItemPrice","sObjectField":"SBQQ__ListPrice__c","transform":"perConditionPricingUnit"},' +
                '{"collection":"items","field":"ATPDate","sObjectField":"SBQQ__EndDate__c","type":"date","showInTrace":false},' +
                '{"collection":"conditions","field":"ZSD6","transform":"conditionValue","sObjectField":"SBQQ__ListPrice__c"},'+
                '{"collection":"conditions","field":"ZSD6","transform":"conditionValueDiscount","sObjectField":"SBQQ__ListPrice__c"},'+
                '{"collection":"conditions","field":"ZSD6","transform":"conditionValuePerItemQuantity","sObjectField":"SBQQ__ListPrice__c"},'+
                '{"collection":"conditions","field":"ZSD6","transform":"conditionValueDiscountPerItemQuantity","sObjectField":"SBQQ__ListPrice__c"},'+
                '{"collection":"conditions","field":"ZSD6","transform":"conditionRateAsPercent","sObjectField":"SBQQ__ListPrice__c"},'+
                '{"collection":"conditions","field":"ZSD6","transform":"conditionRateDiscountAsPercent","sObjectField":"SBQQ__ListPrice__c"},'+
                '{"collection":"conditions","field":"ZSD6","transform":"conditionRate","sObjectField":"SBQQ__ListPrice__c"},'+
                '{"collection":"conditions","field":"ZSD6","transform":"conditionRateDiscount","sObjectField":"SBQQ__ListPrice__c"},'+
                '{"collection":"conditions","field":"ZSD6","transform":"conditionRateUnit","sObjectField":"SBQQ__ListPrice__c"},'+
                '{"collection":"conditions","field":"ZSD6","transform":"unrecognized","sObjectField":"SBQQ__ListPrice__c"}'+
                ']}}}}';
            ensxtx_UTIL_AppSettings.settingsMap.put(ensxtx_UTIL_AppSettings.Prefix + ensxtx_UTIL_AppSettings.CPQV2 + ensxtx_UTIL_AppSettings.Suffix, (Map<String, Object>)JSON.deserializeUntyped(TEST_JSON));

            SBQQ__QuoteLine__c cpqQuoteLine = new SBQQ__QuoteLine__c();
            cpqQuoteLine.SBQQ__Number__c = 1;
            cpqQuoteLine.SBQQ__Quantity__c = 1;
            cpqQuoteLine.ensxtx_SAP_Configuration__c = JSON.serialize(new ensxtx_DS_Document_Detail.CPQ_VC_ITEM_CONFIGURATION());

            List<SBQQ__QuoteLine__c> cpqQuoteLineList = new List<SBQQ__QuoteLine__c>();
            cpqQuoteLineList.add(cpqQuoteLine);

            ensxtx_DS_Document_Detail.ITEMS item = new ensxtx_DS_Document_Detail.ITEMS();
            item.ItemNumber = '1';
            item.Material = 'test';
            item.OrderQuantity = cpqQuoteLine.SBQQ__Quantity__c;
            item.NetItemPrice = 10;
            item.ConditionPricingUnit = 1;
            item.Materialgroup1 = 'test1';
            item.Materialgroup2 = 'test2';        
            item.ItemConditions = new List<ensxtx_DS_Document_Detail.CONDITIONS>();

            ensxtx_DS_Document_Detail.CONDITIONS itemCond = new ensxtx_DS_Document_Detail.CONDITIONS();
            itemCond.ConditionType = 'TEST';
            itemCond.Rate = 2;
            item.ItemConditions.add(itemCond);
            ensxtx_DS_Document_Detail.CONDITIONS itemCond2 = new ensxtx_DS_Document_Detail.CONDITIONS();
            itemCond2.ConditionType = 'SECOND';
            itemCond2.Rate = 10;
            item.ItemConditions.add(itemCond2);

            ensxtx_UTIL_CPQ_QuotePricingV2.applyQuoteLineResponseMappingRules(cpqQuoteLine, item, new Map<String, Object>());

            TEST_JSON = '{"Pricing":{' + 
                '"Request":{' +
                '"Quote":{"RecordMapping":[{"collection":"header","field":"SoldToParty","defaultValue":"soldToParty","sObjectField":"ensxtx_Sold_To_Number__c"}]},' + 
                '"QuoteLine":{"RecordMapping":[{"collection":"items","field":"OrderQuantity","defaultValue":"","sObjectField":"SBQQ__Quantity__c"}]}},' + 
                '"Response":{' + 
                '"Quote":{"RecordMapping":[]},' + 
                '"QuoteLine":{"RecordMapping":[]}}}}';

            ensxtx_UTIL_CPQ_QuotePricingV2.cpqPricingConfig = null;
            ensxtx_UTIL_AppSettings.settingsMap = new Map<String, Map<String, Object>>();
            ensxtx_UTIL_AppSettings.hasBeenRetypedMap = new Map<String, Map<String, Boolean>>();
            ensxtx_UTIL_AppSettings.settingsMap.put(ensxtx_UTIL_AppSettings.Prefix + ensxtx_UTIL_AppSettings.CPQV2 + ensxtx_UTIL_AppSettings.Suffix, (Map<String, Object>)JSON.deserializeUntyped(TEST_JSON));

            ensxtx_UTIL_CPQ_QuotePricingV2.applyQuoteLineResponseMappingRules(cpqQuoteLine, item, new Map<String, Object>());
        }
    }

	@isTest
	static void test_setPricingTables()
	{
        User testUser=[SELECT Id from User where Username='User.Test@enosix.com'];
        System.runAs(testUser) {
            ensxtx_UTIL_CPQ_QuotePricingV2.CPQPricingConfigMappingRule rule = new ensxtx_UTIL_CPQ_QuotePricingV2.CPQPricingConfigMappingRule();
            rule.sObjectField = 'sObjectField';
            List<ensxtx_UTIL_CPQ_QuotePricingV2.PriceTracingTableEntry> priceTracingTables = new List<ensxtx_UTIL_CPQ_QuotePricingV2.PriceTracingTableEntry>();
            ensxtx_UTIL_CPQ_QuotePricingV2.PriceTracingTableEntry priceTracingTable = new ensxtx_UTIL_CPQ_QuotePricingV2.PriceTracingTableEntry();
            priceTracingTable.sourceValue = 1;
            priceTracingTables.add(priceTracingTable);
            ensxtx_UTIL_CPQ_QuotePricingV2.setPricingTables(null, rule, priceTracingTables, new Map<String, List<ensxtx_UTIL_CPQ_QuotePricingV2.PriceTracingTableEntry>>());
        }
	}

    @isTest static void test_Settings()
    {
        User testUser=[SELECT Id from User where Username='User.Test@enosix.com'];
        System.runAs(testUser) {
            Test.startTest();
            Integer QuoteLineIncrement = ensxtx_UTIL_CPQ_QuotePricingV2.QuoteLineIncrement;
            String defaultSalesDocType = ensxtx_UTIL_CPQ_QuotePricingV2.defaultSalesDocType;
            String defaultSalesOrg = ensxtx_UTIL_CPQ_QuotePricingV2.defaultSalesOrg;
            String defaultDistributionChannel = ensxtx_UTIL_CPQ_QuotePricingV2.defaultDistributionChannel;
            String defaultDivision = ensxtx_UTIL_CPQ_QuotePricingV2.defaultDivision;
            String defaultCustomerNumber = ensxtx_UTIL_CPQ_QuotePricingV2.defaultCustomerNumber;
            Test.stopTest();
        }
    }

    static SBQQ__Quote__c quote;
    static List<SBQQ__QuoteLine__c> qlList;
    static Account account;

    private static void createTestObjects()
    {
        SBQQ.TriggerControl.disable();

        ensxtx_DS_Document_Detail salesDocDetail = new ensxtx_DS_Document_Detail();
        ensxtx_UTIL_SalesDoc.SFObject sfObject = new ensxtx_UTIL_SalesDoc.SFObject();
        sfObject.sfLineItems = new List<SObject>();

        List<Product2> prodList = new List<Product2>();
        Product2 prod0 = ensxtx_TSTU_SFTestObject.createTestProduct2();
        prod0.put(ensxtx_UTIL_SFProduct.MaterialFieldName, null);
        prodList.add(prod0);

        Product2 prod1 = ensxtx_TSTU_SFTestObject.createTestProduct2();
        prod1.SBQQ__ExternallyConfigurable__c = true;
        String configurableMaterialField = ensxtx_UTIL_SFProduct.getConfigurableMaterialField();
        if (String.isNotEmpty(configurableMaterialField)) prod1.put(configurableMaterialField, true);
        prod1.put(ensxtx_UTIL_SFProduct.MaterialFieldName, 'MAT1');
        prodList.add(prod1);

        Product2 prod2a = ensxtx_TSTU_SFTestObject.createTestProduct2();
        prod2a.Name = prod1.Name + ' (1)';
        prod2a.SBQQ__ExternallyConfigurable__c = true;
        if (String.isNotEmpty(configurableMaterialField)) prod2a.put(configurableMaterialField, true);
        prod2a.put(ensxtx_UTIL_SFProduct.MaterialFieldName, 'MAT2 (1)');
        prodList.add(prod2a);

        Product2 prod2b = ensxtx_TSTU_SFTestObject.createTestProduct2();
        prod2b.Name = 'MAT2';
        prod2b.SBQQ__ExternallyConfigurable__c = true;
        if (String.isNotEmpty(configurableMaterialField)) prod2b.put(configurableMaterialField, true);
        prod2b.put(ensxtx_UTIL_SFProduct.MaterialFieldName, 'MAT2');
        prodList.add(prod2b);

        Product2 prod3 = ensxtx_TSTU_SFTestObject.createTestProduct2();
        prod3.put(ensxtx_UTIL_SFProduct.MaterialFieldName, 'topItem');
        prodList.add(prod3);

        Product2 prod4 = ensxtx_TSTU_SFTestObject.createTestProduct2();
        prod4.put(ensxtx_UTIL_SFProduct.MaterialFieldName, 'topItem3');
        prodList.add(prod4);
        ensxtx_TSTU_SFTestObject.upsertWithRetry(prodList);

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

        account = ensxtx_TSTU_SFTestObject.createTestAccount();
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
        quote.ensxtx_SAP_Consistency_Check__c = false;
        quote.SBQQ__PriceBook__c = pricebookId;

        ensxtx_TSTU_SFTestObject.upsertWithRetry(quote);
        sfObject.sfMainObject = ensxtx_UTIL_SFSObjectDoc.getSObject(quote.Id);

        qlList = new List<SBQQ__QuoteLine__c>();
        SBQQ__QuoteLine__c qli1 = ensxtx_TSTU_SFCPQQuote.createTestQuoteLine();
        qli1.SBQQ__Quote__c = quote.Id;
        qli1.SBQQ__Number__c = 1;
        qli1.SBQQ__Product__c = prod3.Id;
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
        productFeature.put('SBQQ__ConfiguredSKU__c', prod1.Id);
        ensxtx_TSTU_SFTestObject.upsertWithRetry(productFeature);

        SBQQ__QuoteLine__c qli2 = ensxtx_TSTU_SFCPQQuote.createTestQuoteLine();
        qli2.SBQQ__Quote__c = quote.Id;
        qli2.SBQQ__Number__c = 2;
        qli2.SBQQ__Product__c = prod1.Id;
        qli2.ensxtx_SAP_Configuration__c = JSON.serialize(conf);
        qli2.ensxtx_SAP_Item_Number__c = '101';
        qli2.SBQQ__DynamicOptionId__c = productFeature.Id + ':' + qli2.SBQQ__Product__c;
        qlList.add(qli2);

        conf.ParentLineItem = 2;
        SBQQ__QuoteLine__c qli3 = ensxtx_TSTU_SFCPQQuote.createTestQuoteLine();
        qli3.SBQQ__Quote__c = quote.Id;
        qli3.SBQQ__Number__c = 3;
        qli3.SBQQ__Product__c = prod2a.Id;
        qli3.ensxtx_SAP_Configuration__c = JSON.serialize(conf);
        qli3.ensxtx_SAP_Item_Number__c = '102';
        qli3.SBQQ__DynamicOptionId__c = productFeature.Id + ':' + qli3.SBQQ__Product__c;
        qlList.add(qli3);

        SBQQ__QuoteLine__c qli4 = ensxtx_TSTU_SFCPQQuote.createTestQuoteLine();
        qli4.SBQQ__Quote__c = quote.Id;
        qli4.SBQQ__Number__c = 4;
        qli4.SBQQ__Product__c = prod2b.Id;
        qli4.ensxtx_SAP_Configuration__c = JSON.serialize(conf);
        qli4.ensxtx_SAP_Item_Number__c = '103';
        qli4.SBQQ__DynamicOptionId__c = productFeature.Id + ':' + qli4.SBQQ__Product__c;
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
        qli6.SBQQ__Product__c = prod1.Id;
        qli6.ensxtx_SAP_Item_Number__c = '200';
        qli6.ensxtx_SAP_Configuration__c = JSON.serialize(conf);
        qlList.add(qli6);

        conf.ParentLineItem = 6;

        SBQQ__QuoteLine__c qli7 = ensxtx_TSTU_SFCPQQuote.createTestQuoteLine();
        qli7.SBQQ__Quote__c = quote.Id;
        qli7.SBQQ__Number__c = 7;
        qli7.SBQQ__Product__c = prod1.Id;
        qli7.ensxtx_SAP_Item_Number__c = '201';
        qli7.SBQQ__DynamicOptionId__c = productFeature.Id + ':' + qli7.SBQQ__Product__c;
        qli7.ensxtx_SAP_Configuration__c = JSON.serialize(conf);
        qlList.add(qli7);

        conf.ParentLineItem = 5;

        SBQQ__QuoteLine__c qli8 = ensxtx_TSTU_SFCPQQuote.createTestQuoteLine();
        qli8.SBQQ__Quote__c = quote.Id;
        qli8.SBQQ__Number__c = 8;
        qli8.SBQQ__Product__c = prod4.Id;
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
        qli9.SBQQ__DynamicOptionId__c = productFeature.Id + ':' + qli9.SBQQ__Product__c;
        qli9.ensxtx_SAP_Configuration__c = JSON.serialize(conf);
        qlList.add(qli9);

        SBQQ__QuoteLine__c qli10 = ensxtx_TSTU_SFCPQQuote.createTestQuoteLine();
        qli10.SBQQ__Quote__c = quote.Id;
        qli10.SBQQ__Number__c = 10;
        qli10.SBQQ__Product__c = prod3.Id;
        qli10.ensxtx_SAP_Item_Number__c = '500';
        qlList.add(qli10);

        conf.ParentLineItem = null;

        SBQQ__QuoteLine__c qli11 = ensxtx_TSTU_SFCPQQuote.createTestQuoteLine();
        qli11.SBQQ__Quote__c = quote.Id;
        qli11.SBQQ__Number__c = 11;
        qli11.SBQQ__Product__c = prod0.Id;
        qlList.add(qli11);

        conf.ParentLineItem = 11;

        SBQQ__QuoteLine__c qli12 = ensxtx_TSTU_SFCPQQuote.createTestQuoteLine();
        qli12.SBQQ__Quote__c = quote.Id;
        qli12.SBQQ__Number__c = 12;
        qli12.SBQQ__Product__c = prod1.Id;
        qli12.ensxtx_SAP_Item_Number__c = '400';
        qli12.ensxtx_SAP_Configuration__c = JSON.serialize(conf);
        qlList.add(qli12);

        conf.ParentLineItem = 12;

        SBQQ__QuoteLine__c qli13 = ensxtx_TSTU_SFCPQQuote.createTestQuoteLine();
        qli13.SBQQ__Quote__c = quote.Id;
        qli13.SBQQ__Number__c = 13;
        qli13.SBQQ__Product__c = prod1.Id;
        qli13.ensxtx_SAP_Item_Number__c = '401';
        qli13.ensxtx_SAP_Configuration__c = JSON.serialize(conf);
        qlList.add(qli13);

        ensxtx_TSTU_SFTestObject.upsertWithRetry(qlList);

        SBQQ__QuoteLine__c qli14 = ensxtx_TSTU_SFCPQQuote.createTestQuoteLine();
        qli14.SBQQ__Quote__c = quote.Id;
        qli14.SBQQ__Number__c = 14;
        qli14.SBQQ__Product__c = prod1.Id;
        qli14.ensxtx_SAP_Configuration__c = JSON.serialize(conf);
        qli14.ensxtx_SAP_Item_Number__c = '600';
        qli14.SBQQ__DynamicOptionId__c = productFeature.Id + ':' + qli14.SBQQ__Product__c;

        qli2.put('SBQQ__RequiredBy__c', qli1.Id);
        qli3.put('SBQQ__RequiredBy__c', qli2.Id);
        sfObject.sfLineItems.add(qli2);
        sfObject.sfLineItems.add(qli3);
        
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