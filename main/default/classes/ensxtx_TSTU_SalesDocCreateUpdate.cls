@isTest
public class ensxtx_TSTU_SalesDocCreateUpdate
{
    public class MOC_ensxtx_SBO_EnosixCustomer_Detail implements ensxsdk.EnosixFramework.DetailSBOGetMock
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

        public ensxsdk.EnosixFramework.DetailObject executeGetDetail(object key)
        {
            if (throwException) throw new CalloutException();

            ensxtx_SBO_EnosixCustomer_Detail.EnosixCustomer result = new ensxtx_SBO_EnosixCustomer_Detail.EnosixCustomer();            
            result.setSuccess(this.success);
            return result;
        }
    }

    public class MOC_ensxtx_RFC_SD_GET_SHIP_INFO implements ensxsdk.EnosixFramework.RFCMock
    {
        public boolean success = true;

        public void setSuccess(boolean successful)
        {
            this.success = successful;
        }

        private boolean throwException = false;

        public void setThrowException(boolean throwException)
        {
            this.throwException = throwException;
        }

        public ensxsdk.EnosixFramework.FunctionObject executeFunction()
        {
            if (throwException) throw new CalloutException();
            ensxtx_RFC_SD_GET_SHIP_INFO.RESULT result = new ensxtx_RFC_SD_GET_SHIP_INFO.RESULT();
            result.setSuccess(this.success);
            return result;
        }
    }

    public class MOC_ensxtx_RFC_SD_GET_PRICING_STAT implements ensxsdk.EnosixFramework.RFCMock
    {
        public boolean success = true;

        public void setSuccess(boolean successful)
        {
            this.success = successful;
        }

        private boolean throwException = false;

        public void setThrowException(boolean throwException)
        {
            this.throwException = throwException;
        }

        public ensxsdk.EnosixFramework.FunctionObject executeFunction()
        {
            if (throwException) throw new CalloutException();
            ensxtx_RFC_SD_GET_PRICING_STAT.RESULT result = new ensxtx_RFC_SD_GET_PRICING_STAT.RESULT();
            result.setSuccess(this.success);
            return result;
        }
    }

    public class MOC_ensxtx_RFC_SD_GET_GROUP_OFFICE implements ensxsdk.EnosixFramework.RFCMock
    {
        public boolean success = true;

        public void setSuccess(boolean successful)
        {
            this.success = successful;
        }

        private boolean throwException = false;

        public void setThrowException(boolean throwException)
        {
            this.throwException = throwException;
        }

        public ensxsdk.EnosixFramework.FunctionObject executeFunction()
        {
            if (throwException) throw new CalloutException();
            ensxtx_RFC_SD_GET_GROUP_OFFICE.RESULT result = new ensxtx_RFC_SD_GET_GROUP_OFFICE.RESULT();
            result.setSuccess(this.success);
            return result;
        }
    }

    public class MOC_ensxtx_RFC_SD_GET_CONDITION_TYPES implements ensxsdk.EnosixFramework.RFCMock
    {
        public boolean success = true;

        public void setSuccess(boolean successful)
        {
            this.success = successful;
        }

        private boolean throwException = false;

        public void setThrowException(boolean throwException)
        {
            this.throwException = throwException;
        }

        public ensxsdk.EnosixFramework.FunctionObject executeFunction()
        {
            if (throwException) throw new CalloutException();
            ensxtx_RFC_SD_GET_CONDITION_TYPES.RESULT result = new ensxtx_RFC_SD_GET_CONDITION_TYPES.RESULT();
            result.setSuccess(this.success);
            return result;
        }
    }

    public class MOC_ensxtx_RFC_SD_GET_REJECTION_REASONS implements ensxsdk.EnosixFramework.RFCMock
    {
        public boolean success = true;

        public void setSuccess(boolean successful)
        {
            this.success = successful;
        }

        private boolean throwException = false;

        public void setThrowException(boolean throwException)
        {
            this.throwException = throwException;
        }

        public ensxsdk.EnosixFramework.FunctionObject executeFunction()
        {
            if (throwException) throw new CalloutException();
            ensxtx_RFC_SD_GET_REJECTION_REASONS.RESULT result = new ensxtx_RFC_SD_GET_REJECTION_REASONS.RESULT();
            result.setSuccess(this.success);
            return result;
        }
    }

    public class MOC_ensxtx_RFC_SD_GET_PERIO implements ensxsdk.EnosixFramework.RFCMock
    {
        public boolean success = true;

        public void setSuccess(boolean successful)
        {
            this.success = successful;
        }

        private boolean throwException = false;

        public void setThrowException(boolean throwException)
        {
            this.throwException = throwException;
        }

        public ensxsdk.EnosixFramework.FunctionObject executeFunction()
        {
            if (throwException) throw new CalloutException();
            ensxtx_RFC_SD_GET_PERIO.RESULT result = new ensxtx_RFC_SD_GET_PERIO.RESULT();
            result.setSuccess(this.success);
            return result;
        }
    }

    public class MOC_ensxtx_RFC_SD_GET_COUNTRIES implements ensxsdk.EnosixFramework.RFCMock
    {
        public boolean success = true;

        public void setSuccess(boolean successful)
        {
            this.success = successful;
        }

        private boolean throwException = false;

        public void setThrowException(boolean throwException)
        {
            this.throwException = throwException;
        }

        public ensxsdk.EnosixFramework.FunctionObject executeFunction()
        {
            if (throwException) throw new CalloutException();
            ensxtx_RFC_SD_GET_COUNTRIES.RESULT result = new ensxtx_RFC_SD_GET_COUNTRIES.RESULT();
            result.setSuccess(this.success);
            return result;
        }
    }

    public class MOC_ensxtx_RFC_SD_GET_ITEMCAT_VALUES implements ensxsdk.EnosixFramework.RFCMock
    {
        public boolean success = true;

        public void setSuccess(boolean successful)
        {
            this.success = successful;
        }

        private boolean throwException = false;

        public void setThrowException(boolean throwException)
        {
            this.throwException = throwException;
        }

        public ensxsdk.EnosixFramework.FunctionObject executeFunction()
        {
            if (throwException) throw new CalloutException();
            ensxtx_RFC_SD_GET_ITEMCAT_VALUES.RESULT result = new ensxtx_RFC_SD_GET_ITEMCAT_VALUES.RESULT();
            result.setSuccess(this.success);
            return result;
        }
    }

    public class MOC_ensxtx_RFC_SD_GET_MATERIAL_UOM implements ensxsdk.EnosixFramework.RFCMock
    {
        public boolean success = true;

        public void setSuccess(boolean successful)
        {
            this.success = successful;
        }

        private boolean throwException = false;

        public void setThrowException(boolean throwException)
        {
            this.throwException = throwException;
        }

        public ensxsdk.EnosixFramework.FunctionObject executeFunction()
        {
            if (throwException) throw new CalloutException();
            ensxtx_RFC_SD_GET_MATERIAL_UOM.RESULT result = new ensxtx_RFC_SD_GET_MATERIAL_UOM.RESULT();
            result.setSuccess(this.success);
            return result;
        }
    }

    public class MOC_ensxtx_SBO_EnosixMaterial_Detail implements ensxsdk.EnosixFramework.DetailSBOGetMock
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

        public ensxsdk.EnosixFramework.DetailObject executeGetDetail(object key)
        {
            if (throwException) throw new CalloutException();

            ensxtx_SBO_EnosixMaterial_Detail.EnosixMaterial result = new ensxtx_SBO_EnosixMaterial_Detail.EnosixMaterial();  
            ensxtx_SBO_EnosixMaterial_Detail.PLANT_DATA plantData = new ensxtx_SBO_EnosixMaterial_Detail.PLANT_DATA();
            plantData.Plant = 'Plant';
            plantData.Name = 'Name';
            plantData.SalesOrganization = '0001';
            plantData.DistributionChannel = '01';
            result.PLANT_DATA.add(plantData);
            result.setSuccess(this.success);
            return result;
        }
    }

    public class MOC_ensxtx_SBO_EnosixSalesDocument_Detail implements ensxsdk.EnosixFramework.DetailSBOGetMock,
        ensxsdk.EnosixFramework.DetailSBOCommandMock, ensxsdk.EnosixFramework.DetailSBOSaveMock
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

        public ensxsdk.EnosixFramework.DetailObject executeGetDetail(object key)
        {
            if (throwException) throw new CalloutException();

            ensxtx_SBO_EnosixSalesDocument_Detail.EnosixSalesDocument result = new ensxtx_SBO_EnosixSalesDocument_Detail.EnosixSalesDocument();
            ensxtx_SBO_EnosixSalesDocument_Detail.ITEMS item = new ensxtx_SBO_EnosixSalesDocument_Detail.ITEMS();
            item.ItemNumber = '10';
            item.Material = null;
            result.ITEMS.add(item);
            result.setSuccess(success);
            return result;
        }

        public ensxsdk.EnosixFramework.DetailObject executeCommand(String command, ensxsdk.EnosixFramework.DetailObject obj)
        {
            if (throwException) throw new CalloutException();

            ensxtx_SBO_EnosixSalesDocument_Detail.EnosixSalesDocument result = new ensxtx_SBO_EnosixSalesDocument_Detail.EnosixSalesDocument();
            result.setSuccess(success);
            return result;
        }

        public ensxsdk.EnosixFramework.DetailObject executeSave(ensxsdk.EnosixFramework.DetailObject obj)
        {
            ensxtx_SBO_EnosixSalesDocument_Detail.EnosixSalesDocument result = new ensxtx_SBO_EnosixSalesDocument_Detail.EnosixSalesDocument();
            result.setSuccess(success);
            return result;
        }
    }

    @isTest
    public static void test_getAppSettings()
    {
        ensxtx_DS_SalesDocAppSettings appSettings = createTestAppSettings();
        ensxtx_UTIL_SalesDocCreateUpdate.getAppSettings('OrderApp', 'SalesDoc', 'DefaultOrder');
        ensxtx_UTIL_SalesDocCreateUpdate.getAppSettings('ThrowError', 'ThrowError', 'ThrowError');
    }

    public static ensxtx_DS_SalesDocAppSettings createTestAppSettings()
    {
        ensxtx_DS_SalesDocAppSettings appSettings = new ensxtx_DS_SalesDocAppSettings();
        appSettings.itemNumberIncrement = 10;
        appSettings.bomItemNumberIncrement = 1;
        appSettings.SBODetailType = 'SalesDocument';
        appSettings.SAPDocType = 'Order';
        appSettings.Header = new ensxtx_DS_SalesDocAppSettings.DocumentSetting();
        appSettings.Header.PartnerPickers = new List<ensxtx_DS_SalesDocAppSettings.PartnerSetting>();
        appSettings.Header.Texts =  new List<ensxtx_DS_SalesDocAppSettings.TextSetting>();
        appSettings.Item = new ensxtx_DS_SalesDocAppSettings.DocumentSetting();
        appSettings.Item.PartnerPickers = new List<ensxtx_DS_SalesDocAppSettings.PartnerSetting>();
        appSettings.Item.Texts =  new List<ensxtx_DS_SalesDocAppSettings.TextSetting>();
        appSettings.enableBoMItemEdit = false;
        appSettings.showHeaderIncompletionLogs = true;
        appSettings.showItemIncompletionLogs = true;
        appSettings.incompletionLogsAsErrors = false;
        appSettings.insertSalesDocLog = false;
        appSettings.useConvertToObjectTrigger = false;
        appSettings.updateLineItems = false;
        ensxtx_DS_SalesDocAppSettings.InvokeMethodAppSetting invokeMethod = new ensxtx_DS_SalesDocAppSettings.InvokeMethodAppSetting();
        invokeMethod.InvokeMethod = 'Create';
        invokeMethod.insertSalesDocLog = false;
        appSettings.InvokeMethodAppSettings = new List<ensxtx_DS_SalesDocAppSettings.InvokeMethodAppSetting>{invokeMethod};
        appSettings.enableBoMCountCommand = true;
        appSettings.InvokeMethod = 'Create';
        updateAppSettings(appSettings, 'OrderApp', 'SalesDoc', 'DefaultOrder');
        return appSettings;
    }

    private static void updateAppSettings(ensxtx_DS_SalesDocAppSettings appSettings, String appSettingsName, String appSettingsKey, String appSettingsTypeName)
    {
        Map<String, Object> appSettingsMap = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(appSettings));
        Map<String, ensxtx_DS_SalesDocAppSettings> typeNameMap = new Map<String, ensxtx_DS_SalesDocAppSettings>();
        typeNameMap.put(appSettingsTypeName, appSettings);
        Map<String, Object> settingsMap = new Map<String, Object>();
        settingsMap.put(appSettingsKey, typeNameMap);
        String setKey = 'ensxtx_SR_enosix' + appSettingsName + 'Settings';
        ensxtx_UTIL_AppSettings.settingsMap.put(setKey, settingsMap);
    }

    @isTest
    public static void test_initSFObject()
    {
        Opportunity opp = ensxtx_TSTU_SFTestObject.createTestOpportunity();
        ensxtx_TSTU_SFTestObject.upsertWithRetry(opp);

        ensxtx_UTIL_SalesDocCreateUpdate.initSFObject(opp.Id, 'Order');
    }

    @isTest
    public static void test_getCustomerDetail()
    {
        MOC_ensxtx_SBO_EnosixCustomer_Detail mocEnosixCustomerDetail = new MOC_ensxtx_SBO_EnosixCustomer_Detail();
        ensxsdk.EnosixFramework.setMock(ensxtx_SBO_EnosixCustomer_Detail.class, mocEnosixCustomerDetail);

        ensxtx_UTIL_SalesDocCreateUpdate.getCustomerDetail('TEST');

        mocEnosixCustomerDetail.setThrowException(true);
        ensxtx_UTIL_SalesDocCreateUpdate.getCustomerDetail('TEST');
    }

    @isTest
    public static void test_compareSAPSimulateVsSObject()
    {
        ensxtx_DS_Document_Detail salesDocDetail = new ensxtx_DS_Document_Detail();
        ensxtx_DS_SalesDocAppSettings appSettings = new ensxtx_DS_SalesDocAppSettings();

        ensxtx_UTIL_SalesDocCreateUpdate.compareSAPSimulateVsSObject(salesDocDetail, salesDocDetail, appSettings);

        try {
            ensxtx_UTIL_SalesDocCreateUpdate.compareSAPSimulateVsSObject(null, null, null);
        } catch (Exception ex){}
    }

    @isTest
    public static void test_mapChildBomFields()
    {
        ensxtx_DS_Document_Detail salesDocDetail = new ensxtx_DS_Document_Detail();
        ensxtx_DS_SalesDocAppSettings appSettings = new ensxtx_DS_SalesDocAppSettings();

        ensxtx_UTIL_SalesDocCreateUpdate.mapChildBomFields(salesDocDetail, salesDocDetail, appSettings);

        try {
            ensxtx_UTIL_SalesDocCreateUpdate.mapChildBomFields(null, null, null);
        } catch (Exception ex){}
    }

    @isTest
    public static void test_initSalesDocDetailFromSFObject()
    {
        ensxtx_DS_Document_Detail salesDocDetail = new ensxtx_DS_Document_Detail();
        ensxtx_UTIL_SalesDoc.SFObject sfObject = new ensxtx_UTIL_SalesDoc.SFObject();
        ensxtx_DS_SalesDocAppSettings appSettings = new ensxtx_DS_SalesDocAppSettings();

        ensxtx_UTIL_SalesDocCreateUpdate.initSalesDocDetailFromSFObject(salesDocDetail, sfObject, appSettings);

        Opportunity opp = new Opportunity();
        //opp.ensxtx_SAP_SaveSalesDocHeader__c = 'Bad Data';
        sfObject.sfMainObject = opp;

        ensxtx_UTIL_SalesDocCreateUpdate.initSalesDocDetailFromSFObject(salesDocDetail, sfObject, appSettings);
        try {
            ensxtx_UTIL_SalesDocCreateUpdate.initSalesDocDetailFromSFObject(null, null, null);
        } catch (Exception ex){}
    }

    @isTest
    public static void test_getSalesDocDetail()
    {

        MOC_ensxtx_SBO_EnosixSalesDocument_Detail mocEnosixSalesDocumentDetail = new MOC_ensxtx_SBO_EnosixSalesDocument_Detail();
        ensxsdk.EnosixFramework.setMock(ensxtx_SBO_EnosixSalesDocument_Detail.class, mocEnosixSalesDocumentDetail);
        ensxtx_DS_SalesDocAppSettings appSettings = createAppSettings();
        appSettings.Header = new ensxtx_DS_SalesDocAppSettings.DocumentSetting();
        appSettings.Header.Texts = new List<ensxtx_DS_SalesDocAppSettings.TextSetting>();
        appSettings.Header.PartnerPickers = new List<ensxtx_DS_SalesDocAppSettings.PartnerSetting>();
        appSettings.Item = new ensxtx_DS_SalesDocAppSettings.DocumentSetting();
        appSettings.Item.Texts = new List<ensxtx_DS_SalesDocAppSettings.TextSetting>();
        appSettings.Item.PartnerPickers = new List<ensxtx_DS_SalesDocAppSettings.PartnerSetting>();
        appSettings.mapUpdateFromSObject = false;

        ensxtx_UTIL_SalesDoc.SFObject sfObject = new ensxtx_UTIL_SalesDoc.SFObject();
        Opportunity opp = ensxtx_TSTU_SFTestObject.createTestOpportunity();
        ensxtx_TSTU_SFTestObject.upsertWithRetry(opp);

        OpportunityLineItem oli = ensxtx_TSTU_SFTestObject.createTestOpportunityLineItem();
        oli.OpportunityId = opp.Id;
        oli.Quantity = 10;
        oli.UnitPrice = .95;
        oli.Description = 'test Desciption';

        sfObject = new ensxtx_UTIL_SalesDoc.SFObject();
        sfObject.sfLineItems = new List<SObject>{oli};
        sfObject.initFromSObject = true;
        sfObject.sfMainObject = opp;

        ensxtx_UTIL_SalesDocCreateUpdate.getSalesDocDetail('salesDocNumber', appSettings, sfObject);
        appSettings.mapUpdateFromSObject = true;
        ensxtx_UTIL_SalesDocCreateUpdate.getSalesDocDetail('salesDocNumber', appSettings, sfObject);

        mocEnosixSalesDocumentDetail.setThrowException(true);
        ensxtx_UTIL_SalesDocCreateUpdate.getSalesDocDetail('salesDocNumber', appSettings, sfObject);
    }

    @isTest
    public static void test_getReferenceDocument()
    {
        MOC_ensxtx_SBO_EnosixSalesDocument_Detail mocEnosixSalesDocumentDetail = new MOC_ensxtx_SBO_EnosixSalesDocument_Detail();
        ensxsdk.EnosixFramework.setMock(ensxtx_SBO_EnosixSalesDocument_Detail.class, mocEnosixSalesDocumentDetail);

        ensxtx_DS_Document_Detail salesDocDetail = new ensxtx_DS_Document_Detail();
        ensxtx_DS_SalesDocAppSettings appSettings = createAppSettings();
        appSettings.Header = new ensxtx_DS_SalesDocAppSettings.DocumentSetting();
        appSettings.Header.Texts = new List<ensxtx_DS_SalesDocAppSettings.TextSetting>();

        ensxtx_UTIL_SalesDocCreateUpdate.getReferenceDocument('111', appSettings);

        mocEnosixSalesDocumentDetail.setThrowException(true);
        ensxtx_UTIL_SalesDocCreateUpdate.getReferenceDocument('111', appSettings);
    }

    @isTest
    public static void test_getBomItemsCount()
    {
        MOC_ensxtx_SBO_EnosixSalesDocument_Detail mocEnosixSalesDocumentDetail = new MOC_ensxtx_SBO_EnosixSalesDocument_Detail();
        ensxsdk.EnosixFramework.setMock(ensxtx_SBO_EnosixSalesDocument_Detail.class, mocEnosixSalesDocumentDetail);

        ensxtx_DS_Document_Detail salesDocDetail = new ensxtx_DS_Document_Detail();
        ensxtx_DS_SalesDocAppSettings appSettings = createAppSettings();
        appSettings.enableBoMCountCommand = true;

        ensxtx_UTIL_SalesDocCreateUpdate.getBomItemsCount(salesDocDetail, appSettings);

        mocEnosixSalesDocumentDetail.setThrowException(true);
        ensxtx_UTIL_SalesDocCreateUpdate.getBomItemsCount(salesDocDetail, appSettings);
    }

    @isTest
    public static void test_setItemNumberBasedOnBOMCount()
    {
        ensxtx_DS_SalesDocAppSettings appSettings = createAppSettings();
        appSettings.enableBoMCountCommand = true;
        ensxtx_DS_Document_Detail salesDocDetail = new ensxtx_DS_Document_Detail();
        ensxtx_DS_Document_Detail.ITEMS item = new ensxtx_DS_Document_Detail.ITEMS();
        item.BOMCount = '5';
        salesDocDetail.ITEMS.add(item);
        ensxtx_UTIL_SalesDocCreateUpdate.setItemNumberBasedOnBOMCount(salesDocDetail, appSettings);
        ensxtx_UTIL_SalesDocCreateUpdate.setItemNumberBasedOnBOMCount(salesDocDetail, null);
    }
    
    @isTest
    public static void test_simulateSalesDoc()
    {
        MOC_ensxtx_SBO_EnosixSalesDocument_Detail mocEnosixSalesDocumentDetail = new MOC_ensxtx_SBO_EnosixSalesDocument_Detail();
        ensxsdk.EnosixFramework.setMock(ensxtx_SBO_EnosixSalesDocument_Detail.class, mocEnosixSalesDocumentDetail);

        ensxtx_DS_Document_Detail salesDocDetail = new ensxtx_DS_Document_Detail();
        ensxtx_DS_SalesDocAppSettings appSettings = createAppSettings();

        ensxtx_UTIL_SalesDocCreateUpdate.simulateSalesDoc(salesDocDetail, appSettings);

        mocEnosixSalesDocumentDetail.setThrowException(true);
        ensxtx_UTIL_SalesDocCreateUpdate.simulateSalesDoc(salesDocDetail, appSettings);
    }

    @isTest
    public static void test_saveToSObject()
    {
        ensxtx_UTIL_SalesDoc.SFObject sfObject = new ensxtx_UTIL_SalesDoc.SFObject();
        ensxtx_DS_Document_Detail salesDocDetail = new ensxtx_DS_Document_Detail();

        ensxtx_UTIL_SalesDocCreateUpdate.saveToSObject(sfObject, salesDocDetail, new ensxtx_DS_SalesDocAppSettings());
    }

    @isTest
    public static void test_createSAPDocument()
    {
        MOC_ensxtx_SBO_EnosixSalesDocument_Detail mocEnosixSalesDocumentDetail = new MOC_ensxtx_SBO_EnosixSalesDocument_Detail();
        ensxsdk.EnosixFramework.setMock(ensxtx_SBO_EnosixSalesDocument_Detail.class, mocEnosixSalesDocumentDetail);
        
        Id pricebookId = Test.getStandardPricebookId();
        ensxtx_UTIL_SalesDoc.SFObject sfObject = new ensxtx_UTIL_SalesDoc.SFObject();
        ensxtx_DS_SalesDocAppSettings appSettings = createAppSettings();
        
        ensxtx_DS_Document_Detail salesDocDetail = ensxtx_TSTD_Document_Detail.buildsalesDocDetail();

        ensxtx_UTIL_SalesDocCreateUpdate.createSAPDocument(sfObject, salesDocDetail, appSettings);
        Opportunity opp = ensxtx_TSTU_SFTestObject.createTestOpportunity();
        ensxtx_TSTU_SFTestObject.upsertWithRetry(opp);
        sfObject = new ensxtx_UTIL_SalesDoc.SFObject();
        sfObject.sfLineItems = new List<SObject>();
        sfObject.initFromSObject = true;
        sfObject.sfMainObject = opp;
        ensxtx_UTIL_SalesDocCreateUpdate.createSAPDocument(sfObject, salesDocDetail, appSettings);
    }

    @isTest
    public static void test_updateSAPDocument()
    {
        MOC_ensxtx_SBO_EnosixSalesDocument_Detail mocEnosixSalesDocumentDetail = new MOC_ensxtx_SBO_EnosixSalesDocument_Detail();
        ensxsdk.EnosixFramework.setMock(ensxtx_SBO_EnosixSalesDocument_Detail.class, mocEnosixSalesDocumentDetail);
        
        Id pricebookId = Test.getStandardPricebookId();
        ensxtx_UTIL_SalesDoc.SFObject sfObject = new ensxtx_UTIL_SalesDoc.SFObject();
        ensxtx_DS_SalesDocAppSettings appSettings = createAppSettings();
        
        ensxtx_DS_Document_Detail salesDocDetail = ensxtx_TSTD_Document_Detail.buildsalesDocDetail();

        ensxtx_UTIL_SalesDocCreateUpdate.updateSAPDocument(sfObject, salesDocDetail, appSettings);
        Opportunity opp = ensxtx_TSTU_SFTestObject.createTestOpportunity();
        ensxtx_TSTU_SFTestObject.upsertWithRetry(opp);
        sfObject = new ensxtx_UTIL_SalesDoc.SFObject();
        sfObject.sfLineItems = new List<SObject>();
        sfObject.initFromSObject = true;
        sfObject.sfMainObject = opp;
        ensxtx_UTIL_SalesDocCreateUpdate.updateSAPDocument(sfObject, salesDocDetail, appSettings);
    }

    private static ensxtx_DS_SalesDocAppSettings createAppSettings()
    {
        ensxtx_DS_SalesDocAppSettings appSettings = new ensxtx_DS_SalesDocAppSettings();
        appSettings.SBODetailType = 'SalesDocument';
        appSettings.SAPDocType = 'Quote';
        appSettings.enableBoMItemEdit = false;
        appSettings.updateLineItems = true;
        appSettings.deleteLineItems = true;
        appSettings.useConvertToObjectTrigger = false;
        appSettings.bomItemNumberIncrement = 1;
        appSettings.itemNumberIncrement = 10;
        appSettings.compareSAPSimulateVsSObject = true;
        return appSettings;
    }
}