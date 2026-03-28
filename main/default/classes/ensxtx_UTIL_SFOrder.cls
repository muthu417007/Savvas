public without sharing class ensxtx_UTIL_SFOrder implements ensxtx_I_SFSObjectDoc
{
    private static final ensxsdk.Logger logger = new ensxsdk.Logger(ensxtx_UTIL_SFOrder.class);

    private SObject loadedSObject;
    private Id loadedId;
    private string loadedSapType;
    private string loadedSapDocNum;
    private Map<Id, SObject> loadedLineMap;

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
                string selectCmd = 'SELECT Id, Name, Description, OpportunityId, Pricebook2Id, ensxtx_SAP_SaveSalesDocHeader__c, AccountId,' +
                    ' PoDate, PoNumber, Account.' + ensxtx_UTIL_SFAccount.CustomerFieldName + ', ensxtx_SAP_Order_Number__c,' + 
                    ' OrderNumber, ensxtx_SalesDocStatus__c, LastModifiedDate,'+
                    ' SAP_Document_Number__c, SAP_SalesOrg__c, Sold_To_Customer__c, PO_Date__c, PoNumber__c, Deliver_On__c, Shipping_Conditions__c, New_registered_user_discount__c,'+
                    ' TotalAmount, SAP_Shipto__c,ShipTo_Name__c, Order_Source__c, Use_Freight_Routing__c, ShippingStreet,ShippingState,ShippingCity,ShippingPostalCode,ShippingCountry,Has_One_Time_Ship__c, License_Partner__c, SAP_BillTo__c, Customer_Email__c, Warehouse_text__c,' +
                    ' Attention_Shipping__c, Attention_Billing__c, Shipping_instruction__c, BillingStreet, BillingState, BillingCity, BillingPostalCode, BillingCountry, Customer_Service_Comments__c, Special_EDI_Instructions__c,'+
                    'SAP_Quote_ID__c, Coupon__c, Coupon_Discount__c, Order_Reason__c,cctype__c, ccNumberEnc__c, ccExpDate__c,BillingName__c' ;
                selectCmd += ensxtx_UTIL_SObject.selectCurrencyField('Order');
                Map<String, Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get('Order').getDescribe().fields.getMap();
                if (fieldMap.containsKey('SBQQ__Quote__c')) selectCmd += ', SBQQ__Quote__c';
                selectCmd += ' FROM Order';

                if (id != null)
                {
                    selectCmd += ' WHERE Id = \'' + id + '\'';
                    errorString = ' for the provided Id ' + id;
                }
                else
                {
                    if (sapType == 'Order')
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
                'There was an issue retrieving an Order record: ' + errorString);
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
            Map<String, Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get('OrderItem').getDescribe().fields.getMap();
            Boolean isCPQ = fieldMap.containsKey('SBQQ__QuoteLine__c');

            String configurableMaterialField = ensxtx_UTIL_SFProduct.getConfigurableMaterialField();
            String bomMaterialField = ensxtx_UTIL_SFProduct.getBOMMaterialField();

            string selectCmd = 'SELECT Id, OrderId, PricebookEntryId, Product2Id, Product2.Name, ensxtx_SAP_SaveSalesDocItem__c,' +
                ' Product2.' + ensxtx_UTIL_SFProduct.MaterialFieldName + ', Quantity, SAP_Total_Price__c, UnitPrice, ListPrice,' +
                ' Description, OrderItemNumber, ensxtx_SAP_Item_Number__c,'+
                ' SAP_Item_number__c, Material_Entered__c, Plant__c, Requested_Delivery_Date__c, Net_Weight__c,'+
                ' Price_List_Type__c, Product2.Item_Category_Group_ID__c, Reason_for_Rejection__c, SAP_Order_Item_status__c, Discount__c,'+
                ' Tax__c, Shipping_amount__c';

            if (isCPQ) selectCmd += ', SBQQ__QuoteLine__c';

            if (String.isNotEmpty(configurableMaterialField)) selectCmd += ', Product2.' + configurableMaterialField;

            if (String.isNotEmpty(bomMaterialField)) selectCmd += ', Product2.' + bomMaterialField;

            selectCmd += ' FROM OrderItem WHERE OrderId = :id AND Product2Id != null ';

            if (isCPQ) selectCmd += 'ORDER BY SBQQ__QuoteLine__r.SBQQ__Number__c ASC';
            if (!isCPQ) selectCmd += 'ORDER BY ensxtx_SAP_Item_Number__c ASC';

            List<SObject> lineList = Database.query(selectCmd);
            
            lineMap = new Map<Id, SObject>(Database.query(selectCmd));
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
        return sfSObject == null || sfSObject.getSObjectType().getDescribe().getName() != 'Order' ? null : ((Order) sfSObject).AccountId;
	}

    public String getCustomerNumber(SObject sfSObject)
	{
        return sfSObject == null || sfSObject.getSObjectType().getDescribe().getName() != 'Order' || ((Order) sfSObject).Account == null ? null : (String) ((Order) sfSObject).Account.get(ensxtx_UTIL_SFAccount.CustomerFieldName);
	}

	public String getName(SObject sfSObject)
	{
        return sfSObject == null || sfSObject.getSObjectType().getDescribe().getName() != 'Order' ? '' : ((Order) sfSObject).OrderNumber;
	}

    public String getQuoteNumber(SObject sfSObject)
    {
        return '';
    }

    public String getOrderNumber(SObject sfSObject)
    {
        return sfSObject == null || sfSObject.getSObjectType().getDescribe().getName() != 'Order' ? '' : ((Order) sfSObject).ensxtx_SAP_Order_Number__c;
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
        return sfSObject == null || sfSObject.getSObjectType().getDescribe().getName() != 'Order' ? '' : ((Order) sfSObject).ensxtx_SalesDocStatus__c;
    }

    public String getOpportunityId(SObject sfSObject)
    {
        return sfSObject == null || sfSObject.getSObjectType().getDescribe().getName() != 'Order' ? null :  ((Order) sfSObject).OpportunityId;
    }

    @testVisible
    private Opportunity getOpportunity(SObject sfSObject)
    {
        return null;
    }

    public Id getPriceBookId(SObject sfSObject)
    {
        Id pricebookId;
        if (sfSObject == null || sfSObject.getSObjectType().getDescribe().getName() != 'Order') {
            return null;
        }
        else pricebookId = ((Order) sfSObject).Pricebook2Id;

        if (String.isEmpty(pricebookId)) pricebookId = ensxtx_UTIL_Pricebook.getStandardPriceBookId();

        return pricebookId;
    }

    public Id getProductId(SObject sfsObjectLine)
    {
        return sfsObjectLine == null || sfsObjectLine.getSObjectType().getDescribe().getName() != 'OrderItem' ? null : ((OrderItem) sfsObjectLine).Product2Id;
    }

    public String getMaterial(SObject sfSObject, SObject sfsObjectLine)
    {
        return sfsObjectLine == null || sfsObjectLine.getSObjectType().getDescribe().getName() != 'OrderItem' || ((OrderItem) sfsObjectLine).Product2 == null ? null : (String) ((OrderItem) sfsObjectLine).Product2.get(ensxtx_UTIL_SFProduct.MaterialFieldName);
    }

    public String getItemNumber(SObject sfsObjectLine)
    {
        return sfsObjectLine == null || sfsObjectLine.getSObjectType().getDescribe().getName() != 'OrderItem' ? '' : ((OrderItem) sfsObjectLine).ensxtx_SAP_Item_Number__c;
    }

    public ensxtx_DS_Document_Detail sObjectToSalesDocMapping(
        SObject sfSObject,
        List<SObject> sfLineItems,
        ensxtx_DS_Document_Detail salesDocDetail,
        ensxtx_DS_SalesDocAppSettings appSettings)
    {
        //Do the mapping from SObject and SF Line Items to salesDocDetail here
        if(appSettings.sfInvokeFrom == 'Commerce') {
            sObjectToSalesDocMappingForB2BOrder(sfSObject, sfLineItems, salesDocDetail, appSettings);
        }
        else {
            sObjectToSalesDocMappingForStandardOrder(sfSObject, sfLineItems, salesDocDetail, appSettings);
        }
        return salesDocDetail;
    }

    public ensxtx_DS_Document_Detail sObjectToSalesDocMappingForB2BOrder(
        SObject sfSObject,
        List<SObject> sfLineItems,
        ensxtx_DS_Document_Detail salesDocDetail,
        ensxtx_DS_SalesDocAppSettings appSettings)
    {
        //Do the mapping from SObject and SF Line Items to salesDocDetail here
        Order order = (Order) sfSObject;
        salesDocDetail.SFId = order.Id;

        // Mapping of header fields from SObject
        //String soldToNumber = getCustomerNumber(sfSObject);
        String soldToNumber =  order.Sold_To_Customer__c;           
        salesDocDetail.CustomerPurchaseOrderType = order.Order_Source__c;
        salesDocDetail.SoldToParty = soldToNumber;
        salesDocDetail.SalesDocumentCurrency = ensxtx_UTIL_SObject.getCurrencyIsoCode('Order', order);
        salesDocDetail.CustomerPurchaseOrderDate = order.PO_Date__c;
        salesDocDetail.CustomerPurchaseOrderNumber = order.PoNumber__c;
        salesDocDetail.B2BOrderFlag = true;
        salesDocDetail.NeedToSimulate = true;

        salesDocDetail.SALES.SalesDocumentType = appSettings.DefaultDocType;
        salesDocDetail.SALES.SalesOrganization = order.SAP_Salesorg__c;
        salesDocDetail.SALES.DistributionChannel = appSettings.DefaultDistributionChannel;
        salesDocDetail.SALES.Division = appSettings.DefaultDivision;

        salesDocDetail.SALES.RequestedDeliveryDate = Date.ValueOf(order.Deliver_On__c);        
        salesDocDetail.ShippingConditions = order.Shipping_Conditions__c;
        salesDocDetail.NetOrderValue= order.TotalAmount;
        salesDocDetail.YourReference = order.SAP_Quote_ID__c;
        salesDocDetail.Cupon = order.Coupon__c;
        salesDocDetail.SALES.OrderReason = order.Order_Reason__c;
        if(order.Shipping_Conditions__c == 'AC' || order.Shipping_Conditions__c == 'AF') {
            salesDocDetail.SALES.PriceListType = 'DF';
        }
        else if(order.New_registered_user_discount__c == true) salesDocDetail.SALES.PriceListType = 'PT P Code PT= 5.0';


        String SFOrganisationID=  UserInfo.getOrganizationId();

        ensxtx_DS_Document_Detail.CCARD card  = new ensxtx_DS_Document_Detail.CCARD();
        card.CreditCardType= order.cctype__c;
        card.CreditCardNumber = order.ccNumberEnc__c;
        card.ValidToDate = order.ccExpDate__c;
        card.CardholderName = order.BillingName__c;
        card.PaymentCardEntryMode = 'E';
        
        salesDocDetail.CCARD.add(card);

        ensxtx_DS_Document_Detail.PARTNERS soldToPartner = ensxtx_UTIL_SalesDoc.getPartnerFromDocumentDetail(salesDocDetail.PARTNERS, ensxtx_UTIL_Customer.SOLD_TO_PARTNER_CODE, true);
        soldToPartner.CustomerNumber = soldToNumber;
        if(order.SAP_Shipto__c != null && order.SAP_Shipto__c == '0000009' && order.SAP_BillTo__c == '0000009' && order.Sold_To_Customer__c == '0000009'){
            soldToPartner.CustomerNumber = (String) order.SAP_Shipto__c;
            soldToPartner.Street = order.ShippingStreet;
            soldToPartner.Region = order.ShippingState;
            soldToPartner.City = order.ShippingCity;
            soldToPartner.PostalCode = order.ShippingPostalCode;
            soldToPartner.Country = order.ShippingCountry;
            soldToPartner.PartnerName = order.ShipTo_Name__c;
            soldToPartner.allowAddressOverride = true;
        }

        if(order.SAP_Shipto__c != null) {
            ensxtx_DS_Document_Detail.PARTNERS shipToPartner = ensxtx_UTIL_SalesDoc.getPartnerFromDocumentDetail(salesDocDetail.PARTNERS, ensxtx_UTIL_Customer.SHIP_TO_PARTNER_CODE, true);
            shipToPartner.CustomerNumber = (String) order.SAP_Shipto__c;// .get(ensxtx_UTIL_SFAccount.CustomerFieldName);
            Boolean hasOneTimeShip = (Boolean) order.Has_One_Time_Ship__c;
            if(hasOneTimeShip || (order.SAP_Shipto__c == '0000009' && order.SAP_BillTo__c == '0000009' && order.Sold_To_Customer__c == '0000009')){
                shipToPartner.Street = order.ShippingStreet;
                shipToPartner.Region = order.ShippingState;
                shipToPartner.City = order.ShippingCity;
                shipToPartner.PostalCode = order.ShippingPostalCode;
                shipToPartner.Country = order.ShippingCountry;
                shipToPartner.PartnerName = order.ShipTo_Name__c;
                shipToPartner.allowAddressOverride = true;
            }
            
        }

        ensxtx_DS_Document_Detail.PARTNERS billToPartner = ensxtx_UTIL_SalesDoc.getPartnerFromDocumentDetail(salesDocDetail.PARTNERS, ensxtx_UTIL_Customer.BILL_TO_PARTNER_CODE, true);
        if(order.SAP_BillTo__c != null) {
            billToPartner.CustomerNumber = (String) order.SAP_BillTo__c; //.get(ensxtx_UTIL_SFAccount.CustomerFieldName);
        }
        if(order.SAP_Shipto__c != null && order.SAP_Shipto__c == '0000009' && order.SAP_BillTo__c == '0000009' && order.Sold_To_Customer__c == '0000009'){
            billToPartner.CustomerNumber = (String) order.SAP_Shipto__c;
            billToPartner.Street = order.BillingStreet;
            billToPartner.Region = order.BillingState;
            billToPartner.City = order.BillingCity;
            billToPartner.PostalCode = order.BillingPostalCode;
            billToPartner.Country = order.BillingCountry;
            billToPartner.PartnerName = order.BillingName__c;
            billToPartner.allowAddressOverride = true;
        }

        ensxtx_DS_Document_Detail.PARTNERS payerPartner = ensxtx_UTIL_SalesDoc.getPartnerFromDocumentDetail(salesDocDetail.PARTNERS, ensxtx_UTIL_Customer.PAYER_PARTNER_CODE, true);
        if(order.SAP_BillTo__c != null) {
            payerPartner.CustomerNumber = (String) order.SAP_BillTo__c; //.get(ensxtx_UTIL_SFAccount.CustomerFieldName);
        }
        if(order.SAP_Shipto__c != null && order.SAP_Shipto__c == '0000009' && order.SAP_BillTo__c == '0000009' && order.Sold_To_Customer__c == '0000009'){
            payerPartner.CustomerNumber = (String) order.SAP_Shipto__c;
            payerPartner.Street = order.ShippingStreet;
            payerPartner.Region = order.ShippingState;
            payerPartner.City = order.ShippingCity;
            payerPartner.PostalCode = order.ShippingPostalCode;
            payerPartner.Country = order.ShippingCountry;
            payerPartner.PartnerName = order.ShipTo_Name__c;
            payerPartner.allowAddressOverride = true;
        }

        if(order.Use_Freight_Routing__c != null && order.Use_Freight_Routing__c == true) {
            ensxtx_DS_Document_Detail.PARTNERS carrierPartner = ensxtx_UTIL_SalesDoc.getPartnerFromDocumentDetail(salesDocDetail.PARTNERS, ensxtx_UTIL_Customer.CARRIERS_PARTNER_CODE, true);
            carrierPartner.CustomerNumber = 'T000000010';
        }

        if(order.License_Partner__c!= null){
            ensxtx_DS_Document_Detail.PARTNERS LicensePartner = ensxtx_UTIL_SalesDoc.getPartnerFromDocumentDetail(salesDocDetail.PARTNERS, ensxtx_UTIL_Customer.LICENSE_PARTNER_CODE, true);
            LicensePartner.CustomerNumber = (String) order.License_Partner__c;
        }

        //Converted Instructions
        if (String.isNotEmpty(order.Customer_Email__c )) {
            ensxtx_DS_Document_Detail.TEXTS convertedInstructionsText  = new ensxtx_DS_Document_Detail.TEXTS();
            convertedInstructionsText.TextID = '0020';
            convertedInstructionsText.Text = order.Customer_Email__c ;
            salesDocDetail.TEXTS.add(convertedInstructionsText);
        }

        //Converted Instructions
        if (String.isNotEmpty(order.Warehouse_text__c)) {
            ensxtx_DS_Document_Detail.TEXTS wareHouseText  = new ensxtx_DS_Document_Detail.TEXTS();
            wareHouseText.TextID = '0007';
            wareHouseText.Text = order.Warehouse_text__c;
            salesDocDetail.TEXTS.add(wareHouseText);
        }
        

        //Attention (Shipping)
        if (String.isNotEmpty(order.Attention_Shipping__c)) {
            ensxtx_DS_Document_Detail.TEXTS attentionShippingText  = new ensxtx_DS_Document_Detail.TEXTS();
            attentionShippingText.TextID = '0001';
            attentionShippingText.Text = order.Attention_Shipping__c;
            salesDocDetail.TEXTS.add(attentionShippingText);
        }

        //Attention (Billing)
        if (String.isNotEmpty(order.Attention_Billing__c)) {
            ensxtx_DS_Document_Detail.TEXTS attentionBillingText  = new ensxtx_DS_Document_Detail.TEXTS();
            attentionBillingText.TextID = '0003';
            attentionBillingText.Text = order.Attention_Billing__c;
            salesDocDetail.TEXTS.add(attentionBillingText);
        }

        //Shipping Instructions
        if (String.isNotEmpty(order.Shipping_instruction__c)) {
            ensxtx_DS_Document_Detail.TEXTS shippingInstructionsText  = new ensxtx_DS_Document_Detail.TEXTS();
            shippingInstructionsText.TextID = '0005';
            shippingInstructionsText.Text = order.Shipping_instruction__c;
            salesDocDetail.TEXTS.add(shippingInstructionsText);
        }

        //Customer Service Comments
        if (String.isNotEmpty(order.Customer_Service_Comments__c)) {
            ensxtx_DS_Document_Detail.TEXTS customerServiceCommentsText  = new ensxtx_DS_Document_Detail.TEXTS();
            customerServiceCommentsText.TextID = '0009';
            customerServiceCommentsText.Text = order.Customer_Service_Comments__c;
            salesDocDetail.TEXTS.add(customerServiceCommentsText);
        }

        //Special EDI Instructions
        if (String.isNotEmpty(order.Special_EDI_Instructions__c)) {
            ensxtx_DS_Document_Detail.TEXTS specialEDIInstructionsText  = new ensxtx_DS_Document_Detail.TEXTS();
            specialEDIInstructionsText.TextID = '0015';
            specialEDIInstructionsText.Text = order.Special_EDI_Instructions__c;
            salesDocDetail.TEXTS.add(specialEDIInstructionsText);
        }

        if (sfLineItems != null && sfLineItems.size() > 0) {
            Integer increment = appSettings.itemNumberIncrement;
            Integer itemNumber = increment;

            Integer lineItemTot = sfLineItems.size();

            for (Integer lineItemCnt = 0; lineItemCnt < lineItemTot; lineItemCnt++)
            {
                SObject sfLineItem = sfLineItems[lineItemCnt];
                OrderItem orderLine = (OrderItem) sfLineItem;
                ensxtx_DS_Document_Detail.ITEMS salesDocItem = new ensxtx_DS_Document_Detail.ITEMS();

                // Mapping of item fields from Sobject line items
                salesDocItem.ItemNumber = String.valueOf(itemNumber);
                salesDocItem.HigherLevelItemNumber = '000000';
                if (orderLine.Product2 != null) salesDocItem.Material = getMaterial(order, orderLine);
                salesDocItem.ItemDescription = orderLine.Description;
                salesDocItem.OrderQuantity = orderLine.Quantity;

                salesDocItem.PARTNERS = ensxtx_UTIL_SalesDoc.convertAppSettingPartnersToPartners(appSettings.Item.PartnerPickers);
                salesDocItem.ItemTexts = ensxtx_UTIL_SalesDoc.convertAppSettingTextsToTexts(appSettings.Item.Texts, salesDocDetail.CustomerLanguage);

                salesDocItem.SFId = orderLine.Id;
                if(String.isNotEmpty(salesDocItem.Material)){
                    salesDocDetail.ITEMS.add(salesDocItem);
                    itemNumber += increment;
                }else {
                    String name = '';
                    if(orderLine.Product2 != null) name = (String)  orderLine.Product2.get('Name');
                    ensxtx_UTIL_PageMessages.addMessage(ensxtx_UTIL_PageMessages.WARNING, String.format(System.Label.ensxtx_SalesDoc_Message_SAPMaterialNumberNotFound, new List<String>{name, orderLine.Id}));
                }
            }
        }

        return salesDocDetail;
    }

    public ensxtx_DS_Document_Detail sObjectToSalesDocMappingForStandardOrder(
        SObject sfSObject,
        List<SObject> sfLineItems,
        ensxtx_DS_Document_Detail salesDocDetail,
        ensxtx_DS_SalesDocAppSettings appSettings)
    {
        //Do the mapping from SObject and SF Line Items to salesDocDetail here
        Order order = (Order) sfSObject;

        Map<String, Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get('Order').getDescribe().fields.getMap();
        Boolean isCPQ = fieldMap.containsKey('SBQQ__Quote__c');

        if (String.isNotEmpty(order.ensxtx_SAP_SaveSalesDocHeader__c)) {
            salesDocDetail = (ensxtx_DS_Document_Detail) JSON.deserialize(order.ensxtx_SAP_SaveSalesDocHeader__c, ensxtx_DS_Document_Detail.class);
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
            salesDocDetail.SalesDocumentCurrency = ensxtx_UTIL_SObject.getCurrencyIsoCode('Order', order);
            salesDocDetail.UsersLanguage = UserInfo.getLanguage();
            salesDocDetail.NeedToSimulate = true;
            mapHeaderFields(order, salesDocDetail);
            if (isCPQ && order.get('SBQQ__Quote__c') != null) mapHeaderFields(getCPQQuoteObject((Id) order.get('SBQQ__Quote__c')), salesDocDetail);
        }
        salesDocDetail.SFId = order.Id;

        if (sfLineItems != null && sfLineItems.size() > 0) {
            Integer increment = appSettings.itemNumberIncrement;
            Map<String, Integer> itemNumberMap = new Map<String, Integer>();
            itemNumberMap.put('itemNumber', 0);
            itemNumberMap.put('bomItemNumber', 0);

            Integer lineItemTot = sfLineItems.size();
            Set<Id> cpqQuoteLineIdSet = new Set<Id>();
            for (Integer lineItemCnt = 0; lineItemCnt < lineItemTot; lineItemCnt++)
            {
                SObject sfLineItem = sfLineItems[lineItemCnt];
                OrderItem orderLine = (OrderItem) sfLineItem;
                if (isCPQ && orderLine.get('SBQQ__QuoteLine__c') != null) cpqQuoteLineIdSet.add((Id) orderLine.get('SBQQ__QuoteLine__c'));
            }
            Map<Id, SObject> cpqQuoteLineMap = new Map<Id, SObject>();
            if (isCPQ) cpqQuoteLineMap = getCPQQuoteLineObjects(cpqQuoteLineIdSet);

            Set<Id> productFeaturesIdSet = new Set<Id>();
            for (Integer lineItemCnt = 0; lineItemCnt < lineItemTot; lineItemCnt++)
            {
                SObject sfLineItem = sfLineItems[lineItemCnt];
                OrderItem orderLine = (OrderItem) sfLineItem;
                ensxtx_DS_Document_Detail.ITEMS salesDocItem = new ensxtx_DS_Document_Detail.ITEMS();
                Id cpqQuoteLineId = isCPQ && orderLine.get('SBQQ__QuoteLine__c') != null ? (Id) orderLine.get('SBQQ__QuoteLine__c') : null;
                SObject cpqQuoteLine = cpqQuoteLineMap.get(cpqQuoteLineId);
                String dynamicOptionId = cpqQuoteLine != null ? (String) cpqQuoteLine.get('SBQQ__DynamicOptionId__c') : null;
                String prodFeatId = dynamicOptionId == null || !dynamicOptionId.contains(':') ? null : dynamicOptionId.split(':')[0];
                if (prodFeatId != null) productFeaturesIdSet.add(prodFeatId);
            }
            Map<Id, SObject> productFeaturesMap = new Map<Id, SObject>();
            if (isCPQ) productFeaturesMap = new Map<Id, SObject>(Database.query('SELECT Id, Name FROM SBQQ__ProductFeature__c WHERE Id IN :productFeaturesIdSet AND Name = \'SAP BoM\''));

            Decimal maxNumber = 0;
            Integer parentItemNumber = 0;
            Integer childItemNumber = 0;
            List<Id> sapQLIds = new List<Id>();
            Map<Id, OrderItem> sapSFChildIdMap = new Map<Id, OrderItem>();
            Map<String, OrderItem> qlSortMap = new Map<String, OrderItem>();
            for (Integer lineItemCnt = 0; lineItemCnt < lineItemTot; lineItemCnt++)
            {
                SObject sfLineItem = sfLineItems[lineItemCnt];
                OrderItem orderLine = (OrderItem) sfLineItem;
                Id cpqQuoteLineId = isCPQ && orderLine.get('SBQQ__QuoteLine__c') != null ? (Id) orderLine.get('SBQQ__QuoteLine__c') : null;
                SObject cpqQuoteLine = cpqQuoteLineMap.get(cpqQuoteLineId);
                if (cpqQuoteLine != null && (Decimal) cpqQuoteLine.get('SBQQ__Number__c') > maxNumber) maxNumber = (Decimal) cpqQuoteLine.get('SBQQ__Number__c');
                String sapMaterial = getMaterial(order, orderLine);
                if (String.isNotEmpty(sapMaterial)) {
                    String dynamicOptionId = cpqQuoteLine != null ? (String) cpqQuoteLine.get('SBQQ__DynamicOptionId__c') : null;
                    String prodFeatId = dynamicOptionId == null || !dynamicOptionId.contains(':') ? null : dynamicOptionId.split(':')[0];
                    Boolean isChild = prodFeatId != null && productFeaturesMap.containsKey(prodFeatId);
                    if (isChild) {
                        childItemNumber++;
                        qlSortMap.put(String.valueOf(parentItemNumber + childItemNumber).leftPad(7, '0'), orderLine);
                    } else if (cpqQuoteLine == null || (Id) cpqQuoteLine.get('SBQQ__RequiredBy__c') == null || !sapQLIds.contains((Id) cpqQuoteLine.get('SBQQ__RequiredBy__c'))) {
                        Integer sfChdTot = sapSFChildIdMap.size();
                        if (sfChdTot > 0) {
                            List<Id> sfChdIdList = new List<Id>(sapSFChildIdMap.keySet());
                            for (Integer sfChdCnt = 0 ; sfChdCnt < sfChdTot ; sfchdCnt++) {
                                parentItemNumber += appSettings.itemNumberIncrement;
                                qlSortMap.put(String.valueOf(parentItemNumber).leftPad(7, '0'), sapSFChildIdMap.get(sfChdIdList[sfChdCnt]));
                            }
                            sapSFChildIdMap.clear();
                        }
                        parentItemNumber += appSettings.itemNumberIncrement;
                        childItemNumber = 0;
                        qlSortMap.put(String.valueOf(parentItemNumber).leftPad(7, '0'), orderLine);
                    } else {
                        sapSFChildIdMap.put(orderLine.Id, orderLine);
                    }
                    if (cpqQuoteLine != null) sapQLIds.add(cpqQuoteLine.Id);
                }
            }
            Integer sfChdTot = sapSFChildIdMap.size();
            if (sfChdTot > 0) {
                List<Id> sfChdIdList = new List<Id>(sapSFChildIdMap.keySet());
                for (Integer sfChdCnt = 0 ; sfChdCnt < sfChdTot ; sfchdCnt++) {
                    parentItemNumber += appSettings.itemNumberIncrement;
                    qlSortMap.put(String.valueOf(parentItemNumber).leftPad(7, '0'), sapSFChildIdMap.get(sfChdIdList[sfChdCnt]));
                }
            }

            List<String> qlSortKeyList = new List<String>(qlSortMap.keySet());
            qlSortKeyList.sort();
            lineItemTot = qlSortKeyList.size();
            for (Integer lineItemCnt = 0; lineItemCnt < lineItemTot; lineItemCnt++)
            {
                OrderItem orderLine =  qlSortMap.get(qlSortKeyList[lineItemCnt]);
                Id cpqQuoteLineId = isCPQ && orderLine.get('SBQQ__QuoteLine__c') != null ? (Id) orderLine.get('SBQQ__QuoteLine__c') : null;
                SObject cpqQuoteLine = cpqQuoteLineMap.get(cpqQuoteLineId);
                ensxtx_DS_Document_Detail.ITEMS salesDocItem = new ensxtx_DS_Document_Detail.ITEMS();

                if (String.isNotEmpty(orderLine.ensxtx_SAP_SaveSalesDocItem__c)) {
                    salesDocItem = (ensxtx_DS_Document_Detail.ITEMS) JSON.deserialize(orderLine.ensxtx_SAP_SaveSalesDocItem__c, ensxtx_DS_Document_Detail.ITEMS.class);
                }
                else {
                    // Mapping of item fields from Sobject line items
                    if (orderLine.Product2 != null) salesDocItem.Material = getMaterial(order, orderLine);
                    salesDocItem.ItemDescription = orderLine.Description;
                    salesDocItem.NetItemPrice = orderLine.UnitPrice;
                    salesDocItem.OrderQuantity = orderLine.Quantity;
                    String configurableMaterialField = ensxtx_UTIL_SFProduct.getConfigurableMaterialField();
                    if (orderLine.Product2 != null && String.isNotEmpty(configurableMaterialField)) salesDocItem.ConfigurableMaterial = (Boolean) orderLine.Product2.get(configurableMaterialField);
                    String bomMaterialField = ensxtx_UTIL_SFProduct.getBOMMaterialField();
                    if (orderLine.Product2 != null && String.isNotEmpty(bomMaterialField)) salesDocItem.BOMMaterial = (Boolean) orderLine.Product2.get(bomMaterialField);

                    salesDocItem.PARTNERS = ensxtx_UTIL_SalesDoc.convertAppSettingPartnersToPartners(appSettings.Item.PartnerPickers);
                    salesDocItem.ItemTexts = ensxtx_UTIL_SalesDoc.convertAppSettingTextsToTexts(appSettings.Item.Texts, salesDocDetail.CustomerLanguage);

                    if (cpqQuoteLine != null) mapItemConfiguration((String) cpqQuoteLine.get('ensxtx_SAP_Configuration__c'), salesDocItem);
                }

                String dynamicOptionId = cpqQuoteLine != null ? (String) cpqQuoteLine.get('SBQQ__DynamicOptionId__c') : null;
                String prodFeatId = dynamicOptionId == null || !dynamicOptionId.contains(':') ? null : dynamicOptionId.split(':')[0];
                Boolean isChild = prodFeatId != null && productFeaturesMap.containsKey(prodFeatId);
                itemNumberMap = setItemNumbers(salesDocItem, itemNumberMap, increment, isChild);

                salesDocItem.SFId = orderLine.Id;
                if(String.isNotEmpty(salesDocItem.Material)){
                    salesDocDetail.ITEMS.add(salesDocItem);
                }else {
                    String name = '';
                    if(orderLine.Product2 != null) name = (String)  orderLine.Product2.get('Name');
                    ensxtx_UTIL_PageMessages.addMessage(ensxtx_UTIL_PageMessages.WARNING, String.format(System.Label.ensxtx_SalesDoc_Message_SAPMaterialNumberNotFound, new List<String>{name, orderLine.Id}));
                }
            }
        }

        return salesDocDetail;
    }

    @testVisible
    private SObject getCPQQuoteObject(
        Id cpqQuoteId)
    {
        string selectCmd = 'SELECT Id, ensxtx_Sales_Organization__c, ensxtx_Distribution_Channel__c, ensxtx_Division__c FROM SBQQ__Quote__c WHERE Id = \'' + cpqQuoteId + '\'';
        List<SObject> resultList = new List<SObject>();
        try 
        {        
            resultList = Database.query(selectCmd);
        } catch(Exception e) {}
        return resultList.size() > 0 ? resultList[0] : null; 
    }

    @testVisible
    private Map<Id,SObject> getCPQQuoteLineObjects(
        Set<Id> cpqQuoteLineIdSet)
    {
        string selectCmd = 'SELECT Id, ensxtx_SAP_Configuration__c, SBQQ__RequiredBy__c, SBQQ__DynamicOptionId__c FROM SBQQ__QuoteLine__c WHERE Id IN :cpqQuoteLineIdSet';
        Map<Id,SObject> resultMap = new Map<Id,SObject>();
        try 
        {        
            resultMap = new Map<Id,SObject>(Database.query(selectCmd));
        } catch(Exception e) {}
        return resultMap; 
    }

    @testVisible
    private void mapHeaderFields(
        SObject sfSObject,
        ensxtx_DS_Document_Detail salesDocDetail)
    {
        if (sfSObject != null) {
            Map<String, Schema.SObjectField> fieldMap = sfSObject.getSObjectType().getDescribe().fields.getMap();
            if (fieldMap.containsKey('ensxtx_Sales_Organization__c')) salesDocDetail.SALES.SalesOrganization = (String) sfSObject.get('ensxtx_Sales_Organization__c');
            if (fieldMap.containsKey('ensxtx_Distribution_Channel__c')) salesDocDetail.SALES.DistributionChannel = (String) sfSObject.get('ensxtx_Distribution_Channel__c');
            if (fieldMap.containsKey('ensxtx_Division__c')) salesDocDetail.SALES.Division = (String) sfSObject.get('ensxtx_Division__c');
        }
    }

    @testVisible
    private void mapItemConfiguration(
        String itemConfigJSON, 
        ensxtx_DS_Document_Detail.ITEMS salesDocItem)
    {
        if (String.isNotEmpty(itemConfigJSON)) {
            ensxtx_DS_Document_Detail.CPQ_VC_ITEM_CONFIGURATION cpqItemConfig = (ensxtx_DS_Document_Detail.CPQ_VC_ITEM_CONFIGURATION) JSON.deserialize(itemConfigJSON,ensxtx_DS_Document_Detail.CPQ_VC_ITEM_CONFIGURATION.class);
            salesDocItem.ItemConfigurations = cpqItemConfig.selectedCharacteristics;
        }
    }

    @testVisible
    private Map<String, Integer> setItemNumbers(
        ensxtx_DS_Document_Detail.ITEMS salesDocItem, 
        Map<String, Integer> itemNumberMap, 
        Integer increment,
        Boolean isChild)
    {
        Integer itemNumber = itemNumberMap.get('itemNumber');
        Integer bomItemNumber = itemNumberMap.get('bomItemNumber');
        if (isChild) {
            bomItemNumber += 1;
            salesDocItem.ItemNumber = String.valueOf(itemNumber + bomItemNumber);
            salesDocItem.HigherLevelItemNumber = String.valueOf(itemNumber);
            salesDocItem.BillOfMaterial = String.valueOf(itemNumber);
        }
        else {
            itemNumber += increment;
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
        Order order = (Order) sfSObject;        
        
        if (String.isNotEmpty(salesDocDetail.SalesDocument)) {
            if (appSettings.SAPDocType == 'Order') {
                //order.ensxtx_SAP_Order_Number__c = salesDocDetail.SalesDocument;
                order.SAP_Document_Number__c = salesDocDetail.SalesDocument;  
                order.SAP_Quote_ID__c = salesDocDetail.YourReference;   
                order.Shipping_Amount__c = salesDocDetail.ShippingAmount;
                if(String.isNotEmpty(order.Coupon__c)) order.Coupon_Discount__c= salesDocDetail.CouponDiscount;           
            }
        }
        
        if (salesDocDetail.IsSuccess) {
            ensxtx_DS_Document_Detail copySalesDocDetail = salesDocDetail.cloneHeader();
            order.ensxtx_SAP_SaveSalesDocHeader__c = JSON.serialize(copySalesDocDetail);
        }
        
        return order;
    }

    public void salesDocLineItemMappingToSObject(
        SObject sfSObject, 
        ensxtx_DS_SalesDocAppSettings appSettings, 
        Map<String,Map<String,Object>> lineItemsMap)
    {
        Map<String, OrderItem> upsertMap = new Map<String, OrderItem>();
        List<String> keyList = new List<String>(lineItemsMap.keySet());
        Integer keyTot = keyList.size();
        for (Integer keyCnt = 0 ; keyCnt < keyTot ; keyCnt++)
        {
            String key = keyList[keyCnt];
            Map<String,Object> objectMap = lineItemsMap.get(key);

            ensxtx_DS_Document_Detail.ITEMS salesDocItem = (ensxtx_DS_Document_Detail.ITEMS) objectMap.get('salesDocItem');
            
            OrderItem orderLine = null;
            if (objectMap.containsKey('sfLineItem')) {
                orderLine = (OrderItem) objectMap.get('sfLineItem');
            }
            else if (!appSettings.skipAddedLineValidation) {
                PricebookEntry materialEntry = (PricebookEntry) objectMap.get('materialEntry');
                if (materialEntry != null) {
                    orderLine = new OrderItem();
                    orderLine.OrderId = (Id) sfSObject.get('Id');
                    orderLine.PricebookEntryId = materialEntry.Id;
                    orderLine.Product2Id = materialEntry.Product2Id;
                }
            }

            if (orderLine != null) {
                //orderLine.Description = salesDocItem.ItemDescription;
                orderLine.Material_Entered__c = salesDocItem.MaterialEntered;
                orderLine.Quantity = salesDocItem.OrderQuantity;
                orderLine.UnitPrice = salesDocItem.NetItemPrice;
                orderLine.SAP_Total_Price__c = salesDocItem.NetOrderValue;
                orderLine.Plant__c = salesDocItem.Plant;
                orderLine.Net_Weight__c =String.valueOf(salesDocItem.NetWeight) ;
                orderLine.Reason_for_Rejection__c= salesDocItem.RejectionReason;
                orderLine.SAP_Order_Item_status__c=salesDocItem.GBSTA;
                orderLine.Discount__c = salesDocItem.CouponDiscount;
                orderLine.Tax__c= salesDocItem.TaxAmount;
                orderLine.Shipping_amount__c = salesDocItem.shippingAmount;
                orderLine.SAP_Item_number__c = salesDocItem.ItemNumber;
                if(salesDocItem.ItemConditions != null && salesDocItem.ItemConditions.size() > 0){
                    for(ensxtx_DS_Document_Detail.CONDITIONS condition : salesDocItem.ItemConditions){
                        if(condition.ConditionType == 'ZNET' || condition.ConditionType == 'ZCON'){
                            orderLine.Price_condition__c = condition.ConditionType;
                            break;
                        }
                    }
                }   
                orderLine.ensxtx_SAP_SaveSalesDocItem__c = JSON.serialize(salesDocItem);

                upsertMap.put(key, orderLine);
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