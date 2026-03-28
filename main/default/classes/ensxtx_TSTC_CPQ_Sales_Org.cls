@isTest
public with sharing class ensxtx_TSTC_CPQ_Sales_Org
{
    private static final string TEST_JSON_CPQ =
        '{"DefaultCustomerNumber":"TEST",' +
        '"GenericCustomerSalesOrgs":["1000","2000"],' + 
        '"SalesOrgList": ["1000"],' +
        '"DistributionChannelList": ["01"],' +
        '"DivisionList": ["01"]}';

    private static final string TEST_JSON_VC =
        '{}';

    @isTest
    public static void test_getInfo() {
        ensxtx_UTIL_AppSettings.settingsMap.put(ensxtx_UTIL_AppSettings.Prefix + ensxtx_UTIL_AppSettings.CPQV2 + ensxtx_UTIL_AppSettings.Suffix, (Map<String, Object>)JSON.deserializeUntyped(TEST_JSON_CPQ));
        ensxtx_UTIL_AppSettings.settingsMap.put(ensxtx_UTIL_AppSettings.Prefix + ensxtx_UTIL_AppSettings.VC + ensxtx_UTIL_AppSettings.Suffix, (Map<String, Object>)JSON.deserializeUntyped(TEST_JSON_VC));
        
        Test.startTest();
        SBQQ__Quote__c quote = ensxtx_TSTU_SFCPQQuote.createTestQuote();
        ensxtx_TSTU_SFTestObject.upsertWithRetry(quote);
        ensxtx_UTIL_Aura.Response resp = ensxtx_CTRL_CPQ_Sales_Org.getInfo(quote.Id);
        quote.ensxtx_Sales_Organization__c = 'SO';
        quote.ensxtx_Distribution_Channel__c = 'DC';
        quote.ensxtx_Division__c = 'D';
        ensxtx_TSTU_SFTestObject.upsertWithRetry(quote);
        resp = ensxtx_CTRL_CPQ_Sales_Org.getInfo(quote.Id);
        Test.stopTest();
    }

    @isTest
    public static void test_getSalesAreaList() {
        ensxtx_UTIL_AppSettings.settingsMap.put(ensxtx_UTIL_AppSettings.Prefix + ensxtx_UTIL_AppSettings.CPQV2 + ensxtx_UTIL_AppSettings.Suffix, (Map<String, Object>)JSON.deserializeUntyped(TEST_JSON_CPQ));
        ensxtx_UTIL_AppSettings.settingsMap.put(ensxtx_UTIL_AppSettings.Prefix + ensxtx_UTIL_AppSettings.VC + ensxtx_UTIL_AppSettings.Suffix, (Map<String, Object>)JSON.deserializeUntyped(TEST_JSON_VC));
        
        Test.startTest();
        Mockensxtx_SBO_EnosixCustomer_Detail cdmock = new Mockensxtx_SBO_EnosixCustomer_Detail();
        ensxsdk.EnosixFramework.setMock(ensxtx_SBO_EnosixCustomer_Detail.class, cdmock);
        cdmock.setSuccess(false);
        ensxtx_UTIL_Aura.Response resp = ensxtx_CTRL_CPQ_Sales_Org.getSalesAreaList(null);
        resp = ensxtx_CTRL_CPQ_Sales_Org.getSalesAreaList('TEST');
        cdmock.setSuccess(true);
        cdmock.setReturnSales(false);
        resp = ensxtx_CTRL_CPQ_Sales_Org.getSalesAreaList('TEST');
        cdmock.setReturnSales(true);
        resp = ensxtx_CTRL_CPQ_Sales_Org.getSalesAreaList('TEST');
        cdmock.setThrowException(true);
        resp = ensxtx_CTRL_CPQ_Sales_Org.getSalesAreaList('TEST');
        Test.stopTest();
    }

    @isTest
    public static void test_updateInfo() {
        ensxtx_UTIL_AppSettings.settingsMap.put(ensxtx_UTIL_AppSettings.Prefix + ensxtx_UTIL_AppSettings.CPQV2 + ensxtx_UTIL_AppSettings.Suffix, (Map<String, Object>)JSON.deserializeUntyped(TEST_JSON_CPQ));
        ensxtx_UTIL_AppSettings.settingsMap.put(ensxtx_UTIL_AppSettings.Prefix + ensxtx_UTIL_AppSettings.VC + ensxtx_UTIL_AppSettings.Suffix, (Map<String, Object>)JSON.deserializeUntyped(TEST_JSON_VC));
        
        Test.startTest();
        SBQQ__Quote__c quote = ensxtx_TSTU_SFCPQQuote.createTestQuote();
        ensxtx_TSTU_SFTestObject.upsertWithRetry(quote);
        Map<String,Object> params = new Map<String,Object>();
        ensxtx_UTIL_Aura.Response resp = ensxtx_CTRL_CPQ_Sales_Org.updateInfo(params);
        params.put('quoteId', quote.Id);
        resp = ensxtx_CTRL_CPQ_Sales_Org.updateInfo(params);
        params.put('quoteId', ensxtx_TSTU_SFTestObject.getFakeId(Account.SObjectType));
        resp = ensxtx_CTRL_CPQ_Sales_Org.updateInfo(params);
        Test.stopTest();
    }

    public class Mockensxtx_SBO_EnosixCustomer_Detail implements
        ensxsdk.EnosixFramework.DetailSBOInitMock,
        ensxsdk.EnosixFramework.DetailSBOCommandMock,
        ensxsdk.EnosixFramework.DetailSBOGetMock,
        ensxsdk.EnosixFramework.DetailSBOSaveMock
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

        private boolean returnSales = true;

        public void setReturnSales(boolean returnSales)
        {
            this.returnSales = returnSales;
        }

        public ensxsdk.EnosixFramework.DetailObject executeInitialize(ensxsdk.EnosixFramework.DetailObject initialState) 
        { 
            return null; 
        }

        public ensxsdk.EnosixFramework.DetailObject executeCommand(String command, ensxsdk.EnosixFramework.DetailObject obj) 
        { 
            return null; 
        }

        public ensxsdk.EnosixFramework.DetailObject executeGetDetail(object key) 
        { 
            if (throwException)
            {
                throw new CalloutException();
            }
            ensxtx_SBO_EnosixCustomer_Detail.EnosixCustomer result = new ensxtx_SBO_EnosixCustomer_Detail.EnosixCustomer();
            result.CustomerNumber = 'TEST';
            if (this.returnSales)
            {
                ensxtx_SBO_EnosixCustomer_Detail.SALES_DATA sd1 = new ensxtx_SBO_EnosixCustomer_Detail.SALES_DATA();
                sd1.SalesOrganization = '3000';
                sd1.DistributionChannel = '10';
                sd1.Division = '10';
                result.SALES_DATA.add(sd1);
                ensxtx_SBO_EnosixCustomer_Detail.SALES_DATA sd2 = new ensxtx_SBO_EnosixCustomer_Detail.SALES_DATA();
                sd2.SalesOrganization = '1000';
                sd2.DistributionChannel = '10';
                sd2.Division = '10';
                result.SALES_DATA.add(sd2);
                ensxtx_SBO_EnosixCustomer_Detail.SALES_DATA sd3 = new ensxtx_SBO_EnosixCustomer_Detail.SALES_DATA();
                sd3.SalesOrganization = '1000';
                sd3.DistributionChannel = '01';
                sd3.Division = '10';
                result.SALES_DATA.add(sd3);
                ensxtx_SBO_EnosixCustomer_Detail.SALES_DATA sd4 = new ensxtx_SBO_EnosixCustomer_Detail.SALES_DATA();
                sd4.SalesOrganization = '1000';
                sd4.DistributionChannel = '01';
                sd4.Division = '01';
                result.SALES_DATA.add(sd4);
            }
            
            result.setSuccess(this.success);
            return result;
        }

        public ensxsdk.EnosixFramework.DetailObject executeSave(ensxsdk.EnosixFramework.DetailObject obj) 
        { 
            return null; 
        }
    }
}