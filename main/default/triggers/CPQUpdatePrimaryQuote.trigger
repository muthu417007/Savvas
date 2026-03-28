trigger CPQUpdatePrimaryQuote on CameleonCPQ__Quote__c (after update) {
    List<Id> approval_quotes = new List<Id>(); 
    
    Decimal DecimalRelease;
    
    String ReleaseNumber;
    
    for (Integer i = 0; i < Trigger.new.size(); i++) {
        CameleonCPQ__Quote__c newQuote = Trigger.new[i];
        CameleonCPQ__Quote__c oldQuote = null;
      
        if (Trigger.isUpdate) {
          oldQuote = Trigger.old[i];
        }
 

       if((newQuote.CameleonCPQ__Status__c.equals('Approved') && !oldQuote.CameleonCPQ__Status__c.equals('Approved'))||(newQuote.Name !=oldQuote.Name )){
          DecimalRelease = newQuote.CameleonCPQ__ActiveRelease__c;
          ReleaseNumber = string.valueof(DecimalRelease.intValue());
           CPQQuoteRefresher.refresh(newQuote.ID,ReleaseNumber, 'RefreshQuote');
      }
      
       if((newQuote.CameleonCPQ__Status__c.equals('Needs_Review') && !oldQuote.CameleonCPQ__Status__c.equals('Needs_Review')) ){
          approval_quotes.add(newQuote.Id);
      }

        if(oldQuote.CPQOpportunityId__c != newQuote.CPQOpportunityId__c)
              {
                Opportunity opp = [SELECT Id,CPQ_Primary_Quote__c,Pricebook2Id FROM Opportunity WHERE Id =: newQuote.CPQOpportunityId__c][0];
                // Updating the opportunity Pricebook ID 
                Pricebook2 quotepb = [SELECT Id FROM Pricebook2 WHERE Name = 'Quote Pricebook'];
                if(opp.Pricebook2Id != quotepb.Id)
                {
                    try{delete [SELECT id FROM OpportunityLineItem WHERE OpportunityId =: newQuote.CPQOpportunityId__c];}catch(Exception e){System.debug('caught opp line deletion exception ');}
                    opp.Pricebook2Id = quotepb.Id;
                    update opp;
                }
              }
      //if(oldQuote != null && oldQuote.CPQ_Primary_Quote__c != newQuote.CPQ_Primary_Quote__c )
      /*
      if(oldQuote != null)
      {
          CameleonCPQ__Quote__c[] quotes = [SELECT Id FROM CameleonCPQ__Quote__c WHERE CPQ_Primary_Quote__c =true AND CPQOpportunityId__c =: newQuote.CPQOpportunityId__c];
          //System.debug('ATR : quote size' + quotes.size());           
          /*  
            if(quotes.size() == 0){
            oldQuote.CPQ_Primary_Quote__c=true;
            update oldQuote;
            }
          */
        /*  
        System.debug('ATR : No active quote0'); 
        if (newQuote.CPQ_Primary_Quote__c && newQuote.CPQOpportunityId__c != null) {
            Opportunity opp = [SELECT Id,CPQ_Primary_Quote__c,Pricebook2Id FROM Opportunity WHERE Id =: newQuote.CPQOpportunityId__c][0];
            
            System.debug('ATR : primary is true');    
              
              /* Check if the Primary quote is being cloned against a different opportunity ID */
              /*
              if(oldQuote.CPQOpportunityId__c != newQuote.CPQOpportunityId__c)
              {
                // Updating the opportunity Pricebook ID 
                Pricebook2 quotepb = [SELECT Id FROM Pricebook2 WHERE Name = 'Quote Pricebook'];
                System.debug(Logginglevel.INFO,'Opportunity Pricebook is '+opp.Pricebook2Id);
                System.debug(Logginglevel.INFO,'Quote Pricebook is '+quotepb);
                if(opp.Pricebook2Id != quotepb.Id)
                {
                    try{delete [SELECT id FROM OpportunityLineItem WHERE OpportunityId =: newQuote.CPQOpportunityId__c];}catch(Exception e){System.debug('caught opp line deletion exception ');}
                    opp.Pricebook2Id = quotepb.Id;
                }
                if (opp.CPQ_Primary_Quote__c != null && opp.CPQ_Primary_Quote__c != newQuote.Id) 
                {
                    CameleonCPQ__Quote__c oldPrimaryQuote = [SELECT Id FROM CameleonCPQ__Quote__c WHERE Id =: opp.CPQ_Primary_Quote__c][0];
                    oldPrimaryQuote.CPQ_Primary_Quote__c = false;
                    update oldPrimaryQuote;
                }
                opp.CPQ_Primary_Quote__c = newQuote.Id;
                update opp;
              }
            
            // Update the primary quote for the related opportunity if the primary quote flag is set to true explicitly for that quote         
            if(oldQuote.CPQ_Primary_Quote__c != newQuote.CPQ_Primary_Quote__c) 
            {
                if(!CPQValidator_cls.hasAlreadyDone()){    
                
                      try{
                            CameleonCPQ__QuoteContent__c content = [SELECT Id,CameleonCPQ__QuoteId__c,Name FROM CameleonCPQ__QuoteContent__c WHERE CameleonCPQ__QuoteId__c =: newQuote.Id][0];
                                
                            CPQQuoteMgr mgr = new CPQQuoteMgr();
                            mgr.processAfterSyncUpdate(content);
                            
                            System.debug('ATR : update primary quote: ' + content.CameleonCPQ__QuoteId__c);
                        }
                            
                        catch(Exception e)
                        {
                              System.debug('ATR : error could not update opportunity');
                         }
                CPQValidator_cls.setAlreadyDone();}
                
                if (opp.CPQ_Primary_Quote__c != null && opp.CPQ_Primary_Quote__c != newQuote.Id) {
                  CameleonCPQ__Quote__c oldPrimaryQuote = [SELECT Id FROM CameleonCPQ__Quote__c WHERE Id =: opp.CPQ_Primary_Quote__c][0];
                  oldPrimaryQuote.CPQ_Primary_Quote__c = false;
                  update oldPrimaryQuote;
                } 
                
                  opp.CPQ_Primary_Quote__c = newQuote.Id;
                  update opp;
              }
        }
    }
    */
    }
    
    if(!approval_quotes.isEmpty()){
        Utils.doApprovals(approval_quotes);
    }
}