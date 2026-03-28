@isTest
public class ensxtx_TSTU_SalesDocument_Detail
{
    @isTest
    public static void test_getCommand()
    {
        ensxtx_UTIL_SalesDocument_Detail documentDetail = new ensxtx_UTIL_SalesDocument_Detail();

        String simulateCommand = documentDetail.getSimulateCommand();
        String referenceCommand = documentDetail.getReferenceDocumentCommand();
        String materialBomCountCommand = documentDetail.getMaterialBomCountCommand();
    }

    @isTest
    public static void test_buildSBOReference()
    {
        ensxtx_UTIL_SalesDocument_Detail documentDetail = new ensxtx_UTIL_SalesDocument_Detail();
        ensxsdk.EnosixFramework.DetailObject docDetail = documentDetail.buildSBOForReference(null, null);
    }

    @isTest
    public static void test_convertToSBO()
    {
        ensxtx_DS_Document_Detail salesDocDetail = ensxtx_TSTD_Document_Detail.buildSalesDocDetail();
        ensxtx_UTIL_SalesDocument_Detail documentDetail = new ensxtx_UTIL_SalesDocument_Detail();
        ensxtx_DS_SalesDocAppSettings salesDocAppSettings = ensxtx_TSTD_SalesDocAppSettings.buildAppSettings();

        salesDocAppSettings.SBODetailType = 'SalesDocument';

        ensxtx_SBO_EnosixSalesDocument_Detail.EnosixSalesDocument salesDocSBO = 
            (ensxtx_SBO_EnosixSalesDocument_Detail.EnosixSalesDocument) documentDetail.convertToSBO(null, salesDocDetail, false, salesDocAppSettings);

        for (ensxtx_SBO_EnosixSalesDocument_Detail.PARTNERS partner : salesDocSBO.PARTNERS.getAsList()) {
            if (String.isEmpty(partner.ItemNumber)) {
                partner.ItemNumber = '0';
            }
        }
        salesDocSBO = (ensxtx_SBO_EnosixSalesDocument_Detail.EnosixSalesDocument) documentDetail.convertToSBO(salesDocSBO, salesDocDetail, true, salesDocAppSettings);
        salesDocSBO.PARTNERS.clear();
        salesDocSBO.TEXTS.clear();
        salesDocSBO = (ensxtx_SBO_EnosixSalesDocument_Detail.EnosixSalesDocument) documentDetail.convertToSBO(salesDocSBO, salesDocDetail, true, salesDocAppSettings);
        salesDocSBO = (ensxtx_SBO_EnosixSalesDocument_Detail.EnosixSalesDocument) documentDetail.updateSimulateBeforeUpdate(salesDocSBO, salesDocDetail, salesDocAppSettings);

        ensxtx_DS_Document_Detail clonedSalesDocHeader = salesDocDetail.cloneHeader();
        salesDocSBO = (ensxtx_SBO_EnosixSalesDocument_Detail.EnosixSalesDocument) documentDetail.removeAllConditions(salesDocSBO);
    }

    @isTest
    public static void test_convertToObject()
    {
        ensxtx_DS_Document_Detail salesDocDetail = ensxtx_TSTD_Document_Detail.buildSalesDocDetail();
        ensxtx_UTIL_SalesDocument_Detail documentDetail = new ensxtx_UTIL_SalesDocument_Detail();
        ensxtx_DS_SalesDocAppSettings salesDocAppSettings = ensxtx_TSTD_SalesDocAppSettings.buildAppSettings();

        salesDocAppSettings.SBODetailType = 'SalesDocument';
        salesDocAppSettings.DefaultDocType = 'YORD';

        ensxtx_SBO_EnosixSalesDocument_Detail.EnosixSalesDocument salesDocSBO = 
            (ensxtx_SBO_EnosixSalesDocument_Detail.EnosixSalesDocument) documentDetail.convertToSBO(null, salesDocDetail, false, salesDocAppSettings);

        for (ensxtx_SBO_EnosixSalesDocument_Detail.PARTNERS partner : salesDocSBO.PARTNERS.getAsList()) {
            if (String.isEmpty(partner.ItemNumber)) {
                partner.ItemNumber = '0';
            }
        }
        ensxtx_SBO_EnosixSalesDocument_Detail.BILLING_PLAN_DATES billPlanDate = new ensxtx_SBO_EnosixSalesDocument_Detail.BILLING_PLAN_DATES();
        billPlanDate.ItemNumber = '000010';
        billPlanDate.FromSettlementDate = Date.today();
        billPlanDate.Usage = 'Usage';
        salesDocSBO.BILLING_PLAN_DATES.add(billPlanDate);
    
        ensxtx_SBO_EnosixSalesDocument_Detail.ITEMS_SCHEDULE sched = new ensxtx_SBO_EnosixSalesDocument_Detail.ITEMS_SCHEDULE();
        sched.ItemNumber = '000010';
        salesDocSBO.ITEMS_SCHEDULE.add(sched);

        documentDetail.convertToObject(salesDocSBO, salesDocDetail, false, salesDocAppSettings, ensxtx_UTIL_Document_Detail.convertToObjectTrigger.simulateSalesDoc);

        ensxtx_SBO_EnosixSalesDocument_Detail.INCOMPLETION_LOG newLog1 = new ensxtx_SBO_EnosixSalesDocument_Detail.INCOMPLETION_LOG();
        newLog1.Description = 'Configuration';
        newLog1.ItemNumber = '000010';
        salesDocSBO.INCOMPLETION_LOG.add(newLog1);
        ensxtx_SBO_EnosixSalesDocument_Detail.INCOMPLETION_LOG newLog2 = new ensxtx_SBO_EnosixSalesDocument_Detail.INCOMPLETION_LOG();
        newLog2.Description = 'Configuration';
        newLog2.ItemNumber = '000000';
        salesDocSBO.INCOMPLETION_LOG.add(newLog2);
        salesDocDetail = new ensxtx_DS_Document_Detail();
        documentDetail.convertToObject(salesDocSBO, salesDocDetail, true, salesDocAppSettings, ensxtx_UTIL_Document_Detail.convertToObjectTrigger.simulateSalesDoc);

        salesDocDetail = new ensxtx_DS_Document_Detail();
        salesDocAppSettings.useConvertToObjectTrigger = true;
        documentDetail.convertToObject(salesDocSBO, salesDocDetail, true, salesDocAppSettings, ensxtx_UTIL_Document_Detail.convertToObjectTrigger.updateSAPDocument);
    }
}