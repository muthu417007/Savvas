public with sharing class ensxtx_CTRL_OverrideAddress {
    @AuraEnabled(cacheable=true)
    public static ensxtx_UTIL_Aura.Response loadCountries()
    {
        ensxtx_RFC_SD_GET_COUNTRIES.RESULT result;
        try
        {
            ensxtx_RFC_SD_GET_COUNTRIES rfc = new ensxtx_RFC_SD_GET_COUNTRIES();
            result = rfc.execute();
        }
        catch (Exception ex)
        {
            ensxtx_UTIL_PageMessages.addExceptionMessage(ex);
            return ensxtx_UTIL_Aura.createResponse(null);
        }

        return ensxtx_UTIL_Aura.createResponse(result);
    }
}