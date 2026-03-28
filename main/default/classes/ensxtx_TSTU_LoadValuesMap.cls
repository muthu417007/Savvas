@isTest
public with sharing class ensxtx_TSTU_LoadValuesMap {
    @isTest
    public static void test_loadValuesMap() 
    {
        Account acct = ensxtx_TSTU_SFTestObject.createTestAccount();
        acct.put(ensxtx_UTIL_SFAccount.CustomerFieldName, '1111');
        ensxtx_TSTU_SFTestObject.upsertWithRetry(acct);

        Map<String, Object> mapFieldMap = new Map<String, Object>{
            'sapField' => 'Test',
            'sfObjectType' => 'Account',
            'sfField' => 'AccountNumber',
            'defaultValue' => 'Test'
        };
        List<Map<String, Object>> mapFieldsList = new List<Map<String, Object>>{mapFieldMap};
        Map<String, Id> sfObjectIdMap = new Map<String, Id>();
        sfObjectIdMap.put('Account', acct.Id);
        ensxtx_UTIL_LoadValuesMap.loadValuesMap(mapFieldsList, sfObjectIdMap);
    }
}