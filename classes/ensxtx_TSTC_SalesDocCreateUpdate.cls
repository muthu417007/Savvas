@isTest
public class ensxtx_TSTC_SalesDocCreateUpdate
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
    public static void test_getCustomerDetail()
    {
        MOC_ensxtx_SBO_EnosixCustomer_Detail mocEnosixCustomerDetail = new MOC_ensxtx_SBO_EnosixCustomer_Detail();
        ensxsdk.EnosixFramework.setMock(ensxtx_SBO_EnosixCustomer_Detail.class, mocEnosixCustomerDetail);

        ensxtx_UTIL_Aura.Response response = ensxtx_CTRL_SalesDocCreateUpdate.getCustomerDetail('TEST');

        mocEnosixCustomerDetail.setThrowException(true);
        response = ensxtx_CTRL_SalesDocCreateUpdate.getCustomerDetail('TEST');
    }

    @isTest
    public static void test_getShipInfo()
    {
        MOC_ensxtx_RFC_SD_GET_SHIP_INFO mocRfc = new MOC_ensxtx_RFC_SD_GET_SHIP_INFO();
        ensxsdk.EnosixFramework.setMock(ensxtx_RFC_SD_GET_SHIP_INFO.class, mocRfc);

        ensxtx_UTIL_Aura.Response response = ensxtx_CTRL_SalesDocCreateUpdate.getShipInfo();

        mocRfc.setThrowException(true);
        response = ensxtx_CTRL_SalesDocCreateUpdate.getShipInfo();
    }

    @isTest
    public static void test_getPricingStat()
    {
        MOC_ensxtx_RFC_SD_GET_PRICING_STAT mocRfc = new MOC_ensxtx_RFC_SD_GET_PRICING_STAT();
        ensxsdk.EnosixFramework.setMock(ensxtx_RFC_SD_GET_PRICING_STAT.class, mocRfc);

        ensxtx_UTIL_Aura.Response response = ensxtx_CTRL_SalesDocCreateUpdate.getPricingStat();

        mocRfc.setThrowException(true);
        response = ensxtx_CTRL_SalesDocCreateUpdate.getPricingStat();
    }

    @isTest
    public static void test_getGroupOffice()
    {
        MOC_ensxtx_RFC_SD_GET_GROUP_OFFICE mocRfc = new MOC_ensxtx_RFC_SD_GET_GROUP_OFFICE();
        ensxsdk.EnosixFramework.setMock(ensxtx_RFC_SD_GET_GROUP_OFFICE.class, mocRfc);

        ensxtx_UTIL_Aura.Response response = ensxtx_CTRL_SalesDocCreateUpdate.getGroupOffice();

        mocRfc.setThrowException(true);
        response = ensxtx_CTRL_SalesDocCreateUpdate.getGroupOffice();
    }

    @isTest
    public static void test_getConditionTypes()
    {
        MOC_ensxtx_RFC_SD_GET_CONDITION_TYPES mocRfc = new MOC_ensxtx_RFC_SD_GET_CONDITION_TYPES();
        ensxsdk.EnosixFramework.setMock(ensxtx_RFC_SD_GET_CONDITION_TYPES.class, mocRfc);

        ensxtx_UTIL_Aura.Response response = ensxtx_CTRL_SalesDocCreateUpdate.getConditionTypes(true, 'procedure');

        mocRfc.setThrowException(true);
        response = ensxtx_CTRL_SalesDocCreateUpdate.getConditionTypes(true, 'procedure');
    }

    @isTest
    public static void test_getRejectionReasons()
    {
        MOC_ensxtx_RFC_SD_GET_REJECTION_REASONS mocRfc = new MOC_ensxtx_RFC_SD_GET_REJECTION_REASONS();
        ensxsdk.EnosixFramework.setMock(ensxtx_RFC_SD_GET_REJECTION_REASONS.class, mocRfc);

        ensxtx_UTIL_Aura.Response response = ensxtx_CTRL_SalesDocCreateUpdate.getRejectionReasons();

        mocRfc.setThrowException(true);
        response = ensxtx_CTRL_SalesDocCreateUpdate.getRejectionReasons();
    }

    @isTest
    public static void test_getBillingPlans()
    {
        MOC_ensxtx_RFC_SD_GET_PERIO mocRfc = new MOC_ensxtx_RFC_SD_GET_PERIO();
        ensxsdk.EnosixFramework.setMock(ensxtx_RFC_SD_GET_PERIO.class, mocRfc);

        ensxtx_UTIL_Aura.Response response = ensxtx_CTRL_SalesDocCreateUpdate.getBillingPlans();

        mocRfc.setThrowException(true);
        response = ensxtx_CTRL_SalesDocCreateUpdate.getBillingPlans();
    }

    @isTest
    public static void test_getCountries()
    {
        MOC_ensxtx_RFC_SD_GET_COUNTRIES mocRfc = new MOC_ensxtx_RFC_SD_GET_COUNTRIES();
        ensxsdk.EnosixFramework.setMock(ensxtx_RFC_SD_GET_COUNTRIES.class, mocRfc);

        ensxtx_UTIL_Aura.Response response = ensxtx_CTRL_SalesDocCreateUpdate.getCountries();

        mocRfc.setThrowException(true);
        response = ensxtx_CTRL_SalesDocCreateUpdate.getCountries();
    }

    @isTest
    public static void test_getItemCategories()
    {
        MOC_ensxtx_RFC_SD_GET_ITEMCAT_VALUES mocRfc = new MOC_ensxtx_RFC_SD_GET_ITEMCAT_VALUES();
        ensxsdk.EnosixFramework.setMock(ensxtx_RFC_SD_GET_ITEMCAT_VALUES.class, mocRfc);

        ensxtx_UTIL_Aura.Response response = ensxtx_CTRL_SalesDocCreateUpdate.getItemCategories(new ensxtx_DS_Document_Detail.SALES(), '');

        mocRfc.setThrowException(true);
        response = ensxtx_CTRL_SalesDocCreateUpdate.getItemCategories(new ensxtx_DS_Document_Detail.SALES(), '');
    }

    @isTest
    public static void test_getMaterialUOM()
    {
        MOC_ensxtx_RFC_SD_GET_MATERIAL_UOM mocRfc = new MOC_ensxtx_RFC_SD_GET_MATERIAL_UOM();
        ensxsdk.EnosixFramework.setMock(ensxtx_RFC_SD_GET_MATERIAL_UOM.class, mocRfc);

        ensxtx_UTIL_Aura.Response response = ensxtx_CTRL_SalesDocCreateUpdate.getMaterialUOM('test');

        mocRfc.setThrowException(true);
        response = ensxtx_CTRL_SalesDocCreateUpdate.getMaterialUOM('test');
    }

    @isTest
    public static void test_getMaterialSalesText()
    {
        MOC_ensxtx_SBO_EnosixMaterial_Detail mocEnosixMaterialDetail = new MOC_ensxtx_SBO_EnosixMaterial_Detail();
        ensxsdk.EnosixFramework.setMock(ensxtx_SBO_EnosixMaterial_Detail.class, mocEnosixMaterialDetail);

        ensxtx_UTIL_Aura.Response response = ensxtx_CTRL_SalesDocCreateUpdate.getMaterialsDetail(new List<String>{'TEST'}, '111', '222');

        mocEnosixMaterialDetail.setSuccess(false);
        response = ensxtx_CTRL_SalesDocCreateUpdate.getMaterialsDetail(new List<String>{'TEST'}, '111', '222');

        mocEnosixMaterialDetail.setThrowException(true);
        response = ensxtx_CTRL_SalesDocCreateUpdate.getMaterialsDetail(new List<String>{'TEST'}, '111', '222');
    }

    @isTest
    public static void test_getMaterialAvailability()
    {
        MOC_ensxtx_SBO_EnosixMaterial_Detail mocEnosixMaterialDetail = new MOC_ensxtx_SBO_EnosixMaterial_Detail();
        ensxsdk.EnosixFramework.setMock(ensxtx_SBO_EnosixMaterial_Detail.class, mocEnosixMaterialDetail);

        ensxtx_UTIL_Aura.Response response = ensxtx_CTRL_SalesDocCreateUpdate.getMaterialAvailability('TEST', '222');

        mocEnosixMaterialDetail.setSuccess(false);
        response = ensxtx_CTRL_SalesDocCreateUpdate.getMaterialAvailability('TEST', '222');

        mocEnosixMaterialDetail.setThrowException(true);
        response = ensxtx_CTRL_SalesDocCreateUpdate.getMaterialAvailability('TEST', '222');
    }

    @isTest
    public static void test_initSFObject()
    {
        Opportunity opp = ensxtx_TSTU_SFTestObject.createTestOpportunity();
        ensxtx_TSTU_SFTestObject.upsertWithRetry(opp);

        ensxtx_UTIL_Aura.Response response = ensxtx_CTRL_SalesDocCreateUpdate.initSFObject(opp.Id, 'Order');
    }

    @isTest
    public static void test_initSalesDocDetailFromSFObject()
    {
        ensxtx_DS_Document_Detail salesDocDetail = new ensxtx_DS_Document_Detail();
        ensxtx_UTIL_SalesDoc.SFObject sfObject = new ensxtx_UTIL_SalesDoc.SFObject();
        ensxtx_DS_SalesDocAppSettings appSettings = new ensxtx_DS_SalesDocAppSettings();

        ensxtx_UTIL_Aura.Response response = ensxtx_CTRL_SalesDocCreateUpdate.initSalesDocDetailFromSFObject(salesDocDetail, sfObject, appSettings);

        Opportunity opp = new Opportunity();
        //opp.ensxtx_SAP_SaveSalesDocHeader__c = 'Bad Data';
        sfObject.sfMainObject = opp;

        response = ensxtx_CTRL_SalesDocCreateUpdate.initSalesDocDetailFromSFObject(salesDocDetail, sfObject, appSettings);
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
        appSettings.mapUpdateFromSObject = true;

        ensxtx_UTIL_SalesDoc.SFObject sfObject = new ensxtx_UTIL_SalesDoc.SFObject();
        Opportunity opp = ensxtx_TSTU_SFTestObject.createTestOpportunity();
        ensxtx_TSTU_SFTestObject.upsertWithRetry(opp);

        OpportunityLineItem oli = ensxtx_TSTU_SFTestObject.createTestOpportunityLineItem();
        oli.OpportunityId = opp.Id;
        oli.Quantity = 10;
        oli.UnitPrice = .95;
        oli.Description = 'test Desciption';
        //oli.put('ensxtx_SAP_Item_Number__c', '10');

        sfObject = new ensxtx_UTIL_SalesDoc.SFObject();
        sfObject.sfLineItems = new List<SObject>{oli};
        sfObject.initFromSObject = true;
        sfObject.sfMainObject = opp;

        ensxtx_UTIL_Aura.Response response = ensxtx_CTRL_SalesDocCreateUpdate.getSalesDocDetail('salesDocNumber', appSettings, sfObject);

        mocEnosixSalesDocumentDetail.setThrowException(true);
        response = ensxtx_CTRL_SalesDocCreateUpdate.getSalesDocDetail('salesDocNumber', appSettings, sfObject);

        response = ensxtx_CTRL_SalesDocCreateUpdate.validateProductsInSalesforce(new List<String>{'Test'}, ensxtx_UTIL_Pricebook.getStandardPriceBookId(), 'salesDocumentCurrency');
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

        ensxtx_UTIL_Aura.Response response = ensxtx_CTRL_SalesDocCreateUpdate.getReferenceDocument('111', appSettings);

        mocEnosixSalesDocumentDetail.setThrowException(true);
        response = ensxtx_CTRL_SalesDocCreateUpdate.getReferenceDocument('111', appSettings);
    }

    @isTest
    public static void test_getBomItemsCount()
    {
        MOC_ensxtx_SBO_EnosixSalesDocument_Detail mocEnosixSalesDocumentDetail = new MOC_ensxtx_SBO_EnosixSalesDocument_Detail();
        ensxsdk.EnosixFramework.setMock(ensxtx_SBO_EnosixSalesDocument_Detail.class, mocEnosixSalesDocumentDetail);

        ensxtx_DS_Document_Detail salesDocDetail = new ensxtx_DS_Document_Detail();
        ensxtx_DS_SalesDocAppSettings appSettings = createAppSettings();

        ensxtx_UTIL_Aura.Response response = ensxtx_CTRL_SalesDocCreateUpdate.getBomItemsCount(salesDocDetail, appSettings);

        mocEnosixSalesDocumentDetail.setThrowException(true);
        response = ensxtx_CTRL_SalesDocCreateUpdate.getBomItemsCount(salesDocDetail, appSettings);
    }
    
    @isTest
    public static void test_simulateSalesDoc()
    {
        MOC_ensxtx_SBO_EnosixSalesDocument_Detail mocEnosixSalesDocumentDetail = new MOC_ensxtx_SBO_EnosixSalesDocument_Detail();
        ensxsdk.EnosixFramework.setMock(ensxtx_SBO_EnosixSalesDocument_Detail.class, mocEnosixSalesDocumentDetail);

        ensxtx_DS_Document_Detail salesDocDetail = new ensxtx_DS_Document_Detail();
        ensxtx_DS_SalesDocAppSettings appSettings = createAppSettings();

        ensxtx_UTIL_Aura.Response response = ensxtx_CTRL_SalesDocCreateUpdate.simulateSalesDoc(salesDocDetail, appSettings);

        mocEnosixSalesDocumentDetail.setThrowException(true);
        response = ensxtx_CTRL_SalesDocCreateUpdate.simulateSalesDoc(salesDocDetail, appSettings);
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

        ensxtx_UTIL_Aura.Response response = ensxtx_CTRL_SalesDocCreateUpdate.createSAPDocument(sfObject, salesDocDetail, appSettings);
        Opportunity opp = ensxtx_TSTU_SFTestObject.createTestOpportunity();
        ensxtx_TSTU_SFTestObject.upsertWithRetry(opp);
        sfObject = new ensxtx_UTIL_SalesDoc.SFObject();
        sfObject.sfLineItems = new List<SObject>();
        sfObject.initFromSObject = true;
        sfObject.sfMainObject = opp;
        response = ensxtx_CTRL_SalesDocCreateUpdate.createSAPDocument(sfObject, salesDocDetail, appSettings);
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

        ensxtx_UTIL_Aura.Response response = ensxtx_CTRL_SalesDocCreateUpdate.updateSAPDocument(sfObject, salesDocDetail, appSettings);
        Opportunity opp = ensxtx_TSTU_SFTestObject.createTestOpportunity();
        ensxtx_TSTU_SFTestObject.upsertWithRetry(opp);
        sfObject = new ensxtx_UTIL_SalesDoc.SFObject();
        sfObject.sfLineItems = new List<SObject>();
        sfObject.initFromSObject = true;
        sfObject.sfMainObject = opp;
        response = ensxtx_CTRL_SalesDocCreateUpdate.updateSAPDocument(sfObject, salesDocDetail, appSettings);
    }

    @isTest
    public static void test_saveToObject()
    {
        ensxtx_UTIL_SalesDoc.SFObject sfObject = new ensxtx_UTIL_SalesDoc.SFObject();
        ensxtx_DS_Document_Detail salesDocDetail = new ensxtx_DS_Document_Detail();

        ensxtx_UTIL_Aura.Response response = ensxtx_CTRL_SalesDocCreateUpdate.saveToSObject(sfObject, salesDocDetail, new ensxtx_DS_SalesDocAppSettings());
    }

    @isTest
    public static void test_closeSession()
    {
        // ensxtx_UTIL_VCRequest.headers = new Map<String,String>();
        // ensxtx_UTIL_VCRequest.headers.put('Test1', 'Test1');
        // ensxtx_UTIL_VCRequest.headers.put('Test2', 'Test2');
        // ensxtx_CTRL_SalesDocCreateUpdate.closeSession(ensxtx_UTIL_VCRequest.SessionData);
        ensxtx_CTRL_SalesDocCreateUpdate.closeSession(null);
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
        return appSettings;
    }
}