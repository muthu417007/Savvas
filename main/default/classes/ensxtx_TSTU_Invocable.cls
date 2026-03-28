@isTest
public class ensxtx_TSTU_Invocable
{
    @isTest
    public static void test_insertSalesDocLog()
    {
        Account acct = ensxtx_TSTU_SFTestObject.createTestAccount();
        ensxtx_TSTU_SFTestObject.upsertWithRetry(acct);

        ensxtx_UTIL_PageMessages.addMessage(ensxtx_UTIL_PageMessages.ERROR, 'Test Message');

        ensxtx_SAP_Transact_Log__c sapTransactLog = new ensxtx_SAP_Transact_Log__c();
        sapTransactLog.put(ensxtx_UTIL_Invocable.objectTypeIdFieldName.get('Account'), acct.Id);
        sapTransactLog.ensxtx_InstanceNumber__c = 1;
        ensxtx_TSTU_SFTestObject.upsertWithRetry(sapTransactLog);

        ensxtx_UTIL_Invocable.insertSalesDocLog(ensxtx_UTIL_PageMessages.messageList, acct, 'Simulate', new ensxtx_DS_Document_Detail());
    }

    @isTest
    public static void test_getSalesDocLog()
    {
        Account acct = ensxtx_TSTU_SFTestObject.createTestAccount();
        ensxtx_TSTU_SFTestObject.upsertWithRetry(acct);

        ensxtx_UTIL_PageMessages.addMessage(ensxtx_UTIL_PageMessages.ERROR, 'Test Message');

        ensxtx_UTIL_Invocable.getSalesDocLog(ensxtx_UTIL_PageMessages.messageList, acct.Id, 'Simulate', new ensxtx_DS_Document_Detail());
    }

    @isTest
    public static void test_saveSalesDocMessageTable()
    {
        ensxtx_UTIL_Invocable.saveSalesDocMessageTable(null, new Account());
    }
}