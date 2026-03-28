/**
* Author: Cognizant Team
* Description: Test class for coverage of Sav_FSL_BatchWorkOrderStatusUpdate Batch Class
* Date Created: 03-02-2024
* Version: 1.0
*/
@isTest
public class Sav_FSL_BatchWorkOrderStatusUpdateTest {
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

	@isTest
    Static void testBatch(){
        String accId = [SELECT Id FROM Account][0].Id;
    	String oppId = [SELECT Id FROM Opportunity WHERE AccountId = :accId][0].Id;
        
        User testUser = [SELECT Id FROM User WHERE alias = 'user'][0];
        
        WorkOrder wo = new WorkOrder();
     	wo.Sav_FSL_Order_Date__c =  System.today()-366;
     	wo.Sav_FSL_Opportunity__c = oppId;
     	wo.AccountId = accId;
     	wo.RecordTypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByName().get('Learning Services').getRecordTypeId();
     	wo.Sav_FSL_Service_Type__c = 'Sales - Presentation' ;
     	wo.Sav_FSL_Program__c = System.Label.Sav_FSL_Program_AP_Math;
        wo.Extended_Expiration_Date__c =  System.today()-3;
     	insert wo;
       
        Test.startTest();
        Sav_FSL_BatchWorkOrderStatusUpdate ba= new Sav_FSL_BatchWorkOrderStatusUpdate();
        Database.executeBatch(ba);
        Test.stopTest();
        
    }
}