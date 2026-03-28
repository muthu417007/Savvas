@IsTest
private class ensxtx_TSTU_SFAccount
{
    @isTest
    static void test_CustomerFieldNameAccessException()
    {
        Test.startTest();
        ensxtx_UTIL_SFAccount.CustomerFieldNameAccessException acctExcep = new ensxtx_UTIL_SFAccount.CustomerFieldNameAccessException();
        String message = acctExcep.getMessage();
        Test.stopTest();
    }

    @isTest
    static void test_getAccountFromId()
    {
        Test.startTest();
        Account acct = ensxtx_TSTU_SFTestObject.createTestAccount();
        ensxtx_TSTU_SFTestObject.upsertWithRetry(acct);
        System.debug('A');
        Account fetched = ensxtx_UTIL_SFAccount.getAccountById(ensxtx_TSTU_SFTestObject.getFakeId(Opportunity.SObjectType));
        System.debug('B');
        fetched = ensxtx_UTIL_SFAccount.getAccountById(acct.Id);
        System.debug('C');
        fetched = ensxtx_UTIL_SFAccount.getAccountById(acct.Id, new List<String>{'name'});
        System.debug('D');
        System.assertEquals(acct.Name, fetched.Name);
        System.assertEquals(acct.Id, fetched.Id);
        ensxtx_UTIL_SFAccount.getValueFromAccountField(acct, '', 'warningMessageFormat');
        ensxtx_UTIL_SFAccount.getValueFromAccountField(acct, 'Bad Field', 'warningMessageFormat');
        ensxtx_UTIL_SFAccount.getValueFromAccountField(acct, 'Name', 'warningMessageFormat');
        acct.Name = null;
        ensxtx_UTIL_SFAccount.getValueFromAccountField(acct, 'Name', 'warningMessageFormat');
        Test.stopTest();
    }

    @isTest
    static void test_getCustomerNumberFromAccount()
    {
        Test.startTest();
        Account acct = ensxtx_TSTU_SFTestObject.createTestAccount();
        ensxtx_TSTU_SFTestObject.upsertWithRetry(acct);
        String testCustNumber = 'TESTCUST';
        ensxtx_UTIL_SFAccount.setAccountCustomerNumber(acct, testCustNumber);
        try 
        {
            String customerNumber=ensxtx_UTIL_SFAccount.getCustomerNumberFromAccount(acct);
            System.assertEquals(customerNumber, testCustNumber);
        }
        catch(Exception e) 
        {
            System.assertEquals(e.getMessage(),'Your account does not have access to Account field "AccountNumber" to retrieve the SAP customer.');
        }
        Test.stopTest();
    }

    @isTest
    public static void test_getSObject()
    {
        Account newAccount = ensxtx_TSTU_SFTestObject.createTestAccount();
        ensxtx_TSTU_SFTestObject.upsertWithRetry(newAccount);

        ensxtx_UTIL_SFAccount utility = new ensxtx_UTIL_SFAccount();
        utility.getSObject(newAccount.Id);
        utility.getSObject(newAccount.Id);
        utility.getSObject(ensxtx_TSTU_SFTestObject.getFakeId(Opportunity.SObjectType));
    }

    @isTest
    public static void test_getCustomerNumber()
    {
        ensxtx_UTIL_SFAccount utility = new ensxtx_UTIL_SFAccount();
        utility.getCustomerNumber(null, null);
    }

    @isTest
    public static void test_getParentCustomerNumber()
    {
        ensxtx_UTIL_SFAccount utility = new ensxtx_UTIL_SFAccount();
        utility.getParentCustomerNumber(null, null);
    }

    @isTest
    public static void test_sObjectToCustomerMapping()
    {
        ensxtx_UTIL_SFAccount utility = new ensxtx_UTIL_SFAccount();
        utility.sObjectToCustomerMapping(new Account(), null, ensxtx_UTIL_Customer.SOLD_TO_PARTNER_CODE);
    }

    @isTest
    public static void test_customerMappingToSObject()
    {
        ensxtx_UTIL_SFAccount utility = new ensxtx_UTIL_SFAccount();
        ensxtx_DS_Customer_Detail customerDetail = new ensxtx_DS_Customer_Detail();
        customerDetail.IsSuccess = true;
        utility.customerMappingToSObject(new Account(), customerDetail, ensxtx_UTIL_Customer.SOLD_TO_PARTNER_CODE);
    }
}