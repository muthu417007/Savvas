@isTest
public class ensxtx_TSTU_SalesDoc
{
    @isTest
    public static void test_prop()
    {
        ensxtx_UTIL_SalesDoc.SFObject sfObject = new ensxtx_UTIL_SalesDoc.SFObject();
        sfObject.sfObjectType = 'Opportunity';
        sfObject.sfObjectLabel = 'Opportunity';
        sfObject.initFromSObject = true;
        sfObject.pricebookId = ensxtx_UTIL_Pricebook.getStandardPriceBookId();
        sfObject.sfMainObject = new Opportunity();
        sfObject.sfLineItems = new List<OpportunityLineItem>();
        sfObject.customerNumber = '1111';
        sfObject.sapDocNumber = '2222';
        sfObject.status = 'status';
        sfObject.allowDebug = true;
    }

    @isTest
    public static void test_saveHeaderAndLineItems()
    {
        Account newAccount = ensxtx_TSTU_SFTestObject.createTestAccount();
        newAccount.put(ensxtx_UTIL_SFAccount.CustomerFieldName, '1111');
        ensxtx_TSTU_SFTestObject.upsertWithRetry(newAccount);

        Id pricebookId = ensxtx_UTIL_Pricebook.getStandardPriceBookId();
        Opportunity opp = ensxtx_TSTU_SFTestObject.createTestOpportunity();

        Product2 product = ensxtx_TSTU_SFTestObject.createTestProduct2();
        product.put(ensxtx_UTIL_SFProduct.MaterialFieldName, 'Material1');

        List<OpportunityLineItem> lineItems = new List<OpportunityLineItem>();
        OpportunityLineItem lineItem1 = ensxtx_TSTU_SFTestObject.createTestOpportunityLineItem();
		lineItem1.Quantity = 10;
		lineItem1.UnitPrice = .95;
		lineItem1.Description = 'test Desciption';
        lineItem1.ServiceDate = System.today();
        lineItems.add(lineItem1);

        OpportunityLineItem lineItem2 = ensxtx_TSTU_SFTestObject.createTestOpportunityLineItem();
		lineItem2.Quantity = 10;
		lineItem2.UnitPrice = .95;
		lineItem2.Description = 'test Desciption';
        lineItem2.ServiceDate = System.today();
        lineItems.add(lineItem2);

        ensxtx_UTIL_SalesDoc.SFObject sfObject = new ensxtx_UTIL_SalesDoc.SFObject();
        sfObject.sfObjectType = 'Opportunity';
        sfObject.sfObjectLabel = 'Opportunity';
        sfObject.initFromSObject = true;
        sfObject.sfMainObject = opp;
        sfObject.sfLineItems = lineItems;
        sfObject.customerNumber = '1111';

        ensxtx_DS_Document_Detail salesDocDetail = ensxtx_TSTD_Document_Detail.buildSalesDocDetail();

        ensxtx_DS_SalesDocAppSettings appSettings = new ensxtx_DS_SalesDocAppSettings();
        appSettings.updateLineItems = true;
        appSettings.deleteLineItems = false;
        appSettings.skipAddedLineValidation = false;
        ensxtx_UTIL_SalesDoc.saveHeaderAndLineItems(sfObject, salesDocDetail, appSettings);

        appSettings.skipAddedLineValidation = true;
        ensxtx_UTIL_SalesDoc.saveHeaderAndLineItems(sfObject, salesDocDetail, appSettings);

        OpportunityLineItem lineItem3 = ensxtx_TSTU_SFTestObject.createTestOpportunityLineItem();
		lineItem3.Quantity = 10;
		lineItem3.UnitPrice = .95;
		lineItem3.Description = 'test Desciption';
        lineItem3.ServiceDate = System.today();
        lineItems.clear();
        lineItems.add(lineItem3);

        salesDocDetail.ITEMS[0].sfId = null;
        salesDocDetail.ITEMS[0].ItemNumber = '10';
        salesDocDetail.ITEMS[0].Material = 'Material';

        ensxtx_UTIL_SalesDoc.saveHeaderAndLineItems(sfObject, salesDocDetail, appSettings);

        Set<String> materialNumbers = new Set<String>{product.Name, 'Not Found Material'};
        try {
            ensxtx_UTIL_SalesDoc.validateMaterials(materialNumbers, pricebookId, new Map<String, PricebookEntry>(), 'USD');
            PriceBookEntry pbe = ensxtx_TSTU_SFTestObject.createTestPriceBookEntry();
            pbe.UnitPrice = 100;
            pbe.Product2 = product;
            pbe.UseStandardPrice = false;
            pbe.IsActive = true;
            List<PriceBookEntry> entries = new List<PriceBookEntry>{pbe};
            ensxtx_UTIL_SalesDoc.validateMaterialsFromPBEList(materialNumbers, pricebookId, new Map<String, PricebookEntry>(), entries);
        }
        catch (Exception ex) {}
    }

