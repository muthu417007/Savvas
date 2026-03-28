//THIS UTIL CLASS IS A CLONE FROM PDE WITH AN ADDED METHOD

public with sharing class ensxtx_UTIL_Pricebook
{
    private static final ensxsdk.Logger logger = new ensxsdk.Logger(ensxtx_UTIL_Pricebook.class);

    public class currencyMissingException extends Exception {}

	// getStandardPricebookId()
	// 
	// Return the Id of the standard pricebook
    static Id standardPriceBookId = null;
	public static Id getStandardPriceBookId()
	{
        if (standardPriceBookId == null)
        {
            try
            {
                standardPriceBookId = Test.isRunningTest() ? Test.getStandardPriceBookId() : [SELECT Id FROM Pricebook2 WHERE IsStandard = true LIMIT 1].Id;
            }
            catch (Exception e) { ensxtx_UTIL_PageMessages.addMessage(ensxtx_UTIL_PageMessages.WARNING, 'There was an issue retrieving the standard pricebook. ' + e.getMessage()); }
        }
		return standardPriceBookId;
	}

    public static Map<Id, PricebookEntry> getEntriesForPricebookById(Id pricebookId, Set<String> materialNumbers, String currencyISOCode)
    {
        logger.enterAura('getEntriesForPricebookById', new Map<String, Object> {
            'pricebookId' => pricebookId,
            'materialNumbers' => materialNumbers,
            'currencyISOCode' => currencyISOCode
        });

        Map<Id, PricebookEntry> result = new Map<Id, PricebookEntry>();
        try
        {
            if (null != pricebookId)
            {
                if(UserInfo.isMultiCurrencyOrganization() && String.isEmpty(currencyISOCode)) throw new currencyMissingException('Currency is required on Quote');
                String query = 'SELECT Product2Id, Id, Product2.' + ensxtx_UTIL_SFProduct.MaterialFieldName + ', Product2.Description, UnitPrice, IsActive, Pricebook2Id ' +
                    'FROM PricebookEntry ' +
                    'WHERE Pricebook2Id =: pricebookId ' +
                    'and IsActive = true ';

                if(UserInfo.isMultiCurrencyOrganization()) query += 'AND CurrencyIsoCode =:currencyISOCode ';

                query += 'AND Product2.' + ensxtx_UTIL_SFProduct.MaterialFieldName + ' IN :materialNumbers';

                loadResult(Database.Query(query), result);
            }
        } catch (Exception ex) {
            logger.log(LoggingLevel.ERROR, 'There was an exception thrown when attempting to get price book entries by material numbers', ex);
        } finally { 
            logger.exit();
        }

        return result;
    }

    @testVisible
    private static void loadResult(List<PricebookEntry> items, Map<Id, PricebookEntry> result)
    {
        Integer itemTot = items.size();
        for (Integer itemCnt = 0 ; itemCnt < itemTot ; itemCnt++)
        {
            PricebookEntry item = items[itemCnt];
            result.put(item.Product2Id, item);
        }
    }
    
    /// Compares the list of materials to be added to a cpq quote with the list of products in the pricebook
    /// Returns the material numbers of any products that aren't found in the pricebook.
    public static String validateProductsInPricebook(
        ensxtx_DS_Document_Detail salesDocDetail, 
        Id pricebookId, 
        Set<String> addedMaterialsSet, 
        Map<Id, PriceBookEntry> pricebookEntriesMap)
    {
        Map<string,string> validMaterialsMap = new Map<string,string>();
        Map<String, String> materialDescriptionMap = new Map<String, String>();        
        string resultError = ensxtx_UTIL_Pricebook.validateProductsInPricebook(pricebookId, addedMaterialsSet, pricebookEntriesMap, validMaterialsMap, materialDescriptionMap);

        if (String.isNotEmpty(resultError)) {
            ensxtx_UTIL_PageMessages.addMessage(ensxtx_UTIL_PageMessages.ERROR, resultError);
            return resultError;
        }

        if (salesDocDetail != null) {
           Integer itmTot = salesDocDetail.ITEMS.size();
            for (Integer itmCnt = 0 ; itmCnt < itmTot ; itmCnt++) {
                ensxtx_DS_Document_Detail.ITEMS item = salesDocDetail.ITEMS[itmCnt];
                if (String.isNotEmpty(item.BillOfMaterial) && Integer.valueOf(item.HigherLevelItemNumber) != 0) item.ProductId = validMaterialsMap.get(item.Material);
            }
        }

        return null;
    }

    public static String validateProductsInPricebook(
        Id pricebookId, 
        Set<String> addedMaterialsSet, 
        Map<Id, PriceBookEntry> pricebookEntriesMap,
        Map<string,string> validMaterialsMap,
        Map<String, String> materialDescriptionMap)
    {
        string resultError = '';
        List<string> pricebookValuesList = new List<string>();
        List<string> invalidPricebookValuesList = new List<string>();

        List<PricebookEntry> peList = pricebookEntriesMap.values();
        Integer peTot = peList.size();
        for (Integer peCnt = 0 ; peCnt < peTot ; peCnt++)
        {
            PricebookEntry pe = peList[peCnt];
            string materialName = (String) pe.Product2.get(ensxtx_UTIL_SFProduct.MaterialFieldName);

            if(pricebookValuesList.contains(materialName))
            {
                invalidPricebookValuesList.add(materialName);
            }
            else
            {
                pricebookValuesList.add(materialName);
                addedMaterialsSet.remove(materialName);
                validMaterialsMap.put(materialName, pe.Product2Id);
                materialDescriptionMap.put(materialName, pe.Product2.Description);
            }
        }

        Boolean SkipMissingBoM = (Boolean)ensxtx_UTIL_AppSettings.getValue(ensxtx_UTIL_AppSettings.CPQV2, 'SkipMissingBoM', false);
        if (addedMaterialsSet.size() > 0 && !SkipMissingBoM)
        {
            resultError += ('Some of the products ' + String.join(new List<string>(addedMaterialsSet), ', ') + ' added to this quote either do not exist in the price book: ' + pricebookId 
                + ', the pricebook entry is inactive '
                + ', the pricebook itself is inactive '
                + ', the pricebook entry currency is not same as quote'
                + ', the product is inactive, or the current user does not have permissions to access the product.');
        }
        if (invalidPricebookValuesList.size() > 0)
        {
            resultError += ('The following materials have more than one entry in the pricebook: '
                + String.join(invalidPricebookValuesList,', ')
                + '. Please cleaup pricebook: '
                + pricebookId + ' so that every material only has one entry.');
        }
        return resultError;
    }
}