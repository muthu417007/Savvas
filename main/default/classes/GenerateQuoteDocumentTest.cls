/*
*********************************************************
Class Name       : GenerateQuoteDocumentTest
Created Date     : 11/20/2024  
Author           : Frank Berni - Cognizant
Description      : Test class for GenerateQuoteDocument controller for LWC.
Percentage       : 92%

History:
<Date>          <Authors Name>              <Brief Description of Change>
11/20/2024       Frank Berni                Ticket W-016591 : initial creation
11/21/2024       Frank Berni                Ticket W-016591 : updated test data so one template is assigned to the Quote
**********************************************************/
@isTest
public class GenerateQuoteDocumentTest {

    @testSetup
    static void setupTestData() {
        SBQQ.TriggerControl.disable();

        // Create test Templates
        List<SBQQ__QuoteTemplate__c> templates = new List<SBQQ__QuoteTemplate__c>();
        SBQQ__QuoteTemplate__c template1 = new SBQQ__QuoteTemplate__c(Name = 'Template 1', SBQQ__DeploymentStatus__c = 'Deployed', SBQQ__Default__c = false);
        SBQQ__QuoteTemplate__c template2 = new SBQQ__QuoteTemplate__c(Name = 'Template 2', SBQQ__DeploymentStatus__c = 'Deployed', SBQQ__Default__c = true);

        templates.add(template1);
        templates.add(template2);
        insert templates;

        // Create a test Quote
        SBQQ__Quote__c testQuote = new SBQQ__Quote__c(Quote_Name_Override__c = 'Test Quote - Number 1', SBQQ__QuoteTemplateId__c = template2.Id);
        insert testQuote;
        
    }

    @isTest
    static void testSave() {
        // Arrange
        SBQQ__Quote__c testQuote = [SELECT Id FROM SBQQ__Quote__c LIMIT 1];
        Map<String, Object> contextMap = new Map<String, Object>{
            'name' => 'Test Document',
            'quoteId' => testQuote.Id,
            'templateId' => [SELECT Id FROM SBQQ__QuoteTemplate__c LIMIT 1].Id,
            'outputFormat' => 'PDF',
            'language' => 'en_US',
            'paperSize' => 'Default'
        };

        // Act
        Test.startTest();
        String result = GenerateQuoteDocument.save(contextMap);
        String status = GenerateQuoteDocument.checkJobStatus(result);
        Test.stopTest();

        // Assert
        System.assertNotEquals(null, result, 'The result should not be null');
        System.assert(result.contains('mockJobId12345'), 'Result should contain the mock job Id');
    }

    @isTest
    static void testGenerateQuoteDocumentFromFlow() {
        // Arrange
        SBQQ__Quote__c testQuote = [SELECT Id FROM SBQQ__Quote__c LIMIT 1];
        List<GenerateQuoteDocument.QuoteDocumentRequest> requests = new List<GenerateQuoteDocument.QuoteDocumentRequest>();
        GenerateQuoteDocument.QuoteDocumentRequest request = new GenerateQuoteDocument.QuoteDocumentRequest();
        request.name = 'Test Flow Document';
        request.quoteId = testQuote.Id;
        request.templateId = [SELECT Id FROM SBQQ__QuoteTemplate__c LIMIT 1].Id;
        request.outputFormat = 'PDF';
        request.language = 'en_US';
        request.paperSize = 'A4';
        requests.add(request);

        // Act
        Test.startTest();
        List<String> results = GenerateQuoteDocument.generateQuoteDocumentFromFlow(requests);
        Test.stopTest();

        // Assert
        System.assertEquals(1, results.size(), 'There should be one result');
        System.assert(results[0].contains('mockJobId12345'), 'The result should contain the mock job ID');
    }

    @isTest
    static void testGetDeployedTemplates() {
        // Act
        Test.startTest();
        List<SBQQ__QuoteTemplate__c> templates = GenerateQuoteDocument.getDeployedTemplates();
        Test.stopTest();

        // Assert
        System.assertNotEquals(null, templates, 'Templates should not be null');
        System.assertEquals(2, templates.size(), 'There should be 2 deployed templates');
    }

    @isTest
    static void testGetTemplatesAndQuoteInfo() {
        // Arrange
        SBQQ__Quote__c testQuote = [SELECT Id FROM SBQQ__Quote__c LIMIT 1];

        // Act
        Test.startTest();
        Map<String, Object> result = GenerateQuoteDocument.getTemplatesAndQuoteInfo(testQuote.Id);
        Test.stopTest();

        // Assert
        System.assertNotEquals(null, result, 'Result should not be null');
        System.assert(result.containsKey('templates'), 'Result should contain templates');
        System.assert(result.containsKey('defaultTemplateId'), 'Result should contain defaultTemplateId');
        System.assert(result.containsKey('quoteName'), 'Result should contain quoteName');
    }

    @isTest
    static void testCheckJobStatus() {
        // Arrange
        String asyncJobId = '123456789012345';
        Test.startTest();
        String status = GenerateQuoteDocument.checkJobStatus(asyncJobId);
        Test.stopTest();

        // Assert
        System.assertEquals('Job not found', status, 'The job status should "Job not found"');
    }

    @isTest
    static void testSaveWithMissingQuoteId() {
        // Arrange
        Map<String, Object> contextMap = new Map<String, Object>{
            'name' => 'Test Document',
            'quoteId' => null,
            'templateId' => [SELECT Id FROM SBQQ__QuoteTemplate__c LIMIT 1].Id,
            'outputFormat' => 'PDF',
            'language' => 'en_US',
            'paperSize' => 'Default'
        };

        // Act & Assert
        try {
            GenerateQuoteDocument.save(contextMap);
            System.assert(false, 'An exception should have been thrown due to missing Quote ID');
        } catch (Exception ex) {
            System.assertEquals('Script-thrown exception', ex.getMessage());
        }
    }

    @isTest
    static void testSaveWithMissingTemplateId() {
        // Arrange
        Map<String, Object> contextMap = new Map<String, Object>{
            'name' => 'Test Document',
            'quoteId' => [SELECT Id FROM SBQQ__Quote__c LIMIT 1].Id,
            'templateId' => null,
            'outputFormat' => 'PDF',
            'language' => 'en_US',
            'paperSize' => 'Default'
        };

        // Act & Assert
        try {
            GenerateQuoteDocument.save(contextMap);
            System.assert(false, 'An exception should have been thrown due to missing Quote ID');
        } catch (Exception ex) {
            System.assertEquals('Script-thrown exception', ex.getMessage());
        }
    }
}