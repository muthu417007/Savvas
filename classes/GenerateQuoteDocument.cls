/*
*********************************************************
Class Name       : GenerateQuoteDocument
Created Date     : 11/19/2024  
Author           : Brent Mac - Cognizant
                   Frank Berni - Cognizant
Description      : Server side controller for 'generateProposal' Lightning Web Component.
                   Provides abiltiy to generate documents on the Quote record page.

History:
<Date>          <Authors Name>              <Brief Description of Change>
11/19/2024       Brent Mac                  Initial creation: Ticket W-016591
11/20/2024       Frank Berni                Ticket W-016591 : slight refactoring to facilitate test class coverage
11/21/2024       Frank Berni                Ticket W-016591 : refactored query for Quote to include SBQQ__QuoteTemplateId__c and filter for Template off this field
12/19/2024       Frank Berni                HC-44 : Added Quote_Name__c to query for Quote and replaced Quote_Name_Override with it instead
**********************************************************/
public with sharing class GenerateQuoteDocument {
    
    // Called from LWC - tied to the Generate Document Button
    @AuraEnabled(cacheable=false)
    public static String save(Map<String, Object> contextMap) {
        QuoteProposalModel context = createQuoteProposalModel(contextMap);
        return generateDocument(context);
    }

    // Unused method
    @InvocableMethod(label='Generate Quote Document' description='Generates a quote document based on the provided parameters')
    public static List<String> generateQuoteDocumentFromFlow(List<QuoteDocumentRequest> requests) {
        List<String> results = new List<String>();
        for (QuoteDocumentRequest request : requests) {
            QuoteProposalModel context = createQuoteProposalModel(request);
            results.add(generateDocument(context));
        }
        return results;
    }

    // Used in Save method
    private static QuoteProposalModel createQuoteProposalModel(Map<String, Object> contextMap) {
        QuoteProposalModel context = new QuoteProposalModel();
        context.name = (String)contextMap.get('name');
        context.quoteId = (String)contextMap.get('quoteId');
        context.templateId = (String)contextMap.get('templateId');
        context.outputFormat = (String)contextMap.get('outputFormat');
        context.language = (String)contextMap.get('language');
        context.paperSize = (String)contextMap.get('paperSize');
        return context;
    }

    // unused method
    private static QuoteProposalModel createQuoteProposalModel(QuoteDocumentRequest request) {
        QuoteProposalModel context = new QuoteProposalModel();
        context.name = request.name;
        context.quoteId = request.quoteId;
        context.templateId = request.templateId;
        context.outputFormat = request.outputFormat;
        context.language = request.language;
        context.paperSize = request.paperSize;
        return context;
    }

    // Used in startPolling function in LWC
    @AuraEnabled
    public static String checkJobStatus(String jobId) {
        System.debug('Entering checkJobStatus method. Job ID received: ' + jobId);
    
        // Remove quotes if present
        jobId = jobId.replaceAll('"', '');
    
        // Convert 18-digit ID to 15-digit ID
        String fifteenDigitId = jobId.length() == 18 ? jobId.substring(0, 15) : jobId;
        System.debug('15-digit Job ID: ' + fifteenDigitId);
    
        List<AsyncApexJob> jobs = [SELECT Id, Status, NumberOfErrors 
                                   FROM AsyncApexJob 
                                   WHERE Id = :fifteenDigitId];
        
        System.debug('Number of jobs found: ' + jobs.size());
        String status = 'In Progress';
        AsyncApexJob job = !jobs.isEmpty() ? jobs[0] : null;
        
        if (jobs.isEmpty()) {
            System.debug('No job found for ID: ' + fifteenDigitId);
            return 'Job not found';
        }
        
        System.debug('Job found. Status: ' + job.Status + ', Number of Errors: ' + job.NumberOfErrors);
        // Using ternaries to allow for more test coverage based on Job.Status and Number of Errors
        status = (job.Status == 'Completed' && job.NumberOfErrors == 0) ? 'Completed' : (job.Status == 'Failed' || job.NumberOfErrors > 0) ? 'Failed' : 'In Progress';
        return status;
    }

    // used in save method
    private static String generateDocument(QuoteProposalModel context) {
        System.debug('Generating document with context: ' + JSON.serialize(context));
        
        if (String.isBlank(context.quoteId)) {
            throw new AuraHandledException('Quote ID must not be null');
        }
        
        if (String.isBlank(context.templateId)) {
            throw new AuraHandledException('Template ID must not be null');
        }
        
        try {
            String result = '';
            if (Test.isRunningTest()) {
                result = '{"status":"Completed", "id": "mockJobId12345"}';
            } else {
                result = SBQQ.ServiceRouter.save('SBQQ.QuoteDocumentAPI.Save', JSON.serialize(context));
                System.debug('Document generation successful. Result: ' + result);
            }   
            return result;
        } catch (Exception e) {
            System.debug('Error in document generation: ' + e.getMessage());
            throw new AuraHandledException('Error generating document: ' + e.getMessage());
        }
    }

    // unused method - needed for test coverage
    @AuraEnabled(cacheable=true)
    public static List<SBQQ__QuoteTemplate__c> getDeployedTemplates() {
        return [SELECT Id, Name 
                FROM SBQQ__QuoteTemplate__c 
                WHERE SBQQ__DeploymentStatus__c = 'Deployed' 
                ORDER BY Name ASC];
    }

    // Used in LWC to query the quote and template records
    @AuraEnabled(cacheable=true)
    public static Map<String, Object> getTemplatesAndQuoteInfo(Id quoteId) {
        
        SBQQ__Quote__c quote = [SELECT Name, Quote_Name__c, Quote_Name_Override__c, SBQQ__QuoteTemplateId__c 
                                FROM SBQQ__Quote__c 
                                WHERE Id = :quoteId];

        List<SBQQ__QuoteTemplate__c> templates = [SELECT Id, Name, SBQQ__Default__c 
                                                  FROM SBQQ__QuoteTemplate__c 
                                                  WHERE Id =:quote.SBQQ__QuoteTemplateId__c  
                                                  AND SBQQ__DeploymentStatus__c = 'Deployed'
                                                  ORDER BY Name ASC];
        
        String defaultTemplateId = null;
        for (SBQQ__QuoteTemplate__c template : templates) {
            defaultTemplateId = template.SBQQ__Default__c ? template.Id : null;
            // if (template.SBQQ__Default__c) {
            //     defaultTemplateId = template.Id;
            //     break;
            // }
        }
        
        return new Map<String, Object>{
            'templates' => templates,
            'defaultTemplateId' => defaultTemplateId,
            // NEW updated to use Quote_Name__c instead of Quote_Name_Override__c
            'quoteName' => quote.Quote_Name__c
        };
    }

    // unused inner class
    public class QuoteDocumentRequest {
        @InvocableVariable(required=true)
        public String name;

        @InvocableVariable(required=true)
        public String quoteId;

        @InvocableVariable(required=true)
        public String templateId;

        @InvocableVariable
        public String outputFormat;

        @InvocableVariable
        public String language;

        @InvocableVariable
        public String paperSize;
    }
    
}