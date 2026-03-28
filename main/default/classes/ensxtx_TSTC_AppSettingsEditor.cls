@isTest
private class ensxtx_TSTC_AppSettingsEditor
{
    public class AppSettingHttpMock implements HttpCalloutMock
    {
        public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"example":"test"}');
            res.setStatusCode(200);
            return res;
        }
    }

    public class AppSettingWebServiceMock implements WebServiceMock
    {
        public Boolean success = true;

        public void setSuccess(Boolean successfull)
        {
            this.success = successfull;
        }

        public void doInvoke(
           Object stub,
           Object request,
           Map<String, Object> response,
           String endpoint,
           String soapAction,
           String requestName,
           String responseNS,
           String responseName,
           String responseType)
        {
            List<ensxtx_UTIL_MetadataService.UpsertResult> results = new List<ensxtx_UTIL_MetadataService.UpsertResult>();
            ensxtx_UTIL_MetadataService.UpsertResult result = new ensxtx_UTIL_MetadataService.UpsertResult();
            result.success = this.success;
            if (!this.success) {
                List<ensxtx_UTIL_MetadataService.Error> errors = new List<ensxtx_UTIL_MetadataService.Error>();
                ensxtx_UTIL_MetadataService.Error error = new ensxtx_UTIL_MetadataService.Error();
                error.message = 'Error Message';
                error.statusCode = '500';
                errors.add(error);
                result.errors = errors;
            }
            results.add(result);
            ensxtx_UTIL_MetadataService.upsertMetadataResponse_element resElement =
                new ensxtx_UTIL_MetadataService.upsertMetadataResponse_element();
            resElement.result = results;
            response.put('response_x', resElement);
        }
    }

    @isTest
    public static void test_getAppSettings() {
        ensxtx_CTRL_AppSettingsEditor.getAppSettings();
    }

    @isTest
    public static void test_saveAppSetting() {
        ensxtx_UTIL_Aura.Response response = ensxtx_CTRL_AppSettingsEditor.saveAppSetting('TEST', 'Test');
        Map<String, Object> responseData = (Map<String, Object>) response.data;
        System.assert(responseData.get('isSuccess') == false);

        Test.setMock(HttpCalloutMock.class, new AppSettingHttpMock());
        AppSettingWebServiceMock webServiceMock = new AppSettingWebServiceMock();
        Test.setMock(WebServiceMock.class, webServiceMock);

        response = ensxtx_CTRL_AppSettingsEditor.saveAppSetting('TEST', 'Test');
        responseData = (Map<String, Object>) response.data;
        System.assert(responseData.get('isSuccess') == true, 'expected response.data to be true but was ' + response);

        webServiceMock.setSuccess(false);
        response = ensxtx_CTRL_AppSettingsEditor.saveAppSetting('TEST', 'Test');
        responseData = (Map<String, Object>) response.data;
        System.assert(responseData.get('isSuccess') == false);
    }

    @IsTest
    public static void test_getSessionIdFromVFPageReturnsValue() {
        // act
        String sessionId = ensxtx_CTRL_AppSettingsEditor.getSessionIdFromVFPage();

        // assert
        System.assert(sessionId == 'testsessionid', 'Session ID should not be "testsessionid"');
    }

    @IsTest
    public static void test_getClassApiVersionReturnsClassVersion() {
        // act
        String classVersion = ensxtx_CTRL_AppSettingsEditor.getClassApiVersion();

        // assert
        System.assert(classVersion != null, 'Class version should not be null');
    }

    @isTest
    public static void test_additionalMetadataService() {
        ensxtx_UTIL_MetadataService.ExtendedErrorDetails extendedErrorDetails = new ensxtx_UTIL_MetadataService.ExtendedErrorDetails();
        ensxtx_UTIL_MetadataService.DebuggingInfo_element debuggingInfo = new ensxtx_UTIL_MetadataService.DebuggingInfo_element();
        ensxtx_UTIL_MetadataService.LogInfo logInfo = new ensxtx_UTIL_MetadataService.LogInfo();
        ensxtx_UTIL_MetadataService.DebuggingHeader_element debuggingHeader = new ensxtx_UTIL_MetadataService.DebuggingHeader_element();
        ensxtx_UTIL_MetadataService.CallOptions_element callOptions = new ensxtx_UTIL_MetadataService.CallOptions_element();
        ensxtx_UTIL_MetadataService.AllOrNoneHeader_element allOrNoneHeader = new ensxtx_UTIL_MetadataService.AllOrNoneHeader_element();
    }
}