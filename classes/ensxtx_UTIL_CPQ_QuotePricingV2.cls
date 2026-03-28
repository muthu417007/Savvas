public with sharing class ensxtx_UTIL_CPQ_QuotePricingV2
{
    private static final ensxsdk.Logger logger = new ensxsdk.Logger(ensxtx_UTIL_CPQ_QuotePricingV2.class);

    public static String defaultSalesDocType = (String)ensxtx_UTIL_AppSettings.getValue(ensxtx_UTIL_AppSettings.CPQV2, 'DefaultSalesDocType', '');    
    public static String defaultSalesOrg = (String)ensxtx_UTIL_AppSettings.getValue(ensxtx_UTIL_AppSettings.CPQV2, 'DefaultSalesOrg', '');    
    public static String defaultDistributionChannel = (String)ensxtx_UTIL_AppSettings.getValue(ensxtx_UTIL_AppSettings.CPQV2, 'DefaultDistributionChannel', '');    
    public static String defaultDivision =  (String)ensxtx_UTIL_AppSettings.getValue(ensxtx_UTIL_AppSettings.CPQV2, 'DefaultDivision', '');    
    public static String defaultCustomerNumber = (String)ensxtx_UTIL_AppSettings.getValue(ensxtx_UTIL_AppSettings.CPQV2, 'DefaultCustomerNumber', '');    
    public static Integer QuoteLineIncrement = (Integer)ensxtx_UTIL_AppSettings.getValue(ensxtx_UTIL_AppSettings.CPQV2, 'DefaultQuoteLineIncrement', 10);

    public static SAPSimulationResults prepareQuoteAndSimulate(
        SBQQ__Quote__c cpqQuote, 
        List<SBQQ__QuoteLine__c> cpqQuoteLineList
    ) {
        Map<Id, Product2> productMap = new Map<Id, Product2>();
        Map<String, Object> debugMap = new Map<String, Object>();
        SAPSimulationResults simresults = new SAPSimulationResults();
        try {
            Boolean isQuoteUpdated = false;
            ensxtx_DS_Document_Detail salesDocDetail = loadDocumentDetail(cpqQuote, cpqQuoteLineList, productMap, false);
            if (salesDocDetail.ITEMS.size() > 0) {
                ensxtx_UTIL_VCPricingV2.simulatePricing(salesDocDetail);
                updateCPQQuote(cpqQuote, cpqQuoteLineList, salesDocDetail, productMap, debugMap, isQuoteUpdated);
                Integer qlTot = cpqQuoteLineList.size();
                for (Integer qlCnt = qlTot - 1 ; qlCnt >= 0 ; qlCnt--)
                {
                    SBQQ__QuoteLine__c cpqQuoteLine = cpqQuoteLineList[qlCnt];
                    if (cpqQuoteLine.SBQQ__Number__c < 0) cpqQuoteLineList.remove(qlCnt);
                }
                System.debug('simulation Success ' );
            } else cpqQuoteLineList.clear();
            simresults.Success = true;
            simresults.Message = 'Simulated Pricing in SAP for ' + cpqQuoteLineList.size() + ' items';
            simresults.cpqQuote = cpqQuote;
            simresults.cpqQuoteLineList = cpqQuoteLineList;
            simresults.debugMap = debugMap;
        }
        catch (ensxtx_ENSX_Exceptions.SimulationException simEx) {
            System.debug('simulation failure ' );
            simresults.Success = false;
            simresults.Message = processMessage(cpqQuoteLineList, simEx.getMessage(), productMap);
            simresults.cpqQuote = cpqQuote;
            simresults.cpqQuoteLineList = cpqQuoteLineList;
            simresults.debugMap = debugMap;
        } finally {
            logger.exit();
        }
        return simresults;
    }

    public class SAPSimulationResults
    {
        @AuraEnabled
        public Boolean Success { get; set; }

        @AuraEnabled
        public String Message { get; set; }

        @AuraEnabled
        public SBQQ__Quote__c cpqQuote {get;set;}

        @AuraEnabled
        public List<SBQQ__QuoteLine__c> cpqQuoteLineList {get;set;}

        @AuraEnabled
        public Map<String, Object> debugMap {get;set;}
    }

    @testVisible
    private static String processMessage(
        List<SBQQ__QuoteLine__c> cpqQuoteLineList, 
        String simMessage,
        Map<Id, Product2> productMap
    ) {
        String returnMessage = '';
        List<String> messageList = simMessage.split('; ');
        Integer mTot = messageList.size();
        Integer qlTot = cpqQuoteLineList.size();
        for (Integer mCnt = 0 ; mCnt < mTot ; mCnt++)
        {
            String message = messageList[mCnt];
            returnMessage += returnMessage == '' ? message : '; ' + message;
            List<String> messageParts = message.split(', ');
            if (messageParts.size() >= 3 && 
                messageParts[0].startsWith('Internal error:') &&
                Integer.valueOf(messageParts[1]) > 0)
            {
                Integer itemNumber = Integer.valueOf(messageParts[1]);
                for (Integer qlCnt = 0 ; qlCnt < qlTot ; qlCnt++)
                {
                    SBQQ__QuoteLine__c cpqQuoteLine = cpqQuoteLineList[qlCnt];
                    if (cpqQuoteLine.ensxtx_SAP_Item_Number__c != null && Integer.valueOf(cpqQuoteLine.ensxtx_SAP_Item_Number__c) == itemNumber)
                    {
                        Product2 prod = productMap.get(cpqQuoteLine.SBQQ__Product__c);
                        String SAPMaterialNumber = prod == null ? '' : (String) prod.get(ensxtx_UTIL_SFProduct.MaterialFieldName);
                        String linkMessage = '';
                        if (String.isNotEmpty(String.valueOf(cpqQuoteLine.SBQQ__Number__c))) linkMessage += 'Item Number ' + String.valueOf(cpqQuoteLine.SBQQ__Number__c) + ' ';
                        linkMessage += 'SAP Material ' + SAPMaterialNumber;
                        if (messageParts[2].right(1) == ',') messageParts[2] = messageParts[2].left(messageParts[2].length()-1);
                        linkMessage += ' for SAP Item Number ' + messageParts[1] + ' error ' + messageParts[2];
                        returnMessage += '; ' + linkMessage;
                    }
                }
            }
        }
        return returnMessage;
    }

    public static ensxtx_DS_Document_Detail loadDocumentDetail(
        SBQQ__Quote__c cpqQuote, 
        List<SBQQ__QuoteLine__c> cpqQuoteLineList,
        Map<Id, Product2> productMap,
        Boolean isExternalConfigurator
    ) {
        Set<Id> productIds = new Set<Id>();
        Integer qlTot = cpqQuoteLineList.size();
        for (Integer qlCnt = 0 ; qlCnt < qlTot ; qlCnt++) {
            productIds.add(cpqQuoteLineList[qlCnt].SBQQ__Product__c);
        }

        List<String> fields = new List<String>();
        String configurableMaterialField = ensxtx_UTIL_SFProduct.getConfigurableMaterialField();
        if (String.isNotEmpty(configurableMaterialField)) fields.add(configurableMaterialField);
        String bomMaterialField = ensxtx_UTIL_SFProduct.getBOMMaterialField();
        if (String.isNotEmpty(bomMaterialField)) fields.add(bomMaterialField);
        productMap.putAll(ensxtx_UTIL_SFProduct.getProductsByField('Id', new List<Id>(productIds), fields));

        Integer itemIncrement = QuoteLineIncrement;
        Integer parentItemNumber = 0;
        Integer childItemNumber = 0;

        Set<Id> productFeaturesProdIdSet = new Set<Id>();
        for (Integer qlCnt = 0 ; qlCnt < qlTot ; qlCnt++) {
            SBQQ__QuoteLine__c cpqQuoteLine = cpqQuoteLineList[qlCnt];
            productFeaturesProdIdSet.add(cpqQuoteLine.SBQQ__Product__c);
        }
        Map<Id, SObject> productFeaturesMap = new Map<Id, SObject>(Database.query('SELECT Id, Name, SBQQ__ConfiguredSKU__c FROM SBQQ__ProductFeature__c WHERE SBQQ__ConfiguredSKU__c IN :productFeaturesProdIdSet AND Name = \'SAP BoM\''));

        List<Id> sapQLIds = new List<Id>();
        Map<Id, SBQQ__QuoteLine__c> sapSFChildIdMap = new Map<Id, SBQQ__QuoteLine__c>();
        for (Integer qlCnt = 0 ; qlCnt < qlTot ; qlCnt++) {
            SBQQ__QuoteLine__c cpqQuoteLine = cpqQuoteLineList[qlCnt];
            Product2 prod = productMap.get(cpqQuoteLine.SBQQ__Product__c);
            if (ensxtx_UTIL_SFProduct.isProductLinkedToMaterial(prod)) {
                String SAPMaterialNumber = (String) prod.get(ensxtx_UTIL_SFProduct.MaterialFieldName);
                Boolean isChild = cpqQuoteLine.SBQQ__DynamicOptionId__c != null && 
                    cpqQuoteLine.SBQQ__DynamicOptionId__c.contains(':') &&
                    productFeaturesMap.containsKey(cpqQuoteLine.SBQQ__DynamicOptionId__c.split(':')[0]);
                if (isChild) {
                    childItemNumber++;
                    loadQuoteLineFields(cpqQuoteLine, parentItemNumber, childItemNumber);
                } else if (cpqQuoteLine.SBQQ__RequiredBy__c == null || !sapQLIds.contains(cpqQuoteLine.SBQQ__RequiredBy__c)) {
                    Integer sfChdTot = sapSFChildIdMap.size();
                    if (sfChdTot > 0) {
                        List<Id> sfChdIdList = new List<Id>(sapSFChildIdMap.keySet());
                        for (Integer sfChdCnt = 0 ; sfChdCnt < sfChdTot ; sfchdCnt++) {
                            parentItemNumber += itemIncrement;
                            loadQuoteLineFields(sapSFChildIdMap.get(sfChdIdList[sfChdCnt]), parentItemNumber, 0);
                        }
                        sapSFChildIdMap.clear();
                    }
                    parentItemNumber += itemIncrement;
                    childItemNumber = 0;
                    loadQuoteLineFields(cpqQuoteLine, parentItemNumber, childItemNumber);
                } else {
                    sapSFChildIdMap.put(cpqQuoteLine.Id, cpqQuoteLine);
                }
                sapQLIds.add(cpqQuoteLine.Id);
            }
        }
        Integer sfChdTot = sapSFChildIdMap.size();
        if (sfChdTot > 0) {
            List<Id> sfChdIdList = new List<Id>(sapSFChildIdMap.keySet());
            for (Integer sfChdCnt = 0 ; sfChdCnt < sfChdTot ; sfchdCnt++) {
                parentItemNumber += itemIncrement;
                loadQuoteLineFields(sapSFChildIdMap.get(sfChdIdList[sfChdCnt]), parentItemNumber, 0);
            }
            sapSFChildIdMap.clear();
        }

        return getSBOForCPQQuote(cpqQuote, cpqQuoteLineList, productMap, productFeaturesMap, isExternalConfigurator);
    }

    private static void loadQuoteLineFields(SBQQ__QuoteLine__c cpqQuoteLine, Integer parentItemNumber, Integer childItemNumber)
    {
        cpqQuoteLine.ensxtx_SAP_Item_Number__c = String.valueOf(parentItemNumber + childItemNumber);
        if (String.isNotEmpty(cpqQuoteLine.ensxtx_SAP_Configuration__c)) {
            ensxtx_DS_Document_Detail.CPQ_VC_ITEM_CONFIGURATION itemConfig = (ensxtx_DS_Document_Detail.CPQ_VC_ITEM_CONFIGURATION) JSON.deserialize(cpqQuoteLine.ensxtx_SAP_Configuration__c,ensxtx_DS_Document_Detail.CPQ_VC_ITEM_CONFIGURATION.class);
            if (itemConfig.vcSummary != null) cpqQuoteLine.ensxtx_SAP_VC_Summary__c = buildCharacteristicsTable(itemConfig.vcSummary);
        }
    }

    // Build a table to store the selected characteristics
    @testVisible
    private static String buildCharacteristicsTable(Map<String, List<String>> vcSummary)
    {
        String table = '<div style="border: solid black 1px;"><table style="width:100%">';
        table += '<thead>';
        table += '<tr>';
        table += '<th style="border: solid black 1px;">Characteristic&nbsp;&nbsp;</th>';
        table += '<th style="border: solid black 1px;">Value&nbsp;&nbsp;</th>';
        table += '</tr>';
        table += '</thead>';
        table += '<tbody>';

        for (String characteristic : vcSummary.keySet()) {
            List<String> values = vcSummary.get(characteristic);
            table += '<tr>';
            table += '<td style="border: solid black 1px;">' + characteristic + '&nbsp;&nbsp;</td>';
            table += '<td style="border: solid black 1px;">';

            // If it's more than one value show as unordered list
            if (values.size() > 1) {
                table += '<ul>';
                for (String value : values) {
                    table += '<li>' + value + '&nbsp;&nbsp;</li>';
                }
                table += '</ul></td>';
            }
            else {
                table += values.size() == 1 ? values[0] : '' + '&nbsp;&nbsp;</td>';
            }
            table += '</tr>';
        }
        table += '</tbody>';
        table += '</table></div>';
        table += '<p>&nbsp;</p>';

        return table;
    }

    // getSBOForCPQQuote
    //
    // Performs the SAP pricing simulation
    @Testvisible
    private static ensxtx_DS_Document_Detail getSBOForCPQQuote(
        SBQQ__Quote__c cpqQuote, 
        List<SBQQ__QuoteLine__c> cpqQuoteLineList,
        Map<Id, Product2> productMap,
        Map<Id, SObject> productFeaturesMap,
        Boolean isExternalConfigurator
    ) {
        logger.enterAura('getSBOForCPQQuote', new Map<String, Object> {
            'cpqQuote' => cpqQuote,
            'cpqQuoteLineList' => cpqQuoteLineList,
            'productMap' => productMap
        });

        ensxtx_DS_Document_Detail salesDocDetail = new ensxtx_DS_Document_Detail();
        salesDocDetail = applyQuoteRequestMappingRules(cpqQuote, salesDocDetail);
        if (String.isEmpty(salesDocDetail.SALES.SalesDocumentType)) salesDocDetail.SALES.SalesDocumentType = defaultSalesDocType;
        if (String.isEmpty(salesDocDetail.SALES.SalesOrganization)) salesDocDetail.SALES.SalesOrganization = defaultSalesOrg;
        if (String.isEmpty(salesDocDetail.SALES.DistributionChannel)) salesDocDetail.SALES.DistributionChannel = defaultDistributionChannel;
        if (String.isEmpty(salesDocDetail.SALES.Division)) salesDocDetail.SALES.Division = defaultDivision;
        if (String.isEmpty(salesDocDetail.SoldToParty)) salesDocDetail.SoldToParty = defaultCustomerNumber;

        if (String.isBlank(salesDocDetail.SoldToParty))
        {
            throw new ensxtx_ENSX_Exceptions.SimulationException(System.Label.ensxtx_Account_Sold_To_Blank);
        }

        String configurableMaterialField = ensxtx_UTIL_SFProduct.getConfigurableMaterialField();
        String bomMaterialField = ensxtx_UTIL_SFProduct.getBOMMaterialField();
        Boolean isSimulateNeeded = false;
        Integer qlTot = cpqQuoteLineList.size();
        for (Integer qlCnt = 0 ; qlCnt < qlTot ; qlCnt++)
        {
            SBQQ__QuoteLine__c cpqQuoteLine = cpqQuoteLineList[qlCnt];
            Product2 lineProduct = productMap.get(cpqQuoteLine.SBQQ__Product__c);
            ensxtx_DS_Document_Detail.CPQ_VC_ITEM_CONFIGURATION itemConfig = null;
            if (String.isNotEmpty(cpqQuoteLine.ensxtx_SAP_Configuration__c)) {
                itemConfig = (ensxtx_DS_Document_Detail.CPQ_VC_ITEM_CONFIGURATION) JSON.deserialize(cpqQuoteLine.ensxtx_SAP_Configuration__c,ensxtx_DS_Document_Detail.CPQ_VC_ITEM_CONFIGURATION.class);
            }
            Boolean isChild = cpqQuoteLine.SBQQ__DynamicOptionId__c != null && 
                cpqQuoteLine.SBQQ__DynamicOptionId__c.contains(':') &&
                productFeaturesMap.containsKey(cpqQuoteLine.SBQQ__DynamicOptionId__c.split(':')[0]);
            if (!isChild) 
            {
                Boolean skipLine = cpqQuote.ensxtx_SAP_Consistency_Check__c && String.isNotEmpty(configurableMaterialField) && !((Boolean) lineProduct.get(configurableMaterialField));
                if (ensxtx_UTIL_SFProduct.isProductLinkedToMaterial(lineProduct) && !skipLine) {
                    if (!cpqQuoteLine.ensxtx_SAP_Simulated__c) isSimulateNeeded = true;
                    ensxtx_DS_Document_Detail.ITEMS item = new ensxtx_DS_Document_Detail.ITEMS();
                    item.SFId = cpqQuoteLine.Id;
                    item.ItemNumber = cpqQuoteLine.ensxtx_SAP_Item_Number__c;
                    item.HigherLevelItemNumber = '0';
                    item.CPQNumber = cpqQuoteLine.SBQQ__Number__c;
                    item.ProductId = cpqQuoteLine.SBQQ__Product__c;
                    item.Material = ensxtx_UTIL_SFProduct.getMaterialNumberFromProduct(lineProduct);
                    item.ItemConfigurations = new List<ensxtx_DS_Document_Detail.CONFIG>();
                    if (cpqQuote.ensxtx_SAP_Consistency_Check__c) item.isConfigurationFromVCComplete = true;
                    if (String.isNotEmpty(configurableMaterialField)) item.ConfigurableMaterial = (Boolean) lineProduct.get(configurableMaterialField);
                    if (String.isNotEmpty(bomMaterialField)) item.BOMMaterial = (Boolean) lineProduct.get(bomMaterialField);
                    item.isConfigurationFromVCComplete = itemConfig != null && itemConfig.isIncomplete != null ? !itemConfig.isIncomplete : itemConfig == null && item.ConfigurableMaterial != null && item.ConfigurableMaterial ? false : true;
                    item = applyQuoteLineRequestMappingRules(cpqQuoteLine, item);

                    // Variant Configuration
                    if (itemConfig != null) {
                        item.OptionConfigurationKeys = itemConfig.OptionConfigurationKeys;
                        if (itemConfig.selectedCharacteristics != null && !itemConfig.selectedCharacteristics.isEmpty())
                        {
                            Integer scTot = itemConfig.selectedCharacteristics.size();
                            for (Integer scCnt = 0 ; scCnt < scTot ; scCnt++)
                            {
                                ensxtx_DS_Document_Detail.CONFIG config = itemConfig.selectedCharacteristics[scCnt];
                                if (config.UserModified != null && config.UserModified && String.isNotEmpty(config.CharacteristicID))
                                {
                                    item.ItemConfigurations.add(config);
                                }
                            }
                        }
                    }

                    salesDocDetail.Items.add(item);
                }
                else if (!skipLine) {
                    cpqQuoteLine.put('ensxtx_SAP_Simulation_Error__c', System.Label.ensxtx_MaterialNumber_NotFound);
                }
            }
        }
        if (!isSimulateNeeded && !isExternalConfigurator) salesDocDetail.Items.clear();

        return salesDocDetail;
    }

    @Testvisible
    private static CPQPricingConfig cpqPricingConfig = null;

    @Testvisible
    private static ensxtx_DS_Document_Detail applyQuoteRequestMappingRules(
        SBQQ__Quote__c cpqQuote,
        ensxtx_DS_Document_Detail salesDocDetail
    ) {
        if (null == cpqQuote) {
            return salesDocDetail;
        }
        if (cpqPricingConfig == null) {
            cpqPricingConfig = (CPQPricingConfig)ensxtx_UTIL_AppSettings.getSObject(ensxtx_UTIL_AppSettings.CPQV2, 'Pricing', CPQPricingConfig.class, null);
        }
        if (null == cpqPricingConfig || null == cpqPricingConfig.Request || null == cpqPricingConfig.Request.Quote || 
            null == cpqPricingConfig.Request.Quote.RecordMapping || cpqPricingConfig.Request.Quote.RecordMapping.isEmpty()) {
            return salesDocDetail;
        }
        List<ensxtx_DS_Document_Detail.CONDITIONS> headerConditions = new List<ensxtx_DS_Document_Detail.CONDITIONS>();
        List<ensxtx_DS_Document_Detail.PARTNERS> salesDocDetailPartners = new List<ensxtx_DS_Document_Detail.PARTNERS>();
        salesDocDetailPartners.addAll(salesDocDetail.PARTNERS);
        Map<String, Object> salesDocDetailMap = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(salesDocDetail));
        Map<String, Object> salesDocDetailSalesMap = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(salesDocDetail.SALES));
        List<CPQPricingConfigMappingRule> recordMappingRules = cpqPricingConfig.Request.Quote.RecordMapping;
        Integer ruleTot = recordMappingRules.size();
        for (Integer ruleCnt = 0 ; ruleCnt < ruleTot ; ruleCnt++) {
            CPQPricingConfigMappingRule rule = recordMappingRules[ruleCnt];
            Object value = String.isNotEmpty(rule.sObjectField) ? cpqQuote.get(rule.sObjectField) : null;
            Object defaultValue = String.isNotEmpty(rule.defaultValue) ? rule.defaultValue : null;
            if (value == null && defaultValue == null) continue;
            switch on rule.collection {
                when 'header' {
                    salesDocDetailMap.put(rule.field, value != null ? value : defaultValue);
                }
                when 'sales' {
                    salesDocDetailSalesMap.put(rule.field, value != null ? value : defaultValue);
                }
                when 'partners' {
                    getPartner(salesDocDetailPartners, rule.partnerFunction, rule.partnerFunctionInternal, String.valueOf(value != null ? value : defaultValue));
                }
                when 'conditions' {
                    ensxtx_DS_Document_Detail.CONDITIONS condition = new ensxtx_DS_Document_Detail.CONDITIONS();
                    condition.ConditionType = rule.field;
                    condition.ConditionControl = 'C'; // Manually Entered
                    Decimal decimalValue = Decimal.valueOf(String.valueOf(value != null ? value : defaultValue));
                    switch on rule.transform {
                        when 'conditionRateAsPercent' {
                            condition.Rate = decimalValue;
                        }
                        when 'conditionRateDiscountAsPercent' {
                            condition.Rate = -decimalValue;
                        }
                        when 'conditionRate' {
                            condition.Rate = decimalValue;
                        }
                        when 'conditionRateDiscount' {
                            condition.Rate = -decimalValue;
                        }
                        when else {
                            System.debug('applyQuoteRequestMappingRules: unrecognized transform: ' + rule);
                        }
                    }
                    headerConditions.add(condition);
                }
                when else {
                    System.debug('applyQuoteRequestMappingRules: unrecognized collection: ' + rule);
                }
            }
        }
        salesDocDetail = (ensxtx_DS_Document_Detail) JSON.deserialize(JSON.serialize(salesDocDetailMap), ensxtx_DS_Document_Detail.class);
        salesDocDetail.SALES = (ensxtx_DS_Document_Detail.SALES) JSON.deserialize(JSON.serialize(salesDocDetailSalesMap), ensxtx_DS_Document_Detail.SALES.class);
        salesDocDetail.PARTNERS.clear();
        salesDocDetail.PARTNERS.addAll(salesDocDetailPartners);
        salesDocDetail.CONDITIONS.addAll(headerConditions);
        return salesDocDetail;
    }
    
    @Testvisible
    private static void getPartner(
        List<ensxtx_DS_Document_Detail.PARTNERS> partnerList, 
        string partnerFunction, 
        String partnerFunctionInternal,
        string customerNumber
    ) {
        if (partnerList != null && String.isNotEmpty(customerNumber))
        {
            ensxtx_DS_Document_Detail.PARTNERS result = null;
            Integer partnerTot = partnerList.size();
            for (Integer partnerCnt = 0 ; partnerCnt < partnerTot ; partnerCnt++)
            {
                ensxtx_DS_Document_Detail.PARTNERS partner = partnerList[partnerCnt];
                if (partnerFunction == partner.PartnerFunction)
                {
                    result = partner;
                    break;
                }
            }

            if (null == result)
            {
                result = new ensxtx_DS_Document_Detail.PARTNERS();
                result.PartnerFunction = partnerFunction;
                result.PartnerFunctionInternal = partnerFunctionInternal;
                partnerList.add(result);
            }
            result.CustomerNumber = customerNumber;
        }
    }

    @Testvisible
    private static ensxtx_DS_Document_Detail.ITEMS applyQuoteLineRequestMappingRules(
        SBQQ__QuoteLine__c cpqQuoteLine,
        ensxtx_DS_Document_Detail.ITEMS item
    ) {
        if (null == cpqQuoteLine) {
            return item;
        }
        if (cpqPricingConfig == null) {
            cpqPricingConfig = (CPQPricingConfig)ensxtx_UTIL_AppSettings.getSObject(ensxtx_UTIL_AppSettings.CPQV2, 'Pricing',CPQPricingConfig.class, null);
        }
        if (null == cpqPricingConfig || null == cpqPricingConfig.Request || null == cpqPricingConfig.Request.QuoteLine || 
            null == cpqPricingConfig.Request.QuoteLine.RecordMapping || cpqPricingConfig.Request.QuoteLine.RecordMapping.isEmpty()) {
            return item;
        }
        List<ensxtx_DS_Document_Detail.CONDITIONS> itemConditions = new List<ensxtx_DS_Document_Detail.CONDITIONS>();
        Map<String, Object> itemMap = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(item));
        List<CPQPricingConfigMappingRule> recordMappingRules = cpqPricingConfig.Request.QuoteLine.RecordMapping;
        Integer ruleTot = recordMappingRules.size();
        for (Integer ruleCnt = 0 ; ruleCnt < ruleTot ; ruleCnt++) {
            CPQPricingConfigMappingRule rule = recordMappingRules[ruleCnt];
            Object value = String.isNotEmpty(rule.sObjectField) ? cpqQuoteLine.get(rule.sObjectField) : null;
            Object defaultValue = String.isNotEmpty(rule.defaultValue) ? rule.defaultValue : null;
            if (value == null && defaultValue == null) continue;
            switch on rule.collection {
                when 'items' {
                    itemMap.put(rule.field, value != null ? value : defaultValue);
                }
                when 'conditions' {
                    ensxtx_DS_Document_Detail.CONDITIONS condition = new ensxtx_DS_Document_Detail.CONDITIONS();
                    condition.ConditionType = rule.field;
                    condition.ConditionControl = 'C'; // Manually Entered
                    Decimal decimalValue = Decimal.valueOf(String.valueOf(value != null ? value : defaultValue));
                    switch on rule.transform {
                        when 'conditionRateAsPercent' {
                            condition.Rate = decimalValue;
                        }
                        when 'conditionRateDiscountAsPercent' {
                            condition.Rate = -decimalValue;
                        }
                        when 'conditionRate' {
                            condition.Rate = decimalValue;
                        }
                        when 'conditionRateDiscount' {
                            condition.Rate = -decimalValue;
                        }
                        when else {
                            System.debug('applyQuoteLineRequestMappingRules: unrecognized transform: ' + rule);
                        }
                    }
                    itemConditions.add(condition);
                }
                when else {
                    System.debug('applyQuoteLineRequestMappingRules: unrecognized sboCollection: ' + rule);
                }
            }
        }
        item = (ensxtx_DS_Document_Detail.ITEMS) JSON.deserialize(JSON.serialize(itemMap), ensxtx_DS_Document_Detail.ITEMS.class);
        item.ItemConditions = new List<ensxtx_DS_Document_Detail.CONDITIONS>();
        item.ItemConditions.addAll(itemConditions);
        return item;
    }

    public static void updateCPQQuote(
        SBQQ__Quote__c cpqQuote, 
        List<SBQQ__QuoteLine__c> cpqQuoteLineList,
        ensxtx_DS_Document_Detail salesDocDetail,
        Map<Id, Product2> productMap,
        Map<String, Object> debugMap,
        Boolean isQuoteUpdated
    ) {
        Set<String> sapMatSet = new Set<String>();
        Integer itemTot = salesDocDetail.ITEMS.size();
        for (Integer itemCnt = 0 ; itemCnt < itemTot ; itemCnt++)
        {
            ensxtx_DS_Document_Detail.ITEMS item = salesDocDetail.ITEMS[itemCnt];
            if (String.isNotEmpty(item.Material)) sapMatSet.add(item.Material);
        }
        Id pricebookId = ensxtx_UTIL_SFSObjectDoc.getPriceBookId(cpqQuote);
        String currencyISOCode = ensxtx_UTIL_SObject.getCurrencyIsoCode('SBQQ__Quote__c', cpqQuote);
        Map<Id, PriceBookEntry> pricebookEntriesMap = ensxtx_UTIL_Pricebook.getEntriesForPricebookById(pricebookId, sapMatSet, currencyISOCode);
        ensxtx_UTIL_Pricebook.validateProductsInPricebook(null, pricebookId, sapMatSet, pricebookEntriesMap);
        updateCPQQuoteForSBOResults(cpqQuote, cpqQuoteLineList, salesDocDetail, productMap, debugMap, isQuoteUpdated, pricebookEntriesMap);
    }

    // updateCPQQuoteForSBOResults
    //
    // Maps results of the SAP pricing simulation back to the incoming quote
    @testVisible
    private static void updateCPQQuoteForSBOResults(
        SBQQ__Quote__c cpqQuote, 
        List<SBQQ__QuoteLine__c> cpqQuoteLineList, 
        ensxtx_DS_Document_Detail salesDocDetail, 
        Map<Id, Product2> productMap,
        Map<String, Object> debugMap,
        Boolean isQuoteUpdated,
        Map<Id, PriceBookEntry> pricebookEntriesMap
    ) {
        applyQuoteResponseMappingRules(cpqQuote, salesDocDetail, debugMap, isQuoteUpdated);

        Map<Integer,ensxtx_DS_Document_Detail.ITEMS> itemNumberItemMap1 = new Map<Integer,ensxtx_DS_Document_Detail.ITEMS>();
        List<Integer> itemNumberList1 = new List<Integer>();

        Integer itemTot = salesDocDetail.ITEMS.size();
        for (Integer itemCnt = 0 ; itemCnt < itemTot ; itemCnt++)
        {
            ensxtx_DS_Document_Detail.ITEMS item = salesDocDetail.ITEMS[itemCnt];
            if (item.isConfigurationFromVCComplete == null || item.isConfigurationFromVCComplete) {
                Integer itemNumber = Integer.valueOf(item.ItemNumber);
                itemNumberItemMap1.put(itemNumber, item);
                itemNumberList1.add(itemNumber);
            }
        }
        itemNumberList1.sort();

        Map<Integer,ensxtx_DS_Document_Detail.ITEMS> itemNumberItemMap2 = new Map<Integer,ensxtx_DS_Document_Detail.ITEMS>();
        List<Integer> itemNumberList2 = new List<Integer>();
        Integer childItemNumber = 0;
        Map<String, String> childItemHigherLevelItem = new Map<String, String>();
        itemTot = itemNumberList1.size();
        for (Integer itemCnt = 0 ; itemCnt < itemTot ; itemCnt++)
        {
            childItemNumber++;
            ensxtx_DS_Document_Detail.ITEMS item = itemNumberItemMap1.get(itemNumberList1[itemCnt]);
            Integer higherLevelItemNumber = Integer.valueOf(item.HigherLevelItemNumber);
            // A higher item level number of '0' indicates that the item is root parent item
            if(0 != higherLevelItemNumber && String.isNotEmpty(item.BillOfMaterial))
            {                
                // A child item could have its own child item
                // This is a workaround that replace the HigherLevelItemNumber with the top parent
                if (childItemHigherLevelItem.containsKey(item.HigherLevelItemNumber)) 
                {
                    item.HigherLevelItemNumber = childItemHigherLevelItem.get(item.HigherLevelItemNumber);
                    higherLevelItemNumber = Integer.valueOf(item.HigherLevelItemNumber);
                }
                childItemHigherLevelItem.put(item.ItemNumber, item.HigherLevelItemNumber);
                item.ItemNumber = String.valueOf(higherLevelItemNumber + childItemNumber);
            } else childItemNumber = 0;

            itemNumberItemMap2.put(Integer.valueOf(item.ItemNumber),item);
            itemNumberList2.add(Integer.valueOf(item.ItemNumber));
        }

        Map<String, PriceBookEntry> sapMaterialPBEMap = new Map<String, PriceBookEntry>();
        Integer pbeTot = pricebookEntriesMap.size();
        for (Integer pbeCnt = 0 ; pbeCnt < pbeTot ; pbeCnt++) {
            PriceBookEntry pbe = pricebookEntriesMap.values()[pbeCnt];
            Product2 prod = (Product2) pbe.Product2;
            sapMaterialPBEMap.put((String) prod.get(ensxtx_UTIL_SFProduct.MaterialFieldName), pbe);
        }
        Map<Integer, List<SBQQ__QuoteLine__c>> parentChildMap = new Map<Integer, List<SBQQ__QuoteLine__c>>();
        Map<Decimal, SBQQ__QuoteLine__c> newLinkedQuoteLinesMap = new Map<Decimal, SBQQ__QuoteLine__c>();

        Integer qlTot = cpqQuoteLineList.size();
        Map<Decimal, SBQQ__QuoteLine__c> cqpQuoteLineMap = new Map<Decimal, SBQQ__QuoteLine__c>();
        
        Set<Id> productFeaturesProdIdSet = new Set<Id>();
        for (Integer qlCnt = 0 ; qlCnt < qlTot ; qlCnt++) {
            SBQQ__QuoteLine__c cpqQuoteLine = cpqQuoteLineList[qlCnt];
            cqpQuoteLineMap.put(cpqQuoteLine.SBQQ__Number__c.stripTrailingZeros(), cpqQuoteLine);
            productFeaturesProdIdSet.add(cpqQuoteLine.SBQQ__Product__c);
        }
        List<SObject> productFeaturesList = Database.query('SELECT Id, Name, SBQQ__ConfiguredSKU__c FROM SBQQ__ProductFeature__c WHERE SBQQ__ConfiguredSKU__c IN :productFeaturesProdIdSet AND Name = \'SAP BoM\'');
        Map<Id, SObject> productFeaturesMap = new Map<Id, SObject>(productFeaturesList);
        Integer pfTot = productFeaturesList.size();

        Decimal newCPQNumber = -2;
        for (Integer qlCnt = 0 ; qlCnt < qlTot ; qlCnt++)
        {
            SBQQ__QuoteLine__c cpqQuoteLine = cpqQuoteLineList[qlCnt];
            if (cpqQuoteLine.SBQQ__Number__c <= newCPQNumber) newCPQNumber = cpqQuoteLine.SBQQ__Number__c - 1;
            ensxtx_DS_Document_Detail.CPQ_VC_ITEM_CONFIGURATION itemConfig = new ensxtx_DS_Document_Detail.CPQ_VC_ITEM_CONFIGURATION();
            if (String.isNotEmpty(cpqQuoteLine.ensxtx_SAP_Configuration__c)) {
                itemConfig = (ensxtx_DS_Document_Detail.CPQ_VC_ITEM_CONFIGURATION) JSON.deserialize(cpqQuoteLine.ensxtx_SAP_Configuration__c,ensxtx_DS_Document_Detail.CPQ_VC_ITEM_CONFIGURATION.class);
            }
            SBQQ__QuoteLine__c parentQuoteLine = null;
            if (cpqQuoteLine.SBQQ__DynamicOptionId__c == null || 
                !cpqQuoteLine.SBQQ__DynamicOptionId__c.contains(':') ||
                !productFeaturesMap.containsKey(cpqQuoteLine.SBQQ__DynamicOptionId__c.split(':')[0])) 
            {
                newLinkedQuoteLinesMap.put(cpqQuoteLine.SBQQ__Number__c.stripTrailingZeros(), cpqQuoteLine);
            } else {
                parentQuoteLine = itemConfig == null ? null : cqpQuoteLineMap.get(Decimal.valueOf(itemConfig.ParentLineItem));
            }
            if (parentQuoteLine == null) parentQuoteLine = cpqQuoteLine;
            if (parentQuoteLine.ensxtx_SAP_Item_Number__c != null && parentQuoteLine.ensxtx_SAP_Item_Number__c != cpqQuoteLine.ensxtx_SAP_Item_Number__c) {
                Integer itemNumber = Integer.valueOf(parentQuoteLine.ensxtx_SAP_Item_Number__c);
                List<SBQQ__QuoteLine__c> childList = parentChildMap.containsKey(itemNumber) ? parentChildMap.get(itemNumber) : new List<SBQQ__QuoteLine__c>();
                childList.add(cpqQuoteLine);
                parentChildMap.put(itemNumber,childList);
            }
        }

        Boolean AddVCBoM = (Boolean)ensxtx_UTIL_AppSettings.getValue(ensxtx_UTIL_AppSettings.CPQV2, 'AddVCBoM', true);
        Boolean AddNonVCBoM = (Boolean)ensxtx_UTIL_AppSettings.getValue(ensxtx_UTIL_AppSettings.CPQV2, 'AddNonVCBoM', true);
        Set<String> missingMaterialSet = new Set<String>();
        Map<Decimal, String> qlMaterialMap = new Map<Decimal, String>();
        for (Integer itemCnt = 0 ; itemCnt < itemTot ; itemCnt++)
        {
            Integer itemNumber = itemNumberList2[itemCnt];
            ensxtx_DS_Document_Detail.ITEMS item = itemNumberItemMap2.get(itemNumber);
            SBQQ__QuoteLine__c cpqQuoteLine = cqpQuoteLineMap.get(item.CPQNumber.stripTrailingZeros());
            if (cpqQuoteLine == null) {
                Integer hlItemNumber = Integer.valueOf(item.HigherLevelItemNumber);
                if (hlItemNumber == 0) hlItemNumber = itemNumber;
                List<SBQQ__QuoteLine__c> childList = parentChildMap.get(hlItemNumber);
                if (childList != null) {
                    Integer chdTot = childList.size();
                    for (Integer chdCnt = 0 ; chdCnt < chdTot ; chdCnt++) {
                        SBQQ__QuoteLine__c chdQuoteLine = childList[chdCnt];
                        Product2 prod = productMap.get(chdQuoteLine.SBQQ__Product__c);
                        String SAPMaterialNumber = (String) prod.get(ensxtx_UTIL_SFProduct.MaterialFieldName);
                        SAPMaterialNumber = String.isEmpty(SAPMaterialNumber) ? null : SAPMaterialNumber.replaceFirst('^0+(?!$)', '');
                        String materialEntered = String.isEmpty(item.MaterialEntered) ? null : item.MaterialEntered.replaceFirst('^0+(?!$)', '');
                        if (SAPMaterialNumber == materialEntered) {
                            cpqQuoteLine = chdQuoteLine;
                            childList.remove(chdCnt);
                            break;
                        }
                    }
                }
            }
            ensxtx_DS_Document_Detail.ITEMS parentItem = null;
            SBQQ__QuoteLine__c parentQuoteLine = null;
            if (String.isNotEmpty(item.BillOfMaterial) && Integer.valueOf(item.HigherLevelItemNumber) != 0) {
                parentItem = itemNumberItemMap2.get(Integer.valueOf(item.HigherLevelItemNumber));
                parentQuoteLine = parentItem == null ? null : newLinkedQuoteLinesMap.get(parentItem.CPQNumber.stripTrailingZeros());
            }
            if (cpqQuoteLine == null) {
                cpqQuoteLine = new SBQQ__QuoteLine__c();
                cpqQuoteLine.SBQQ__Number__c = newCPQNumber--;
                if (parentQuoteLine != null) {
                    for (Integer pfCnt = 0 ; pfCnt < pfTot ; pfCnt++ ) {
                        SBQQ__ProductFeature__c prodFeat = (SBQQ__ProductFeature__c) productFeaturesList[pfCnt];
                        if (prodFeat.SBQQ__ConfiguredSKU__c == parentQuoteLine.SBQQ__Product__c) {
                            cpqQuoteLine.SBQQ__DynamicOptionId__c = prodFeat.Id + ':';
                            break;
                        }
                    }
                    ensxtx_DS_Document_Detail.CPQ_VC_ITEM_CONFIGURATION itemConfig = new ensxtx_DS_Document_Detail.CPQ_VC_ITEM_CONFIGURATION();
                    itemConfig.ParentLineItem = Integer.valueOf(parentQuoteLine.SBQQ__Number__c);
                    cpqQuoteLine.ensxtx_SAP_Configuration__c = JSON.serialize(itemConfig);
                }
                missingMaterialSet.add(item.MaterialEntered.replaceFirst('^0+(?!$)', ''));
                qlMaterialMap.put(cpqQuoteLine.SBQQ__Number__c, item.MaterialEntered.replaceFirst('^0+(?!$)', ''));
            }
            if (cpqQuoteLine.SBQQ__Number__c == null) cpqQuoteLine.SBQQ__Number__c = newCPQNumber--;
            mapItemPricingFields(cpqQuoteLine, item, debugMap);
            cpqQuoteLine.SBQQ__Quantity__c = item.OrderQuantity;
            if (parentQuoteLine != null) {
                cpqQuoteLine.SBQQ__BundledQuantity__c = cpqQuoteLine.SBQQ__Quantity__c / parentQuoteLine.SBQQ__Quantity__c;
            }
            newLinkedQuoteLinesMap.put(cpqQuoteLine.SBQQ__Number__c.stripTrailingZeros(), cpqQuoteLine);
            if (String.isNotEmpty(item.BillOfMaterial) && Integer.valueOf(item.HigherLevelItemNumber) != 0) {
                if (parentQuoteLine != null) {
                    PriceBookEntry pbe = sapMaterialPBEMap.get(item.Material);
                    if (pbe != null) item.ProductId = pbe.Product2Id;
                    newLinkedQuoteLinesMap.put(parentItem.CPQNumber.stripTrailingZeros(), parentQuoteLine);
                }
            }
        }

        Map<String, Id> missingProductMap = new Map<String, Id>();
        if (missingMaterialSet.size() > 0) {
            List<String> fields = new List<String>();
            String configurableMaterialField = ensxtx_UTIL_SFProduct.getConfigurableMaterialField();
            if (String.isNotEmpty(configurableMaterialField)) fields.add(configurableMaterialField);
            String bomMaterialField = ensxtx_UTIL_SFProduct.getBOMMaterialField();
            if (String.isNotEmpty(bomMaterialField)) fields.add(bomMaterialField);
            Map<Id, Product2> pMap = ensxtx_UTIL_SFProduct.getProductsByField(ensxtx_UTIL_SFProduct.MaterialFieldName, new List<String>(missingMaterialSet), fields);
            List<SObject> missingProductList = pMap.size() > 0 ? pMap.values() : new List<SObject>();
            Integer mpTot = missingProductList.size();
            for (Integer mpCnt = 0 ; mpCnt < mpTot ; mpCnt++) {
                Product2 missingProduct = (Product2) missingProductList[mpCnt];
                missingProductMap.put((String) missingProduct.get(ensxtx_UTIL_SFProduct.MaterialFieldName), missingProduct.Id);
                productMap.put(missingProduct.Id, missingProduct);
            }
        }

        cpqQuoteLineList.clear();
        List<Decimal> nlQlKeyList = new List<Decimal>(newLinkedQuoteLinesMap.keySet());
        nlQlKeyList.sort();
        Integer keyTot = nlQlKeyList.size();
        for (Integer keyCnt = 0 ; keyCnt < keyTot ; keyCnt++) {
            SBQQ__QuoteLine__c cpqQuoteLine = newLinkedQuoteLinesMap.get(nlQlKeyList[keyCnt]);
            String sapMaterial = qlMaterialMap.get(cpqQuoteLine.SBQQ__Number__c);
            if (String.isEmpty(cpqQuoteLine.SBQQ__Product__c)) {
                cpqQuoteLine.SBQQ__Product__c = missingProductMap.get(sapMaterial);
                if (String.isNotEmpty(cpqQuoteLine.SBQQ__DynamicOptionId__c)) cpqQuoteLine.SBQQ__DynamicOptionId__c += cpqQuoteLine.SBQQ__Product__c;
            }
            cpqQuoteLineList.add(cpqQuoteLine);
        }
    }

    public static void mapSalesDocumentItemPricing(ensxtx_DS_Document_Detail.ITEMS item) {
        SBQQ__QuoteLine__c cpqQuoteLine = new SBQQ__QuoteLine__c();

        // Map Customer specific fields from SAP simulated item to quote line

        // cpqQuoteLine.SBQQ__PriceEditable__c = item.isPriceEditable;
        // cpqQuoteLine.SBQQ__ListPrice__c = item.CPQListPrice;
        mapItemPricingFields(cpqQuoteLine, item, new Map<String, Object>());

        // Map Customer specific fields from quote line to SAP simulated item

        // item.CPQListPrice = cpqQuoteLine.SBQQ__ListPrice__c;
        // item.CPQUnitCost = cpqQuoteLine.SBQQ__UnitCost__c;
    }

    private static void mapItemPricingFields(
        SBQQ__QuoteLine__c cpqQuoteLine,
        ensxtx_DS_Document_Detail.ITEMS item,
        Map<String, Object> debugMap
    ) {
        applyQuoteLineResponseMappingRules(cpqQuoteLine, item, debugMap);
        cpqQuoteLine.ensxtx_SAP_Simulated__c = true;
        cpqQuoteLine.ensxtx_SAP_Item_Number__c = item.ItemNumber;

        // Customer Specific unique quote lime mapping rules should go here
    }

    private static Map<String, List<PriceTracingTableEntry>> targetFieldPriceTracingTable;
    @testvisible
    private static void applyQuoteResponseMappingRules(
        SBQQ__Quote__c cpqQuote,
        ensxtx_DS_Document_Detail salesDocDetail,
        Map<String, Object> debugMap,
        Boolean isQuoteUpdated
    ) {
        if (cpqPricingConfig == null) {
            cpqPricingConfig = (CPQPricingConfig)ensxtx_UTIL_AppSettings.getSObject(ensxtx_UTIL_AppSettings.CPQV2, 'Pricing',CPQPricingConfig.class, null);
        }
        if (null == cpqPricingConfig || null == cpqPricingConfig.Response || null == cpqPricingConfig.Response.Quote || 
            null == cpqPricingConfig.Response.Quote.RecordMapping || cpqPricingConfig.Response.Quote.RecordMapping.isEmpty()) {
            return;
        }
        List<CPQPricingConfigMappingRule> recordMappingRules = cpqPricingConfig.Response.Quote.RecordMapping;
        if (ensxtx_UTIL_CPQ_SetupV2.getFromAppSettings().config.DEBUG) {
            debugMap.put('Header', 
                new Map<String,Object>{
                    'headerConditions' => salesDocDetail.CONDITIONS
                }
            );
        }
        Map<String, Object> salesDocDetailMap = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(salesDocDetail));
        targetFieldPriceTracingTable = new Map<String, List<PriceTracingTableEntry>>();
        Integer ruleTot = recordMappingRules.size();
        for (Integer ruleCnt = 0 ; ruleCnt < ruleTot ; ruleCnt++) {
            CPQPricingConfigMappingRule rule = recordMappingRules[ruleCnt];
            if (String.isEmpty(rule.sObjectField)) continue;
            Object value = null;
            switch on rule.collection {
                when 'header' {
                    value = salesDocDetailMap.get(rule.field);
                }
                when 'conditions' {
                    List<PriceTracingTableEntry> priceTracingTables = transformConditionToValue(rule, salesDocDetail.CONDITIONS, null);
                    Decimal currentValue = (Decimal) cpqQuote.get(rule.sObjectField);
                    value = setPricingTables(currentValue, rule, priceTracingTables, targetFieldPriceTracingTable);
                }
                when else {
                    System.debug('applyQuoteResponseMappingRules: unrecognized sboCollection: ' + rule);
                }
            }
            cpqQuote.put(rule.sObjectField, value);
            isQuoteUpdated = true;
        }
    }
    
    @testvisible
    private static void applyQuoteLineResponseMappingRules(
        SBQQ__QuoteLine__c cpqQuoteLine,
        ensxtx_DS_Document_Detail.ITEMS item,
        Map<String, Object> debugMap
    ) {

        if (cpqPricingConfig == null) {
            cpqPricingConfig = (CPQPricingConfig)ensxtx_UTIL_AppSettings.getSObject(ensxtx_UTIL_AppSettings.CPQV2, 'Pricing',CPQPricingConfig.class, null);
        }
        if (null == cpqPricingConfig || null == cpqPricingConfig.Response || null == cpqPricingConfig.Response.QuoteLine || 
            null == cpqPricingConfig.Response.QuoteLine.RecordMapping || cpqPricingConfig.Response.QuoteLine.RecordMapping.isEmpty()) {
            return;
        }
        List<CPQPricingConfigMappingRule> recordMappingRules = cpqPricingConfig.Response.QuoteLine.RecordMapping;
        if (ensxtx_UTIL_CPQ_SetupV2.getFromAppSettings().config.DEBUG) {
            debugMap.put(String.valueOf(cpqQuoteLine.SBQQ__Number__c), 
                new Map<String,Object>{
                    'itemConditions' => item.SBOItemConditions
                }
            );
        }
        Map<String, Object> itemMap = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(item));
        targetFieldPriceTracingTable = new Map<String, List<PriceTracingTableEntry>>();
        Integer ruleTot = recordMappingRules.size();

        for (Integer ruleCnt = 0 ; ruleCnt < ruleTot ; ruleCnt++) {
            CPQPricingConfigMappingRule rule = recordMappingRules[ruleCnt];
            if (String.isEmpty(rule.sObjectField)) continue;
            Object defaultValue = rule.type == 'Boolean' ? (Object)Boolean.valueOf(rule.defaultValue) : (Object)rule.defaultValue;
            Object value = defaultValue;
            switch on rule.collection {
                when 'items' {
                    value = transformItemToValue(rule, itemMap);
                    if (rule.showInTrace == null || rule.showInTrace) {
                        List<PriceTracingTableEntry> priceTracingTables = buildPriceTracingTableForItemField(rule, itemMap, value);
                        value = setPricingTables(0, rule, priceTracingTables, targetFieldPriceTracingTable);
                    }
                }
                when 'conditions' {
                    List<PriceTracingTableEntry> priceTracingTables = transformConditionToValue(rule, item.SBOItemConditions, item.OrderQuantity);
                    Decimal currentValue = (Decimal) cpqQuoteLine.get(rule.sObjectField);
                    value = setPricingTables(currentValue, rule, priceTracingTables, targetFieldPriceTracingTable);
                }
                when else {
                    System.debug('applyQuoteLineResponseMappingRules: unrecognized sboCollection: ' + rule);
                }
            }
            cpqQuoteLine.put(rule.sObjectField, value);
        }

        if (targetFieldPriceTracingTable.size() > 0) buildTableForPriceTracing(targetFieldPriceTracingTable, cpqQuoteLine);
    }

    private static Object transformItemToValue(CPQPricingConfigMappingRule rule, Map<String, Object> itemMap)
    {
        Object value = itemMap.get(rule.field);

        if (rule.type == 'date') {
            String dateValue = (String) value;
            value = dateValue != null ? Date.valueOf(dateValue) : null;
        }
        else {
            switch on rule.transform {
                when 'perConditionPricingUnit' {
                    Decimal conditionPricingUnit = (Decimal) itemMap.get('ConditionPricingUnit');
                    if (conditionPricingUnit != null && conditionPricingUnit > 0) {
                        value = ((Decimal) value / conditionPricingUnit);
                    }
                }
            }
        }

        return value;
    }

    private static List<PriceTracingTableEntry> buildPriceTracingTableForItemField(
        CPQPricingConfigMappingRule rule, Map<String, Object> itemMap, Object value)
    {
        PriceTracingTableEntry priceTable = new PriceTracingTableEntry();
        priceTable.targetField = rule.sObjectField;
        priceTable.sourceField = rule.field;
        priceTable.sourceValue = (Decimal) value;
        priceTable.targetValueAfter = (Decimal) value;
        priceTable.currencyKey = (String) itemMap.get('SalesDocumentCurrency');
        priceTable.operation = '+';

        return new List<PriceTracingTableEntry>{priceTable};
    }

    @testvisible
    private static Decimal setPricingTables(Decimal currentValue,
        CPQPricingConfigMappingRule rule, List<PriceTracingTableEntry> priceTracingTables,
        Map<String, List<PriceTracingTableEntry>> targetFieldPriceTracingTable)
    {
        Decimal newValue = currentValue;

        if (priceTracingTables != null) {

            for (PriceTracingTableEntry priceTracingTable : priceTracingTables) {
                if (priceTracingTable.sourceValue != null) {
                    if (currentValue == null) {
                        currentValue = 0;
                    }

                    priceTracingTable.targetValueBefore = currentValue;
                    currentValue += priceTracingTable.sourceValue;
                    newValue = currentValue;
                    priceTracingTable.targetValueAfter = newValue;

                    List<PriceTracingTableEntry> currentPriceTracingTables = targetFieldPriceTracingTable.get(rule.sObjectField);
                    if (currentPriceTracingTables == null) currentPriceTracingTables = new List<PriceTracingTableEntry>();
                    currentPriceTracingTables.add(priceTracingTable);
                    targetFieldPriceTracingTable.put(rule.sObjectField, currentPriceTracingTables);
                }
            }
        }

        return newValue;
    }

    @testvisible
    private static List<PriceTracingTableEntry> transformConditionToValue(
        CPQPricingConfigMappingRule rule,
        List<ensxtx_DS_Document_Detail.CONDITIONS> conditionList,
        Decimal itemQuantity)
    {
        List<PriceTracingTableEntry> priceTracingTables = null;
        if (conditionList != null) {

            priceTracingTables = new List<PriceTracingTableEntry>();

            Integer cTot = conditionList.size();
            for (Integer cCnt = 0 ; cCnt < cTot ; cCnt++)
            {
                Decimal totalValue = 0;
                ensxtx_DS_Document_Detail.CONDITIONS condition = conditionList[cCnt];
                if (condition.ConditionType == rule.field) {
                    PriceTracingTableEntry priceTracingTable = new PriceTracingTableEntry();
                    priceTracingTable.targetField = rule.sObjectField;
                    priceTracingTable.sourceField = condition.ConditionTypeName + ' (' + condition.ConditionType + ')';

                    if (String.isNotEmpty(condition.CurrencyKey)) {
                        priceTracingTable.currencyKey = condition.CurrencyKey;
                    }

                    priceTracingTable.unitOfMeasure = condition.RateUnit;

                    switch on rule.transform {
                        when 'conditionValue' {
                            totalValue += condition.ConditionValue;
                            priceTracingTable.sourceValue = totalValue;
                            priceTracingTable.operation = '+';
                        }
                        when 'conditionValueDiscount' {
                            totalValue += -condition.ConditionValue;
                            priceTracingTable.sourceValue = totalValue;
                            priceTracingTable.operation = '-';
                        }
                        when 'conditionValuePerItemQuantity' {
                            if (itemQuantity > 0) {
                                totalValue += condition.ConditionValue / itemQuantity;
                                priceTracingTable.sourceValue = totalValue;
                            }
                            priceTracingTable.operation = '+';
                        }
                        when 'conditionValueDiscountPerItemQuantity' {
                            if (itemQuantity > 0) {
                                totalValue += -condition.ConditionValue / itemQuantity;
                                priceTracingTable.sourceValue = totalValue;
                            }
                            priceTracingTable.operation = '-';
                        }
                        when 'conditionRateAsPercent' {
                            totalValue += condition.Rate;
                            priceTracingTable.sourceValue = totalValue;
                            priceTracingTable.operation = '+';
                        }
                        when 'conditionRateDiscountAsPercent' {
                            totalValue += -condition.Rate;
                            priceTracingTable.sourceValue = totalValue;
                            priceTracingTable.operation = '-';
                        }
                        when 'conditionRate' {
                            totalValue += condition.Rate;
                            priceTracingTable.sourceValue = totalValue;
                            priceTracingTable.operation = '+';
                        }
                        when 'conditionRateDiscount' {
                            totalValue += -condition.Rate;
                            priceTracingTable.sourceValue = totalValue;
                            priceTracingTable.operation = '-';
                        }
                        when 'conditionRateUnit' {
                            priceTracingTable.unitOfMeasure = condition.RateUnit;
                            priceTracingTable.operation = '';
                        }
                        when else {
                            System.debug('transformConditionToValue: unrecognized transform: ' + rule);
                        }
                    }

                    priceTracingTables.add(priceTracingTable);
                }
            }
        }

        return priceTracingTables;
    }

    @testvisible
    private static void buildTableForPriceTracing(Map<String, List<PriceTracingTableEntry>> targetFieldPriceTracingTable, SBQQ__QuoteLine__c quoteLine)
    {
        String combineTable = '';
        for (String targetField : targetFieldPriceTracingTable.keySet()) {
            String table = '<div style="border: solid black 1px;"><table style="width:100%">';
            table += '<thead>';
            table += '<tr>';
            table += '<th style="border: solid black 1px;">Target Field&nbsp;&nbsp;</th>';
            table += '<th style="border: solid black 1px;">Source Field&nbsp;&nbsp;</th>';
            table += '<th style="border: solid black 1px;">Source Value&nbsp;&nbsp;</th>';
            table += '<th style="border: solid black 1px;">Target Value Before&nbsp;&nbsp;</th>';
            table += '<th style="border: solid black 1px;">Target Value After&nbsp;&nbsp;</th>';
            table += '<th style="border: solid black 1px;">Currency&nbsp;&nbsp;</th>';
            table += '<th style="border: solid black 1px;">Operation&nbsp;&nbsp;</th>';
            table += '</tr>';
            table += '</thead>';
            table += '<tbody>';

            List<PriceTracingTableEntry> priceTracingTables = targetFieldPriceTracingTable.get(targetField);
            for (PriceTracingTableEntry priceTracing : priceTracingTables) {
                table += '<tr>';
                table += '<td style="border: solid black 1px;">' + priceTracing.targetField + '&nbsp;&nbsp;</td>';
                table += '<td style="border: solid black 1px;">' + priceTracing.sourceField + '&nbsp;&nbsp;</td>';
                table += '<td style="border: solid black 1px;">' + priceTracing.sourceValue + '&nbsp;&nbsp;</td>';
                table += '<td style="border: solid black 1px;">' + priceTracing.targetValueBefore + '&nbsp;&nbsp;</td>';
                table += '<td style="border: solid black 1px;">' + priceTracing.targetValueAfter + '&nbsp;&nbsp;</td>';
                table += '<td style="border: solid black 1px;">' + priceTracing.currencyKey + '&nbsp;&nbsp;</td>';
                table += '<td style="border: solid black 1px;">' + priceTracing.operation + '&nbsp;&nbsp;</td>';
                table += '</tr>';
            }
            table += '</tbody>';
            table += '</table></div>';
            table += '<p>&nbsp;</p>';
            combineTable += table;
        }

        quoteLine.put('ensxtx_SAP_PricingTrace__c', combineTable);
    }

    public class CPQPricingConfig {
        public CPQPricingConfigRequestResponse Request;
        public CPQPricingConfigRequestResponse Response;
    }

    public class CPQPricingConfigRequestResponse {
        public CPQPricingConfigRecordMapping Quote;
        public CPQPricingConfigRecordMapping QuoteLine;
    }

    public class CPQPricingConfigRecordMapping {
        public List<CPQPricingConfigMappingRule> RecordMapping;
    }

    @TestVisible
    public class CPQPricingConfigMappingRule {
        public String collection;
        public String field;
        public String partnerFunction;
        public String partnerFunctionInternal;
        public String defaultValue;
        public String sObjectField;
        public String type;
        public String transform;
        public Boolean showInTrace;
    }

    public class PriceTracingTableEntry {
        public String targetField;
        public String sourceField;
        public Decimal targetValueBefore;
        public Decimal targetValueAfter;
        public Decimal sourceValue;
        public String unitOfMeasure;
        public String currencyKey;
        public String operation;
    }
}