public class ensxtx_CTRL_GeneratePDF 
{
    private static final ensxsdk.Logger logger = new ensxsdk.Logger(ensxtx_CTRL_GeneratePDF.class);

    @AuraEnabled
    public static ensxtx_UTIL_Aura.Response getDocumentsList(String docNum, String messageType, String outputApplication)
    {
        Object responseData = null;
        Object responsePagingOptions = null;

        logger.enterAura('getDocumentsList', new Map<String, Object> {
            'docNum' => docNum,
            'messageType' => messageType,
            'outputApplication' => outputApplication
        });

        try
        {
            ensxtx_SBO_SFCISalesDocOutput_Search searchSBO = new ensxtx_SBO_SFCISalesDocOutput_Search();
            ensxtx_SBO_SFCISalesDocOutput_Search.SFCISalesDocOutput_SC searchContext = ensxtx_CTRL_GeneratePDF.getDocSearchContext(docNum, messageType, outputApplication);
            searchContext = searchSBO.search(searchContext);
            responseData = searchContext.result.getResults();
            ensxtx_UTIL_PageMessages.addFrameworkMessages(searchContext.getMessages());
            responsePagingOptions = searchContext.pagingOptions;
        }
        catch (Exception ex)
        {
            ensxtx_UTIL_PageMessages.addExceptionMessage(ex);
        }
        finally
        {
            logger.exit();
        }

        return ensxtx_UTIL_Aura.createResponse(responseData);
    }

    private static ensxtx_SBO_SFCISalesDocOutput_Search.SFCISalesDocOutput_SC getDocSearchContext(String docNum, String messageType, String outputApplication)
    {
        ensxtx_SBO_SFCISalesDocOutput_Search.SFCISalesDocOutput_SC searchContext = new ensxtx_SBO_SFCISalesDocOutput_Search.SFCISalesDocOutput_SC();
        searchContext.SEARCHPARAMS.SalesDocument = docNum;
        // Default to 'V1' if empty
        searchContext.SEARCHPARAMS.OutputApplication = String.isNotEmpty(outputApplication) ? outputApplication : 'V1';
        if (String.isNotBlank(messageType))
        {
            ensxtx_SBO_SFCISalesDocOutput_Search.OUTPUT_TYPE sboOutputType = new ensxtx_SBO_SFCISalesDocOutput_Search.OUTPUT_TYPE();
            sboOutputType.ConditionType = messageType;
            sboOutputType.X_GetPDF = true;
            searchContext.OUTPUT_TYPE.add(sboOutputType);
        }
        return searchContext;
    }
}