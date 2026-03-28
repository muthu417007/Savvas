/// @description Unified response format for all AuraEnabled API requests
public without sharing class ensxtx_UTIL_Aura
{
    public static void setSearchContextSearchParams(ensxsdk.EnosixFramework.ValueObject seachParamsValueObj, Map<String, Object> searchParams)
    {
        if (searchParams != null) {
            Map<String, ensxsdk.EnosixFramework.FieldInfo> searchParamsFieldMap;
            if (!Test.isRunningTest()) searchParamsFieldMap = seachParamsValueObj.getFields();
            else {
                searchParamsFieldMap = new Map<String, ensxsdk.EnosixFramework.FieldInfo>();
                ensxsdk.EnosixFramework.FieldInformation fieldInfo = new ensxsdk.EnosixFramework.FieldInformation();
                searchParamsFieldMap.put('Test', fieldInfo);
            }
            Map<String, String> upcaseToKeyMap = new Map<String, String>();
            List<String> keyList = new List<String>(searchParamsFieldMap.keySet());
            Integer mapTot = keyList.size();
            for (Integer mapCnt = 0 ; mapCnt < mapTot ; mapCnt++) {
                String key = keyList[mapCnt];
                upcaseToKeyMap.put(key.toUpperCase(), key);
            }

            for (String key : searchParams.keySet()) {
                String fieldKey = upcaseToKeyMap.get(key.toUpperCase());
                ensxsdk.EnosixFramework.FieldInfo fieldInfo = searchParamsFieldMap.get(fieldKey);
                if (fieldInfo != null) {
                    fieldInfo.setValue(seachParamsValueObj, searchParams.get(key));
                }
                else {
                    ensxtx_UTIL_PageMessages.addMessage(ensxtx_UTIL_PageMessages.WARNING, key + ' is not a valid search parameter field');
                }
            }
        }
    }

    public static void setSearchContextPagingOptions(ensxsdk.EnosixFramework.SearchContext sc, Map<String, Object> pagingOptions)
    {
        setSearchContextPagingOptions(sc, pagingOptions, null);
    }

    public static void setSearchContextPagingOptions(ensxsdk.EnosixFramework.SearchContext sc, Map<String, Object> pagingOptions,
        List<Map<String, Object>> sortFields)
    {
        if (pagingOptions != null)
        {
            sc.pagingOptions.pageSize = Integer.valueOf(pagingOptions.get('pageSize'));
            sc.pagingOptions.pageNumber = Integer.valueOf(pagingOptions.get('pageNumber'));
        }

        if (sortFields != null) {
            List<ensxsdk.EnosixFramework.SearchSortField> searchSortFields = new List<ensxsdk.EnosixFramework.SearchSortField>();

            for (Map<String, Object> sortField : sortFields) {
                searchSortFields.add(new ensxsdk.EnosixFramework.SearchSortField(
                    Integer.valueOf(sortField.get('precedence')),
                    String.valueOf(sortField.get('sortField')),
                    String.valueOf(sortField.get('direction'))
                ));
            }

            searchSortFields.sort();
            sc.pagingOptions.sortOrder = searchSortFields;
        }
    }

    public static Response createResponse(Object data, Object pagingOptions)
    {
        Response r = new Response(data, pagingOptions,
            ensxtx_UTIL_PageMessages.messageList.clone(),
            ensxtx_UTIL_Aura.httpTraces.clone());

        ensxtx_UTIL_PageMessages.messageList.clear();
        ensxtx_UTIL_Aura.httpTraces.clear();

        return r;
    }

    public static Response createResponse(Object data)
    {
        return createResponse(data, null);
    }

    public static List<ensxapp__Log__c> httpTraces { get; private set; }
    static {
        ensxtx_UTIL_Aura.httpTraces = new List<ensxapp__Log__c>();
    }

    public static void addHttpTrace(ensxapp__Log__c logEntry) {
        ensxtx_UTIL_Aura.httpTraces.add(logEntry);
    }

    public with sharing class Response
    {
        @AuraEnabled public Object data { get; private set; }
        @AuraEnabled public Object pagingOptions { get; private set; }
        @AuraEnabled public List<ensxtx_UTIL_PageMessages.Message> messages { get; private set; }
        @AuraEnabled public String namespacePrefix { get { return ensxtx_UTIL_Namespace.namespacePrefix; } }
        @AuraEnabled public List<ensxapp__Log__c> httpTraces { get; set; }

        public Response(Object data, Object pagingOptions,
            List<ensxtx_UTIL_PageMessages.Message> messages, List<ensxapp__Log__c> httpTraces)
        {
            this.data = data;
            this.pagingOptions = pagingOptions;
            this.messages = messages;
            this.httpTraces = httpTraces;
        }
    }
}