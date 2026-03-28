@isTest
public with sharing class ensxtx_TSTC_CustomerSearch {
    public class MOC_ensxtx_SBO_EnosixCustomer_Search implements ensxsdk.EnosixFramework.SearchSBOSearchMock
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

            ensxtx_SBO_EnosixCustomer_Search.EnosixCustomer_SR sr = new ensxtx_SBO_EnosixCustomer_Search.EnosixCustomer_SR();
            ensxtx_SBO_EnosixCustomer_Search.SEARCHRESULT result = new ensxtx_SBO_EnosixCustomer_Search.SEARCHRESULT();
            result.CustomerNumber = '1234';
            sr.SearchResults.add(result);
            sr.setSuccess(this.success);
            searchContext.baseResult = sr;
			return searchContext;
        }
    }

    public class MOC_ensxtx_SBO_EnosixVendor_Search implements ensxsdk.EnosixFramework.SearchSBOSearchMock
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

            ensxtx_SBO_EnosixVendor_Search.EnosixVendor_SR sr = new ensxtx_SBO_EnosixVendor_Search.EnosixVendor_SR();
            ensxtx_SBO_EnosixVendor_Search.SEARCHRESULT result = new ensxtx_SBO_EnosixVendor_Search.SEARCHRESULT();
            result.Vendor = '1234';
            sr.SearchResults.add(result);
            sr.setSuccess(this.success);
            searchContext.baseResult = sr;
			return searchContext;
        }
    }

    @isTest
    public static void test_searchCustomers()
    {
        MOC_ensxtx_SBO_EnosixCustomer_Search mocSboEnosixCustomerSearch = new MOC_ensxtx_SBO_EnosixCustomer_Search();
        ensxsdk.EnosixFramework.setMock(ensxtx_SBO_EnosixCustomer_Search.class, mocSboEnosixCustomerSearch);
        
        Account acct = ensxtx_TSTU_SFTestObject.createTestAccount();
        acct.put(ensxtx_UTIL_SFAccount.CustomerFieldName, 'Test');
        ensxtx_TSTU_SFTestObject.upsertWithRetry(acct);

        List<Map<String, Object>> mapFieldsList = new List<Map<String, Object>> {
            new Map<String, Object>{
                'sapField' => 'CustomerNumber',
                'sfObjectType' => 'Account',
                'sfField' => ensxtx_UTIL_SFAccount.CustomerFieldName
            }
        };

        Map<String, Id> sfObjectIds = new Map<String, Id>{'account' => acct.Id};

        ensxtx_CTRL_CustomerSearch.searchCustomers(true, null, mapFieldsList, sfObjectIds);
        ensxtx_CTRL_CustomerSearch.searchCustomers(false, null, mapFieldsList, sfObjectIds);
        ensxtx_CTRL_CustomerSearch.searchCustomers(true, null, new List<Map<String, Object>>(), sfObjectIds);
        mocSboEnosixCustomerSearch.setThrowException(true);
        ensxtx_CTRL_CustomerSearch.searchCustomers(false, null, mapFieldsList, sfObjectIds);
    }

    @isTest
    public static void test_searchVendors()
    {
        MOC_ensxtx_SBO_EnosixVendor_Search mocSboEnosixVendorSearch = new MOC_ensxtx_SBO_EnosixVendor_Search();
        ensxsdk.EnosixFramework.setMock(ensxtx_SBO_EnosixVendor_Search.class, mocSboEnosixVendorSearch);
        
        Account acct = ensxtx_TSTU_SFTestObject.createTestAccount();
        acct.put(ensxtx_UTIL_SFAccount.CustomerFieldName, 'Test');
        ensxtx_TSTU_SFTestObject.upsertWithRetry(acct);

        List<Map<String, Object>> mapFieldsList = new List<Map<String, Object>> {
            new Map<String, Object>{
                'sapField' => 'CustomerNumber',
                'sfObjectType' => 'Account',
                'sfField' => ensxtx_UTIL_SFAccount.CustomerFieldName
            }
        };

        Map<String, Id> sfObjectIds = new Map<String, Id>{'account' => acct.Id};

        ensxtx_CTRL_CustomerSearch.searchVendors(true, null, mapFieldsList, sfObjectIds);
        ensxtx_CTRL_CustomerSearch.searchVendors(true, null, new List<Map<String, Object>>(), sfObjectIds);
        mocSboEnosixVendorSearch.setThrowException(true);
        ensxtx_CTRL_CustomerSearch.searchVendors(false, null, mapFieldsList, sfObjectIds);
    }
}