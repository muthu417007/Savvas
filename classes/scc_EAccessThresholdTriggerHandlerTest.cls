/*********************************************************** 
* @Class Name  - scc_EAccessThresholdTriggerHandlerTest
* @description - Test class for scc_EAccessThresholdTriggerHandler
* @Created By  - CTS-Sanika
* @Created On - 27/06/2024
* **********************************************************/ 
@isTest
public class scc_EAccessThresholdTriggerHandlerTest {
    /**
*  Description: Below method is test Eaccess thershold data
*  @name: testProcessThresholds
*  @param:NA
*  @return: NA
*  @throws exception- NA
*/ 
    @isTest
    static void testProcessThresholds() {
        // Create test data
        EAccess_Imprints__c imprint = new EAccess_Imprints__c(
            Admin_Email1__c = 'test@example.com',
            Admin_Email2__c = 'test2@example.com',
            Imprint_ID__c = 213
        );
        insert imprint;

        EAccess_Threshold__c threshold = new EAccess_Threshold__c(
            Avl_Stock__c = 5,
            Threshold__c = 10,
            EAccess_Imprints__c = imprint.Id
        );
        insert threshold;

        // Create a list and call the processThresholds method
        List<EAccess_Threshold__c> thresholdList = [SELECT Id, Avl_Stock__c, Threshold__c, EAccess_Imprints__c FROM EAccess_Threshold__c];
        Test.startTest();
        scc_EAccessThresholdTriggerHandler.processThresholds(thresholdList);
        Test.stopTest();

    }
}