@isTest public class ensxtx_TSTU_EnsxAppHttpTrace {

    @isTest public static void test_invoke_null() {
        new ensxtx_UTIL_EnsxAppHttpTrace().invoke(null);
    }

    @isTest public static void test_invoke_non_log() {
        new ensxtx_UTIL_EnsxAppHttpTrace().invoke(new List<String>());
    }

    @isTest public static void test_invoke_log_non_http() {
        new ensxtx_UTIL_EnsxAppHttpTrace().invoke(new ensxapp__Log__c());
    }

    @isTest public static void test_invoke_log_http() {
        new ensxtx_UTIL_EnsxAppHttpTrace().invoke(new ensxapp__Log__c(ensxapp__LogLevel__c='HTTP_TRACE'));
    }
}