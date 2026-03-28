public without sharing class CPQQuoteMgr {
    
    public void processAfterSyncUpdate(CameleonCPQ__QuoteContent__c content) {
        system.debug(' ENTERED CPQQuoteMgr.processAfterSyncUpdate');
        // Initialization
           CameleonCPQ__Quote__c quote = retrieveQuote(content);
           Map<String,CameleonQuoteLineItem__c> cqliMap = new Map<String,CameleonQuoteLineItem__c>();

        // Remove old Cameleon Quote Line Items
           try{delete [SELECT id FROM CameleonQuoteLineItem__c WHERE Cameleon_Quote__c =: quote.Id];}catch(Exception e){System.debug('caught quotelines deletion exception');}

       // CPQ Quote processing
       // Get Cameleon quote content XML from Attachment (note '_content' suffix)
          Attachment[] att = [SELECT Id, Name, Body FROM Attachment WHERE parentId =: content.Id AND Name LIKE '%_content'];
          Blob quoContentXML = att[0].Body; 
          
       // Invoke the Parser utility
          CameleonCPQ.CPQParser quoteParser = new CameleonCPQ.CPQParser(quoContentXML);
          CameleonCPQ.CPQParser.Quote parsedQuote = quoteParser.getQuote();
          List<CameleonCPQ.CPQParser.QuoteLine> AllLines = parsedQuote.getAllLines();
          
          boolean Multiyear = false;  //ICOM-68
          Double TotContractValue=Double.valueOf(parsedQuote.getField('TCTotalContractPrice'));
          String quoStatus=parsedQuote.getField('ChangeAndControlTab.CurrentStatus');
          Double TotDiscountPct,TotDiscountAmt,TotPaidAmount,TotCreditAmount = 0.0;
          try{TotDiscountPct=Double.valueOf(parsedQuote.getField('TCDiscPct'));}catch(Exception e){TotDiscountPct = 0.0;}
          try{TotDiscountAmt=Double.valueOf(parsedQuote.getField('TCDiscountAmt'));}catch(Exception e){TotDiscountAmt = 0.0;} 
		  try{TotPaidAmount=Double.valueOf(parsedQuote.getField('TCTotal'));}catch(Exception e){TotPaidAmount = 0.0;} 
		  try{TotCreditAmount=Double.valueOf(parsedQuote.getField('TCAmount'));}catch(Exception e){TotCreditAmount = 0.0;} 

        // Only if quote has an opportunity
        
            if (quote.CPQOpportunityId__c != null) {
                Opportunity opp = [SELECT Id, OwnerId, Pricebook2Id,Total_Contract_Value__c FROM Opportunity WHERE Id =: quote.CPQOpportunityId__c];   
                   
                Id pricebook2Id = opp.Pricebook2Id;
        
                // Assign the Quote pricebook ID in this case 
                 if(pricebook2Id == null) {
                    //Pricebook2 stdpb = [SELECT Id FROM Pricebook2 WHERE IsActive = true];
                    Pricebook2 stdpb = [SELECT Id FROM Pricebook2 WHERE Name = 'Quote Pricebook'];
                    opp.Pricebook2Id = stdpb.Id;
                    pricebook2Id = stdpb.Id;
                }
                    
         /* Commenting the change required for CPQ Primary quote */

                if(quoStatus.equalsIgnoreCase('Released') || quoStatus.equalsIgnoreCase('Presented') || quoStatus.equalsIgnoreCase('Accepted')) {
                  try{delete [SELECT id FROM OpportunityLineItem WHERE OpportunityId =: quote.CPQOpportunityId__c];}catch(Exception e){System.debug('caught opp line deletion exception ');}
                  Pricebook2 quotepb = [SELECT Id, Name FROM Pricebook2 WHERE Name = 'Quote Pricebook' Limit 1];
                    if(opp.Pricebook2Id != quotepb.id){
                        opp.Pricebook2Id = quotepb.id;
                        update opp;
                    }
                }
                
                  Map<String,Product2> productsList = new Map<String,Product2>();
                  Map<String,PriceBookEntry> priceBookEntryList = new Map<String,PriceBookEntry>();
                  Map<String,Double> cartItemsPrices = new Map<String,Double>();
                  List<CameleonQuoteLineItem__c> cqliList = new List<CameleonQuoteLineItem__c>();
                  Map<string,OpportunityLineItem> oliMap = new Map<String,OpportunityLineItem>();
                  List<OpportunityLineItem> oliList = new List<OpportunityLineItem>();
                  
                    for (CameleonCPQ.CPQParser.QuoteLine Line : AllLines) {
                            Map<String,String> m = Line.getColumns();
                            String LineNum = Line.getId();
                            if(m.get('isSFDC').equals('1'))
                            {                                   
                                String parts = m.get('IRRelated');
                                String part0 = '', part1 = '', part2='', part3 = '', part4 = '' ;
                                
                                if(parts.length() > 0){
                                    parts = parts.replace('~', ' ~ ');

                                     part0 = parts.split('~')[0];
                                     part1 = parts.split('~')[1];
                                     part2 = parts.split('~')[2];
                                     part3 = parts.split('~')[3];
                                     part4 = parts.split('~')[4];
                                }
                                                             
                                productsList.put(m.get('ItemNumber'),new Product2(ProductCode= m.get('ItemNumber'), Name = m.get('Description'),
                                Cameleon_External_ID__c= m.get('ItemNumber'), Description= m.get('Description'), Family = m.get('ProductFamily'),
                                ProductType__c = m.get('ProductType'), Product_Sub_Type__c = m.get('ProductSubType'), ISBN10__c = m.get('ISBN10'),MasterProgram__c = m.get('IRPRDMasterProgram'),
                                Business_Line__c = part0.trim(), SupplierId__c = part1.trim(),
                                Install_Base_Tracked__c = part2.trim(), Install_Base_Required__c = part3.trim(), Service_Item_Type_Code__c = part4.trim()));/*,SUPPLEMENT_DESC__c=m.get('SupplementalDescription')));Install_Base_Tracked__c= m.get('')*/
                                
                                System.debug('-- Trying to Parse List Price and Item Number -- ');
                                double ItemListPrice;
                                try{ItemListPrice=Decimal.valueof(m.get('ListPrice'));}catch(Exception e){ItemListPrice=0;}
                                cartItemsPrices.put(m.get('ItemNumber'),ItemListPrice);
                                CameleonQuoteLineItem__c cqli = createCameleonQuoteLineItem(m,LineNum, quote.Id);
                                cqliList.add(cqli); 
                                
                                if(m.get('Optional').equals('1')||m.get('Year1Qty')=='0'){  //Additional check for DE1845 to keep optional QLIs out of OLIs and Opp Amount rollup
                                  //skip creating OLI, so that it is not rolled into Opp Amount rollup
                                }
                                 else{
                                 //if(quoStatus.equalsIgnoreCase('Presented') || quoStatus.equalsIgnoreCase('Accepted')|| quoStatus.equalsIgnoreCase('Validated') || quoStatus.equalsIgnoreCase('Draft')){
                                    OpportunityLineItem oli = createOpportunityLineItem(m, quote.CPQOpportunityId__c);
                                    oliList.add(oli);
                                 //}
                              }
                             
                            }
                        // If Multi-Year Quote, it set's the Quote Payment Term Field to Multi-Year
                        if (String.isNotBlank(m.get('Year1Amt'))&& String.isNotBlank(m.get('Year1Qty'))&& !MultiYear){
                           quote.CPQ_Payment_Terms__c = 'Multi-Year';
                           Multiyear=true;
                        }
                    }
            
            createPricebookEntries(productsList,priceBookEntryList,cartItemsPrices,opp);
            // Insert Cameleon Quote Line Items
            insert cqliList; 

            List<OpportunityLineItem> oliListForPricebook = new List<OpportunityLineItem>();
             // Loop through opp line items 
             for(OpportunityLineItem oli:oliList) {
                 PriceBookEntry pbe = priceBookEntryList.get(oli.ProductCode__c); 
                 if(pbe != null ){
                    oli.PricebookEntryId = pbe.Id;
                    oliListForPricebook.add(oli);
                 }
             }
 
                if(TotDiscountPct != null)
                     quote.TCDiscPct__c = TotDiscountPct * 100;
                  quote.TCDiscountAmt__c = TotDiscountAmt;
                  try{quote.TCAppliedShipping__c = parsedQuote.getField('TCShipping');}catch(Exception e){quote.TCAppliedShipping__c= null;}
                
                 // Mapping quote statuses for approval

                  if(quoStatus.equals('Needs_Review'))
                  {
                    quote.Approval_Reason__c = parsedQuote.getField('CartInfoTab.ApprovalComments');
                    quote.CPQ_Mandatory_Flag__c = parsedQuote.getField('CartInfoTab.MandatoryProductsFlag').equals('1') ? true : false;
                  }
				  else{
					  quote.Approval_Reason__c = parsedQuote.getField('CartInfoTab.ApprovalComments');
				  }
                  
                  quote.CameleonCPQ__Status__c = quoStatus;
                  quote.Non_Standard_Duration__c = parsedQuote.getField('CartInfoTab.ContractLengthFlag').equals('1')? true : false;
				  /**Added as part of W-011824 **/
				  system.debug('TotPaidAmount: '+TotPaidAmount);
				  system.debug('TotCreditAmount: '+TotCreditAmount);
				  quote.TCTotalContractPrice__c = TotPaidAmount;
				  quote.Total_Credit__c = TotCreditAmount;
				  /**Added as part of W-011824 **/
                  update quote;                      
                
                if(quoStatus.equalsIgnoreCase('Released') || quoStatus.equalsIgnoreCase('Presented') || quoStatus.equalsIgnoreCase('Accepted')) {
                    // Loop through all lines to prepare information and populate the Opportunity Line Items Map and the Cameleon Quote Line Items Map (Protection from Governor Limits)
                    insert oliListForPricebook;  
                    update quote;
                    // User Story W-000579.  Prevent changing pricebook until the Quote is in Presented,Accepted or Validated Status
					
					/*Create Dummy Opportunity Line item to capture the total credit as part of W-011824*/
					if(TotCreditAmount > 0.0){
						List<PricebookEntry> priceBookEntry = [select id from PricebookEntry where product2.name = 'Total Credit' and Pricebook2.name = 'Quote Pricebook'];
						system.debug('priceBookEntry size: '+priceBookEntry);
						if(priceBookEntry.size()>0){
							OpportunityLineItem opLine = new OpportunityLineItem();
							opLine.Quantity = 1;
							opLine.Opportunityid = opp.Id;
							opLine.UnitPrice = 0 - TotCreditAmount;
							opLine.PricebookEntryId = priceBookEntry[0].id;
							insert opLine;
						}
					}
										
                   opp.Total_Contract_Value__c = TotContractValue;
                   update opp;
                }
            } 
        system.debug('END CPQQuoteMgr.processAfterSyncUpdate');
    }
    
    public static void createOrderFromReleasedQuote(List<CameleonCPQ__QuoteRelease__c> QuoteReleases) {
        system.debug('  ENTERED CPQQuoteMgr.createOrderFromReleasedQuote');
        Map<Id, CameleonCPQ__QuoteRelease__c> quoteIdToQuoteReleaseMap = new Map<Id, CameleonCPQ__QuoteRelease__c> ();
        List<Order__c> ordersToCreate = new List<Order__c> ();
        List<OrderLineItem__c> orderLineitemsToInsert = new List<OrderLineItem__c> ();
        List<CameleonCPQ__QuoteRelease__c> releasesToUpdate = new List<CameleonCPQ__QuoteRelease__c>();
        Map<Id, Order__c> quoteToOrderMap = new Map<Id, Order__c>();

        Map<Id,CameleonCPQ__Quote__c> quotesToCopy;
        Map<Id,CameleonQuoteLineItem__c> quoteLineItems;

        Map<Id,CameleonQuoteLineItemSite__c> quoteLineItemSites;
        Set<Id> quoteLineItemsWithSites = new Set<Id>();

        for (CameleonCPQ__QuoteRelease__c release: QuoteReleases) {
            if((release.CameleonCPQ__QuoteId__c != null) && (release.Active__c) && (release.Order__c == null)){
                quoteIdToQuoteReleaseMap.put(release.CameleonCPQ__QuoteId__c,release);
            }
        }
        
        if(quoteIdToQuoteReleaseMap.IsEmpty()) {
            return;
        }

        quotesToCopy = new Map<Id,CameleonCPQ__Quote__c> ([SELECT CameleonCPQ__Status__c, CameleonCPQ__AccountId__c, Id,
                                                                CurrencyIsoCode, Deliver_To_Address__c, Deliver_To_Contact__c, 
                                                                TCDiscountAmt__c, Invoice_To_Address__c, Invoice_To_Contact__c, 
                                                                CPQOpportunityId__c, PONumber__c, OwnerId, Ship_To_Address__c, Ship_To_Contact__c, 
                                                                CameleonCPQ__PrimaryContactId__c, Special_Order_Handling__c, Sent_to_OASIS__c, 
                                                                CPQ_Invoice_Email_address__c, TCOriginalSHTotal__c,TCOriginalSHPct__c, Promo_SH_Amount__c, 
                                                                Promo_SH_Percentage__c, TCAppliedShippingPercent__c, TCAppliedShipping__c, SHPromotionCd__c, 
                                                                SHPromotion__c, FinancialAccountNumber__c
                                                        FROM CameleonCPQ__Quote__c
                                                        WHERE Id IN :quoteIdToQuoteReleaseMap.keyset()]);

        quoteLineItems = new Map<Id,CameleonQuoteLineItem__c>([select Account__c, Cameleon_Quote__c, 
                                                                Cameleon_Quote__r.Id, CPQ_Promo_Description__c, CPQ_Promo_Expiration_Date__c, 
                                                                CurrencyIsoCode, DealType__c, Deliver_To_Address__c, Deliver_To_Contact__c, 
                                                                Description__c, Duration__c, DurationUOM__c, Extended_Price__c, 
                                                                Free_Indicator__c, Id, Invoice_To_Address__c, Invoice_To_Contact__c, Name, 
                                                                Net_Price__c, Product__c, ProductForService__c, Quantity__c, FreeQTY__c, Ship_To_Address__c, 
                                                                Ship_To_Contact__c, Sites_Quantity_Roll_Up__c, Unit_Of_Measure__c,Discount_Amount__c, 
                                                                Discount_Percentage__c,Site_Enrollment__c,Line_Item_Product_Grouping__c, ERP_Supplier__c 
                                                                FROM CameleonQuoteLineItem__c 
                                                                WHERE Optional_Ind__c = false AND Cameleon_Quote__r.Id in :quoteIdToQuoteReleaseMap.keyset()]);
        

        quoteLineItemSites = new Map<Id,CameleonQuoteLineItemSite__c>([SELECT Id, Account__c, Quantity__c, Quote_Line_Item__c, Site_Address__c, Site_Contact__c 
                                                                    FROM CameleonQuoteLineItemSite__c 
                                                                    WHERE Quote_Line_Item__c in :quoteLineItems.keyset()]);

        for (CameleonQuoteLineItemSite__c quoteLineItemSite : quoteLineItemSites.values()) {
            quoteLineItemsWithSites.add(quoteLineItemSite.Quote_Line_Item__c);  
        }
        
        for(CameleonCPQ__Quote__c quote : quotesToCopy.values()) {
      
            Order__c order = mapOrderFromQuote(quote, quoteIdToQuoteReleaseMap.get(quote.Id));
            order.Status__c='Approved'; 
            order.OrderType__c = 'Quote';
           
            if (quote.Sent_to_OASIS__c == true) {
              order.Order_Destination__c = 'Oasis'; 
            }
            else {
                order.Order_Destination__c = 'SAP_USK12';
            }
            
            ordersToCreate.add(order);

        }
      
        if (ordersToCreate.size() > 0) {insert ordersToCreate;}

        for(Order__c order : ordersToCreate){
            CameleonCPQ__QuoteRelease__c release = quoteIdToQuoteReleaseMap.get(order.Cameleon_Quote__c);
            release.Order__c = order.Id;
            quoteToOrderMap.put(order.Cameleon_Quote__c, order);
            releasesToUpdate.add(release);
        }

        if (releasesToUpdate.size() > 0) {update releasesToUpdate;}

        Integer olinum = 0;
        for(cameleonquotelineitem__c quoteLineItem : quoteLineItems.values()) {
          
            OrderLineItem__c lineItem = mapOrderLineItemFromQuoteLineItem(quoteLineItem);
            
            if(quoteLineItemsWithSites.contains(quoteLineItem.id)) {
                
                for(cameleonquotelineitemsite__c quoteLineItemSite : quoteLineItemSites.values()) {
                    if(quoteLineItemSite.Quote_Line_Item__c == quoteLineItem.id) {
                        lineItem.Account__c = quoteLineItemSite.Account__c;
                        lineItem.Site__c = quoteLineItemSite.Id;
                        lineItem.ItemQuantity__c = quoteLineItemSite.Quantity__c;
                        lineItem.LineTotal__c = quoteLineItemSite.Quantity__c*quoteLineItem.Net_Price__c;
                        lineItem.DeliverToAddress__c = quoteLineItemSite.Site_Address__c;
                        lineItem.DeliverToContact__c = quoteLineItemSite.Site_Contact__c; 
                        lineItem.Order__c = quoteToOrderMap.get(quoteLineItem.Cameleon_Quote__c).Id;
                        olinum++;
                        lineItem.LineNo__c = olinum;
                        
                        if(!(orderLineItemsToInsert.contains(lineItem))) {orderLineItemsToInsert.add(lineItem);}
                    }
                }
                
                if(quoteLineItem.Quantity__c-quoteLineItem.Sites_Quantity_Roll_Up__c>0) {
                    lineItem.Account__c = quoteLineItem.Account__c;
                    lineItem.ItemQuantity__c = quoteLineItem.Quantity__c-quoteLineItem.Sites_Quantity_Roll_Up__c;
                    lineItem.LineTotal__c = (quoteLineItem.Quantity__c-quoteLineItem.Sites_Quantity_Roll_Up__c)*quoteLineItem.Net_Price__c;
                    lineItem.DeliverToAddress__c = quoteLineItem.Deliver_To_Address__c;
                    lineItem.DeliverToContact__c = quoteLineItem.Deliver_To_Contact__c;
                    lineItem.Order__c = quoteToOrderMap.get(quoteLineItem.Cameleon_Quote__c).Id;
                    olinum++;
                    lineItem.LineNo__c = olinum;
                    
                    if(!(orderLineItemsToInsert.contains(lineItem))) {orderLineItemsToInsert.add(lineItem);}
                }
            }else{
                lineItem.Account__c = quoteLineItem.Account__c;
                lineItem.Order__c = quoteToOrderMap.get(quoteLineItem.Cameleon_Quote__c).Id;
                lineItem.DeliverToAddress__c = quoteLineItem.Deliver_To_Address__c;
                lineItem.DeliverToContact__c = quoteLineItem.Deliver_To_Contact__c;
                lineItem.ItemQuantity__c = quoteLineItem.Quantity__c;
                lineItem.LineTotal__c = quoteLineItem.Extended_Price__c;
                olinum++;
                lineItem.LineNo__c = olinum;
                orderLineItemsToInsert.add(lineItem);
            }
        }
  
        insert orderLineItemsToInsert; 
        system.debug('END CPQQuoteMgr.createOrderFromReleasedQuote');
    }
    
    public static void CPQUpdatePrimaryQuote (List<CameleonCPQ__Quote__c> triggerNew, List<CameleonCPQ__Quote__c> triggerOld){
        
        system.debug('ENTERED CPQQuoteMgr.CPQUpdatePrimaryQuote');
        List<Id> approval_quotes = new List<Id>(); 
        Decimal DecimalRelease;
        String ReleaseNumber;
        Set<Id> oppIdsRelatedToQuotes = new Set<Id>();

        List<Opportunity> oppsToUpdate = new List<Opportunity>();
        Map<Id,Opportunity> oppsRelatedToUpdatedQuotes;
        List<OpportunityLineItem> oppLineItemsRelatedToQuoteOpps;
    
        List<OpportunityLineItem> olisToDelete = new List<OpportunityLineItem>();
        List<OpportunityLineItem> oppLineItemsToDelete = new List<OpportunityLineItem>();
    
        Pricebook2 quotepb = [SELECT Id FROM Pricebook2 WHERE Name = 'Quote Pricebook'];
    
        for(CameleonCPQ__Quote__c quote: triggerNew){
          oppIdsRelatedToQuotes.add(quote.CPQOpportunityId__c); 
        }

        oppsRelatedToUpdatedQuotes = new Map<Id,Opportunity>([SELECT Id,Amount,Total_Contract_Value__c,CPQ_Primary_Quote__c,Pricebook2Id FROM Opportunity WHERE Id IN :oppIdsRelatedToQuotes]);
        oppLineItemsRelatedToQuoteOpps = new List<OpportunityLineItem>([SELECT id, OpportunityId FROM OpportunityLineItem WHERE OpportunityId IN :oppIdsRelatedToQuotes]);
        
        for (Integer i = 0; i < triggerNew.size(); i++) {
          CameleonCPQ__Quote__c newQuote = triggerNew[i];
          CameleonCPQ__Quote__c oldQuote = null;
          
          //if (Trigger.isUpdate) {
            oldQuote = triggerOld[i];
          //}
     
          if(newQuote.CameleonCPQ__ActiveRelease__c != oldQuote.CameleonCPQ__ActiveRelease__c ){
           
              DecimalRelease = newQuote.CameleonCPQ__ActiveRelease__c;
              ReleaseNumber = string.valueof(DecimalRelease.intValue());
              //CPQQuoteRefresher.refresh(newQuote.ID,ReleaseNumber, 'RefreshQuote'); 
          }
          
          if((newQuote.CameleonCPQ__Status__c.equals('Needs_Review') && !oldQuote.CameleonCPQ__Status__c.equals('Needs_Review')) ){
              approval_quotes.add(newQuote.Id);
          }

          if(oppsRelatedToUpdatedQuotes.containsKey(newQuote.CPQOpportunityId__c)){
            Opportunity opp = oppsRelatedToUpdatedQuotes.get(newQuote.CPQOpportunityId__c);  

                if (!newQuote.CameleonCPQ__Status__c.equals('Draft')){
					system.debug('Quote Total amount: '+opp.amount);
					system.debug('Quote Total contract: '+newQuote.TCTotalContractPrice__c);
                    opp.Total_Contract_Value__c = newQuote.TCTotalContractPrice__c;

            
                    if(oldQuote.CPQOpportunityId__c != newQuote.CPQOpportunityId__c ){
                            
                        // Updating the opportunity Pricebook ID 
                        if(opp.Pricebook2Id != quotepb.Id){
                
                            for(OpportunityLineItem li: oppLineItemsRelatedToQuoteOpps){
                                if(li.OpportunityId == opp.Id){
                                    olisToDelete.add(li);
                                }
                            }
                
                            opp.Pricebook2Id = quotepb.Id;
                
                        }
                    }
            
                    oppsToUpdate.add(opp);
                }
                
            }
         
        }
    
        if(!olisToDelete.isEmpty()){
            delete olisToDelete;

        }
    
        if(!oppsToUpdate.isEmpty()){

            update oppsToUpdate;
        }
        
        if(!approval_quotes.isEmpty()){
            Utils.doApprovals(approval_quotes);
        }
        
        system.debug('  END CPQQuoteMgr.CPQUpdatePrimaryQuote');
    }

    public static void CPQCameleonQuoteAfterInsert (List<Id> triggerNewQuoteIds) {

        if(!triggerNewQuoteIds.isEmpty()){
            system.debug(' ENTERED CPQQuoteMgr.CPQCameleonQuoteAfterInsert');
            List<CameleonCPQ__Quote__c> allQuotes = [SELECT CPQOpportunityId__c, CameleonCPQ__AccountId__c,CameleonCPQ__PrimaryContactId__c 
            FROM CameleonCPQ__Quote__c 
            WHERE Id IN: triggerNewQuoteIds];

            List<CameleonCPQ__Quote__c> quotesToUpdate = new List<CameleonCPQ__Quote__c>();
            
            //TODO holy crap, please fix this it's a time bomb for updates and errors.
            for (CameleonCPQ__Quote__c quote : allQuotes) {
            // for (CameleonCPQ__Quote__c quote : trigger.new) {  
                if(quote.CPQOpportunityId__c!= null){
                    Opportunity opp = [SELECT Account.Id, Account.BillingCountry, Owner.Name, Owner.MobilePhone,Owner.Title, Owner.Phone,Owner.Email, Pricebook2Id 
                    FROM Opportunity 
                    WHERE Id =: quote.CPQOpportunityId__c];
                    
                    
                OpportunityContactRole ocr = null;
                try{ocr = [Select Contact.Id 
                    from OpportunityContactRole 
                    where OpportunityId=:quote.CPQOpportunityId__c and IsPrimary = true];}catch(Exception e){}
                
                    if(opp.Account != null){
                        quote.CameleonCPQ__AccountId__c = opp.Account.Id;
                    }
                    
                    if(ocr!=null)
                    {
                        quote.CameleonCPQ__PrimaryContactId__c = ocr.Contact.Id;
                    }
                    

                    quote.CPQ_Future_Pricing_Date__c = Date.today();

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
                if(quote!=null){
                    quotesToUpdate.add(quote);
                }

            }
            
            if(!quotesToUpdate.isEmpty()){
                try{
                  update quotesToUpdate;
                } catch (DMLException e){
                  System.debug('Exception Thrown updating quotes in AfterInsert: ' + e.getMessage());
              }
            }
           
    }
    system.debug(' END OF CPQQuoteMgr.CPQCameleonQuoteAfterInsert');
}
    
    public static void CameleonQuoteBeforeInsert(List<CameleonCPQ__Quote__c> triggerNew, Map<Id,CameleonCPQ__Quote__c> oldMap, boolean isInsert, boolean isUpdate){

    set<Id> OppIds = new set<Id>();
    set<Id> OwnerIds = new set<Id>();
    set<Id> ManagerIds = new set<Id>();
    set<Id> quoteReleaseIds = new set<Id>();

    for (CameleonCPQ__Quote__c cq : triggerNew){
        //if(cq.CameleonCPQ__Status__c == 'Accepted'){
        //    cq.CameleonCPQ__Status__c = 'Released';
        //    quoteReleaseIds.add(cq.Id);
        //}
        
        if(isInsert || (isUpdate 
        && cq.CameleonCPQ__Status__c == 'Needs_Review' 
        && oldMap.get(cq.Id).CameleonCPQ__Status__c <> cq.CameleonCPQ__Status__c)){
            OppIds.add(cq.CPQOpportunityId__c);
            //OwnerIds.add(cq.OwnerId);
        }
    }
    
    if(OppIds.size()>0 && Limits.getLimitQueries()>4){    
        User mdUser = [Select Id from User where Opportunity_Role__c='Managing Director' limit 1]; //Managing Director's User Record
        Id mdId = mdUser.Id; //Managing Director's User Id
        GroupMember DealDeskUser = [Select g.UserOrGroupId, g.Group.Name, g.GroupId From GroupMember g where g.Group.Name='Deal Desk' limit 1];
        id DealDeskId = DealDeskUser.UserOrGroupId;
        
        List<Opportunity> lstOpps = [select Id,OwnerId,Has_Quote__c from Opportunity where Id in :OppIds];
        Map<id,id>OppToOwnerMap = new map<id,id>();
        //List of opportunities to update
        List<Opportunity> updateOpsLst = new list<Opportunity>();
        for(Opportunity o :lstOpps){
            OppToOwnerMap.put(o.Id, o.OwnerId);
            OwnerIds.add(o.OwnerId);
            
            //Update the opportunity and set has quote field to true
            o.Has_Quote__c=TRUE;
            updateOpsLst.add(o);
        }
        
        //Update the opportunity
        if(updateOpsLst.size()>0){
            update updateOpsLst;
        }
        
        Map<id,id>OwnerToManagerMap = new map<id,id>();
        Map<id,String> OwnerToRoleName = new map<id,String>();          // ICOM-1154
        //List<User> OwnersList = [select Id, ManagerId from User where id in :OwnerIds];
        List<User> OwnersList = [Select u.id, u.ManagerId, u.UserRole.Name, u.UserRoleId, u.Name From User u where u.id in :OwnerIds]; //New Soql Query ICOM-1154
        for(User o :OwnersList){
            OwnerToManagerMap.put(o.Id, o.ManagerId);
            ManagerIds.add(o.ManagerId);
            OwnerToRoleName.put(o.Id, o.UserRole.Name);      //ICOM-1154
        }
        
            
        for (CameleonCPQ__Quote__c cq : triggerNew){
            if(isInsert || (isUpdate && cq.CameleonCPQ__Status__c == 'Needs_Review' && oldMap.get(cq.Id).CameleonCPQ__Status__c<>cq.CameleonCPQ__Status__c)){
                id oid = cq.CPQOpportunityId__c; //Quote's Opportunity
                id ooid = OppToOwnerMap.get(oid); //Quote's Opportunity Owner
                string oorn = OwnerToRoleName.get(ooid); // ICOM-1154 - Quote's Opportunity Owner Role Name
                id lmid = OwnerToManagerMap.get(ooid); //Opp Owner's Line Manager
        // Check the Opportunity owner's role for escalation
            if(String.isNotBlank(oorn)){
                if(oorn.contains('SVP') || oorn.contains('VP')){
                cq.First_Level_Manager__c = ooid;
                        cq.Second_Level_Manager__c = ooid;
                }else if(oorn.contains('MGM')){
                    cq.First_Level_Manager__c = ooid;
                   
                   // Line Below are commented out for ICOM-1886
                   //if(lmid <> null){                    
                   //             cq.Second_Level_Manager__c = lmid;
                   // }else{
                                cq.Second_Level_Manager__c = DealDeskId;
                    //}
                }else{
                    if(lmid <> null){
                            cq.First_Level_Manager__c = lmid;
                            //id slmid = ManagerToManager2Map.get(lmid); //Opp Owner's Second Level Manager
                            //    if(slmid <> null){
                            //        cq.Second_Level_Manager__c = slmid;
                            //    }else{
                                 cq.Second_Level_Manager__c = DealDeskId;
                            //    }
                        }else{
                                cq.First_Level_Manager__c = DealDeskId;
                                cq.Second_Level_Manager__c = DealDeskId;
                        }
         
                } 
           }else{
                    if(lmid <> null){
                            cq.First_Level_Manager__c = lmid;
                            //id slmid = ManagerToManager2Map.get(lmid); //Opp Owner's Second Level Manager
                            //    if(slmid <> null){
                            //        cq.Second_Level_Manager__c = slmid;
                            //    }else{
                                 cq.Second_Level_Manager__c = DealDeskId;
                            //    }
                        }else{
                                cq.First_Level_Manager__c = DealDeskId;
                                cq.Second_Level_Manager__c = DealDeskId;
                        }
         //End new If Statement for ICOM-1154
                } 
  
            }
        }
    }
}

    private static OrderLineItem__c mapOrderLineItemFromQuoteLineItem(cameleonquotelineitem__c quoteLineItem) {
        OrderLineItem__c lineItem = new OrderLineItem__c();
        
        lineItem.CameleonQuote__c = quoteLineItem.Cameleon_Quote__c;
        lineItem.CameleonQuoteLineItem__c = quoteLineItem.Id;
        lineItem.CPQ_Promo_Description__c = quoteLineItem.CPQ_Promo_Description__c;
        lineItem.CPQ_Promo_Expiration_Date__c = quoteLineItem.CPQ_Promo_Expiration_Date__c;
        lineItem.CurrencyIsoCode = quoteLineItem.CurrencyIsoCode;
        lineItem.DealType__c = quoteLineItem.DealType__c;
        lineItem.Duration__c = quoteLineItem.Duration__c;
        lineItem.DurationUOM__c = quoteLineItem.DurationUOM__c;
        lineItem.FreeShippingFlag__c = quoteLineItem.Free_Indicator__c;
        lineItem.InvoiceToAddress__c = quoteLineItem.Invoice_To_Address__c;
        lineItem.InvoiceToContact__c = quoteLineItem.Invoice_To_Contact__c;
        lineItem.ItemDescription__c = quoteLineItem.Description__c;
        lineItem.Ordered_Item__c = quoteLineItem.Name;
        lineItem.Price__c = quoteLineItem.Net_Price__c;
        lineItem.Discount_Amount__c = quoteLineItem.Discount_Amount__c;    //ICOM-1390
        lineItem.Discount_Percentage__c = quoteLineItem.Discount_Percentage__c;    //ICOM-1390
        lineItem.Product__c = quoteLineItem.Product__c;
        lineItem.ProductForService__c = quoteLineItem.ProductForService__c;
        lineItem.ShipToAddress__c = quoteLineItem.Ship_To_Address__c;
        lineItem.ShipToContact__c = quoteLineItem.Ship_To_Contact__c;
        lineItem.UnitOfMeasure__c = quoteLineItem.Unit_Of_Measure__c;
        lineItem.Site_Enrollment__c = quoteLineItem.Site_Enrollment__c;
        lineItem.Line_Item_Product_Grouping__c = quoteLineItem.Line_Item_Product_Grouping__c;
        lineItem.Free_Item_Quantity__c = quoteLineItem.FreeQTY__c;
        
        return lineItem;
        
    }
    
    private static Order__c mapOrderFromQuote(CameleonCPQ__Quote__c quote, CameleonCPQ__QuoteRelease__c release){
      
        String appliedSH;  
        //  Code below strips out the comma on the string  
        if(String.isNotBlank(quote.TCAppliedShipping__c)) {
          Pattern appliedSHPattern = Pattern.compile (',');
          appliedSH = appliedSHPattern.matcher(quote.TCAppliedShipping__c).replaceAll('');
              
        }else {
          appliedSH = null;
          
         }
        
        Order__c order = new Order__c ();
        // NEED TO ADD RELEASE Number CAPTURE
        order.Quote_Release_Number__c = release.CameleonCPQ__ReleaseNumber__c;
        order.Quote_Release__c = release.id;
        order.StatusReason__c = quote.CameleonCPQ__Status__c;
        order.Account__c = quote.CameleonCPQ__AccountId__c;
        order.Cameleon_Quote__c = quote.Id;
        order.CurrencyIsoCode = quote.CurrencyIsoCode;
        order.DeliverToAddress__c = quote.Deliver_To_Address__c;
        order.DeliverToContact__c = quote.Deliver_To_Contact__c;
        order.DiscountAmount__c = quote.TCDiscountAmt__c;
        order.InvoiceToAddress__c = quote.Invoice_To_Address__c;
        order.InvoiceToContact__c = quote.Invoice_To_Contact__c;
        order.Opportunity__c = quote.CPQOpportunityId__c;
        order.PONumber__c = quote.PONumber__c;
        order.Salesperson__c = quote.OwnerId;
        order.ShipToAddress__c = quote.Ship_To_Address__c;
        order.ShipToContact__c = quote.Ship_To_Contact__c;
        order.SoldToContact__c = quote.CameleonCPQ__PrimaryContactId__c;
        order.Special_Order_Handling__c = quote.Special_Order_Handling__c;
        order.Sent_to_OASIS__c = quote.Sent_to_OASIS__c;
        order.TransactionNotificationEmail__c = quote.CPQ_Invoice_Email_address__c;
        order.TCOriginalSHTotal__c = quote.TCOriginalSHTotal__c;
        order.TCOriginalSHPct__c = quote.TCOriginalSHPct__c;
        order.TCStandardSHTotal__c = quote.Promo_SH_Amount__c;
        order.TCStandardSHTotalPct__c = quote.Promo_SH_Percentage__c;
        order.TCShippingPercent__c = quote.TCAppliedShippingPercent__c;
        try{order.TCShipping__c = Decimal.valueof(appliedSH);}catch(Exception e){order.TCShipping__c =  null;}
        order.SHPromotionCd__c = quote.SHPromotionCd__c;
        order.SHPromotion__c = quote.SHPromotion__c;
        order.FinancialAccountNumber__c = quote.FinancialAccountNumber__c;
        
        return order;
    }
    
    /**
     * Retrieves the Cameleon Quote related to the specified Quote Content object.
     */
    private CameleonCPQ__Quote__c retrieveQuote(CameleonCPQ__QuoteContent__c content) {
        return [SELECT Id, CPQOpportunityId__c, CPQOpportunityId__r.Pricebook2Id, CameleonCPQ__Status__c
                FROM CameleonCPQ__Quote__c
                WHERE Id =: content.CameleonCPQ__QuoteId__c][0];
    }
    
   // Creation of the Cameleon Quote Line Item
    private  CameleonQuoteLineItem__c createCameleonQuoteLineItem(Map<String,String> m,String LineNum, Id quoteId) {
        CameleonQuoteLineItem__c cqli = new CameleonQuoteLineItem__c();
        String IRRelatedparts = m.get('IRRelated');
        String IRRelatedpart0 = '', IRRelatedpart1 = '', IRRelatedpart2='', IRRelatedpart3 = '', IRRelatedpart4 = '', SiteEnrollment = '' ;
        if(IRRelatedparts.length() > 0){
                IRRelatedparts = IRRelatedparts.replace('~', ' ~ ');
                IRRelatedpart0 = IRRelatedparts.split('~')[0];
                IRRelatedpart1 = IRRelatedparts.split('~')[1];
                IRRelatedpart2 = IRRelatedparts.split('~')[2];
                IRRelatedpart3 = IRRelatedparts.split('~')[3];
                IRRelatedpart4 = IRRelatedparts.split('~')[4];
                try{SiteEnrollment = IRRelatedparts.split('~')[5];}catch(Exception e){SiteEnrollment  = '';}
                
         }
        cqli.ERP_Supplier__c = IRRelatedpart1.trim();
        cqli.Cameleon_Quote__c = quoteId;
        cqli.Name = m.get('ItemNumber');
        cqli.Description__c = m.get('Description');

        try{cqli.Discount_Amount__c = Decimal.valueof(m.get('DiAmt'));}catch(Exception e){cqli.Discount_Amount__c = 0;}                //ICOM-1390
        try{cqli.Discount_Percentage__c = Decimal.valueof(m.get('DiPct'))*100;}catch(Exception e){cqli.Discount_Percentage__c = 0;}           //ICOM-1390

        cqli.Extended_Price__c = Decimal.valueof(m.get('ExtendedPrice'));
        cqli.License_Type__c = m.get('ParentItem');
        cqli.Contract_Price_Updated__c = m.get('ContractPriceUpdated').equals('1') ? true : false;
        try{cqli.List_Price__c = Decimal.valueof(m.get('ListPriceTerm'));}catch(Exception e){cqli.List_Price__c = 0;}          //ICOM-1390
        try{cqli.Contracted_Price__c  = Decimal.valueof(m.get('ContractPriceTerm'));}catch(Exception e){cqli.Contracted_Price__c = 0;}   //ICOM-1390
        cqli.Net_Price__c = Decimal.valueof(m.get('NetPrice')); 

        cqli.Optional_Ind__c = m.get('Optional').equals('1') ? true : false;
        //added by Rob Power to write Product__c to Quote Line Item
        Product2 prodmem = new Product2(Cameleon_External_ID__c=m.get('ItemNumber'));
        cqli.Product__r = prodmem;
        //END added by Rob Power to write Product__c to Quote Line Item
        cqli.Quantity__c = Decimal.valueof(m.get('ItemQty'));

        cqli.FreeQty__c=Decimal.valueof(m.get('FreeQty'));
        cqli.TotalQty__c=Decimal.valueof(m.get('TotalQty'));
        cqli.FreeAmount__c=Decimal.valueof(m.get('FreeAmount'));
        //cqli.StandardCost__c=Decimal.valueof(m.get('StandardCost'));
        try{cqli.StandardCost__c  = Decimal.valueof(m.get('StandardCost'));}catch(Exception e){cqli.StandardCost__c = 0;}
        //ICOM-4335
        try{
            /*if(Decimal.valueof(SiteEnrollment.trim())==0)
                cqli.Site_Enrollment__c = null;
            else
                cqli.Site_Enrollment__c = Decimal.valueof(SiteEnrollment.trim());*/
            if(SiteEnrollment != null && Decimal.valueof(SiteEnrollment.trim()) != 0)
                cqli.Site_Enrollment__c = Decimal.valueof(SiteEnrollment.trim());
            else
                cqli.Site_Enrollment__c = null;
        }catch(Exception e){cqli.Site_Enrollment__c = null;}
        
        cqli.Request_Date__c = parseDate(m.get('ReqDate'));
        cqli.Unit_Of_Measure__c = m.get('UnitOfMeasure');

        cqli.Free_Indicator__c = m.get('FreeInd').equals('1') ? true : false;
        cqli.DealType__c = m.get('DealType');
        cqli.CPQ_Promo_Description__c = m.get('PromotionDescription');
        cqli.CPQ_Promo_Expiration_Date__c = parseExpirationDate(m.get('PromoExpirationDate'));

               try{
            if(m.get('ProductType').equals('Maintenance and Support'))
                cqli.ProductforService__c = m.get('ProductForService');
            else
                cqli.ProductforService__c = '';
        }catch(Exception e){cqli.ProductforService__c = '';}   
        try{cqli.Duration__c = Decimal.valueof(m.get('Term'));}catch(Exception e){cqli.Duration__c = 0;}
        cqli.Line_Number__c = Double.valueOf(LineNum);
        cqli.Line_Item_Product_Grouping__c = m.get('IRGrade');  
        return cqli;
    }
    
    // Creation of the opportunity line item
   private OpportunityLineItem createOpportunityLineItem(Map<String,String> m, Id OpportunityId) {
        
        OpportunityLineItem oli = new OpportunityLineItem();
        oli.OpportunityId = OpportunityId;
        oli.ProductCode__c = m.get('ItemNumber');

        oli.Description = m.get('Description');        
        try{oli.CPQ_List_Price__c  = Decimal.valueof(m.get('ListPriceTerm'));}catch(Exception e){oli.CPQ_List_Price__c = 0;} //ICOM-1390

        oli.CPQ_Exended_Price__c = Double.valueOf(m.get('ExtendedPrice'));
        oli.CPQ_Request_Date__c = parseDate(m.get('ReqDate'));
        oli.DealType__c = m.get('DealType');

       // If Year 1 amount and Quantity is null, the quote is a multi year so the Year 1 amount and Quantity is used
       // and duration is set to 12 in the Opportunity line item
      if (string.isNotBlank(m.get('Year1Amt')) && string.isNotBlank(m.get('Year1Qty'))){
          oli.CPQ_Net_Price__c = Decimal.valueof(m.get('Year1Amt'));
          oli.Quantity = Double.valueof(m.get('Year1Qty'));
		  system.debug('Year amount1: '+Decimal.valueof(m.get('Year1Amt')));
          oli.TotalPrice = Decimal.valueof(m.get('Year1Amt'));
          oli.Duration__c = 12;
         }
        else{
			 system.debug('Year amount2: '+Decimal.valueof(m.get('ExtendedPrice')));
          oli.TotalPrice = Double.valueof(m.get('ExtendedPrice'));
          oli.CPQ_Net_Price__c = Double.valueOf(m.get('NetPrice'));
          oli.Quantity = Double.valueof(m.get('TotalQty'));
          oli.CPQ_Free_QTY__c=Decimal.valueof(m.get('FreeQty'));
           oli.CPQ_Free_Amount__c=Decimal.valueof(m.get('FreeAmount'));
         // oli.CPQ_Standard_Cost__c=Decimal.valueof(m.get('StandardCost'));
            try{oli.CPQ_Standard_Cost__c  = Decimal.valueof(m.get('StandardCost'));}catch(Exception e){oli.CPQ_Standard_Cost__c = 0;}
          try{oli.Duration__c = Decimal.valueof(m.get('Term'));}catch(Exception e){oli.Duration__c = 0;}
      }       
        
        return oli;
    }
  
    private static Date parseDate(String dateString) {
        Date resultDate = null;
        if(dateString.length() > 0){
            Integer y = Integer.valueOf(dateString.substring(0, 4));
            Integer m = Integer.valueOf(dateString.substring(4, 6));
            Integer d = Integer.valueOf(dateString.substring(6, 8));
            resultDate = Date.newinstance(y, m, d);
        }
        return resultDate;
    }
    
    private static Date parseExpirationDate(String dateString) {
        Date resultDate = null;
        if(dateString.length() > 0){
            Integer y = Integer.valueOf(dateString.substring(0, 4));
            Integer m = Integer.valueOf(dateString.substring(5, 7));
            Integer d = Integer.valueOf(dateString.substring(8, 10));
            resultDate = Date.newinstance(y, m, d);
        }
        return resultDate;
    }
    
   //---------------------------------------------------------------------------------//
    // Create Pricebook Entries (single query/insert statement to avoid governor limits)        //
    //---------------------------------------------------------------------------------//

    /*
   private void createPricebookEntries(Map<String,Product2> productsList, Map<String,PriceBookEntry> priceBookEntries,Map<String,Double> cartItemsPrices, sObject opp ){

        Product2[] newProducts = new Product2[0];

        Map<Id, Pricebook2> prosPricebooks;

        Map<Id, Map<String, PriceBookEntry>> pricebookEntriesByPricebook = new Map<Id, Map<String, PriceBookEntry>>();
        List<PriceBookEntry> pricebookEntriesToUpsert = new List<PriceBookEntry>();
        
        for (String pr : productsList.keySet()) {
          if (productsList.get(pr).Id==null ) {
               System.debug(Logginglevel.INFO,'Adding new product with code :'+productsList.get(pr).ProductCode);              
               newProducts.add(productsList.get(pr));
           }
           if (newProducts.size()==200) {
               System.debug(Logginglevel.INFO,'Upserting new products');
               //insert newProducts;
               upsert newProducts Cameleon_External_ID__c;
               newProducts.clear();
           }
        }

        if (!newProducts.isEmpty()) {
           System.debug(Logginglevel.INFO,'Upserting new products');
           upsert newProducts Cameleon_External_ID__c;
        
        }
        
        //TODO if the quote pricebook is aver set to "standard" then this will all break and quotes won't work. this is bad. 

        //1. We have to get a list of all existing products accross both priceboooks that use the product code in the productsList map
        //2. Compare those prices + product codes against what is in the manifest from pros, and remove those that don't need to be updated
        //3. Create new pricebook entries for those that don't exist, this should happen in both pricebooks.
        //4. Update existing pricebook entries whose prices have changed according to PROS

        prosPricebooks = new Map<Id, Pricebook2>([SELECT Id, Name FROM Pricebook2 WHERE IsStandard=true OR Name = 'Quote Pricebook']);

        System.debug('Products list from Manifest' + productsList.keySet());

        List<PriceBookEntry> existingPriceBookEntries = [Select Id, ProductCode, Product2Id, UnitPrice, Pricebook2Id 
                                                            From PriceBookEntry 
                                                            WHERE Pricebook2Id IN :prosPricebooks.keySet() and ProductCode 
                                                            IN :productsList.keySet() AND IsActive = true AND Product2Id != NULL
        ];

        for(Pricebook2 pricebook: prosPricebooks.values()){

            Map<String, PriceBookEntry> pricebookEntriesByProductCode = new Map<String, PriceBookEntry>();

            for(PriceBookEntry pbe: existingPriceBookEntries){
                
                if(pbe.pricebook2Id == pricebook.Id){
                    
                
                    pricebookEntriesByProductCode.put(pbe.ProductCode, pbe);
                }
            }

            pricebookEntriesByPricebook.put(pricebook.Id, pricebookEntriesByProductCode);
        }

        for(Pricebook2 pricebook: prosPricebooks.values()){

            Map<String, PriceBookEntry> existingPricebookEntriesByProductCode = pricebookEntriesByPricebook.get(pricebook.Id);



            for(String pc : productsList.keySet()) {
                PriceBookEntry newPriceBookEntry = new PriceBookEntry(Pricebook2Id= pricebook.Id, Product2Id= productsList.get(pc).Id, UseStandardPrice= false, CurrencyIsoCode='USD', IsActive= true, UnitPrice= cartItemsPrices.get(pc));
                    
                existingPricebookEntriesByProductCode.put(pc, newPriceBookEntry);
                pricebookEntriesToUpsert.add(newPriceBookEntry);
            }

            for (String pc : productsList.keySet()) {

                if (existingPricebookEntriesByProductCode.containsKey(pc)){

                    if(existingPricebookEntriesByProductCode.get(pc).UnitPrice != cartItemsPrices.get(pc)){

                        existingPricebookEntriesByProductCode.get(pc).UnitPrice = cartItemsPrices.get(pc);
                        existingPricebookEntriesByProductCode.get(pc).UseStandardPrice= false;

                        pricebookEntriesToUpsert.add(existingPricebookEntriesByProductCode.get(pc));

                    }

                    priceBookEntries.put(pc,existingPricebookEntriesByProductCode.get(pc));

                } 
            }
        }

        if(!pricebookEntriesToUpsert.isEmpty()){
            //upsert pricebookEntriesToUpsert;

        } 
    }*/


    //---------------------------------------------------------------------------------//
    // Create Pricebook Entries (single query/insert statement to avoid governor limits)        //
    //---------------------------------------------------------------------------------//
   private void createPricebookEntries(Map<String,Product2> productsList, Map<String,PriceBookEntry> priceBookEntryList,Map<String,Double> cartItemsPrices, sObject opp ){

    // Retrieve existing products
    System.debug(Logginglevel.INFO,'Retrieving product information of ['+productsList.keySet().size()+'] items');

    Product2[] newProducts = new Product2[0];
    
    for (String pr : productsList.keySet()) {
      if (productsList.get(pr).Id==null ) {
           System.debug(Logginglevel.INFO,'Adding new product with code :'+productsList.get(pr).ProductCode);              
           newProducts.add(productsList.get(pr));
       }
       if (newProducts.size()==200) {
           System.debug(Logginglevel.INFO,'Upserting new products');
           //insert newProducts;
           upsert newProducts Cameleon_External_ID__c;
           newProducts.clear();
       }
    }

    if (!newProducts.isEmpty()) {
       System.debug(Logginglevel.INFO,'Upserting new products');
       upsert newProducts Cameleon_External_ID__c;
  
    }
    
    System.debug(Logginglevel.INFO,'Retrieving price book information of ['+productsList.keySet().size()+'] items');

    // Depending if opportunity Price Book Id is different than Standard Price book Id, create 2 entries
    //  - One for Standard price book (always)
    //  - One for Opportunity price book (line items will be created with this one)
    // get standard  Pricebook
    
    Pricebook2[] pb = [SELECT Id, Name FROM Pricebook2 where IsStandard=true];
    Id[] pbIds = new Id[0];
    pbIds.add(pb[0].Id);
    
    Schema.DescribeSObjectResult dopp = opp.getSObjectType().getDescribe();     
    Schema.DescribeSObjectResult dpbe = PriceBookEntry.SObjectType.getDescribe(); 
    Schema.SObjectField fcpbe = dpbe.fields.getMap().get('CurrencyIsoCode');

    Pricebook2[] pb1 = [SELECT Id, Name FROM Pricebook2 where Name = 'Quote Pricebook' AND IsActive!=false];
        pbIds.add((pb1[0].Id));


    PriceBookEntry[] updPriceBookEntry = new PriceBookEntry[0];
    for (Integer i = 0; i < pbIds.size(); i++) {
         System.debug(Logginglevel.INFO,'Reading price book entries for ['+pbIds[i]+']');

         priceBookEntryList.clear();
         for (String pc : productsList.keySet())
         {
            SObject newPriceBookEntry = new PriceBookEntry(Pricebook2Id= pbIds[i], Product2Id= productsList.get(pc).Id, UseStandardPrice= false, IsActive= true, UnitPrice= 0);
            if (fcpbe!=null)
                newPriceBookEntry.put(fcpbe,'USD');
            priceBookEntryList.put(productsList.get(pc).ProductCode,(PriceBookEntry)newPriceBookEntry);
         }
         PriceBookEntry[] priceBookEntries= [Select Id, ProductCode, UnitPrice From PriceBookEntry where Pricebook2Id=:pbIds[i] and ProductCode IN :productsList.keySet()];
         for (PriceBookEntry pbe : priceBookEntries)
         {
            priceBookEntryList.put(pbe.ProductCode, pbe);
         }
         
         for (String pc : productsList.keySet())
         {
            System.debug(Logginglevel.INFO,'Adding new price book entry/Updating existing entry for item :'+productsList.get(pc).ProductCode);
            PriceBookEntry pbe = priceBookEntryList.get(pc);
            pbe.UnitPrice = cartItemsPrices.get(pc);
            pbe.IsActive = true;
            updPriceBookEntry.add(pbe);
            if (updPriceBookEntry.size()==200) {
                System.debug(Logginglevel.INFO,'Inserting/Updating price book entries for ['+pbIds[i]+']');
                upsert updPriceBookEntry;
                updPriceBookEntry.clear();
            }
         }
         if (!updPriceBookEntry.isEmpty()) {
             System.debug(Logginglevel.INFO,'Inserting/Updating price book entries for ['+pbIds[i]+']');
             upsert updPriceBookEntry;
         }
    }
}
}