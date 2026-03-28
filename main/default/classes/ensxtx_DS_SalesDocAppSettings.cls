public class ensxtx_DS_SalesDocAppSettings
{
    @AuraEnabled public Integer itemNumberIncrement { get; set; }
    @AuraEnabled public Integer bomItemNumberIncrement { get; set; }
    @AuraEnabled public Integer sortOrderIncrement { get; set; }
    @AuraEnabled public Map<String, Boolean> autoSimulate { get; set; }
    @AuraEnabled public Boolean showHeaderIncompletionLogs { get; set; }
    @AuraEnabled public Boolean showItemIncompletionLogs { get; set; }
    @AuraEnabled public Boolean incompletionLogsAsErrors { get; set; }
    @AuraEnabled public Boolean enableBoMItemEdit { get; set; }
    @AuraEnabled public Boolean enableConfiguration { get; set; }
    @AuraEnabled public Integer lineItemsBatchForAsync { get; set; }
    @AuraEnabled public Boolean enableBoMCountCommand { get; set; }
    @AuraEnabled public Boolean mapUpdateFromSObject { get; set; }
    @AuraEnabled public String SAPDocType { get; set; }
    @AuraEnabled public String SBODetailType { get; set; }
    @AuraEnabled public String DefaultDocType { get; set; }
    @AuraEnabled public String DefaultDocTypeInternal { get; set; }
    @AuraEnabled public String DefaultSalesOrganization { get; set; }
    @AuraEnabled public String DefaultDistributionChannel { get; set; }
    @AuraEnabled public String DefaultDivision { get; set; }
    @AuraEnabled public String sfInvokeFrom { get; set; }
    @AuraEnabled public List<DocumentType> DocTypes { get; set; }
    @AuraEnabled public Boolean salesAreasFromCustomer { get; set; }
    @AuraEnabled public List<Map<String, String>> SalesAreas { get; set; }
    @AuraEnabled public DocumentSetting Header { get; set; }
    @AuraEnabled public DocumentSetting Item { get; set; }
    @AuraEnabled public Boolean updateLineItems { get; set; }
    @AuraEnabled public Boolean deleteLineItems { get; set; }
    @AuraEnabled public Boolean useConvertToObjectTrigger { get; set; }
    @AuraEnabled public List<InvokeMethodAppSetting> InvokeMethodAppSettings { get; set; }
    @AuraEnabled public String InvokeMethod { get; set; }    
    @AuraEnabled public Boolean insertSalesDocLog { get; set; }    
    @AuraEnabled public Boolean skipAddedLineValidation { get; set; }
    @AuraEnabled public Boolean purgeSAPMaterialsBeforeUpdate { get; set; }
    @AuraEnabled public Boolean compareSAPSimulateVsSObject { get; set; }
    @AuraEnabled public Boolean mapChildBomFields { get; set; }

    public class DocumentType
    {
        @AuraEnabled public String id { get; set; }
        @AuraEnabled public String label { get; set; }
    }
    
    public class DocumentSetting
    {
        @AuraEnabled public List<PartnerSetting> PartnerPickers { get; set; }
        @AuraEnabled public List<TextSetting> Texts { get; set; }
    }

    public class PartnerSetting
    {
        @AuraEnabled public String PartnerFunction { get; set; }
        @AuraEnabled public String PartnerFunctionInternal { get; set; }
        @AuraEnabled public String PartnerFunctionName { get; set; }
        @AuraEnabled public String CustomLabel_PartnerFunctionName { get; set; }
        @AuraEnabled public String ComponentType { get; set; }
        @AuraEnabled public String SearchType { get; set; }
        @AuraEnabled public Boolean autoSearch { get; set; }
        @AuraEnabled public Boolean allowSearch { get; set; }
        @AuraEnabled public Boolean allowAddressOverride { get; set; }
        @AuraEnabled public Boolean autoPopulateAddressOverrideFromCustomer { get; set; }
    }

    public class TextSetting
    {
        @AuraEnabled public String Id { get; set; }
        @AuraEnabled public String Description { get; set; }
        @AuraEnabled public Boolean Required { get; set; }
    }

    public class InvokeMethodAppSetting
    {
        @AuraEnabled public String InvokeMethod { get; set; }    
        @AuraEnabled public Boolean insertSalesDocLog { get; set; }    
        @AuraEnabled public Boolean skipAddedLineValidation { get; set; }
    }
}