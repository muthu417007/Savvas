public class implOppMashupSoapSforceCom {
    public class getUserInfo_element {
        private String[] apex_schema_type_info = new String[]{'urn:enterprise.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{};
    }
    public class LoginResult {
        public String metadataServerUrl;
        public Boolean passwordExpired;
        public Boolean sandbox;
        public String serverUrl;
        public String sessionId;
        public String userId;
        public implOppMashupSoapSforceCom.GetUserInfoResult userInfo;
        private String[] metadataServerUrl_type_info = new String[]{'metadataServerUrl','http://www.w3.org/2001/XMLSchema','string','1','1','true'};
        private String[] passwordExpired_type_info = new String[]{'passwordExpired','http://www.w3.org/2001/XMLSchema','boolean','1','1','false'};
        private String[] sandbox_type_info = new String[]{'sandbox','http://www.w3.org/2001/XMLSchema','boolean','1','1','false'};
        private String[] serverUrl_type_info = new String[]{'serverUrl','http://www.w3.org/2001/XMLSchema','string','1','1','true'};
        private String[] sessionId_type_info = new String[]{'sessionId','http://www.w3.org/2001/XMLSchema','string','1','1','true'};
        private String[] userId_type_info = new String[]{'userId','urn:enterprise.soap.sforce.com','ID','1','1','true'};
        private String[] userInfo_type_info = new String[]{'userInfo','urn:enterprise.soap.sforce.com','GetUserInfoResult','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:enterprise.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'metadataServerUrl','passwordExpired','sandbox','serverUrl','sessionId','userId','userInfo'};
    }
    public class queryResponse_element {
        public implOppMashupSoapSforceCom.QueryResult result;
        private String[] result_type_info = new String[]{'result','urn:enterprise.soap.sforce.com','QueryResult','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:enterprise.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public class loginResponse_element {
        public implOppMashupSoapSforceCom.LoginResult result;
        private String[] result_type_info = new String[]{'result','urn:enterprise.soap.sforce.com','LoginResult','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:enterprise.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public class GetUserInfoResult {
        public Boolean accessibilityMode;
        public String currencySymbol;
        public Integer orgAttachmentFileSizeLimit;
        public String orgDefaultCurrencyIsoCode;
        public Boolean orgDisallowHtmlAttachments;
        public Boolean orgHasPersonAccounts;
        public String organizationId;
        public Boolean organizationMultiCurrency;
        public String organizationName;
        public String profileId;
        public String roleId;
        public Integer sessionSecondsValid;
        public String userDefaultCurrencyIsoCode;
        public String userEmail;
        public String userFullName;
        public String userId;
        public String userLanguage;
        public String userLocale;
        public String userName;
        public String userTimeZone;
        public String userType;
        public String userUiSkin;
        private String[] accessibilityMode_type_info = new String[]{'accessibilityMode','http://www.w3.org/2001/XMLSchema','boolean','1','1','false'};
        private String[] currencySymbol_type_info = new String[]{'currencySymbol','http://www.w3.org/2001/XMLSchema','string','1','1','true'};
        private String[] orgAttachmentFileSizeLimit_type_info = new String[]{'orgAttachmentFileSizeLimit','http://www.w3.org/2001/XMLSchema','int','1','1','false'};
        private String[] orgDefaultCurrencyIsoCode_type_info = new String[]{'orgDefaultCurrencyIsoCode','http://www.w3.org/2001/XMLSchema','string','1','1','true'};
        private String[] orgDisallowHtmlAttachments_type_info = new String[]{'orgDisallowHtmlAttachments','http://www.w3.org/2001/XMLSchema','boolean','1','1','false'};
        private String[] orgHasPersonAccounts_type_info = new String[]{'orgHasPersonAccounts','http://www.w3.org/2001/XMLSchema','boolean','1','1','false'};
        private String[] organizationId_type_info = new String[]{'organizationId','urn:enterprise.soap.sforce.com','ID','1','1','false'};
        private String[] organizationMultiCurrency_type_info = new String[]{'organizationMultiCurrency','http://www.w3.org/2001/XMLSchema','boolean','1','1','false'};
        private String[] organizationName_type_info = new String[]{'organizationName','http://www.w3.org/2001/XMLSchema','string','1','1','false'};
        private String[] profileId_type_info = new String[]{'profileId','urn:enterprise.soap.sforce.com','ID','1','1','false'};
        private String[] roleId_type_info = new String[]{'roleId','urn:enterprise.soap.sforce.com','ID','1','1','true'};
        private String[] sessionSecondsValid_type_info = new String[]{'sessionSecondsValid','http://www.w3.org/2001/XMLSchema','int','1','1','false'};
        private String[] userDefaultCurrencyIsoCode_type_info = new String[]{'userDefaultCurrencyIsoCode','http://www.w3.org/2001/XMLSchema','string','1','1','true'};
        private String[] userEmail_type_info = new String[]{'userEmail','http://www.w3.org/2001/XMLSchema','string','1','1','false'};
        private String[] userFullName_type_info = new String[]{'userFullName','http://www.w3.org/2001/XMLSchema','string','1','1','false'};
        private String[] userId_type_info = new String[]{'userId','urn:enterprise.soap.sforce.com','ID','1','1','false'};
        private String[] userLanguage_type_info = new String[]{'userLanguage','http://www.w3.org/2001/XMLSchema','string','1','1','false'};
        private String[] userLocale_type_info = new String[]{'userLocale','http://www.w3.org/2001/XMLSchema','string','1','1','false'};
        private String[] userName_type_info = new String[]{'userName','http://www.w3.org/2001/XMLSchema','string','1','1','false'};
        private String[] userTimeZone_type_info = new String[]{'userTimeZone','http://www.w3.org/2001/XMLSchema','string','1','1','false'};
        private String[] userType_type_info = new String[]{'userType','http://www.w3.org/2001/XMLSchema','string','1','1','false'};
        private String[] userUiSkin_type_info = new String[]{'userUiSkin','http://www.w3.org/2001/XMLSchema','string','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:enterprise.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'accessibilityMode','currencySymbol','orgAttachmentFileSizeLimit','orgDefaultCurrencyIsoCode','orgDisallowHtmlAttachments','orgHasPersonAccounts','organizationId','organizationMultiCurrency','organizationName','profileId','roleId','sessionSecondsValid','userDefaultCurrencyIsoCode','userEmail','userFullName','userId','userLanguage','userLocale','userName','userTimeZone','userType','userUiSkin'};
    } 
    public class QueryResult {
        public Boolean done;
        public String queryLocator;
        public implOppSobjectMashupSoapSforceCom.sObject_x[] records;
        public Integer size;
        private String[] done_type_info = new String[]{'done','http://www.w3.org/2001/XMLSchema','boolean','1','1','false'};
        private String[] queryLocator_type_info = new String[]{'queryLocator','urn:enterprise.soap.sforce.com','QueryLocator','1','1','true'};
        private String[] records_type_info = new String[]{'records','urn:sobject.enterprise.soap.sforce.com','sObject','0','-1','true'};
        private String[] size_type_info = new String[]{'size','http://www.w3.org/2001/XMLSchema','int','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:enterprise.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'done','queryLocator','records','size'};
    }
    public class QueryOptions_element {
        public Integer batchSize;
        private String[] batchSize_type_info = new String[]{'batchSize','http://www.w3.org/2001/XMLSchema','int','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:enterprise.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'batchSize'};
    }
    public class MruHeader_element {
        public Boolean updateMru;
        private String[] updateMru_type_info = new String[]{'updateMru','http://www.w3.org/2001/XMLSchema','boolean','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:enterprise.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'updateMru'};
    }
    public class Soap {
        public String endpoint_x = 'https://login.salesforce.com/services/Soap/c/26.0/0DF000000008PxO';
        public Map<String,String> inputHttpHeaders_x;
        public Map<String,String> outputHttpHeaders_x;
        public String clientCertName_x;
        public String clientCert_x;
        public String clientCertPasswd_x;
        public Integer timeout_x;
        public implOppMashupSoapSforceCom.QueryOptions_element QueryOptions;
        public implOppMashupSoapSforceCom.EmailHeader_element EmailHeader;
        public implOppMashupSoapSforceCom.DebuggingInfo_element DebuggingInfo;
        public implOppMashupSoapSforceCom.MruHeader_element MruHeader;
        public implOppMashupSoapSforceCom.PackageVersionHeader_element PackageVersionHeader;
        public implOppMashupSoapSforceCom.SessionHeader_element SessionHeader;
        public implOppMashupSoapSforceCom.LoginScopeHeader_element LoginScopeHeader;
        public implOppMashupSoapSforceCom.UserTerritoryDeleteHeader_element UserTerritoryDeleteHeader;
        public implOppMashupSoapSforceCom.AllowFieldTruncationHeader_element AllowFieldTruncationHeader;
        public implOppMashupSoapSforceCom.DebuggingHeader_element DebuggingHeader;
        public implOppMashupSoapSforceCom.AllOrNoneHeader_element AllOrNoneHeader;
        public implOppMashupSoapSforceCom.LocaleOptions_element LocaleOptions;
        public implOppMashupSoapSforceCom.AssignmentRuleHeader_element AssignmentRuleHeader;
        public implOppMashupSoapSforceCom.DisableFeedTrackingHeader_element DisableFeedTrackingHeader;
        public implOppMashupSoapSforceCom.StreamingEnabledHeader_element StreamingEnabledHeader;
        private String QueryOptions_hns = 'QueryOptions=urn:enterprise.soap.sforce.com';
        private String EmailHeader_hns = 'EmailHeader=urn:enterprise.soap.sforce.com';
        private String DebuggingInfo_hns = 'DebuggingInfo=urn:enterprise.soap.sforce.com';
        private String MruHeader_hns = 'MruHeader=urn:enterprise.soap.sforce.com';
        private String PackageVersionHeader_hns = 'PackageVersionHeader=urn:enterprise.soap.sforce.com';
        private String SessionHeader_hns = 'SessionHeader=urn:enterprise.soap.sforce.com';
        private String LoginScopeHeader_hns = 'LoginScopeHeader=urn:enterprise.soap.sforce.com';
        private String UserTerritoryDeleteHeader_hns = 'UserTerritoryDeleteHeader=urn:enterprise.soap.sforce.com';
        private String AllowFieldTruncationHeader_hns = 'AllowFieldTruncationHeader=urn:enterprise.soap.sforce.com';
        private String DebuggingHeader_hns = 'DebuggingHeader=urn:enterprise.soap.sforce.com';
        private String AllOrNoneHeader_hns = 'AllOrNoneHeader=urn:enterprise.soap.sforce.com';
        private String LocaleOptions_hns = 'LocaleOptions=urn:enterprise.soap.sforce.com';
        private String AssignmentRuleHeader_hns = 'AssignmentRuleHeader=urn:enterprise.soap.sforce.com';
        private String DisableFeedTrackingHeader_hns = 'DisableFeedTrackingHeader=urn:enterprise.soap.sforce.com';
        private String StreamingEnabledHeader_hns = 'StreamingEnabledHeader=urn:enterprise.soap.sforce.com';
        private String[] ns_map_type_info = new String[]{'urn:fault.enterprise.soap.sforce.com', 'faultEnterpriseSoapSforceCom', 'urn:enterprise.soap.sforce.com', 'implOppMashupSoapSforceCom', 'urn:sobject.enterprise.soap.sforce.com', 'implOppSobjectMashupSoapSforceCom'};
        public implOppMashupSoapSforceCom.LoginResult login(String username,String password) {
            implOppMashupSoapSforceCom.login_element request_x = new implOppMashupSoapSforceCom.login_element();
            implOppMashupSoapSforceCom.loginResponse_element response_x;
            request_x.username = username;
            request_x.password = password;
            Map<String, implOppMashupSoapSforceCom.loginResponse_element> response_map_x = new Map<String, implOppMashupSoapSforceCom.loginResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'urn:enterprise.soap.sforce.com',
              'login',
              'urn:enterprise.soap.sforce.com',
              'loginResponse',
              'implOppMashupSoapSforceCom.loginResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.result;
        }
        public implOppMashupSoapSforceCom.QueryResult query(String queryString) {
            implOppMashupSoapSforceCom.query_element request_x = new implOppMashupSoapSforceCom.query_element();
            implOppMashupSoapSforceCom.queryResponse_element response_x;
            request_x.queryString = queryString;
            Map<String, implOppMashupSoapSforceCom.queryResponse_element> response_map_x = new Map<String, implOppMashupSoapSforceCom.queryResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'urn:enterprise.soap.sforce.com',
              'query',
              'urn:enterprise.soap.sforce.com',
              'queryResponse',
              'implOppMashupSoapSforceCom.queryResponse_element'}
            );
            system.debug(response_map_x);
            response_x = response_map_x.get('response_x');
            system.debug(response_x);
            return response_x.result;
        }
    }
    public class SessionHeader_element {
        public String sessionId;
        private String[] sessionId_type_info = new String[]{'sessionId','http://www.w3.org/2001/XMLSchema','string','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:enterprise.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'sessionId'};
    }
    public class AllOrNoneHeader_element {
        public Boolean allOrNone;
        private String[] allOrNone_type_info = new String[]{'allOrNone','http://www.w3.org/2001/XMLSchema','boolean','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:enterprise.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'allOrNone'};
    }
    public class AllowFieldTruncationHeader_element {
        public Boolean allowFieldTruncation;
        private String[] allowFieldTruncation_type_info = new String[]{'allowFieldTruncation','http://www.w3.org/2001/XMLSchema','boolean','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:enterprise.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'allowFieldTruncation'};
    }
    public class DisableFeedTrackingHeader_element {
        public Boolean disableFeedTracking;
        private String[] disableFeedTracking_type_info = new String[]{'disableFeedTracking','http://www.w3.org/2001/XMLSchema','boolean','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:enterprise.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'disableFeedTracking'};
    }
    public class LoginScopeHeader_element {
        public String organizationId;
        public String portalId;
        private String[] organizationId_type_info = new String[]{'organizationId','urn:enterprise.soap.sforce.com','ID','1','1','false'};
        private String[] portalId_type_info = new String[]{'portalId','urn:enterprise.soap.sforce.com','ID','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:enterprise.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'organizationId','portalId'};
    }
    public class LocaleOptions_element {
        public String language;
        private String[] language_type_info = new String[]{'language','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:enterprise.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'language'};
    }
    public class StreamingEnabledHeader_element {
        public Boolean streamingEnabled;
        private String[] streamingEnabled_type_info = new String[]{'streamingEnabled','http://www.w3.org/2001/XMLSchema','boolean','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:enterprise.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'streamingEnabled'};
    }
    public class query_element {
        public String queryString;
        private String[] queryString_type_info = new String[]{'queryString','http://www.w3.org/2001/XMLSchema','string','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:enterprise.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'queryString'};
    }
    public class PackageVersion {
        public Integer majorNumber;
        public Integer minorNumber;
        public String namespace;
        private String[] majorNumber_type_info = new String[]{'majorNumber','http://www.w3.org/2001/XMLSchema','int','1','1','false'};
        private String[] minorNumber_type_info = new String[]{'minorNumber','http://www.w3.org/2001/XMLSchema','int','1','1','false'};
        private String[] namespace_type_info = new String[]{'namespace','http://www.w3.org/2001/XMLSchema','string','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:enterprise.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'majorNumber','minorNumber','namespace'};
    }
    public class AssignmentRuleHeader_element {
        public String assignmentRuleId;
        public Boolean useDefaultRule;
        private String[] assignmentRuleId_type_info = new String[]{'assignmentRuleId','urn:enterprise.soap.sforce.com','ID','1','1','true'};
        private String[] useDefaultRule_type_info = new String[]{'useDefaultRule','http://www.w3.org/2001/XMLSchema','boolean','1','1','true'};
        private String[] apex_schema_type_info = new String[]{'urn:enterprise.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'assignmentRuleId','useDefaultRule'};
    }
    public class PackageVersionHeader_element {
        public implOppMashupSoapSforceCom.PackageVersion[] packageVersions;
        private String[] packageVersions_type_info = new String[]{'packageVersions','urn:enterprise.soap.sforce.com','PackageVersion','0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:enterprise.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'packageVersions'};
    }
    public class login_element {
        public String username;
        public String password;
        private String[] username_type_info = new String[]{'username','http://www.w3.org/2001/XMLSchema','string','1','1','false'};
        private String[] password_type_info = new String[]{'password','http://www.w3.org/2001/XMLSchema','string','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:enterprise.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'username','password'};
    }
    public class UserTerritoryDeleteHeader_element {
        public String transferToUserId;
        private String[] transferToUserId_type_info = new String[]{'transferToUserId','urn:enterprise.soap.sforce.com','ID','1','1','true'};
        private String[] apex_schema_type_info = new String[]{'urn:enterprise.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'transferToUserId'};
    }
    public class DebuggingInfo_element {
        public String debugLog;
        private String[] debugLog_type_info = new String[]{'debugLog','http://www.w3.org/2001/XMLSchema','string','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:enterprise.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'debugLog'};
    }
    public class EmailHeader_element {
        public Boolean triggerAutoResponseEmail;
        public Boolean triggerOtherEmail;
        public Boolean triggerUserEmail;
        private String[] triggerAutoResponseEmail_type_info = new String[]{'triggerAutoResponseEmail','http://www.w3.org/2001/XMLSchema','boolean','1','1','false'};
        private String[] triggerOtherEmail_type_info = new String[]{'triggerOtherEmail','http://www.w3.org/2001/XMLSchema','boolean','1','1','false'};
        private String[] triggerUserEmail_type_info = new String[]{'triggerUserEmail','http://www.w3.org/2001/XMLSchema','boolean','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:enterprise.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'triggerAutoResponseEmail','triggerOtherEmail','triggerUserEmail'};
    }
    public class DebuggingHeader_element {
        public String debugLevel;
        private String[] debugLevel_type_info = new String[]{'debugLevel','urn:enterprise.soap.sforce.com','DebugLevel','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:enterprise.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'debugLevel'};
    }
}