@isTest
public class ensxtx_TSTU_EnsxAppLogSink {

    @isTest
    public static void test_invoke() {
        new ensxtx_UTIL_EnsxAppLogSink().invoke(null);
        ensxapp__Log__c log = new ensxapp__Log__c();
        log.ensxapp__LogLevel__c = 'HTTP_TRACE';
        new ensxtx_UTIL_EnsxAppLogSink().invoke(log);
    }

    @isTest
    public static void test_callable() {
        insert new ensxapp__LogSetting__c(
            ensxapp__LoggingLevel__c = 1,
            ensxapp__HTTP_Trace__c = true
        );
        // all fields
        new ensxtx_UTIL_EnsxAppLogSink().call(
            'httpRequest',
            new Map<String, Object> {
                'url' => null,
                'reqHeaders' => null,
                'reqBody' => null,
                'resHeaders' => null,
                'resBody' => null,
                'page' => null,
                'start' => null,
                'end' => null,
                'sbo' => null,
                'statusCode' => null,
                'statusMessage' => null,
                'context' => null
            }
        );
        // catch exception
        new ensxtx_UTIL_EnsxAppLogSink().call(
            null,
            new Map<String, Object> {
                'statusCode' => 'not an integer'
            }
        );
    }
}