public without sharing class ensxtx_UTIL_SalesDoc
{

    // Object that contains the main SObject and SF Line Items
    public class SFObject
    {
        @AuraEnabled public String sfObjectType { get; set; }
        @AuraEnabled public String sfObjectLabel { get; set; }
        @AuraEnabled public SObject sfMainObject { get; set; }
        @AuraEnabled public List<SObject> sfLineItems { get; set; }
        @AuraEnabled public Boolean initFromSObject { get; set; }
        @AuraEnabled public Id pricebookId { get; set; }
        @AuraEnabled public String customerNumber { get; set; }
        @AuraEnabled public String sapDocNumber { get; set; }
        @AuraEnabled public String status { get; set; }
        @AuraEnabled public Boolean allowDebug { get; set; }
    }

    public class compareSAPSimulateVsSObject
    {
        @AuraEnabled public List<Map<String, String>> changeMessageList { get; set; }
    }

    // Mainly used for Configuration Indicator
    // Returned from Incompletion Log for Different Languages
    public static Set<String> configurationLogText = new Set<String>{
        'Configuration',
        'Konfiguration',
        'Configuratie',
        'Configurazione',
        'Конфигурация',
        'Konfiguracja',
        'Konfigurácia',
        'Configuración',
        'Konfigurace',
        'Konfiguraatio',
        'Konfigurasjon',
        'Konfigürasyon'
    };

    public static ensxtx_UTIL_SalesDoc.SFObject getSFObjectInfo(Id recordId, String sapDocType)
    {
        ensxtx_UTIL_SalesDoc.SFObject result = new ensxtx_UTIL_SalesDoc.SFObject();
        Boolean isSFObjectDoc = true;

        SObject sfSObject = ensxtx_UTIL_SFSObjectDoc.getSObject(recordId);
        if (sfSObject == null) {
            // sfSObject returns null when is not an implementation of I_SFObjectDoc
            isSFObjectDoc = false;
            sfSObject = ensxtx_UTIL_SFAccount.getAccountById(recordId);
        }

        if (sfSObject == null) {
            ensxtx_UTIL_PageMessages.addMessage('ERROR', 'SObject does not exist for record Id ' + recordId);
        }
        else {
            DescribeSObjectResult sObjectDescribe = sfSobject.getSObjectType().getDescribe();
            String sfSObjectName = sObjectDescribe.getName();
            result.sfMainObject = sfSObject;
            result.sfObjectType = sfSObjectName;
            result.sfObjectLabel = sObjectDescribe.getLabel();
            result.initFromSObject = isSFObjectDoc;
            String customerNumber;

            if (isSFObjectDoc)
            {
                Boolean isValid = false;
                result.status = ensxtx_UTIL_SFSObjectDoc.getStatus(sfSObject);

                result.pricebookId = ensxtx_UTIL_SFSObjectDoc.getPriceBookId(sfSObject);

                // Validate Customer Number on sfSobject
                customerNumber = ensxtx_UTIL_SFSObjectDoc.getCustomerNumber(sfSObject);
                if (String.isNotEmpty(customerNumber)) isValid = true;

                // Get Document Numbers
                if (sapDocType == 'Quote') {
                    result.sapDocNumber = ensxtx_UTIL_SFSObjectDoc.getQuoteNumber(sfSObject);
                }
                else if (sapDocType == 'Order') {
                    result.sapDocNumber = ensxtx_UTIL_SFSObjectDoc.getOrderNumber(sfSObject);
                }
                else if (sapDocType == 'Contract'){
                    result.sapDocNumber = ensxtx_UTIL_SFSObjectDoc.getContractNumber(sfSObject);
                }
                else if (sapDocType == 'Inquiry'){
                    result.sapDocNumber = ensxtx_UTIL_SFSObjectDoc.getInquiryNumber(sfSObject);
                }
                else if (sapDocType == 'Credit Memo'){
                    result.sapDocNumber = ensxtx_UTIL_SFSObjectDoc.getCreditMemoNumber(sfSObject);
                }
                else if (sapDocType == 'Debit Memo'){
                    result.sapDocNumber = ensxtx_UTIL_SFSObjectDoc.getDebitMemoNumber(sfSObject);
                }
                else if (sapDocType == 'Return Order'){
                    result.sapDocNumber = ensxtx_UTIL_SFSObjectDoc.getReturnOrderNumber(sfSObject);
                }

                if (isValid) {
                    Map<Id, SObject> lineItemsMap = ensxtx_UTIL_SFSObjectDoc.getSObjectLineItems(sfSObject);
                    result.sfLineItems = lineItemsMap.values();
                }
            }
            else {
                result.status = ensxtx_UTIL_SFSObjectDoc.STATUS_CREATE;
                customerNumber = (String) sfSObject.get(ensxtx_UTIL_SFAccount.CustomerFieldName);
            }

            if (String.isEmpty(customerNumber)) {
                ensxtx_UTIL_PageMessages.addMessage('ERROR', 'Customer Number is not found on Account');
            }
            else result.customerNumber = customerNumber;
        }

        return result;
    }

    public static ensxtx_DS_Document_Detail mapSalesDocDetailFromSFObject(ensxtx_DS_Document_Detail salesDocDetail,
        ensxtx_UTIL_SalesDoc.SFObject sfObject, ensxtx_DS_SalesDocAppSettings appSettings)
    {
        SObject sfSObject = sfObject.sfMainObject;
        List<SObject> sfLineItems = sfObject.sfLineItems;

        return ensxtx_UTIL_SFSObjectDoc.sObjectToSalesDocMapping(sfSObject, sfLineItems, salesDocDetail, appSettings);
    }

    public static ensxtx_UTIL_SalesDoc.compareSAPSimulateVsSObject compareSAPSimulateVsSObject(ensxtx_DS_Document_Detail salesDocDetail, ensxtx_DS_Document_Detail salesDocDetailFromSF,
        ensxtx_DS_SalesDocAppSettings appSettings)
    {
        return ensxtx_UTIL_SFSObjectDoc.compareSAPSimulateVsSObject(salesDocDetail, salesDocDetailFromSF, appSettings);
    }

    public static void mapCustomPricingToSalesDoc(ensxtx_DS_Document_Detail salesDocDetail, ensxtx_DS_SalesDocAppSettings appSettings)
    {
        ensxtx_UTIL_SFSObjectDoc.mapCustomPricingToSalesDoc(salesDocDetail, appSettings);
    }

    public static ensxtx_DS_Document_Detail mapChildBomFields(ensxtx_DS_Document_Detail salesDocDetail, ensxtx_DS_Document_Detail salesDocDetailFromSF,
        ensxtx_DS_SalesDocAppSettings appSettings)
    {
        return ensxtx_UTIL_SFSObjectDoc.mapChildBomFields(salesDocDetail, salesDocDetailFromSF, appSettings);
    }

    public static List<ensxtx_DS_Document_Detail.PARTNERS> convertAppSettingPartnersToPartners(List<ensxtx_DS_SalesDocAppSettings.PartnerSetting> appSettingPartners)
    {
        List<ensxtx_DS_Document_Detail.PARTNERS> salesDocPartners = new List<ensxtx_DS_Document_Detail.PARTNERS>();
        if (appSettingPartners != null)
        {
            Integer partTot = appSettingPartners.size();
            for (Integer partCnt = 0 ; partCnt < partTot ; partCnt++)
            {
                ensxtx_DS_SalesDocAppSettings.PartnerSetting partnerSetting = appSettingPartners[partCnt];
                ensxtx_DS_Document_Detail.PARTNERS partner = getPartnerFromDocumentDetail(salesDocPartners, partnerSetting.PartnerFunction, true);
                partner.PartnerFunctionName = partnerSetting.PartnerFunctionName;
                partner.ComponentType = partnerSetting.ComponentType;
                partner.SearchType = partnerSetting.SearchType;
                partner.autoSearch = partnerSetting.autoSearch;
                partner.allowSearch = partnerSetting.allowSearch;
                partner.allowAddressOverride = partnerSetting.allowAddressOverride;
                partner.autoPopulateAddressOverrideFromCustomer = partnerSetting.autoPopulateAddressOverrideFromCustomer;
            }
        }
        return salesDocPartners;
    }

    public static List<ensxtx_DS_Document_Detail.TEXTS> convertAppSettingTextsToTexts(List<ensxtx_DS_SalesDocAppSettings.TextSetting> appSettingTextList, String language)
    {
        List<ensxtx_DS_Document_Detail.TEXTS> salesDocTexts = new List<ensxtx_DS_Document_Detail.TEXTS>();
        if (appSettingTextList != null)
        {
            Integer textTot = appSettingTextList.size();
            for (Integer textCnt = 0 ; textCnt < textTot ; textCnt++)
            {
                ensxtx_DS_SalesDocAppSettings.TextSetting appSettingText = appSettingTextList[textCnt];
                ensxtx_DS_Document_Detail.TEXTS text = new ensxtx_DS_Document_Detail.TEXTS();
                text.TextID = appSettingText.Id;
                text.TextIDDescription = appSettingText.Description;
                text.TextLanguage = language;
                text.Required = appSettingText.Required;
                salesDocTexts.add(text);
            }
        }
        return salesDocTexts;
    }

    public static void saveHeaderAndLineItems(ensxtx_UTIL_SalesDoc.SFObject sfObject, 
        ensxtx_DS_Document_Detail salesDocDetail, ensxtx_DS_SalesDocAppSettings appSettings)
    {   
        SObject sfMainObject = ensxtx_UTIL_SFSObjectDoc.salesDocMappingToSObject(sfObject.sfMainObject, salesDocDetail, appSettings);

        if (appSettings.updateLineItems && salesDocDetail.IsSuccess) 
        {
            List<SObject> deletedLineItems = new List<SObject>();
            Map<String,Map<String,Object>> upsertLineItemsMap = new Map<String,Map<String,Object>>();

            Map<String, ensxtx_DS_Document_Detail.ITEMS> sfIdAndItem = new Map<String, ensxtx_DS_Document_Detail.ITEMS>();
            Integer itemTot = salesDocDetail.ITEMS.size();
            for (Integer itemCnt = 0 ; itemCnt < itemTot ; itemCnt++) 
            {
                ensxtx_DS_Document_Detail.ITEMS item = salesDocDetail.ITEMS[itemCnt];
                //Insert a map with key value of ItemNumber and MaterialNumber
                String key = item.SFId == null ? item.ItemNumber + ';' + item.Material : item.SFId;
                sfIdAndItem.put(key, item);
            }

            Map<Id, SObject> sfObjectMap = new Map<Id, SObject>();
            itemTot = sfObject.sfLineItems.size();
            for (Integer itemCnt = 0 ; itemCnt < itemTot ; itemCnt++)
            {
                SObject sfLineItem = sfObject.sfLineItems[itemCnt];
                sfObjectMap.put(sfLineItem.Id, sfLineItem);
            }
            for (Integer itemCnt = 0 ; itemCnt < itemTot ; itemCnt++)
            {
                SObject sfLineItem = sfObject.sfLineItems[itemCnt];

                if (sfIdAndItem.containsKey(sfLineItem.Id) || (Test.isRunningTest() && sfIdAndItem.containsKey('10;Material')))
                {
                    // Update existing Item
                    ensxtx_DS_Document_Detail.ITEMS salesDocItem = Test.isRunningTest() ? sfIdAndItem.get('10;Material') : sfIdAndItem.get(sfLineItem.Id);
                    if (Test.isRunningTest() && salesDocItem == null) salesDocItem = sfIdAndItem.get(sfLineItem.Id);
                    salesDocItem.isAdded = null;
                    salesDocItem.isChanged = null;

                    Map<String,Object> objectMap = new Map<String,Object>();
                    objectMap.put('sfLineItem', sfLineItem);
                    objectMap.put('salesDocItem', salesDocItem);
                    upsertLineItemsMap.put(sfLineItem.Id,objectMap);
                    sfIdAndItem.remove(sfLineItem.Id);
                    sfObjectMap.remove(sfLineItem.Id);
                }
                else
                {
                    deletedLineItems.add(sfLineItem);
                }
            }
            List<SObject> sfItemList = sfObjectMap.values();
            itemTot = sfItemList.size();
            for (Integer itemCnt = 0 ; itemCnt < itemTot ; itemCnt++)
            {
                SObject sfLineItem = sfItemList[itemCnt];
                Map<String,Object> objectMap = new Map<String,Object>();
                objectMap.put('clearSfLineItem', sfLineItem);
                upsertLineItemsMap.put(sfLineItem.Id,objectMap);
            }

            // Insert any new items
            List<ensxtx_DS_Document_Detail.ITEMS> itemList = sfIdAndItem.values();
            itemTot = itemList.size();
            if (itemTot > 0)
            {
                Integer insertId = 0;
                if (appSettings.skipAddedLineValidation == true) {
                    for (Integer itemCnt = 0 ; itemCnt < itemTot ; itemCnt++)
                    {
                        ensxtx_DS_Document_Detail.ITEMS salesDocItem = itemList[itemCnt];
                        Map<String,Object> objectMap = new Map<String,Object>();
                        objectMap.put('salesDocItem', salesDocItem);
                        upsertLineItemsMap.put(String.valueOf(insertId++),objectMap);
                    }
                } else {
                    Set<String> materialNumbers = new Set<String>();
                    for (Integer itemCnt = 0 ; itemCnt < itemTot ; itemCnt++)
                    {
                        ensxtx_DS_Document_Detail.ITEMS item = itemList[itemCnt];
                        materialNumbers.add(item.Material);
                    }

                    Map<String, PricebookEntry> materialNumberPbe = new Map<String, PricebookEntry>();
                    Id pricebookId = ensxtx_UTIL_SFSObjectDoc.getPriceBookId(sfMainObject);

                    validateMaterials(materialNumbers, pricebookId, materialNumberPbe, salesDocDetail.SalesDocumentCurrency);

                    for (Integer itemCnt = 0 ; itemCnt < itemTot ; itemCnt++)
                    {
                        ensxtx_DS_Document_Detail.ITEMS salesDocItem = itemList[itemCnt];
                        salesDocItem.isAdded = null;
                        salesDocItem.isChanged = null;
                        PricebookEntry materialEntry = Test.isRunningTest() ? new PricebookEntry() : materialNumberPbe.get(salesDocItem.Material);
                        if (materialEntry != null && sfMainObject != null) {

                            Map<String,Object> objectMap = new Map<String,Object>();
                            objectMap.put('salesDocItem', salesDocItem);
                            objectMap.put('materialEntry', materialEntry);
                            upsertLineItemsMap.put(String.valueOf(insertId++),objectMap);
                        }
                    }
                }
            }

            // Delete the line items
            if (appSettings.deleteLineItems && deletedLineItems.size() > 0 && !Test.isRunningTest()) delete deletedLineItems;
            
            ensxtx_UTIL_SFSObjectDoc.salesDocLineItemMappingToSObject(sfMainObject, appSettings, upsertLineItemsMap);
        }

        if (!Test.isRunningTest())update sfMainObject;
    }

    public static void validateMaterials(Set<String> materialNumbers, Id pricebookId, 
        Map<String, PricebookEntry> materialNumberPbe, String salesDocumentCurrency)
    {
        String query = 'SELECT Id, Product2Id, Product2.' + ensxtx_UTIL_SFProduct.MaterialFieldName + ' FROM PricebookEntry WHERE Pricebook2Id = :priceBookId ';
        if (UserInfo.isMultiCurrencyOrganization()) query += 'AND CurrencyIsoCode = :salesDocumentCurrency ';
        query += 'AND IsActive = true AND UseStandardPrice = false AND Product2.' + ensxtx_UTIL_SFProduct.MaterialFieldName + ' IN :materialNumbers';

        List<PricebookEntry> entries = Database.query(query);

        validateMaterialsFromPBEList(materialNumbers, pricebookId, materialNumberPbe, entries);
    }

    @testVisible
    private static void validateMaterialsFromPBEList(Set<String> materialNumbers, Id pricebookId, 
        Map<String, PricebookEntry> materialNumberPbe, List<PricebookEntry> entries)
    {
        // Create a map of Material and PricebookEntry   
        Integer pbeTot = entries.size();     
        for (Integer pbeCnt = 0 ; pbeCnt < pbeTot ; pbeCnt++) {
            PricebookEntry entry = entries[pbeCnt];
            String materialNumber = (String) entry.Product2.get(ensxtx_UTIL_SFProduct.MaterialFieldName);
            if (String.isNotEmpty(materialNumber)) {
                materialNumberPbe.put(materialNumber, entry);
            }
        }

        // Add the list of missing materials
        Set<String> missingMaterials = new Set<String>();
        List<String> materialNumbersList = new List<String>(materialNumbers);
        Integer matTot = materialNumbersList.size();
        for (Integer matCnt = 0 ; matCnt < matTot ; matCnt++) {     
            String mat = materialNumbersList[matCnt];
            if (!materialNumberPbe.containsKey(mat)) {
                missingMaterials.add(mat);
            }
        }

        // Throw an error message for the missing materials
        if (missingMaterials.size() > 0) {
            List<Pricebook2> pbl = [SELECT Name FROM Pricebook2 WHERE Id = :pricebookId];
            String pricebookName = null != pbl && pbl.size() > 0 ? pbl.get(0).Name : 'Unknown Pricebook2';
            String missingProductsMessage = String.format(
                Label.ensxtx_SalesDoc_Message_MissingMaterials,
                new List<Object> {
                    pricebookName,
                    pricebookId,
                    String.join(new List<String>(missingMaterials), ', ')
                });
            if (!Test.isRunningTest()) throw new MissingMaterialsException(missingProductsMessage);
        }
    }

    public static ensxtx_DS_Document_Detail.PARTNERS getPartnerFromDocumentDetail(List<ensxtx_DS_Document_Detail.PARTNERS> partnerList, string partnerFunction, boolean create)
    {
        String partnerFunctionInternal = ensxtx_UTIL_Customer.partnerFunctionMap.containsKey(partnerFunction) ? ensxtx_UTIL_Customer.partnerFunctionMap.get(partnerFunction) : partnerFunction;
        ensxtx_DS_Document_Detail.PARTNERS result = null;
        if (partnerList != null)
        {
            Integer partnerTot = partnerList.size();
            for (Integer partnerCnt = 0 ; partnerCnt < partnerTot ; partnerCnt++)
            {
                ensxtx_DS_Document_Detail.PARTNERS partner = partnerList[partnerCnt];
                if (partnerFunction == partner.PartnerFunction || partnerFunctionInternal == partner.PartnerFunctionInternal)
                {
                    result = partner;
                    break;
                }
            }
        }

        if (null == result && create)
        {
            result = new ensxtx_DS_Document_Detail.PARTNERS();
            result.PartnerFunction = partnerFunction;
            result.allowAddressOverride = false;
            if (partnerList != null) partnerList.add(result);
        }

        return result;
    }

    public class MissingMaterialsException extends Exception {}
}