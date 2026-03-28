/**
* Email services are automated processes that use Apex classes
* to process the contents, headers, and attachments of inbound
* email.
*/
global class OpportunityUpdateFrmEmailController implements Messaging.InboundEmailHandler {
    
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
        
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
        
        String subToCompare = 'Notice of Update on Opportunity';
        
        if(String.isNotBlank(email.subject) && email.subject.containsIgnoreCase(subToCompare))
        {
            
            // Retrieves content from the email. 
            // Splits each line by the terminating newline character
            // and looks for the position of the Opportunity ID, stage, amount and description
            Boolean updateOpp=False;
            String[] emailBody = email.plainTextBody.split('~\n', 0);

            // Assign body of email to variables
            String notice = emailBody[0];
            String acc = emailBody[1].substringAfter(': ');
            String oppName = emailBody[2].substringAfter(': ');
            String oppContact = emailBody[3].substringAfter(': ');
            String stage = emailBody[4].substringAfter(': ');
            String prob = emailBody[5].substringAfter(': ');
            Date closeDate = date.parse(emailBody[6].substringAfter(': '));
            Decimal Amount = Decimal.valueof(emailBody[7].substringAfter(': $').replaceAll('[^.\\d]',''));
            String renewalAttach=emailBody[8].substringAfter(': ');
            String Id = emailBody[9].substringAfter(': ');
            String oppOwner = emailBody[10].substringAfter(': ');
            String oppOwnerEmail = emailBody[11].substringAfter(': ');
            String BBBOppId = emailBody[12].substringAfter(': ');
            String Link = emailBody[13].substringAfter(': ');
            String currentDateTime=system.now().format();
           
            string oppDescription = 'Contact: '+oppContact+ +'\n'
                +'Opp Owner: '+oppOwner+' '+oppOwnerEmail+'\n'
                +Link+'\n';
                
         	//Convert BBB Opportunity Stages to Learning Services Stages
            if(stage.containsIgnoreCase('Qualified')){
                stage='Prospect';
            }else if(stage.containsIgnoreCase('Needs Assesment')){
                stage='Initial Solutioning';
            }else if(stage.containsIgnoreCase('Presentation')){
                stage='Formal Presentation';
            }else if(stage.containsIgnoreCase('Proposal') || stage.containsIgnoreCase('Final Negotiation')){
                stage='Short Listed';
            }else if(stage.containsIgnoreCase('Commitment')){
                stage='Verbal Commitment';
            }else if(stage.containsIgnoreCase('Closed Won')){
                stage='Closed Won';
            }else if(stage.containsIgnoreCase('Closed Lost')){
                stage='Closed Lost';
            }
            
            // Try to look up any Opportunity based on the ID on the email body
            // If there is no Opportunity matching the Id provided,
            // an exception will be thrown and the catch statement will be called.
            try {
                Opportunity opp = [SELECT Id, StageName,Amount,Description,closeDate,Has_Quote__c,Name
                                   FROM Opportunity
                                   WHERE Id = :Id and Name like '%BBB%'
                                   LIMIT 1];
                list<OpportunityLineItem> oppProd=[select ID, OpportunityId,Unitprice,PricebookentryId,PricebookEntry.Name from opportunitylineitem where opportunityId=:opp.Id];
                
                if(opp.StageName!=Stage){
                	opp.StageName=stage;
                    updateOpp=True;
                }
                
                if(opp.CloseDate!=closeDate){
                    opp.CloseDate=closeDate;
                    updateOpp=True;
                }
                
                if(oppProd.isEmpty() && opp.Amount!=Amount){
                    opp.Amount=Amount;
                    updateOpp=True;
                }else if(oppProd.size()==1 && opp.Amount!=Amount  && opp.Has_Quote__c==false){
                    // If the opportunity has a product, update the product price
                    oppProd[0].UnitPrice=Amount;
                    update oppProd[0];
                }else{
                    oppDescription=oppDescription+'Amount: '+Amount+'\n';
                    updateOpp=True;
                }
                
                // Only update the opportunity if one of the field's was updated
                if(updateOpp){
                	opp.Description=oppDescription+'Last Updated:'+currentDateTime;
                    update opp;
                }
                
            }
            // If an exception occurs when the query accesses 
            // the Opportunity record, a QueryException is called.
            // An Exception email is sent to members of the ICOM Admin Public Group.
            catch (QueryException e) {
                sendEmailerror(Id);
            }
        }
        
        result.success = true;
        return result;
    }
    
    // Send email to integration admin public group that there was an errors
    public static void sendEmailError(String Id){
        List<string> toAddresses=new List<string>();
        
        for(user u:[select email from user where isActive=true and id in (select userorgroupid from groupmember where group.name like '%ICOM Admin%')]){
            toAddresses.add(u.email);
        }
        if(toAddresses.size()>0){
            
            Messaging.SingleEmailMessage mail=new Messaging.SingleEmailMessage();
            mail.setToAddresses(toAddresses);
            mail.setReplyTo('donotreply.customersupport@pearson.com	');
            mail.setSenderDisplayName('Do Not Reply');
            mail.setSubject('ERROR: Failed to update opportunity from BBB');
            mail.setPlainTextBody('Error updating the Opportunity '+Id);
            
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
        
    }
}