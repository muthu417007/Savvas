@isTest
public class CSMAutomation_QuoteAttachmentCntrl_Test {
    
    @TestSetup
    static void setupTestData() {
        //test Opportunity
        Opportunity opp1 = new Opportunity();
        opp1.Name = 'Test Opportunity 1';
        opp1.StageName = 'Prospect';
        opp1.Discipline_and_Grade_Band__c = 'Humanities 6-8';
        opp1.CloseDate = Date.today().addDays(30);
        insert opp1;

        Opportunity opp2 = new Opportunity();
        opp2.Name = 'Test Opportunity 2';
        opp2.StageName = 'Awarded';
        opp2.Discipline_and_Grade_Band__c = 'Humanities 6-8';
        opp2.CloseDate = Date.today().addDays(30);
        insert opp2;

        //test Quote associated with opp1 (Primary and Presented)
        SBQQ__Quote__c quote1 = new SBQQ__Quote__c();
        quote1.Quote_Name__c = 'Test Quote 1';
        quote1.SBQQ__Opportunity2__c = opp1.Id;
        quote1.SBQQ__Primary__c = true;
        quote1.ApprovalStatus__c = 'Presented';
        insert quote1;

        //test Attachment related to the Quote
        Attachment attachment1 = new Attachment();
        attachment1.Name = 'Test Attachment 1';
        attachment1.Body = Blob.valueOf('Test Attachment Body 1');
        attachment1.ParentId = quote1.Id;
        insert attachment1;

        //Quote associated with opp2 (not Primary or not Presented)
        SBQQ__Quote__c quote2 = new SBQQ__Quote__c();
        quote2.Quote_Name__c = 'Test Quote 2';
        quote2.SBQQ__Opportunity2__c = opp2.Id;
        quote2.SBQQ__Primary__c = false;
        quote2.ApprovalStatus__c = 'Draft';
        insert quote2;
    }

    @IsTest
    static void testCopyAttachmentsFromPrimaryQuote_Success() {

        Opportunity opp1 = [SELECT Id FROM Opportunity WHERE Name = 'Test Opportunity 1' LIMIT 1];

        Test.startTest();
        CSMAutomation_QuoteAttachmentController.copyAttachmentsFromPrimaryQuote(new List<Id>{opp1.Id});
        Test.stopTest();

        List<Attachment> attachments = [SELECT Id, Name, ParentId FROM Attachment WHERE ParentId = :opp1.Id];
        System.assertEquals(1, attachments.size(), 'The attachment should be copied to the Opportunity');
    }

    @IsTest
    static void testCopyAttachmentsFromPrimaryQuote_NoPrimaryQuote() {

        Opportunity opp2 = [SELECT Id FROM Opportunity WHERE Name = 'Test Opportunity 2' LIMIT 1];
        Test.startTest();
        CSMAutomation_QuoteAttachmentController.copyAttachmentsFromPrimaryQuote(new List<Id>{opp2.Id});
        Test.stopTest();

        List<Exception_Log__c> logs = [SELECT DeveloperMessage__c FROM Exception_Log__c];
        System.assertEquals(2, logs.size(), 'There should be one exception log due to no primary Quote found');
    }

    @IsTest
    static void testCopyAttachmentsFromPrimaryQuote_NoAttachments() {
        //Opportunity and associated Quote with no Attachments
        Opportunity opp3 = new Opportunity();
        opp3.Name = 'Opportunity No Attachments';
        opp3.StageName = 'Verbal Commitment';
        opp3.Discipline_and_Grade_Band__c = 'Humanities 6-8';
        opp3.CloseDate = Date.today().addDays(30);
        insert opp3;

        SBQQ__Quote__c quote3 = new SBQQ__Quote__c();
        quote3.Quote_Name__c = 'Quote No Attachments';
        quote3.SBQQ__Opportunity2__c = opp3.Id;
        quote3.SBQQ__Primary__c = true;
        quote3.ApprovalStatus__c = 'Presented';
        insert quote3;

        Test.startTest();
        CSMAutomation_QuoteAttachmentController.copyAttachmentsFromPrimaryQuote(new List<Id>{opp3.Id});
        Test.stopTest();

        List<Exception_Log__c> logs = [SELECT DeveloperMessage__c FROM Exception_Log__c WHERE DeveloperMessage__c LIKE '%No attachment found%'];
        System.assertEquals(1, logs.size(), 'There should be one exception log due to no attachments found');
    }   
}