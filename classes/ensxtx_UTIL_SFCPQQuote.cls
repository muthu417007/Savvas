public with sharing class ensxtx_UTIL_SFCPQQuote implements ensxtx_I_SFSObjectDoc
{
    private static final ensxsdk.Logger logger = new ensxsdk.Logger(ensxtx_UTIL_SFCPQQuote.class);

    @testVisible
    private static String defaultSalesDocType = (String)ensxtx_UTIL_AppSettings.getValue(ensxtx_UTIL_AppSettings.CPQV2, 'DefaultSalesDocType', '');
    @testVisible
    private static String defaultSalesOrg = (String)ensxtx_UTIL_AppSettings.getValue(ensxtx_UTIL_AppSettings.CPQV2, 'DefaultSalesOrg', '');
    @testVisible
    private static String defaultDistributionChannel = (String)ensxtx_UTIL_AppSettings.getValue(ensxtx_UTIL_AppSettings.CPQV2, 'DefaultDistributionChannel', '');
    @testVisible
    private static String defaultDivision = (String)ensxtx_UTIL_AppSettings.getValue(ensxtx_UTIL_AppSettings.CPQV2, 'DefaultDivision', '');

    public static String QuoteFieldName
    {
        get
        {
            return (String)ensxtx_UTIL_AppSettings.getValue(ensxtx_UTIL_AppSettings.CPQV2, 'CPQQuote.QuoteFieldName', 'ensxtx_SAP_Quote_Number__c');
        }
    }

    public static String OrderFieldName
    {
        get
        {
            return (String)ensxtx_UTIL_AppSettings.getValue(ensxtx_UTIL_AppSettings.CPQV2, 'CPQQuote.OrderFieldName', 'ensxtx_SAP_Order_Number__c');
        }
    }

    public static String ContractFieldName
    {
        get
        {
            return (String)ensxtx_UTIL_AppSettings.getValue(ensxtx_UTIL_AppSettings.CPQV2, 'CPQQuote.ContractFieldName', 'ensxtx_SAP_Contract_Number__c');
        }
    }

    public static String InquiryFieldName
    {
        get
        {
            return (String)ensxtx_UTIL_AppSettings.getValue(ensxtx_UTIL_AppSettings.CPQV2, 'CPQQuote.InquiryFieldName', 'ensxtx_SAP_Inquiry_Number__c');
        }
    }

    public static String CreditMemoFieldName
    {
        get
        {
            return (String)ensxtx_UTIL_AppSettings.getValue(ensxtx_UTIL_AppSettings.CPQV2, 'CPQQuote.CreditMemoFieldName', 'ensxtx_SAP_CreditMemo_Number__c');
        }
    }

    public static String DebitMemoFieldName
    {
        get
        {
            return (String)ensxtx_UTIL_AppSettings.getValue(ensxtx_UTIL_AppSettings.CPQV2, 'CPQQuote.DebitMemoFieldName', 'ensxtx_SAP_DebitMemo_Number__c');
        }
    }

    public static String ReturnOrderFieldName
    {
        get
        {
            return (String)ensxtx_UTIL_AppSettings.getValue(ensxtx_UTIL_AppSettings.CPQV2, 'CPQQuote.ReturnOrderFieldName', 'ensxtx_SAP_ReturnOrder_Number__c');
        }
    }

    public Object callReturnMethod(String method, Map<String, Object> params)
    {
        switch on method {
            when 'CustomLineQuery' {
                return getCustomLineQuery(params);
            }
        }
        return null;
    }

    private String getCustomLineQuery(Map<String, Object> params)
    {
        String query = getSObjectLineQuery();
        query += ' FROM SBQQ__QuoteLine__c WHERE Id IN :lineItemIds ORDER BY SBQQ__Number__c ASC';
        return query;
    }

    private SObject loadedSObject;
    private Id loadedId;
    private string loadedSapType;
    private string loadedSapDocNum;
    private Map<Id, SObject> loadedLineMap;

	public SObject getSObject(Id id)
	{
        return getSObject(id, null, null);
    }

	public SObject getSObject(String sapType, String sapDocNum)
	{
        return getSObject(null, sapType, sapDocNum);
    }

	private SObject getSObject(Id id, String sapType, String sapDocNum)
	{
        if (loadedSObject != null && (loadedId == id || (loadedSapType == sapType && loadedSapDocNum == sapDocNum)))
        {
            return loadedSObject;
        }
        loadedId = id;
        loadedSapType = sapType;
        loadedSapDocNum = sapDocNum;
        loadedLineMap = null;
        
		SObject result = null;

        string errorString = '';
        if (id != null || (String.isNotEmpty(sapType) && String.isNotEmpty(sapDocNum)))
        {
            try
            {
                string selectCmd = 'SELECT Id, Name, SBQQ__Opportunity2__c, SBQQ__PricebookId__c, SBQQ__Account__c,' +
                    ' ensxtx_SAP_SaveSalesDocHeader__c, ensxtx_SalesDocStatus__c, ensxtx_SAP_Simulation_Error__c,' +
                    ' SBQQ__Account__r.' + ensxtx_UTIL_SFAccount.CustomerFieldName + ', ensxtx_Sold_To_Number__c,' +
                    ' ensxtx_Ship_To_Number__c, ensxtx_Bill_To_Number__c, ensxtx_Payer_Number__c, ensxtx_Document_Type__c,' +
                    ' ensxtx_Sales_Organization__c, ensxtx_Distribution_Channel__c, ensxtx_Division__c, ' + ensxtx_UTIL_SFCPQQuote.QuoteFieldName + ',' +
                    ensxtx_UTIL_SFCPQQuote.OrderFieldName + ',' + ensxtx_UTIL_SFCPQQuote.ContractFieldName + ',' + ensxtx_UTIL_SFCPQQuote.InquiryFieldName + ',' +
                    ensxtx_UTIL_SFCPQQuote.CreditMemoFieldName + ',' + ensxtx_UTIL_SFCPQQuote.DebitMemoFieldName + ',' + ensxtx_UTIL_SFCPQQuote.ReturnOrderFieldName;
                selectCmd += ensxtx_UTIL_SObject.selectCurrencyField('SBQQ__Quote__c');
                selectCmd += ' FROM SBQQ__Quote__c';

                if (id != null)
                {
                    selectCmd += ' WHERE Id = \'' + id + '\'';
                    errorString = ' for the provided Id ' + id;
                }
                else
                {
                    if (sapType == 'Quote')
                    {
                        selectCmd += ' WHERE ensxtx_SAP_Quote_Number__c = \'' + sapDocNum + '\'';
                        errorString = ' for the provided SAP Quote Number ' + sapDocNum;
                    }
                    else if (sapType == 'Order')
                    {
                        selectCmd += ' WHERE ensxtx_SAP_Order_Number__c = \'' + sapDocNum + '\'';
                        errorString = ' for the provided SAP Order Number ' + sapDocNum;
                    }
                    else
                    {
                        selectCmd = null;
                    }
                }
                if (selectCmd != null)
                {
                    selectCmd += ' Limit 1';

                    List<SObject> resultList = Database.query(selectCmd);

                    if (resultList.size() > 0)
                    {
                        result = resultList[0];
                        loadedId = result.Id;
                    }
                }
            }
            catch (Exception e) { ensxtx_UTIL_PageMessages.addExceptionMessage(e); }
        }

        if (result == null && id != null)
        {
            ensxtx_UTIL_PageMessages.addMessage(ensxtx_UTIL_PageMessages.ERROR, 
                'There was an issue retrieving an Quote record: ' + errorString);
        }

        loadedSObject = result;
		return result;
	}

	public Map<Id, SObject> getSObjectLineItems(Id id)
	{
        if (loadedLineMap != null && loadedId == id)
        {
            return loadedLineMap;
        }

        loadedId = id;

		Map<Id, SObject> lineMap = new Map<Id, SObject>();

		try
		{
            string selectCmd = getSObjectLineQuery();

            selectCmd += ' FROM SBQQ__QuoteLine__c WHERE SBQQ__Quote__c = :id ORDER BY SBQQ__Number__c';
            lineMap = new Map<Id, SObject>(Database.query(selectCmd));
		}
		catch (Exception e) { ensxtx_UTIL_PageMessages.addExceptionMessage(e); }
        loadedLineMap = lineMap;
        return lineMap;
	}

    private String getSObjectLineQuery()
    {
        String query = 'SELECT Id, Name, SBQQ__Quote__c, SBQQ__PricebookEntryId__c, ensxtx_SAP_Item_Number__c, ensxtx_Created_SAP_Item_Number__c, SBQQ__Number__c,' +
            ' SBQQ__Discount__c, SBQQ__AdditionalDiscount__c, SBQQ__Quantity__c, SBQQ__ListPrice__c, SBQQ__Product__r.SBQQ__ExternallyConfigurable__c,' +
            ' SBQQ__NetPrice__c, SBQQ__Description__c, ensxtx_SAP_Configuration__c, SBQQ__ProductCode__c, ensxtx_SAP_SaveSalesDocItem__c, SBQQ__RequiredBy__c,' + 
            ' SBQQ__Product__c, SBQQ__Product__r.' + ensxtx_UTIL_SFProduct.MaterialFieldName + ', SBQQ__DynamicOptionId__c, SBQQ__UnitCost__c,' +
            ' SBQQ__BundledQuantity__c, SBQQ__OptionLevel__c ';

        String configurableMaterialField = ensxtx_UTIL_SFProduct.getConfigurableMaterialField();
        String bomMaterialField = ensxtx_UTIL_SFProduct.getBOMMaterialField();

        if (String.isNotEmpty(configurableMaterialField)) {
            query += ', SBQQ__Product__r.' + configurableMaterialField;
        }

        if (String.isNotEmpty(bomMaterialField)) {
            query += ', SBQQ__Product__r.' + bomMaterialField;
        }

        return query;
    }
	
	public Map<Id, SObject> getSObjectContacts(Id id)
	{
		//Implement to get Contact link to SObject
		return new Map<Id, SObject>();
	}
    
	public String getAccountId(SObject sfSObject)
	{
        return sfSObject == null || sfSObject.getSObjectType().getDescribe().getName() != 'SBQQ__Quote__c' ? null : ((SBQQ__Quote__c) sfSObject).SBQQ__Account__c;
	}

    public String getCustomerNumber(SObject sfSObject)
	{
        return sfSObject == null || sfSObject.getSObjectType().getDescribe().getName() != 'SBQQ__Quote__c' || ((SBQQ__Quote__c) sfSObject).SBQQ__Account__c == null ? null : (String) ((SBQQ__Quote__c) sfSObject).SBQQ__Account__r.get(ensxtx_UTIL_SFAccount.CustomerFieldName);
	}

	public String getName(SObject sfSObject)
	{
        return '';
	}

    public String getQuoteNumber(SObject sfSObject)
    {
        return sfSObject == null || sfSObject.getSObjectType().getDescribe().getName() != 'SBQQ__Quote__c' ? '' : (String) ((SBQQ__Quote__c) sfSObject).get(ensxtx_UTIL_SFCPQQuote.QuoteFieldName);
    }

    public String getOrderNumber(SObject sfSObject)
    {
        return sfSObject == null || sfSObject.getSObjectType().getDescribe().getName() != 'SBQQ__Quote__c' ? '' : (String) ((SBQQ__Quote__c) sfSObject).get(ensxtx_UTIL_SFCPQQuote.OrderFieldName);
    }

    public String getContractNumber(SObject sfSObject)
    {
        return sfSObject == null || sfSObject.getSObjectType().getDescribe().getName() != 'SBQQ__Quote__c' ? '' : (String) ((SBQQ__Quote__c) sfSObject).get(ensxtx_UTIL_SFCPQQuote.ContractFieldName);
    }

    public String getInquiryNumber(SObject sfSObject)
    {
        return sfSObject == null || sfSObject.getSObjectType().getDescribe().getName() != 'SBQQ__Quote__c' ? '' : (String) ((SBQQ__Quote__c) sfSObject).get(ensxtx_UTIL_SFCPQQuote.InquiryFieldName);
    }

    public String getCreditMemoNumber(SObject sfSObject)
    {
        return sfSObject == null || sfSObject.getSObjectType().getDescribe().getName() != 'SBQQ__Quote__c' ? '' : (String) ((SBQQ__Quote__c) sfSObject).get(ensxtx_UTIL_SFCPQQuote.CreditMemoFieldName);
    }

    public String getDebitMemoNumber(SObject sfSObject)
    {
        return sfSObject == null || sfSObject.getSObjectType().getDescribe().getName() != 'SBQQ__Quote__c' ? '' : (String) ((SBQQ__Quote__c) sfSObject).get(ensxtx_UTIL_SFCPQQuote.DebitMemoFieldName);
    }

    public String getReturnOrderNumber(SObject sfSObject)
    {
        return sfSObject == null || sfSObject.getSObjectType().getDescribe().getName() != 'SBQQ__Quote__c' ? '' : (String) ((SBQQ__Quote__c) sfSObject).get(ensxtx_UTIL_SFCPQQuote.ReturnOrderFieldName);
    }

    public String getStatus(SObject sfSObject)
    {
        return sfSObject == null || sfSObject.getSObjectType().getDescribe().getName() != 'SBQQ__Quote__c' ? '' : (String) ((SBQQ__Quote__c) sfSObject).ensxtx_SalesDocStatus__c;
    }

    public String getOpportunityId(SObject sfSObject)
    {
        return sfSObject == null || sfSObject.getSObjectType().getDescribe().getName() != 'SBQQ__Quote__c'  ? null : ((SBQQ__Quote__c) sfSObject).SBQQ__Opportunity2__c;
    }

    @testVisible
    private Opportunity getOpportunity(SObject sfSObject)
    {
        return null;
    }

    public Id getPriceBookId(SObject sfSObject)
    {
        Id pricebookId;
        if (sfSObject == null || sfSObject.getSObjectType().getDescribe().getName() != 'SBQQ__Quote__c') {
            return null;
        }
        else pricebookId = ((SBQQ__Quote__c) sfSObject).SBQQ__PricebookId__c;

        if (String.isEmpty(pricebookId)) pricebookId = ensxtx_UTIL_Pricebook.getStandardPriceBookId();

        return pricebookId;
    }

    public Id getProductId(SObject sfsObjectLine)
    {
        return sfsObjectLine == null || sfsObjectLine.getSObjectType().getDescribe().getName() != 'SBQQ__QuoteLine__c' ? null : ((SBQQ__QuoteLine__c) sfsObjectLine).SBQQ__Product__c;
    }

    private Map<Id, String> productSAPMaterialNumberList;

    public String getMaterial(SObject sfSObject, SObject sfsObjectLine)
    {
        return sfsObjectLine == null || sfsObjectLine.getSObjectType().getDescribe().getName() != 'SBQQ__QuoteLine__c' || ((SBQQ__QuoteLine__c) sfsObjectLine).SBQQ__Product__c == null ? null : (String) ((SBQQ__QuoteLine__c) sfsObjectLine).SBQQ__Product__r.get(ensxtx_UTIL_SFProduct.MaterialFieldName);
    }

    public String getItemNumber(SObject sfsObjectLine)
    {
        return sfsObjectLine == null || sfsObjectLine.getSObjectType().getDescribe().getName() != 'SBQQ__QuoteLine__c' ? null : ((SBQQ__QuoteLine__c) sfsObjectLine).ensxtx_Created_SAP_Item_Number__c;
    }

    public ensxtx_DS_Document_Detail sObjectToSalesDocMapping(
        SObject sfSObject,
        List<SObject> sfLineItems,
        ensxtx_DS_Document_Detail salesDocDetail,
        ensxtx_DS_SalesDocAppSettings appSettings)
    {
        //Do the mapping from SObject and SF Line Items to salesDocDetail here
        SBQQ__Quote__c quote = (SBQQ__Quote__c) sfSObject;

        if (String.isEmpty(salesDocDetail.SalesDocument) && String.isNotEmpty(quote.ensxtx_SAP_SaveSalesDocHeader__c)) {
            salesDocDetail = (ensxtx_DS_Document_Detail) JSON.deserialize(quote.ensxtx_SAP_SaveSalesDocHeader__c, ensxtx_DS_Document_Detail.class);
            salesDocDetail.SalesDocument = '';
            if (salesDocDetail.UsersLanguage != UserInfo.getLanguage()) {
                salesDocDetail.UsersLanguage = UserInfo.getLanguage();
                salesDocDetail.NeedToSimulate = true;
            }
            else {
                salesDocDetail.NeedToSimulate = false;
            }
        }
        else {
            // Mapping of header fields from SObject
            salesDocDetail.SalesDocumentCurrency = ensxtx_UTIL_SObject.getCurrencyIsoCode('SBQQ__Quote__c', quote);
            salesDocDetail.UsersLanguage = UserInfo.getLanguage();
            salesDocDetail.SALES.SalesDocumentType = quote.ensxtx_Document_Type__c;
            ensxtx_DS_Document_Detail.PARTNERS shipToPartner = ensxtx_UTIL_SalesDoc.getPartnerFromDocumentDetail(salesDocDetail.PARTNERS, ensxtx_UTIL_Customer.SHIP_TO_PARTNER_CODE, true);
            shipToPartner.CustomerNumber = quote.ensxtx_Ship_To_Number__c;
            salesDocDetail.NeedToSimulate = true;
        }
        if (String.isEmpty(salesDocDetail.SALES.SalesDocumentType)) salesDocDetail.SALES.SalesDocumentType = appSettings.DefaultDocType;

        if (salesDocDetail.SALES.SalesOrganization != quote.ensxtx_Sales_Organization__c)
        {
            salesDocDetail.SALES.SalesOffice = '';
            salesDocDetail.SALES.SalesOfficeName = '';
            salesDocDetail.SALES.SalesGroup = '';
            salesDocDetail.SALES.SalesGroupName = '';
        }
        salesDocDetail.SFId = quote.Id;
        salesDocDetail.SALES.SalesOrganization = quote.ensxtx_Sales_Organization__c;
        salesDocDetail.SALES.DistributionChannel = quote.ensxtx_Distribution_Channel__c;
        salesDocDetail.SALES.Division = quote.ensxtx_Division__c;

        if (sfLineItems != null && sfLineItems.size() > 0) {
            Map<String, Integer> itemNumberMap = new Map<String, Integer>();
            itemNumberMap.put('itemNumber', 0);
            itemNumberMap.put('bomItemNumber', 0);

            Map<Integer, SBQQ__QuoteLine__c> itemNumberQuoteLine = new Map<Integer, SBQQ__QuoteLine__c>();

            Integer lineItemTot = sfLineItems.size();
            Set<Id> productFeaturesIdSet = new Set<Id>();
            for (Integer lineItemCnt = 0; lineItemCnt < lineItemTot; lineItemCnt++)
            {
                SObject sfLineItem = sfLineItems[lineItemCnt];
                SBQQ__QuoteLine__c quoteLine = (SBQQ__QuoteLine__c) sfLineItem;

                if (String.isEmpty(salesDocDetail.SalesDocument)) quoteLine.ensxtx_Created_SAP_Item_Number__c = null;
                if (String.isNotEmpty(quoteLine.ensxtx_Created_SAP_Item_Number__c)) {
                    itemNumberQuoteLine.put(Integer.valueOf(quoteLine.ensxtx_Created_SAP_Item_Number__c), quoteLine);
                }
                if (quoteLine.SBQQ__DynamicOptionId__c != null && quoteLine.SBQQ__DynamicOptionId__c.contains(':')) {
                    productFeaturesIdSet.add(quoteLine.SBQQ__DynamicOptionId__c.split(':')[0]);
                }
            }
            Map<Id, SObject> productFeaturesMap = new Map<Id, SObject>(Database.query('SELECT Id, Name FROM SBQQ__ProductFeature__c WHERE Id IN :productFeaturesIdSet AND Name = \'SAP BoM\''));

            // Update existing sales doc line items
            Set<Integer> deletedItemNumbers = new Set<Integer>();
            Set<String> deletedItemNumbersString = new Set<String>();
            Map<Integer, ensxtx_DS_Document_Detail.ITEMS> itemNumberItemMap = new Map<Integer, ensxtx_DS_Document_Detail.ITEMS>();
            salesDocDetail.removedItems = new List<String>();
            if (salesDocDetail.ITEMS != null && salesDocDetail.ITEMS.size() > 0) {
                Integer salesDocItemsTot = salesDocDetail.ITEMS.size();

                for (Integer salesDocItemsCnt = (salesDocItemsTot - 1); salesDocItemsCnt >= 0; salesDocItemsCnt--) {
                    ensxtx_DS_Document_Detail.ITEMS salesDocItem = salesDocDetail.ITEMS[salesDocItemsCnt];
                    if (String.isNotEmpty(salesDocItem.ItemNumber)) {
                        itemNumberItemMap.put(Integer.valueOf(salesDocItem.ItemNumber), salesDocItem);
                        if (!itemNumberQuoteLine.containsKey(Integer.valueOf(salesDocItem.ItemNumber))) {
                            deletedItemNumbers.add(Integer.valueOf(salesDocItem.ItemNumber));
                            deletedItemNumbersString.add(salesDocItem.ItemNumber);
                            salesDocDetail.ITEMS.remove(salesDocItemsCnt);
                        }
                    }
                }
            }

            if (deletedItemNumbersString.size() > 0) {
                salesDocDetail.removedItems = new List<String>(deletedItemNumbersString);
                salesDocDetail.removedItems.sort();
            }

            Decimal maxNumber = 0;
            Map<Id, SBQQ__QuoteLine__c> qlIdMap = new Map<Id, SBQQ__QuoteLine__c>();
            Integer parentItemNumber = 0;
            Integer childItemNumber = 0;
            List<Id> sapQLIds = new List<Id>();
            Map<Id, SBQQ__QuoteLine__c> sapSFChildIdMap = new Map<Id, SBQQ__QuoteLine__c>();
            Map<Id, String> qlSortOrderMap = new Map<Id, String>();
            for (Integer lineItemCnt = 0; lineItemCnt < lineItemTot; lineItemCnt++)
            {
                SObject sfLineItem = sfLineItems[lineItemCnt];
                SBQQ__QuoteLine__c quoteLine = (SBQQ__QuoteLine__c) sfLineItem;
                qlIdMap.put(quoteLine.Id, quoteLine);
                if (quoteLine.SBQQ__Number__c > maxNumber) maxNumber = quoteLine.SBQQ__Number__c;
                String sapMaterial = getMaterial(quote, quoteLine);
                if (String.isNotEmpty(sapMaterial)) {
                    Boolean isChild = quoteLine.SBQQ__DynamicOptionId__c != null && 
                        quoteLine.SBQQ__DynamicOptionId__c.contains(':') &&
                        productFeaturesMap.containsKey(quoteLine.SBQQ__DynamicOptionId__c.split(':')[0]);
                    if (isChild) {
                        childItemNumber++;
                        qlSortOrderMap.put(quoteLine.Id, String.valueOf(parentItemNumber + childItemNumber).leftPad(7, '0'));
                    } else if (quoteLine.SBQQ__RequiredBy__c == null || !sapQLIds.contains(quoteLine.SBQQ__RequiredBy__c)) {
                        Integer sfChdTot = sapSFChildIdMap.size();
                        if (sfChdTot > 0) {
                            List<Id> sfChdIdList = new List<Id>(sapSFChildIdMap.keySet());
                            for (Integer sfChdCnt = 0 ; sfChdCnt < sfChdTot ; sfchdCnt++) {
                                parentItemNumber += appSettings.itemNumberIncrement;
                                qlSortOrderMap.put(sapSFChildIdMap.get(sfChdIdList[sfChdCnt]).Id, String.valueOf(parentItemNumber).leftPad(7, '0'));
                            }
                            sapSFChildIdMap.clear();
                        }
                        parentItemNumber += appSettings.itemNumberIncrement;
                        childItemNumber = 0;
                        qlSortOrderMap.put(quoteLine.Id, String.valueOf(parentItemNumber).leftPad(7, '0'));
                    } else {
                        sapSFChildIdMap.put(quoteLine.Id, quoteLine);
                    }
                    sapQLIds.add(quoteLine.Id);
                }
            }
            Integer sfChdTot = sapSFChildIdMap.size();
            if (sfChdTot > 0) {
                List<Id> sfChdIdList = new List<Id>(sapSFChildIdMap.keySet());
                for (Integer sfChdCnt = 0 ; sfChdCnt < sfChdTot ; sfchdCnt++) {
                    parentItemNumber += appSettings.itemNumberIncrement;
                    qlSortOrderMap.put(sapSFChildIdMap.get(sfChdIdList[sfChdCnt]).Id, String.valueOf(parentItemNumber).leftPad(7, '0'));
                }
            }
    
            Set<Decimal> usedNumberSet = new Set<Decimal>();
            Map<String, SBQQ__QuoteLine__c> qlSortMap = new Map<String, SBQQ__QuoteLine__c>();
            for (Integer lineItemCnt = 0; lineItemCnt < lineItemTot; lineItemCnt++)
            {
                SObject sfLineItem = sfLineItems[lineItemCnt];
                SBQQ__QuoteLine__c quoteLine = (SBQQ__QuoteLine__c) sfLineItem;
                if (qlSortOrderMap.containsKey(quoteLine.Id)) {
                    SBQQ__QuoteLine__c parentLine = qlIdMap.get(quoteLine.SBQQ__RequiredBy__c);
                    String parentSapMaterial = getMaterial(quote, parentLine);
                    if (String.isEmpty(parentSapMaterial)) parentLine = null;
                    String qItemNumber = String.isEmpty(quoteLine.ensxtx_Created_SAP_Item_Number__c) ? '9999999' : quoteLine.ensxtx_Created_SAP_Item_Number__c.leftPad(7, '0');
                    String pItemNumber = parentLine == null ? qItemNumber : String.isEmpty(parentLine.ensxtx_Created_SAP_Item_Number__c) ? '9999999' : parentLine.ensxtx_Created_SAP_Item_Number__c.leftPad(7, '0');
                    if (usedNumberSet.contains(quoteLine.SBQQ__Number__c)) quoteLine.SBQQ__Number__c = ++maxNumber;
                    usedNumberSet.add(quoteLine.SBQQ__Number__c);
                    String qlSortKey = pItemNumber + '.' + qItemNumber + '.' + qlSortOrderMap.get(quoteLine.Id);
                    qlSortMap.put(qlSortKey, quoteLine);
                }
            }

            List<String> qlSortKeyList = new List<String>(qlSortMap.keySet());
            qlSortKeyList.sort();
            lineItemTot = qlSortKeyList.size();
            for (Integer lineItemCnt = 0; lineItemCnt < lineItemTot; lineItemCnt++)
            {
                SBQQ__QuoteLine__c quoteLine =  qlSortMap.get(qlSortKeyList[lineItemCnt]);
                ensxtx_DS_Document_Detail.ITEMS salesDocItem = String.isEmpty(quoteLine.ensxtx_Created_SAP_Item_Number__c) ? null : itemNumberItemMap.get(Integer.valueOf(quoteLine.ensxtx_Created_SAP_Item_Number__c));
                if (salesDocItem != null) {
                    System.debug('update existing item');
                    salesDocItem.isChanged = true;
                    mapSalesDocLineItemFields(salesDocDetail, salesDocItem, quoteLine, appSettings, itemNumberMap, productFeaturesMap, deletedItemNumbers);
                } else {
                    String sapMaterial = getMaterial(quote, quoteLine);
                    if (String.isNotEmpty(sapMaterial)) {
                        System.debug('insert new line item');
                        salesDocItem = new ensxtx_DS_Document_Detail.ITEMS();
                        if (String.isNotEmpty(quoteLine.ensxtx_SAP_SaveSalesDocItem__c)) {
                            salesDocItem = (ensxtx_DS_Document_Detail.ITEMS) JSON.deserialize(quoteLine.ensxtx_SAP_SaveSalesDocItem__c, ensxtx_DS_Document_Detail.ITEMS.class);
                        }
                        salesDocItem.isAdded = true;
                        mapSalesDocLineItemFields(salesDocDetail, salesDocItem, quoteLine, appSettings, itemNumberMap, productFeaturesMap, deletedItemNumbers);
                        salesDocDetail.ITEMS.add(salesDocItem);
                    }
                }
            }
        }

        return salesDocDetail;
    }

    private void mapSalesDocLineItemFields(
        ensxtx_DS_Document_Detail salesDocDetail,
        ensxtx_DS_Document_Detail.ITEMS salesDocItem,
        SBQQ__QuoteLine__c quoteLine,
        ensxtx_DS_SalesDocAppSettings appSettings,
        Map<String, Integer> itemNumberMap,
        Map<Id, SObject> productFeaturesMap,
        Set<Integer> deletedItemNumbers)
    {
        // Mapping of item fields from Sobject line items

        // Add new item not on SAP document
        if (salesDocItem.isChanged != true) {
            String sapMaterial = getMaterial(null, quoteLine);
            salesDocItem.Material = sapMaterial;
            salesDocItem.ItemDescription =  String.isEmpty(quoteLine.SBQQ__Description__c) ? '' : quoteLine.SBQQ__Description__c.replace('</div>','\n').replaceAll('<[^>]+>',' ').unescapeHtml4();
        }

        // Update existing or Add new item for SAP document
        salesDocItem.NetItemPrice = quoteLine.SBQQ__ListPrice__c;
        salesDocItem.OrderQuantity = quoteLine.SBQQ__Quantity__c;
        String configurableMaterialField = ensxtx_UTIL_SFProduct.getConfigurableMaterialField();
        if (quoteLine.SBQQ__Product__c != null && String.isNotEmpty(configurableMaterialField)) salesDocItem.ConfigurableMaterial = (Boolean) ((Product2) quoteLine.SBQQ__Product__r).get(configurableMaterialField);
        String bomMaterialField = ensxtx_UTIL_SFProduct.getBOMMaterialField();
        if (quoteLine.SBQQ__Product__c != null && String.isNotEmpty(bomMaterialField)) salesDocItem.BOMMaterial = (Boolean) ((Product2) quoteLine.SBQQ__Product__r).get(bomMaterialField);

        salesDocItem.PARTNERS = ensxtx_UTIL_SalesDoc.convertAppSettingPartnersToPartners(appSettings.Item.PartnerPickers);
        salesDocItem.ItemTexts = ensxtx_UTIL_SalesDoc.convertAppSettingTextsToTexts(appSettings.Item.Texts, salesDocDetail.CustomerLanguage);
    
        if (String.isNotEmpty(quoteLine.ensxtx_SAP_Configuration__c)) {
            ensxtx_DS_Document_Detail.CPQ_VC_ITEM_CONFIGURATION cpqItemConfig = (ensxtx_DS_Document_Detail.CPQ_VC_ITEM_CONFIGURATION) JSON.deserialize(quoteLine.ensxtx_SAP_Configuration__c,ensxtx_DS_Document_Detail.CPQ_VC_ITEM_CONFIGURATION.class);
            salesDocItem.ItemConfigurations = cpqItemConfig.selectedCharacteristics;
            salesDocItem.vcSummaryJSON = JSON.serialize(cpqItemConfig.vcSummary);
            salesDocItem.OptionConfigurationKeys = cpqItemConfig.OptionConfigurationKeys;
        }

        Boolean isChild = quoteLine.SBQQ__DynamicOptionId__c != null && 
            quoteLine.SBQQ__DynamicOptionId__c.contains(':') &&
            productFeaturesMap.containsKey(quoteLine.SBQQ__DynamicOptionId__c.split(':')[0]);
        salesDocItem.ItemNumber = quoteLine.ensxtx_Created_SAP_Item_Number__c;
        itemNumberMap = setItemNumbers(salesDocItem, itemNumberMap, appSettings.itemNumberIncrement, appSettings.bomItemNumberIncrement, isChild, deletedItemNumbers);

        salesDocItem.SFId = quoteLine.Id;
        salesDocItem.CPQNumber = quoteLine.SBQQ__Number__c;
        salesDocItem.ProductId = quoteLine.SBQQ__Product__c;
    }

    @testVisible
    private Map<String, Integer> setItemNumbers(
        ensxtx_DS_Document_Detail.ITEMS salesDocItem, 
        Map<String, Integer> itemNumberMap, 
        Integer increment,
        Integer bomItemNumberIncrement,
        Boolean isChild,
        Set<Integer> deletedItemNumbers)
    {
        Integer itemNumber = itemNumberMap.get('itemNumber');
        Integer bomItemNumber = itemNumberMap.get('bomItemNumber');
        if (isChild) {
            bomItemNumber += bomItemNumberIncrement;
            if (String.isNotEmpty(salesDocItem.ItemNumber)) bomItemNumber = Integer.valueOf(salesDocItem.ItemNumber) - itemNumber;
            while (deletedItemNumbers.contains(itemNumber + bomItemNumber)) bomItemNumber += bomItemNumberIncrement;
            salesDocItem.ItemNumber = String.valueOf(itemNumber + bomItemNumber);
            salesDocItem.HigherLevelItemNumber = String.valueOf(itemNumber);
            salesDocItem.BillOfMaterial = String.valueOf(itemNumber);
        }
        else {
            itemNumber += increment;
            if (String.isNotEmpty(salesDocItem.ItemNumber)) itemNumber = Integer.valueOf(salesDocItem.ItemNumber);
            while (deletedItemNumbers.contains(itemNumber + bomItemNumber)) itemNumber += increment;
            salesDocItem.ItemNumber = String.valueOf(itemNumber);
            salesDocItem.HigherLevelItemNumber = '000000';
            bomItemNumber = 0;
        }

        itemNumberMap.put('itemNumber', itemNumber);
        itemNumberMap.put('bomItemNumber', bomItemNumber);
        return itemNumberMap;
    }

    public SObject salesDocMappingToSObject(
        SObject sfSObject, 
        ensxtx_DS_Document_Detail salesDocDetail,
        ensxtx_DS_SalesDocAppSettings appSettings)
    {
        SBQQ__Quote__c quote = (SBQQ__Quote__c) sfSObject;
        
        if (String.isNotEmpty(salesDocDetail.SalesDocument)) {
            quote.SBQQ__Status__c = 'Accepted';           

            if (appSettings.SAPDocType == 'Quote') {
                quote.put(ensxtx_UTIL_SFCPQQuote.QuoteFieldName, salesDocDetail.SalesDocument);
            }
            else if (appSettings.SAPDocType == 'Order') {
                quote.put(ensxtx_UTIL_SFCPQQuote.OrderFieldName, salesDocDetail.SalesDocument);
            }
            else if (appSettings.SAPDocType == 'Contract') {
                quote.put(ensxtx_UTIL_SFCPQQuote.ContractFieldName, salesDocDetail.SalesDocument);
            }
            else if (appSettings.SAPDocType == 'Credit Memo') {
                quote.put(ensxtx_UTIL_SFCPQQuote.CreditMemoFieldName, salesDocDetail.SalesDocument);
            }
            else if (appSettings.SAPDocType == 'Debit Memo') {
                quote.put(ensxtx_UTIL_SFCPQQuote.DebitMemoFieldName, salesDocDetail.SalesDocument);
            }
            else if (appSettings.SAPDocType == 'Inquiry') {
                quote.put(ensxtx_UTIL_SFCPQQuote.InquiryFieldName, salesDocDetail.SalesDocument);
            }
            else if (appSettings.SAPDocType == 'Return Order') {
                quote.put(ensxtx_UTIL_SFCPQQuote.ReturnOrderFieldName, salesDocDetail.SalesDocument);
            }
        }
        
        if (salesDocDetail.IsSuccess) {
            ensxtx_DS_Document_Detail copySalesDocDetail = salesDocDetail.cloneHeader();
            if (appSettings.SAPDocType == 'Quote') quote.ensxtx_Document_Type__c = salesDocDetail.SALES.SalesDocumentType;
            quote.ensxtx_Sales_Organization__c = salesDocDetail.SALES.SalesOrganization;
            quote.ensxtx_Distribution_Channel__c = salesDocDetail.SALES.DistributionChannel;
            quote.ensxtx_Division__c = salesDocDetail.SALES.Division;
            ensxtx_DS_Document_Detail.PARTNERS shipToPartner = ensxtx_UTIL_SalesDoc.getPartnerFromDocumentDetail(salesDocDetail.PARTNERS, ensxtx_UTIL_Customer.SHIP_TO_PARTNER_CODE, false);
            if (shipToPartner != null) quote.ensxtx_Ship_To_Number__c = shipToPartner.CustomerNumber;
            quote.ensxtx_SAP_SaveSalesDocHeader__c = JSON.serialize(copySalesDocDetail);
        }
        
        return quote;
    }

    public void salesDocLineItemMappingToSObject(
        SObject sfSObject, 
        ensxtx_DS_SalesDocAppSettings appSettings, 
        Map<String,Map<String,Object>> lineItemsMap)
    {
        Map<String, SBQQ__QuoteLine__c> upsertMap = new Map<String, SBQQ__QuoteLine__c>();
        List<String> keyList = new List<String>(lineItemsMap.keySet());
        Integer keyTot = keyList.size();
        List<String> sortItemNumberList = new List<String>();
        for (Integer keyCnt = 0 ; keyCnt < keyTot ; keyCnt++)
        {
            String key = keyList[keyCnt];
            Map<String,Object> objectMap = lineItemsMap.get(key);

            ensxtx_DS_Document_Detail.ITEMS salesDocItem = (ensxtx_DS_Document_Detail.ITEMS) objectMap.get('salesDocItem');
            if (salesDocItem != null) sortItemNumberList.add(salesDocItem.ItemNumber);
        }
        sortItemNumberList.sort();

        for (Integer keyCnt = 0 ; keyCnt < keyTot ; keyCnt++)
        {
            String key = keyList[keyCnt];
            Map<String,Object> objectMap = lineItemsMap.get(key);

            ensxtx_DS_Document_Detail.ITEMS salesDocItem = (ensxtx_DS_Document_Detail.ITEMS) objectMap.get('salesDocItem');
            
            if (objectMap.containsKey('clearSfLineItem')) 
            {
                SBQQ__QuoteLine__c quoteLine = (SBQQ__QuoteLine__c) objectMap.get('clearSfLineItem');
                quoteLine.ensxtx_Created_SAP_Item_Number__c = null;
                upsertMap.put(key, quoteLine);
            } 
            else if (String.isEmpty(salesDocItem.BillOfMaterial) || Integer.valueOf(salesDocItem.HigherLevelItemNumber) == 0 || objectMap.containsKey('sfLineItem'))
            {
                SBQQ__QuoteLine__c quoteLine;
                if (objectMap.containsKey('sfLineItem')) {
                    quoteLine = (SBQQ__QuoteLine__c) objectMap.get('sfLineItem');
                }
                else 
                {
                    PricebookEntry materialEntry = (PricebookEntry) objectMap.get('materialEntry');
                    quoteLine = new SBQQ__QuoteLine__c();
                    quoteLine.SBQQ__Quote__c = (Id) sfSObject.get('Id');
                    quoteLine.SBQQ__PricebookEntryId__c = materialEntry.Id;
                    quoteLine.SBQQ__Product__c = materialEntry.Product2Id;
                }

                quoteLine.SBQQ__Description__c = salesDocItem.ItemDescription;
                quoteLine.SBQQ__Quantity__c = salesDocItem.OrderQuantity;
                quoteLine.SBQQ__NetPrice__c = salesDocItem.NetItemPrice;
                if (String.isNotEmpty(salesDocItem.SalesDocumentNumber)) quoteLine.ensxtx_Created_SAP_Item_Number__c = salesDocItem.ItemNumber;
                quoteLine.ensxtx_SAP_SaveSalesDocItem__c = JSON.serialize(salesDocItem);

                ensxtx_DS_Document_Detail.CPQ_VC_ITEM_CONFIGURATION cpqItemConfig = new ensxtx_DS_Document_Detail.CPQ_VC_ITEM_CONFIGURATION();
                if (String.isNotEmpty(quoteLine.ensxtx_SAP_Configuration__c)) {
                    cpqItemConfig = (ensxtx_DS_Document_Detail.CPQ_VC_ITEM_CONFIGURATION) JSON.deserialize(quoteLine.ensxtx_SAP_Configuration__c,ensxtx_DS_Document_Detail.CPQ_VC_ITEM_CONFIGURATION.class);
                }
                cpqItemConfig.selectedCharacteristics = salesDocItem.ItemConfigurations;

                quoteLine.ensxtx_SAP_Configuration__c = JSON.serialize(cpqItemConfig);

                upsertMap.put(key, quoteLine);
            }
        }
        
        SBQQ.TriggerControl.disable();
        if (upsertMap.size() > 0 && !Test.isRunningTest()) upsert upsertMap.values();
        SBQQ.TriggerControl.enable();
    }
    
    public ensxtx_UTIL_SalesDoc.compareSAPSimulateVsSObject compareSAPSimulateVsSObject(
        ensxtx_DS_Document_Detail salesDocDetail, 
        ensxtx_DS_Document_Detail salesDocDetailFromSF, 
        ensxtx_DS_SalesDocAppSettings appSettings)
    {
        Map<Integer, Map<String, List<ensxtx_DS_Document_Detail.ITEMS>>> parentItemsMap = new Map<Integer, Map<String, List<ensxtx_DS_Document_Detail.ITEMS>>>();
        Map<Integer, Integer> higherLevelMap = new Map<Integer, Integer>();
        Integer sapTot = salesDocDetail.ITEMS.size();
        for (Integer sapCnt = 0 ; sapCnt < sapTot ; sapCnt++) {
            ensxtx_DS_Document_Detail.ITEMS sapItem = salesDocDetail.ITEMS[sapCnt];
            Integer parentItemNumber = Integer.valueOf(sapItem.HigherLevelItemNumber) > 0 ? Integer.valueOf(sapItem.HigherLevelItemNumber) : Integer.valueOf(sapItem.ItemNumber);
            if (higherLevelMap.containsKey(parentItemNumber)) parentItemNumber = higherLevelMap.get(parentItemNumber);
            if (parentItemNumber != Integer.valueOf(sapItem.ItemNumber)) higherLevelMap.put(Integer.valueOf(sapItem.ItemNumber), parentItemNumber);
            Map<String, List<ensxtx_DS_Document_Detail.ITEMS>> materialMap = parentItemsMap.containsKey(parentItemNumber) ? 
                parentItemsMap.get(parentItemNumber) : new Map<String, List<ensxtx_DS_Document_Detail.ITEMS>>();
            List<ensxtx_DS_Document_Detail.ITEMS> itemList = materialMap.containsKey(sapItem.MaterialEntered) ?
                materialMap.get(sapItem.MaterialEntered) : new List<ensxtx_DS_Document_Detail.ITEMS>();
            itemList.add(sapItem);
            materialMap.put(sapItem.MaterialEntered, itemList);
            parentItemsMap.put(parentItemNumber, materialMap);
        }

        List<Map<String, String>> changeMessageList = new List<Map<String, String>>();
        Map<Integer, ensxtx_DS_Document_Detail.ITEMS> itemNumberMap = new Map<Integer, ensxtx_DS_Document_Detail.ITEMS>();
        Integer sfTot = salesDocDetailFromSF.ITEMS.size();
        for (Integer sfCnt = 0 ; sfCnt < sfTot ; sfCnt++) {
            ensxtx_DS_Document_Detail.ITEMS sfItem = salesDocDetailFromSF.ITEMS[sfCnt];
            itemNumberMap.put(Integer.valueOf(sfItem.ItemNumber), sfItem);
            Integer parentItemNumber = Integer.valueOf(sfItem.HigherLevelItemNumber) > 0 ? Integer.valueOf(sfItem.HigherLevelItemNumber) : Integer.valueOf(sfItem.ItemNumber);
            Map<String, List<ensxtx_DS_Document_Detail.ITEMS>> materialMap = parentItemsMap.get(parentItemNumber);
            List<ensxtx_DS_Document_Detail.ITEMS> itemList = materialMap != null ? materialMap.get(sfItem.Material) : new List<ensxtx_DS_Document_Detail.ITEMS>();
            ensxtx_DS_Document_Detail.ITEMS sapItem = itemList != null && itemList.size() > 0 ? itemList[0] : null;

            // Customer specific status check messages to compare SAP returned fields with what is currently in Salesforce

            String message = '';
            Boolean listChanged = sapItem != null && String.isEmpty(sfItem.RejectionReason) && sfItem.NetItemPrice != sapItem.NetItemPrice && !sfItem.isPriceEditable;
            Boolean costChanged = sapItem != null && String.isEmpty(sfItem.RejectionReason) && sfItem.CostInDocCurrency != sapItem.CostInDocCurrency;
            Boolean quantityChanged = sapItem != null && String.isEmpty(sfItem.RejectionReason) && sfItem.OrderQuantity != sapItem.OrderQuantity;
            ensxtx_DS_Document_Detail.ITEMS parentItem = itemNumberMap.get(Integer.valueOf(sfItem.HigherLevelItemNumber));
            if (listChanged && costChanged && quantityChanged) {
                message = System.Label.ensxtx_SalesDoc_Status_Message_ListCostQtyChanged;
            } else if (listChanged && costChanged) {
                message = System.Label.ensxtx_SalesDoc_Status_Message_ListCostChanged;
            } else if (listChanged && quantityChanged) {
                message = System.Label.ensxtx_SalesDoc_Status_Message_ListQtyChanged;
            } else if (costChanged && quantityChanged) {
                message = System.Label.ensxtx_SalesDoc_Status_Message_CostQtyChanged;
            } else if (listChanged) {
                message = System.Label.ensxtx_SalesDoc_Status_Message_ListChanged;
            } else if (costChanged) {
                message = System.Label.ensxtx_SalesDoc_Status_Message_CostChanged;
            } else if (quantityChanged) {
                message = System.Label.ensxtx_SalesDoc_Status_Message_QtyChanged;
            } else if (sapItem == null) {
                message = System.Label.ensxtx_SalesDoc_Status_Message_SapMissing;
            }
            if (String.isNotEmpty(message)) {
                message = String.format(message, new List<String>{
                    ' ' + String.valueOf(sfItem.CPQNumber) + ' ', 
                    ' ' + sfItem.Material, 
                    parentItem == null ? '' : ' ' + String.format(System.Label.ensxtx_SalesDoc_Status_Message_WithParent, new List<String>{String.valueOf(parentItem.CPQNumber), parentItem.Material})});
                Map<String, String> messageMap = new Map<String, String>();
                messageMap.put('messageType', 'WARNING');
                messageMap.put('message', message);
                changeMessageList.add(messageMap);
            }
            if (sapItem != null) {
                itemList.remove(0);
                materialMap.put(sfItem.Material, itemList);
                parentItemsMap.put(parentItemNumber, materialMap);
            }
        }
        List<Integer> parentKeyList = new List<Integer>(parentItemsMap.keySet());
        Integer pTot = parentKeyList.size();
        for (Integer pCnt = 0 ; pCnt < pTot ; pCnt++) {
            Map<String, List<ensxtx_DS_Document_Detail.ITEMS>> materialMap = parentItemsMap.get(parentKeyList[pCnt]);
            List<String> materialKeyList = new List<String>(materialMap.keySet());
            Integer mTot = materialKeyList.size();
            for (Integer mCnt = 0 ; mCnt < mTot ; mCnt++) {
                List<ensxtx_DS_Document_Detail.ITEMS> itemList = materialMap.get(materialKeyList[mCnt]);
                sapTot = itemList.size();
                for (Integer sapCnt = 0 ; sapCnt < sapTot ; sapCnt++) {
                    ensxtx_DS_Document_Detail.ITEMS sapItem = itemList[sapCnt];
                    ensxtx_DS_Document_Detail.ITEMS parentItem = itemNumberMap.get(Integer.valueOf(sapItem.HigherLevelItemNumber));
                    String message = String.format(System.Label.ensxtx_SalesDoc_Status_Message_SalesforceMissing, new List<String>{
                        ' ' + sapItem.Material, 
                        parentItem == null ? '' : ' ' + String.format(System.Label.ensxtx_SalesDoc_Status_Message_WithParent, new List<String>{String.valueOf(parentItem.CPQNumber), parentItem.Material})});
                    Map<String, String> messageMap = new Map<String, String>();
                    messageMap.put('messageType', 'WARNING');
                    messageMap.put('message', message);
                    changeMessageList.add(messageMap);
                }
            }
        }

        ensxtx_UTIL_SalesDoc.compareSAPSimulateVsSObject compareSAPSimulateVsSObject = new ensxtx_UTIL_SalesDoc.compareSAPSimulateVsSObject();
        compareSAPSimulateVsSObject.changeMessageList = changeMessageList;
        return compareSAPSimulateVsSObject;
    }
    
    public Void mapCustomPricingToSalesDoc(
        ensxtx_DS_Document_Detail salesDocDetail, 
        ensxtx_DS_SalesDocAppSettings appSettings)
    {
        Integer itemTot = salesDocDetail.ITEMS.size();
        for (Integer itemCnt = 0 ; itemCnt < itemTot ; itemCnt++) {
            ensxtx_UTIL_CPQ_QuotePricingV2.mapSalesDocumentItemPricing(salesDocDetail.ITEMS[itemCnt]);
        }
    }

    public ensxtx_DS_Document_Detail mapChildBomFields(
        ensxtx_DS_Document_Detail salesDocDetail, 
        ensxtx_DS_Document_Detail salesDocDetailFromSF, 
        ensxtx_DS_SalesDocAppSettings appSettings)
    {
        Map<Integer, ensxtx_DS_Document_Detail.ITEMS> itemsMap = new Map<Integer, ensxtx_DS_Document_Detail.ITEMS>();
        Map<Integer, Map<String, List<ensxtx_DS_Document_Detail.ITEMS>>> parentItemsMap = new Map<Integer, Map<String, List<ensxtx_DS_Document_Detail.ITEMS>>>();
        Integer sapTot = salesDocDetail.ITEMS.size();
        for (Integer sapCnt = 0 ; sapCnt < sapTot ; sapCnt++) {
            ensxtx_DS_Document_Detail.ITEMS sapItem = salesDocDetail.ITEMS[sapCnt];
            Integer parentItemNumber = Integer.valueOf(sapItem.HigherLevelItemNumber) > 0 ? Integer.valueOf(sapItem.HigherLevelItemNumber) : Integer.valueOf(sapItem.ItemNumber);
            Map<String, List<ensxtx_DS_Document_Detail.ITEMS>> materialMap = parentItemsMap.containsKey(parentItemNumber) ? 
                parentItemsMap.get(parentItemNumber) : new Map<String, List<ensxtx_DS_Document_Detail.ITEMS>>();
            List<ensxtx_DS_Document_Detail.ITEMS> itemList = materialMap.containsKey(sapItem.MaterialEntered) ?
                materialMap.get(sapItem.MaterialEntered) : new List<ensxtx_DS_Document_Detail.ITEMS>();
            itemList.add(sapItem);
            materialMap.put(sapItem.MaterialEntered, itemList);
            parentItemsMap.put(parentItemNumber, materialMap);
        }

        Boolean needSimulate = false;
        Map<Integer, ensxtx_DS_Document_Detail.ITEMS> itemNumberMap = new Map<Integer, ensxtx_DS_Document_Detail.ITEMS>();
        Integer sfTot = salesDocDetailFromSF.ITEMS.size();
        for (Integer sfCnt = 0 ; sfCnt < sfTot ; sfCnt++) {
            ensxtx_DS_Document_Detail.ITEMS sfItem = salesDocDetailFromSF.ITEMS[sfCnt];
            itemNumberMap.put(Integer.valueOf(sfItem.ItemNumber), sfItem);
            Integer parentItemNumber = Integer.valueOf(sfItem.HigherLevelItemNumber) > 0 ? Integer.valueOf(sfItem.HigherLevelItemNumber) : Integer.valueOf(sfItem.ItemNumber);
            Map<String, List<ensxtx_DS_Document_Detail.ITEMS>> materialMap = parentItemsMap.get(parentItemNumber);
            List<ensxtx_DS_Document_Detail.ITEMS> itemList = materialMap != null ? materialMap.get(sfItem.Material) : new List<ensxtx_DS_Document_Detail.ITEMS>();
            ensxtx_DS_Document_Detail.ITEMS sapItem = itemList != null && itemList.size() > 0 ? itemList[0] : null;
            if (sapItem != null) {
                itemList.remove(0);
                materialMap.put(sfItem.Material, itemList);
                parentItemsMap.put(parentItemNumber, materialMap);
                sapItem.BOMMaterial = sfItem.BOMMaterial;
                sapItem.CPQNumber = sfItem.CPQNumber;
                sapItem.isAdded = sfItem.isAdded;
                sapItem.Plant = sfItem.Plant;
                sapItem.ProductId = sfItem.ProductId;
                sapItem.SFId = sfItem.SFId;
                ensxtx_DS_Document_Detail.ITEMS parentItem = itemNumberMap.get(Integer.valueOf(sfItem.HigherLevelItemNumber));
                if (parentItem != null) {
                    needSimulate = needSimulate || (sapItem.RejectionReason != sfItem.RejectionReason);
                    sapItem.RejectionReason = sfItem.RejectionReason;

                    // Customer specific Bom fields to be mapped from Salesfroce to SAP

                    // sapItem.isPriceEditable = sfItem.isPriceEditable;
                    // ensxtx_DS_Document_Detail.TEXTS sfText = null;
                    // Integer txtTot = sfItem.ItemTexts.size();
                    // for (Integer txtCnt = 0 ; txtCnt < txtTot ; txtCnt++) {
                    //     if (sfItem.ItemTexts[txtCnt].TextID == '0001') {
                    //         sfText = sfItem.ItemTexts[txtCnt];
                    //         break;
                    //     }
                    // }
                    // txtTot = sapItem.ItemTexts.size();
                    // for (Integer txtCnt = 0 ; txtCnt < txtTot ; txtCnt++) {
                    //     if (sapItem.ItemTexts[txtCnt].TextID == '0001') {
                    //         sapItem.ItemTexts.remove(txtCnt);
                    //         break;
                    //     }
                    // }
                    // if (sfText != null) sapItem.ItemTexts.add(sfText);

                    // ensxtx_DS_Document_Detail.CONDITIONS sfCond = null;
                    // Integer condTot = sfItem.ItemConditions.size();
                    // for (Integer condCnt = 0 ; condCnt < condTot ; condCnt++) {
                    //     if (sfItem.ItemConditions[condCnt].ConditionType == 'PR00') {
                    //         sfCond = sfItem.ItemConditions[condCnt];
                    //         break;
                    //     }
                    // }
                    // Decimal sapRate = null;
                    // condTot = sapItem.ItemConditions.size();
                    // for (Integer condCnt = 0 ; condCnt < condTot ; condCnt++) {
                    //     if (sapItem.ItemConditions[condCnt].ConditionType == 'PR00') {
                    //         sapRate = sapItem.ItemConditions[condCnt].Rate;
                    //         sapItem.ItemConditions.remove(condCnt);
                    //         break;
                    //     }
                    // }
                    // if ((sfCond == null && sapRate != null) || (sfCond != null && sapRate == null) || (sfCond != null && sapRate != null && sfCond.Rate != sapRate)) needSimulate = true;
                    // if (sfCond != null) sapItem.ItemConditions.add(sfCond);
                }
                itemsMap.put(Integer.valueOf(sapItem.ItemNumber),sapItem);
            }
        }
        salesDocDetail.ITEMS.clear();
        salesDocDetail.ITEMS.addAll(itemsMap.values());
        salesDocDetail.NeedToSimulate = (salesDocDetail.NeedToSimulate != null && salesDocDetail.NeedToSimulate) || needSimulate;
        return salesDocDetail;
    }
}