/*
Apex Test Class:scc_EAccessThresholdBatchTest
Author: CTS (Sanika)
Created Date: 15/07/2024
Modified Date:
*/
@isTest
public class scc_EAccessThresholdBatchTest {
    /**
*  Description: Below method is used to create test data
*  @name: setupTestData
*  @param:NA
*  @return: NA
*  @throws exception- NA
*/
    @TestSetup
    static void setupTestData() {
        EAccess_Imprints__c imprint = new EAccess_Imprints__c(
            Admin_Email1__c = 'test@example.com',
            Admin_Email2__c = 'test2@example.com',
            Imprint_ID__c = 213
        );
        insert imprint;
    }
    
    /**
*  Description: Below method tests below thershold scenario
*  @name: setupTestData
*  @param:NA
*  @return: NA
*  @throws exception- NA
*/
    @isTest
    static void testBatchExecution_BelowThreshold() {
        // Create test data for below threshold scenario
        List<EAccess_Threshold__c> thresholdList = new List<EAccess_Threshold__c>();
        EAccess_Imprints__c imprint = [SELECT Id FROM EAccess_Imprints__c LIMIT 1];
        for (Integer i = 0; i < 5; i++) {
            thresholdList.add(new EAccess_Threshold__c(
                Avl_Stock__c = 5,
                Threshold__c = 10,
                EAccess_Imprints__c = imprint.Id,
                StockAlerted__c = false
            ));
        }
        insert thresholdList;
        
        // Execute the batch
        Test.startTest();
        scc_EAccessThresholdBatch batch = new scc_EAccessThresholdBatch();
        Database.executeBatch(batch, 200);
        Test.stopTest();
        
        // Assertions
        List<EAccess_Threshold__c> updatedThresholds = [SELECT Id, StockAlerted__c FROM EAccess_Threshold__c];
        System.assertEquals(5, updatedThresholds.size(), 'Expected 5 threshold records');
        for (EAccess_Threshold__c threshold : updatedThresholds) {
            System.assertEquals(true, threshold.StockAlerted__c, 'StockAlerted__c should be true for below threshold records');
        }
    }
    
    /**
*  Description: Below method tests above thershold scenario
*  @name: setupTestData
*  @param:NA
*  @return: NA
*  @throws exception- NA
*/
    @isTest
    static void testBatchExecution_AboveThreshold() {
        // Create test data for above threshold scenario
        List<EAccess_Threshold__c> thresholdList = new List<EAccess_Threshold__c>();
        EAccess_Imprints__c imprint = [SELECT Id FROM EAccess_Imprints__c LIMIT 1];
        for (Integer i = 0; i < 5; i++) {
            thresholdList.add(new EAccess_Threshold__c(
                Avl_Stock__c = 15,
                Threshold__c = 10,
                EAccess_Imprints__c = imprint.Id,
                StockAlerted__c = true
            ));
        }
        insert thresholdList;
        
        // Execute the batch
        Test.startTest();
        scc_EAccessThresholdBatch batch = new scc_EAccessThresholdBatch();
        Database.executeBatch(batch, 200);
        Test.stopTest();
        
        // Assertions
        List<EAccess_Threshold__c> updatedThresholds = [SELECT Id, StockAlerted__c FROM EAccess_Threshold__c];
        System.assertEquals(5, updatedThresholds.size(), 'Expected 5 threshold records');
        for (EAccess_Threshold__c threshold : updatedThresholds) {
            System.assertEquals(false, threshold.StockAlerted__c, 'StockAlerted__c should be false for above threshold records');
        }
    }
    
    /**
*  Description: Below method tests mixed thershold scenario
*  @name: setupTestData
*  @param:NA
*  @return: NA
*  @throws exception- NA
*/
    @isTest
    static void testBatchExecution_MixedScenarios() {
        // Create test data for mixed scenarios
        List<EAccess_Threshold__c> thresholdList = new List<EAccess_Threshold__c>();
        EAccess_Imprints__c imprint = [SELECT Id FROM EAccess_Imprints__c LIMIT 1];
        thresholdList.add(new EAccess_Threshold__c(Avl_Stock__c = 5, Threshold__c = 10, EAccess_Imprints__c = imprint.Id, StockAlerted__c = false)); // Below threshold, not alerted
        thresholdList.add(new EAccess_Threshold__c(Avl_Stock__c = 15, Threshold__c = 10, EAccess_Imprints__c = imprint.Id, StockAlerted__c = true)); // Above threshold, alerted
        thresholdList.add(new EAccess_Threshold__c(Avl_Stock__c = 5, Threshold__c = 10, EAccess_Imprints__c = imprint.Id, StockAlerted__c = true)); // Below threshold, already alerted
        thresholdList.add(new EAccess_Threshold__c(Avl_Stock__c = 15, Threshold__c = 10, EAccess_Imprints__c = imprint.Id, StockAlerted__c = false)); // Above threshold, not alerted
        insert thresholdList;
        
        // Execute the batch
        Test.startTest();
        scc_EAccessThresholdBatch batch = new scc_EAccessThresholdBatch();
        Database.executeBatch(batch, 200);
        Test.stopTest();
        
        // Assertions
        List<EAccess_Threshold__c> updatedThresholds = [SELECT Id, Avl_Stock__c, Threshold__c, StockAlerted__c FROM EAccess_Threshold__c ORDER BY Avl_Stock__c];
        System.assertEquals(4, updatedThresholds.size(), 'Expected 4 threshold records');
        System.assertEquals(true, updatedThresholds[0].StockAlerted__c, 'First record should be alerted');
        System.assertEquals(true, updatedThresholds[1].StockAlerted__c, 'Second record should remain alerted');
        System.assertEquals(false, updatedThresholds[2].StockAlerted__c, 'Third record should not be alerted');
        System.assertEquals(false, updatedThresholds[3].StockAlerted__c, 'Fourth record should not be alerted');
    }
}