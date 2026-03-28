public with sharing class ensxtx_CTRL_CustomerSearch
{
    private static final ensxsdk.Logger logger = new ensxsdk.Logger(ensxtx_CTRL_CustomerSearch.class);

    @AuraEnabled(cacheable=false)
    public static ensxtx_UTIL_Aura.Response searchCustomers(
        Boolean isContactSearch,
        Map<String, Object> pagingOptions,
        List<Map<String, Object>> mapFieldsList,
        Map<String, Id> sfObjectIdMap
    )
    {
        logger.enterAura('searchCustomers', new Map<String, Object>{
            'isContactSearch' => isContactSearch,
            'pagingOptions' => pagingOptions,
            'mapFieldsList' => mapFieldsList,
            'sfObjectIdMap' => sfObjectIdMap
        });

        ensxtx_SBO_EnosixCustomer_Search sbo = new ensxtx_SBO_EnosixCustomer_Search();
        Map<String, Object> results = new Map<String, Object>();
        Object responsePagingOptions = null;

        try
        {
            if (isContactSearch) {
                Map<String, Object> mapField = new Map<String, Object>{
                    'sapField' => 'customerNumber',
                    'sfObjectType' => 'ACCOUNT',
                    'sfField' => ensxtx_UTIL_SFAccount.CustomerFieldName
                };

                if (mapFieldsList.size() > 0) {
                    mapFieldsList.add(0, mapField);
                }
                else {
                    mapFieldsList.add(mapField);
                }
            }

            Map<String, String> searchParams = ensxtx_UTIL_LoadValuesMap.loadValuesMap(mapFieldsList, sfObjectIdMap);
            ensxtx_SBO_EnosixCustomer_Search.EnosixCustomer_SC searchContext = new ensxtx_SBO_EnosixCustomer_Search.EnosixCustomer_SC();

            if (isContactSearch) {
                ensxtx_UTIL_Aura.setSearchContextSearchParams(searchContext.CONTACT_PERSON, searchParams);

                // This is being returned to be able to be displayed in the LWC when it is used as a default on the load of the screen so it can be displayed
                results.put('customerNumber', searchParams.get('customerNumber'));
            }
            else {
                ensxtx_UTIL_Aura.setSearchContextSearchParams(searchContext.SEARCHPARAMS, searchParams);
            }

            ensxtx_UTIL_Aura.setSearchContextPagingOptions(searchContext, pagingOptions);

            sbo.search(searchContext);

            List<ensxtx_SBO_EnosixCustomer_Search.SEARCHRESULT> searchResults = searchContext.result.getResults();
            List<Map<String, Object>> returnList = new List<Map<String, Object>>();
            Integer srTot = searchResults.size();

            for (Integer srCnt = 0 ; srCnt < srTot ; srCnt++) {
                ensxtx_SBO_EnosixCustomer_Search.SEARCHRESULT sr = searchResults[srCnt];
                Map<String, Object> returnMap = new Map<String, Object>();
                returnMap.put('CustomerNumber', sr.CustomerNumber);
                returnMap.put('Name', sr.Name);
                returnMap.put('Name2', sr.Name2);
                returnMap.put('Street', sr.Street);
                returnMap.put('City', sr.City);
                returnMap.put('PostalCode', sr.PostalCode);
                returnMap.put('Region', sr.Region);
                returnMap.put('Country', sr.Country);
                returnMap.put('POBox', sr.POBox);
                returnMap.put('TelephoneNumber', sr.TelephoneNumber);
                returnMap.put('Language', sr.Language);
                returnMap.put('CreditLimit', sr.CreditLimit);
                returnMap.put('CreditAvailable', sr.CreditAvailable);
                returnMap.put('CurrencyKey', sr.CurrencyKey);
                returnMap.put('EMailAddress', sr.EMailAddress);
                returnList.add(returnMap);
            }

            if (searchResults.size() > 0) results.put('searchResult', returnList);
            responsePagingOptions = searchContext.pagingOptions;
            ensxtx_UTIL_PageMessages.addFrameworkMessages(searchContext.result.getMessages());
        }
        catch (Exception ex)
        {
            ensxtx_UTIL_PageMessages.addExceptionMessage(ex);
        }
        finally
        {
            logger.exit();
        }

        return ensxtx_UTIL_Aura.createResponse(results, responsePagingOptions);
    }

    @AuraEnabled(cacheable=false)
    public static ensxtx_UTIL_Aura.Response searchVendors(
        Boolean isContactSearch,
        Map<String, Object> pagingOptions,
        List<Map<String, Object>> mapFieldsList,
        Map<String, Id> sfObjectIdMap
    )
    {
        logger.enterAura('searchVendors', new Map<String, Object>{
            'isContactSearch' => isContactSearch,
            'pagingOptions' => pagingOptions,
            'mapFieldsList' => mapFieldsList,
            'sfObjectIdMap' => sfObjectIdMap
        });

        ensxtx_SBO_EnosixVendor_Search sbo = new ensxtx_SBO_EnosixVendor_Search();
        Map<String, Object> results = new Map<String, Object>();
        Object responsePagingOptions = null; 

        try
        {
            Map<String, String> searchParams = ensxtx_UTIL_LoadValuesMap.loadValuesMap(mapFieldsList, sfObjectIdMap);
            ensxtx_SBO_EnosixVendor_Search.EnosixVendor_SC searchContext = new ensxtx_SBO_EnosixVendor_Search.EnosixVendor_SC();
            ensxtx_UTIL_Aura.setSearchContextSearchParams(searchContext.VENDOR, searchParams);
            ensxtx_UTIL_Aura.setSearchContextPagingOptions(searchContext, pagingOptions);

            sbo.search(searchContext);

            List<ensxtx_SBO_EnosixVendor_Search.SEARCHRESULT> searchResults = searchContext.result.getResults();
            List<Map<String, Object>> returnList = new List<Map<String, Object>>();
            Integer srTot = searchResults.size();

            for (Integer srCnt = 0 ; srCnt < srTot ; srCnt++) {
                ensxtx_SBO_EnosixVendor_Search.SEARCHRESULT sr = searchResults[srCnt];
                Map<String, Object> srMap = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(sr));
                srMap.put('CustomerNumber', srMap.get('Vendor'));
                returnList.add(srMap);
            }

            if (searchResults.size() > 0) results.put('searchResult', returnList);
            responsePagingOptions = searchContext.pagingOptions;
            ensxtx_UTIL_PageMessages.addFrameworkMessages(searchContext.result.getMessages());
        }
        catch (Exception ex)
        {
            ensxtx_UTIL_PageMessages.addExceptionMessage(ex);
        }
        finally
        {
            logger.exit();
        }

        return ensxtx_UTIL_Aura.createResponse(results, responsePagingOptions);
    }
}