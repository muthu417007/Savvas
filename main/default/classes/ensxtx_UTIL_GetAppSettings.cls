public without sharing class ensxtx_UTIL_GetAppSettings
{
    public static String testBody = null;
    
    @testVisible
    private static Map<String, String> settingsMap = new Map<String, String>();

    @AuraEnabled(cacheable=true)
    public static String getAppsettings (String appsettingName) {
        if (settingsMap.containsKey(appsettingName)) return settingsMap.get(appsettingName);
        
        String lang = UserInfo.getLanguage();
        String body;

        if (lang != null) {
            String localeAppsettingName = appsettingName+'_'+lang;
            StaticResource[] userLangStaticResource = [SELECT Id, Body FROM StaticResource WHERE Name = :localeAppsettingName LIMIT 1];
            if(userLangStaticResource.size() > 0) body = userLangStaticResource[0].Body.toString();

            if (body == null) {
                StaticResource[] standardStaticResource = [SELECT Id, Body FROM StaticResource WHERE Name = :appsettingName LIMIT 1];
                if(standardStaticResource.size() > 0) body = standardStaticResource[0].Body.toString();
            }
        }

        if (Test.isRunningTest() && testBody != null) body = testBody;
        if (body == null && !Test.isRunningTest()) throw new AuraHandledException('Static Resource ' + appsettingName + ' does not exist.');
        return body;
    }
}