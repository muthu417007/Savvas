@isTest
public class ensxtx_TSTU_Document_Detail
{
    private static final String sboDetailType = 'SalesDocument';

    @isTest
    public static void test_simulateCommand()
    {
        String simulateCommand = ensxtx_UTIL_Document_Detail.getSimulateCommand(sboDetailType);
    }

    @isTest
    public static void test_referenceCommand()
    {
        String referenceCommand = ensxtx_UTIL_Document_Detail.getReferenceDocumentCommand(sboDetailType);
    }
    
    @isTest
    public static void test_getMaterialBomCountCommand()
    {
        String command = ensxtx_UTIL_Document_Detail.getMaterialBomCountCommand(sboDetailType);
    }

    @isTest
    public static void test_removeAllConditions()
    {
        ensxsdk.EnosixFramework.DetailObject docDetail = ensxtx_UTIL_Document_Detail.removeAllConditions(
            new ensxtx_SBO_EnosixSalesDocument_Detail.EnosixSalesDocument(), sboDetailType);
    }

    @isTest
    public static void test_updateSimulateBeforeUpdate()
    {
        ensxtx_DS_Document_Detail salesDocDetail = new ensxtx_DS_Document_Detail();
        ensxtx_DS_SalesDocAppSettings salesDocAppSettings = new ensxtx_DS_SalesDocAppSettings();
        salesDocAppSettings.SBODetailType = sboDetailType;

        ensxsdk.EnosixFramework.DetailObject docDetail = ensxtx_UTIL_Document_Detail.updateSimulateBeforeUpdate(
            new ensxtx_SBO_EnosixSalesDocument_Detail.EnosixSalesDocument(), salesDocDetail, salesDocAppSettings);
    }

    @isTest
    public static void test_buildSBOReference()
    {
        ensxsdk.EnosixFramework.DetailObject docDetail = ensxtx_UTIL_Document_Detail.buildSBOForReference('111', 'Test', sboDetailType);
    }

    @isTest
    public static void test_convertToSBO()
    {
        ensxtx_DS_Document_Detail salesDocDetail = new ensxtx_DS_Document_Detail();
        ensxtx_DS_SalesDocAppSettings salesDocAppSettings = new ensxtx_DS_SalesDocAppSettings();
        salesDocAppSettings.SBODetailType = sboDetailType;

        ensxsdk.EnosixFramework.DetailObject salesDocSBO = ensxtx_UTIL_Document_Detail.convertToSBO(null, salesDocDetail, false, salesDocAppSettings);
    }

    @isTest
    public static void test_convertToObject()
    {
        ensxtx_DS_Document_Detail salesDocDetail = new ensxtx_DS_Document_Detail();
        ensxtx_DS_SalesDocAppSettings salesDocAppSettings = new ensxtx_DS_SalesDocAppSettings();
        salesDocAppSettings.SBODetailType = sboDetailType;
        salesDocAppSettings.useConvertToObjectTrigger = false;

        ensxtx_UTIL_Document_Detail.convertToObject(new ensxtx_SBO_EnosixSalesDocument_Detail.EnosixSalesDocument(), salesDocDetail, false, salesDocAppSettings, ensxtx_UTIL_Document_Detail.convertToObjectTrigger.simulateSalesDoc);
        ensxtx_UTIL_Document_Detail.convertToObject(new ensxtx_SBO_EnosixSalesDocument_Detail.EnosixSalesDocument(), salesDocDetail, false, salesDocAppSettings, ensxtx_UTIL_Document_Detail.convertToObjectTrigger.createSAPDocument);
    }

    @isTest
    public static void test_initializeSBODetail()
    {
        ensxsdk.EnosixFramework.DetailSBO detailSBO = ensxtx_UTIL_Document_Detail.initializeSBODetail(sboDetailType);
    }
}