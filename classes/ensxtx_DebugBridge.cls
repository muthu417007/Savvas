// Debug Bridge to SAP
//
// WARNING: There is no apex unit test code coverage for this class because
// this endpoint is intended to only be used for development and testing,
// and is NOT intended to be used in a production environment.
//
// The endpoint must remain "ensx_mgb" (enosix Model Generator Bridge) to remain compatible with
// the legacy enosix Apex Model Generator desktop client.
//
// Endpoint available at https://<salesforce-instance>/services/apexrest/<namespace>/ensx_mgb/
// Requires Authentication header with Bearer token of SessionID or OAuth token.
@RestResource(urlMapping = '/ensx_mgb/*')
global with sharing class ensxtx_DebugBridge {
    @HttpPost
    global static void doPost() {
        ConnectOptions copts = new ConnectOptions();
        if (RestContext.request.requestURI.contains('sap-host=') || String.isNotBlank(RestContext.request.params.get('sap-host'))) {
            copts.Host = String.isNotBlank(RestContext.request.params.get('sap-host')) ?
                RestContext.request.params.get('sap-host') :
                RestContext.request.requestURI.substringAfter('sap-host=');
            if (!copts.Host.startsWith('callout:')) {
                copts.Host = 'callout:' + copts.Host;
            }
            if (String.isNotBlank(RestContext.request.params.get('sap-client'))) {
                copts.Client = RestContext.request.params.get('sap-client');
            }
            if (String.isNotBlank(RestContext.request.params.get('cid'))) {
                copts.CID = RestContext.request.params.get('cid');
            }
        } else {
            copts = getDefaultConnectOptions();
        }

        if (String.isNotBlank(RestContext.request.params.get('sap-language'))) {
            copts.Language = RestContext.request.params.get('sap-language');
        }

        Map<string, string> proxyClientInputParams = RestContext.request.params;
        Map<string, object> urlParameters = new Map<string, object>();
        for (String key : proxyClientInputParams.keySet()) {
            if (key != 'sap-host') {
                urlParameters.put(key, proxyClientInputParams.get(key));
            }
        }

        HttpRequest req = sapConnectionCreateRequest(copts, urlParameters);
        if (String.isNotBlank(RestContext.request.headers.get('Content-Type'))) {
            req.setHeader('Content-Type', RestContext.request.headers.get('Content-Type'));
        }
        if (String.isNotBlank(RestContext.request.headers.get('Cookie'))) {
            req.setHeader('Cookie', RestContext.request.headers.get('Cookie'));
        }
        req.setBodyAsBlob(RestContext.request.requestBody);

        logRequest(req);
        HttpResponse response = new Http().send(req);
        logResponse(response);

        RestContext.response.statusCode = response.getStatusCode();
        RestContext.response.addHeader('X-Forwarded-To', req.getEndpoint());
        RestContext.response.addHeader('Content-Type', response.getHeader('Content-Type'));
        RestContext.response.responseBody = response.getBodyAsBlob();
    }

    public class ConnectOptions {
        public String Host { get; set; }
        public String Client { get; set; }
        public String Language { get; set; }
        public String CID { get; set; }
        public Integer Timeout { get; set; }
        public Boolean CompressionEnabled { get; set; }
        public ConnectOptions() {
            Language = getCurrentUsersLanguage('EN');
            CID = 'SFDC';
            Timeout = 120000;
            CompressionEnabled = false;
        }
    }

    private static String getCurrentUsersLanguage(String defaultValue) {
        String local = UserInfo.getLanguage();
        if (null != local) {
            return local.substringBefore('_');
        }
        return defaultValue;
    }

    public static ConnectOptions getDefaultConnectOptions() {
        ConnectOptions copts = new ConnectOptions();
        SObject settings = getSettingsInstance('ensxapp__EnosixFramework__c', new Set<String>{
            'ensxapp__SAP_Host__c'
            ,'ensxapp__SAP_Client__c'
            ,'ensxapp__Customizing_ID__c'
            ,'ensxapp__Timeout__c'
            ,'ensxapp__Compression_Enabled__c'
        });
        if (null != settings) {
            if (null != settings.get('ensxapp__SAP_Host__c')) {
                copts.Host = String.valueOf(settings.get('ensxapp__SAP_Host__c'));
            }
            if (null != settings.get('ensxapp__SAP_Client__c')) {
                copts.Client = String.valueOf(settings.get('ensxapp__SAP_Client__c'));
            }
            if (null != settings.get('ensxapp__Customizing_ID__c')) {
                copts.CID = String.valueOf(settings.get('ensxapp__Customizing_ID__c'));
            }
            if (null != settings.get('ensxapp__Timeout__c')) {
                copts.Timeout = Integer.valueOf(settings.get('ensxapp__Timeout__c'));
            }
            if (null != settings.get('ensxapp__Compression_Enabled__c')) {
                copts.CompressionEnabled = Boolean.valueOf(settings.get('ensxapp__Compression_Enabled__c'));
            }
        }
        return copts;
    }

    public static SObject getSettingsInstance(String settingsTypeName, Set<String> fields) {
        if (null == Type.forName(settingsTypeName)) {
            return null;
        }
        Id userId = UserInfo.getUserId();
        Id profileId = UserInfo.getProfileId();
        Id orgId = UserInfo.getOrganizationId();
        Map<SObjectType, SObject> settings = new Map<SobjectType, SObject>();
        fields.add('SetupOwnerId');
        for (SObject record : Database.query(
            'SELECT ' + String.escapeSingleQuotes(String.join(fields, ', ')) +
            ' FROM ' + String.escapeSingleQuotes(settingsTypeName) +
            ' WHERE SetupOwnerId IN (:userId, :profileId, :orgId) LIMIT 200',
            AccessLevel.SYSTEM_MODE)
        ) {
            settings.put(((Id)record.get('SetupOwnerId')).getSobjectType(), record);
        }
        SObject instance = (SObject)Type.forName(settingsTypeName).newInstance();
        if (settings.containsKey(Organization.SObjectType)) {
            applyPopulatedFields(instance, settings.get(Organization.SObjectType));
        }
        if (settings.containsKey(Profile.SObjectType)) {
            applyPopulatedFields(instance, settings.get(Profile.SObjectType));
        }
        if (settings.containsKey(User.SObjectType)) {
            applyPopulatedFields(instance, settings.get(User.SObjectType));
        }
        return instance;
    }

    private static void applyPopulatedFields(SObject target, SObject source) {
        Map<String,Object> src = source.getPopulatedFieldsAsMap();
        for(String key : src.keySet()) {
            Object value = src.get(key);
            if (null != value) {
                target.put(key, value);
            }
        }
    }

    private static HttpRequest sapConnectionCreateRequest(ConnectOptions options, Map<String, Object> parameters) {
        HttpRequest req = new HttpRequest();

        Map<String, object> urlParameters = new Map<String, object>();
        if (parameters != null) {
            urlParameters.putAll(parameters);
        }
        urlParameters.put('sap-sessioncmd', 'cancel');
        if (string.isNotBlank(options.Client)) { urlParameters.put('sap-client', options.Client); }
        if (string.isNotBlank(options.Language)) { urlParameters.put('sap-language', options.Language); }
        if (string.isNotBlank(options.CID)) { urlParameters.put('cid', options.CID); }

        List<String> urlKeyValuePairs = new List<String>();

        String encoding = 'UTF-8';

        for (String key : urlParameters.keySet()) {
            String value = String.valueOf(urlParameters.get(key));
            String entry = String.Format('{0}={1}',new String[]{
                 EncodingUtil.urlEncode(key, encoding ),
                 EncodingUtil.urlEncode(value, encoding)
                 });
            urlKeyValuePairs.add(entry);
        }

        String endpoint = String.Format('{0}?&{1}', new String[]{
            options.Host,
            String.join(urlKeyValuePairs, '&')
        });

        req.setEndpoint(endpoint);
        req.setMethod('POST');
        req.setTimeout(options.Timeout);
        req.setCompressed(options.CompressionEnabled);
        req.setHeader('Client', 'EnosixSFDCClient-1.12');
        req.setHeader('Content-Type','application/xml');

        return req;
    }

    private static void logRequest(HttpRequest request) {
        debugLog('ensxtx_DebugBridge.logRequest');
        Map<String, String> headersMap = new Map<String, String>{
            'Content-Type' => request.getHeader('Content-Type'),
            'Client' => request.getHeader('Client'),
            'Cookie' => request.getHeader('Cookie')
        };
        debugLog(
            'Request URL = ' + request.getEndpoint()
            + '\nRequest Headers = ' + JSON.serializePretty(headersMap, true)
            + '\nRequest Body = ' + request.getBody()
        );
    }

    private static void logResponse(HttpResponse response) {
        debugLog('ensxtx_DebugBridge.logResponse');
        List<String> headerKeys = response.getHeaderKeys();
        Map<String, String> headersMap = new Map<String, String>();
        for (String headerKey : headerKeys){
            headersMap.put(headerKey, response.getHeader(headerKey));
        }
        debugLog(
            'Status Code = ' + response.getStatusCode()
            + '\nStatus Message = ' + response.getStatus()
            + '\nResponse Headers = ' + JSON.serializePretty(headersMap)
            + '\nResponse Body = ' + response.getBody()
        );
    }

    private static void debugLog(Object message) {
        System.debug(System.LoggingLevel.ERROR, message);
    }
}