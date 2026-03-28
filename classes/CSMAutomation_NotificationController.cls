public class CSMAutomation_NotificationController {
    
    @AuraEnabled(cacheable=true)
    public static List<Map<String, Object>> getCustomNotificationData() {
        List<Map<String, Object>> dataList = new List<Map<String, Object>>();
        for (CSM_Notification_Setup__mdt record : [SELECT Name__c, Notification_Type__c FROM CSM_Notification_Setup__mdt]) {
            dataList.add(new Map<String, Object>{
                'Name' => record.Name__c,
                'Type' => record.Notification_Type__c,
                'Subscribe' => false // Default value for 'Subscribe'
            });
        }
        return dataList;
    }

}