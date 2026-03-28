public without sharing class ensxtx_UTIL_SFWebCart implements ensxtx_I_SFSObjectDoc
{
    private static final ensxsdk.Logger logger = new ensxsdk.Logger(ensxtx_UTIL_SFWebCart.class);

    private SObject loadedSObject;
    private Id loadedId;
    private string loadedSapType;
    private string loadedSapDocNum;
    private Map<Id, SObject> loadedLineMap;

    // Returns the field name which stores the SAP Quote number
    // The default is from the EDM package or from the AppSettings
    public static String QuoteFieldName
    {
        get
        {
            return null;
        }
    }

    // Returns the field name which stores the SAP Order number
    // The default is from the EDM package or from the AppSettings
    public static String OrderFieldName
    {
        get
        {
            return null;
        }
    }

    // Returns the field name which stores the SAP Contract number
    // The default is from the EDM package or from the AppSettings
    public static String ContractFieldName
    {
        get
        {
            return null;
        }
    }

    public Object callReturnMethod(String method, Map<String, Object> params)
    {
        return null;
    }

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
                string selectCmd = 'SELECT Id, Name, SAP_Salesorg__c, Sold_To_Customer__c, PO_Date__c, PoNumber__c, Deliver_On__c, Payment_Terms__c,Shipping_Conditions__c,TotalAmount, Coupon__c, New_registered_user_discount__c, Shipping_Amount__c, Coupon_Discount__c, AccountId, PoNumber, LastModifiedDate, Status';
                selectCmd += ensxtx_UTIL_SObject.selectCurrencyField('WebCart');
                selectCmd += ' FROM WebCart';
                if (id != null)
                {
                    selectCmd += ' WHERE Id = \'' + id + '\'';
                    errorString = ' for the provided Id ' + id;
                }
                else
                {
                    if (sapType == 'Quote')
                    {
                        selectCmd += ' WHERE ' + ensxtx_UTIL_SFWebCart.QuoteFieldName + ' = \'' + sapDocNum + '\'';
                        errorString = ' for the provided SAP Quote Number ' + sapDocNum;
                    }
                    else if (sapType == 'Order')
                    {
                        selectCmd += ' WHERE ' + ensxtx_UTIL_SFWebCart.OrderFieldName + ' = \'' + sapDocNum + '\'';
                        errorString = ' for the provided SAP Order Number ' + sapDocNum;
                    }
                    else if (sapType == 'Contract')
                    {
                        selectCmd += ' WHERE ' + ensxtx_UTIL_SFWebCart.ContractFieldName + ' = \'' + sapDocNum + '\'';
                        errorString = ' for the provided SAP Contract Number ' + sapDocNum;
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
                'There was an issue retrieving an WebCart record: ' + errorString);
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
            String configurableMaterialField = ensxtx_UTIL_SFProduct.getConfigurableMaterialField();
            String bomMaterialField = ensxtx_UTIL_SFProduct.getBOMMaterialField();

            string selectCmd = 'SELECT Id, CartId, Product2Id, Product2.' + ensxtx_UTIL_SFProduct.MaterialFieldName + ', Quantity, ' +
            ' ensxtx_SAP_Item_JSON__c, Description__c, Material_Entered__c, NetUnitPrice,  TotalPrice, Plant__c, Requested_Delivery_Date__c, ' +
            ' Net_Weight__c, Price_List_Type__c, Product2.Item_Category_Group_ID__c, Reason_for_Rejection__c, Tax__c, Discount__c, Shipping_amount__c ';

            if (String.isNotEmpty(configurableMaterialField)) selectCmd += ', Product2.' + configurableMaterialField;

            if (String.isNotEmpty(bomMaterialField)) selectCmd += ', Product2.' + bomMaterialField;

            selectCmd += ' FROM CartItem WHERE CartId = :id';
            
            List<SObject> lineList = Database.query(selectCmd);

            lineMap = new Map<Id, SObject>(lineList);
		}
		catch (Exception e) { ensxtx_UTIL_PageMessages.addExceptionMessage(e); }
        loadedLineMap = lineMap;
        return lineMap;
	}

    public Map<Id, SObject> getSObjectContacts(Id id)
    {
		//Implement to get Contact link to SObject
		return new Map<Id, SObject>();
    }

	public String getAccountId(SObject sfSObject)
	{
        return sfSObject == null || sfSObject.getSObjectType().getDescribe().getName() != 'WebCart' ? null : ((WebCart) sfSObject).AccountId;
	}

    public String getCustomerNumber(SObject sfSObject)
	{
        Account acct = new Account();
        try {
            String acctId = getAccountId(sfSObject);
            String selectCmd = 'SELECT Id, ' + ensxtx_UTIL_SFAccount.CustomerFieldName + ' FROM ACCOUNT WHERE Id =: acctId';
            List<Account> acctList = Database.query(selectCmd);
            acct = acctList[0];
        }
        catch (Exception e) {}
        return (String) acct.get(ensxtx_UTIL_SFAccount.CustomerFieldName);
	}

	public String getName(SObject sfSObject)
	{
        return sfSObject == null || sfSObject.getSObjectType().getDescribe().getName() != 'WebCart' ? '' : ((WebCart) sfSObject).Name;
	}

    public String getQuoteNumber(SObject sfSObject)
    {
        return '';
    }

    public String getOrderNumber(SObject sfSObject)
    {
        return '';
    }

    public String getContractNumber(SObject sfSObject)
    {
        return '';
    }

    public String getInquiryNumber(SObject sfSObject)
    {
        return '';
    }

    public String getCreditMemoNumber(SObject sfSObject)
    {
        return '';
    }

    public String getDebitMemoNumber(SObject sfSObject)
    {
        return '';
    }

    public String getReturnOrderNumber(SObject sfSObject)
    {
        return '';
    }

    public String getStatus(SObject sfSObject)
    {
        return sfSObject == null || sfSObject.getSObjectType().getDescribe().getName() != 'WebCart' ? '' : 'Simulate';
    }

    public String getOpportunityId(SObject sfSObject)
    {
        return null;
    }

    public Id getPriceBookId(SObject sfSObject)
    {
        return null;
    }

    public Id getProductId(SObject sfsObjectLine)
    {
        return sfsObjectLine == null || sfsObjectLine.getSObjectType().getDescribe().getName() != 'CartItem' ? null : ((CartItem) sfsObjectLine).Product2Id;
    }

    public String getMaterial(SObject sfSObject, SObject sfsObjectLine)
    {
        return sfsObjectLine == null || sfsObjectLine.getSObjectType().getDescribe().getName() != 'CartItem' || ((CartItem) sfsObjectLine).Product2 == null ? null : (String) ((CartItem) sfsObjectLine).Product2.get(ensxtx_UTIL_SFProduct.MaterialFieldName);
    }

    public String getItemNumber(SObject sfsObjectLine)
    {
        return '';
    }

    public ensxtx_DS_Document_Detail sObjectToSalesDocMapping(
        SObject sfSObject,
        List<SObject> sfLineItems,
        ensxtx_DS_Document_Detail salesDocDetail,
        ensxtx_DS_SalesDocAppSettings appSettings)
    {
        //Do the mapping from SObject and SF Line Items to salesDocDetail here
        WebCart cart = (WebCart) sfSObject;
        salesDocDetail.SFId = cart.Id;

        if (cart.Status == 'Closed') return salesDocDetail;

        // Mapping of header fields from SObject
        //String soldToNumber = getCustomerNumber(sfSObject);    
        String soldToNumber= cart.Sold_To_Customer__c;
        salesDocDetail.SoldToParty = soldToNumber;
        salesDocDetail.SalesDocumentCurrency = ensxtx_UTIL_SObject.getCurrencyIsoCode('WebCart', cart);
        salesDocDetail.CustomerPurchaseOrderDate = cart.PO_Date__c;
        salesDocDetail.CustomerPurchaseOrderNumber = cart.PoNumber__c;

        salesDocDetail.NeedToSimulate = true;

        salesDocDetail.SALES.SalesDocumentType = appSettings.DefaultDocType;
        salesDocDetail.SALES.SalesOrganization = cart.SAP_Salesorg__c;
        salesDocDetail.SALES.DistributionChannel = appSettings.DefaultDistributionChannel;
        salesDocDetail.SALES.Division = appSettings.DefaultDivision;

        salesDocDetail.SALES.RequestedDeliveryDate = cart.Deliver_On__c;
        salesDocDetail.SALES.TermsofPaymentKey = cart.Payment_Terms__c;
        salesDocDetail.ShippingConditions = cart.Shipping_Conditions__c;
        salesDocDetail.Cupon = cart.Coupon__c;
        salesDocDetail.NetOrderValue= cart.TotalAmount;
        if(cart.Shipping_Conditions__c == 'AC' || cart.Shipping_Conditions__c == 'AF') {
            salesDocDetail.SALES.PriceListType = 'DF';
        }
        else if(cart.New_registered_user_discount__c == true) salesDocDetail.SALES.PriceListType = 'PT P Code PT= 5.0';

        ensxtx_DS_Document_Detail.PARTNERS soldToPartner = ensxtx_UTIL_SalesDoc.getPartnerFromDocumentDetail(salesDocDetail.PARTNERS, ensxtx_UTIL_Customer.SOLD_TO_PARTNER_CODE, true);
        soldToPartner.CustomerNumber = soldToNumber;

        if (sfLineItems != null && sfLineItems.size() > 0) {
            Integer increment = appSettings.itemNumberIncrement;
            Integer itemNumber = increment;

            Integer lineItemTot = sfLineItems.size();
            for (Integer lineItemCnt = 0; lineItemCnt < lineItemTot; lineItemCnt++)
            {
                SObject sfLineItem = sfLineItems[lineItemCnt];
                CartItem ciObj = (CartItem) sfLineItem;

                String sapMaterial = ciObj.Product2 != null ? getMaterial(cart, ciObj) : null;

                Boolean isChanged = true;
                List<ensxtx_DS_Document_Detail.ITEMS> itemList = String.isNotEmpty(ciObj.ensxtx_SAP_Item_JSON__c) ? (List<ensxtx_DS_Document_Detail.ITEMS>) JSON.deserialize(ciObj.ensxtx_SAP_Item_JSON__c, List<ensxtx_DS_Document_Detail.ITEMS>.class) : new List<ensxtx_DS_Document_Detail.ITEMS>();
                for (ensxtx_DS_Document_Detail.ITEMS salesDocItem : itemList) {
                    if (salesDocItem.Material == sapMaterial && (salesDocItem.HigherLevelItemNumber == null || String.isEmpty(salesDocItem.HigherLevelItemNumber.remove('0'))) ) {
                        if (salesDocItem.OrderQuantity == ciObj.Quantity &&
                            salesDocItem.NetItemPrice == ciObj.NetUnitPrice &&
                            salesDocItem.NetOrderValue == ciObj.TotalPrice
                        ) {
                            isChanged = false;
                            break;
                        }
                    }
                }

                if ((appSettings.InvokeMethod != 'Simulate' || isChanged) && String.isNotEmpty(sapMaterial)) {
                    ensxtx_DS_Document_Detail.ITEMS salesDocItem = new ensxtx_DS_Document_Detail.ITEMS();

                    // Mapping of item fields from Sobject line items
                    salesDocItem.ItemNumber = String.valueOf(itemNumber);
                    salesDocItem.HigherLevelItemNumber = '000000';
                    salesDocItem.Material = sapMaterial;
                    salesDocItem.OrderQuantity = ciObj.Quantity;                    
                    salesDocItem.ScheduleLineDate =  ciObj.Requested_Delivery_Date__c;

                    salesDocItem.PARTNERS = ensxtx_UTIL_SalesDoc.convertAppSettingPartnersToPartners(appSettings.Item.PartnerPickers);
                    salesDocItem.ItemTexts = ensxtx_UTIL_SalesDoc.convertAppSettingTextsToTexts(appSettings.Item.Texts, salesDocDetail.CustomerLanguage);

                    salesDocItem.SFId = ciObj.Id;
                    salesDocDetail.ITEMS.add(salesDocItem);
                    itemNumber += increment;
                }
            }
        }

        return salesDocDetail;
    }

    public SObject salesDocMappingToSObject(
        SObject sfSObject, 
        ensxtx_DS_Document_Detail salesDocDetail,
        ensxtx_DS_SalesDocAppSettings appSettings)
    {
        WebCart cart = (WebCart) sfSObject;   
        cart.Shipping_amount__c = salesDocDetail.ShippingAmount;
        if(String.isNotEmpty(cart.Coupon__c)) cart.Coupon_Discount__c = salesDocDetail.CouponDiscount;           
    
        
        if (!salesDocDetail.IsSuccess) {
            List<CartValidationOutput> cvoList = new List<CartValidationOutput>();
            if (ensxtx_UTIL_PageMessages.messageList != null) {
                for (ensxtx_UTIL_PageMessages.Message message : ensxtx_UTIL_PageMessages.messageList) {
                    CartValidationOutput cvoObj = new CartValidationOutput();
                    cvoObj.CartId = cart.Id;
                    cvoObj.Level = message.messageType == ensxtx_UTIL_PageMessages.WARNING ? 'Warning' : 'Error';
                    cvoObj.Message = message.message;
                    cvoObj.Name = 'SAP Cart Pricing Error';
                    cvoObj.RelatedEntityId = cart.Id;
                    cvoObj.Type = 'Pricing';
                    cvoList.add(cvoObj);
                }
            }
            if (cvoList.size() > 0) insert cvoList;
        }

        return cart;
    }

    public void salesDocLineItemMappingToSObject(
        SObject sfSObject, 
        ensxtx_DS_SalesDocAppSettings appSettings, 
        Map<String,Map<String,Object>> lineItemsMap)
    {
        WebCart cart = (WebCart) sfSObject;      

        Map<String, CartItem> upsertMap = new Map<String, CartItem>();
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

        Map<String, List<ensxtx_DS_Document_Detail.ITEMS>> jsonItemMap = new Map<String, List<ensxtx_DS_Document_Detail.ITEMS>>();
        for (Integer keyCnt = 0 ; keyCnt < keyTot ; keyCnt++)
        {
            String key = keyList[keyCnt];
            Map<String,Object> objectMap = lineItemsMap.get(key);

            ensxtx_DS_Document_Detail.ITEMS salesDocItem = (ensxtx_DS_Document_Detail.ITEMS) objectMap.get('salesDocItem');
            if (salesDocItem != null) {          
                CartItem ciObj;
                if (objectMap.containsKey('sfLineItem')) {
                    ciObj = (CartItem) objectMap.get('sfLineItem');
                    ciObj.Description__c=salesDocItem.ItemDescription;
                    ciObj.Material_Entered__c = salesDocItem.MaterialEntered;
                    ciObj.NetUnitPrice = salesDocItem.NetItemPrice;                
                    ciObj.TotalPrice = salesDocItem.SubTotal3;
                    ciObj.Plant__c= salesDocItem.Plant;
                    ciObj.Net_Weight__c= string.valueOf(salesDocItem.NetWeight);
                    ciObj.Price_List_Type__c= salesDocItem.PriceListType;
                    ciObj.Reason_for_Rejection__c= salesDocItem.RejectionReason;
                    ciObj.Discount__c = salesDocItem.CouponDiscount;
                    ciObj.Tax__c =  salesDocItem.TaxAmount;
                    ciObj.Shipping_Amount__c = salesDocItem.shippingAmount;
                    if(salesDocItem.ItemConditions != null && salesDocItem.ItemConditions.size() > 0){
                        for(ensxtx_DS_Document_Detail.CONDITIONS condition : salesDocItem.ItemConditions){
                            if(condition.ConditionType == 'ZNET' || condition.ConditionType == 'ZCON'){
                                ciObj.Price_condition__c = condition.ConditionType;
                                break;
                            }
                        }
                    }
                }
                String jsonKey = salesDocItem.HigherLevelItemNumber == null || String.isEmpty(salesDocItem.HigherLevelItemNumber.remove('0')) ? salesDocItem.ItemNumber : salesDocItem.HigherLevelItemNumber;
                List<ensxtx_DS_Document_Detail.ITEMS> itemList = jsonItemMap.containsKey(jsonKey) ? jsonItemMap.get(jsonKey) : new List<ensxtx_DS_Document_Detail.ITEMS>();
                salesDocItem.PARTNERS = null;
                salesDocItem.ItemConditions = null;
                salesDocItem.ItemTexts = null;
                salesDocItem.ItemConfigurations = null;
                salesDocItem.SBOItemConditions = null;
                salesDocItem.BillingPlanDates = null;
                salesDocItem.ItemIncompletionLogs = null;
                itemList.add(salesDocItem);
                jsonItemMap.put(jsonKey,itemList);
            }
        }

        for (Integer keyCnt = 0 ; keyCnt < keyTot ; keyCnt++)
        {
            String key = keyList[keyCnt];
            Map<String,Object> objectMap = lineItemsMap.get(key);

            ensxtx_DS_Document_Detail.ITEMS salesDocItem = (ensxtx_DS_Document_Detail.ITEMS) objectMap.get('salesDocItem');
            if (salesDocItem != null) {          
                CartItem ciObj;
                if (objectMap.containsKey('sfLineItem')) {
                    ciObj = (CartItem) objectMap.get('sfLineItem');
                    List<ensxtx_DS_Document_Detail.ITEMS> itemList = jsonItemMap.containsKey(salesDocItem.ItemNumber) ? jsonItemMap.get(salesDocItem.ItemNumber) : new List<ensxtx_DS_Document_Detail.ITEMS>();
                    ciObj.ensxtx_SAP_Item_JSON__c = JSON.serialize(itemList, true);
                    upsertMap.put(key, ciObj);
                }
            }
        }

        if (upsertMap.size() > 0 && !Test.isRunningTest()) upsert upsertMap.values();
    }

    public ensxtx_UTIL_SalesDoc.compareSAPSimulateVsSObject compareSAPSimulateVsSObject(
        ensxtx_DS_Document_Detail salesDocDetail, 
        ensxtx_DS_Document_Detail salesDocDetailFromSF, 
        ensxtx_DS_SalesDocAppSettings appSettings)
    {
        return new ensxtx_UTIL_SalesDoc.compareSAPSimulateVsSObject();
    }
    
    public Void mapCustomPricingToSalesDoc(
        ensxtx_DS_Document_Detail salesDocDetail, 
        ensxtx_DS_SalesDocAppSettings appSettings)
    {
    }

    public ensxtx_DS_Document_Detail mapChildBomFields(
        ensxtx_DS_Document_Detail salesDocDetail, 
        ensxtx_DS_Document_Detail salesDocDetailFromSF, 
        ensxtx_DS_SalesDocAppSettings appSettings)
    {
        return null;
    }
}