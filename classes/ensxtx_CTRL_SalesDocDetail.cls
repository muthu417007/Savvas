public with sharing class ensxtx_CTRL_SalesDocDetail {
    @AuraEnabled(cacheable=false)
    public static ensxtx_UTIL_Aura.Response getDetail (string documentNumber) {
        new ensxsdk.Logger(null);
        ensxtx_SBO_SFCISalesDocument_Detail.SFCISalesDocument detail = new ensxtx_SBO_SFCISalesDocument_Detail().getDetail(documentNumber);
        return ensxtx_UTIL_Aura.createResponse(detail);
    }

    @AuraEnabled(cacheable=false)
    public static ensxtx_UTIL_Aura.Response getInvoice (string documentNumber) {
        new ensxsdk.Logger(null);
        ensxtx_SBO_SFCIInvoice_Detail.SFCIInvoice invoice = new ensxtx_SBO_SFCIInvoice_Detail().getDetail(documentNumber);
        return ensxtx_UTIL_Aura.createResponse(invoice);
    }

    @AuraEnabled(cacheable=false)
    public static ensxtx_UTIL_Aura.Response getDelivery (string documentNumber) {
        new ensxsdk.Logger(null);
        ensxtx_SBO_SFCIDelivery_Detail.SFCIDelivery delivery = new ensxtx_SBO_SFCIDelivery_Detail().getDetail(documentNumber);
        return ensxtx_UTIL_Aura.createResponse(delivery);
    }

    @AuraEnabled(cacheable=false)
    public static ensxtx_UTIL_Aura.Response getSalesDocFlow(string documentNumber, string itemNumber)
    {
        new ensxsdk.Logger(null);

        List<ensxtx_SBO_SFCISalesDocFlow_Search.SEARCHRESULT> searchResults = new List<ensxtx_SBO_SFCISalesDocFlow_Search.SEARCHRESULT>();
        Object responsePagingOptions = null;

        try
        {
            ensxtx_SBO_SFCISalesDocFlow_Search searchSBO = new ensxtx_SBO_SFCISalesDocFlow_Search();
            ensxtx_SBO_SFCISalesDocFlow_Search.SFCISalesDocFlow_SC searchContext = new ensxtx_SBO_SFCISalesDocFlow_Search.SFCISalesDocFlow_SC();
            searchContext.SEARCHPARAMS.SalesDocument = documentNumber;
            searchContext.SEARCHPARAMS.ItemNumber = itemNumber;

            searchSBO.search(searchContext);
            searchResults = searchContext.result.getResults();
            responsePagingOptions = searchContext.pagingOptions;
            ensxtx_UTIL_PageMessages.addFrameworkMessages(searchContext.getMessages());
        }
        catch (Exception ex)
        {
            ensxtx_UTIL_PageMessages.addExceptionMessage(ex);
        }

        return ensxtx_UTIL_Aura.createResponse(searchResults, responsePagingOptions);
    }
    
    
  
}