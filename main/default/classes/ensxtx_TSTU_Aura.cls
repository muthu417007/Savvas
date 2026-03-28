@isTest
public with sharing class ensxtx_TSTU_Aura
{
    @isTest
    public static void test_setSearchContextSearchParams()
    {
        SearchContextTest searchContext = new SearchContextTest();
        Map<String, Object> searchParams = new Map<String, Object>{
            'CustomerNumber' => '1234',
            'Test' => '444'
        };
        ensxtx_UTIL_Aura.setSearchContextSearchParams(searchContext.SEARCHPARAMS, searchParams);
    }

    @isTest
    public static void test_setSearchContextPagingOptions()
    {
        Test.startTest();
        Map<String, Object> pagingOptions = new Map<String, Object>();
        pagingOptions.put('pageSize', '10');
        pagingOptions.put('pageNumber', '1');
        ensxtx_UTIL_Aura.setSearchContextPagingOptions(new SearchContextTest(), pagingOptions);

        Map<String, Object> sortField = new Map<String, Object>{
            'precedence' => 1,
            'sortField' => 'TEST',
            'direction' => 'Descending'
        };
        List<Map<String, Object>> sortFields = new List<Map<String, Object>>{sortField};
        ensxtx_UTIL_Aura.setSearchContextPagingOptions(new SearchContextTest(), pagingOptions, sortFields);
    }

    public class SearchContextTest extends ensxsdk.EnosixFramework.SearchContext
    {
        public SearchContextTest()
        {
            super(new Map<string, type>{
                'SearchParamsTest' => ensxtx_TSTU_Aura.SearchParamsTest.class
            });
        }
        public override Type getType() { return SearchContextTest.class; }

        @AuraEnabled public ensxtx_TSTU_Aura.SearchParamsTest SEARCHPARAMS
        {
            get
            {
                return (ensxtx_TSTU_Aura.SearchParamsTest)this.getStruct(ensxtx_TSTU_Aura.SearchParamsTest.class);
            }
        }
    }

    public class SearchParamsTest extends ensxsdk.EnosixFramework.ValueObject
    {
        public override Type getType() { return SearchParamsTest.class; }
    }

    @isTest
    public static void test_addHttpTrace()
    {
        ensxtx_UTIL_Aura.addHttpTrace(new ensxapp__Log__c());

    }

    @isTest
    public static void test_createResponse()
    {
        Test.startTest();
        Object data = 1;
        Object pagingOptions = 2;
        ensxtx_UTIL_PageMessages.addMessage(null, null);
        ensxtx_UTIL_Aura.Response response1 = ensxtx_UTIL_Aura.createResponse(data, pagingOptions);
        String namespacePrefix = response1.namespacePrefix;
        ensxtx_UTIL_Aura.Response response2 = ensxtx_UTIL_Aura.createResponse(data);
        Test.stopTest();

        System.assertEquals(1, response1.data);
        System.assertEquals(2, response1.pagingOptions);
        System.assertEquals(ensxtx_UTIL_Namespace.namespacePrefix, response1.namespacePrefix);
        System.assertNotEquals(null, response1.messages);
        System.assertEquals(1, response1.messages.size());
        System.assertEquals(null, response1.messages[0].message);

        System.assertEquals(1, response2.data);
        System.assertEquals(null, response2.pagingOptions);
        System.assertNotEquals(null, response2.messages);
        System.assertEquals(0, response2.messages.size());
    }
}