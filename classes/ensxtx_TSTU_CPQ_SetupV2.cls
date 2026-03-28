@IsTest
public with sharing class ensxtx_TSTU_CPQ_SetupV2
{
    @isTest
    static void test_getFromAppSettings()
    {
        ensxtx_UTIL_CPQ_SetupV2.getFromAppSettings();
        ensxtx_UTIL_CPQ_SetupV2.installCustomScript();
        ensxtx_UTIL_CPQ_SetupV2.getFromAppSettings().installThisCustomScript();
    }

    @IsTest
    public static void test_installCustomScript()
    {
        Test.startTest();
        SBQQ__CustomAction__c customActionUpdateSapBom = new SBQQ__CustomAction__c (
            SBQQ__Active__c = true,
            SBQQ__BrandButton__c = false,
            SBQQ__ConditionsMet__c = 'All',
            SBQQ__Default__c = false,
            SBQQ__DisplayOrder__c = 1,
            SBQQ__Label__c = 'Update SAP BoM',
            SBQQ__Location__c = 'Quote',
            SBQQ__Page__c = 'Quote Line Editor',
            SBQQ__Type__c = 'Menu',
            SBQQ__URLTarget__c = 'Popup',
            SBQQ__URL__c = '{!$Setup.GeneralSettings__c.ExternalConfigurationURL__c}',
            Name = 'Update SAP BoM'
        );
        upsert customActionUpdateSapBom;

        ensxtx_UTIL_CPQ_SetupV2 util = new ensxtx_UTIL_CPQ_SetupV2();
        SBQQ__CustomScript__c cs = new SBQQ__CustomScript__c();
        cs.Name = util.customScriptName;
        ensxtx_TSTU_SFTestObject.upsertWithRetry(cs);       
        ensxtx_UTIL_CPQ_SetupV2.installCustomScript();
        Test.stopTest();
        System.assert(null != [SELECT Id FROM SBQQ__CustomScript__c WHERE Name = :(util.customScriptName)].Id);
        ensxtx_UTIL_CPQ_SetupV2.getFromAppSettings().insertCustomBundleActions();
    }

    @IsTest
    public static void test_checkFieldSet()
    {
        Test.startTest();
        ensxtx_UTIL_CPQ_SetupV2 util = new ensxtx_UTIL_CPQ_SetupV2();
        try {
            util.checkFieldSet('SBQQ__ProductOption__c', 'ensxtx_SAPOptionConfiguration', new Set<String>{'test'});
        } catch (Exception e) {}
        Test.stopTest();
    }

    @IsTest
    public static void test_upsertCustomScript()
    {
        Test.startTest();
        ensxtx_UTIL_CPQ_SetupV2 util = new ensxtx_UTIL_CPQ_SetupV2();
        util.upsertCustomScript('customScriptName', '', '');
        String query = 'SELECT Id, Name, SBQQ__Code__c, SBQQ__TranspiledCode__c, SBQQ__QuoteFields__c, SBQQ__QuoteLineFields__c FROM SBQQ__CustomScript__c WHERE Name = \'customScriptName\'';
        List<SBQQ__CustomScript__c> existingCustomScriptList = Database.query(query);
        util.upsertCustomScript('customScriptName', existingCustomScriptList[0].SBQQ__Code__c, existingCustomScriptList[0].SBQQ__TranspiledCode__c);
        util.quoteFields.add('ensxtx_SAP_Simulation_Error__c');
        util.upsertCustomScript('customScriptName', '', '');
        util.quoteFields.clear();
        util.upsertCustomScript('customScriptName', '', '');
        Test.stopTest();
    }
}