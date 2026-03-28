global class BatchDeleteATMsForTerritoryUser implements 
   Database.Batchable<sObject> {

   global final String query;
   global final String territoryId;
   global final String userId;
   global final String memberRole;
   
   global BatchDeleteATMsForTerritoryUser(String territoryUserId) {
       territoryuser__c tu=[select Territory__c, User__c, TeamMemberRole__c from territoryuser__c where id=:territoryUserId limit 1];
       territoryId = tu.Territory__c;
       userId = tu.User__c;
//       memberRole = tu.TeamMemberRole__c;
       query = 'SELECT Account__c from TerritoryAccount__c where Territory__c=\''+territoryId+'\'';
   }

   global Database.QueryLocator start(Database.BatchableContext BC){
       return Database.getQueryLocator(query);
   }
   
   global void execute(Database.BatchableContext BC, List<TerritoryAccount__c> scope){
       if(scope.size()>0){
           list<id> accountIdsList = new list<id>();
           for(TerritoryAccount__c ta:scope){
               accountIdsList.add(ta.Account__c);
           }
           list<AccountTeamMember> atmsToDelete = [select id from AccountTeamMember where AccountId in :accountIdsList and UserId = :userId];
           if(atmsToDelete.size()>0){
               delete atmsToDelete;
           }
       }
   }

   global void finish(Database.BatchableContext BC){
       AsyncApexJob a = 
           [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,
            TotalJobItems, CreatedBy.Email
            FROM AsyncApexJob WHERE Id =
            :BC.getJobId()];
                          
       // Send an email to the Apex job's submitter 
       //   notifying of job completion. 
       Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
       String[] toAddresses = new String[] {a.CreatedBy.Email};
       mail.setToAddresses(toAddresses);
       mail.setSubject('Territory User to Account Team Member Status: ' + a.Status);
       mail.setPlainTextBody
       ('The batch Apex job processed ' + a.TotalJobItems +
       ' batches with '+ a.NumberOfErrors + ' failures.');
       Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
   }
}