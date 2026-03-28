global with sharing class PROSCAMCPQWS {
    public with sharing class unlockQuoteRequest_element {
        public PROSCAMCPQWS.QuoteKeyType quoteKey;
        public String user_x;
        private String[] quoteKey_type_info = new String[]{'quoteKey','http://www.access-commerce.com/cameleonWS/cart/',null,'1','1','false'};
        private String[] user_x_type_info = new String[]{'user','http://www.access-commerce.com/cameleonWS/cart/',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.access-commerce.com/cameleonWS/cart/','false','false'};
        private String[] field_order_type_info = new String[]{'quoteKey','user_x'};
    }
    public with sharing class isQuoteLockedResponse_element {
        public Boolean isLocked;
        public String user_x;
        public String messageAction;
        public String statusAction;
        private String[] isLocked_type_info = new String[]{'isLocked','http://www.access-commerce.com/cameleonWS/cart/',null,'1','1','false'};
        private String[] user_x_type_info = new String[]{'user','http://www.access-commerce.com/cameleonWS/cart/',null,'1','1','true'};
        private String[] messageAction_type_info = new String[]{'messageAction','http://www.access-commerce.com/cameleonWS/cart/',null,'0','1','false'};
        private String[] statusAction_type_info = new String[]{'statusAction','http://www.access-commerce.com/cameleonWS/cart/',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.access-commerce.com/cameleonWS/cart/','false','false'};
        private String[] field_order_type_info = new String[]{'isLocked','user_x','messageAction','statusAction'};
    }
    public with sharing class unlockQuoteResponse_element {
        public Boolean unlockedOk;
        public String message;
        public String statusAction;
        private String[] unlockedOk_type_info = new String[]{'unlockedOk','http://www.access-commerce.com/cameleonWS/cart/',null,'1','1','false'};
        private String[] message_type_info = new String[]{'message','http://www.access-commerce.com/cameleonWS/cart/',null,'1','1','true'};
        private String[] statusAction_type_info = new String[]{'statusAction','http://www.access-commerce.com/cameleonWS/cart/',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.access-commerce.com/cameleonWS/cart/','false','false'};
        private String[] field_order_type_info = new String[]{'unlockedOk','message','statusAction'};
    }
    public with sharing class getQuoteResponse_element {
        public String xmlCart;
        public String messageAction;
        public String statusAction;
        private String[] xmlCart_type_info = new String[]{'xmlCart','http://www.access-commerce.com/cameleonWS/cart/',null,'1','1','false'};
        private String[] messageAction_type_info = new String[]{'messageAction','http://www.access-commerce.com/cameleonWS/cart/',null,'0','1','false'};
        private String[] statusAction_type_info = new String[]{'statusAction','http://www.access-commerce.com/cameleonWS/cart/',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.access-commerce.com/cameleonWS/cart/','false','false'};
        private String[] field_order_type_info = new String[]{'xmlCart','messageAction','statusAction'};
    }
    public with sharing class QueryCriterionType {
        public String alias;
        public String operator;
        public String value;
        private String[] alias_type_info = new String[]{'alias','http://www.access-commerce.com/cameleonWS/cart/',null,'1','1','false'};
        private String[] operator_type_info = new String[]{'operator','http://www.access-commerce.com/cameleonWS/cart/',null,'1','1','false'};
        private String[] value_type_info = new String[]{'value','http://www.access-commerce.com/cameleonWS/cart/',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.access-commerce.com/cameleonWS/cart/','false','false'};
        private String[] field_order_type_info = new String[]{'alias','operator','value'};
    }
    public with sharing class getQuoteListRequest_element {
        public String quoteModelPK;
        public PROSCAMCPQWS.QueryCriterionType[] searchCriteria;
        public PROSCAMCPQWS.CustomQueryCriterionType[] customSearchCriteria;
        private String[] quoteModelPK_type_info = new String[]{'quoteModelPK','http://www.access-commerce.com/cameleonWS/cart/',null,'1','1','true'};
        private String[] searchCriteria_type_info = new String[]{'searchCriteria','http://www.access-commerce.com/cameleonWS/cart/',null,'0','-1','true'};
        private String[] customSearchCriteria_type_info = new String[]{'customSearchCriteria','http://www.access-commerce.com/cameleonWS/cart/',null,'0','-1','true'};
        private String[] apex_schema_type_info = new String[]{'http://www.access-commerce.com/cameleonWS/cart/','false','false'};
        private String[] field_order_type_info = new String[]{'quoteModelPK','searchCriteria','customSearchCriteria'};
    }
    public with sharing class QueryResultSetType {
        public Integer count;
        public PROSCAMCPQWS.QueryRecordType[] records;
        private String[] count_type_info = new String[]{'count','http://www.access-commerce.com/cameleonWS/cart/',null,'1','1','false'};
        private String[] records_type_info = new String[]{'records','http://www.access-commerce.com/cameleonWS/cart/',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.access-commerce.com/cameleonWS/cart/','false','false'};
        private String[] field_order_type_info = new String[]{'count','records'};
    }
    public with sharing class QueryRecordType {
        public String[] fieldValues;
        private String[] fieldValues_type_info = new String[]{'fieldValues','http://www.access-commerce.com/cameleonWS/cart/',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.access-commerce.com/cameleonWS/cart/','false','false'};
        private String[] field_order_type_info = new String[]{'fieldValues'};
    }
    public with sharing class runUIRequest_element {
        public String xmlSession;
        public String xmlCart;
        public String exitURL;
        public String bindingId;
        public String bindingTargetPoint;
        public String clearMergedCSSFileOnStartup;
        private String[] xmlSession_type_info = new String[]{'xmlSession','http://www.access-commerce.com/cameleonWS/cart/',null,'1','1','false'};
        private String[] xmlCart_type_info = new String[]{'xmlCart','http://www.access-commerce.com/cameleonWS/cart/',null,'1','1','false'};
        private String[] exitURL_type_info = new String[]{'exitURL','http://www.access-commerce.com/cameleonWS/cart/',null,'0','1','true'};
        private String[] bindingId_type_info = new String[]{'bindingId','http://www.access-commerce.com/cameleonWS/cart/',null,'0','1','true'};
        private String[] bindingTargetPoint_type_info = new String[]{'bindingTargetPoint','http://www.access-commerce.com/cameleonWS/cart/',null,'0','1','true'};
        private String[] clearMergedCSSFileOnStartup_type_info = new String[]{'clearMergedCSSFileOnStartup','http://www.access-commerce.com/cameleonWS/cart/',null,'0','1','true'};
        private String[] apex_schema_type_info = new String[]{'http://www.access-commerce.com/cameleonWS/cart/','false','false'};
        private String[] field_order_type_info = new String[]{'xmlSession','xmlCart','exitURL','bindingId','bindingTargetPoint','clearMergedCSSFileOnStartup'};
    }
    public with sharing class getQuoteReleasesListRequest_element {
        public String xmlMetaModel;
        private String[] xmlMetaModel_type_info = new String[]{'xmlMetaModel','http://www.access-commerce.com/cameleonWS/cart/',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.access-commerce.com/cameleonWS/cart/','false','false'};
        private String[] field_order_type_info = new String[]{'xmlMetaModel'};
    }
    public with sharing class QuoteKeyType {
        public String domain;
        public String quoteId;
        public Integer release;
        private String[] domain_type_info = new String[]{'domain','http://www.access-commerce.com/cameleonWS/cart/',null,'1','1','false'};
        private String[] quoteId_type_info = new String[]{'quoteId','http://www.access-commerce.com/cameleonWS/cart/',null,'1','1','false'};
        private String[] release_type_info = new String[]{'release','http://www.access-commerce.com/cameleonWS/cart/',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.access-commerce.com/cameleonWS/cart/','false','false'};
        private String[] field_order_type_info = new String[]{'domain','quoteId','release'};
    }
    public with sharing class runUIResponse_element {
        public String url;
        public String messageAction;
        public String statusAction;
        private String[] url_type_info = new String[]{'url','http://www.access-commerce.com/cameleonWS/cart/',null,'1','1','false'};
        private String[] messageAction_type_info = new String[]{'messageAction','http://www.access-commerce.com/cameleonWS/cart/',null,'0','1','false'};
        private String[] statusAction_type_info = new String[]{'statusAction','http://www.access-commerce.com/cameleonWS/cart/',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.access-commerce.com/cameleonWS/cart/','false','false'};
        private String[] field_order_type_info = new String[]{'url','messageAction','statusAction'};
    }
    public with sharing class getQuoteListResponse_element {
        public PROSCAMCPQWS.QueryResultSetType results;
        public String statusAction;
        public String messageAction;
        private String[] results_type_info = new String[]{'results','http://www.access-commerce.com/cameleonWS/cart/',null,'1','1','false'};
        private String[] statusAction_type_info = new String[]{'statusAction','http://www.access-commerce.com/cameleonWS/cart/',null,'1','1','false'};
        private String[] messageAction_type_info = new String[]{'messageAction','http://www.access-commerce.com/cameleonWS/cart/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.access-commerce.com/cameleonWS/cart/','false','false'};
        private String[] field_order_type_info = new String[]{'results','statusAction','messageAction'};
    }
    public with sharing class isQuoteLockedRequest_element {
        public PROSCAMCPQWS.QuoteKeyType quoteKey;
        private String[] quoteKey_type_info = new String[]{'quoteKey','http://www.access-commerce.com/cameleonWS/cart/',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.access-commerce.com/cameleonWS/cart/','false','false'};
        private String[] field_order_type_info = new String[]{'quoteKey'};
    }
    public with sharing class CustomQueryCriterionType {
        public String alias;
        public String operator;
        public String value;
        private String[] alias_type_info = new String[]{'alias','http://www.access-commerce.com/cameleonWS/cart/',null,'1','1','false'};
        private String[] operator_type_info = new String[]{'operator','http://www.access-commerce.com/cameleonWS/cart/',null,'1','1','false'};
        private String[] value_type_info = new String[]{'value','http://www.access-commerce.com/cameleonWS/cart/',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.access-commerce.com/cameleonWS/cart/','false','false'};
        private String[] field_order_type_info = new String[]{'alias','operator','value'};
    }
    public with sharing class getQuoteReleasesListResponse_element {
        public String xmlReleasesList;
        public String messageAction;
        public String statusAction;
        private String[] xmlReleasesList_type_info = new String[]{'xmlReleasesList','http://www.access-commerce.com/cameleonWS/cart/',null,'1','1','false'};
        private String[] messageAction_type_info = new String[]{'messageAction','http://www.access-commerce.com/cameleonWS/cart/',null,'0','1','false'};
        private String[] statusAction_type_info = new String[]{'statusAction','http://www.access-commerce.com/cameleonWS/cart/',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.access-commerce.com/cameleonWS/cart/','false','false'};
        private String[] field_order_type_info = new String[]{'xmlReleasesList','messageAction','statusAction'};
    }
    public with sharing class getQuoteRequest_element {
        public PROSCAMCPQWS.QuoteKeyType quoteKey;
        public String[] filter;
        public String exportPolicy;
        private String[] quoteKey_type_info = new String[]{'quoteKey','http://www.access-commerce.com/cameleonWS/cart/',null,'1','1','false'};
        private String[] filter_type_info = new String[]{'filter','http://www.access-commerce.com/cameleonWS/cart/',null,'0','-1','true'};
        private String[] exportPolicy_type_info = new String[]{'exportPolicy','http://www.access-commerce.com/cameleonWS/cart/',null,'1','1','true'};
        private String[] apex_schema_type_info = new String[]{'http://www.access-commerce.com/cameleonWS/cart/','false','false'};
        private String[] field_order_type_info = new String[]{'quoteKey','filter','exportPolicy'};
    }
    public with sharing class cartSOAP {
        public CameleonCPQ__CAMCPQSettings__c CPQSettings = CameleonCPQ__CAMCPQSettings__c.getInstance();
        public String endpoint_x = (CPQSettings!=null)?(CPQSettings.CameleonCPQ__CPQServer_EndpointURL__c+'/cart/services/cart'):'http://localhost:8080/CameleonWS/services/CameleonWS/';
        public Map<String,String> inputHttpHeaders_x;
        public Map<String,String> outputHttpHeaders_x;
        public String clientCertName_x;
        public String clientCert_x;
        public String clientCertPasswd_x;
        public Integer timeout_x = 120000;
        private String[] ns_map_type_info = new String[]{'http://www.access-commerce.com/cameleonWS/cart/', 'PROSCAMCPQWS'};
        
        public cartSOAP() {
            inputHttpHeaders_x = new Map<String, String>();
            Blob headerValue = Blob.valueOf(UserInfo.getOrganizationId().substring(0,15)+':'+ (CPQSettings.CameleonCPQ__CPQSession_AuthPwd__c!=null ? CPQSettings.CameleonCPQ__CPQSession_AuthPwd__c : ''));
            String authorizationHeader = 'BASIC '+EncodingUtil.base64Encode(headerValue);
            inputHttpHeaders_x.put('Authorization', authorizationHeader);
        }

        public PROSCAMCPQWS.unlockQuoteResponse_element unlockQuote(PROSCAMCPQWS.QuoteKeyType quoteKey,String user_x) {
            PROSCAMCPQWS.unlockQuoteRequest_element request_x = new PROSCAMCPQWS.unlockQuoteRequest_element();
            request_x.quoteKey = quoteKey;
            request_x.user_x = user_x;
            PROSCAMCPQWS.unlockQuoteResponse_element response_x;
            Map<String, PROSCAMCPQWS.unlockQuoteResponse_element> response_map_x = new Map<String, PROSCAMCPQWS.unlockQuoteResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'http://www.access-commerce.com/cameleonWS/cart/unlockQuote',
              'http://www.access-commerce.com/cameleonWS/cart/',
              'unlockQuoteRequest',
              'http://www.access-commerce.com/cameleonWS/cart/',
              'unlockQuoteResponse',
              'PROSCAMCPQWS.unlockQuoteResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x;
        }
        public PROSCAMCPQWS.getQuoteReleasesListResponse_element getQuoteReleasesList(String xmlMetaModel) {
            PROSCAMCPQWS.getQuoteReleasesListRequest_element request_x = new PROSCAMCPQWS.getQuoteReleasesListRequest_element();
            request_x.xmlMetaModel = xmlMetaModel;
            PROSCAMCPQWS.getQuoteReleasesListResponse_element response_x;
            Map<String, PROSCAMCPQWS.getQuoteReleasesListResponse_element> response_map_x = new Map<String, PROSCAMCPQWS.getQuoteReleasesListResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'http://www.access-commerce.com/cameleonWS/cart/getQuoteReleasesList',
              'http://www.access-commerce.com/cameleonWS/cart/',
              'getQuoteReleasesListRequest',
              'http://www.access-commerce.com/cameleonWS/cart/',
              'getQuoteReleasesListResponse',
              'PROSCAMCPQWS.getQuoteReleasesListResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x;
        }
        public PROSCAMCPQWS.getQuoteListResponse_element getQuoteList(String quoteModelPK,PROSCAMCPQWS.QueryCriterionType[] searchCriteria,PROSCAMCPQWS.CustomQueryCriterionType[] customSearchCriteria) {
            PROSCAMCPQWS.getQuoteListRequest_element request_x = new PROSCAMCPQWS.getQuoteListRequest_element();
            request_x.quoteModelPK = quoteModelPK;
            request_x.searchCriteria = searchCriteria;
            request_x.customSearchCriteria = customSearchCriteria;
            PROSCAMCPQWS.getQuoteListResponse_element response_x;
            Map<String, PROSCAMCPQWS.getQuoteListResponse_element> response_map_x = new Map<String, PROSCAMCPQWS.getQuoteListResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'http://www.access-commerce.com/cameleonWS/cart/getQuoteList',
              'http://www.access-commerce.com/cameleonWS/cart/',
              'getQuoteListRequest',
              'http://www.access-commerce.com/cameleonWS/cart/',
              'getQuoteListResponse',
              'PROSCAMCPQWS.getQuoteListResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x;
        }
        public PROSCAMCPQWS.runUIResponse_element runUI(String xmlSession,String xmlCart,String exitURL,String bindingId,String bindingTargetPoint,String clearMergedCSSFileOnStartup) {
            PROSCAMCPQWS.runUIRequest_element request_x = new PROSCAMCPQWS.runUIRequest_element();
            request_x.xmlSession = xmlSession;
            request_x.xmlCart = xmlCart;
            request_x.exitURL = exitURL;
            request_x.bindingId = bindingId;
            request_x.bindingTargetPoint = bindingTargetPoint;
            request_x.clearMergedCSSFileOnStartup = clearMergedCSSFileOnStartup;
            PROSCAMCPQWS.runUIResponse_element response_x;
            Map<String, PROSCAMCPQWS.runUIResponse_element> response_map_x = new Map<String, PROSCAMCPQWS.runUIResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'http://www.access-commerce.com/cameleonWS/cart/runUI',
              'http://www.access-commerce.com/cameleonWS/cart/',
              'runUIRequest',
              'http://www.access-commerce.com/cameleonWS/cart/',
              'runUIResponse',
              'PROSCAMCPQWS.runUIResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x;
        }
        public PROSCAMCPQWS.isQuoteLockedResponse_element isQuoteLocked(PROSCAMCPQWS.QuoteKeyType quoteKey) {
            PROSCAMCPQWS.isQuoteLockedRequest_element request_x = new PROSCAMCPQWS.isQuoteLockedRequest_element();
            request_x.quoteKey = quoteKey;
            PROSCAMCPQWS.isQuoteLockedResponse_element response_x;
            Map<String, PROSCAMCPQWS.isQuoteLockedResponse_element> response_map_x = new Map<String, PROSCAMCPQWS.isQuoteLockedResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'http://www.access-commerce.com/cameleonWS/cart/isQuoteLocked',
              'http://www.access-commerce.com/cameleonWS/cart/',
              'isQuoteLockedRequest',
              'http://www.access-commerce.com/cameleonWS/cart/',
              'isQuoteLockedResponse',
              'PROSCAMCPQWS.isQuoteLockedResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x;
        }
        public PROSCAMCPQWS.getQuoteResponse_element getQuote(PROSCAMCPQWS.QuoteKeyType quoteKey,String[] filter,String exportPolicy) {
            PROSCAMCPQWS.getQuoteRequest_element request_x = new PROSCAMCPQWS.getQuoteRequest_element();
            request_x.quoteKey = quoteKey;
            request_x.filter = filter;
            request_x.exportPolicy = exportPolicy;
            PROSCAMCPQWS.getQuoteResponse_element response_x;
            Map<String, PROSCAMCPQWS.getQuoteResponse_element> response_map_x = new Map<String, PROSCAMCPQWS.getQuoteResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'http://www.access-commerce.com/cameleonWS/cart/getQuote',
              'http://www.access-commerce.com/cameleonWS/cart/',
              'getQuoteRequest',
              'http://www.access-commerce.com/cameleonWS/cart/',
              'getQuoteResponse',
              'PROSCAMCPQWS.getQuoteResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x;
        }
    }
}