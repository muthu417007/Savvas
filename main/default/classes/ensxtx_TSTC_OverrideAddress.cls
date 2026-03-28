@isTest
public with sharing class ensxtx_TSTC_OverrideAddress {
    public class MOC_ensxtx_RFC_SD_GET_COUNTRIES implements ensxsdk.EnosixFramework.RFCMock
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

        public ensxsdk.EnosixFramework.FunctionObject executeFunction()
        {
            if (throwException) throw new CalloutException();
            ensxtx_RFC_SD_GET_COUNTRIES.RESULT result = new ensxtx_RFC_SD_GET_COUNTRIES.RESULT();
            result.setSuccess(this.success);
            return result;
        }
    }

    @isTest
    public static void test_loadCountries()
    {
        MOC_ensxtx_RFC_SD_GET_COUNTRIES mocRfc = new MOC_ensxtx_RFC_SD_GET_COUNTRIES();
        ensxsdk.EnosixFramework.setMock(ensxtx_RFC_SD_GET_COUNTRIES.class, mocRfc);

        ensxtx_UTIL_Aura.Response response = ensxtx_CTRL_OverrideAddress.loadCountries();

        mocRfc.setThrowException(true);
        response = ensxtx_CTRL_OverrideAddress.loadCountries();
    }
}