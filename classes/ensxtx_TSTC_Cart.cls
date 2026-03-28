@isTest
public with sharing class ensxtx_TSTC_Cart {
    public class MOC_ensxtx_SBO_EnosixSalesDocument_Detail implements ensxsdk.EnosixFramework.DetailSBOGetMock,
        ensxsdk.EnosixFramework.DetailSBOCommandMock, ensxsdk.EnosixFramework.DetailSBOSaveMock
    {
        private boolean success = true;

        public void setSuccess(boolean successful)
        {
            this.success = successful;
        }

        private boolean throwException = false;

        public void setThrowException(boolean throwException)
        {
            this.throwException = throwException;
        }

        public ensxsdk.EnosixFramework.DetailObject executeGetDetail(object key)
        {
            if (throwException) throw new CalloutException();

            ensxtx_SBO_EnosixSalesDocument_Detail.EnosixSalesDocument result = new ensxtx_SBO_EnosixSalesDocument_Detail.EnosixSalesDocument();
            ensxtx_SBO_EnosixSalesDocument_Detail.ITEMS item = new ensxtx_SBO_EnosixSalesDocument_Detail.ITEMS();
            item.ItemNumber = '10';
            item.Material = null;
            result.ITEMS.add(item);
            result.INCOMPLETION_LOG.add(new ensxtx_SBO_EnosixSalesDocument_Detail.INCOMPLETION_LOG());
            result.setSuccess(success);
            return result;
        }

        public ensxsdk.EnosixFramework.DetailObject executeCommand(String command, ensxsdk.EnosixFramework.DetailObject obj)
        {
            if (throwException) throw new CalloutException();

            ensxtx_SBO_EnosixSalesDocument_Detail.EnosixSalesDocument result = new ensxtx_SBO_EnosixSalesDocument_Detail.EnosixSalesDocument();
            ensxtx_SBO_EnosixSalesDocument_Detail.ITEMS item = new ensxtx_SBO_EnosixSalesDocument_Detail.ITEMS();
            item.ItemNumber = '10';
            item.Material = null;
            result.ITEMS.add(item);
            result.INCOMPLETION_LOG.add(new ensxtx_SBO_EnosixSalesDocument_Detail.INCOMPLETION_LOG());
            result.setSuccess(success);
            return result;
        }

        public ensxsdk.EnosixFramework.DetailObject executeSave(ensxsdk.EnosixFramework.DetailObject obj)
        {
            ensxtx_SBO_EnosixSalesDocument_Detail.EnosixSalesDocument result = new ensxtx_SBO_EnosixSalesDocument_Detail.EnosixSalesDocument();
            result.setSuccess(success);
            return result;
        }
    }
    
    public class MOC_ensxtx_SBO_SFCIMaterialScales_Search implements ensxsdk.EnosixFramework.SearchSBOSearchMock
    {
        private boolean success = true;

        public void setSuccess(boolean successful)
        {
            this.success = successful;
        }

        private boolean throwException = false;

        public void setThrowException(boolean throwException)
        {
            this.throwException = throwException;
        }

        public ensxsdk.EnosixFramework.SearchContext executeSearch(ensxsdk.EnosixFramework.SearchContext searchContext)
        {
            if (throwException)
            {
                throw new CalloutException();
            }

            ensxtx_SBO_SFCIMaterialScales_Search.SFCIMaterialScales_SR sr = new ensxtx_SBO_SFCIMaterialScales_Search.SFCIMaterialScales_SR();

            ensxtx_SBO_SFCIMaterialScales_Search.SEARCHRESULT result = new ensxtx_SBO_SFCIMaterialScales_Search.SEARCHRESULT();
            result.ConditionNumber = 'ConditionNumber';
            result.SequenceNumber = 'SequenceNumber';
            sr.SearchResults.add(result);
            sr.setSuccess(this.success);
            searchContext.baseResult = sr;
			return searchContext;
        }
    }

    @isTest
    static void test_salesDocInvocable()
    {
    	Test.startTest();
        ensxtx_CTRL_Cart.Request rq1 = new ensxtx_CTRL_Cart.Request();
        rq1.appSettingsName = 'ensxtx_SR_enosixWebCartB2BAppSettings';
        rq1.recordId = null;
        rq1.isBackground = true;
        ensxtx_CTRL_Cart.Request rq2 = new ensxtx_CTRL_Cart.Request();
        rq2.appSettingsName = 'ensxtx_SR_enosixWebCartB2BAppSettings';
        rq2.recordId = null;
        rq2.isBackground = false;
        ensxtx_CTRL_Cart.salesDocInvocable(new List<ensxtx_CTRL_Cart.Request>{rq1, rq2});
		Test.stopTest();
    }

    @isTest
    static void test_getPartner()
    {
    	Test.startTest();
        SObject testSObject = createTestObjects();
        Map<String, Id> sfObjectIdMap = new Map<String, Id>();
        sfObjectIdMap.put('WebCart', testSObject.Id);
        ensxtx_CTRL_Cart.getPartner(ensxtx_UTIL_Customer.SHIP_TO_PARTNER_CODE, sfObjectIdMap);
		Test.stopTest();
    }

    @isTest
    static void test_savePartner()
    {
    	Test.startTest();
        SObject testSObject = createTestObjects();
        Map<String, Id> sfObjectIdMap = new Map<String, Id>();
        sfObjectIdMap.put('WebCart', testSObject.Id);
        Map<String, String> partner = new Map<String, String>();
        ensxtx_CTRL_Cart.savePartner(ensxtx_UTIL_Customer.SHIP_TO_PARTNER_CODE, partner, sfObjectIdMap);
        ensxtx_CTRL_Cart.savePartner(ensxtx_UTIL_Customer.BILL_TO_PARTNER_CODE, partner, sfObjectIdMap);
        partner.put('Country', 'Bad Country');
        ensxtx_CTRL_Cart.savePartner(ensxtx_UTIL_Customer.SHIP_TO_PARTNER_CODE, partner, sfObjectIdMap);
        ensxtx_CTRL_Cart.savePartner(ensxtx_UTIL_Customer.BILL_TO_PARTNER_CODE, partner, sfObjectIdMap);
		Test.stopTest();
    }

    private static WebCart createTestObjects()
    {
        Account acct = ensxtx_TSTU_SFTestObject.createTestAccount();
        acct.put(ensxtx_UTIL_SFAccount.CustomerFieldName, 'custNo');
        ensxtx_TSTU_SFTestObject.upsertWithRetry(acct);

        WebCart wcObj = ensxtx_TSTU_SFWebCart.createTestWebCart();
        wcObj.AccountId = acct.Id;
        ensxtx_TSTU_SFTestObject.upsertWithRetry(wcObj);

        CartDeliveryGroup cdgObj = ensxtx_TSTU_SFWebCart.createTestCartDeliveryGroup();
        cdgObj.CartId = wcObj.Id;
        ensxtx_TSTU_SFTestObject.upsertWithRetry(cdgObj);
        return wcObj;
    }

    @isTest
    public static void test_productSimulation() 
    {
        MOC_ensxtx_SBO_EnosixSalesDocument_Detail mocEnosixSalesDocumentDetail = new MOC_ensxtx_SBO_EnosixSalesDocument_Detail();
        ensxsdk.EnosixFramework.setMock(ensxtx_SBO_EnosixSalesDocument_Detail.class, mocEnosixSalesDocumentDetail);

        ensxtx_CTRL_Cart.productSimulation(new List<String>(), new Map<String, Id>{'account' => null}, 'ensxtx_SR_enosixCartPDPAppSettings', 'ensxtx_SR_enosixProductB2BAppSettings', null);
        ensxtx_CTRL_Cart.productSimulation(new List<String>(), new Map<String, Id>{'account' => null}, null, 'ensxtx_SR_enosixProductB2BAppSettings', null);
        ensxtx_CTRL_Cart.productSimulation(new List<String>(), new Map<String, Id>{'account' => null}, null, 'Bad', new Map<String, String>());
        ensxtx_UTIL_GetAppSettings.testBody = JSON.serialize(new Map<String, Object>());
        ensxtx_CTRL_Cart.productSimulation(new List<String>(), new Map<String, Id>{'account' => null}, null, 'Bad', null);
        ensxtx_UTIL_GetAppSettings.testBody = JSON.serialize(new Map<String, Object>{'1' => new Map<String, Object>(), '2' => new Map<String, Object>()});
        ensxtx_CTRL_Cart.productSimulation(new List<String>(), new Map<String, Id>{'account' => null}, null, 'Bad', null);
    }
    
    @isTest
    public static void test_cartSimulation() 
    {
        MOC_ensxtx_SBO_EnosixSalesDocument_Detail mocEnosixSalesDocumentDetail = new MOC_ensxtx_SBO_EnosixSalesDocument_Detail();
        ensxsdk.EnosixFramework.setMock(ensxtx_SBO_EnosixSalesDocument_Detail.class, mocEnosixSalesDocumentDetail);

        ensxtx_CTRL_Cart.cartSimulation(null, 'ensxtx_SR_enosixWebCartB2BAppSettings');
        ensxtx_CTRL_Cart.cartSimulation(null, 'Bad');
        ensxtx_UTIL_GetAppSettings.testBody = JSON.serialize(new Map<String, Object>());
        ensxtx_CTRL_Cart.cartSimulation(null, 'Bad');
        ensxtx_UTIL_GetAppSettings.testBody = JSON.serialize(new Map<String, Object>{'1' => new Map<String, Object>(), '2' => new Map<String, Object>()});
        ensxtx_CTRL_Cart.cartSimulation(null, 'Bad');
    }
    
    @isTest
    public static void test_createSalesDocumentn() 
    {
        MOC_ensxtx_SBO_EnosixSalesDocument_Detail mocEnosixSalesDocumentDetail = new MOC_ensxtx_SBO_EnosixSalesDocument_Detail();
        ensxsdk.EnosixFramework.setMock(ensxtx_SBO_EnosixSalesDocument_Detail.class, mocEnosixSalesDocumentDetail);

        ensxtx_CTRL_Cart.createSalesDocument(null, 'ensxtx_SR_enosixWebCartB2BAppSettings');
        ensxtx_CTRL_Cart.createSalesDocument(null, 'Bad');
        ensxtx_UTIL_GetAppSettings.testBody = JSON.serialize(new Map<String, Object>());
        ensxtx_CTRL_Cart.createSalesDocument(null, 'Bad');
        ensxtx_UTIL_GetAppSettings.testBody = JSON.serialize(new Map<String, Object>{'1' => new Map<String, Object>(), '2' => new Map<String, Object>()});
        ensxtx_CTRL_Cart.createSalesDocument(null, 'Bad');
    }

    @isTest
    public static void test_getPricingTiers() 
    {
        MOC_ensxtx_SBO_SFCIMaterialScales_Search mocSFCIMaterialScales = new MOC_ensxtx_SBO_SFCIMaterialScales_Search();
        ensxsdk.EnosixFramework.setMock(ensxtx_SBO_SFCIMaterialScales_Search.class, mocSFCIMaterialScales);

        ensxtx_CTRL_Cart.getPricingTiers('ensxtx_SR_enosixCartPDPAppSettings', null);
        ensxtx_CTRL_Cart.getPricingTiers(null, null);
        mocSFCIMaterialScales.setThrowException(true);
        ensxtx_CTRL_Cart.getPricingTiers(null, null);
    }
    
    @isTest
    public static void test_addItemToList() 
    {
        ensxtx_CTRL_Cart.addItemToList(null, null, null, null);

        Account aObj = ensxtx_TSTU_SFTestObject.createTestAccount();
        aObj.put(ensxtx_UTIL_SFAccount.CustomerFieldName, 'custNo');
        ensxtx_TSTU_SFTestObject.upsertWithRetry(aObj);

        WebStore wsObj = new WebStore();
        wsObj.Name = 'Test Store';
        ensxtx_TSTU_SFTestObject.upsertWithRetry(wsObj);

        Wishlist wlObj = new Wishlist();
        wlObj.Name = 'Test List';
        wlObj.AccountId = aObj.Id;
        wlObj.WebStoreId = wsObj.Id;
        ensxtx_TSTU_SFTestObject.upsertWithRetry(wlObj);
        wlObj = [SELECT Id, OwnerId, WebStoreId, AccountId FROM WishList WHERE Id = :wlObj.Id LIMIT 1];

        ensxtx_CTRL_Cart.addItemToList(wsObj.Id, null, aObj.Id, wlObj.OwnerId);
    }
}