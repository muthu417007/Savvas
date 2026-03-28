/*
*********************************************************
Class Name       : SavCpqQuoteControllerTest
Created Date     : 6/26/2024  
Author           : Frank Berni - Cognizant
Description      : Apex validation controller for New Cpq Quote button
Test Percentage  : 100%

History:
<Date>          <Authors Name>              <Brief Description of Change>
6/26/2024       Frank Berni                 Initial creation: Ticket W-015045 
**********************************************************/
@isTest
public with sharing class SavCpqQuoteControllerTest {

    @TestSetup
    static void makeData() {

        Id schoolAccId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Schools Account').getRecordTypeId();

        Account acc = new Account();
        acc.RecordTypeId = schoolAccId;
        acc.Name = 'Testing Tykes Elementary';
        acc.Type = 'Public District';
        insert acc;
        System.debug('Account Inserted - ' + acc);

        System.debug('All Test Data Inserted Successfully');
        
    }
    
    /*
    *********************************************************
    Method Name    : testGetOppInfo
    Author         : Frank Berni
    Description    : Tests for getOppInfo method - Positive test
    ********************************************************
    */
    @isTest
    static void testGetOppInfo(){

        // Test setup 2
        Account acc = [SELECT Id FROM Account LIMIT 1];

        Opportunity opp = new Opportunity();
        opp.Name = 'Tykes Elem - Envision Core Offerings';
        opp.CloseDate = Date.Today();
        opp.StageName = 'Prospect';
        opp.AccountId = acc.Id;
        insert opp;
        System.debug('Opportunity Inserted - ' + opp);

        // Testing the method
        String oppId = (String)opp.Id;

        Test.startTest();
        Opportunity returnedOpp = SavCpqQuoteController.getOppInfo(oppId);
        Test.stopTest();

        System.assert(returnedOpp != null, 'Did not return the Opportunity properly');

    }

    /*
    *********************************************************
    Method Name    : testGetOppInfo
    Author         : Frank Berni
    Description    : Tests for getOppInfo method - Negative test - needs this to be above 90%
    ********************************************************
    */
    @isTest
    static void testGetOppInfoNeg(){

        // Testing the method
        String oppId = '006W4000004T1xhIAC';

        Test.startTest();
        Opportunity returnedOpp = SavCpqQuoteController.getOppInfo(oppId);
        Test.stopTest();

        System.assert(returnedOpp == null, 'Did not return null for the Opportunity');

    }

    /*
    *********************************************************
    Method Name    : testGetPrimaryContact
    Author         : Frank Berni
    Description    : Tests for getPrimaryContact method - Positive test
    ********************************************************
    */
    @isTest
    static void testGetPrimaryContact(){

        // Setting up Quote Pricebook 
        PriceBook2 quotePricebook = new PriceBook2();
        quotePricebook.Name = 'Quote Pricebook';
        quotePricebook.IsActive = true;
        insert quotePricebook;

        // Test setup 2
        Account acc = [SELECT Id FROM Account LIMIT 1];

        Contact con = new Contact();
        con.FirstName = 'Michael';
        con.LastName = 'Grote';
        con.Title = 'QA';
        con.Email = 'mgrote@yahoo22.com';
        con.AccountId = acc.Id;
        insert con;
        System.debug('Contact Inserted - ' + con);

        Opportunity opp = new Opportunity();
        opp.Name = 'Tykes Elem - Envision Core Offerings';
        opp.CloseDate = Date.Today();
        opp.StageName = 'Prospect';
        opp.AccountId = acc.Id;
        insert opp;
        System.debug('Opportunity Inserted - ' + opp);

        OpportunityContactRole ocr = new OpportunityContactRole();
        ocr.OpportunityId = opp.Id;
        ocr.ContactId = con.Id;
        ocr.Role = 'Evaluator';
        ocr.IsPrimary = true;
        insert ocr;
        System.debug('Opp Contact Role Inserted - ' + ocr);

        // Testing the method
        String oppId = (String)opp.Id;

        Test.startTest();
        PriceBook2 returnedPricebook = SavCpqQuoteController.getQuotePricebook();
        OpportunityContactRole returnedOcr = SavCpqQuoteController.getPrimaryContact(oppId);
        Test.stopTest();

        System.assert(returnedOcr != null, 'Did not return the Opportunity Contact Role properly');

    }

    /*
    *********************************************************
    Method Name    : testGetPrimaryContactNeg
    Author         : Frank Berni
    Description    : Tests for getPrimaryContact method - Negative test - needs this to be above 90%
    ********************************************************
    */
    @isTest
    static void testGetPrimaryContactNeg(){

        // Test setup 2
        Account acc = [SELECT Id FROM Account LIMIT 1];

        Contact con = new Contact();
        con.FirstName = 'Michael';
        con.LastName = 'Grote';
        con.Title = 'QA';
        con.Email = 'mgrote@yahoo22.com';
        con.AccountId = acc.Id;
        insert con;
        System.debug('Contact Inserted - ' + con);

        Opportunity opp = new Opportunity();
        opp.Name = 'Tykes Elem - Envision Core Offerings';
        opp.CloseDate = Date.Today();
        opp.StageName = 'Prospect';
        opp.AccountId = acc.Id;
        insert opp;
        System.debug('Opportunity Inserted - ' + opp);

        // Testing the method
        String oppId = (String)opp.Id;

        Test.startTest();
        PriceBook2 returnedPricebook = SavCpqQuoteController.getQuotePricebook();
        OpportunityContactRole returnedOcr = SavCpqQuoteController.getPrimaryContact(oppId);
        Test.stopTest();

        System.assert(returnedOcr == null, 'Did not return null for the Opportunity Contact Role');

    }
}