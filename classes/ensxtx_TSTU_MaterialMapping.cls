@isTest public with sharing class ensxtx_TSTU_MaterialMapping
{
    @isTest
    static void test_getMapping()
    {
        Test.startTest();
        ensxtx_UTIL_MaterialMapping.MaterialMapping MM = ensxtx_UTIL_MaterialMapping.getMapping();
        List<ensxtx_UTIL_MaterialMapping.SearchFieldMapping> allFields = MM.allFields;
        Test.stopTest();
    }

    @isTest
    static void test_getSettingsUrl()
    {
        Test.startTest();
        ensxtx_UTIL_MaterialMapping.getSettingsUrl();
        Test.stopTest();
    }
}