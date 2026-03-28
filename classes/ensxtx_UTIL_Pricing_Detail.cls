public class ensxtx_UTIL_Pricing_Detail implements ensxtx_I_Document_Detail
{
    private ensxtx_DS_SalesDocAppSettings appSettings;

    public String getSimulateCommand()
    {
        return 'CMD_SIMULATE_PRICING';
    }

    public String getReferenceDocumentCommand()
    {
        return null;
    }

    public String getMaterialBomCountCommand()
    {
        return null;
    }

    public ensxsdk.EnosixFramework.DetailObject removeAllConditions(ensxsdk.EnosixFramework.DetailObject detailObj)
    {
        ensxtx_SBO_EnosixPricing_Detail.EnosixOpportunityPricing sboObject = (ensxtx_SBO_EnosixPricing_Detail.EnosixOpportunityPricing) detailObj;
        sboObject.CONDITIONS.clear();
        return sboObject;
    }

    // Update the SBO Header and Item Text Fields
    // Mainly use after simulation before update so it can keep any line breaks in the text
    public ensxsdk.EnosixFramework.DetailObject updateSimulateBeforeUpdate(ensxsdk.EnosixFramework.DetailObject detailObj, ensxtx_DS_Document_Detail docObj, ensxtx_DS_SalesDocAppSettings appSettings)
    {
        return detailObj;
    }

    public ensxsdk.EnosixFramework.DetailObject buildSBOForReference(String salesDocNumber, String salesDocType)
    {
        return null;
    }

    // #region Convert to SBO Mapping

    // Implementation of Converting ensxtx_DS_Document_Detail to SBO Detail Object
    // This conversion is needed before sending the request to SAP
    public ensxsdk.EnosixFramework.DetailObject convertToSBO(ensxsdk.EnosixFramework.DetailObject detailObj, 
        ensxtx_DS_Document_Detail docObj, Boolean isUpdate, ensxtx_DS_SalesDocAppSettings appSettings)
    {
        this.appSettings = appSettings;
        ensxtx_SBO_EnosixPricing_Detail.EnosixOpportunityPricing sboObject;

        if (detailObj == null) sboObject = new ensxtx_SBO_EnosixPricing_Detail.EnosixOpportunityPricing();
        else sboObject = (ensxtx_SBO_EnosixPricing_Detail.EnosixOpportunityPricing) detailObj;

        mapHeaderFieldsToSBO(sboObject, docObj);

        // PARTNERS
        if (String.isNotEmpty(docObj.SoldToParty)) 
        {
            sboObject.SoldToParty = docObj.SoldToParty;
            ensxtx_DS_Document_Detail.PARTNERS soldToPartner = ensxtx_UTIL_SalesDoc.getPartnerFromDocumentDetail(docObj.PARTNERS, ensxtx_UTIL_Customer.SOLD_TO_PARTNER_CODE, true);
            soldToPartner.CustomerNumber = docObj.SoldToParty;
        }
        Integer partTot = docObj.PARTNERS.size();
        for (Integer partCnt = 0 ; partCnt < partTot ; partCnt++)
        {            
            ensxtx_DS_Document_Detail.PARTNERS partner = docObj.PARTNERS[partCnt];
            ensxtx_SBO_EnosixPricing_Detail.PARTNERS sboPartner = createNewPartnerSBO(partner, null);
            if (sboPartner != null) sboObject.PARTNERS.add(sboPartner);                
        }

        // CONDITIONS
        Integer condTot = docObj.CONDITIONS == null ? 0 : docObj.CONDITIONS.size();
        for (Integer condCnt = 0 ; condCnt < condTot ; condCnt++)
        {            
            ensxtx_DS_Document_Detail.CONDITIONS headerCondition = docObj.CONDITIONS[condCnt];
            if (String.isNotEmpty(headerCondition.ConditionType) && headerCondition.Rate != null)
            {
                ensxtx_SBO_EnosixPricing_Detail.CONDITIONS newCondition = new ensxtx_SBO_EnosixPricing_Detail.CONDITIONS();
                mapConditionFieldsToSBO(newCondition, headerCondition, '', sboObject.SalesDocumentCurrency);
                sboObject.CONDITIONS.add(newCondition);
            }
        }

        // ITEMS
        if (docObj.ITEMS != null && docObj.ITEMS.size() > 0) 
        {
            mapNewItemsToSBO(sboObject, docObj.ITEMS);
        }

        return sboObject;
    }

    private void mapHeaderFieldsToSBO(ensxtx_SBO_EnosixPricing_Detail.EnosixOpportunityPricing sboObject, ensxtx_DS_Document_Detail docObj)
    {
        // HEADER
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
    }

    // Mapping of newly added Items to SBO
    private void mapNewItemsToSBO(ensxtx_SBO_EnosixPricing_Detail.EnosixOpportunityPricing sboObject, List<ensxtx_DS_Document_Detail.ITEMS> items)
    {
        Integer itemTot = items.size();
        for (Integer itemCnt = 0 ; itemCnt < itemTot ; itemCnt++)
        {
            ensxtx_DS_Document_Detail.ITEMS item = items[itemCnt];
            Boolean isMainItem = String.isEmpty(item.BillOfMaterial) || Integer.valueOf(item.HigherLevelItemNumber) == 0;

            if (this.appSettings.enableBoMItemEdit || isMainItem)
            {
                ensxtx_SBO_EnosixPricing_Detail.ITEMS newItem = new ensxtx_SBO_EnosixPricing_Detail.ITEMS();
                mapItemFieldsToSBO(newItem, item);
                sboObject.ITEMS.add(newItem);

                // Add Item Conditions
                Integer condTot = item.ItemConditions == null ? 0 : item.itemConditions.size();
                for (Integer condCnt = 0 ; condCnt < condTot ; condCnt++)
                {
                    ensxtx_DS_Document_Detail.CONDITIONS itemCondition = item.itemConditions[condCnt];
                    ensxtx_SBO_EnosixPricing_Detail.CONDITIONS newItemCondition = new ensxtx_SBO_EnosixPricing_Detail.CONDITIONS();
                    mapConditionFieldsToSBO(newItemCondition, itemCondition, item.ItemNumber, sboObject.SalesDocumentCurrency);
                    sboObject.CONDITIONS.add(newItemCondition);
                }

                // Partners
                if (item.PARTNERS != null && item.PARTNERS.size() > 0){
                    Integer partnerTot = item.PARTNERS.size();
                    for (Integer partnerCnt = 0; partnerCnt < partnerTot; partnerCnt++)
                    {
                        ensxtx_DS_Document_Detail.PARTNERS itemPartner = item.PARTNERS[partnerCnt];
                        ensxtx_SBO_EnosixPricing_Detail.PARTNERS sboPartner = createNewPartnerSBO(itemPartner, item.ItemNumber);
                        if (sboPartner != null) sboObject.PARTNERS.add(sboPartner);
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
                            ensxtx_SBO_EnosixPricing_Detail.ITEMS_CONFIG sboItemConfig = new ensxtx_SBO_EnosixPricing_Detail.ITEMS_CONFIG();
                            mapItemsConfigToSBO(sboItemConfig, item.ItemNumber, config);
                            sboObject.ITEMS_CONFIG.add(sboItemConfig);
                        }
                    }
                }
            }
        }
    }

    private ensxtx_SBO_EnosixPricing_Detail.PARTNERS createNewPartnerSBO(ensxtx_DS_Document_Detail.PARTNERS partner, String itemNumber)
    {
        ensxtx_SBO_EnosixPricing_Detail.PARTNERS newPartner;

        if (String.isNotEmpty(partner.CustomerNumber) || String.isNotEmpty(partner.Vendor) || String.isNotEmpty(partner.PersonnelNumber) || String.isNotEmpty(partner.ContactPersonNumber))
        {
            newPartner = new ensxtx_SBO_EnosixPricing_Detail.PARTNERS();
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
            if (String.isNotEmpty(partner.HouseNumber)) newPartner.HouseNumber = partner.HouseNumber;
            if (String.isNotEmpty(partner.Street)) newPartner.Street = partner.Street;
            if (String.isNotEmpty(partner.City)) newPartner.City = partner.City;
            if (String.isNotEmpty(partner.PostalCode)) newPartner.PostalCode = partner.PostalCode;
            if (String.isNotEmpty(partner.Region)) newPartner.Region = partner.Region;
            if (String.isNotEmpty(partner.Country)) newPartner.Country = partner.Country;
        }

        return newPartner;
    }

    private void mapItemFieldsToSBO(ensxtx_SBO_EnosixPricing_Detail.ITEMS sboItem, ensxtx_DS_Document_Detail.ITEMS item)
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
        sboItem.Plant = item.Plant;
        sboItem.ConfigurableMaterial = item.ConfigurableMaterial;
        sboItem.PriceListType = item.PriceListType;
        sboItem.ItemReferenceDocument = item.ReferenceDocument;
        sboItem.ItemReferenceDocumentItNumber = item.ReferenceItemNumber;
        sboItem.ItemReferenceDocumentCtegory = item.ReferenceDocumentCategory;
        sboItem.Materialgroup1 = item.Materialgroup1;
        sboItem.Materialgroup2 = item.Materialgroup2;
    }

    private void mapConditionFieldsToSBO(ensxtx_SBO_EnosixPricing_Detail.CONDITIONS sboCondition,
        ensxtx_DS_Document_Detail.CONDITIONS condition, String itemNumber, String currencyKey)
    {
        if (String.isNotEmpty(itemNumber)) sboCondition.ConditionItemNumber = itemNumber;
        sboCondition.ConditionType = condition.ConditionType;
        sboCondition.Rate = condition.Rate;
        sboCondition.ConditionControl = 'C';
        sboCondition.KRECH = condition.CalculationType;
        sboCondition.ConditionCounter = condition.ConditionCounter;
        sboCondition.ConditionControl = condition.ConditionControl;
        // Insert Currency for Calculation type gross weight
        if (sboCondition.KRECH == 'D') sboCondition.CurrencyKey = currencyKey;
    }

    private void mapItemsConfigToSBO(ensxtx_SBO_EnosixPricing_Detail.ITEMS_CONFIG sboItemConfig, String itemNumber, ensxtx_DS_Document_Detail.CONFIG itemConfig)
    {
        sboItemConfig.ItemNumber = itemNumber;
        sboItemConfig.CharacteristicID = itemConfig.CharacteristicID;
        sboItemConfig.CharacteristicName = itemConfig.CharacteristicName;
        sboItemConfig.CharacteristicValue = itemConfig.CharacteristicValue;
    }

    // #region Convert to DS Object mapping

    // Implementation of Converting SBO Detail Object to ensxtx_DS_Document_Detail Object
    // This conversion is use before sending the detail object to Front-end
    public void convertToObject(ensxsdk.EnosixFramework.DetailObject detailObj, ensxtx_DS_Document_Detail docObj, 
        Boolean isFromGetDetail, ensxtx_DS_SalesDocAppSettings appSettings, ensxtx_UTIL_Document_Detail.convertToObjectTrigger convertTrigger)
    {
        ensxtx_SBO_EnosixPricing_Detail.EnosixOpportunityPricing sboObject = (ensxtx_SBO_EnosixPricing_Detail.EnosixOpportunityPricing) detailObj;

        convertSBOHeaderAndSales(docObj, sboObject);

        // CONDITIONS
        // Get all the conditions from the SBO
        // Store the Item conditions in a map
        Map<String, List<ensxtx_DS_Document_Detail.CONDITIONS>> itemNumberConditions = new Map<String, List<ensxtx_DS_Document_Detail.CONDITIONS>>();
        docObj.SBOHeaderConditions = new List<ensxtx_DS_Document_Detail.CONDITIONS>();
        
        List<ensxtx_SBO_EnosixPricing_Detail.CONDITIONS> condList = sboObject.CONDITIONS.getAsList();
        Integer condTot = condList.size();
        for (Integer condCnt = 0 ; condCnt < condTot ; condCnt++)
        {
            ensxtx_SBO_EnosixPricing_Detail.CONDITIONS condition = condList[condCnt];

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

        Map<String, List<ensxtx_DS_Document_Detail.SCHEDULE>> itemNumberItemSchedules = 
            new Map<String, List<ensxtx_DS_Document_Detail.SCHEDULE>>();

        // Convert SBO Items Schedule
        List<ensxtx_SBO_EnosixPricing_Detail.ITEMS_SCHEDULE> schedList = sboObject.ITEMS_SCHEDULE.getAsList();
        Integer schedTot = schedList.size();
        for (Integer schedCnt = 0 ; schedCnt < schedTot ; schedCnt++)
        {
            ensxtx_SBO_EnosixPricing_Detail.ITEMS_SCHEDULE sboItemSched = schedList[schedCnt];
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

        Map<String, List<ensxtx_DS_Document_Detail.CONFIG>> itemNumberItemsConfig = 
            new Map<String, List<ensxtx_DS_Document_Detail.CONFIG>>();
        Map<String, List<ensxtx_DS_Document_Detail.PARTNERS>> itemNumberItemPartners = 
            new Map<String, List<ensxtx_DS_Document_Detail.PARTNERS>>();

        // ITEMS
        // Mapping of items from SBO to DS Object
        docObj.ITEMS = new List<ensxtx_DS_Document_Detail.ITEMS>();
        List<ensxtx_SBO_EnosixPricing_Detail.ITEMS> itemList = sboObject.ITEMS.getAsList();
        itemTot = itemList.size();
        for (Integer itemCnt = 0 ; itemCnt < itemTot ; itemCnt++)
        {
            ensxtx_SBO_EnosixPricing_Detail.ITEMS sboItem = itemList[itemCnt];
            ensxtx_DS_Document_Detail.ITEMS newItem = new ensxtx_DS_Document_Detail.ITEMS();
            newItem.SBOItemConditions = new List<ensxtx_DS_Document_Detail.CONDITIONS>();
            newItem.ItemSchedules = new List<ensxtx_DS_Document_Detail.SCHEDULE>();

            String sboItemNumber = String.isNotEmpty(sboItem.CustomerPurchaseOrderItemNumber) ? sboItem.CustomerPurchaseOrderItemNumber : sboItem.ItemNumber;

            ensxtx_DS_Document_Detail.ITEMS currentItem = itemNumberItem.get(sboItemNumber.leftPad(6, '0'));

            if (itemNumberConditions.containsKey(sboItem.ItemNumber.leftPad(6, '0'))) newItem.SBOItemConditions = itemNumberConditions.get(sboItem.ItemNumber.leftPad(6, '0'));

            if (null != currentItem) {
                newItem.SFId = currentItem.SFId;
                newItem.CPQNumber = currentItem.CPQNumber;
                newItem.OptionConfigurationKeys = currentItem.OptionConfigurationKeys;
                newItem.ProductId = currentItem.ProductId;
                newItem.vcSummaryJSON = currentItem.vcSummaryJSON;
                newItem.ItemConditions = currentItem.ItemConditions;
                newItem.ItemConfigurations = currentItem.ItemConfigurations;
                newItem.BOMMaterial = currentItem.BOMMaterial;
                newItem.isAdded = currentItem.isAdded;
                newItem.isChanged = currentItem.isChanged;
                newItem.PARTNERS = currentItem.PARTNERS;
                newItem.isConfigurationFromVCComplete = currentItem.isConfigurationFromVCComplete;
            }
            else {
                newItem.ItemConditions = ensxtx_UTIL_SBOAdapter.getAddedConditions(newItem.SBOItemConditions,false);
                newItem.ItemConfigurations = itemNumberItemsConfig.get(sboItem.ItemNumber.leftPad(6, '0'));
                newItem.CPQNumber = -1;
            }

            newItem.ItemSchedules = itemNumberItemSchedules.get(sboItem.ItemNumber.leftPad(6, '0'));

            convertSBOItem(newItem, sboItem);

            docObj.ITEMS.add(newItem);
        }
    }

    private void convertSBOHeaderAndSales(ensxtx_DS_Document_Detail docObj, ensxtx_SBO_EnosixPricing_Detail.EnosixOpportunityPricing sboObject)
    {
        // HEADER
        docObj.SoldToParty = sboObject.SoldToParty;
        docObj.SoldToPartyText = sboObject.SoldToPartyText;
        docObj.SalesDocumentCurrency = sboObject.SALES.SalesDocumentCurrency;
        docObj.CustomerPurchaseOrderNumber = sboObject.CustomerPurchaseOrderNumber;
        docObj.CustomerPurchaseOrderDate = sboObject.CustomerPurchaseOrderDate;
        docObj.NetOrderValue = sboObject.NetOrderValue;
        docObj.ReferenceDocument = sboObject.ReferenceDocument;
        docObj.ReferenceDocumentCategory = sboObject.ReferenceDocumentCategory;
        docObj.TaxAmount = sboObject.TaxAmount;
        docObj.IsSuccess = sboObject.isSuccess();

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
    }

    private void convertSBOItem(ensxtx_DS_Document_Detail.ITEMS newItem, ensxtx_SBO_EnosixPricing_Detail.ITEMS sboItem)
    {
        // Savvas return the original item number in CustomerPurchaseOrderItemNumber
        newItem.ItemNumber = String.isNotEmpty(sboItem.CustomerPurchaseOrderItemNumber) ? sboItem.CustomerPurchaseOrderItemNumber : sboItem.ItemNumber;
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
        newItem.NetOrderValue = sboItem.NetOrderValue;
        newItem.SalesUnit = sboItem.SalesUnit;
        newItem.BaseUnitOfMeasure = sboItem.BaseUnitOfMeasure;
        newItem.GrossWeight = sboItem.GrossWeight;
        newItem.NetWeight = sboItem.NetWeight;
        newItem.WeightUnit = sboItem.WeightUnit;
        newItem.SalesDocumentCurrency = sboItem.SalesDocumentCurrency;
        newItem.ConfigurableMaterial = sboItem.ConfigurableMaterial;
        newItem.PriceListType = sboItem.PriceListType;
        newItem.ReferenceItemNumber = sboItem.ItemReferenceDocumentItNumber;
        newItem.ReferenceDocument = sboItem.ItemReferenceDocument;
        newItem.ReferenceDocumentCategory = sboItem.ItemReferenceDocumentCtegory;
        newItem.Materialgroup1 = sboItem.Materialgroup1;
        newItem.Materialgroup2 = sboItem.Materialgroup2;
        newItem.BillOfMaterial = sboItem.BillOfMaterial;

        if (sboItem.PriceListType == 'DA') newItem.ShippingHandlingRate = 0;
        else if ((String.isNotEmpty(sboItem.PriceListType) && (sboItem.PriceListType.startsWith('P') || sboItem.PriceListType.startsWith('Z'))) &&
            String.isNotEmpty(sboItem.PriceListTypeText))
        {
            String priceListSubstring = sboItem.PriceListTypeText.substringAfter('=');
            newItem.ShippingHandlingRate = String.isNotEmpty(priceListSubstring) ? Decimal.valueOf(priceListSubstring.trim().replace('%', '')) : null;
        }
        else newItem.ShippingHandlingRate = null;
    }

    private ensxtx_DS_Document_Detail.SCHEDULE convertSBOSched(ensxtx_SBO_EnosixPricing_Detail.ITEMS_SCHEDULE sboItemSched)
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

    // Convert List of SBO Conditions to DS Conditoins;
    private ensxtx_DS_Document_Detail.CONDITIONS convertSBOCondition(ensxtx_SBO_EnosixPricing_Detail.CONDITIONS sboCondition)
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
        newCondition.ConditionValue = sboCondition.KWERT;
        newCondition.CurrencyKey = sboCondition.CurrencyKey;
        newCondition.CalculationType = sboCondition.KRECH;
        newCondition.ConditionControl = sboCondition.ConditionControl;
        
        return newCondition;
    }
    // #endregion Convert to DS Object mapping
}