public with sharing class ensxtx_UTIL_CPQ_SetupV2
{
    public String customScriptName = 'ensxtx_enosix_sap_simulationV2';
    public String staticresourceCodeName = 'ensxtx_enosix_sap_simulationV2';
    public String staticresourceTranspiledCodeName = 'ensxtx_enosix_sap_simulationV2_transpiled';

    // Need to add Quote fields which are needed to be selected and included in the model passed into the simulation.
    public Set<String> quoteFields = new Set<String>();
    // QuoteLine must be included in the CPQ JSON model and is maintained by the QCP / EC via JavaScript
    // Need to add QuoteLine fields which are needed to be selected and included in the model passed into the simulation.
    public Set<String> quoteLineFields = new Set<String>();

    public ScriptConfig config = new ScriptConfig();

    public class ScriptConfig {
        public Boolean DEBUG = true;
        public Boolean resortBom = true;
        public String splitSimulationLevel = 'PerLine';
        public String splitSimulationGroupByField = '';
        public String quoteSimulationEnabledField = 'ensxtx_enablePricingSimulation__c';
        public String quoteLineSimulationEnabledField = 'ensxtx_enablePricingSimulation__c';
        public String enosixSapSimulationApexService = '/ensxtx_ENSX_CPQ_QuoteCalculationServV2';
        public Set<String> requestQuoteRecordFields = new Set<String>{};
        public Set<String> requestQuoteLineRecordFields = new Set<String>{};
        public String instanceUrl;
    }

    public static void installCustomScript()
    {
        getFromAppSettings().installThisCustomScript();
    }

    private static ensxtx_UTIL_CPQ_SetupV2 cpqSetup = null;

    public static ensxtx_UTIL_CPQ_SetupV2 getFromAppSettings()
    {
        if (cpqSetup == null) {
            cpqSetup = (ensxtx_UTIL_CPQ_SetupV2)ensxtx_UTIL_AppSettings.getSObject(ensxtx_UTIL_AppSettings.CPQV2, 'UTIL_CPQ_SetupV2', ensxtx_UTIL_CPQ_SetupV2.class, new ensxtx_UTIL_CPQ_SetupV2());
        }
        return cpqSetup;
    }

    public void installThisCustomScript()
    {
        if (quoteFields == null) quoteFields = new Set<String>();
        quoteFields.add('ensxtx_SAP_Simulation_Error__c');
        quoteFields.add('ensxtx_SAP_Resimulate__c');
        quoteFields.add('ensxtx_SAP_Consistency_Check__c');
        quoteFields.add('ensxtx_SAP_Simulated_JSON__c');
        if (quoteLineFields == null) quoteLineFields = new Set<String>();
        quoteLineFields.add('ensxtx_SAP_Configuration__c');
        quoteLineFields.add('ensxtx_SAP_QuoteLine_JSON__c');
        quoteLineFields.add('ensxtx_SAP_Item_Number__c');
        quoteLineFields.add('ensxtx_SAP_Simulation_Error__c');
        quoteLineFields.add('ensxtx_SAP_Simulated__c');
        quoteLineFields.add('ensxtx_SAP_Simulated_JSON__c');
        if (null != config) {
            config.instanceUrl = URL.getOrgDomainUrl().toExternalForm().toLowercase();
            if (String.isNotEmpty(config.quoteSimulationEnabledField)) quoteFields.add(config.quoteSimulationEnabledField);
            if (String.isNotEmpty(config.quoteLineSimulationEnabledField)) quoteLineFields.add(config.quoteLineSimulationEnabledField);
            if (String.isNotEmpty(config.splitSimulationGroupByField)) quoteLineFields.add(config.splitSimulationGroupByField);
            if (config.requestQuoteRecordFields == null) config.requestQuoteRecordFields = new Set<String>();
            if (config.requestQuoteLineRecordFields == null) config.requestQuoteLineRecordFields = new Set<String>();
            config.requestQuoteRecordFields.add('ensxtx_SAP_Consistency_Check__c');
            ensxtx_UTIL_CPQ_QuotePricingV2.CPQPricingConfig cpqPricingConfig = (ensxtx_UTIL_CPQ_QuotePricingV2.CPQPricingConfig)ensxtx_UTIL_AppSettings.getSObject(ensxtx_UTIL_AppSettings.CPQV2, 'Pricing', ensxtx_UTIL_CPQ_QuotePricingV2.CPQPricingConfig.class, null);
            if (cpqPricingConfig != null && cpqPricingConfig.Request != null) {
                if (cpqPricingConfig.Request.Quote != null && cpqPricingConfig.Request.Quote.RecordMapping != null && !cpqPricingConfig.Request.Quote.RecordMapping.isEmpty()) {
                    List<ensxtx_UTIL_CPQ_QuotePricingV2.CPQPricingConfigMappingRule> recordMappingRules = cpqPricingConfig.Request.Quote.RecordMapping;
                    Integer ruleTot = recordMappingRules.size();
                    for (Integer ruleCnt = 0 ; ruleCnt < ruleTot ; ruleCnt++) {
                        ensxtx_UTIL_CPQ_QuotePricingV2.CPQPricingConfigMappingRule rule = recordMappingRules[ruleCnt];
                        if (String.isNotEmpty(rule.sObjectField)) {
                            config.requestQuoteRecordFields.add(rule.sObjectField);
                        }
                    }
                }
                if (cpqPricingConfig.Request.QuoteLine != null && cpqPricingConfig.Request.QuoteLine.RecordMapping != null && !cpqPricingConfig.Request.QuoteLine.RecordMapping.isEmpty()) {
                    List<ensxtx_UTIL_CPQ_QuotePricingV2.CPQPricingConfigMappingRule> recordMappingRules = cpqPricingConfig.Request.QuoteLine.RecordMapping;
                    Integer ruleTot = recordMappingRules.size();
                    for (Integer ruleCnt = 0 ; ruleCnt < ruleTot ; ruleCnt++) {
                        ensxtx_UTIL_CPQ_QuotePricingV2.CPQPricingConfigMappingRule rule = recordMappingRules[ruleCnt];
                        if (String.isNotEmpty(rule.sObjectField)) {
                            config.requestQuoteLineRecordFields.add(rule.sObjectField);
                        }
                    }
                }
            }
            quoteFields.addAll(config.requestQuoteRecordFields);
            quoteLineFields.addAll(config.requestQuoteLineRecordFields);
        }

        //checkFieldSet('SBQQ__Quote__c', 'ReferencedFields', new Set<String>(config.requestQuoteRecordFields));
        
        System.debug(JSON.serializePretty(config));
        insertCustomBundleActions();
        upsertCustomScript(
            customScriptName,
            applyConfig(ensxtx_UTIL_StaticResource.getStringResourceContents(staticresourceCodeName),config),
            applyConfig(ensxtx_UTIL_StaticResource.getStringResourceContents(staticresourceTranspiledCodeName),config)
        );
    }

    public class FieldSetException extends Exception
    {}

    @TestVisible
    private void checkFieldSet(String sObjectName, String fieldSetName, Set<String> fieldsSet) {
        Schema.SObjectType targetType = Schema.getGlobalDescribe().get(sObjectName);
        Map<String, List<String>> fieldSetMap = new Map<String, List<String>>();
        Map<String, Schema.FieldSet> FsMap = targetType.getDescribe().fieldSets.getMap();
        Schema.FieldSet fs1 = FsMap.get(fieldSetName);
        List<FieldSetMember> fsmList = fs1.getFields();
        for (FieldSetMember fsm : fsmList) {
            String field = fsm.getSObjectField().getDescribe().getName();
            if (fieldsSet.contains(field)) fieldsSet.remove(field);
        }
        if (fieldsSet.size() > 0) {
            String error = 'Error: ' + sObjectName + ' ' + fieldSetName + ' Field Set missing fields ' + String.join(new List<String>(fieldsSet), ',');
            if (!Test.isRunningTest()) throw new FieldSetException(error);
        }
    }

    private String applyConfig(String code, ScriptConfig config)
    {
        return code.replace('{/*ENOSIXCONFIG*/}', JSON.serialize(config));
    }

    @TestVisible
    private void insertCustomBundleActions()
    {
        // Boolean UseBundleBom = (Boolean)ensxtx_UTIL_AppSettings.getValue(ensxtx_UTIL_AppSettings.VC, 'UseBundleBom', false);
        // SBQQ__CustomAction__c customActionConfigureSapVc = new SBQQ__CustomAction__c (
        //     SBQQ__Active__c = UseBundleBom,
        //     SBQQ__BrandButton__c = false,
        //     SBQQ__ConditionsMet__c = 'All',
        //     SBQQ__Default__c = false,
        //     SBQQ__DisplayOrder__c = 1,
        //     SBQQ__Label__c = 'Configure SAP VC',
        //     SBQQ__Location__c = 'Configurator',
        //     SBQQ__Page__c = 'Product Configurator',
        //     SBQQ__Type__c = 'Button',
        //     SBQQ__URLTarget__c = 'Popup',
        //     SBQQ__URL__c = '{!$Setup.GeneralSettings__c.ExternalConfigurationURL__c}',
        //     Name = 'Configure SAP VC'
        // );
        
        // // obtain existing records if they exist
        // String query = 'SELECT Id, Name FROM SBQQ__CustomAction__c WHERE Name in (\'Update SAP BoM\', \'Configure SAP VC\')';
        // List<SBQQ__CustomAction__c> existingCustomActionList = Database.query(query);
        // Set<String> nameSet = new Set<String>();
        // Integer exTot = existingCustomActionList.size();
        // for (Integer exCnt = 0 ; exCnt < exTot ; exCnt++) {
        //     SBQQ__CustomAction__c exCA = existingCustomActionList[exCnt];
        //     if (exCA.name == 'Configure SAP VC') customActionConfigureSapVc = null;
        // }
        // List<SBQQ__CustomAction__c> insertListCa = new List<SBQQ__CustomAction__c>();
        // if (customActionConfigureSapVc != null) insertListCa.add(customActionConfigureSapVc);
        // if (insertListCa.size() > 0) insert insertListCa;
    }

    @TestVisible
    private void upsertCustomScript(String customScriptName, String code, String transpiledCode)
    {
        SBQQ__CustomScript__c customScript = new SBQQ__CustomScript__c(
            Name = customScriptName
        );
        // obtain existing record if it exists
        String query = 'SELECT Id, Name, SBQQ__Code__c, SBQQ__TranspiledCode__c, SBQQ__QuoteFields__c, SBQQ__QuoteLineFields__c FROM SBQQ__CustomScript__c WHERE Name LIKE \'' + customScriptName + '%\'';
        List<SBQQ__CustomScript__c> existingCustomScriptList = Database.query(query);
        Integer exTot = existingCustomScriptList.size();
        SBQQ__CustomScript__c currCS = null;
        Integer nameValue = 0;
        for (Integer exCnt = 0 ; exCnt < exTot ; exCnt++) {
            SBQQ__CustomScript__c exCS = existingCustomScriptList[exCnt];
            if (exCS.Name == customScriptName) {
                currCS = exCS;
            }
            else if (exCS.Name.contains('|')) {
                Integer exValue = Integer.valueOf(exCS.Name.split('\\|')[1]);
                nameValue = exValue > nameValue ? exValue : nameValue;
            }
        }
        List<SBQQ__CustomScript__c> upsertListCs = new List<SBQQ__CustomScript__c>();
        if (currCS != null) {
            String currCodeCheck = currCS.SBQQ__Code__c != null ? currCS.SBQQ__Code__c.replaceAll('[\n\r\t\'" ]','') : null;
            String newCodeCheck = code != null ? code.replaceAll('[\n\r\t\'" ]','') : null;
            String currTransCodeCheck = currCS.SBQQ__TranspiledCode__c != null ? currCS.SBQQ__TranspiledCode__c.replaceAll('[\n\r\t\'" ]','') : null;
            String newTransCodeCheck = transpiledCode != null ? transpiledCode.replaceAll('[\n\r\t\'" ]','') : null;
            String currQuoteFields = currCS.SBQQ__QuoteFields__c == null ? '' : currCS.SBQQ__QuoteFields__c;
            String currQuoteLineFields = currCS.SBQQ__QuoteLineFields__c == null ? '' : currCS.SBQQ__QuoteLineFields__c;
            if (
                currCodeCheck == newCodeCheck &&
                currTransCodeCheck == newTransCodeCheck &&
                currQuoteFields == String.join(new List<String>(quoteFields), '\n') &&
                currQuoteLineFields == String.join(new List<String>(quoteLineFields), '\n'))
            {
                return;
            }
            nameValue++;
            currCS.Name = customScriptName + '|' + nameValue;
            upsertListCs.add(currCS);
        }
        customScript.SBQQ__Code__c = code;
        customScript.SBQQ__TranspiledCode__c = transpiledCode + '\n//# sourceURL='+staticresourceTranspiledCodeName;

        customScript.SBQQ__QuoteFields__c = String.join(new List<String>(quoteFields), '\n');
        customScript.SBQQ__QuoteLineFields__c = String.join(new List<String>(quoteLineFields), '\n');
        upsertListCs.add(customScript);

        upsert upsertListCs;
    }
}