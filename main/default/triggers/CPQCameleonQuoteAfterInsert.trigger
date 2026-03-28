trigger CPQCameleonQuoteAfterInsert on CameleonCPQ__Quote__c (after insert) {
    
     List<CameleonCPQ__Quote__c> allQuotes = [SELECT CPQOpportunityId__c, CameleonCPQ__AccountId__c,CameleonCPQ__PrimaryContactId__c FROM CameleonCPQ__Quote__c WHERE Id IN: Trigger.newMap.keySet()];
     

     for (CameleonCPQ__Quote__c quote : allQuotes) {
     // for (CameleonCPQ__Quote__c quote : trigger.new) {  
        if(quote.CPQOpportunityId__c!= null){
            Opportunity opp = [SELECT Account.Id, Account.BillingCountry, Owner.Name, Owner.MobilePhone,Owner.Title, Owner.Phone,Owner.Email, Pricebook2Id FROM Opportunity WHERE Id =: quote.CPQOpportunityId__c];
             
        // Updating the opportunity Pricebook ID 
        // User Story W-000579.  Prevent changing pricebook until the Quote is in Presented Status
        // Pricebook2 quotepb = [SELECT Id, Name FROM Pricebook2 WHERE Name = 'Quote Pricebook' Limit 1];
        // if(opp.Pricebook2Id != quotepb.Id)
        // {
        //    try{delete [SELECT id FROM OpportunityLineItem WHERE OpportunityId =: quote.CPQOpportunityId__c];}catch(Exception e){System.debug('caught opp line deletion exception ');}
        //    opp.Pricebook2Id = quotepb.Id;
        //    update opp;
        // }
            
         OpportunityContactRole ocr = null;
         try{ocr = [Select Contact.Id from OpportunityContactRole where OpportunityId=:quote.CPQOpportunityId__c and IsPrimary = true];}catch(Exception e){}
         
         
         // Updating the opportunity Primary quote
         /*
         if(opp.CPQ_Primary_Quote__c != null)
         {
            CameleonCPQ__Quote__c oldPrimaryQuote = [SELECT Id FROM CameleonCPQ__Quote__c WHERE Id =: opp.CPQ_Primary_Quote__c][0];
            oldPrimaryQuote.CPQ_Primary_Quote__c = false;
            update oldPrimaryQuote;
         }
         opp.CPQ_Primary_Quote__c = quote.Id;
         update opp;
         */
         
            if(opp.Account != null){
                quote.CameleonCPQ__AccountId__c = opp.Account.Id;
            }
            if(ocr!=null)
            {
                quote.CameleonCPQ__PrimaryContactId__c = ocr.Contact.Id;
            }
            
            //quote.CPQ_Future_Pricing_Date__c = System.now();
            quote.CPQ_Future_Pricing_Date__c = Date.today();
            //quote.CPQ_Primary_Quote__c = true;
            quote.AEName__c=opp.Owner.Name;
            quote.AETitle__c=opp.Owner.Title;
            quote.AEPhone__c=opp.Owner.Phone;  
            quote.AECell__c=opp.Owner.MobilePhone;
            quote.AEEmail__c=opp.Owner.Email;
            quote.CPQ_Quote_Creation_Date__c = System.now();
         }else{
             quote.CPQ_Future_Pricing_Date__c = Date.today();
             quote.CPQ_Quote_Creation_Date__c = System.now();
         }
         
          update quote;
    } 
 }