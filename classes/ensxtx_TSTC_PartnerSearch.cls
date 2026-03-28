@isTest
public with sharing class ensxtx_TSTC_PartnerSearch {
    public class MOC_ensxtx_SBO_EnosixPartner_Search implements ensxsdk.EnosixFramework.SearchSBOSearchMock
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

            ensxtx_SBO_EnosixPartner_Search.EnosixPartner_SR sr = new ensxtx_SBO_EnosixPartner_Search.EnosixPartner_SR();
            ensxtx_SBO_EnosixPartner_Search.SEARCHRESULT result = new ensxtx_SBO_EnosixPartner_Search.SEARCHRESULT();
            result.PartnerNumber = '1234';
            result.PartnerName = 'Bob';
            result.Street = 'Angel Grove St';
            result.City = 'New York';
            result.PostalCode = '4566';
            result.Region = 'New York';
            result.Country = 'USA';
            sr.SearchResults.add(result);
            sr.setSuccess(this.success);
            searchContext.baseResult = sr;
			return searchContext;
        }
    }

    @isTest
    public static void test_searchPartners()
    {
        MOC_ensxtx_SBO_EnosixPartner_Search mocSboEnosixPartnerSearch = new MOC_ensxtx_SBO_EnosixPartner_Search();
        ensxsdk.EnosixFramework.setMock(ensxtx_SBO_EnosixPartner_Search.class, mocSboEnosixPartnerSearch);
        
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

        ensxtx_CTRL_PartnerSearch.searchPartners('SH', null, null, null, mapFieldsList, sfObjectIds);
        ensxtx_CTRL_PartnerSearch.searchPartners('SH', null, null, null, new List<Map<String, Object>>(), sfObjectIds);
        mocSboEnosixPartnerSearch.setThrowException(true);
        ensxtx_CTRL_PartnerSearch.searchPartners('SH', null, null, null, mapFieldsList, sfObjectIds);
    }
}