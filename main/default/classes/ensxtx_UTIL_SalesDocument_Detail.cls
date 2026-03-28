public class ensxtx_UTIL_SalesDocument_Detail implements ensxtx_I_Document_Detail
{
    private ensxtx_DS_SalesDocAppSettings appSettings;

    public String getSimulateCommand()
    {
        return 'CMD_SIMULATE_DOCUMENT';
    }

    public String getReferenceDocumentCommand()
    {
        return 'CMD_FILL_REF_DOC_DETAILS';
    }

    public String getMaterialBomCountCommand()
    {
        return 'CMD_MATERIAL_BOM_COUNT';
    }

    public ensxsdk.EnosixFramework.DetailObject removeAllConditions(ensxsdk.EnosixFramework.DetailObject detailObj)
    {
        ensxtx_SBO_EnosixSalesDocument_Detail.EnosixSalesDocument sboObject = (ensxtx_SBO_EnosixSalesDocument_Detail.EnosixSalesDocument) detailObj;
        sboObject.CONDITIONS.clear();
        return sboObject;
    }

    // Update the SBO for any fields lost during simulate like Header and Item Text Fields
    // Mainly use after simulation before update so it can keep any line breaks in the text
    public ensxsdk.EnosixFramework.DetailObject updateSimulateBeforeUpdate(ensxsdk.EnosixFramework.DetailObject detailObj, ensxtx_DS_Document_Detail docObj, ensxtx_DS_SalesDocAppSettings appSettings)
    {
        this.appSettings = appSettings;
        ensxtx_SBO_EnosixSalesDocument_Detail.EnosixSalesDocument sboObject = (ensxtx_SBO_EnosixSalesDocument_Detail.EnosixSalesDocument) detailObj;
        mapHeaderTextsToSBOForUpdate(sboObject, docObj);

        Integer itemsTot = docObj.ITEMS.size();
        List<ensxtx_SBO_EnosixSalesDocument_Detail.ITEMS_TEXT> sboItemTextList = sboObject.ITEMS_TEXT.getAsList();
        Integer sboItemTextsTot = sboItemTextList.size();

        for (Integer itemCnt = 0; itemCnt < itemsTot; itemCnt++)
        {
            ensxtx_DS_Document_Detail.ITEMS item = docObj.ITEMS[itemCnt];
            if (item.isChanged == true || item.isAdded == true)
            {                
                Integer itemTextsTot = item.ItemTexts.size();                
                for (Integer itemTextCnt = 0; itemTextCnt < itemTextsTot; itemTextCnt++)
                {
                    ensxtx_DS_Document_Detail.TEXTS itemText = item.ItemTexts[itemTextCnt];
                    for (Integer sboItemTextCnt = 0; sboItemTextCnt < sboItemTextsTot; sboItemTextCnt++)
                    {
                        ensxtx_SBO_EnosixSalesDocument_Detail.ITEMS_TEXT sboItemText = sboItemTextList[sboItemTextCnt];
                        if (item.ItemNumber == sboItemText.ItemNumber && itemText.TextID == sboItemText.TextID) {
                            sboItemText.Text = itemText.Text;
                            sboItemText.TextLanguage = itemText.TextLanguage;
                            break;
                        }  
                    }
                }
            }
        }

        return sboObject;
    }

    public ensxsdk.EnosixFramework.DetailObject buildSBOForReference(String salesDocNumber, String salesDocType)
    {
        ensxtx_SBO_EnosixSalesDocument_Detail.EnosixSalesDocument sboObject = new ensxtx_SBO_EnosixSalesDocument_Detail.EnosixSalesDocument();

        sboObject.ORDER_ACTION.ReferenceFlag = true;
        sboObject.ORDER_ACTION.ReferenceDocumentNumber = salesDocNumber;
        sboObject.ORDER_ACTION.ReferenceDocumentType = salesDocType;

        return sboObject;
    }


    // #region Convert to SBO Mapping

    // Implementation of Converting ensxtx_DS_Document_Detail to SBO Detail Object
    // This conversion is needed before sending the request to SAP
    public ensxsdk.EnosixFramework.DetailObject convertToSBO(ensxsdk.EnosixFramework.DetailObject detailObj, 
        ensxtx_DS_Document_Detail docObj, Boolean isUpdate, ensxtx_DS_SalesDocAppSettings appSettings)
    {
        this.appSettings = appSettings;
        ensxtx_SBO_EnosixSalesDocument_Detail.EnosixSalesDocument sboObject;

        if (detailObj == null) sboObject = new ensxtx_SBO_EnosixSalesDocument_Detail.EnosixSalesDocument();
        else sboObject = (ensxtx_SBO_EnosixSalesDocument_Detail.EnosixSalesDocument) detailObj;

        mapHeaderFieldsToSBO(sboObject, docObj);

        if (isUpdate) {
            
            mapPartnersToSBOForUpdate(sboObject, docObj.PARTNERS, null);
            mapHeaderTextsToSBOForUpdate(sboObject, docObj);
            mapHeaderConditionsToSBOForUpdate(sboObject, docObj);
            removedItemsForUpdate(sboObject, docObj);
            mapItemsForUpdate(sboObject, docObj, false);
        }
        else {       

            // PARTNERS
            List<ensxtx_DS_Document_Detail.PARTNERS> partnerList = new List<ensxtx_DS_Document_Detail.PARTNERS>(docObj.PARTNERS);
            if (String.isNotEmpty(docObj.SoldToParty)) 
            {
                sboObject.SoldToParty = docObj.SoldToParty;
                ensxtx_DS_Document_Detail.PARTNERS soldToPartner = ensxtx_UTIL_SalesDoc.getPartnerFromDocumentDetail(partnerList, ensxtx_UTIL_Customer.SOLD_TO_PARTNER_CODE, true);
                soldToPartner.CustomerNumber = docObj.SoldToParty;
            }
            Integer partTot = partnerList.size();
            for (Integer partCnt = 0 ; partCnt < partTot ; partCnt++)
            {            
                ensxtx_DS_Document_Detail.PARTNERS partner = partnerList[partCnt];
                ensxtx_SBO_EnosixSalesDocument_Detail.PARTNERS sboPartner = createNewPartnerSBO(partner, null);
                if (sboPartner != null) {
                    // If new item & partner to that item added while update
                    if (String.isNotEmpty(docObj.SalesDocument) && partner.isChanged == true) sboPartner.PartnerChangedFlag = true;

                    sboObject.PARTNERS.add(sboPartner);
                }
            }

            // CONDITIONS
            Integer condTot = docObj.CONDITIONS == null ? 0 : docObj.CONDITIONS.size();
            for (Integer condCnt = 0 ; condCnt < condTot ; condCnt++)
            {            
                ensxtx_DS_Document_Detail.CONDITIONS headerCondition = docObj.CONDITIONS[condCnt];
                if (String.isNotEmpty(headerCondition.ConditionType) && headerCondition.Rate != null)
                {
                    ensxtx_SBO_EnosixSalesDocument_Detail.CONDITIONS newCondition = new ensxtx_SBO_EnosixSalesDocument_Detail.CONDITIONS();
                    mapConditionFieldsToSBO(newCondition, headerCondition, '', sboObject.SalesDocumentCurrency);
                    sboObject.CONDITIONS.add(newCondition);
                }
            }

            // TEXTS
            Integer textTot = docObj.TEXTS == null ? 0 : docObj.TEXTS.size();
            for (Integer textCnt = 0 ; textCnt < textTot ; textCnt++)
            {            
                ensxtx_DS_Document_Detail.TEXTS text = docObj.TEXTS[textCnt];
                if (String.isNotEmpty(text.Text))
                {
                    ensxtx_SBO_EnosixSalesDocument_Detail.TEXTS newText = new ensxtx_SBO_EnosixSalesDocument_Detail.TEXTS();
                    mapHeaderTextToSBO(newText, text);
                    sboObject.TEXTS.add(newText);
                }                
            }

            // ITEMS
            if (docObj.ITEMS != null && docObj.ITEMS.size() > 0) 
            {
                mapNewItemsToSBO(sboObject, docObj.ITEMS, false);
            }

             //CCCard
             Integer CCTot = docObj.CCARD == null ? 0 : docObj.CCARD.size();
             for (Integer Cnt = 0 ; Cnt < CCTot ; Cnt++)
             { 
                 ensxtx_DS_Document_Detail.CCARD CCcard = docObj.CCARD[Cnt];
                 if (String.isNotEmpty(CCcard.CreditCardType))
                 {
                     ensxtx_SBO_EnosixSalesDocument_Detail.CCARD CCcarddetails = new ensxtx_SBO_EnosixSalesDocument_Detail.CCARD();
                     mapCCCardToSBO(CCcarddetails, CCcard);
                     sboObject.CCARD.add(CCcarddetails);
                 }   
             } 
            
        }

        return sboObject;
    }

    private void mapCCCardToSBO(ensxtx_SBO_EnosixSalesDocument_Detail.CCARD sboCCCard, ensxtx_DS_Document_Detail.CCARD CCcard)
    {
        sboCCCard.CreditCardType = CCcard.CreditCardType;
        sboCCCard.CreditCardNumber= CCcard.CreditCardNumber;
        sboCCCard.ValidToDate = CCcard.ValidToDate;
        sboCCCard.CardholderName = CCcard.CardholderName;
        sboCCCard.PaymentCardEntryMode = CCcard.PaymentCardEntryMode;
       
    } 

    private void mapHeaderFieldsToSBO(ensxtx_SBO_EnosixSalesDocument_Detail.EnosixSalesDocument sboObject, ensxtx_DS_Document_Detail docObj)
    {
        // HEADER
        if (String.isNotEmpty(docObj.SalesDocument)) sboObject.SalesDocument = docObj.SalesDocument;
        if (String.isNotEmpty(docObj.SoldToPartyText)) sboObject.SoldToPartyText = docObj.SoldToPartyText;
        if (String.isNotEmpty(docObj.CustomerPurchaseOrderNumber)) sboObject.CustomerPurchaseOrderNumber = docObj.CustomerPurchaseOrderNumber;
        if (null != docObj.CustomerPurchaseOrderDate) sboObject.CustomerPurchaseOrderDate = docObj.CustomerPurchaseOrderDate;
        if (String.isNotEmpty(docObj.SalesDocumentCurrency))
        {
            sboObject.SalesDocumentCurrency = docObj.SalesDocumentCurrency;
            sboObject.SALES.SalesDocumentCurrency = docObj.SalesDocumentCurrency;
        }

        if (String.isNotEmpty(docObj.ReferenceDocument)) sboObject.ReferenceDocument = docObj.ReferenceDocument;
        if (String.isNotEmpty(docObj.ReferenceDocumentCategory)) sboObject.ReferenceDocumentCategory = docObj.ReferenceDocumentCategory;
        if (String.isNotEmpty(docObj.Cupon)) sboObject.Cupon = docObj.Cupon;
        if (docObj.B2BOrderFlag != null) sboObject.B2BOrderFlag = docObj.B2BOrderFlag;

        // SALES DATA
        sboObject.SALES.SalesDocumentType = docObj.SALES.SalesDocumentType;
        sboObject.SALES.SalesDocumentTypeInternal = docObj.SALES.SalesDocumentTypeInternal;
        if (String.isNotEmpty(docObj.SALES.SalesOrganization)) sboObject.SALES.SalesOrganization = docObj.SALES.SalesOrganization;
        if (String.isNotEmpty(docObj.SALES.DistributionChannel)) sboObject.SALES.DistributionChannel = docObj.SALES.DistributionChannel;
        if (String.isNotEmpty(docObj.SALES.Division)) sboObject.SALES.Division = docObj.SALES.Division;
        if (String.isNotEmpty(docObj.SALES.PriceGroup)) sboObject.SALES.PriceGroup = docObj.SALES.PriceGroup;
        if (String.isNotEmpty(docObj.SALES.PriceListType)) sboObject.SALES.PriceListType = docObj.SALES.PriceListType;
        if (String.isNotEmpty(docObj.SALES.SalesDistrict)) sboObject.SALES.SalesDistrict = docObj.SALES.SalesDistrict;
        if (String.isNotEmpty(docObj.SALES.TermsofPaymentKey)) sboObject.SALES.TermsofPaymentKey = docObj.SALES.TermsofPaymentKey;
        if (String.isNotEmpty(docObj.SALES.IncotermsPart1)) sboObject.SALES.IncotermsPart1 = docObj.SALES.IncotermsPart1;
        if (String.isNotEmpty(docObj.SALES.IncotermsPart2)) sboObject.SALES.IncotermsPart2 = docObj.SALES.IncotermsPart2;        
        if (String.isNotEmpty(docObj.SALES.SalesOffice)) sboObject.SALES.SalesOffice = docObj.SALES.SalesOffice;        
        if (String.isNotEmpty(docObj.SALES.OrderReason)) sboObject.SALES.OrderReason = docObj.SALES.OrderReason;
        if (String.isNotEmpty(docObj.SALES.CustomerGroup)) sboObject.SALES.CustomerGroup = docObj.SALES.CustomerGroup;
        if (String.isNotEmpty(docObj.SALES.SalesDocumentVersionNumber)) sboObject.SALES.SalesDocumentVersionNumber = docObj.SALES.SalesDocumentVersionNumber;

        sboObject.SALES.ValidFrom = docObj.SALES.ValidFrom != null ? docObj.SALES.ValidFrom : Date.today();
        sboObject.SALES.ValidTo = docObj.SALES.ValidTo != null ? docObj.SALES.ValidTo : Date.today() + 30;
        sboObject.SALES.DateforPricingExchangeRate = docObj.SALES.DateforPricingExchangeRate != null ? docObj.SALES.DateforPricingExchangeRate : Date.today();
        sboObject.SALES.RequestedDeliveryDate = docObj.SALES.RequestedDeliveryDate != null ? docObj.SALES.RequestedDeliveryDate : Date.today();
        sboObject.SALES.BillingBlock = docObj.SALES.BillingBlock;
        sboObject.SALES.DeliveryBlock = docObj.SALES.DeliveryBlock;

        // SHIPPING
        if (String.isNotEmpty(docObj.ShippingConditions)) sboObject.SHIPPING.ShippingConditions = docObj.ShippingConditions;

        // ORDERDATA
        if (String.isNotEmpty(docObj.CollectiveNumber)) sboObject.ORDERDATA.CollectiveNumber = docObj.CollectiveNumber;
        if (String.isNotEmpty(docObj.YourReference)) sboObject.ORDERDATA.YourReference = docObj.YourReference;
        if (String.isNotEmpty(docObj.CustomerPurchaseOrderType)) sboObject.ORDERDATA.CustomerPurchaseOrderType = docObj.CustomerPurchaseOrderType;
    }

    // Mapping of newly added Items to SBO
    private void mapNewItemsToSBO(ensxtx_SBO_EnosixSalesDocument_Detail.EnosixSalesDocument sboObject, List<ensxtx_DS_Document_Detail.ITEMS> items, Boolean updateAfterSimulte)
    {
        Integer itemTot = items.size();
        for (Integer itemCnt = 0 ; itemCnt < itemTot ; itemCnt++)
        {
            ensxtx_DS_Document_Detail.ITEMS item = items[itemCnt];
            Boolean isMainItem = String.isEmpty(item.BillOfMaterial) || Integer.valueOf(item.HigherLevelItemNumber) == 0;

            if (this.appSettings.enableBoMItemEdit || isMainItem)
            {
                if (!updateAfterSimulte) {
                    ensxtx_SBO_EnosixSalesDocument_Detail.ITEMS newItem = new ensxtx_SBO_EnosixSalesDocument_Detail.ITEMS();
                    mapItemFieldsToSBO(newItem, item);
                    sboObject.ITEMS.add(newItem);

                    // Item Texts
                    Integer textTot = item.ItemTexts == null ? 0 : item.ItemTexts.size();
                    for (Integer textCnt = 0 ; textCnt < textTot ; textCnt++)
                    {
                        ensxtx_DS_Document_Detail.TEXTS text = item.ItemTexts[textCnt];
                        ensxtx_SBO_EnosixSalesDocument_Detail.ITEMS_TEXT sboItemsText = new ensxtx_SBO_EnosixSalesDocument_Detail.ITEMS_TEXT();
                        mapItemsTextToSBO(sboItemsText, item.ItemNumber, text);
                        sboObject.ITEMS_TEXT.add(sboItemsText);
                    }

                    // Add Item Conditions
                    Integer condTot = item.ItemConditions == null ? 0 : item.itemConditions.size();
                    for (Integer condCnt = 0 ; condCnt < condTot ; condCnt++)
                    {
                        ensxtx_DS_Document_Detail.CONDITIONS itemCondition = item.itemConditions[condCnt];
                        ensxtx_SBO_EnosixSalesDocument_Detail.CONDITIONS newItemCondition = new ensxtx_SBO_EnosixSalesDocument_Detail.CONDITIONS();
                        mapConditionFieldsToSBO(newItemCondition, itemCondition, item.ItemNumber, sboObject.SalesDocumentCurrency);
                        sboObject.CONDITIONS.add(newItemCondition);
                    }

                    // Partners
                    if (item.PARTNERS != null && item.PARTNERS.size() > 0){
                        Integer partnerTot = item.PARTNERS.size();
                        for (Integer partnerCnt = 0; partnerCnt < partnerTot; partnerCnt++)
                        {
                            ensxtx_DS_Document_Detail.PARTNERS itemPartner = item.PARTNERS[partnerCnt];
                            ensxtx_SBO_EnosixSalesDocument_Detail.PARTNERS sboPartner = createNewPartnerSBO(itemPartner, item.ItemNumber);
                            if (sboPartner != null) {
                                // If new item & partner to that item added while update
                                if (String.isNotEmpty(sboObject.SalesDocument)) sboPartner.PartnerChangedFlag = true;

                                sboObject.PARTNERS.add(sboPartner);
                            }
                        }
                    }

                    // Add Item Configs
                    if (String.isEmpty(item.RejectionReason) && item.ItemConfigurations != null && item.ItemConfigurations.size() > 0)
                    {
                        Integer configTot = item.ItemConfigurations.size();
                        for (Integer configCnt = 0 ; configCnt < configTot ; configCnt++)
                        {
                            ensxtx_DS_Document_Detail.CONFIG config = item.ItemConfigurations[configCnt];
                            if (config.UserModified != null && config.UserModified) {
                                ensxtx_SBO_EnosixSalesDocument_Detail.ITEMS_CONFIG sboItemConfig = new ensxtx_SBO_EnosixSalesDocument_Detail.ITEMS_CONFIG();
                                mapItemsConfigToSBO(sboItemConfig, item.ItemNumber, config);
                                sboObject.ITEMS_CONFIG.add(sboItemConfig);
                            }
                        }
                    }

                    // Billing Plan
                    if (item.BillingPlan != null) {
                        ensxtx_SBO_EnosixSalesDocument_Detail.BILL_PLAN sboBillingPlan = new ensxtx_SBO_EnosixSalesDocument_Detail.BILL_PLAN();
                        mapBillingPlanFieldsToSBO(sboBillingPlan, item.BillingPlan, item.ItemNumber);
                        sboObject.BILL_PLAN.add(sboBillingPlan);             
                    }
                }

                ensxtx_SBO_EnosixSalesDocument_Detail.ITEMS_ACTION sboItemAction = new ensxtx_SBO_EnosixSalesDocument_Detail.ITEMS_ACTION();
                sboItemAction.ItemNumber = item.ItemNumber;
                // Simulate call when there is a document number (Update)
                if (String.isNotEmpty(sboObject.SalesDocument)) {
                    if (item.isAdded != true && item.isChanged == true){
                        sboItemAction.ItemChanged = true;

                    }
                    else if (item.isAdded == true) {
                        sboItemAction.ItemAdded = true;
                    }
                }
                else {
                    sboItemAction.ItemAdded = true;
                }
                sboObject.ITEMS_ACTION.add(sboItemAction);
            }
        }
    }

    private ensxtx_SBO_EnosixSalesDocument_Detail.PARTNERS createNewPartnerSBO(ensxtx_DS_Document_Detail.PARTNERS partner, String itemNumber)
    {
        ensxtx_SBO_EnosixSalesDocument_Detail.PARTNERS newPartner;

        if (String.isNotEmpty(partner.CustomerNumber) || String.isNotEmpty(partner.Vendor) || String.isNotEmpty(partner.PersonnelNumber) || String.isNotEmpty(partner.ContactPersonNumber))
        {
            newPartner = new ensxtx_SBO_EnosixSalesDocument_Detail.PARTNERS();
            if (String.isNotEmpty(itemNumber)) {
                newPartner.ItemNumber = itemNumber;
            }
            newPartner.PartnerFunction = partner.PartnerFunction;
            partner.PartnerFunctionInternal = ensxtx_UTIL_Customer.partnerFunctionMap.containsKey(partner.PartnerFunction) ? ensxtx_UTIL_Customer.partnerFunctionMap.get(partner.PartnerFunction) : partner.PartnerFunctionInternal;
            newPartner.PartnerFunctionInternal = partner.PartnerFunctionInternal;

            if (String.isNotEmpty(partner.CustomerNumber) && partner.CustomerNumber.replaceFirst('^0+(?!$)', '') != '0') {
                newPartner.CustomerNumber = partner.CustomerNumber;
            }
            else if (String.isNotEmpty(partner.Vendor) && partner.Vendor.replaceFirst('^0+(?!$)', '') != '0') {
                newPartner.Vendor = partner.Vendor;
            }
            else if (String.isNotEmpty(partner.PersonnelNumber) && partner.PersonnelNumber.replaceFirst('^0+(?!$)', '') != '0') {
                newPartner.PersonnelNumber = partner.PersonnelNumber;
            }
            else if (String.isNotEmpty(partner.ContactPersonNumber) && partner.ContactPersonNumber.replaceFirst('^0+(?!$)', '') != '0') {
                newPartner.ContactPersonNumber = partner.ContactPersonNumber;
            }

            if (String.isNotEmpty(partner.PartnerName)) newPartner.PartnerName = partner.PartnerName;

            if (partner.allowAddressOverride == true) {
                if (String.isNotEmpty(partner.HouseNumber)) newPartner.HouseNumber = partner.HouseNumber;
                if (String.isNotEmpty(partner.Street)) newPartner.Street = partner.Street;
                if (String.isNotEmpty(partner.City)) newPartner.City = partner.City;
                if (String.isNotEmpty(partner.PostalCode)) newPartner.PostalCode = partner.PostalCode;
                if (String.isNotEmpty(partner.Region)) newPartner.Region = partner.Region;
                if (String.isNotEmpty(partner.Country)) newPartner.Country = partner.Country;
            }
        }

        return newPartner;
    }

    private void mapHeaderTextToSBO(ensxtx_SBO_EnosixSalesDocument_Detail.TEXTS sboText, ensxtx_DS_Document_Detail.TEXTS text)
    {
        sboText.TextID = text.TextID;
        sboText.Text = text.Text;
        sboText.TextLanguage = text.TextLanguage;
    }

    private void mapItemsTextToSBO(ensxtx_SBO_EnosixSalesDocument_Detail.ITEMS_TEXT sboItemsText, String itemNumber, ensxtx_DS_Document_Detail.TEXTS text)
    {
        sboItemsText.ItemNumber = itemNumber;
        sboItemsText.TextID = text.TextID;
        sboItemsText.Text = text.Text;
    }

    private void mapItemFieldsToSBO(ensxtx_SBO_EnosixSalesDocument_Detail.ITEMS sboItem, ensxtx_DS_Document_Detail.ITEMS item)
    {
        sboItem.ItemNumber = item.ItemNumber;
        sboItem.Material = item.Material;
        sboItem.MaterialEntered = item.MaterialEntered;
        sboItem.HigherLevelItemNumber = item.HigherLevelItemNumber;
        sboItem.ItemDescription = item.ItemDescription;
        sboItem.OrderQuantity = item.OrderQuantity;
        sboItem.ReasonForRejection = item.RejectionReason;
        sboItem.ScheduleLineDate = item.ScheduleLineDate;
        sboItem.SalesUnit = item.SalesUnit;
        sboItem.SalesUnitInternal = item.SalesUnitInternal;
        sboItem.Plant = item.Plant;
        sboItem.ItemCategory = item.ItemCategory;
        sboItem.AlternativeForItem = item.AlternativeItem;
        sboItem.ConfigurableMaterial = item.ConfigurableMaterial;
        sboItem.PriceListType = item.PriceListType;
        sboItem.ItemReferenceDocument = item.ReferenceDocument;
        sboItem.ItemReferenceDocumentItNumber = item.ReferenceItemNumber;
        sboItem.ItemReferenceDocumentCtegory = item.ReferenceDocumentCategory;
        sboItem.Materialgroup1 = item.Materialgroup1;
        sboItem.Materialgroup2 = item.Materialgroup2;
    }

    private void mapConditionFieldsToSBO(ensxtx_SBO_EnosixSalesDocument_Detail.CONDITIONS sboCondition,
        ensxtx_DS_Document_Detail.CONDITIONS condition, String itemNumber, String currencyKey)
    {
        if (String.isNotEmpty(itemNumber)) sboCondition.ConditionItemNumber = itemNumber;
        sboCondition.ConditionType = condition.ConditionType;
        sboCondition.Rate = condition.Rate;
        sboCondition.ConditionControl = 'C';
        sboCondition.CalculationType = condition.CalculationType;
        sboCondition.ConditionCounter = condition.ConditionCounter;
        sboCondition.ConditionOrigin = condition.OriginOfCondition;
        // Insert Currency for Calculation type gross weight
        if (sboCondition.CalculationType == 'D') sboCondition.CurrencyKey = currencyKey;
    }

    private void mapItemsConfigToSBO(ensxtx_SBO_EnosixSalesDocument_Detail.ITEMS_CONFIG sboItemConfig, String itemNumber, ensxtx_DS_Document_Detail.CONFIG itemConfig)
    {
        sboItemConfig.ItemNumber = itemNumber;
        sboItemConfig.CharacteristicID = itemConfig.CharacteristicID;
        sboItemConfig.CharacteristicName = itemConfig.CharacteristicName;
        sboItemConfig.CharacteristicValue = itemConfig.CharacteristicValue;
    }

    private void mapBillingPlanFieldsToSBO(ensxtx_SBO_EnosixSalesDocument_Detail.BILL_PLAN sboBillingPlan,
        ensxtx_DS_Document_Detail.BILLING_PLAN billingPlan, String itemNumber)
    {
        if (String.isNotEmpty(itemNumber)) sboBillingPlan.ItemNumber = itemNumber;
        sboBillingPlan.BillingPlanType = billingPlan.BillingPlanType;
        sboBillingPlan.BillingPlanStartDate = billingPlan.BillingPlanStartDate;
        sboBillingPlan.BillingPlanEndDate = billingPlan.BillingPlanEndDate;
        sboBillingPlan.RuleForNextBillingDateOrigin = billingPlan.RuleForNextBillingDateOrigin;
    }

    private void mapPartnersToSBOForUpdate(ensxtx_SBO_EnosixSalesDocument_Detail.EnosixSalesDocument sboObject, List<ensxtx_DS_Document_Detail.PARTNERS> objPartners, String itemNumber)
    {
        Integer partTot = objPartners.size();
        List<ensxtx_SBO_EnosixSalesDocument_Detail.PARTNERS> sboPartners = sboObject.PARTNERS.getAsList();
        List<ensxtx_SBO_EnosixSalesDocument_Detail.PARTNERS> updatedSBOPartners = new List<ensxtx_SBO_EnosixSalesDocument_Detail.PARTNERS>();
        Integer partTot2 = sboPartners.size();

        for (Integer partCnt = 0 ; partCnt < partTot ; partCnt++)
        {
            ensxtx_DS_Document_Detail.PARTNERS partner = objPartners[partCnt];
            Boolean isFound = false;

            for (Integer partCnt2 = 0 ; partCnt2 < partTot2 ; partCnt2++)
            {
                ensxtx_SBO_EnosixSalesDocument_Detail.PARTNERS sboPartner = sboPartners[partCnt2];
                if ((sboPartner.PartnerFunction == partner.PartnerFunction || sboPartner.PartnerFunctionInternal == partner.PartnerFunctionInternal) &&
                    (String.isNotEmpty(itemNumber) ? sboPartner.ItemNumber == itemNumber : sboPartner.ItemNumber.replaceFirst('^0+(?!$)', '') == '0')) 
                {
                    if (partner.isChanged == true) {
                        if (String.isNotEmpty(partner.PartnerName)) sboPartner.PartnerName = partner.PartnerName;
                        if (String.isNotEmpty(partner.CustomerNumber)) sboPartner.CustomerNumber = partner.CustomerNumber;
                        if (String.isNotEmpty(partner.Vendor)) sboPartner.Vendor = partner.Vendor;
                        if (String.isNotEmpty(partner.PersonnelNumber)) sboPartner.PersonnelNumber = partner.PersonnelNumber;
                        if (String.isNotEmpty(partner.ContactPersonNumber)) sboPartner.ContactPersonNumber = partner.ContactPersonNumber;
                        if (partner.allowAddressOverride == true) {
                            if (String.isNotEmpty(partner.HouseNumber)) sboPartner.HouseNumber = partner.HouseNumber;
                            if (String.isNotEmpty(partner.Street)) sboPartner.Street = partner.Street;
                            if (String.isNotEmpty(partner.City)) sboPartner.City = partner.City;
                            if (String.isNotEmpty(partner.PostalCode)) sboPartner.PostalCode = partner.PostalCode;
                            if (String.isNotEmpty(partner.Region)) sboPartner.Region = partner.Region;
                            if (String.isNotEmpty(partner.Country)) sboPartner.Country = partner.Country;
                        }
                        sboPartner.PartnerChangedFlag = true;
                        updatedSBOPartners.add(sboPartner);
                    }

                    isFound = true;
                    break;
                }
            }

            if (!isFound) {
                ensxtx_SBO_EnosixSalesDocument_Detail.PARTNERS sboPartner = createNewPartnerSBO(partner, itemNumber);
                if (sboPartner != null) {
                    sboPartner.PartnerChangedFlag = true;
                    updatedSBOPartners.add(sboPartner);
                }
            }
        }

        // Clear all the partners in the SBO and send only the updated partners
       
        if(String.isNotEmpty(itemNumber)) {
            for(ensxtx_SBO_EnosixSalesDocument_Detail.PARTNERS sboPartnernew : sboPartners){
                if(sboPartnernew.ItemNumber == itemNumber){
                    sboObject.PARTNERS.remove(sboPartnernew);
                }
            }
        }
        else {
            for (ensxtx_SBO_EnosixSalesDocument_Detail.PARTNERS sboPartner : sboObject.PARTNERS.getAsList()) {
                if (String.isNotEmpty(sboPartner.ItemNumber) && String.isNotEmpty(sboPartner.ItemNumber.replace('0',''))) {
                    updatedSBOPartners.add(sboPartner);
                }
            }
            sboObject.PARTNERS.clear();
        }
        if (updatedSBOPartners.size()>0) sboObject.PARTNERS.addAll(updatedSBOPartners);
    }

    private void mapHeaderTextsToSBOForUpdate(ensxtx_SBO_EnosixSalesDocument_Detail.EnosixSalesDocument sboObject, ensxtx_DS_Document_Detail salesDocDetail)
    {
        Integer textTot = salesDocDetail.TEXTS.size();
        List<ensxtx_SBO_EnosixSalesDocument_Detail.TEXTS> textList = sboObject.TEXTS.getAsList();
        Integer textTot2 = textList.size();
        for (Integer textCnt = 0 ; textCnt < textTot ; textCnt++)
        {
            ensxtx_DS_Document_Detail.TEXTS headerText = salesDocDetail.TEXTS[textCnt];
            Boolean isFound = false;

            for (Integer textCnt2 = 0 ; textCnt2 < textTot2 ; textCnt2++)
            {
                ensxtx_SBO_EnosixSalesDocument_Detail.TEXTS sboText = textList[textCnt2];
                if (sboText.TextID == headerText.TextID) {
                    mapHeaderTextToSBO(sboText, headerText);
                    isFound = true;
                    break;
                }
            }

            if (!isFound) {
                ensxtx_SBO_EnosixSalesDocument_Detail.TEXTS newText = new ensxtx_SBO_EnosixSalesDocument_Detail.TEXTS();
                mapHeaderTextToSBO(newText, headerText);
                sboObject.TEXTS.add(newText);
            }
        }
    }

    private void mapHeaderConditionsToSBOForUpdate(ensxtx_SBO_EnosixSalesDocument_Detail.EnosixSalesDocument sboObject, ensxtx_DS_Document_Detail salesDocDetail)
    {
        Integer condTot = salesDocDetail.CONDITIONS.size();
        for (Integer condCnt = 0 ; condCnt < condTot ; condCnt++)
        {
            ensxtx_DS_Document_Detail.CONDITIONS headerCondition = salesDocDetail.CONDITIONS[condCnt];
            ensxtx_SBO_EnosixSalesDocument_Detail.CONDITIONS sboCondition = new ensxtx_SBO_EnosixSalesDocument_Detail.CONDITIONS();
            mapConditionFieldsToSBO(sboCondition, headerCondition, '', sboObject.SalesDocumentCurrency);
            sboObject.CONDITIONS.add(sboCondition);
        }
    }

    private void removedItemsForUpdate(ensxtx_SBO_EnosixSalesDocument_Detail.EnosixSalesDocument sboObject, ensxtx_DS_Document_Detail salesDocDetail)
    {
        if (salesDocDetail.removedItems != null && salesDocDetail.removedItems.size() > 0)
        {
            Integer itemTot = salesDocDetail.removedItems.size();
            for (Integer itemCnt = 0 ; itemCnt < itemTot ; itemCnt++) 
            {
                String itemNumber = salesDocDetail.removedItems[itemCnt];

                ensxtx_SBO_EnosixSalesDocument_Detail.ITEMS_ACTION itemRemovedAction = new ensxtx_SBO_EnosixSalesDocument_Detail.ITEMS_ACTION();
                itemRemovedAction.ItemNumber = itemNumber;
                itemRemovedAction.ItemDeleted = true;
                sboObject.ITEMS_ACTION.add(itemRemovedAction);
            }
        }
    }

    private void mapItemsForUpdate(ensxtx_SBO_EnosixSalesDocument_Detail.EnosixSalesDocument sboObject, ensxtx_DS_Document_Detail salesDocDetail, Boolean updateAfterSimulte)
    {
        List<ensxtx_DS_Document_Detail.ITEMS> addedItems = new List<ensxtx_DS_Document_Detail.ITEMS>();
        List<ensxtx_DS_Document_Detail.ITEMS> changedItems = new List<ensxtx_DS_Document_Detail.ITEMS>();
        Set<String> changedItemNumbers = new Set<String>();
        Set<String> alternativeItemNumbers = new Set<String>();

        Integer itemTot = salesDocDetail.ITEMS.size();
        for (Integer itemCnt = 0 ; itemCnt < itemTot ; itemCnt++)
        {
            ensxtx_DS_Document_Detail.ITEMS item = salesDocDetail.ITEMS[itemCnt];
            if (item.isAdded == true) {
                salesDocDetail.callSimulateBeforeUpdate = true;
                addedItems.add(item);

                // When a newly added item has Alternative Item Value
                // Need to include the Alternative Item as changed item
                if (String.isNotEmpty(item.AlternativeItem) && item.AlternativeItem.replaceFirst('^0+(?!$)', '') != '0') {
                    alternativeItemNumbers.add(item.AlternativeItem);
                }
            }
            else if (item.isChanged == true) {
                changedItems.add(item);
                changedItemNumbers.add(item.ItemNumber);
            }
        }

        if (alternativeItemNumbers.size() > 0) {
            itemTot = salesDocDetail.ITEMS.size();
            for (Integer itemCnt = 0 ; itemCnt < itemTot ; itemCnt++)
            {
                ensxtx_DS_Document_Detail.ITEMS item = salesDocDetail.ITEMS[itemCnt];
                if (alternativeItemNumbers.contains(item.ItemNumber) && !changedItemNumbers.contains(item.ItemNumber)) {
                    changedItems.add(item);
                }
            }
        }

        if (changedItems.size() > 0) {
            itemTot = changedItems.size();
            List<ensxtx_SBO_EnosixSalesDocument_Detail.ITEMS_TEXT> textList = sboObject.ITEMS_TEXT.getAsList();
            Integer textTot2 = textList.size();
            List<ensxtx_SBO_EnosixSalesDocument_Detail.ITEMS> itemList = sboObject.ITEMS.getAsList();
            Integer itemTot2 = itemList.size();
            List<ensxtx_SBO_EnosixSalesDocument_Detail.BILL_PLAN> billPlanList = sboObject.BILL_PLAN.getAsList();
            Integer billPlanTot = billPlanList.size();

            for (Integer itemCnt = 0 ; itemCnt < itemTot ; itemCnt++)
            {
                ensxtx_DS_Document_Detail.ITEMS item = changedItems[itemCnt];

                if (!updateAfterSimulte) {
                    mapPartnersToSBOForUpdate(sboObject, item.PARTNERS, item.ItemNumber);

                    Integer condTot = item.ItemConditions == null ? 0 : item.ItemConditions.size();
                    for (Integer condCnt = 0 ; condCnt < condTot ; condCnt++)
                    {
                        ensxtx_DS_Document_Detail.CONDITIONS itemCondition = item.ItemConditions[condCnt];
                        ensxtx_SBO_EnosixSalesDocument_Detail.CONDITIONS sboCondition = new ensxtx_SBO_EnosixSalesDocument_Detail.CONDITIONS();
                        mapConditionFieldsToSBO(sboCondition, itemCondition, item.ItemNumber, sboObject.SalesDocumentCurrency);
                        sboObject.CONDITIONS.add(sboCondition);
                    }

                    Integer textTot = item.ItemTexts == null ? 0 : item.ItemTexts.size();
                    for (Integer textCnt = 0 ; textCnt < textTot ; textCnt++)
                    {
                        ensxtx_DS_Document_Detail.TEXTS itemText = item.ItemTexts[textCnt];
                        for (Integer textCnt2 = 0 ; textCnt2 < textTot2 ; textCnt2++)
                        {
                            ensxtx_SBO_EnosixSalesDocument_Detail.ITEMS_TEXT sboItemText = textList[textCnt2];

                            if (item.ItemNumber == sboItemText.ItemNumber && itemText.TextID == sboItemText.TextID) {
                                sboItemText.Text = itemText.Text;
                                break;
                            }
                        }
                    }

                    for (Integer billPlanCnt = 0; billPlanCnt < billPlanTot; billPlanCnt++)
                    {
                        ensxtx_SBO_EnosixSalesDocument_Detail.BILL_PLAN sboBillingPlan = billPlanList[billPlanCnt];
                        if (sboBillingPlan.ItemNumber == item.ItemNumber)
                        {
                            mapBillingPlanFieldsToSBO(sboBillingPlan, item.BillingPlan, sboBillingPlan.ItemNumber);
                            break;
                        }
                    }

                    Integer configTot = item.ItemConfigurations == null ? 0 : item.ItemConfigurations.size();
                    if (String.isEmpty(item.RejectionReason)) {
                        for (Integer configCnt = 0; configCnt < configTot; configCnt++)
                        {
                            ensxtx_DS_Document_Detail.CONFIG itemConfig = item.ItemConfigurations[configCnt];
                            if (itemConfig.UserModified == true) {
                                ensxtx_SBO_EnosixSalesDocument_Detail.ITEMS_CONFIG sboItemConfig = new ensxtx_SBO_EnosixSalesDocument_Detail.ITEMS_CONFIG();
                                mapItemsConfigToSBO(sboItemConfig, item.ItemNumber, itemConfig);
                                sboObject.ITEMS_CONFIG.add(sboItemConfig);
                            }
                        }
                    }

                    for (Integer itemCnt2 = 0 ; itemCnt2 < itemTot2 ; itemCnt2++)
                    {
                        ensxtx_SBO_EnosixSalesDocument_Detail.ITEMS sboItem = itemList[itemCnt2];

                        if (sboItem.ItemNumber.leftPad(6, '0') == item.ItemNumber.leftPad(6, '0')) {
                            mapItemFieldsToSBO(sboItem, item);
                            break;
                        }
                    }
                }

                ensxtx_SBO_EnosixSalesDocument_Detail.ITEMS_ACTION itemChangedAction = new ensxtx_SBO_EnosixSalesDocument_Detail.ITEMS_ACTION();
                itemChangedAction.ItemNumber = item.ItemNumber;
                itemChangedAction.ItemChanged = true;
                sboObject.ITEMS_ACTION.add(itemChangedAction);
            }
        }
        if (addedItems.size() > 0) {
            mapNewItemsToSBO(sboObject, addedItems, updateAfterSimulte);
        }
    }
    // #endregion Convert to SBO Mapping




    // #region Convert to DS Object mapping

    // Implementation of Converting SBO Detail Object to ensxtx_DS_Document_Detail Object
    // This conversion is use before sending the detail object to Front-end
    public void convertToObject(ensxsdk.EnosixFramework.DetailObject detailObj, ensxtx_DS_Document_Detail docObj, 
        Boolean isFromGetDetail, ensxtx_DS_SalesDocAppSettings appSettings, ensxtx_UTIL_Document_Detail.convertToObjectTrigger convertTrigger)
    {
        ensxtx_SBO_EnosixSalesDocument_Detail.EnosixSalesDocument sboObject = (ensxtx_SBO_EnosixSalesDocument_Detail.EnosixSalesDocument) detailObj;

        if (appSettings.useConvertToObjectTrigger && 
            (convertTrigger == ensxtx_UTIL_Document_Detail.convertToObjectTrigger.createSAPDocument || 
            convertTrigger == ensxtx_UTIL_Document_Detail.convertToObjectTrigger.updateSAPDocument)) 
        {
            docObj.SalesDocument = sboObject.SalesDocument;
            docObj.IsSuccess = sboObject.isSuccess();
            return;
        }

        convertSBOHeaderAndSales(docObj, sboObject);

        // CONDITIONS
        // Get all the conditions from the SBO
        // Store the Item conditions in a map
        Map<String, List<ensxtx_DS_Document_Detail.CONDITIONS>> itemNumberConditions = new Map<String, List<ensxtx_DS_Document_Detail.CONDITIONS>>();
        docObj.SBOHeaderConditions = new List<ensxtx_DS_Document_Detail.CONDITIONS>();
        
        List<ensxtx_SBO_EnosixSalesDocument_Detail.CONDITIONS> condList = sboObject.CONDITIONS.getAsList();
        Integer condTot = condList.size();
        for (Integer condCnt = 0 ; condCnt < condTot ; condCnt++)
        {
            ensxtx_SBO_EnosixSalesDocument_Detail.CONDITIONS condition = condList[condCnt];

            if (String.isNotEmpty(condition.ConditionItemNumber) && condition.ConditionItemNumber.replaceFirst('^0+(?!$)', '') != '0')
            {
                List<ensxtx_DS_Document_Detail.CONDITIONS> conditions = itemNumberConditions.get(condition.ConditionItemNumber.leftPad(6, '0'));
                if (null == conditions)
                {
                    conditions = new List<ensxtx_DS_Document_Detail.CONDITIONS>();
                }
                conditions.add(convertSBOCondition(condition));
                itemNumberConditions.put(condition.ConditionItemNumber.leftPad(6, '0'), conditions);
            }
            else
            {
                docObj.SBOHeaderConditions.add(convertSBOCondition(condition));
            }
        }

        // Item Number that has 'Configuration' (Translated to other languages as well)
        // INCOMPLETION_LOG
        Set<String> itemNumbersNeedConfigure = new Set<String>();
        docObj.IncompletionLogs = new List<ensxtx_DS_Document_Detail.INCOMPLETION_LOG>();
        Map<String, List<ensxtx_DS_Document_Detail.INCOMPLETION_LOG>> itemNumberIncompletionLogs = new Map<String, List<ensxtx_DS_Document_Detail.INCOMPLETION_LOG>>();

        List<ensxtx_SBO_EnosixSalesDocument_Detail.INCOMPLETION_LOG> logList = sboObject.INCOMPLETION_LOG.getAsList();

        // Set isIncomplete to true if there are incompletion logs
        if (logList.size() > 0 && (appSettings.showHeaderIncompletionLogs == true || appSettings.showItemIncompletionLogs == true))
        {
            docObj.isIncomplete = true;
            if (appSettings.incompletionLogsAsErrors == true && ensxtx_UTIL_Document_Detail.convertToObjectTrigger.simulateSalesDoc == convertTrigger) {
                ensxtx_UTIL_PageMessages.addMessage(ensxtx_UTIL_PageMessages.ERROR,
                    'There are Incompletion Logs on the ' + appSettings.SAPDocType);
            }
        }
        else docObj.isIncomplete = false;

        Integer logTot = logList.size();
        for (Integer logCnt = 0 ; logCnt < logTot ; logCnt++)
        {
            ensxtx_SBO_EnosixSalesDocument_Detail.INCOMPLETION_LOG log = logList[logCnt];
            Boolean isLineLog = String.isNotEmpty(log.ItemNumber) && log.ItemNumber.replaceFirst('^0+(?!$)', '') != '0';
            if (isLineLog)
            {
                List<ensxtx_DS_Document_Detail.INCOMPLETION_LOG> incompletionLogs = itemNumberIncompletionLogs.get(log.ItemNumber.leftPad(6, '0'));
                if (null == incompletionLogs)
                {
                    incompletionLogs = new List<ensxtx_DS_Document_Detail.INCOMPLETION_LOG>();
                }
                incompletionLogs.add(convertSBOIncompletionLog(log));
                itemNumberIncompletionLogs.put(log.ItemNumber.leftPad(6, '0'), incompletionLogs);

                if (ensxtx_UTIL_SalesDoc.configurationLogText.contains(log.Description)) {
                    itemNumbersNeedConfigure.add(log.ItemNumber);
                }
            }
            else
            {
                docObj.IncompletionLogs.add(convertSBOIncompletionLog(log));
            }
            if (String.isNotEmpty(appSettings.InvokeMethod) &&
                appSettings.incompletionLogsAsErrors == true &&
                ((appSettings.showItemIncompletionLogs == true && isLineLog) || 
                (appSettings.showHeaderIncompletionLogs == true && !isLineLog))) 
            {
                String message = '';
                if (String.isNotEmpty(log.TextID)) message += 'TextID=' + log.TextID + ' ';
                if (String.isNotEmpty(log.Description)) message += 'Description=' + log.Description + ' ';
                if (String.isNotEmpty(log.ItemNumber)) message += 'ItemNumber=' + log.ItemNumber + ' ';
                if (String.isNotEmpty(log.ScheduleLineNumber)) message += 'ScheduleLineNumber=' + log.ScheduleLineNumber + ' ';
                if (String.isNotEmpty(log.PartnerFunction)) message += 'PartnerFunction=' + log.PartnerFunction + ' ';
                if (String.isNotEmpty(log.TableName)) message += 'TableName=' + log.TableName + ' ';
                if (String.isNotEmpty(log.FieldName)) message += 'FieldName=' + log.FieldName + ' ';
                if (String.isNotEmpty(log.IncompletionProcedure)) message += 'IncompletionProcedure=' + log.IncompletionProcedure + ' ';
                if (String.isNotEmpty(log.StatusGroup)) message += 'StatusGroup=' + log.StatusGroup + ' ';
                // if (log.DataAging != null) message s+= 'DataAging=' + log.DataAging + ' ';
                ensxtx_UTIL_PageMessages.addMessage(ensxtx_UTIL_PageMessages.ERROR, message);
            }
        }

        // BILLING PLAN
        Map<String, ensxtx_DS_Document_Detail.BILLING_PLAN> itemNumberBillingPlan = new Map<String, ensxtx_DS_Document_Detail.BILLING_PLAN>();
        List<ensxtx_SBO_EnosixSalesDocument_Detail.BILL_PLAN> billPlanList = sboObject.BILL_PLAN.getAsList();
        Integer billPlanTot = billPlanList.size();
        for (Integer billPlanCnt = 0; billPlanCnt < billPlanTot; billPlanCnt++)
        {
            ensxtx_SBO_EnosixSalesDocument_Detail.BILL_PLAN sboBillingPlan = billPlanList[billPlanCnt];
            if (String.isNotEmpty(sboBillingPlan.ItemNumber))
            {
                itemNumberBillingPlan.put(sboBillingPlan.ItemNumber.leftPad(6, '0'), convertSBOBillingPlan(sboBillingPlan));
            }
        }

        //BILLING PLAN DATES
        Map<String, List<ensxtx_DS_Document_Detail.BILLING_PLAN_DATES>> itemNumberBillingPlanDates = new Map<String, List<ensxtx_DS_Document_Detail.BILLING_PLAN_DATES>>(); 
        List<ensxtx_SBO_EnosixSalesDocument_Detail.BILLING_PLAN_DATES> billPlanDateList = sboObject.BILLING_PLAN_DATES.getAsList();
        Integer billPlanDateTot = billPlanDateList.size();
        for (Integer billPlanDateCnt = 0; billPlanDateCnt < billPlanDateTot; billPlanDateCnt++)
        {
            ensxtx_SBO_EnosixSalesDocument_Detail.BILLING_PLAN_DATES sboBillingPlanDate = billPlanDateList[billPlanDateCnt];
            if (String.isNotEmpty(sboBillingPlanDate.ItemNumber))
            {
                List<ensxtx_DS_Document_Detail.BILLING_PLAN_DATES> billPlanDates = itemNumberBillingPlanDates.get(sboBillingPlanDate.ItemNumber.leftPad(6, '0'));
                if (billPlanDates == null) {
                    billPlanDates = new List<ensxtx_DS_Document_Detail.BILLING_PLAN_DATES>();
                }
                billPlanDates.add(convertSBOBillingPlanDate(sboBillingPlanDate));
                itemNumberBillingPlanDates.put(sboBillingPlanDate.ItemNumber.leftPad(6, '0'), billPlanDates);
            }
        }

        Map<String, List<ensxtx_DS_Document_Detail.SCHEDULE>> itemNumberItemSchedules = 
            new Map<String, List<ensxtx_DS_Document_Detail.SCHEDULE>>();

        // Convert SBO Items Schedule
        List<ensxtx_SBO_EnosixSalesDocument_Detail.ITEMS_SCHEDULE> schedList = sboObject.ITEMS_SCHEDULE.getAsList();
        Integer schedTot = schedList.size();
        for (Integer schedCnt = 0 ; schedCnt < schedTot ; schedCnt++)
        {
            ensxtx_SBO_EnosixSalesDocument_Detail.ITEMS_SCHEDULE sboItemSched = schedList[schedCnt];
            List<ensxtx_DS_Document_Detail.SCHEDULE> itemScheds = itemNumberItemSchedules.get(sboItemSched.ItemNumber.leftPad(6, '0'));
            if (null == itemScheds) {
                itemScheds = new List<ensxtx_DS_Document_Detail.SCHEDULE>();
            }

            itemScheds.add(convertSBOSched(sboItemSched));
            itemNumberItemSchedules.put(sboItemSched.ItemNumber.leftPad(6, '0'), itemScheds);
        }

        // Store the current Items in a map
        Map<String, ensxtx_DS_Document_Detail.ITEMS> itemNumberItem = new Map<String, ensxtx_DS_Document_Detail.ITEMS>();
        Integer itemTot = docObj.ITEMS.size();
        for (Integer itemCnt = 0 ; itemCnt < itemTot ; itemCnt++)
        {            
            ensxtx_DS_Document_Detail.ITEMS item = docObj.ITEMS[itemCnt];
            itemNumberItem.put(item.ItemNumber.leftPad(6, '0'), item);            
        }

        Map<String, List<ensxtx_DS_Document_Detail.TEXTS>> itemNumberItemsText = 
            new Map<String, List<ensxtx_DS_Document_Detail.TEXTS>>();
        Map<String, List<ensxtx_DS_Document_Detail.CONFIG>> itemNumberItemsConfig = 
            new Map<String, List<ensxtx_DS_Document_Detail.CONFIG>>();
        Map<String, List<ensxtx_DS_Document_Detail.PARTNERS>> itemNumberItemPartners = 
            new Map<String, List<ensxtx_DS_Document_Detail.PARTNERS>>();

        if (isFromGetDetail)
        {
            // Get the added Condition from the SBO
            docObj.CONDITIONS = ensxtx_UTIL_SBOAdapter.getAddedConditions(docObj.SBOHeaderConditions, true);

            // Get all the SBO Partners
            List<ensxtx_SBO_EnosixSalesDocument_Detail.PARTNERS> partnerList = sboObject.PARTNERS.getAsList();
            Integer partnerTot = partnerList.size();
            for (Integer partnerCnt = 0 ; partnerCnt < partnerTot ; partnerCnt++)
            {
                ensxtx_SBO_EnosixSalesDocument_Detail.PARTNERS sboPartner = partnerList[partnerCnt];
                List<ensxtx_DS_Document_Detail.PARTNERS> itemPartners = itemNumberItemPartners.get(sboPartner.ItemNumber.leftPad(6, '0'));
                if (itemPartners == null) {
                    itemPartners = new List<ensxtx_DS_Document_Detail.PARTNERS>();
                }
                itemPartners.add(convertSBOPartner(sboPartner));
                itemNumberItemPartners.put(sboPartner.ItemNumber.leftPad(6, '0'), itemPartners);
            }            
            docObj.PARTNERS = ensxtx_UTIL_SBOAdapter.filterPartners(
                appSettings.Header.PartnerPickers, docObj.PARTNERS, itemNumberItemPartners.get('000000'));
                
            // Convert SBO Header Text
            List<ensxtx_DS_Document_Detail.TEXTS> headerTexts = new List<ensxtx_DS_Document_Detail.TEXTS>();
            List<ensxtx_SBO_EnosixSalesDocument_Detail.TEXTS> textList = sboObject.TEXTS.getAsList();
            Integer textTot = textList.size();
            for (Integer textCnt = 0 ; textCnt < textTot ; textCnt++)
            {
                ensxtx_SBO_EnosixSalesDocument_Detail.TEXTS sboHeaderText = textList[textCnt];
                headerTexts.add(convertSBOText(sboHeaderText));
            }
            docObj.TEXTS = ensxtx_UTIL_SBOAdapter.filterTexts(docObj.TEXTS, headerTexts, appSettings.Header.Texts);

            // Convert SBO Items Text
            List<ensxtx_SBO_EnosixSalesDocument_Detail.ITEMS_TEXT> textList2 = sboObject.ITEMS_TEXT.getAsList();
            Integer textTot2 = textList2.size();
            for (Integer textCnt2 = 0 ; textCnt2 < textTot2 ; textCnt2++)
            {
                ensxtx_SBO_EnosixSalesDocument_Detail.ITEMS_TEXT sboItemText = textList2[textCnt2];
                List<ensxtx_DS_Document_Detail.TEXTS> itemTexts = itemNumberItemsText.get(sboItemText.ItemNumber.leftPad(6, '0'));
                if (null == itemTexts) {
                    itemTexts = new List<ensxtx_DS_Document_Detail.TEXTS>();
                }

                itemTexts.add(convertSBOText(sboItemText));
                itemNumberItemsText.put(sboItemText.ItemNumber.leftPad(6, '0'), itemTexts);
            }

            // Convert SBO Items Config
            List<ensxtx_SBO_EnosixSalesDocument_Detail.ITEMS_CONFIG> configList = sboObject.ITEMS_CONFIG.getAsList();
            Integer configTot = configList.size();
            for (Integer configCnt = 0 ; configCnt < configTot ; configCnt++)
            {
                ensxtx_SBO_EnosixSalesDocument_Detail.ITEMS_CONFIG sboItemConfig = configList[configCnt];
                List<ensxtx_DS_Document_Detail.CONFIG> itemConfigs = itemNumberItemsConfig.get(sboItemConfig.ItemNumber.leftPad(6, '0'));
                if (null == itemConfigs) {
                    itemConfigs = new List<ensxtx_DS_Document_Detail.CONFIG>();
                }

                itemConfigs.add(convertSBOConfig(sboItemConfig));
                itemNumberItemsConfig.put(sboItemConfig.ItemNumber.leftPad(6, '0'), itemConfigs);
            }
        }

        // ITEMS
        // Mapping of items from SBO to DS Object
        docObj.ITEMS = new List<ensxtx_DS_Document_Detail.ITEMS>();
        List<ensxtx_SBO_EnosixSalesDocument_Detail.ITEMS> itemList = sboObject.ITEMS.getAsList();
        itemTot = itemList.size();
        for (Integer itemCnt = 0 ; itemCnt < itemTot ; itemCnt++)
        {
            ensxtx_SBO_EnosixSalesDocument_Detail.ITEMS sboItem = itemList[itemCnt];
            ensxtx_DS_Document_Detail.ITEMS newItem = new ensxtx_DS_Document_Detail.ITEMS();
            newItem.ItemIncompletionLogs = new List<ensxtx_DS_Document_Detail.INCOMPLETION_LOG>();
            newItem.SBOItemConditions = new List<ensxtx_DS_Document_Detail.CONDITIONS>();
            newItem.BillingPlan = null;
            newItem.BillingPlanDates = new List<ensxtx_DS_Document_Detail.BILLING_PLAN_DATES>();
            newItem.ItemSchedules = new List<ensxtx_DS_Document_Detail.SCHEDULE>();
            List<ensxtx_DS_Document_Detail.CONDITIONS> sboConditions = new List<ensxtx_DS_Document_Detail.CONDITIONS>();

            String sboItemNumber = String.isNotEmpty(sboItem.CustomerPurchaseOrderItemNumber) ? sboItem.CustomerPurchaseOrderItemNumber : sboItem.ItemNumber;
            ensxtx_DS_Document_Detail.ITEMS currentItem = itemNumberItem.get(sboItemNumber.leftPad(6, '0'));

            if (itemNumberConditions.containsKey(sboItem.ItemNumber.leftPad(6, '0'))) newItem.SBOItemConditions = itemNumberConditions.get(sboItem.ItemNumber.leftPad(6, '0'));

            if (null != currentItem) {
                newItem.SFId = currentItem.SFId;
                newItem.CPQNumber = currentItem.CPQNumber;
                newItem.ProductId = currentItem.ProductId;
                newItem.OptionConfigurationKeys = currentItem.OptionConfigurationKeys;
                newItem.ItemConditions = currentItem.ItemConditions;
                newItem.ItemConfigurations = currentItem.ItemConfigurations;
                newItem.ItemTexts = currentItem.ItemTexts;
                newItem.isConfigurationFromVCComplete = currentItem.isConfigurationFromVCComplete;
                newItem.BOMMaterial = currentItem.BOMMaterial;
                newItem.isAdded = currentItem.isAdded;
                newItem.isChanged = currentItem.isChanged;
                newItem.PARTNERS = currentItem.PARTNERS;
                newItem.ItemConditions = ensxtx_UTIL_SBOAdapter.getAddedConditions(newItem.SBOItemConditions, false);
            }
            else {
                newItem.ItemConditions = ensxtx_UTIL_SBOAdapter.getAddedConditions(newItem.SBOItemConditions, false);
                newItem.ItemTexts = ensxtx_UTIL_SBOAdapter.filterTexts(new List<ensxtx_DS_Document_Detail.TEXTS>(), itemNumberItemsText.get(sboItem.ItemNumber.leftPad(6, '0')), appSettings.Item.Texts);
                newItem.ItemConfigurations = itemNumberItemsConfig.get(sboItem.ItemNumber.leftPad(6, '0'));
            }
            newItem.PARTNERS = ensxtx_UTIL_SBOAdapter.filterPartners(appSettings.Item.PartnerPickers, new List<ensxtx_DS_Document_Detail.PARTNERS>(), itemNumberItemPartners.get(sboItem.ItemNumber.leftPad(6, '0')));
            if(appSettings.DefaultDocType == 'YORD' && (appSettings.InvokeMethod == 'Simulate' || appSettings.InvokeMethod == 'Create')){
                sboConditions = ensxtx_UTIL_SBOAdapter.getfilteredSBOConditions(newItem.SBOItemConditions, false);
                newItem.ItemConditions.addAll(sboConditions);
            }
            if (itemNumberIncompletionLogs.containsKey(sboItem.ItemNumber.leftPad(6, '0'))) newItem.ItemIncompletionLogs = itemNumberIncompletionLogs.get(sboItem.ItemNumber.leftPad(6, '0'));
            if (itemNumberBillingPlan.containsKey(sboItem.ItemNumber.leftPad(6, '0'))) newItem.BillingPlan = itemNumberBillingPlan.get(sboItem.ItemNumber.leftPad(6, '0'));
            if (itemNumberBillingPlanDates.containsKey(sboItem.ItemNumber.leftPad(6, '0'))) newItem.BillingPlanDates = itemNumberBillingPlanDates.get(sboItem.ItemNumber.leftPad(6, '0'));
            newItem.ItemSchedules = itemNumberItemSchedules.get(sboItem.ItemNumber.leftPad(6, '0'));

            convertSBOItem(newItem, sboItem, sboObject.SalesDocument);

            newItem.isNeedConfigure = itemNumbersNeedConfigure.contains(sboItem.ItemNumber) &&
                (newItem.isConfigurationFromVCComplete == null || !newItem.isConfigurationFromVCComplete) ? true : false;

            docObj.ITEMS.add(newItem);
        }
    }

    private void convertSBOHeaderAndSales(ensxtx_DS_Document_Detail docObj, ensxtx_SBO_EnosixSalesDocument_Detail.EnosixSalesDocument sboObject)
    {
        // HEADER
        docObj.SalesDocument = sboObject.SalesDocument;
        if(String.isNotBlank(sboObject.SoldToParty)) docObj.SoldToParty = sboObject.SoldToParty;
        docObj.SoldToPartyText = sboObject.SoldToPartyText;
        docObj.SalesDocumentCurrency = sboObject.SALES.SalesDocumentCurrency;
        docObj.CustomerPurchaseOrderNumber = sboObject.CustomerPurchaseOrderNumber;
        docObj.CustomerPurchaseOrderDate = sboObject.CustomerPurchaseOrderDate;
        docObj.NetOrderValue = sboObject.NetOrderValue;
        docObj.ReferenceDocument = sboObject.ReferenceDocument;
        docObj.ReferenceDocumentCategory = sboObject.ReferenceDocumentCategory;
        docObj.YourReference= sboObject.YourReference;
        docObj.TaxAmount = sboObject.TaxAmount;
        docObj.Cupon = sboObject.Cupon;
        docObj.CouponDiscount = sboObject.CouponDiscount;
        docObj.ShippingAmount = sboObject.ShippingAmount;
        docObj.B2BOrderFlag = sboObject.B2BOrderFlag;
        docObj.IsSuccess = sboObject.isSuccess();
        docObj.NeedToSimulate = false;

        // SALES
        docObj.SALES.CreateDate = sboObject.SALES.CreateDate;
        docObj.SALES.SalesDocumentType = sboObject.SALES.SalesDocumentType;
        docObj.SALES.SalesDocumentTypeInternal = sboObject.SALES.SalesDocumentTypeInternal;
        docObj.SALES.SalesOrganization = sboObject.SALES.SalesOrganization;
        docObj.SALES.DistributionChannel = sboObject.SALES.DistributionChannel;
        docObj.SALES.Division = sboObject.SALES.Division;
        docObj.SALES.PricingProcedureInPricing = sboObject.SALES.PricingProcedureInPricing;
        docObj.SALES.PriceGroup = sboObject.SALES.PriceGroup;
        docObj.SALES.PriceListType = sboObject.SALES.PriceListType;
        docObj.SALES.SalesDistrict = sboObject.SALES.SalesDistrict;
        docObj.SALES.SalesOffice = sboObject.SALES.SalesOffice;
        docObj.SALES.OrderReason = sboObject.SALES.OrderReason;
        docObj.SALES.CustomerGroup = sboObject.SALES.CustomerGroup;
        docObj.SALES.ValidFrom = sboObject.SALES.ValidFrom;
        docObj.SALES.ValidTo = sboObject.SALES.ValidTo;
        docObj.SALES.DateforPricingExchangeRate = sboObject.SALES.DateforPricingExchangeRate;
        docObj.SALES.RequestedDeliveryDate = sboObject.SALES.RequestedDeliveryDate;
        docObj.SALES.TermsofPaymentKey = sboObject.SALES.TermsofPaymentKey;
        docObj.SALES.IncotermsPart1 = sboObject.SALES.IncotermsPart1;
        docObj.SALES.IncotermsPart2 = sboObject.SALES.IncotermsPart2;
        docObj.SALES.BillingBlock = sboObject.SALES.BillingBlock;
        docObj.SALES.BillingBlockDescription = sboObject.SALES.BillingBlockDescription;
        docObj.SALES.DeliveryBlock = sboObject.SALES.DeliveryBlock;
        docObj.SALES.DeliveryBlockDescription = sboObject.SALES.DeliveryBlockDescription;

        // SHIPPING
        docObj.ShippingConditions = sboObject.SHIPPING.ShippingConditions;
    }

    private void convertSBOItem(ensxtx_DS_Document_Detail.ITEMS newItem, ensxtx_SBO_EnosixSalesDocument_Detail.ITEMS sboItem, String SalesDocumentNumber)
    {
        // Savvas return the original item number in CustomerPurchaseOrderItemNumber
        newItem.ItemNumber = String.isNotEmpty(sboItem.CustomerPurchaseOrderItemNumber) ? sboItem.CustomerPurchaseOrderItemNumber : sboItem.ItemNumber;
        newItem.SalesDocumentNumber = SalesDocumentNumber;
        newItem.HigherLevelItemNumber = sboItem.HigherLevelItemNumber;
        newItem.Material = sboItem.Material;
        newItem.MaterialEntered = sboItem.MaterialEntered;
        newItem.ItemDescription = sboItem.ItemDescription;
        newItem.Plant = sboItem.Plant;
        newItem.ScheduleLineDate = sboItem.ScheduleLineDate;
        newItem.OrderQuantity = sboItem.OrderQuantity;
        newItem.NetItemPrice = sboItem.NetItemPrice;
        newItem.ItemCategory = sboItem.ItemCategory;
        newItem.BillingBlockStatus = sboItem.BillingBlockStatus;
        newItem.DeliveryBlockStatus = sboItem.DeliveryBlockStatus;
        newItem.ConditionPricingUnit = sboItem.ConditionPricingUnit;
        newItem.AlternativeItem = sboItem.AlternativeForItem;
        newItem.NetOrderValue = sboItem.NetOrderValue;
        newItem.SalesUnit = sboItem.SalesUnit;
        newItem.SalesUnitInternal = sboItem.SalesUnitInternal;
        newItem.BaseUnitOfMeasure = sboItem.BaseUnitOfMeasure;
        newItem.GrossWeight = sboItem.GrossWeight;
        newItem.NetWeight = sboItem.NetWeight;
        newItem.WeightUnit = sboItem.WeightUnit;
        newItem.RejectionReason = sboItem.ReasonForRejection;
        newItem.SalesDocumentCurrency = sboItem.SalesDocumentCurrency;
        newItem.ConfigurableMaterial = sboItem.ConfigurableMaterial;
        newItem.PriceListType = sboItem.PriceListType;
        newItem.ReferenceItemNumber = sboItem.ItemReferenceDocumentItNumber;
        newItem.ReferenceDocument = sboItem.ItemReferenceDocument;
        newItem.ReferenceDocumentCategory = sboItem.ItemReferenceDocumentCtegory;
        newItem.Materialgroup1 = sboItem.Materialgroup1;
        newItem.Materialgroup2 = sboItem.Materialgroup2;
        newItem.BillOfMaterial = sboItem.BillOfMaterial;
        newItem.BOMCount = sboItem.BOMCount;
        newItem.ShippingAmount = sboItem.ShippingAmount;
        newItem.TaxAmount = sboItem.TaxAmount;
        newItem.GBSTA = sboItem.GBSTA;
        newItem.CouponDiscount = sboItem.CouponDiscount;
        newItem.SubTotal3 = sboItem.TotalAmount;
    }

    private ensxtx_DS_Document_Detail.PARTNERS convertSBOPartner(ensxtx_SBO_EnosixSalesDocument_Detail.PARTNERS sboPartner)
    {
        ensxtx_DS_Document_Detail.PARTNERS newPartner = new ensxtx_DS_Document_Detail.PARTNERS();
        newPartner.PartnerFunction = sboPartner.PartnerFunction;
        newPartner.PartnerFunctionInternal = sboPartner.PartnerFunctionInternal;
        newPartner.PartnerFunctionName = sboPartner.PartnerFunctionName;
        newPartner.CustomerNumber = sboPartner.CustomerNumber;
        newPartner.Vendor = sboPartner.Vendor;
        newPartner.PersonnelNumber = sboPartner.PersonnelNumber;
        newPartner.ContactPersonNumber = sboPartner.ContactPersonNumber;
        newPartner.PartnerName = sboPartner.PartnerName;
        newPartner.PartnerName2 = sboPartner.PartnerName2;
        newPartner.HouseNumber = sboPartner.HouseNumber;
        newPartner.Street = sboPartner.Street;
        newPartner.City = sboPartner.City;
        newPartner.PostalCode = sboPartner.PostalCode;
        newPartner.Region = sboPartner.Region;
        newPartner.Country = sboPartner.Country;

        return newPartner;
    }

    private ensxtx_DS_Document_Detail.TEXTS convertSBOText(ensxtx_SBO_EnosixSalesDocument_Detail.ITEMS_TEXT sboText)
    {
        ensxtx_DS_Document_Detail.TEXTS newText = new ensxtx_DS_Document_Detail.TEXTS();
        newText.TextID = sboText.TextID;
        newText.TextLanguage = sboText.TextLanguage;
        newText.TextIDDescription = sboText.TextIDDescription;
        newText.Text = sboText.Text;

        return newText;
    }

    private ensxtx_DS_Document_Detail.TEXTS convertSBOText(ensxtx_SBO_EnosixSalesDocument_Detail.TEXTS sboText)
    {
        ensxtx_DS_Document_Detail.TEXTS newText = new ensxtx_DS_Document_Detail.TEXTS();
        newText.TextID = sboText.TextID;
        newText.TextLanguage = sboText.TextLanguage;
        newText.TextIDDescription = sboText.TextIDDescription;
        newText.Text = sboText.Text;

        return newText;
    }

    private ensxtx_DS_Document_Detail.CONFIG convertSBOConfig(ensxtx_SBO_EnosixSalesDocument_Detail.ITEMS_CONFIG sboItemConfig)
    {
        ensxtx_DS_Document_Detail.CONFIG newConfig = new ensxtx_DS_Document_Detail.CONFIG();
        newConfig.CharacteristicID = sboItemConfig.CharacteristicID;
        newConfig.CharacteristicName = sboItemConfig.CharacteristicName;
        newConfig.CharacteristicValue = sboItemConfig.CharacteristicValue;
        newConfig.CharacteristicValueDescription = sboItemConfig.CharacteristicValueDescription;
        newConfig.UserModified = true;

        return newConfig;
    }

    private ensxtx_DS_Document_Detail.SCHEDULE convertSBOSched(ensxtx_SBO_EnosixSalesDocument_Detail.ITEMS_SCHEDULE sboItemSched)
    {
        ensxtx_DS_Document_Detail.SCHEDULE newSched = new ensxtx_DS_Document_Detail.SCHEDULE();
        newSched.ScheduleLineNumber = sboItemSched.ScheduleLineNumber;
        newSched.ScheduleLineDate = sboItemSched.ScheduleLineDate;
        newSched.OrderQuantity = sboItemSched.OrderQuantity;
        newSched.RoundedQuantity = sboItemSched.RoundedQuantity;
        newSched.ConfirmedQuantity = sboItemSched.ConfirmedQuantity;
        newSched.SalesUnit = sboItemSched.SalesUnit;
        newSched.DeliveryBlock = sboItemSched.DeliveryBlock;
        newSched.DeliveryBlockDescription = sboItemSched.DeliveryBlockDescription;
        newSched.DeliveredQuantity = sboItemSched.DeliveredQuantity;
        newSched.ScheduleLineCategory = sboItemSched.ScheduleLineCategory;
        newSched.ScheduleLineCategoryDescription = sboItemSched.ScheduleLineCategoryDescription;
        newSched.PurchaseRequisitionNumber = sboItemSched.PurchaseRequisitionNumber;
        newSched.PurchaseRequisitionItemNumber = sboItemSched.PurchaseRequisitionItemNumber;

        return newSched;
    }

    // Convert the list of Incompletion logs to DS object
    private ensxtx_DS_Document_Detail.INCOMPLETION_LOG convertSBOIncompletionLog(ensxtx_SBO_EnosixSalesDocument_Detail.INCOMPLETION_LOG sboIncompletionLog)
    {
        ensxtx_DS_Document_Detail.INCOMPLETION_LOG newLog = new ensxtx_DS_Document_Detail.INCOMPLETION_LOG();
        newLog.TextID = sboIncompletionLog.TextID;
        newLog.Text = sboIncompletionLog.Description;
        
        return newLog;
    }

    // Convert List of SBO Conditions to DS Conditoins;
    private ensxtx_DS_Document_Detail.CONDITIONS convertSBOCondition(ensxtx_SBO_EnosixSalesDocument_Detail.CONDITIONS sboCondition)
    {
        ensxtx_DS_Document_Detail.CONDITIONS newCondition = new ensxtx_DS_Document_Detail.CONDITIONS();
        newCondition.ConditionCounter = sboCondition.ConditionCounter;
        newCondition.ConditionType = sboCondition.ConditionType;
        newCondition.ConditionTypeName = sboCondition.ConditionTypeName;
        newCondition.Rate = sboCondition.Rate;
        newCondition.RateUnit = sboCondition.RateUnit;
        newCondition.ConditionPricingUnit = sboCondition.ConditionPricingUnit;
        newCondition.ConditionUnit = sboCondition.ConditionUnit;
        newCondition.ConditionUnitInternal = sboCondition.ConditionUnitInternal;
        newCondition.ConditionValue = sboCondition.ConditionValue;
        newCondition.CurrencyKey = sboCondition.CurrencyKey;
        newCondition.CalculationType = sboCondition.CalculationType;
        newCondition.OriginOfCondition = sboCondition.ConditionOrigin;
        newCondition.ConditionControl = sboCondition.ConditionControl;
        return newCondition;
    }

    // Convert SBO Billing Plan to DS Billing Plan
    private ensxtx_DS_Document_Detail.BILLING_PLAN convertSBOBillingPlan(ensxtx_SBO_EnosixSalesDocument_Detail.BILL_PLAN sboBillingPlan)
    {
        ensxtx_DS_Document_Detail.BILLING_PLAN newBillingPlan = new ensxtx_DS_Document_Detail.BILLING_PLAN();
        newBillingPlan.BillingPlanType = sboBillingPlan.BillingPlanType;
        newBillingPlan.BillingPlanStartDate = sboBillingPlan.BillingPlanStartDate;
        newBillingPlan.BillingPlanEndDate = sboBillingPlan.BillingPlanEndDate;
        newBillingPlan.RuleForNextBillingDateOrigin = sboBillingPlan.RuleForNextBillingDateOrigin;
        
        return newBillingPlan;
    }

    // Convert SBO Billing Plan Dates to DS Billing Plan Dates
    private ensxtx_DS_Document_Detail.BILLING_PLAN_DATES convertSBOBillingPlanDate(ensxtx_SBO_EnosixSalesDocument_Detail.BILLING_PLAN_DATES sboBillingPlanDate)
    {
        ensxtx_DS_Document_Detail.BILLING_PLAN_DATES newBillingPlanDate = new ensxtx_DS_Document_Detail.BILLING_PLAN_DATES();
        newBillingPlanDate.DeadlineSettlementDate = sboBillingPlanDate.FromSettlementDate;
        newBillingPlanDate.Usage = sboBillingPlanDate.Usage;
        newBillingPlanDate.PercentageOfValueToBeInvoiced = sboBillingPlanDate.PercentageOfValueToBeInvoiced;
        newBillingPlanDate.ValueToBeBilled = sboBillingPlanDate.ValueToBeBilled;
        newBillingPlanDate.BillingBlockForBillingPlan = sboBillingPlanDate.BillingBlockForBillingPlan;
        newBillingPlanDate.RuleInBillingPlan = sboBillingPlanDate.RuleInBillingPlan;
        newBillingPlanDate.BillingStatusForBillingPlan = sboBillingPlanDate.BillingStatusForBillingPlan;
        newBillingPlanDate.DateCategory = sboBillingPlanDate.DateCategory;
        newBillingPlanDate.ProposedBillingType = sboBillingPlanDate.ProposedBillingType;
        
        return newBillingPlanDate;
    }
    // #endregion Convert to DS Object mapping
}