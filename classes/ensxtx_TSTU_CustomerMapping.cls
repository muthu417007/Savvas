@isTest public with sharing class ensxtx_TSTU_CustomerMapping
{
    @isTest
    static void test_getMapping()
    {
        Test.startTest();
        Account testAcct = ensxtx_TSTU_SFTestObject.createTestAccount();
        ensxtx_TSTU_SFTestObject.upsertWithRetry(testAcct);
        ensxtx_UTIL_CustomerMapping.CustomerInformationMapping CIM = ensxtx_UTIL_CustomerMapping.getMapping();
        CIM = ensxtx_UTIL_CustomerMapping.getMapping(testAcct.Id);
        CIM = ensxtx_UTIL_CustomerMapping.getMapping(testAcct);
        List<ensxtx_UTIL_CustomerMapping.SearchFieldMapping> allFields = CIM.allFields;
        Test.stopTest();
    }

    @isTest
    static void test_getSettingsUrl()
    {
        Test.startTest();
        ensxtx_UTIL_CustomerMapping.getSettingsUrl();
        Test.stopTest();
    }
}