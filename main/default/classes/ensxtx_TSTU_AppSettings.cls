@isTest
public class ensxtx_TSTU_AppSettings
{
    static final string TEST_JSON =
        '{"list1":["FERT","ZERT"],"set1":["A","*"],"bool1":false,' +
        '"dec1":1234.1234,"map1":{"Name":"Test Name"},"bools":[true,false,true],' +
        '"str1":"test string","atype":"Account","ttype":"ensxtx_TSTU_AppSettings.TestType"}';

    public class TestType {}

    @isTest 
    static void test_staticVariables()
    {
        Test.startTest();
        String testString = ensxtx_UTIL_AppSettings.Prefix;
        testString = ensxtx_UTIL_AppSettings.Suffix;
        testString = ensxtx_UTIL_AppSettings.EnterpriseApp;
        testString = ensxtx_UTIL_AppSettings.Cart;
        testString = ensxtx_UTIL_AppSettings.VC;
        testString = ensxtx_UTIL_AppSettings.CPQ;
        testString = ensxtx_UTIL_AppSettings.CPQV2;
        testString = ensxtx_UTIL_AppSettings.CustomerSyncBatch;
        testString = ensxtx_UTIL_AppSettings.MaterialSyncBatch;
        testString = ensxtx_UTIL_AppSettings.ContactSyncBatch;
        testString = ensxtx_UTIL_AppSettings.InvoiceSyncBatch;
        testString = ensxtx_UTIL_AppSettings.OrderSyncBatch;
        testString = ensxtx_UTIL_AppSettings.QuoteSyncBatch;
        testString = ensxtx_UTIL_AppSettings.CustInvocable;
        Test.stopTest();
    }

    @isTest 
    static void test_validJSON()
    {
        Boolean isJsonValid = false;

        Test.startTest();
        try
        {
            String testString = (String)ensxtx_UTIL_AppSettings.getValue(ensxtx_UTIL_AppSettings.EnterpriseApp, 'x');
            isJsonValid = true;
        }
        catch (Exception ex)
        {
            isJsonValid = false;
        }
        Test.stopTest();

        System.assert(isJsonValid == true, 'Failure parsing EnsxAppSettings JSON resource');
    }

    @isTest 
    static void test_noJSON()
    {
        ensxtx_UTIL_AppSettings.settingsMap.put(ensxtx_UTIL_AppSettings.Prefix + ensxtx_UTIL_AppSettings.EnterpriseApp + ensxtx_UTIL_AppSettings.Suffix, (Map<String, Object>)JSON.deserializeUntyped('{}'));
        Test.startTest();
        Boolean b1 = (Boolean)ensxtx_UTIL_AppSettings.getValue(ensxtx_UTIL_AppSettings.EnterpriseApp, 'bool1', true);
        Boolean b2 = (Boolean)ensxtx_UTIL_AppSettings.getValue(ensxtx_UTIL_AppSettings.EnterpriseApp, 'bool2', false);
        Boolean b3 = (Boolean)ensxtx_UTIL_AppSettings.getValue(ensxtx_UTIL_AppSettings.EnterpriseApp, 'bool3');
        Test.stopTest();

        System.assert(b1 == true);
        System.assert(b2 == false);
        System.assert(b3 == null);
    }

    @isTest 
    static void test_getValue()
    {
        ensxtx_UTIL_AppSettings.settingsMap.put(ensxtx_UTIL_AppSettings.Prefix + ensxtx_UTIL_AppSettings.EnterpriseApp + ensxtx_UTIL_AppSettings.Suffix, (Map<String, Object>)JSON.deserializeUntyped(TEST_JSON));

        Test.startTest();
        String s0 = (String)ensxtx_UTIL_AppSettings.getValue(ensxtx_UTIL_AppSettings.EnterpriseApp, 'str0');
        String s1 = (String)ensxtx_UTIL_AppSettings.getValue(ensxtx_UTIL_AppSettings.EnterpriseApp, 'str1');
        String s2 = (String)ensxtx_UTIL_AppSettings.getValue(ensxtx_UTIL_AppSettings.EnterpriseApp, 'str1', 'DEFAULT');
        String s3 = (String)ensxtx_UTIL_AppSettings.getValue(ensxtx_UTIL_AppSettings.EnterpriseApp, 'str3', 'DEFAULT');
        Boolean b1 = (Boolean)ensxtx_UTIL_AppSettings.getValue(ensxtx_UTIL_AppSettings.EnterpriseApp, 'bool1');
        Decimal d1 = (Decimal)ensxtx_UTIL_AppSettings.getValue(ensxtx_UTIL_AppSettings.EnterpriseApp, 'dec1');
        Test.stopTest();

        System.assert(s0 == null);
        System.assert(s1 == 'test string');
        System.assert(s2 == s1);
        System.assert(s3 == 'DEFAULT');
        System.assert(b1 == false);
        System.assert(d1 == 1234.1234);
    }

