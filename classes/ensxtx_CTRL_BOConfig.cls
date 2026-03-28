public class ensxtx_CTRL_BOConfig
{
    private static final ensxsdk.Logger logger = new ensxsdk.Logger(ensxtx_CTRL_BOConfig.class);

    @AuraEnabled
    public static ensxtx_UTIL_Aura.Response getBOConfigs()
    {
        logger.enterAura('getBOConfigs', new Map<String, Object>());

        List<ensxtx_SBO_EnosixBOConfigValue_Search.SEARCHRESULT> searchResults =
            new List<ensxtx_SBO_EnosixBOConfigValue_Search.SEARCHRESULT>();
        Object responsePagingOptions = null;

        try
        {
            ensxtx_SBO_EnosixBOConfigValue_Search sbo = new ensxtx_SBO_EnosixBOConfigValue_Search();
            ensxtx_SBO_EnosixBOConfigValue_Search.EnosixBOConfigValue_SC searchContext =
                new ensxtx_SBO_EnosixBOConfigValue_Search.EnosixBOConfigValue_SC();
            Map<String, Object> pagingOptions = new Map<String, Object>{
                'pageSize' => 9999,
                'pageNumber' => 1
            };
            ensxtx_UTIL_Aura.setSearchContextPagingOptions(searchContext, pagingOptions);
            sbo.search(searchContext);
            ensxtx_UTIL_PageMessages.addFrameworkMessages(searchContext.getMessages());
            searchResults = searchContext.result.getResults();
            responsePagingOptions = searchContext.pagingOptions;
        }
        catch (Exception ex)
        {
            ensxtx_UTIL_PageMessages.addExceptionMessage(ex);
        }

        return ensxtx_UTIL_Aura.createResponse(searchResults, responsePagingOptions);
    }
}