    @isTest
    public static void test_getSFObjectInfo1()
    {
        Account newAccount = ensxtx_TSTU_SFTestObject.createTestAccount();
        ensxtx_TSTU_SFTestObject.upsertWithRetry(newAccount);

        Opportunity opp = ensxtx_TSTU_SFTestObject.createTestOpportunity();
        ensxtx_TSTU_SFTestObject.upsertWithRetry(opp);

        newAccount.put(ensxtx_UTIL_SFAccount.CustomerFieldName, '1111');
        ensxtx_TSTU_SFTestObject.upsertWithRetry(newAccount);

        ensxtx_UTIL_SalesDoc.SFObject result = ensxtx_UTIL_SalesDoc.getSFObjectInfo(opp.Id, 'Order');
        
        try
        {
            result = ensxtx_UTIL_SalesDoc.getSFObjectInfo(newAccount.Id, 'Order');
        }
        catch(Exception e) { }    }

    @isTest
    public static void test_getSFObjectInfoNon2()
    {
        Account newAccount = ensxtx_TSTU_SFTestObject.createTestAccount();
        newAccount.put(ensxtx_UTIL_SFAccount.CustomerFieldName, 'custNo');
        ensxtx_TSTU_SFTestObject.upsertWithRetry(newAccount);

        Opportunity opp = ensxtx_TSTU_SFTestObject.createTestOpportunity();
        opp.AccountId = newAccount.Id;
        ensxtx_TSTU_SFTestObject.upsertWithRetry(opp);
        
        ensxtx_UTIL_SalesDoc.SFObject result = ensxtx_UTIL_SalesDoc.getSFObjectInfo(opp.Id, 'Order');

        result = ensxtx_UTIL_SalesDoc.getSFObjectInfo(opp.Id, 'Order');

        result = ensxtx_UTIL_SalesDoc.getSFObjectInfo(opp.Id, 'Quote');

        result = ensxtx_UTIL_SalesDoc.getSFObjectInfo(opp.Id, 'Contract');

        result = ensxtx_UTIL_SalesDoc.getSFObjectInfo(opp.Id, 'Inquiry');

        result = ensxtx_UTIL_SalesDoc.getSFObjectInfo(opp.Id, 'Credit Memo');

        result = ensxtx_UTIL_SalesDoc.getSFObjectInfo(opp.Id, 'Debit Memo');

        result = ensxtx_UTIL_SalesDoc.getSFObjectInfo(opp.Id, 'Return Order');

        result = ensxtx_UTIL_SalesDoc.getSFObjectInfo(null, 'Order');
    }

