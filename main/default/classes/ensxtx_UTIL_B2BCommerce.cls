public with sharing class ensxtx_UTIL_B2BCommerce
{
    // A cache which maps community Ids to WebStore Ids
    private static Map<String, String> communityIdToWebStoreIdCache = new Map<String, String>();

    @AuraEnabled(cacheable=true)
    public static String getWebStoreId (String communityId) {
        if (communityIdToWebStoreIdCache.containsKey(communityId)) {
            return communityIdToWebStoreIdCache.get(communityId);
        } else {
            List<WebStoreNetwork> WebStoreNetworkList = [SELECT WebStoreId FROM WebStoreNetwork WHERE NetworkId = :communityId WITH SECURITY_ENFORCED];
            String webStoreId = WebStoreNetworkList.size() > 0 ? WebStoreNetworkList[0].WebStoreId : null;
            communityIdToWebStoreIdCache.put(communityId, webStoreId);
            return webStoreId;
        }
    }

    @AuraEnabled(cacheable=true)
    public static Map<String, Object> getProduct(
        String webStoreId,
        String productId,
        String accountId
    ) {
        // https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_ConnectAPI_CommerceCatalog_static_methods.htm#apex_ConnectAPI_CommerceCatalog_static_methods
        ConnectApi.ProductDetail resultConnect = (Test.isRunningTest()) ? 
            new ConnectApi.ProductDetail() : ConnectApi.CommerceCatalog.getProduct(webStoreId, productId, accountId, null, false, null, false, true, false);
        Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(resultConnect));
        Map<String, Object> attributeInfoMap = new Map<String, Object>();
        Schema.SObjectType targetType = Schema.getGlobalDescribe().get('Product2');
        Map<String, Schema.SObjectField> fieldMap = targetType.getDescribe().fields.getMap();
        for (Schema.SObjectField field : fieldMap.values()) {
            Schema.DescribeFieldResult describe = field.getDescribe();
            String apiName = describe.getName();
            String label = describe.getLabel();
            Map<String, String> attributeInfo = new Map<String, String>();
            attributeInfo.put('apiName', apiName);
            attributeInfo.put('label', label);
            attributeInfoMap.put(apiName, attributeInfo);
        }
        result.put('attributeInfoMap', attributeInfoMap);
        return result;
    }
}