    @isTest 
    static void test_getList()
    {
        ensxtx_UTIL_AppSettings.settingsMap.put(ensxtx_UTIL_AppSettings.Prefix + ensxtx_UTIL_AppSettings.EnterpriseApp + ensxtx_UTIL_AppSettings.Suffix, (Map<String, Object>)JSON.deserializeUntyped(TEST_JSON));

        Test.startTest();
        List<String> s1 = (List<String>)ensxtx_UTIL_AppSettings.getList(ensxtx_UTIL_AppSettings.EnterpriseApp, 'list1', String.class);
        List<String> s2 = (List<String>)ensxtx_UTIL_AppSettings.getList(ensxtx_UTIL_AppSettings.EnterpriseApp, 'list1', String.class, new List<String>());
        List<Boolean> b1 = (List<Boolean>)ensxtx_UTIL_AppSettings.getList(ensxtx_UTIL_AppSettings.EnterpriseApp, 'bools', Boolean.class);
        List<String> none = (List<String>)ensxtx_UTIL_AppSettings.getList(ensxtx_UTIL_AppSettings.EnterpriseApp, 'listnone', String.class);
        List<String> empty = (List<String>)ensxtx_UTIL_AppSettings.getList(ensxtx_UTIL_AppSettings.EnterpriseApp, 'listnone', String.class, new List<String>());
        Test.stopTest();

        System.assert(s1.get(0) == 'FERT');
        System.assert(s1.get(1) == 'ZERT');
        System.assert(s2 == s1);
        System.assert(b1.get(0) == true);
        System.assert(b1.get(1) == false);
        System.assert(b1.get(2) == true);
        System.assert(none == null);
        System.assert(empty.isEmpty());
    }

    @isTest 
    static void test_getSet()
    {
        ensxtx_UTIL_AppSettings.settingsMap.put(ensxtx_UTIL_AppSettings.Prefix + ensxtx_UTIL_AppSettings.EnterpriseApp + ensxtx_UTIL_AppSettings.Suffix, (Map<String, Object>)JSON.deserializeUntyped(TEST_JSON));

        Test.startTest();
        Set<String> s1 = (Set<String>)ensxtx_UTIL_AppSettings.getSet(ensxtx_UTIL_AppSettings.EnterpriseApp, 'set1', String.class);
        Set<String> s2 = (Set<String>)ensxtx_UTIL_AppSettings.getSet(ensxtx_UTIL_AppSettings.EnterpriseApp, 'set1', String.class, new Set<String>());
        Set<Boolean> b1 = (Set<Boolean>)ensxtx_UTIL_AppSettings.getSet(ensxtx_UTIL_AppSettings.EnterpriseApp, 'bools', Boolean.class);
        Set<String> none = (Set<String>)ensxtx_UTIL_AppSettings.getSet(ensxtx_UTIL_AppSettings.EnterpriseApp, 'setnone', String.class);
        Set<String> empty = (Set<String>)ensxtx_UTIL_AppSettings.getSet(ensxtx_UTIL_AppSettings.EnterpriseApp, 'setnone', String.class, new Set<String>());
        Test.stopTest();

        System.assert(s1.containsAll(new List<String>{'*', 'A'}));
        System.assert(s2 == s1);
        System.assert(b1.containsAll(new List<Boolean>{true, false}));
        System.assert(none == null);
        System.assert(empty.isEmpty());
    }

    @isTest 
    static void test_getMap()
    {
        ensxtx_UTIL_AppSettings.settingsMap.put(ensxtx_UTIL_AppSettings.Prefix + ensxtx_UTIL_AppSettings.EnterpriseApp + ensxtx_UTIL_AppSettings.Suffix, (Map<String, Object>)JSON.deserializeUntyped(TEST_JSON));

        Test.startTest();
        Map<String, String> m1 = (Map<String, String>)ensxtx_UTIL_AppSettings.getMap(
            ensxtx_UTIL_AppSettings.EnterpriseApp, 'map1', String.class, String.class);

        Map<String, String> m2 = (Map<String, String>)ensxtx_UTIL_AppSettings.getMap(
            ensxtx_UTIL_AppSettings.EnterpriseApp, 'map1', String.class, String.class, new Map<String, String>());

        Map<String, String> none = (Map<String, String>)ensxtx_UTIL_AppSettings.getMap(
            ensxtx_UTIL_AppSettings.EnterpriseApp, 'mapnone', String.class, String.class);

        Map<String, Boolean> empty = (Map<String, Boolean>)ensxtx_UTIL_AppSettings.getMap(
            ensxtx_UTIL_AppSettings.EnterpriseApp, 'mapnone', String.class, Boolean.class, new Map<String, Boolean>());

        Test.stopTest();

        System.assert(m1.get('Name') == 'Test Name');
        System.assert(m2 == m1);
        System.assert(none == null);
        System.assert(empty.isEmpty());
    }

    @isTest 
    static void test_getSObject()
    {
        ensxtx_UTIL_AppSettings.settingsMap.put(ensxtx_UTIL_AppSettings.Prefix + ensxtx_UTIL_AppSettings.EnterpriseApp + ensxtx_UTIL_AppSettings.Suffix, (Map<String, Object>)JSON.deserializeUntyped(TEST_JSON));

        Account defaultAccount = ensxtx_TSTU_SFTestObject.createTestAccount();

        Test.startTest();
        Account a1 = (Account)ensxtx_UTIL_AppSettings.getSObject(ensxtx_UTIL_AppSettings.EnterpriseApp, 'map1', Account.class);
        Account a2 = (Account)ensxtx_UTIL_AppSettings.getSObject(ensxtx_UTIL_AppSettings.EnterpriseApp, 'map1', Account.class, ensxtx_TSTU_SFTestObject.createTestAccount());
        Account none = (Account)ensxtx_UTIL_AppSettings.getSObject(ensxtx_UTIL_AppSettings.EnterpriseApp, 'none', Account.class);
        Account def = (Account)ensxtx_UTIL_AppSettings.getSObject(ensxtx_UTIL_AppSettings.EnterpriseApp, 'none', Account.class, defaultAccount);
        Test.stopTest();

        System.assert(a1.Name == 'Test Name');
        System.assert(a2 == a1);
        System.assert(none == null);
        System.assert(def == defaultAccount);
    }
}