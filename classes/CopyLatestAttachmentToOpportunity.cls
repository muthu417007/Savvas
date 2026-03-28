public without sharing class CopyLatestAttachmentToOpportunity {
    
    /*public class QuoteIdsWrapper {
        @InvocableVariable(required=true)
        public List<Id> quoteIds;
        
    }*/
    
   @InvocableMethod
    public static void copyAttachments(List<Id> quoteIds) {
        List<Attachment> attachmentsToInsert = new List<Attachment>();
        List<Exception_Log__c> exceptionLog = new List<Exception_Log__c>();
        
        //List<Id> quoteIds = quoteIdsWrapperList[0].quoteIds;
        System.debug('quoteIds => ' + quoteIds);

        try {
            // Retrieve the Quotes based on the passed IDs
            List<SBQQ__Quote__c> quotes = [SELECT Id, SBQQ__Opportunity2__c, Quote_Name_Override__c
                                           FROM SBQQ__Quote__c 
                                           WHERE Id IN :quoteIds];

            System.debug('Quotes => ' + quotes);

            for (SBQQ__Quote__c q : quotes) {
                if (q.SBQQ__Opportunity2__c != null) {
                    Attachment latestAttachment = null;

                    // Try to get the most recent Attachment where the name matches Quote_Name_Override__c + '.pdf'
                    if (q.Quote_Name_Override__c != null) {
                        String attachmentNameWithPdf = q.Quote_Name_Override__c + '.pdf';
                        System.debug('Searching for attachment with name: ' + attachmentNameWithPdf);

                        List<Attachment> matchingAttachments = [SELECT Id, Name, Body, CreatedDate 
                                                                FROM Attachment 
                                                                WHERE ParentId = :q.Id 
                                                                AND Name = :attachmentNameWithPdf
                                                                ORDER BY CreatedDate DESC 
                                                                LIMIT 1];
                        
                        if (!matchingAttachments.isEmpty()) {
                            System.debug('Found matching attachment for Quote_Name_Override__c + ".pdf"...');
                            latestAttachment = matchingAttachments[0];
                        }
                    }

                    // If no matching attachment, get the most recent attachment regardless of name
                    if (latestAttachment == null) {
                        System.debug('No matching attachment, fetching the most recent attachment...');
                        List<Attachment> allAttachments = [SELECT Id, Name, Body, CreatedDate 
                                                           FROM Attachment 
                                                           WHERE ParentId = :q.Id
                                                           ORDER BY CreatedDate DESC 
                                                           LIMIT 1];

                        if (!allAttachments.isEmpty()) {
                            latestAttachment = allAttachments[0];
                        }
                    }

                    // Process the attachment (either matched or the most recent)
                    if (latestAttachment != null) {
                        System.debug('Processing Attachment...');
                        Attachment newAttachment = new Attachment();
                        newAttachment.ParentId = q.SBQQ__Opportunity2__c;  // Link to the Opportunity
                        newAttachment.Name = latestAttachment.Name;
                        newAttachment.Body = latestAttachment.Body;
                        attachmentsToInsert.add(newAttachment);
                    } else {
                        System.debug('No attachment found for Quote ID: ' + q.Id);
                    }
                } else {
                    System.debug('Opportunity is missing for Quote ID: ' + q.Id);
                }
            }

            // Insert the new Attachments into the related Opportunities
            if (!attachmentsToInsert.isEmpty()) {
                System.debug('Inserting attachments: ' + attachmentsToInsert);
                insert attachmentsToInsert;
            } else {
                System.debug('No attachments to insert.');
            }

        } catch (Exception ex) {
            System.debug('Error in CopyLatestAttachmentToOpportunity: ' + ex.getMessage());
            Exception_Log__c logEntry = new Exception_Log__c();
            logEntry.DeveloperMessage__c = 'Error occurred while copying the latest Quote attachment to the related Opportunity.';
            logEntry.Message__c = ex.getMessage();
            logEntry.StackTrace__c = ex.getStackTraceString();
            logEntry.Type__c = 'Apex Method: CopyLatestAttachmentToOpportunity.copyAttachments';
            exceptionLog.add(logEntry);
        }

        // Insert exception log records if any exceptions occurred
        if (!exceptionLog.isEmpty()) {
            insert exceptionLog;
            System.debug('Inserted exception logs: ' + exceptionLog);
        }
    }
}