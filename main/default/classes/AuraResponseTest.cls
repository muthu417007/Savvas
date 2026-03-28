@isTest
public class AuraResponseTest {
      public static testMethod void testAuraResponse(){      
        Account acc = new Account(Name='test1 acc',billingcity = 'New York');
        insert acc;
        
        Opportunity opp = new Opportunity(Name = 'test Opportunity', AccountId = acc.Id, 
                                          StageName = 'Prospect', CloseDate = Date.today(), CurrencyIsoCode = 'USD');
        insert opp;

        String accId = [SELECT Id FROM Account][0].Id;
        String oppId = [SELECT Id FROM Opportunity WHERE AccountId = :accId][0].Id;

        WorkOrder wo = new WorkOrder();
        wo.Sav_FSL_Order_Date__c =  System.today();
        wo.Sav_FSL_Opportunity__c = oppId;
        wo.AccountId = accId;
        wo.RecordTypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByName().get('Learning Services').getRecordTypeId();
        wo.Sav_FSL_Service_Type__c = 'Prof Dev - Impl Essnt';
        wo.Sav_FSL_Program__c = 'AP Math';
        insert wo;

        List<WorkOrder> woLst = [Select Id FROM WorkOrder WHERE AccountId = :accId];

        AuraResponse aura=new AuraResponse(false,'message',woLst);
        system.assertEquals(aura.isSuccess,false);
    }
}