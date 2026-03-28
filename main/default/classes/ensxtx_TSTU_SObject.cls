@isTest public with sharing class ensxtx_TSTU_SObject
{
    @isTest
    static void test_CustomerNumberFieldAccessException()
    {
        Test.startTest();
        String fakeId = ensxtx_TSTU_SFTestObject.getFakeId(Account.SObjectType);
        ensxtx_UTIL_SObject.CustomerNumberFieldAccessException acctExcep = new ensxtx_UTIL_SObject.CustomerNumberFieldAccessException(fakeId);
        String message = acctExcep.getMessage();
        Test.stopTest();
    }

    @isTest
    static void test_getSObjectNameFromId()
    {
        Account acct = ensxtx_TSTU_SFTestObject.createTestAccount();
        ensxtx_TSTU_SFTestObject.upsertWithRetry(acct);

        Test.startTest();
        String sObjName = ensxtx_UTIL_SObject.getSObjectNameFromId(null);
        sObjName = ensxtx_UTIL_SObject.getSObjectNameFromId(acct.Id);
        Test.stopTest();

        System.assertEquals(sObjName, 'Account');

    }

    @isTest
    static void test_getSObjectById()
    {
        Account testAcct = ensxtx_TSTU_SFTestObject.createTestAccount();
        testAcct.put(ensxtx_UTIL_SFAccount.CustomerFieldName, 'TEST');
        ensxtx_TSTU_SFTestObject.upsertWithRetry(testAcct);

        List<String> fields = new List<String>();
        fields.add('Name');

        Test.startTest();

        SObject getObj = ensxtx_UTIL_SObject.getSObjectById(testAcct.Id, fields);
        
        Account getAcct = (Account)getObj;

        Test.stopTest();

        System.assertEquals(testAcct.Name,getAcct.Name);

    }


    @isTest
    static void test_isSobjectLinkedToCustomer()
    {
        Account testAcct = ensxtx_TSTU_SFTestObject.createTestAccount();
        ensxtx_TSTU_SFTestObject.upsertWithRetry(testAcct);

        Test.startTest();
        try
        {
            Boolean result1 = ensxtx_UTIL_SObject.isSObjectLinkedToCustomer(testAcct.Id);
            System.assertEquals(result1, false);
        }
        catch(Exception e)
        {
            System.assertEquals(e.getMessage(),'Unable to read SAP Customer Number because your user does not have access to "AccountNumber" field on "Account" Sobject');
        }

        ensxtx_UTIL_SObject.setCustomerNumberOnSObject(testAcct.Id, 'customerNumber');
        ensxtx_UTIL_SObject.getValueFromSObjectField(null, null, null);
        ensxtx_UTIL_SObject.getValueFromSObjectField(testAcct, 'Bad Field', '');
        ensxtx_UTIL_SObject.getValueFromSObjectField(testAcct, 'Name', 'warningMessageFormat');
        Test.stopTest();

    }

    @isTest
    static void test_isSobjectLinkedToCustomer2()
    {
        Account testAcct = ensxtx_TSTU_SFTestObject.createTestAccount();
        testAcct.put(ensxtx_UTIL_SFAccount.CustomerFieldName, 'TEST');
        ensxtx_TSTU_SFTestObject.upsertWithRetry(testAcct);

        Test.startTest();
        try
        {
            Boolean result2 = ensxtx_UTIL_SObject.isSObjectLinkedToCustomer(testAcct.Id);
            System.assertEquals(result2, true);
        }
        catch(Exception e)
        {
            System.assertEquals(e.getMessage(),'Unable to read SAP Customer Number because your user does not have access to "AccountNumber" field on "Account" Sobject');
        }
        Test.stopTest();

    }

    @isTest
    static void test_booleanCalls()
    {
        Test.startTest();
        Id testId = Id.valueOf('001xa000003DIlo');

        Boolean custMapping = ensxtx_UTIL_SObject.doesSObjectHaveCustomerMapping(testId);
        Boolean userAccess = ensxtx_UTIL_SObject.canUserAccessSObjectCustomerNumber(testId);
        Boolean custNumber = ensxtx_UTIL_SObject.canUserSetSObjectCustomerNumber(testId);
        ensxtx_UTIL_SObject.getCustomerNumberFieldfromSObject(new Account());
        Boolean userAccessField = ensxtx_UTIL_SObject.canUserAccessSObjectField(testId, 'Name');
        Test.stopTest();

        System.Assert(custMapping == true);
        System.Assert(userAccessField == true);
    }

    @isTest
    static void test_selectCurrencyField()
    {
        Test.startTest();
        String selectCurrencyField = ensxtx_UTIL_SObject.selectCurrencyField('Opportunity');
        Test.stopTest();
    }

    @isTest
    static void test_getCurrencyIsoCode()
    {
        Test.startTest();
        String getCurrencyIsoCode = ensxtx_UTIL_SObject.getCurrencyIsoCode('Opportunity', new Opportunity());
        Test.stopTest();
    }

    @isTest
    static void test_putCurrencyIsoCode()
    {
        Test.startTest();
        ensxtx_UTIL_SObject.putCurrencyIsoCode('Opportunity', new Opportunity(), 'USD');
        Test.stopTest();
    }

    @isTest
    public static void testDoesSobjectFieldExist()
    {
        Test.startTest();
        ensxtx_UTIL_SObject.doesSobjectFieldExist('Account', 'Test Field');
        Test.stopTest();
    }
}