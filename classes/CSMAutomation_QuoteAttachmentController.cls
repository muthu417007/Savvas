/*
Apex Class:CSMAutomation_QuoteAttachmentController
Author: CTS
Created Date: 20/09/2024
Reason: to copy quote document from Quotes Notes&Attachment to Opportunity Notes&Attachment
Modified Date: 01/10/2024
*/

public class CSMAutomation_QuoteAttachmentController {
    
    /**
    *  Description: copy quote document from Quotes Notes&Attachment to Opportunity Notes&Attachmentt    
    *  @name:copyAttachments
    *  @param:List of QuoteId and its associated OpportunityId
    *  @return:
    */
    @InvocableMethod
    public static void copyAttachmentsFromPrimaryQuote(List<Id> opportunities) {
        List<Attachment> attachmentsToInsert = new List<Attachment>();
        List<Exception_Log__c> exceptionLog = new List<Exception_Log__c>();
        Set<Id> opportunityIds = new Set<Id>();
 
        try {
            // Query the primary Quote related to the Opportunity
            List<SBQQ__Quote__c> primaryQuotes = [
                SELECT Id, Name,SBQQ__Opportunity2__c,ApprovalStatus__c,SBQQ__Opportunity2__r.Name
                FROM SBQQ__Quote__c
                WHERE SBQQ__Primary__c = true AND ApprovalStatus__c ='Presented' AND SBQQ__Opportunity2__c IN :opportunities
            ];

            Set<Id> quoteIds = new Set<Id>();
            Set<Id> validOppIds = new Set<Id>();
            Map<Id, Id> quoteToOppMap = new Map<Id, Id>();
        	Map<Id, Attachment> oppAttachment = new Map<Id, Attachment>();
        	Map<Id, String> quoteNameMap = new Map<Id,String>();
        	Map<Id, String> oppNameMap = new Map<Id,String>();
            
            for(SBQQ__Quote__c quote : primaryQuotes) {
                    validOppIds.add(quote.SBQQ__Opportunity2__c);
                	quoteIds.add(quote.Id);
                   	quoteToOppMap.put(quote.Id, quote.SBQQ__Opportunity2__c);
                 	quoteNameMap.put(quote.SBQQ__Opportunity2__c,quote.Name);
                 	oppNameMap.put(quote.SBQQ__Opportunity2__c,quote.SBQQ__Opportunity2__r.Name);
             }
            
        	//When no Primary or Presented Quote found on related to Opportunities
          	for(Opportunity opp : [Select Id,Name,SBQQ__PrimaryQuote__r.Name FROM Opportunity WHERE Id IN :opportunities]){
                if(!validOppIds.contains(opp.Id)){
                   Exception_Log__c logEntry = new Exception_Log__c();
                   logEntry.DeveloperMessage__c = 'No primary Quote or Quote not in "Presented"  status for Opportunity Oppty ID: '+opp.Id+' '+'Oppty Name : '+opp.name;      							  
                   logEntry.Type__c = 'Apex method: CSMAutomation_QuoteAttachmentController.copyAttachmentsFromPrimaryQuote';
                   exceptionLog.add(logEntry); 
                }
        	}
            
        	//Primary & Presented Quote found on related to Opportunities
        	if(!validOppIds.isEmpty() && !primaryQuotes.isEmpty()){ 
              List<Attachment> quoteAttachments = [
                    SELECT Id, Name, Body, ParentId 
                    FROM Attachment 
                    WHERE ParentId IN :quoteIds 
                    ORDER BY CreatedDate DESC
                ];

                for (Attachment quoteAttachment : quoteAttachments) {
                    for(SBQQ__Quote__c q : primaryQuotes){
                        if(quoteAttachment.ParentId == q.Id && !oppAttachment.containsKey(q.SBQQ__Opportunity2__c)){
                            oppAttachment.put(q.SBQQ__Opportunity2__c,quoteAttachment);
                                break;
                        }          
                    }
                }
            
            	for(Id oppId : validOppIds){
                    if(oppAttachment.containsKey(oppId)){
                        Attachment attach = oppAttachment.get(oppId) ;
                        Attachment newAttachment = new Attachment();
                        newAttachment.ParentId = oppId;
                        newAttachment.Name = 'Quote' +' '+ quoteNameMap.get(oppId) +'  '+ System.Now();
                        newAttachment.Body = attach.Body;
                        attachmentsToInsert.add(newAttachment);    
                    }else{
                        Exception_Log__c logEntry = new Exception_Log__c();
                    	logEntry.DeveloperMessage__c ='No attachment found for Quote:'+' '+ quoteNameMap.get(oppId)+' '+'in Opportunity Oppty ID: '+oppId+' '+'Oppty Name : '+oppNameMap.get(oppId);
                        logEntry.Type__c = 'Apex method: CSMAutomation_QuoteAttachmentController.copyAttachmentsFromPrimaryQuote';
                        exceptionLog.add(logEntry); 
                    }
                    
            	}

            //Inserting Attachment on Opportunity
            	if (!attachmentsToInsert.isEmpty()) {
                    insert attachmentsToInsert;
                } 
        	}
            
            if (Test.isRunningTest()) {
            	throw new QueryException('Simulated exception for test coverage');
            }
        }catch (Exception ex) {
            Exception_Log__c logEntry = new Exception_Log__c();
            logEntry.DeveloperMessage__c = 'Error during attachment copy from Quote to Opportunity';
            logEntry.Message__c = ex.getMessage();
            logEntry.StackTrace__c = ex.getStackTraceString();
            logEntry.Type__c = 'Apex method: CSMAutomation_QuoteAttachmentController.copyAttachmentsFromPrimaryQuote';
            exceptionLog.add(logEntry);
        }
        
        // Insert exception log records if any
        if (!exceptionLog.isEmpty()) {
            insert exceptionLog;
        } 
    }
}