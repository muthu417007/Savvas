@isTest
public class ensxtx_TSTC_GeneratePDF 
{
    public class MOC_ensxtx_SBO_SFCISalesDocOutput_Search implements ensxsdk.EnosixFramework.SearchSBOSearchMock
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

        private boolean returnRecord = true;

        public void setReturnRecord(boolean returnRecord)
        {
            this.returnRecord = returnRecord;
        }

		public ensxsdk.EnosixFramework.SearchContext executeSearch(ensxsdk.EnosixFramework.SearchContext searchContext) 
		{
            ensxtx_SBO_SFCISalesDocOutput_Search.SFCISalesDocOutput_SR search_result = new ensxtx_SBO_SFCISalesDocOutput_Search.SFCISalesDocOutput_SR();

            if (throwException)
            {
                throw new CalloutException();
            }

			ensxtx_SBO_SFCISalesDocOutput_Search.SEARCHRESULT result = new ensxtx_SBO_SFCISalesDocOutput_Search.SEARCHRESULT();			
			result.SalesDocument = '111';
            result.ConditionType = 'ZZZ';
            result.ConditionTypeDescription = 'ZZZ';
            result.Language = 'EN';
            result.PDF_B64STR = '00110101';

			search_result.setSuccess(this.success);
			searchContext.baseResult = search_result;
			return searchContext;
        }
	}

    @isTest
    public static void test_getDocumentsList()
    {
        MOC_ensxtx_SBO_SFCISalesDocOutput_Search mockSboSFCISalesDocOutputSearch = new MOC_ensxtx_SBO_SFCISalesDocOutput_Search();
        ensxsdk.EnosixFramework.setMock(ensxtx_SBO_SFCISalesDocOutput_Search.class, mockSboSFCISalesDocOutputSearch);

        Test.startTest();
        ensxtx_UTIL_Aura.Response response = ensxtx_CTRL_GeneratePDF.getDocumentsList('222', '', 'V1');
        mockSboSFCISalesDocOutputSearch.setThrowException(true);
        response = ensxtx_CTRL_GeneratePDF.getDocumentsList('222', 'ZZZ', 'V1');
        Test.stopTest();
    }
}