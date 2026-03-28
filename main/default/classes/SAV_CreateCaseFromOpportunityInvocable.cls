public class SAV_CreateCaseFromOpportunityInvocable {
    
    @InvocableMethod(label='Create Case from Closed Renewal Opportunity.' description='Creates Case from Opportunity')
    public static void createCaseFromRenewalOpportunity(List<id>OppsToProcess){
        String ownerQueueName;
        String caseRecordType;
        List<Opportunity> oppInfoToCopy = [select Id, AccountId, Owner.Name, Name, Type, Renewal_Contract_ID__c, 
                                           Product_Name__c, NextStep, Description 
                                     from Opportunity 
                                     where Id in :OppsToProcess];
        
        //system.debug('SAV_OpportunityToCase oppInfoToCopy.size is: ' + oppInfoToCopy.size());
        if(oppInfoToCopy.size() < 1){
            system.debug('SAV_OpportunityToCase.createCaseFromRenewalOpportunity received zero length list of Opportunities.');
            return;
        }
        
        List<Case> newCases = new List<Case>();
        
        // The below will cause an exception if the ownerQueueName Group does not exist.
        Group ourQueue = [select Id from Group where Type = 'Queue' AND NAME = 'Intervention System Cleanup' Limit 1];
 
        // Requested by Kimberly Kenia 5-18-2021 - but this Contact did not exist in sandbox, so trying to error-proof.
        List<Contact> caseContact = new List<Contact>();
        caseContact = [select Id from Contact where Id = '0030W00003pzTIxQAM' Limit 1];

        String infoForCase;
        String acctState;
        String acctName;
        Account acctInfo;
        List<Id> opsProcessed = new List<Id>();
        
        for(Opportunity o : oppInfoToCopy){
            //system.debug('oppId: ' + o.Id + ' Opp name: ' + o.Name);
            if(!(opsProcessed.contains(o.Id))){
                opsProcessed.add(o.Id);
                
                acctInfo = [select Id, Name, BillingState from Account where Id =:o.AccountId Limit 1];
                acctName = acctInfo.Name;
                acctState = acctInfo.BillingState;
                infoForCase = 'Opportunity Name: ' + o.Name + '\n Owner: ' + o.Owner.Name + '\n Type: ' + o.Type + '\n Renewal Contract: ';
                infoForCase = infoForCase + o.Renewal_Contract_ID__c + '\n Product: ' + o.Product_Name__c + '\n NextStep: ' + o.NextStep + '\n Description: ' + o.Description;
                
                Case newCase = new Case(OwnerId = ourQueue.Id);
                newCase.AccountId = o.AccountId;
                if(caseContact.size() == 1){
                    newCase.Contact = caseContact.get(0);
                }
                // Requested by Kimberly Kenia 5-18-2021: Origin, Primary & Secondary Descriptors, Subject
                newCase.Origin = 'Internal';
                newCase.Primary_Issue_Descriptor__c = 'Intervention & Services';
                newCase.Secondary_Descriptor__c = 'Cancellation Renewal';
                newCase.Subject = 'Contract # ' + o.Renewal_Contract_ID__c + ' ' + acctName + ' ' + acctState + ' ' + o.Name + ' - Closed/Lost Opportunity';
                newCase.Original_Reference_Number__c = o.Renewal_Contract_ID__c; 
                newCase.Description = infoForCase;
                newCases.add(newCase);
            }
            infoForCase = '';
            acctName = '';
            acctState = '';
        }
        
        if(newCases.size() > 0){
            //system.debug('inserting new cases size: ' + newCases.size());
            insert newCases;
        }
        
        //system.debug('end of create case from opportunity');
    }


}