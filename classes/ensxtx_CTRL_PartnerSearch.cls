public with sharing class ensxtx_CTRL_PartnerSearch {

    private static final ensxsdk.Logger logger = new ensxsdk.Logger(ensxtx_CTRL_PartnerSearch.class);

    @AuraEnabled(cacheable=false)
    public static ensxtx_UTIL_Aura.Response searchPartners(
        String partnerFunction,
        String partnerFunctionInternal,
        Map<String, Object> pagingOptions,
        List<Map<String, Object>> sortFields,
        List<Map<String, Object>> mapFieldsList,
        Map<String, Id> sfObjectIdMap
    )
    {
        logger.enterAura('searchPartners', new Map<String, Object>{
            'partnerFunction' => partnerFunction,
            'partnerFunctionInternal' => partnerFunctionInternal,
            'pagingOptions' => pagingOptions,
            'sortFields' => sortFields,
            'mapFieldsList' => mapFieldsList,
            'sfObjectIdMap' => sfObjectIdMap
        });

        ensxtx_SBO_EnosixPartner_Search sbo = new ensxtx_SBO_EnosixPartner_Search();
        Map<String, Object> results = new Map<String, Object>();
        Object responsePagingOptions = null; 

        try
        {
            Map<String, String> searchParams;
            Map<String, Object> mapField = new Map<String, Object>{
                'sapField' => 'CustomerNumber',
                'sfObjectType' => 'ACCOUNT',
                'sfField' => ensxtx_UTIL_SFAccount.CustomerFieldName
            };

            if (mapFieldsList.size() > 0) {
                mapFieldsList.add(0, mapField);
            }
            else {
                mapFieldsList.add(mapField);
            }

            mapFieldsList.add(0,
                new Map<String, Object>{
                    'sapField' => 'Material',
                    'sfObjectType' => 'PRODUCT2',
                    'sfField' => ensxtx_UTIL_SFProduct.MaterialFieldName
                });

            searchParams = ensxtx_UTIL_LoadValuesMap.loadValuesMap(mapFieldsList, sfObjectIdMap);

            ensxtx_SBO_EnosixPartner_Search.EnosixPartner_SC searchContext = new ensxtx_SBO_EnosixPartner_Search.EnosixPartner_SC();
            searchContext.SEARCHPARAMS.PartnerFunction = partnerFunction;
            searchContext.SEARCHPARAMS.PartnerFunctionInternal = String.isNotEmpty(partnerFunctionInternal) ? 
                partnerFunctionInternal : (ensxtx_UTIL_Customer.partnerFunctionMap.containsKey(partnerFunction) ?
                    ensxtx_UTIL_Customer.partnerFunctionMap.get(partnerFunction) : partnerFunction);

            ensxtx_UTIL_Aura.setSearchContextSearchParams(searchContext.SEARCHPARAMS, searchParams);
            ensxtx_UTIL_Aura.setSearchContextPagingOptions(searchContext, pagingOptions, sortFields);

            sbo.search(searchContext);

            List<ensxtx_SBO_EnosixPartner_Search.SEARCHRESULT> searchResults = searchContext.result.getResults();
            Map<String, Map<String, Object>> returnMap = new Map<String, Map<String, Object>>();
            Integer srTot = searchResults.size();

            for (Integer srCnt = 0 ; srCnt < srTot ; srCnt++) {
                ensxtx_SBO_EnosixPartner_Search.SEARCHRESULT sr = searchResults[srCnt];
                String key = sr.PartnerNumber + ':' + sr.VendorNumber + ':' + sr.ContactNumber + ':' + sr.PersonnelNumber + ':' + sr.HouseNumber + ':' +
                    sr.Street + ':' + sr.City + ':' + sr.District + ':' + sr.PostalCode + ':' + sr.Region + ':' + sr.Country;

                sr.DefaultPartner = sr.DefaultPartner || returnMap.containsKey(key) ? (Boolean) returnMap.get(key).containsKey('DefaultPartner') : false;

                Map<String, Object> returnMap2 = new Map<String, Object>();
                returnMap2.put('SalesOrganization', sr.SalesOrganization);
                returnMap2.put('SalesOrganizationName', sr.SalesOrganizationName);
                returnMap2.put('DistributionChannel', sr.DistributionChannel);
                returnMap2.put('DistributionChannelName', sr.DistributionChannelName);
                returnMap2.put('Division', sr.Division);
                returnMap2.put('DivisionName', sr.DivisionName);
                returnMap2.put('PartnerFunction', sr.PartnerFunction);
                returnMap2.put('PartnerFunctionInternal', sr.PartnerFunctionInternal);
                returnMap2.put('PartnerFunctionName', sr.PartnerFunctionName);
                returnMap2.put('PartnerNumber', sr.PartnerNumber);
                returnMap2.put('PartnerName', sr.PartnerName);
                returnMap2.put('VendorNumber', sr.VendorNumber);
                returnMap2.put('VendorName', sr.VendorName);
                returnMap2.put('ContactNumber', sr.ContactNumber);
                returnMap2.put('ContactFirstName', sr.ContactFirstName);
                returnMap2.put('ContactLastName', sr.ContactLastName);
                returnMap2.put('PersonnelNumber', sr.PersonnelNumber);
                returnMap2.put('PersonnelFirstName', sr.PersonnelFirstName);
                returnMap2.put('PersonnelLastName', sr.PersonnelLastName);
                returnMap2.put('HouseNumber', sr.HouseNumber);
                returnMap2.put('Street', sr.Street);
                returnMap2.put('City', sr.City);
                returnMap2.put('District', sr.District);
                returnMap2.put('PostalCode', sr.PostalCode);
                returnMap2.put('Region', sr.Region);
                returnMap2.put('Country', sr.Country);
                returnMap2.put('DefaultPartner', sr.DefaultPartner);
                returnMap.put(key, returnMap2);
            }

            if (searchResults.size() > 0) results.put('partners', returnMap.values());

            responsePagingOptions = searchContext.pagingOptions;
            ensxtx_UTIL_PageMessages.addFrameworkMessages(searchContext.result.getMessages());
        }
        catch (Exception ex)
        {
            ensxtx_UTIL_PageMessages.addExceptionMessage(ex);
        }

        return ensxtx_UTIL_Aura.createResponse(results, responsePagingOptions);
    }
}