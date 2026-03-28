@IsTest
public class ensxtx_TSTU_SFTestObject
{
    static Integer accountCnt = 0;
    public static Account createTestAccount()
    {
        Account accountObj = new Account();
        accountObj.Name = 'TestAccount' + accountCnt++;
        return accountObj;
    }

    public static Case createTestCase()
    {
        Case caseObj = new Case();
        return caseObj;
    }

    static Integer contactCnt = 0;
    public static Contact createTestContact(Account acct)
    {
        Contact contactObj = new Contact();
        contactObj.LastName = 'TestContact' + contactCnt++;
        contactObj.Email = 'abc@abc.com';
        contactObj.Phone = '9999';
        contactObj.MobilePhone = '9999';
        contactObj.MDR_ID__c = 'test';
        if (acct != null) contactObj.AccountId = acct.id;
        return contactObj;
    }

    public static Opportunity createTestOpportunity()
    {
        Opportunity opportunityObj = new Opportunity();
        opportunityObj.Name = 'testSObject';
        opportunityObj.StageName = 'Prospect';
        opportunityObj.CloseDate = Date.today();
        return opportunityObj;
    }

    public static OpportunityContactRole createTestOpportunityContactRole(Opportunity opportunityObj, Contact contactObj)
    {
        OpportunityContactRole oppContRoleObj = new OpportunityContactRole();
        if (opportunityObj != null) oppContRoleObj.OpportunityId = opportunityObj.Id;
        if (contactObj != null) oppContRoleObj.ContactId = contactObj.Id;
        return oppContRoleObj;
    }

    private static void insertOrUpdateWithRetry(List<SObject> objList, String op)
    {
        Integer upsertTries = 10;
        Boolean isSuccess = false;
        do {
            try {
                if ('insert' == op) Database.insert(objList);
                if ('update' == op) Database.update(objList);
                isSuccess = true;
            } catch (Exception e) {
                upsertTries -= 1;
                if (upsertTries == 0)
                {
                    isSuccess = true;
                    throw e;
                }
            }
        } while(!isSuccess);
    }

    public static void upsertWithRetry(List<SObject> objList)
    {
        List<SObject> insertList = new List<SObject>();
        List<SObject> updateList = new List<SObject>();
        Integer listSize = objList.size();
        for (Integer index = 0 ; index < listSize ; index++)
        {
            SObject obj = objList[index];
            if (String.isNotBlank(obj.Id)) {
                updateList.add(obj);
            } else {
                insertList.add(obj);
            }
        }
        if (insertList.size() > 0) insertOrUpdateWithRetry(insertList, 'insert');
        if (updateList.size() > 0) insertOrUpdateWithRetry(updateList, 'update');
    }

    public static void upsertWithRetry(SObject obj)
    {
        if (String.isNotBlank(obj.Id)) {
            insertOrUpdateWithRetry(new List<SObject>{ obj }, 'update');
        } else {
            insertOrUpdateWithRetry(new List<SObject>{ obj }, 'insert');
        }
    }

    public static OpportunityLineItem createTestOpportunityLineItem() {
        OpportunityLineItem opportunityLineItemObj = new OpportunityLineItem();
        return opportunityLineItemObj;
    }

    // Price Book Entries should not be written for tests.  Code should be created to not require Price
    // Book Entries or objects which require them like Opportunity Line Items to be written.  Selects and
    // code to use the results should be split to allow for testing.  If Price Book Entries are written in
    // test code the can cause UNABLE_TO_LOCK_ROW errors which is caused when Salesforce tries to lock the 
    // Standard Price Book
    public static PriceBookEntry createTestPriceBookEntry() {
        PriceBookEntry priceBookEntryObj = new PriceBookEntry();
        return priceBookEntryObj;
    }

    static Integer priceBookCnt = 0;
    public static Id createTestPriceBook2() {
        PriceBook2 priceBookObj = new PriceBook2();
        priceBookObj.Name = 'Mock Price Book' + priceBookCnt++;
        ensxtx_TSTU_SFTestObject.upsertWithRetry(priceBookObj);
        return priceBookObj.Id;
    }

    static Integer productCnt = 0;
    public static Product2 createTestProduct2() {
        Product2 productObj = new Product2();
        productObj.Name = 'Mock Product' + productCnt++;
        productObj.isActive = true;
        productObj.put(ensxtx_UTIL_SFProduct.MaterialFieldName, productObj.Name);
        return productObj;
    }

    public static SObject setFormulafield(SObject sObj, String fieldName, Object value)
    {
        String jsonString = JSON.serialize(sObj);
        Map<String,Object> dataMap = (Map<String,Object>)JSON.deserializeUntyped(jsonString);
        dataMap.put(fieldName, value);
        jsonString = JSON.serialize(dataMap);
        return (SObject)JSON.deserialize(jsonString, SObject.class);
    }

    // ex. - sfObject.Id = ensxtx_TSTU_SFTestObject.getFakeId(Opportunity.SObjectType);
    static Integer getFakeId_s_num = 1;
    public static Id getFakeId(Schema.SObjectType sot)
    {
       return Id.valueOf(sot.getDescribe().getKeyPrefix() + String.valueOf(getFakeId_s_num++).leftPad(12, '0'));
    }
}