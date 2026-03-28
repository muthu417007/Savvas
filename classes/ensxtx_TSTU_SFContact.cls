@IsTest
private class ensxtx_TSTU_SFContact
{
    @isTest
    static void test_getContactFromId()
    {
        Test.startTest();
        Contact contact = ensxtx_TSTU_SFTestObject.createTestContact(null);
        ensxtx_TSTU_SFTestObject.upsertWithRetry(contact);
        Contact fetched = ensxtx_UTIL_SFContact.getContactFromId(contact.Id);
        System.assertEquals(contact.LastName, fetched.LastName);
        System.assertEquals(contact.Id, fetched.Id);
        Account acct = ensxtx_TSTU_SFTestObject.createTestAccount();
        ensxtx_TSTU_SFTestObject.upsertWithRetry(acct);
        ensxtx_UTIL_SFContact.getContactFromId(acct.Id);
        Test.stopTest();
    }

    @isTest
    static void test_getContactNumberFromContact()
    {
        Test.startTest();
        Contact contact = ensxtx_TSTU_SFTestObject.createTestContact(null);
        ensxtx_TSTU_SFTestObject.upsertWithRetry(contact);
        String testContactNumber = 'TestContact';
        ensxtx_UTIL_SFContact.setContactContactNumber(contact, testContactNumber);
        String contactField = ensxtx_UTIL_SFContact.getContactNumberFromContact(contact);
        String ContactCustomerFieldName = ensxtx_UTIL_SFContact.ContactCustomerFieldName;
        Test.stopTest();
    }
}