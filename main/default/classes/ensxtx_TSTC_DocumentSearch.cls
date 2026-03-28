@isTest
public class ensxtx_TSTC_DocumentSearch
{
    public class MOC_ensxtx_SBO_SFCISalesDocument_Search implements ensxsdk.EnosixFramework.SearchSBOSearchMock
    {
        public Boolean success = true;

        public void setSuccess(Boolean successfull)
        {
            this.success = successfull;
        }

        private boolean throwException = false;

        public void setThrowException(boolean throwException)
        {
            this.throwException = throwException;
        }

        public ensxsdk.EnosixFramework.SearchContext executeSearch(ensxsdk.EnosixFramework.SearchContext searchContext)
        {
            if (throwException) throw new CalloutException();

            ensxtx_SBO_SFCISalesDocument_Search.SFCISalesDocument_SR sr = new ensxtx_SBO_SFCISalesDocument_Search.SFCISalesDocument_SR();
            ensxtx_SBO_SFCISalesDocument_Search.SEARCHRESULT result = new ensxtx_SBO_SFCISalesDocument_Search.SEARCHRESULT();
            result.SalesDocument = '1234';
            sr.SearchResults.add(result);
            sr.setSuccess(this.success);
            searchContext.baseResult = sr;
			return searchContext;
        }
    }

    public class MOC_ensxtx_SBO_SFCIInvoice_Search implements ensxsdk.EnosixFramework.SearchSBOSearchMock
    {
        public Boolean success = true;

        public void setSuccess(Boolean successfull)
        {
            this.success = successfull;
        }

        private boolean throwException = false;

        public void setThrowException(boolean throwException)
        {
            this.throwException = throwException;
        }

        public ensxsdk.EnosixFramework.SearchContext executeSearch(ensxsdk.EnosixFramework.SearchContext searchContext)
        {
            if (throwException) throw new CalloutException();

            ensxtx_SBO_SFCIInvoice_Search.SFCIInvoice_SR sr = new ensxtx_SBO_SFCIInvoice_Search.SFCIInvoice_SR();
            ensxtx_SBO_SFCIInvoice_Search.SEARCHRESULT result = new ensxtx_SBO_SFCIInvoice_Search.SEARCHRESULT();
            result.BillingDocument = '1234';
            sr.SearchResults.add(result);
            sr.setSuccess(this.success);
            searchContext.baseResult = sr;
			return searchContext;
        }
    }

    public class MOC_ensxtx_SBO_SFCIDelivery_Search implements ensxsdk.EnosixFramework.SearchSBOSearchMock
    {
        public Boolean success = true;

        public void setSuccess(Boolean successfull)
        {
            this.success = successfull;
        }

        private boolean throwException = false;

        public void setThrowException(boolean throwException)
        {
            this.throwException = throwException;
        }

        public ensxsdk.EnosixFramework.SearchContext executeSearch(ensxsdk.EnosixFramework.SearchContext searchContext)
        {
            if (throwException) throw new CalloutException();

            ensxtx_SBO_SFCIDelivery_Search.SFCIDelivery_SR sr = new ensxtx_SBO_SFCIDelivery_Search.SFCIDelivery_SR();
            ensxtx_SBO_SFCIDelivery_Search.SEARCHRESULT result = new ensxtx_SBO_SFCIDelivery_Search.SEARCHRESULT();
            result.Delivery = '1234';
            sr.SearchResults.add(result);
            sr.setSuccess(this.success);
            searchContext.baseResult = sr;
			return searchContext;
        }
    }

    @isTest
    public static void test_getCustomerNumber()
    {
        Account acct = ensxtx_TSTU_SFTestObject.createTestAccount();
        ensxtx_TSTU_SFTestObject.upsertWithRetry(acct);
        ensxtx_UTIL_Aura.Response response = ensxtx_CTRL_DocumentSearch.getCustomerNumber(acct.Id);
    }

    @isTest
    public static void test_documentSearch()
    {
        String docType = 'SalesDoc';
        Map<String, Object> searchParams = new Map<String, Object>{
            'SoldToParty' => '1234'
        };
        List<String> docTypes = new List<String>{'OR'};
        Map<String, Object> pagingOptions = new Map<String, Object>{
            'pageSize' => 10,
            'pageNumber' => 1
        };
        Map<String, Object> sortField = new Map<String, Object>{
            'precedence' => 1,
            'sortField' => 'ERDAT',
            'direction' => 'Descending'
        };
        List<Map<String, Object>> sortFields = new List<Map<String, Object>>{sortField};

        ensxtx_UTIL_Aura.Response response = ensxtx_CTRL_DocumentSearch.search(docType, searchParams, docTypes, pagingOptions, sortFields);

        response = ensxtx_CTRL_DocumentSearch.search('Invoice', searchParams, docTypes, new Map<String, Object>(), sortFields);
        response = ensxtx_CTRL_DocumentSearch.search('Delivery', searchParams, docTypes, new Map<String, Object>(), sortFields);
        response = ensxtx_CTRL_DocumentSearch.search(null, searchParams, docTypes, new Map<String, Object>(), sortFields);

        ensxsdk.EnosixFramework.setMock(ensxtx_SBO_SFCISalesDocument_Search.class, new MOC_ensxtx_SBO_SFCISalesDocument_Search());
        ensxsdk.EnosixFramework.setMock(ensxtx_SBO_SFCIInvoice_Search.class, new MOC_ensxtx_SBO_SFCIInvoice_Search());
        ensxsdk.EnosixFramework.setMock(ensxtx_SBO_SFCIDelivery_Search.class, new MOC_ensxtx_SBO_SFCIDelivery_Search());

        response = ensxtx_CTRL_DocumentSearch.search('SalesDoc', searchParams, docTypes, new Map<String, Object>(), sortFields);
        response = ensxtx_CTRL_DocumentSearch.search('Invoice', searchParams, docTypes, new Map<String, Object>(), sortFields);
        response = ensxtx_CTRL_DocumentSearch.search('Delivery', searchParams, docTypes, new Map<String, Object>(), sortFields);
    }
}