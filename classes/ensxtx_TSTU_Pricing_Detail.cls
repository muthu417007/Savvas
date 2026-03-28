@isTest
public class ensxtx_TSTU_Pricing_Detail
{
    @isTest
    public static void test_getCommand()
    {
        ensxtx_UTIL_Pricing_Detail documentDetail = new ensxtx_UTIL_Pricing_Detail();

        String simulateCommand = documentDetail.getSimulateCommand();
        String referenceCommand = documentDetail.getReferenceDocumentCommand();
        String command = documentDetail.getMaterialBomCountCommand();
    }

    @isTest
    public static void test_buildSBOReference()
    {
        ensxtx_UTIL_Pricing_Detail documentDetail = new ensxtx_UTIL_Pricing_Detail();
        ensxsdk.EnosixFramework.DetailObject docDetail = documentDetail.buildSBOForReference(null, null);
    }

    @isTest
    public static void test_convertToSBO()
    {
        ensxtx_DS_Document_Detail salesDocDetail = ensxtx_TSTD_Document_Detail.buildSalesDocDetail();
        ensxtx_UTIL_Pricing_Detail documentDetail = new ensxtx_UTIL_Pricing_Detail();
        ensxtx_DS_SalesDocAppSettings salesDocAppSettings = ensxtx_TSTD_SalesDocAppSettings.buildAppSettings();

        salesDocAppSettings.SBODetailType = 'Pricing';

        ensxtx_SBO_EnosixPricing_Detail.EnosixOpportunityPricing salesDocSBO = 
            (ensxtx_SBO_EnosixPricing_Detail.EnosixOpportunityPricing) documentDetail.convertToSBO(null, salesDocDetail, false, salesDocAppSettings);

        for (ensxtx_SBO_EnosixPricing_Detail.PARTNERS partner : salesDocSBO.PARTNERS.getAsList()) {
            if (String.isEmpty(partner.ItemNumber)) {
                partner.ItemNumber = '0';
            }
        }
        salesDocSBO = (ensxtx_SBO_EnosixPricing_Detail.EnosixOpportunityPricing) documentDetail.convertToSBO(salesDocSBO, salesDocDetail, true, salesDocAppSettings);
        salesDocSBO.PARTNERS.clear();
        salesDocSBO = (ensxtx_SBO_EnosixPricing_Detail.EnosixOpportunityPricing) documentDetail.convertToSBO(salesDocSBO, salesDocDetail, true, salesDocAppSettings);
        salesDocSBO = (ensxtx_SBO_EnosixPricing_Detail.EnosixOpportunityPricing) documentDetail.updateSimulateBeforeUpdate(salesDocSBO, salesDocDetail, salesDocAppSettings);

        ensxtx_DS_Document_Detail clonedSalesDocHeader = salesDocDetail.cloneHeader();
        salesDocSBO = (ensxtx_SBO_EnosixPricing_Detail.EnosixOpportunityPricing) documentDetail.removeAllConditions(salesDocSBO);
    }

    @isTest
    public static void test_convertToObject()
    {
        ensxtx_DS_Document_Detail salesDocDetail = ensxtx_TSTD_Document_Detail.buildSalesDocDetail();
        ensxtx_UTIL_Pricing_Detail documentDetail = new ensxtx_UTIL_Pricing_Detail();
        ensxtx_DS_SalesDocAppSettings salesDocAppSettings = ensxtx_TSTD_SalesDocAppSettings.buildAppSettings();

        salesDocAppSettings.SBODetailType = 'Pricing';

        ensxtx_SBO_EnosixPricing_Detail.EnosixOpportunityPricing salesDocSBO = 
            (ensxtx_SBO_EnosixPricing_Detail.EnosixOpportunityPricing) documentDetail.convertToSBO(null, salesDocDetail, false, salesDocAppSettings);

        ensxtx_SBO_EnosixPricing_Detail.ITEMS_SCHEDULE sched = new ensxtx_SBO_EnosixPricing_Detail.ITEMS_SCHEDULE();
        sched.ItemNumber = '000010';
        salesDocSBO.ITEMS_SCHEDULE.add(sched);

        List<ensxtx_SBO_EnosixPricing_Detail.ITEMS> sboItems = salesDocSBO.ITEMS.getAsList();

        sboItems[0].PriceListType = 'PA';
        sboItems[0].PriceListTypeText = 'Hello World = 2%';

        documentDetail.convertToObject(salesDocSBO, salesDocDetail, false, salesDocAppSettings, ensxtx_UTIL_Document_Detail.convertToObjectTrigger.simulateSalesDoc);
        salesDocDetail = new ensxtx_DS_Document_Detail();
        documentDetail.convertToObject(salesDocSBO, salesDocDetail, true, salesDocAppSettings, ensxtx_UTIL_Document_Detail.convertToObjectTrigger.simulateSalesDoc);
        salesDocDetail = new ensxtx_DS_Document_Detail();
        salesDocAppSettings.useConvertToObjectTrigger = true;
        documentDetail.convertToObject(salesDocSBO, salesDocDetail, true, salesDocAppSettings, ensxtx_UTIL_Document_Detail.convertToObjectTrigger.updateSAPDocument);
    }
}