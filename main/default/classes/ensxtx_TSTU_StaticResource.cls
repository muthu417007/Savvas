@isTest
public with sharing class ensxtx_TSTU_StaticResource
{
    private static String getStringResourceName()
    {
        List<StaticResource> sr = [SELECT Name FROM StaticResource WHERE ContentType = 'application/javascript' LIMIT 1];
        return sr[0].Name;
    }

    @isTest
    public static void test_getStringResourceContents()
    {
        String name = getStringResourceName();
        Test.startTest();
        String contents = ensxtx_UTIL_StaticResource.getStringResourceContents(name);
        Test.stopTest();
    }
}