    @isTest
    public static void test_mapSalesDocDetailFromSFObject()
    {
        ensxtx_DS_Document_Detail salesDocDetail = new ensxtx_DS_Document_Detail();
        ensxtx_UTIL_SalesDoc.SFObject sfObject = new ensxtx_UTIL_SalesDoc.SFObject();
        ensxtx_DS_SalesDocAppSettings appSettings = new ensxtx_DS_SalesDocAppSettings();

        ensxtx_DS_Document_Detail newSalesDocDetail = ensxtx_UTIL_SalesDoc.mapSalesDocDetailFromSFObject(salesDocDetail, sfObject, appSettings);
    }

    @isTest
    public static void test_compareSAPSimulateVsSObject()
    {
        ensxtx_DS_Document_Detail salesDocDetail = new ensxtx_DS_Document_Detail();
        ensxtx_DS_SalesDocAppSettings appSettings = new ensxtx_DS_SalesDocAppSettings();

        ensxtx_UTIL_SalesDoc.compareSAPSimulateVsSObject(salesDocDetail, salesDocDetail, appSettings);
        ensxtx_UTIL_SalesDoc.compareSAPSimulateVsSObject compareSAPSimulateVsSObject = new ensxtx_UTIL_SalesDoc.compareSAPSimulateVsSObject();
        compareSAPSimulateVsSObject.changeMessageList = null;
    }

    @isTest
    public static void test_mapCustomPricingToSalesDoc()
    {
        ensxtx_DS_Document_Detail salesDocDetail = new ensxtx_DS_Document_Detail();
        ensxtx_DS_SalesDocAppSettings appSettings = new ensxtx_DS_SalesDocAppSettings();

        ensxtx_UTIL_SalesDoc.mapCustomPricingToSalesDoc(salesDocDetail, appSettings);
    }

    @isTest
    public static void test_mapChildBomFields()
    {
        ensxtx_DS_Document_Detail salesDocDetail = new ensxtx_DS_Document_Detail();
        ensxtx_DS_SalesDocAppSettings appSettings = new ensxtx_DS_SalesDocAppSettings();

        ensxtx_UTIL_SalesDoc.mapChildBomFields(salesDocDetail, salesDocDetail, appSettings);
    }

    @isTest
    public static void test_convertAppSettingPartners()
    {
        List<ensxtx_DS_SalesDocAppSettings.PartnerSetting> appSettingPartners = new List<ensxtx_DS_SalesDocAppSettings.PartnerSetting>();
        ensxtx_DS_SalesDocAppSettings.PartnerSetting partnerSetting = new ensxtx_DS_SalesDocAppSettings.PartnerSetting();
        partnerSetting.PartnerFunction = 'SH';
        partnerSetting.PartnerFunctionName = 'Ship';
        partnerSetting.ComponentType = 'TEST';
        appSettingPartners.add(partnerSetting);

        List<ensxtx_DS_Document_Detail.PARTNERS> partners = ensxtx_UTIL_SalesDoc.convertAppSettingPartnersToPartners(appSettingPartners);
    }

    @isTest
    public static void test_convertAppSettingTexts()
    {
        List<ensxtx_DS_SalesDocAppSettings.TextSetting> appSettingTextList = new List<ensxtx_DS_SalesDocAppSettings.TextSetting>();
        ensxtx_DS_SalesDocAppSettings.TextSetting appSettingText = new ensxtx_DS_SalesDocAppSettings.TextSetting();
        appSettingTextList.add(appSettingText);

        List<ensxtx_DS_Document_Detail.TEXTS> texts = ensxtx_UTIL_SalesDoc.convertAppSettingTextsToTexts(appSettingTextList, 'EN');
    }

    
    @isTest
    public static void test_getPartnerFromDocumentDetail()
    {
        List<ensxtx_DS_Document_Detail.PARTNERS> partnerList = new List<ensxtx_DS_Document_Detail.PARTNERS>();

        ensxtx_UTIL_SalesDoc.getPartnerFromDocumentDetail(partnerList, 'partnerFunction', true);
        ensxtx_UTIL_SalesDoc.getPartnerFromDocumentDetail(partnerList, 'partnerFunction', true);
    }
}