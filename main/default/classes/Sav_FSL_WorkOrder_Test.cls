/**
* Author: Cognizant Team
* Description: Test class for coverage of Sav_FSL_WorkOrder_Trigger Trigger and Sav_FSL_WorkOrderTriggerHandler Apex class
* Date Created: 25-04-2023
* Version: 1.0
*/

@isTest
public class Sav_FSL_WorkOrder_Test {
	 @TestSetup
    private static void makeData(){
        Profile p = [SELECT Id FROM Profile WHERE Name =: Label.ICOM_Professional_Services];
        User testUser = new User(Alias = 'user', Email='newuser@testorg.com',
                                 EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                                 LocaleSidKey='en_US', ProfileId = p.Id,
                                 TimeZoneSidKey='America/Los_Angeles',Username = UserInfo.getOrganizationId() + System.now().millisecond()+'@managertest.com');
        
        insert testUser;
        Account acc = new Account(Name='test acc',billingcity = 'New York', OwnerId =testUser.Id);
        insert acc;
        
        Opportunity opp = new Opportunity(Name = 'test Opportunity', AccountId = acc.Id, 
                                          StageName = 'Prospect', CloseDate = Date.today(), CurrencyIsoCode = 'USD', Opportunity_Leader__c = testUser.Id );
        insert opp;
    }
    
    static testMethod void AddWorkOrder() {
        String accId = [SELECT Id FROM Account][0].Id;
    	String oppId = [SELECT Id FROM Opportunity WHERE AccountId = :accId][0].Id;
        
        User testUser = [SELECT Id FROM User WHERE alias = 'user'][0];
        
        WorkOrder wo = new WorkOrder();
     	wo.Sav_FSL_Order_Date__c =  System.today();
     	wo.Sav_FSL_Opportunity__c = oppId;
     	wo.AccountId = accId;
     	wo.RecordTypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByName().get('Learning Services').getRecordTypeId();
     	wo.Sav_FSL_Service_Type__c = System.Label.Sav_FSL_Service_Type_PD;
     	wo.Sav_FSL_Program__c = System.Label.Sav_FSL_Program_AP_Math;
     	insert wo;
        
       
    }
    static testMethod void AddWorkOrder2() {
        String accId = [SELECT Id FROM Account][0].Id;
    	String oppId = [SELECT Id FROM Opportunity WHERE AccountId = :accId][0].Id;
        
        User testUser = [SELECT Id FROM User WHERE profile.Name =: Label.ICOM_Professional_Services and isActive = true LIMIT 1];
        
        WorkOrder wo1 = new WorkOrder();
     	wo1.Sav_FSL_Order_Date__c =  System.today();
     	wo1.Sav_FSL_Opportunity__c = oppId;
     	wo1.AccountId = accId;
     	wo1.RecordTypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByName().get('Learning Services').getRecordTypeId();
     	wo1.Sav_FSL_Service_Type__c = System.Label.Sav_FSL_Service_Type_PIE;
     	wo1.Sav_FSL_Program__c = System.Label.Sav_FSL_Program_AP_Math;
        wo1.Sav_FSL_Purchase_Order__c = '1234';
     	insert wo1;
    }
    static testMethod void AddWorkOrder3() {
        String accId = [SELECT Id FROM Account][0].Id;
    	String oppId = [SELECT Id FROM Opportunity WHERE AccountId = :accId][0].Id;
        
        User testUser = [SELECT Id FROM User WHERE profile.Name =: Label.ICOM_Professional_Services and isActive = true LIMIT 1];
        
        WorkOrder wo2 = new WorkOrder();
     	wo2.Sav_FSL_Order_Date__c =  System.today();
     	wo2.Sav_FSL_Opportunity__c = oppId;
     	wo2.AccountId = accId;
     	wo2.RecordTypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByName().get('Learning Services').getRecordTypeId();
     	wo2.Sav_FSL_Service_Type__c = System.Label.Sav_FSL_Service_Type_Pilot_Support;
     	wo2.Sav_FSL_Program__c = System.Label.Sav_FSL_Program_AP_Math;
     	insert wo2;
    }
}