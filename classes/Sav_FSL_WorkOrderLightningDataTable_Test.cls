@isTest
public class Sav_FSL_WorkOrderLightningDataTable_Test {
    @TestSetup
    static void makeData(){
        Account acc = new Account(Name='test acc',billingcity = 'New York');
        insert acc;
        
        Account acc1 = new Account(Name='test1 acc',billingcity = 'New York');
        insert acc1;
        
        Opportunity opp = new Opportunity(Name = 'test Opportunity', AccountId = acc.Id, 
                                          StageName = 'Prospect', CloseDate = Date.today(), CurrencyIsoCode = 'USD');
        insert opp;
        
        Opportunity opp2 = new Opportunity(Name = 'test Opportunity', AccountId = acc1.Id, 
                                           StageName = 'Prospect', CloseDate = Date.today(), CurrencyIsoCode = 'USD');
        insert opp2;
    }
    
    @isTest
    public static void getWorkOrder() {
        String acc1Id = [SELECT Id FROM Account][1].Id;
        String opp2Id = [SELECT Id FROM Opportunity WHERE AccountId = :acc1Id][0].Id;
        
        WorkOrder wo = new WorkOrder();
        wo.Sav_FSL_Order_Date__c =  System.today();
        wo.Sav_FSL_Opportunity__c = opp2Id;
        wo.AccountId = acc1Id;
        wo.RecordTypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByName().get('Learning Services').getRecordTypeId();
        wo.Sav_FSL_Service_Type__c = System.Label.Sav_FSL_Service_Type_PIE;
        wo.Sav_FSL_Program__c = System.Label.Sav_FSL_Program_AP_Math;
        wo.Status = 'New';
        insert wo;    
        
        
        test.startTest();
        AuraResponse objResponse = Sav_FSL_WorkOrderLightningDataTable.getWorkOrderList(opp2Id);
       // System.assertEquals(objResponse.isSuccess, true);
        test.stopTest();
    }
    
    @isTest
    public static void getWorkOrderException() {
        String accId = [SELECT Id FROM Account][0].Id;
        String oppId = [SELECT Id FROM Opportunity WHERE AccountId = :accId][0].Id;
        
        WorkOrder wo = new WorkOrder();
        wo.Sav_FSL_Order_Date__c =  System.today();
        wo.Sav_FSL_Opportunity__c = oppId;
        wo.AccountId = accId;
        wo.RecordTypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByName().get('Learning Services').getRecordTypeId();
        wo.Sav_FSL_Service_Type__c = System.Label.Sav_FSL_Service_Type_Pilot_Support;
        wo.Sav_FSL_Program__c = System.Label.Sav_FSL_Program_AP_Math;
        wo.Status = 'New';
        insert wo; 
        
        Test.startTest();
        AuraResponse objResponse = Sav_FSL_WorkOrderLightningDataTable.getWorkOrderList(oppId);
        System.assertEquals(objResponse.isSuccess, false);
        Test.stopTest();

    } 
    
}