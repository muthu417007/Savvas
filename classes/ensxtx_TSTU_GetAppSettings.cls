@isTest
public with sharing class ensxtx_TSTU_GetAppSettings {
    @isTest
    public static void test_getAppsettings()
    {
        ensxtx_UTIL_GetAppSettings.testBody = null;
        ensxtx_UTIL_GetAppSettings.getAppsettings('test');
    }
}