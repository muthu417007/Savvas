@isTest
public class ensxtx_TSTC_SalesDocDetail
{
    public class MOC_SFCISalesDocument_Detail implements ensxsdk.EnosixFramework.DetailSBOGetMock
    {
        public boolean success = true;

        public void setSuccess(boolean successful)
        {
            this.success = successful;
        }

        private boolean throwException = false;

        public void setThrowException(boolean throwException)
        {
            this.throwException = throwException;
        }

        public ensxsdk.EnosixFramework.DetailObject executeGetDetail(object key) { return null; }
    }

    public class MOC_SFCIInvoice_Detail implements ensxsdk.EnosixFramework.DetailSBOGetMock
    {
        public boolean success = true;

        public void setSuccess(boolean successful)
        {
            this.success = successful;
        }

        private boolean throwException = false;

        public void setThrowException(boolean throwException)
        {
            this.throwException = throwException;
        }

        public ensxsdk.EnosixFramework.DetailObject executeGetDetail(object key) { return null; }
    }

    public class MOC_SFCIDelivery_Detail implements ensxsdk.EnosixFramework.DetailSBOGetMock
    {
        public boolean success = true;

        public void setSuccess(boolean successful)
        {
            this.success = successful;
        }

        private boolean throwException = false;

        public void setThrowException(boolean throwException)
        {
            this.throwException = throwException;
        }

        public ensxsdk.EnosixFramework.DetailObject executeGetDetail(object key) { return null; }
    }

    public class MOC_ensxtx_SBO_SFCISalesDocFlow_Search implements ensxsdk.EnosixFramework.SearchSBOSearchMock
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

            ensxtx_SBO_SFCISalesDocFlow_Search.SFCISalesDocFlow_SR sr = new ensxtx_SBO_SFCISalesDocFlow_Search.SFCISalesDocFlow_SR();
            ensxtx_SBO_SFCISalesDocFlow_Search.SEARCHRESULT result = new ensxtx_SBO_SFCISalesDocFlow_Search.SEARCHRESULT();
            result.SalesDocument = '1234';
            sr.SearchResults.add(result);
            sr.setSuccess(this.success);
            searchContext.baseResult = sr;
			return searchContext;
        }
    }

    @isTest
    public static void test_getDetail()
    {
        MOC_SFCISalesDocument_Detail moc = new MOC_SFCISalesDocument_Detail();
        ensxsdk.EnosixFramework.setMock(ensxtx_SBO_SFCISalesDocument_Detail.class, moc);
        ensxtx_CTRL_SalesDocDetail.getDetail('TEST');
        moc.setThrowException(true);
        ensxtx_CTRL_SalesDocDetail.getDetail('TEST');
    }

    @isTest
    public static void test_getInvoice()
    {
        MOC_SFCIInvoice_Detail moc = new MOC_SFCIInvoice_Detail();
        ensxsdk.EnosixFramework.setMock(ensxtx_SBO_SFCIInvoice_Detail.class, moc);
        ensxtx_CTRL_SalesDocDetail.getInvoice('TEST');
        moc.setThrowException(true);
        ensxtx_CTRL_SalesDocDetail.getInvoice('TEST');
    }

    @isTest
    public static void test_getDelivery()
    {
        MOC_SFCIDelivery_Detail moc = new MOC_SFCIDelivery_Detail();
        ensxsdk.EnosixFramework.setMock(ensxtx_SBO_SFCIDelivery_Detail.class, moc);
        ensxtx_CTRL_SalesDocDetail.getDelivery('TEST');
        moc.setThrowException(true);
        ensxtx_CTRL_SalesDocDetail.getDelivery('TEST');
    }

    @isTest
    public static void test_getSalesDocFlow()
    {
        MOC_ensxtx_SBO_SFCISalesDocFlow_Search moc = new MOC_ensxtx_SBO_SFCISalesDocFlow_Search();
        ensxsdk.EnosixFramework.setMock(ensxtx_SBO_SFCISalesDocFlow_Search.class, moc);
        ensxtx_CTRL_SalesDocDetail.getSalesDocFlow('1234', '1');
        moc.setThrowException(true);
        ensxtx_CTRL_SalesDocDetail.getSalesDocFlow('1234', '1');
    }

}