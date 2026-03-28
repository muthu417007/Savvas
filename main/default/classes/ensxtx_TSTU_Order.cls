@isTest
public with sharing class ensxtx_TSTU_Order
{
    @isTest
    public static void test_allowedItemCategoriesByOrderType()
    {
        Test.startTest();
        Map<String, Set<String>> allowedItemCategoriesByOrderType = ensxtx_UTIL_Order.allowedItemCategoriesByOrderType;
        Test.stopTest();
    }
}