@isTest
public class ensxtx_TSTU_SalesDocInvocableActions
{
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
            result.INCOMPLETION_LOG.add(new ensxtx_SBO_EnosixSalesDocument_Detail.INCOMPLETION_LOG());
            result.setSuccess(success);
            return result;
        }

        public ensxsdk.EnosixFramework.DetailObject executeCommand(String command, ensxsdk.EnosixFramework.DetailObject obj)
        {
            if (throwException) throw new CalloutException();

            ensxtx_SBO_EnosixSalesDocument_Detail.EnosixSalesDocument result = new ensxtx_SBO_EnosixSalesDocument_Detail.EnosixSalesDocument();
            ensxtx_SBO_EnosixSalesDocument_Detail.ITEMS item = new ensxtx_SBO_EnosixSalesDocument_Detail.ITEMS();
            item.ItemNumber = '10';
            item.Material = null;
            result.ITEMS.add(item);
            result.INCOMPLETION_LOG.add(new ensxtx_SBO_EnosixSalesDocument_Detail.INCOMPLETION_LOG());
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
    public static void test_invokeSalesDocLWC()
    {
        MOC_ensxtx_SBO_EnosixSalesDocument_Detail mocEnosixSalesDocumentDetail = new MOC_ensxtx_SBO_EnosixSalesDocument_Detail();
        ensxsdk.EnosixFramework.setMock(ensxtx_SBO_EnosixSalesDocument_Detail.class, mocEnosixSalesDocumentDetail);

        ensxtx_UTIL_SalesDocInvocableActions.Request req = createTestObjects(null);

        ensxtx_UTIL_SalesDocInvocableActions.invokeSalesDocLWC(JSON.serialize(req));
    }

    @isTest
    public static void test_invokeSalesDoc()
    {
        MOC_ensxtx_SBO_EnosixSalesDocument_Detail mocEnosixSalesDocumentDetail = new MOC_ensxtx_SBO_EnosixSalesDocument_Detail();
        ensxsdk.EnosixFramework.setMock(ensxtx_SBO_EnosixSalesDocument_Detail.class, mocEnosixSalesDocumentDetail);

        ensxtx_UTIL_SalesDocInvocableActions.Request req = createTestObjects(null);

        ensxtx_UTIL_SalesDocInvocableActions.invokeSalesDoc(req);

        appSettings.showHeaderIncompletionLogs = true;
        appSettings.incompletionLogsAsErrors = true;
        updateAppSettings(req);
        try
        {
            ensxtx_UTIL_SalesDocInvocableForeground.salesDocInvocable(new List<ensxtx_UTIL_SalesDocInvocableActions.Request>{req,req});
        }
        catch (Exception ex) {}
        ensxtx_UTIL_SalesDocInvocableForeground.salesDocInvocable(new List<ensxtx_UTIL_SalesDocInvocableActions.Request>{req});
        ensxtx_UTIL_SalesDocInvocableBackground.salesDocInvocable(new List<ensxtx_UTIL_SalesDocInvocableActions.Request>{req});
    }

    @isTest
    public static void test_invokeSalesDoc2()
    {
        MOC_ensxtx_SBO_EnosixSalesDocument_Detail mocEnosixSalesDocumentDetail = new MOC_ensxtx_SBO_EnosixSalesDocument_Detail();
        ensxsdk.EnosixFramework.setMock(ensxtx_SBO_EnosixSalesDocument_Detail.class, mocEnosixSalesDocumentDetail);

        ensxtx_UTIL_SalesDocInvocableActions.Request req = createTestObjects('1234');
        req.appSettingsName = 'OrderB2BApp';
        req.appSettingsInvokeMethod = 'Update';
        appSettings.InvokeMethod = 'Update';
        updateAppSettings(req);

        ensxtx_UTIL_SalesDocInvocableActions.invokeSalesDoc(req);

        ensxtx_DS_Document_Detail salesDocDetail = new ensxtx_DS_Document_Detail();
        salesDocDetail.isIncomplete = true;
        //Opportunity opp = new Opportunity();
        //opp.Id = req.recordId;
        //opp.ensxtx_SAP_SaveSalesDocHeader__c = JSON.serialize(salesDocDetail.cloneHeader());
        //ensxtx_TSTU_SFTestObject.upsertWithRetry(opp);
        //ensxtx_UTIL_SalesDocInvocableActions.invokeSalesDoc(req);

        //req.appSettingsName = 'Missing';
        //ensxtx_UTIL_SalesDocInvocableActions.invokeSalesDoc(req);
    }

    @isTest
    public static void test_invokeSalesDoc3()
    {
        MOC_ensxtx_SBO_EnosixSalesDocument_Detail mocEnosixSalesDocumentDetail = new MOC_ensxtx_SBO_EnosixSalesDocument_Detail();
        ensxsdk.EnosixFramework.setMock(ensxtx_SBO_EnosixSalesDocument_Detail.class, mocEnosixSalesDocumentDetail);

        ensxtx_UTIL_SalesDocInvocableActions.Request req = createTestObjects('1234');
        req.appSettingsInvokeMethod = 'Simulate';

        ensxtx_DS_SalesDocAppSettings.InvokeMethodAppSetting invokeMethod = new ensxtx_DS_SalesDocAppSettings.InvokeMethodAppSetting();
        invokeMethod.InvokeMethod = 'Simulate';
        appSettings.InvokeMethodAppSettings = new List<ensxtx_DS_SalesDocAppSettings.InvokeMethodAppSetting>{invokeMethod};

        updateAppSettings(req);

        try
        {
            ensxtx_UTIL_SalesDocInvocableActions.invokeSalesDoc(req);
        }
        catch (Exception ex) {}

        invokeMethod.insertSalesDocLog = true;
        appSettings.InvokeMethodAppSettings = new List<ensxtx_DS_SalesDocAppSettings.InvokeMethodAppSetting>{invokeMethod};

        updateAppSettings(req);
        ensxtx_UTIL_SalesDocInvocableActions.invokeSalesDoc(req);

        invokeMethod.insertSalesDocLog = false;
        appSettings.InvokeMethodAppSettings = new List<ensxtx_DS_SalesDocAppSettings.InvokeMethodAppSetting>{invokeMethod};
        updateAppSettings(req);
        ensxtx_UTIL_SalesDocInvocableActions.invokeSalesDoc(req);

        req.appSettingsInvokeMethod = 'Create';
        invokeMethod.InvokeMethod = 'Create';
        appSettings.InvokeMethodAppSettings = new List<ensxtx_DS_SalesDocAppSettings.InvokeMethodAppSetting>{invokeMethod};
        updateAppSettings(req);

        try
        {
            ensxtx_UTIL_SalesDocInvocableActions.invokeSalesDoc(req);
        }
        catch (Exception ex) {}
    }

    @isTest
    public static void test_invokeSalesDoc4()
    {
        MOC_ensxtx_SBO_EnosixSalesDocument_Detail mocEnosixSalesDocumentDetail = new MOC_ensxtx_SBO_EnosixSalesDocument_Detail();
        ensxsdk.EnosixFramework.setMock(ensxtx_SBO_EnosixSalesDocument_Detail.class, mocEnosixSalesDocumentDetail);

        ensxtx_UTIL_SalesDocInvocableActions.Request req = createTestObjects('1234');
        req.appSettingsInvokeMethod = 'Product';

        updateAppSettings(req);

        Product2 pObj = ensxtx_TSTU_SFTestObject.createTestProduct2();
        pObj.put(ensxtx_UTIL_SFProduct.MaterialFieldName, 'SAPMat1');
        ensxtx_TSTU_SFTestObject.upsertWithRetry(pObj);
        List<Id> prodIdList = new List<Id>{pObj.Id};

        req.recordId = acct.Id;
        ensxtx_UTIL_SFProduct.ProductInfo prodInfo = new ensxtx_UTIL_SFProduct.ProductInfo();
        prodInfo.prodId = pObj.Id;
        List<String> prodInfoList = new List<String>{JSON.serialize(prodInfo)};
        req.productJSONList = prodInfoList;
        req.productSimulationFieldsMapJSON = null;
        ensxtx_UTIL_SalesDocInvocableActions.invokeSalesDoc(req);
    }

    private static void updateAppSettings(ensxtx_UTIL_SalesDocInvocableActions.Request req)
    {
        Map<String, Object> appSettingsMap = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(appSettings));
        Map<String, ensxtx_DS_SalesDocAppSettings> typeNameMap = new Map<String, ensxtx_DS_SalesDocAppSettings>();
        typeNameMap.put(req.appSettingsTypeName, appSettings);
        Map<String, Object> settingsMap = new Map<String, Object>();
        settingsMap.put(req.appSettingsKey, typeNameMap);
        String setKey = 'ensxtx_SR_enosix' + req.appSettingsName + 'Settings';
        ensxtx_UTIL_AppSettings.settingsMap.put(setKey, settingsMap);
    }

    private static ensxtx_DS_SalesDocAppSettings appSettings;
    private static Account acct;

    public static ensxtx_UTIL_SalesDocInvocableActions.Request createTestObjects(String docNumber)
    {
        acct = ensxtx_TSTU_SFTestObject.createTestAccount();
        acct.put(ensxtx_UTIL_SFAccount.CustomerFieldName, '1111');
        ensxtx_TSTU_SFTestObject.upsertWithRetry(acct);

        Id pricebookId = ensxtx_UTIL_Pricebook.getStandardPriceBookId();
        Opportunity opp = ensxtx_TSTU_SFTestObject.createTestOpportunity();
        opp.AccountId = acct.Id;
        opp.Pricebook2Id = pricebookId;
        //if (String.isNotEmpty(docNumber)) opp.put(ensxtx_UTIL_SFOpportunity.OrderFieldName, '1234');
        ensxtx_TSTU_SFTestObject.upsertWithRetry(opp);
        opp = [SELECT Id, Pricebook2Id FROM Opportunity WHERE Id =: opp.Id];
        String recordId = opp.Id;
        
        if (String.isNotEmpty(docNumber)) {
            Order order = new Order();
        	order.AccountId = acct.Id;
        	order.Status = 'Draft';
        	order.EffectiveDate = Date.today();
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
            if (String.isNotEmpty(docNumber)) order.ensxtx_SAP_Order_Number__c = '1234';
            ensxtx_TSTU_SFTestObject.upsertWithRetry(order);
            order = [SELECT Id, Pricebook2Id FROM Order WHERE Id = :order.Id];
            order.Pricebook2Id = pricebookId;
            ensxtx_TSTU_SFTestObject.upsertWithRetry(order);
            recordId = order.Id;
        }

        ensxtx_UTIL_SalesDocInvocableActions.Request req = new ensxtx_UTIL_SalesDocInvocableActions.Request();
        req.recordId = recordId;
        req.appSettingsName = 'OrderApp';
        req.appSettingsKey = 'SalesDoc';
        req.appSettingsTypeName = 'DefaultOrder';
        req.appSettingsInvokeMethod = 'Create';

        appSettings = new ensxtx_DS_SalesDocAppSettings();
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
        updateAppSettings(req);
        return req;
    }

    @isTest
    public static void test_getMethodAppSettings()
    {
        ensxtx_DS_SalesDocAppSettings appSettings = ensxtx_TSTU_SalesDocCreateUpdate.createTestAppSettings();
        ensxtx_UTIL_SalesDocInvocableActions.Request request = new ensxtx_UTIL_SalesDocInvocableActions.Request();

        ensxtx_UTIL_SalesDocInvocableActions.getMethodAppSettings(request, 'Create', appSettings);
    }
}