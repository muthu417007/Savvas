@RestResource(urlMapping='/ensxtx_ENSX_CPQ_QuoteCalculationServV2/*')
global with sharing class ensxtx_ENSX_CPQ_QuoteCalculationServV2 {
    private static final ensxsdk.Logger logger = new ensxsdk.Logger(ensxtx_ENSX_CPQ_QuoteCalculationServV2.class);

    @HttpPost
    global static String doPost(String serializedCPQQuote, String serializedCPQQuoteLineList, Boolean isSimulate)
    {
        logger.enterAura('doPost', new Map<String, Object> {
            'serializedCPQQuote' => serializedCPQQuote,
            'serializedCPQQuoteLineList' => serializedCPQQuoteLineList,
            'isSimulate' => isSimulate
        });

        ensxtx_UTIL_CPQ_QuotePricingV2.SAPSimulationResults simresults = new ensxtx_UTIL_CPQ_QuotePricingV2.SAPSimulationResults();

        try
        {
            System.debug('/ensxtx_ENSX_CPQ_QuoteCalculationServV2/doPost');
            SBQQ__Quote__c cpqQuote = (SBQQ__Quote__c)JSON.deserialize(serializedCPQQuote,SBQQ__Quote__c.class);
            List<SBQQ__QuoteLine__c> cpqQuoteLineList = (List<SBQQ__QuoteLine__c>)JSON.deserialize(serializedCPQQuoteLineList,List<SBQQ__QuoteLine__c>.class);

            simresults = ensxtx_UTIL_CPQ_QuotePricingV2.prepareQuoteAndSimulate(cpqQuote, cpqQuoteLineList);
            System.debug('/ensxtx_ENSX_CPQ_QuoteCalculationServV2/doPost');
        }
        catch (Exception ex) {
            logger.log(LoggingLevel.ERROR, 'There was an exception thrown when attempting to doPost ', ex);
            simresults.Success = false;
            simresults.Message = ex.getMessage();
        }
        finally
        {
            logger.exit();
        }

        ensxtx_UTIL_Aura.Response response = ensxtx_UTIL_Aura.createResponse(simresults);
        return JSON.serialize(response);
    }
}