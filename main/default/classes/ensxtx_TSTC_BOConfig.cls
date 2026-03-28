@isTest
public class ensxtx_TSTC_BOConfig
{
    public class MOC_ensxtx_SBO_EnosixBOConfigValue_Search implements ensxsdk.EnosixFramework.SearchSBOSearchMock
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

            ensxtx_SBO_EnosixBOConfigValue_Search.EnosixBOConfigValue_SR sr = new ensxtx_SBO_EnosixBOConfigValue_Search.EnosixBOConfigValue_SR();
            ensxtx_SBO_EnosixBOConfigValue_Search.SEARCHRESULT result = new ensxtx_SBO_EnosixBOConfigValue_Search.SEARCHRESULT();
            result.BusinessObject = 'Test';
            sr.SearchResults.add(result);
            sr.setSuccess(this.success);
            searchContext.baseResult = sr;
			return searchContext;
        }
    }

    @isTest
    public static void test_getBOConfigs()
    {
        MOC_ensxtx_SBO_EnosixBOConfigValue_Search mocSBOSearch = new MOC_ensxtx_SBO_EnosixBOConfigValue_Search();
        ensxsdk.EnosixFramework.setMock(ensxtx_SBO_EnosixBOConfigValue_Search.class, mocSBOSearch);

        ensxtx_UTIL_Aura.Response response = ensxtx_CTRL_BOConfig.getBOConfigs();
        mocSBOSearch.setThrowException(true);

        response = ensxtx_CTRL_BOConfig.getBOConfigs();
    }
}