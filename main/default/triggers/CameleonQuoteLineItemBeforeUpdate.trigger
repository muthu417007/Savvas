trigger CameleonQuoteLineItemBeforeUpdate on CameleonQuoteLineItem__c (before insert,before update,after update,after Insert) {
    set<id> quoteset = new set<id>();
    for(CameleonQuoteLineItem__c qli : Trigger.New){
        quoteset.add(qli.Cameleon_Quote__c);
    }
    integer numQueries = Limits.getQueries();
    if(numQueries<100){
//        map<Id,CameleonCPQ__Quote__c> quotemap = new map<Id,CameleonCPQ__Quote__c>([select Id,CameleonCPQ__AccountId__c,CameleonCPQ__ParentAccountId__c from CameleonCPQ__Quote__c where id in:quoteset]);
        map<Id,CameleonCPQ__Quote__c> quotemap = new map<Id,CameleonCPQ__Quote__c>([select Id,CameleonCPQ__AccountId__c from CameleonCPQ__Quote__c where id in:quoteset]);        
        for(CameleonQuoteLineItem__c qli : Trigger.New){
            CameleonCPQ__Quote__c quote = quotemap.get(qli.Cameleon_Quote__c);
            if(string.isBlank(qli.Account__c)){
                qli.Account__c=quote.CameleonCPQ__AccountId__c;
            }
//            qli.ParentAccount__c=quote.CameleonCPQ__ParentAccountId__c;
        }
    }
    if(Trigger.isAfter){
        if(Trigger.isInsert || Trigger.isUpdate){
             List<CameleonCPQ__Quote__c> QuoteToUpdate= new List<CameleonCPQ__Quote__c>();
      map<Id,CameleonCPQ__Quote__c> quotemap1 = new map<Id,CameleonCPQ__Quote__c>([select Id,FreeQTYofQLI__c,ProductTypeofProduct__c from CameleonCPQ__Quote__c where id in:quoteset]);        
        for(CameleonQuoteLineItem__c qli : Trigger.New){
            CameleonCPQ__Quote__c quote = quotemap1.get(qli.Cameleon_Quote__c);
           
                quote.FreeQTYofQLI__c=qli.FreeQTY__c;
                quote.ProductTypeofProduct__c=qli.ProductTypeID__c;
                QuoteToUpdate.add(quote);
                
            
          //qli.ParentAccount__c=quote.CameleonCPQ__ParentAccountId__c;
        }
        System.debug('Test: '+QuoteToUpdate.size());
        System.debug('Test: '+QuoteToUpdate);
        if(QuoteToUpdate.size()>0){
            try{
                update QuoteToUpdate;
            }catch(exception e){
                System.debug(e.getMessage());
            }
           
        }
            
        }
    }
    /*Inactive product addition restriction to Quote
    if(Trigger.isBefore && Trigger.isInsert){
        for(CameleonQuoteLineItem__c qli : Trigger.New){
            if(!qli.Product__r.IsActive){
                qli.addError('Product is Inactive!!! Choose active one');
            }
        }
    }*/
}