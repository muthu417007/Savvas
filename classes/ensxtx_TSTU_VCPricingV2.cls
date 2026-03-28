@isTest 
public with sharing class ensxtx_TSTU_VCPricingV2 
{
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
            if (throwException)
            {
                throw new ensxtx_ENSX_Exceptions.SimulationException();
            }

            ensxtx_SBO_EnosixPricing_Detail.EnosixOpportunityPricing result = new ensxtx_SBO_EnosixPricing_Detail.EnosixOpportunityPricing();           
            result.setSuccess(success);
            
            ensxtx_SBO_EnosixPricing_Detail.ITEMS topItem = new ensxtx_SBO_EnosixPricing_Detail.ITEMS();
            topItem.ItemNumber = '10';
            topItem.HigherLevelItemNumber = '0';
            topItem.CostInDocCurrency = 5;
            topItem.OrderQuantity = 1;
            topItem.NetItemPrice = 10;
            
            ensxtx_SBO_EnosixPricing_Detail.ITEMS childItem = new ensxtx_SBO_EnosixPricing_Detail.ITEMS();
            childItem.ItemNumber = '11';
            childItem.Material = 'MAT1';
            childItem.HigherLevelItemNumber = '10';
            childItem.CostInDocCurrency = 6;
            childItem.OrderQuantity = 1;
            childItem.NetItemPrice = 10;

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
            
            result.ITEMS.add(topItem);
            result.ITEMS.add(childItem);
            result.ITEMS.add(childItem2);
            result.ITEMS.add(childItem3);
            result.ITEMS.add(childItem4);
            
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

        public ensxsdk.EnosixFramework.DetailObject executeSave(ensxsdk.EnosixFramework.DetailObject obj) 
        { 
            ensxtx_SBO_EnosixPricing_Detail.EnosixOpportunityPricing result = new ensxtx_SBO_EnosixPricing_Detail.EnosixOpportunityPricing();
            result.setSuccess(success);
            return result;
        }
    }

    @isTest static void test_Settings()
    {
        Test.startTest();
        String defaultMaterialgroup1 = ensxtx_UTIL_VCPricingV2.defaultMaterialgroup1;
        String defaultMaterialgroup2 = ensxtx_UTIL_VCPricingV2.defaultMaterialgroup2;
        Test.stopTest();
    }

    @isTest static void test_simulatePricing()
    {
        Mockensxtx_SBO_EnosixPricing_Detail sbo = new Mockensxtx_SBO_EnosixPricing_Detail();
        ensxsdk.EnosixFramework.setMock(ensxtx_SBO_EnosixPricing_Detail.class, sbo);
        ensxtx_SBO_EnosixPricing_Detail.EnosixOpportunityPricing oppPricingDetail = (ensxtx_SBO_EnosixPricing_Detail.EnosixOpportunityPricing) sbo.executeGetDetail(null);
        ensxtx_DS_SalesDocAppSettings appSettings = new ensxtx_DS_SalesDocAppSettings();
        appSettings.SBODetailType = (String)ensxtx_UTIL_AppSettings.getValue(ensxtx_UTIL_AppSettings.CPQV2, 'SBODetailType', 'Pricing');
        appSettings.enableBoMItemEdit = true;
        ensxtx_DS_Document_Detail salesDocDetail = new ensxtx_DS_Document_Detail();
        ensxtx_UTIL_Document_Detail.convertToObject(oppPricingDetail, salesDocDetail, false, appSettings, ensxtx_UTIL_Document_Detail.convertToObjectTrigger.simulateSalesDoc);

        Test.startTest();
        ensxtx_UTIL_VCPricingV2.simulatePricing(salesDocDetail);
        sbo.setSuccess(false);
        try {
            ensxtx_UTIL_VCPricingV2.simulatePricing(salesDocDetail);
        } catch (Exception e) {}
        Test.stopTest();
    }

    @isTest static void test_simulatePricing_incomplete()
    {
        Mockensxtx_SBO_EnosixPricing_Detail sbo = new Mockensxtx_SBO_EnosixPricing_Detail();
        ensxsdk.EnosixFramework.setMock(ensxtx_SBO_EnosixPricing_Detail.class, sbo);
        ensxtx_SBO_EnosixPricing_Detail.EnosixOpportunityPricing oppPricingDetail = (ensxtx_SBO_EnosixPricing_Detail.EnosixOpportunityPricing) sbo.executeGetDetail(null);
        ensxtx_DS_SalesDocAppSettings appSettings = new ensxtx_DS_SalesDocAppSettings();
        appSettings.SBODetailType = (String)ensxtx_UTIL_AppSettings.getValue(ensxtx_UTIL_AppSettings.CPQV2, 'SBODetailType', 'Pricing');
        appSettings.enableBoMItemEdit = true;
        ensxtx_DS_Document_Detail salesDocDetail = new ensxtx_DS_Document_Detail();
        ensxtx_UTIL_Document_Detail.convertToObject(oppPricingDetail, salesDocDetail, false, appSettings, ensxtx_UTIL_Document_Detail.convertToObjectTrigger.simulateSalesDoc);

        Test.startTest();
        ensxtx_UTIL_AppSettings.getValue(ensxtx_UTIL_AppSettings.CPQV2, 'isIncompleteAllowed', false);
        String setKey = ensxtx_UTIL_AppSettings.Prefix + ensxtx_UTIL_AppSettings.CPQV2 + ensxtx_UTIL_AppSettings.Suffix;
        Map<String, Object> settingsMap = ensxtx_UTIL_AppSettings.settingsMap.get(setKey);
        settingsMap.put('isIncompleteAllowed', true);
        ensxtx_UTIL_AppSettings.settingsMap.put(setKey, settingsMap);
        ensxtx_DS_Document_Detail.ITEMS item = salesDocDetail.ITEMS[0];
        item.isConfigurationFromVCComplete = false;
        salesDocDetail.ITEMS.clear();
        salesDocDetail.ITEMS.add(item);
        ensxtx_UTIL_VCPricingV2.simulatePricing(salesDocDetail);
        Test.stopTest();
    }

    @isTest static void test_hasErrorMessages()
    {
        Test.startTest();
        ensxsdk.EnosixFramework.Message m1 = new ensxsdk.EnosixFramework.Message(ensxsdk.EnosixFramework.MessageType.ERROR, 'm1');
        try {
            ensxtx_UTIL_VCPricingV2.hasErrorMessages(new List<ensxsdk.EnosixFramework.Message>());
        } catch (Exception e) {}
        try {
            ensxtx_UTIL_VCPricingV2.hasErrorMessages(new List<ensxsdk.EnosixFramework.Message>{m1});
        } catch (Exception e) {}
        Test.stopTest();
    }

    @isTest static void test_handleSimulateFailure()
    {
        Test.startTest();
        ensxsdk.EnosixFramework.Message m1 = new ensxsdk.EnosixFramework.Message(ensxsdk.EnosixFramework.MessageType.ERROR, 'm1');
        try {
            ensxtx_UTIL_VCPricingV2.handleSimulateFailure(new List<ensxsdk.EnosixFramework.Message>());
        } catch (Exception e) {}
        try {
            ensxtx_UTIL_VCPricingV2.handleSimulateFailure(new List<ensxsdk.EnosixFramework.Message>{m1});
        } catch (Exception e) {}
        Test.stopTest();
    }
}