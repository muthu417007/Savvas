/**************************************************************************************** 
* @Class Name  - scc_IntegrationLogs_Helper
* @description - test class for scc_IntegrationLogs_Helper
* @Created By  - Vaibhav Saptal (Cognizant)
* @Created On - 2024-08-23
* ***************************************************************************************/ 
@istest
public class scc_IntegrationLogs_Helper_Test {
    public static List<Integration_Logs__c> radarIntegrationLogs = new List<Integration_Logs__c>();
/*
*  Method Name : testClassMethod
*  Description : test class method for scc_IntegrationLogs_Helper
*  param : NA
*  return : NA
*/    
    @isTest
    static void testClassMethod(){
        test.startTest();
        scc_IntegrationLogs_Helper.createIntegrationLogsLWC('Fedex','requestString','response.getBody()','Success','');
        scc_IntegrationLogs_Helper.createIntegrationLogsLWC1('Fedex','requestString','response.getBody()','Success','','');
        Integration_Logs__c integrationLog = new Integration_Logs__c(
            Type__c = 'logType',
            Request_Body__c = 'requestBody',
            Response_Body__c = 'responseBody',
            Status__c = 'Success',
            Internal_Status__c = 'internalStatus',
            Contact_Email__c = 'contactEmail',
            scc_User_Type__c = 'userType'
        );
        radarIntegrationLogs.add(integrationLog);
        scc_IntegrationLogs_Helper.createSFCCIntegrationLogs(JSON.serialize(radarIntegrationLogs));
        Account acc= scc_TestDataFactory.accountCreation('testAccount4');
        Contact con = scc_TestDataFactory.contactCreation( acc.Id, 'firstname4', 'testlastname4', 'testemail1@abc.com');
        Profile pd = [Select id From profile where name =:scc_constantHelper.SAVVAS_EXTERNAL_USERS_BASE_PROFILE limit 1];
        Profile pd1 = [Select id From profile where name =:scc_constantHelper.MY_SAVVAS_ORDERS_PROFILE limit 1];
        User testUser1 = new User();
        testUser1.ProfileId=pd.Id;          
        testUser1.LastName = 'Test User';
        testUser1.Email = 'testuser@example.com';
        testUser1.Username = 'testuser@example.com' + System.currentTimeMillis();
        testUser1.Alias = 'tuser';
        testUser1.TimeZoneSidKey = 'America/Los_Angeles';
        testUser1.LocaleSidKey = 'en_US';
        testUser1.EmailEncodingKey = 'UTF-8';
        testUser1.LanguageLocaleKey = 'en_US';
        testUser1.ContactId = con.Id;
        insert testUser1;
        
        User testUser2 = new User();
        testUser2.ProfileId=pd1.Id;          
        testUser2.LastName = 'Test User';
        testUser2.Email = 'testuser@example.com';
        testUser2.Username = 'testuser@example.com' + System.currentTimeMillis();
        testUser2.Alias = 'tuser';
        testUser2.TimeZoneSidKey = 'America/Los_Angeles';
        testUser2.LocaleSidKey = 'en_US';
        testUser2.EmailEncodingKey = 'UTF-8';
        testUser2.LanguageLocaleKey = 'en_US';
        insert testUser2;
        
        System.runAs(testUser1) {
            scc_IntegrationLogs_Helper.createIntegrationLogsLWC('Fedex','requestString','response.getBody()','Success','');  
            scc_IntegrationLogs_Helper.createIntegrationLogsLWC1('Fedex','requestString','response.getBody()','Success','','');              
            scc_PaymetricIntegrationController.createIntegrationLogs('Paymetric', 'requestBody','responseBody', 'Success', '', '', '',true,'External User');
            scc_checkAccessCode.createIntegrationLogs('Pearson Access Code', 'requestBody','responseBody', 'Success', '', '', '',true,'External User');
            scc_fedExTrackingService.createIntegrationLogs('Fedex', 'requestBody','responseBody', 'Success', '', '', '',true,'External User');
        }
        
        System.runAs(testUser2) {
            scc_IntegrationLogs_Helper.createIntegrationLogsLWC('Fedex','requestString','response.getBody()','Success','');  
            scc_IntegrationLogs_Helper.createIntegrationLogsLWC1('Fedex','requestString','response.getBody()','Success','','');              
            scc_PaymetricIntegrationController.createIntegrationLogs('Paymetric', 'requestBody','responseBody', 'Success', '', '', '',true,'External User');
            scc_checkAccessCode.createIntegrationLogs('Pearson Access Code', 'requestBody','responseBody', 'Success', '', '', '',true,'External User');
            scc_fedExTrackingService.createIntegrationLogs('Fedex', 'requestBody','responseBody', 'Success', '', '', '',true,'External User');
        }
        test.stopTest();
    }
}