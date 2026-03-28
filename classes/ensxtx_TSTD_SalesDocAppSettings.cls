@isTest
public class ensxtx_TSTD_SalesDocAppSettings
{
    @isTest public static void test_appSettings()
    {
        ensxtx_DS_SalesDocAppSettings appSettings = buildAppSettings();
    }

    public static ensxtx_DS_SalesDocAppSettings buildAppSettings()
    {
        ensxtx_DS_SalesDocAppSettings appSettings = new ensxtx_DS_SalesDocAppSettings();
        appSettings.itemNumberIncrement = 10;
        appSettings.bomItemNumberIncrement = 10;
        appSettings.sortOrderIncrement = 10;
        appSettings.autoSimulate = new Map<String, Boolean>();
        appSettings.showHeaderIncompletionLogs = true;
        appSettings.showItemIncompletionLogs = true;
        appSettings.incompletionLogsAsErrors = true;
        appSettings.enableBoMItemEdit = false;
        appSettings.enableConfiguration = true;
        appSettings.lineItemsBatchForAsync = 10;
        appSettings.enableBoMCountCommand = false;
        appSettings.mapUpdateFromSObject = false;
        appSettings.SAPDocType = 'Quote';
        appSettings.SBODetailType = 'SalesDocument';
        appSettings.DefaultDocType = 'OR';
        appSettings.DefaultDocTypeInternal = 'TA';
        appSettings.DefaultSalesOrganization = '1000';
        appSettings.DefaultDistributionChannel = '00';
        appSettings.DefaultDivision = '00';
        appSettings.sfInvokeFrom = 'StandardUI';
        appSettings.purgeSAPMaterialsBeforeUpdate = true;
        appSettings.compareSAPSimulateVsSObject = true;
        appSettings.mapChildBomFields = true;
        ensxtx_DS_SalesDocAppSettings.DocumentType documentType = new ensxtx_DS_SalesDocAppSettings.DocumentType();
        documentType.id = 'OR';
        documentType.label = 'TEST';
        appSettings.DocTypes = new List<ensxtx_DS_SalesDocAppSettings.DocumentType>{documentType};
        appSettings.salesAreasFromCustomer = false;
        appSettings.SalesAreas = new List<Map<String, String>>();
        ensxtx_DS_SalesDocAppSettings.DocumentSetting documentSetting = new ensxtx_DS_SalesDocAppSettings.DocumentSetting();
        ensxtx_DS_SalesDocAppSettings.PartnerSetting partnerSetting = new ensxtx_DS_SalesDocAppSettings.PartnerSetting();
        partnerSetting.PartnerFunction = 'SH';
        partnerSetting.PartnerFunctionInternal = 'WE';
        partnerSetting.PartnerFunctionName = 'TEST';
        partnerSetting.CustomLabel_PartnerFunctionName = 'TEST';
        partnerSetting.ComponentType = 'Component';
        partnerSetting.SearchType = 'Partner';
        partnerSetting.autoSearch = true;
        partnerSetting.allowSearch = true;
        partnerSetting.allowAddressOverride = true;
        partnerSetting.autoPopulateAddressOverrideFromCustomer = true;
        ensxtx_DS_SalesDocAppSettings.PartnerSetting partnerSetting2 = new ensxtx_DS_SalesDocAppSettings.PartnerSetting();
        partnerSetting2.PartnerFunction = 'SP';
        partnerSetting2.PartnerFunctionInternal = 'WE';
        partnerSetting2.PartnerFunctionName = 'TEST';
        partnerSetting2.CustomLabel_PartnerFunctionName = 'TEST';
        partnerSetting2.ComponentType = 'Component';
        partnerSetting2.SearchType = 'Partner';
        partnerSetting2.autoSearch = true;
        documentSetting.PartnerPickers = new List<ensxtx_DS_SalesDocAppSettings.PartnerSetting>{partnerSetting, partnerSetting2};
        ensxtx_DS_SalesDocAppSettings.TextSetting textSetting = new ensxtx_DS_SalesDocAppSettings.TextSetting();
        textSetting.Id = '0001';
        textSetting.Description = 'TEST';
        textSetting.Required = true;
        documentSetting.Texts = new List<ensxtx_DS_SalesDocAppSettings.TextSetting>{textSetting};
        appSettings.Header = documentSetting;
        appSettings.Item = documentSetting;
        appSettings.updateLineItems = true;
        appSettings.deleteLineItems = true;
        ensxtx_DS_SalesDocAppSettings.InvokeMethodAppSetting invokeMethodAppSetting = new ensxtx_DS_SalesDocAppSettings.InvokeMethodAppSetting();
        invokeMethodAppSetting.InvokeMethod = 'Simulate';
        invokeMethodAppSetting.insertSalesDocLog = false;
        invokeMethodAppSetting.skipAddedLineValidation = false;
        appSettings.InvokeMethodAppSettings = new List<ensxtx_DS_SalesDocAppSettings.InvokeMethodAppSetting>{invokeMethodAppSetting};
        appSettings.InvokeMethod = 'Simulate';
        appSettings.insertSalesDocLog = true;
        appSettings.skipAddedLineValidation = false;
        appSettings.useConvertToObjectTrigger = false;
        return appSettings;
    }
}