public without sharing class ensxtx_CTRL_Cart {
    private static final ensxsdk.Logger logger = new ensxsdk.Logger(ensxtx_CTRL_Cart.class);

    public class Request 
    {
        @InvocableVariable(label='App Settings Name' description='Specifiy the name of the static resource file.' required=true)
        public String appSettingsName;

        @InvocableVariable(label='Record Id' description='Record Id of the SObject' required=true)
        public Id recordId;

        @InvocableVariable(label='Invoke Method' description='Simulate or Create' required=true)
        public Id invokeMethod;

        @InvocableVariable(label='Run in Background' description='Default is False.' required=false)
        public Boolean isBackground;
    }

    @InvocableMethod(label='Enosix Commerce Sales Doc Invocable' description='Invoke simulate or create SAP sales document from Commerce Cart or Order' category='enosix' callout=true)
    public static void salesDocInvocable(List<Request> requestList)
    {
        logger.enterAura('salesDocInvocable', new Map<String, Object>{
            'requestList' => requestList
        });

        List<ensxtx_UTIL_SalesDocInvocableActions.Request> foregroundList = new List<ensxtx_UTIL_SalesDocInvocableActions.Request>();
        List<ensxtx_UTIL_SalesDocInvocableActions.Request> backgroundList = new List<ensxtx_UTIL_SalesDocInvocableActions.Request>();
        Integer reqTot = requestList.size();
        for (Integer reqCnt = 0 ; reqCnt < reqTot ; reqCnt++) {
            Request req = requestList[reqCnt];
            Map<String, String> appSettingsMap = pareseAppSettingsName(req.appSettingsName);
            ensxtx_UTIL_SalesDocInvocableActions.Request sdReq = new ensxtx_UTIL_SalesDocInvocableActions.Request();
            sdReq.recordId = req.recordId;
            sdReq.appSettingsName = appSettingsMap.get('appSettingsName');
            sdReq.appSettingsKey = appSettingsMap.get('appSettingsKey');
            sdReq.appSettingsTypeName = appSettingsMap.get('appSettingsTypeName');
            sdReq.appSettingsInvokeMethod = req.invokeMethod;
            if (req.isBackground != null && req.isBackground) {
                backgroundList.add(sdReq);
            } else foregroundList.add(sdReq);
        }
        if (foregroundList.size() > 0) ensxtx_UTIL_SalesDocInvocableForeground.salesDocInvocable(foregroundList);
        if (backgroundList.size() > 0) ensxtx_UTIL_SalesDocInvocableBackground.salesDocInvocable(backgroundList);
        logger.exit();
    }

    @AuraEnabled(cacheable=false)
    public static ensxtx_UTIL_Aura.Response getPartner(
        String partnerFunction,
        Map<String, Id> sfObjectIdMap
    )
    {
        Id cartId = sfObjectIdMap.get('WebCart');
        String jsonField = 'ensxtx_SAP_' + partnerFunction + '_Partner_JSON__c';
        String query = 'SELECT Id, ' + jsonField + ' FROM WebCart WHERE Id =\'' + cartId + '\'';
        List<WebCart> wcList = Database.query(query);
        Map<String, Object> partner = wcList.size() == 0 || String.isEmpty((String) wcList[0].get(jsonField)) ? null : (Map<String, Object>) JSON.deserializeUntyped((String) wcList[0].get(jsonField));
        return ensxtx_UTIL_Aura.createResponse(partner);
    }

    @AuraEnabled(cacheable=false)
    public static ensxtx_UTIL_Aura.Response savePartner(
        String partnerFunction,
        Map<String, String> partner,
        Map<String, Id> sfObjectIdMap
    )
    {
        ContactPointAddress cpa = null;
        WebCart cart = new WebCart();
        Id cartId = sfObjectIdMap.get('WebCart');
        Id acctId = sfObjectIdMap.get('Account');
        cart.Id = cartId;
        cart.put('ensxtx_SAP_' + partnerFunction + '_Partner_JSON__c', JSON.serialize(partner));
        update cart;
        if (partnerFunction == ensxtx_UTIL_Customer.SHIP_TO_PARTNER_CODE) {
            try {
                List<CartDeliveryGroup> cdgList = [SELECT Id, CartId, isDeleted FROM CartDeliveryGroup WHERE isDeleted = false AND CartId = :cartId];
                CartDeliveryGroup cdg = cdgList.size() > 0 ? cdgList[0] : new CartDeliveryGroup();
                if (String.isEmpty(cdg.CartId)) cdg.CartId = cartId;
                String firstName = partner.containsKey('PartnerName') ? partner.get('PartnerName') : '';
                String lastName = partner.containsKey('PartnerName2') ? partner.get('PartnerName2') : '';
                String city = partner.containsKey('City') ? partner.get('City') : '';
                String state = partner.containsKey('Region') ? partner.get('Region') : '';
                String country = partner.containsKey('Country') ? partner.get('Country') : '';
                String postalCode = partner.containsKey('PostalCode') ? partner.get('PostalCode') : '';
                if (String.isNotEmpty(firstName)) cdg.DeliverToFirstName = firstName;
                if (String.isNotEmpty(lastName)) cdg.DeliverToLastName = lastName;
                cdg.DeliverToStreet = String.isEmpty(partner.get('HouseNumber')) ? '' : partner.get('HouseNumber');
                cdg.DeliverToStreet += String.isEmpty(cdg.DeliverToStreet) || String.isEmpty(partner.get('Street')) ? '' : ' ';
                cdg.DeliverToStreet += String.isEmpty(partner.get('Street')) ? '' : partner.get('Street');
                cdg.DeliverToCity = city;
                Boolean isStateCode = ensxtx_UTIL_SObject.doesSobjectFieldExist('CartDeliveryGroup', 'DeliverToStateCode');
                String cdgStateField = isStateCode ? 'DeliverToStateCode' : 'DeliverToState';
                String cdgCountryField = isStateCode ? 'DeliverToCountryCode' : 'DeliverToCountry';
                cdg.put(cdgStateField, state);
                cdg.put(cdgCountryField, country);
                cdg.DeliverToPostalCode = postalCode;
                upsert cdg;
                String cpaStateField = isStateCode ? 'StateCode' : 'State';
                String cpaCountryField = isStateCode ? 'CountryCode' : 'Country';
                String query = 'SELECT Id, ParentId, AddressType FROM ContactPointAddress WHERE isDeleted = false AND ParentId = \'' + acctId + '\' ' +
                    'AND AddressType = \'Shipping\' AND ActiveFromDate = null AND ActiveToDate = null AND AddressFirstName = \'' + firstName +  '\' ' +
                    'AND AddressLastName = \'' + lastName + '\' AND Street = \'' + cdg.DeliverToStreet + '\' AND City = \'' + city +  '\' ' +
                    'AND ' + cpaStateField + ' = \'' + state + '\' AND ' + cpaCountryField + ' = \'' + country + '\' AND PostalCode = \'' + postalCode + '\'';
                System.debug('Query='+query);
                List<ContactPointAddress> cpaList = Database.query(query);
                cpa = new ContactPointAddress();
                cpa.ParentId = acctId;
                cpa.AddressType = 'Shipping';
                cpa.Name = String.isNotEmpty(firstName) ? firstName : '';
                if (String.isNotEmpty(firstName) && String.isNotEmpty(lastName)) cpa.Name += ' ';
                cpa.Name += String.isNotEmpty(lastName) ? lastName : '';
                if (cpaList.size() > 0) cpa = cpaList[0];
                cpa.AddressFirstName = firstName;
                cpa.AddressLastName = lastName;
                cpa.Street = cdg.DeliverToStreet;
                cpa.City = city;
                cpa.put(cpaStateField, state);
                cpa.put(cpaCountryField, country);
                cpa.PostalCode = postalCode;
                upsert cpa;
            } catch (Exception e) {}
        } else if (partnerFunction == ensxtx_UTIL_Customer.BILL_TO_PARTNER_CODE) {
            try {
                cart.BillingStreet = String.isEmpty(partner.get('HouseNumber')) ? '' : partner.get('HouseNumber');
                cart.BillingStreet += String.isEmpty(cart.BillingStreet) || String.isEmpty(partner.get('Street')) ? '' : ' ';
                cart.BillingStreet += String.isEmpty(partner.get('Street')) ? '' : partner.get('Street');
                cart.BillingCity = partner.get('City');
                Boolean isStateCode = ensxtx_UTIL_SObject.doesSobjectFieldExist('WebCart', 'BillingStateCode');
                String stateField = isStateCode ? 'BillingStateCode' : 'BillingState';
                String countryField = isStateCode ? 'BillingCountryCode' : 'BillingCountry';
                cart.put(stateField, partner.get('Region'));
                cart.put(countryField, partner.get('Country'));
                cart.BillingPostalCode = partner.get('PostalCode');
                update cart;
            } catch (Exception e) {}
        }

        return ensxtx_UTIL_Aura.createResponse(cpa);
    }

    @AuraEnabled(cacheable=false)
    public static ensxtx_UTIL_Aura.Response productSimulation(
        List<String> productInfoList,
        Map<String, Id> sfObjectIdMap,
        String pdpAppSettingsName,
        String appSettingsName,
        Map<String, String> pdpInputParametersMap
    ) {
        for (String key : sfObjectIdMap.keySet()) {
            sfObjectIdMap.put(key.toUpperCase(), sfObjectIdMap.get(key));
        }
        Map<String, String> productSimulattionFieldsMap;
        Map<String, Object> appSettings = null;
        String pdpDocAppSettingsJSON = ensxtx_UTIL_GetAppSettings.getAppsettings(pdpAppSettingsName);
        if (String.isNotEmpty(pdpDocAppSettingsJSON)) {
            appSettings = (Map<String, Object>) ((Map<String, Object>) JSON.deserializeUntyped(pdpDocAppSettingsJSON)).get('CartPDP');
        }    
        List<Object> mapFieldsObj = appSettings != null && appSettings.containsKey('SimulationFields') ? 
            (List<Object>) appSettings.get('SimulationFields') : new List<Object>();
        List<Map<String, Object>> mapFieldsList = new List<Map<String, Object>>();
        for (Object mapFieldObj : mapFieldsObj) {
            mapFieldsList.add((Map<String, Object>) mapFieldObj);
        }
        Map<String, Object> mapField = new Map<String, Object>{'sapField' => 'Header:SoldToParty', 'sfObjectType' => 'ACCOUNT', 'sfField' => ensxtx_UTIL_SFAccount.CustomerFieldName};
        if (mapFieldsList.size() > 0) {
            mapFieldsList.add(0, mapField);
        } else mapFieldsList.add(mapField);
        productSimulattionFieldsMap = ensxtx_UTIL_LoadValuesMap.loadValuesMap(mapFieldsList, sfObjectIdMap);
        if(pdpInputParametersMap != null) {
            productSimulattionFieldsMap.putAll(pdpInputParametersMap);
        }

        return invokeSalesDoc(appSettingsName, sfObjectIdMap.get('ACCOUNT'), 'Product', productInfoList, productSimulattionFieldsMap);
    }

    private static ensxtx_UTIL_Aura.Response invokeSalesDoc(
        String appSettingsName,
        Id recordId,
        String invokeMethodAppSetting,
        List<String> productInfoList,
        Map<String, String> productSimulattionFieldsMap
    ) {
        ensxtx_UTIL_Aura.Response response = ensxtx_UTIL_Aura.createResponse(null);
        Map<String, String> appSettingsMap = pareseAppSettingsName(appSettingsName);
        if (String.isNotEmpty(appSettingsMap.get('appSettingsTypeName'))) {
            ensxtx_UTIL_SalesDocInvocableActions.Request request = new ensxtx_UTIL_SalesDocInvocableActions.Request();
            request.recordId = recordId;
            request.productSimulationFieldsMapJSON = JSON.serialize(productSimulattionFieldsMap);
            request.productJSONList = productInfoList;
            request.appSettingsName = appSettingsMap.get('appSettingsName');
            request.appSettingsKey = appSettingsMap.get('appSettingsKey');
            request.appSettingsTypeName = appSettingsMap.get('appSettingsTypeName');
            request.appSettingsInvokeMethod = invokeMethodAppSetting;

            if (recordId != null) response = ensxtx_UTIL_Aura.createResponse(ensxtx_UTIL_SalesDocInvocableActions.invokeSalesDoc(request));
        }
        return response;
    }

    private static Map<String, String> pareseAppSettingsName(
        String appSettingsName
    ) {
        Map<String, String> appSettingsMap = new Map<String, String>();
        String salesDocAppSettingsJSON = ensxtx_UTIL_GetAppSettings.getAppsettings(appSettingsName);
        if (String.isNotEmpty(salesDocAppSettingsJSON)) {
            appSettingsMap.put('appSettingsName', appSettingsName.removeStart(ensxtx_UTIL_AppSettings.Prefix).removeEnd(ensxtx_UTIL_AppSettings.Suffix));
            Map<String, Object> salesDocAppSettings = (Map<String, Object>) JSON.deserializeUntyped(salesDocAppSettingsJSON);
            List<String> keyList = new List<String>(salesDocAppSettings.keySet());
            if (keyList.size() > 1) {
                appSettingsMap.put('appSettingsKey', new List<String>(salesDocAppSettings.keySet())[1]);

                salesDocAppSettings = (Map<String, Object>) salesDocAppSettings.get(appSettingsMap.get('appSettingsKey'));
                keyList = new List<String>(salesDocAppSettings.keySet());
                if (keyList.size() > 0) {
                    appSettingsMap.put('appSettingsTypeName', new List<String>(salesDocAppSettings.keySet())[0]);
                } else ensxtx_UTIL_PageMessages.addMessage(ensxtx_UTIL_PageMessages.ERROR, 'Invalid App Settings');
            } else ensxtx_UTIL_PageMessages.addMessage(ensxtx_UTIL_PageMessages.ERROR, 'Invalid App Settings');
        } else ensxtx_UTIL_PageMessages.addMessage(ensxtx_UTIL_PageMessages.ERROR, 'Required App Settings missing for '+appSettingsName);

        return appSettingsMap;
    }

    @AuraEnabled(cacheable=false)
    public static ensxtx_UTIL_Aura.Response cartSimulation(
        Id cartId,
        String appSettingsName
    ) {
        return invokeSalesDoc(appSettingsName, cartId, 'Simulate', null, null);
    }

    @AuraEnabled(cacheable=false)
    public static ensxtx_UTIL_Aura.Response createSalesDocument(
        Id recordId,
        String appSettingsName
    ) {
        return invokeSalesDoc(appSettingsName, recordId, 'Create', null, null);
    }

    @AuraEnabled(cacheable=false)
    public static ensxtx_UTIL_Aura.Response getPricingTiers(
        String pdpAppSettingsName,
        Map<String, Id> sfObjectIdMap
    ) {
        ensxtx_SBO_SFCIMaterialScales_Search sbo = new ensxtx_SBO_SFCIMaterialScales_Search();
        Map<String, Object> results = new Map<String, Object>();
        Object responsePagingOptions = null; 

        try
        {
            Map<String, Object> appSettings = null;
            String pdpDocAppSettingsJSON = ensxtx_UTIL_GetAppSettings.getAppsettings(pdpAppSettingsName);
            if (String.isNotEmpty(pdpDocAppSettingsJSON)) {
                appSettings = (Map<String, Object>) ((Map<String, Object>) JSON.deserializeUntyped(pdpDocAppSettingsJSON)).get('CartPDP');
            }    
            Map<String, String> searchParams;

            List<Object> mapFieldsObj = appSettings != null && appSettings.containsKey('SimulationFields') ? 
                (List<Object>) appSettings.get('SimulationFields') : new List<Object>();
            List<Map<String, Object>> mapFieldsList = new List<Map<String, Object>>();
            for (Object mapFieldObj : mapFieldsObj) {
                mapFieldsList.add((Map<String, Object>) mapFieldObj);
            }
            Map<String, Object> mapField = new Map<String, Object>{'sapField' => 'CustomerNumber', 'sfObjectType' => 'ACCOUNT', 'sfField' => ensxtx_UTIL_SFAccount.CustomerFieldName};
            if (mapFieldsList.size() > 0) {
                mapFieldsList.add(0, mapField);
            } else mapFieldsList.add(mapField);
            mapFieldsList.add(0, new Map<String, Object>{'sapField' => 'Material', 'sfObjectType' => 'PRODUCT2', 'sfField' => ensxtx_UTIL_SFProduct.MaterialFieldName});
            searchParams = ensxtx_UTIL_LoadValuesMap.loadValuesMap(mapFieldsList, sfObjectIdMap);
            ensxtx_SBO_SFCIMaterialScales_Search.SFCIMaterialScales_SC searchContext = new ensxtx_SBO_SFCIMaterialScales_Search.SFCIMaterialScales_SC();
            ensxtx_UTIL_Aura.setSearchContextSearchParams(searchContext.SEARCHPARAMS, searchParams);
            Map<String, Object> pagingOptions = new Map<String, Object>();
            pagingOptions.put('pageSize', 100);
            pagingOptions.put('pageNumber', 1);
            ensxtx_UTIL_Aura.setSearchContextPagingOptions(searchContext, pagingOptions);

            sbo.search(searchContext);

            List<ensxtx_SBO_SFCIMaterialScales_Search.SEARCHRESULT> searchResults = searchContext.result.getResults();
            if (searchResults.size() > 0) results.put('materialScales', searchResults);
            responsePagingOptions = searchContext.pagingOptions;
            ensxtx_UTIL_PageMessages.addFrameworkMessages(searchContext.result.getMessages());
        }
        catch (Exception ex)
        {
            ensxtx_UTIL_PageMessages.addExceptionMessage(ex);
        }
        return ensxtx_UTIL_Aura.createResponse(results, responsePagingOptions);
    }

    @AuraEnabled(cacheable=false)
    public static ensxtx_UTIL_Aura.Response addItemToList(
        String webStoreId,
        String productId,
        String accountId,
        String userId
    ) {
        ensxtx_UTIL_Aura.Response response = null;
        Id wishlistId = null;
        List<Wishlist> wishlistList = [SELECT Id, OwnerId, WebStoreId, AccountId FROM Wishlist WHERE OwnerId = :userId AND WebStoreId = :webStoreId AND AccountId = :accountId];
        Wishlist wishlistObj = wishlistList.size() == 0 ? null : wishlistList[0];
        if (wishlistObj == null) {
            ConnectApi.WishlistInput wishlistInput = new ConnectApi.WishlistInput();
            wishlistInput.name = 'My List';
            ConnectApi.WishlistItemInput wishlistItemInput = new ConnectApi.WishlistItemInput();
            wishlistItemInput.productId = productId;
            wishlistInput.products = new List<ConnectApi.WishlistItemInput>{wishlistItemInput};
            ConnectApi.Wishlist connectWishlist = (Test.isRunningTest()) ? new ConnectApi.Wishlist() : ConnectApi.CommerceWishlist.createWishlist(webStoreId, wishlistInput);
            if (!Test.isRunningTest()) wishlistId = connectWishlist.summary.id;
        } else {
            wishlistId = wishlistObj.Id;
            List<WishlistItem> WishlistItemList = [SELECT Id, Name, WishlistId, Product2Id FROM WishlistItem WHERE WishListId = :wishlistId AND Product2Id = :productId];
            if (WishlistItemList.size() == 0) {
                ConnectApi.WishlistItemInput wishlistItemInput = new ConnectApi.WishlistItemInput();
                wishlistItemInput.productId = productId;
                if (!Test.isRunningTest()) ConnectApi.CommerceWishlist.addItemToWishlist(webStoreId, wishlistObj.Id, wishlistItemInput);
            }
        }

        response = ensxtx_UTIL_Aura.createResponse(wishlistId);
        return response;
    }
}