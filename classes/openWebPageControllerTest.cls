/**
 * @description       : Test class for the openWebPageController
 * @author            : Ryan Schmitt
 * @group             : 
 * @last modified on  : 08-17-2022
 * @last modified by  : Ryan Schmitt
 * Modifications Log
 * Ver   Date         Author         Modification
 * 1.0   08-09-2022   Ryan Schmitt   Initial Version
**/

@isTest
public with sharing class openWebPageControllerTest {
    @TestSetup
    public static void setup(){
        SBQQ__CustomAction__c customActionRecord = new SBQQ__CustomAction__c();
        customActionRecord.SBQQ__DisplayOrder__c = 10;
        customActionRecord.Name = 'Add Products';
        insert customActionRecord;
    }

    @isTest
    public static void testGetCustomAction() {
       
        SBQQ__CustomAction__c customActionTest = [SELECT Id FROM SBQQ__CustomAction__c WHERE Name = 'Add Products'];

        Test.startTest();
        Id result = openWebPageController.getCustomAction();
        Test.stopTest();
        System.assertEquals(customActionTest.Id, result, 'The custom action Id can not be found');
    }
}