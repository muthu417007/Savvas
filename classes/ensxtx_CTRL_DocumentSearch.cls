public class ensxtx_CTRL_DocumentSearch
{
    private static final ensxsdk.Logger logger = new ensxsdk.Logger(ensxtx_CTRL_DocumentSearch.class);

    @AuraEnabled(cacheable=false)
    public static ensxtx_UTIL_Aura.Response getCustomerNumber(Id recordId) {

        logger.enterAura('getCustomerNumber', new Map<String, Object>{
            'recordId' => recordId
        });

        String customerNumber;

        try
        {
            Account acct = ensxtx_UTIL_SFAccount.getAccountById(recordId);
            if (acct != null) customerNumber = ensxtx_UTIL_SFAccount.getCustomerNumberFromAccount(acct);
        }
        catch(Exception ex)
        {
            ensxtx_UTIL_PageMessages.addExceptionMessage(ex);
        }

        return ensxtx_UTIL_Aura.createResponse(customerNumber);
    }

    @AuraEnabled(cacheable=false)
    public static ensxtx_UTIL_Aura.Response search(String docType, Map<String, Object> searchParams, List<String> docTypes,
        Map<String, Object> pagingOptions, List<Map<String, Object>> sortFields)
    {
        logger.enterAura('searchDocuments', new Map<String, Object>{
            'docType' => docType,
            'searchParams' => searchParams,
            'docTypes' => docTypes,
            'paginOptions' => pagingOptions,
            'sortFields' => sortFields
        });

        switch on docType {
            when 'SalesDoc' {
                return searchSalesDocs(searchParams, docTypes, pagingOptions, sortFields);
            }
            when 'Invoice' {
                return searchInvoices(searchParams, docTypes, pagingOptions, sortFields);
            }
            when 'Delivery' {
                return searchDeliveries(searchParams, docTypes, pagingOptions, sortFields);
            }
            when else {
                ensxtx_UTIL_PageMessages.addMessage(ensxtx_UTIL_PageMessages.ERROR,
                    'DocType ' + docType + ' is not recognizable. Please update the app settings');
                return ensxtx_UTIL_Aura.createResponse(null);
            }
        }
    }

    private static ensxtx_UTIL_Aura.Response searchSalesDocs(Map<String, Object> searchParams, List<String> docTypes,
        Map<String, Object> pagingOptions, List<Map<String, Object>> sortFields)
    {
        ensxtx_SBO_SFCISalesDocument_Search sbo = new ensxtx_SBO_SFCISalesDocument_Search();
        List<ensxtx_SBO_SFCISalesDocument_Search.SEARCHRESULT> searchResults = new List<ensxtx_SBO_SFCISalesDocument_Search.SEARCHRESULT>();
        Object responsePagingOptions = null;

        try
        {
            ensxtx_SBO_SFCISalesDocument_Search.SFCISalesDocument_SC searchContext = new ensxtx_SBO_SFCISalesDocument_Search.SFCISalesDocument_SC();

            ensxtx_UTIL_Aura.setSearchContextSearchParams(searchContext.SEARCHPARAMS, searchParams);
            ensxtx_UTIL_Aura.setSearchContextPagingOptions(searchContext, pagingOptions, sortFields);

            if (docTypes != null) {
                for (String docType : docTypes) {
                    ensxtx_SBO_SFCISalesDocument_Search.SALESDOCTYPE newDocType = new ensxtx_SBO_SFCISalesDocument_Search.SALESDOCTYPE();
                    newDocType.SalesDocumentType = docType;
                    searchContext.SALESDOCTYPE.add(newDocType);
                }
            }

            sbo.search(searchContext);
            searchResults = searchContext.result.getResults();
            responsePagingOptions = searchContext.pagingOptions;
            ensxtx_UTIL_PageMessages.addFrameworkMessages(searchContext.getMessages());
        }
        catch(Exception ex)
        {
            ensxtx_UTIL_PageMessages.addExceptionMessage(ex);
        }

        return ensxtx_UTIL_Aura.createResponse(searchResults, responsePagingOptions);
    }

    private static ensxtx_UTIL_Aura.Response searchInvoices(Map<String, Object> searchParams, List<String> docTypes,
        Map<String, Object> pagingOptions, List<Map<String, Object>> sortFields)
    {
        ensxtx_SBO_SFCIInvoice_Search sbo = new ensxtx_SBO_SFCIInvoice_Search();
        List<ensxtx_SBO_SFCIInvoice_Search.SEARCHRESULT> searchResults = new List<ensxtx_SBO_SFCIInvoice_Search.SEARCHRESULT>();
        Object responsePagingOptions = null;

        try
        {
            ensxtx_SBO_SFCIInvoice_Search.SFCIInvoice_SC searchContext = new ensxtx_SBO_SFCIInvoice_Search.SFCIInvoice_SC();

            ensxtx_UTIL_Aura.setSearchContextSearchParams(searchContext.SEARCHPARAMS, searchParams);
            ensxtx_UTIL_Aura.setSearchContextPagingOptions(searchContext, pagingOptions, sortFields);

            if (docTypes != null) {
                for (String docType : docTypes) {
                    ensxtx_SBO_SFCIInvoice_Search.BILLINGTYPE newDocType = new ensxtx_SBO_SFCIInvoice_Search.BILLINGTYPE();
                    newDocType.BillingType = docType;
                    searchContext.BILLINGTYPE.add(newDocType);
                }
            }

            sbo.search(searchContext);
            searchResults = searchContext.result.getResults();
            responsePagingOptions = searchContext.pagingOptions;
            ensxtx_UTIL_PageMessages.addFrameworkMessages(searchContext.getMessages());
        }
        catch(Exception ex)
        {
            ensxtx_UTIL_PageMessages.addExceptionMessage(ex);
        }

        return ensxtx_UTIL_Aura.createResponse(searchResults, responsePagingOptions);
    }

    private static ensxtx_UTIL_Aura.Response searchDeliveries(Map<String, Object> searchParams, List<String> docTypes,
        Map<String, Object> pagingOptions, List<Map<String, Object>> sortFields)
    {
        ensxtx_SBO_SFCIDelivery_Search sbo = new ensxtx_SBO_SFCIDelivery_Search();
        List<ensxtx_SBO_SFCIDelivery_Search.SEARCHRESULT> searchResults = new List<ensxtx_SBO_SFCIDelivery_Search.SEARCHRESULT>();
        Object responsePagingOptions = null;

        try
        {
            ensxtx_SBO_SFCIDelivery_Search.SFCIDelivery_SC searchContext = new ensxtx_SBO_SFCIDelivery_Search.SFCIDelivery_SC();

            ensxtx_UTIL_Aura.setSearchContextSearchParams(searchContext.SEARCHPARAMS, searchParams);
            ensxtx_UTIL_Aura.setSearchContextPagingOptions(searchContext, pagingOptions, sortFields);

            if (docTypes != null) {
                for (String docType : docTypes) {
                    ensxtx_SBO_SFCIDelivery_Search.DELIVERYTYPE newDocType = new ensxtx_SBO_SFCIDelivery_Search.DELIVERYTYPE();
                    newDocType.DeliveryType = docType;
                    searchContext.DELIVERYTYPE.add(newDocType);
                }
            }

            sbo.search(searchContext);
            searchResults = searchContext.result.getResults();
            responsePagingOptions = searchContext.pagingOptions;
            ensxtx_UTIL_PageMessages.addFrameworkMessages(searchContext.getMessages());
        }
        catch(Exception ex)
        {
            ensxtx_UTIL_PageMessages.addExceptionMessage(ex);
        }

        return ensxtx_UTIL_Aura.createResponse(searchResults, responsePagingOptions);
    }
}