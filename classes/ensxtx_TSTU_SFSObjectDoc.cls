@isTest
public class ensxtx_TSTU_SFSObjectDoc
{
    @isTest
    public static void test_methods()
    {
        Account acct = ensxtx_TSTU_SFTestObject.createTestAccount();
        ensxtx_TSTU_SFTestObject.upsertWithRetry(acct);
        Id pricebookId = ensxtx_UTIL_Pricebook.getStandardPriceBookId();

        Opportunity opp = ensxtx_TSTU_SFTestObject.createTestOpportunity();
        opp.AccountId = acct.Id;
        opp.Pricebook2Id = pricebookId;
        ensxtx_TSTU_SFTestObject.upsertWithRetry(opp);

        Product2 prod = ensxtx_TSTU_SFTestObject.createTestProduct2();
        ensxtx_TSTU_SFTestObject.upsertWithRetry(prod);

        PricebookEntry pbe = ensxtx_TSTU_SFTestObject.createTestPriceBookEntry();
        pbe.Product2Id = prod.Id;
        pbe.Pricebook2Id = pricebookId;
        pbe.UnitPrice = 10;
        pbe.IsActive = true;

        OpportunityLineItem oli = ensxtx_TSTU_SFTestObject.createTestOpportunityLineItem();
        oli.Product2Id = prod.Id;
        oli.OpportunityId = opp.Id;
        oli.Quantity = 1;
        oli.TotalPrice = 10;

        SObject testObject = ensxtx_UTIL_SFSObjectDoc.initObjectsForSAP(acct.Id, '1111', 'Test');
        ensxtx_UTIL_SFSObjectDoc.callReturnMethod(null, null, null);
        ensxtx_UTIL_SFSObjectDoc.getSObject(opp.Id);
        Map<Id, SObject> lineItems = ensxtx_UTIL_SFSObjectDoc.getSObjectLineItems(opp);
        Map<Id, SObject> contacts = ensxtx_UTIL_SFSObjectDoc.getSObjectContacts(opp);
        Object value = ensxtx_UTIL_SFSObjectDoc.getAccountId(opp);
        value = ensxtx_UTIL_SFSObjectDoc.getCustomerNumber(opp);
        value = ensxtx_UTIL_SFSObjectDoc.getName(opp);
        value = ensxtx_UTIL_SFSObjectDoc.getQuoteNumber(opp);
        value = ensxtx_UTIL_SFSObjectDoc.getOrderNumber(opp);
        value = ensxtx_UTIL_SFSObjectDoc.getContractNumber(opp);
        value = ensxtx_UTIL_SFSObjectDoc.getInquiryNumber(opp);
        value = ensxtx_UTIL_SFSObjectDoc.getCreditMemoNumber(opp);
        value = ensxtx_UTIL_SFSObjectDoc.getDebitMemoNumber(opp);
        value = ensxtx_UTIL_SFSObjectDoc.getReturnOrderNumber(opp);
        value = ensxtx_UTIL_SFSObjectDoc.getStatus(opp);
        value = ensxtx_UTIL_SFSObjectDoc.getOpportunityId(opp);
        value = ensxtx_UTIL_SFSObjectDoc.getMaterial(opp, oli);
        value = ensxtx_UTIL_SFSObjectDoc.getItemNumber(opp, oli);
        Id idValue = ensxtx_UTIL_SFSObjectDoc.getPriceBookId(opp);
        idValue = ensxtx_UTIL_SFSObjectDoc.getProductId(opp, oli);
        ensxtx_DS_SalesDocAppSettings appSettings = ensxtx_TSTD_SalesDocAppSettings.buildAppSettings();
        ensxtx_DS_Document_Detail documentDetail = ensxtx_TSTD_Document_Detail.buildSalesDocDetail();
        ensxtx_DS_Document_Detail result = ensxtx_UTIL_SFSObjectDoc.sObjectToSalesDocMapping(opp,
            new List<OpportunityLineItem>{oli},documentDetail, appSettings);
        ensxtx_UTIL_SFSObjectDoc.sObjectToSalesDocMapping(null, null, null, null);

        testObject = ensxtx_UTIL_SFSObjectDoc.salesDocMappingToSObject(opp, documentDetail, appSettings);
        ensxtx_UTIL_SFSObjectDoc.salesDocMappingToSObject(null, null, null);
        Map<String,Map<String,Object>> lineItemsMap = new Map<String,Map<String,Object>>();
        Map<String,Object> objectMap = new Map<String,Object>();
        objectMap.put('sfLineItem', oli);
        objectMap.put('materialEntry', pbe);
        objectMap.put('salesDocItem', documentDetail.ITEMS[0]);
        lineItemsMap.put('1', objectMap);
        ensxtx_UTIL_SFSObjectDoc.salesDocLineItemMappingToSObject(opp, appSettings, lineItemsMap);
        ensxtx_UTIL_SFSObjectDoc.compareSAPSimulateVsSObject(documentDetail, documentDetail, appSettings);
        ensxtx_UTIL_SFSObjectDoc.mapCustomPricingToSalesDoc(documentDetail, appSettings);
        ensxtx_UTIL_SFSObjectDoc.mapChildBomFields(documentDetail, documentDetail, appSettings);
    }
}