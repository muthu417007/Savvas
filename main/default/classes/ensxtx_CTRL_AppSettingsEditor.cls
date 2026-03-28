public with sharing class ensxtx_CTRL_AppSettingsEditor
{
    private static final ensxsdk.Logger logger = new ensxsdk.Logger(ensxtx_CTRL_AppSettingsEditor.class);
    
    @TestVisible
    static String getSessionIdFromVFPage(){
        String content;
        if (Test.isRunningTest()) {
            content = 'Start_Of_Session_IdtestsessionidEnd_Of_Session_Id';
        }
        else {
            content = Page.ensxtx_GetSessionId.getContent().toString();
        }

        Integer s = content.indexOf('Start_Of_Session_Id') + 'Start_Of_Session_Id'.length(),
                e = content.indexOf('End_Of_Session_Id');
        return content.substring(s, e);
    }

    @TestVisible
    static String getClassApiVersion() {
        string className = ensxtx_CTRL_AppSettingsEditor.class.getName();
        ApexClass classObj = [SELECT ApiVersion FROM ApexClass WHERE Name = :className];
		return String.valueOf(classObj.ApiVersion);
    }

    @AuraEnabled
    public static ensxtx_UTIL_Aura.Response getAppSettings()
    {
        logger.enterAura('getAppSettings', null);

        List<Map<String, Object>> results = new List<Map<String, Object>>();

        try {
            String settingsNameLike = ensxtx_UTIL_AppSettings.Prefix + '%' + ensxtx_UTIL_AppSettings.Suffix;
            List<StaticResource> resources = [
                SELECT Body, Name FROM StaticResource
                WHERE Name LIKE :settingsNameLike
            ];

            Set<String> schemaNames = new Set<String>();

            for (StaticResource resource : resources) {
                Map<String, Object> body = (Map<String, Object>) JSON.deserializeUntyped(resource.Body.toString());
                Map<String, Object> record = new Map<String, Object>();
                record.put('Label', resource.Name.removeStart(ensxtx_UTIL_AppSettings.Prefix).removeEnd(ensxtx_UTIL_AppSettings.Suffix));
                record.put('Name', resource.Name);
                record.put('Body', body);

                string schemaName = getFileName(String.valueOf(body.get('$schema')));
                System.debug('Schema Name: ' + schemaName + ' derived from ' + String.valueOf(body.get('$schema')));

                schemaNames.add(schemaName);

                results.add(record);
            }

            List<StaticResource> schemas = [
                SELECT Body, Name FROM StaticResource
                WHERE Name IN :schemaNames
            ];

            System.debug('Found ' + schemas.size() + ' schemas to match...');

            for (Map<String, Object> result: results) {
                Map<String, Object> body = (Map<String, Object>) result.get('Body');
                String search = getFileName(String.valueOf(body.get('$schema')));

                for (StaticResource schema : schemas) {
                    System.debug('Does ' + schema.Name + ' match ' + search + '?');
                    if (schema.Name == search) {
                        Object schemaBody = (Map<String, Object>) JSON.deserializeUntyped(schema.Body.toString());
                        result.put('Schema', schemaBody);
                    }
                }
            }
        }
        catch (Exception ex) { ensxtx_UTIL_PageMessages.addExceptionMessage(ex); }

        return ensxtx_UTIL_Aura.createResponse(results);
    }

    private static string getFileName(string path)
    {
        if (path == null) return '';
        List<String> pathParts = path.split('/');
        String filename = pathParts[pathParts.size() - 1];
        System.debug('Spliting filename, ' + filename + ' on .');

        return filename.replace('.json', '');
    }

	@AuraEnabled
    public static ensxtx_UTIL_Aura.Response saveAppSetting(string appSettingNameOrLabel, string content)
    {
        logger.enterAura('saveAppSetting', new Map<String, Object>{
            'appSettingNameOrLabel' => appSettingNameOrLabel,
            'content' => content
        });

        String appSettingName = appSettingNameOrLabel;
        if (!appSettingName.startsWith(ensxtx_UTIL_AppSettings.Prefix)) {
            appSettingName = ensxtx_UTIL_AppSettings.Prefix + appSettingName;
        }
        if (!appSettingName.endsWith(ensxtx_UTIL_AppSettings.Suffix)) {
            appSettingName += ensxtx_UTIL_AppSettings.Suffix;
        }

        Boolean isSuccess = true;

        try {
            String sessionId = getSessionIdFromVFPage();

            // Http http = new Http();
            // HttpRequest req = new HttpRequest();
            // req.setEndpoint(URL.getOrgDomainURL().toExternalForm()+'/services/data/v39.0/query/?q=SELECT+Id+FROM+Account+limit+1');
            // req.setHeader('Authorization', 'Bearer ' + sessionId);
            // req.setMethod('GET');
            // HttpResponse res = http.send(req);

            ensxtx_UTIL_MetadataService.MetadataPort service = new ensxtx_UTIL_MetadataService.MetadataPort();
            service.SessionHeader = new ensxtx_UTIL_MetadataService.SessionHeader_element();
            service.SessionHeader.sessionId = sessionId;//'{!$Credential.OAuthToken}';
            service.endpoint_x = URL.getOrgDomainURL().toExternalForm()+'/services/Soap/m/'+getClassApiVersion();

            ensxtx_UTIL_MetadataService.StaticResource staticResource = new ensxtx_UTIL_MetadataService.StaticResource();
            staticResource.fullName = appSettingName;
            staticResource.contentType = 'application/javascript';
            staticResource.cacheControl = 'public';
            staticResource.content = content;
            List<ensxtx_UTIL_MetadataService.UpsertResult> saveResults = service.upsertMetadata(new List<ensxtx_UTIL_MetadataService.Metadata> { staticResource });
            ensxtx_UTIL_MetadataService.UpsertResult saveResult = saveResults[0];

            System.debug('Success: ' + saveResult.success);
            System.debug('error: ' + saveResult.errors);

            if (!saveResult.success) {
                isSuccess = false;
                ensxtx_UTIL_PageMessages.addMessage(ensxtx_UTIL_PageMessages.ERROR, 'Failed to save app settings.');
            }
            if (saveResult.errors != null)
            {
                for(ensxtx_UTIL_MetadataService.Error error : saveResult.errors) {
                    ensxtx_UTIL_PageMessages.addMessage(ensxtx_UTIL_PageMessages.ERROR,
                        error.message + ' (' + error.statusCode + ').' +
                        ( error.fields != null && error.fields.size() > 0 ?
                            ' Fields ' + String.join(error.fields, ',') + '.' : '' ) );
                }
            }
        }
        catch(Exception ex) {
            isSuccess = false;
            ensxtx_UTIL_PageMessages.addExceptionMessage(ex);
        }

        return ensxtx_UTIL_Aura.createResponse(new Map<String,Object>{'appSettingName' => appSettingName, 'isSuccess' => isSuccess});
    }
}