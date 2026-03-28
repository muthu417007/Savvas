/*********************************************************** 
* @Class Name  - scc_fetchCustomAlertMessage_Test
* @description - Test class for scc_fetchCustomAlertMessage
* @Created By  - CTS-Muthukumar
* @Created On - 2024-07-30 
* **********************************************************/ 
@isTest
public class scc_fetchCustomAlertMessage_Test {
    /**
*  Description: Below method is fetch custom alert message
*  @name: fetchCustomAlertMessage
*  @param:NA
*  @return: NA
*  @throws exception- NA
*/ 
    @isTest
    static void fetchCustomAlertMessage(){
        Custom_Alert_Message__c customAlert = new Custom_Alert_Message__c(
            Name = 'custom Alert',
            Alert_Content__c='custom Alert',
            Alert_Heading__c='custom Alert',
            End_Date__c=date.today(),
            Start_Date__c=date.today(),
            Publish_Alert__c = false
        );
        insert customAlert;
        
        TEST.StartTest();
        scc_fetchCustomAlertMessage.fetchAlertMessage();
        Test.stopTest();
    }
    @isTest
    static void fetchCustomAlertMessage1(){
        Custom_Alert_Message__c customAlert = new Custom_Alert_Message__c(
            Name = 'custom Alert',
            Alert_Content__c='custom Alert',
            Alert_Heading__c='custom Alert',
            End_Date__c=date.today(),
            Start_Date__c=date.today(),
            Publish_Alert__c = true
        );
        insert customAlert;
        
        TEST.StartTest();
        scc_fetchCustomAlertMessage.fetchAlertMessage();
        Test.stopTest();
    }
    @isTest
    static void fetchCustomAlertMessage2(){
        Custom_Alert_Message__c customAlert = new Custom_Alert_Message__c(
            Name = 'custom Alert',
            Alert_Content__c='custom Alert',
            Alert_Heading__c='custom Alert',
            End_Date__c=date.today().addDays(-10),
            Start_Date__c=date.today(),
            Publish_Alert__c = true
        );
        insert customAlert;
        
        TEST.StartTest();
        scc_fetchCustomAlertMessage.fetchAlertMessage();
        Test.stopTest();
    }
}