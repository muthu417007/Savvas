public class CreateOrderFromQuoteInvocable {
  
    Static Map<Id,CameleonCPQ__QuoteRelease__c> quoteReleases =  new Map<Id,CameleonCPQ__QuoteRelease__c>();
    
    @InvocableMethod(label='Create Order from Released Quote.' description='Creates Orders and Line Items from Quote')
    public static void createOrderFromReleasedQuote(List<CameleonCPQ__QuoteRelease__c> QuoteReleases) {
        
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
                                                                WHERE Cameleon_Quote__r.Id in :quoteIdToQuoteReleaseMap.keyset()]);
        

        quoteLineItemSites = new Map<Id,CameleonQuoteLineItemSite__c>([SELECT Id, Account__c, Quantity__c, Quote_Line_Item__c, Site_Address__c, Site_Contact__c 
                                                                    FROM CameleonQuoteLineItemSite__c 
                                                                    WHERE Quote_Line_Item__c in :quoteLineItems.keyset()]);

        for (CameleonQuoteLineItemSite__c quoteLineItemSite : quoteLineItemSites.values()) {
            quoteLineItemsWithSites.add(quoteLineItemSite.Quote_Line_Item__c);  
            
        }
        
        for(CameleonCPQ__Quote__c quote : quotesToCopy.values()) {
      
            Order__c order = mapOrderFromQuote(quote, quoteIdToQuoteReleaseMap.get(quote.Id));
            
			order.Status__c='Approved'; 
            
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
                        
                        lineItem.Account__c=quoteLineItemSite.Account__c;
                        lineItem.Site__c=quoteLineItemSite.Id;
                        lineItem.ItemQuantity__c=quoteLineItemSite.Quantity__c;
                        lineItem.LineTotal__c=quoteLineItemSite.Quantity__c*quoteLineItem.Net_Price__c;
                        lineItem.DeliverToAddress__c=quoteLineItemSite.Site_Address__c;
                        lineItem.DeliverToContact__c=quoteLineItemSite.Site_Contact__c; 
                        lineItem.Order__c=quoteToOrderMap.get(quoteLineItem.Cameleon_Quote__c).Id;
                        olinum++;
                        lineItem.LineNo__c=olinum;
                        
                        if(!(orderLineItemsToInsert.contains(lineItem))) {orderLineItemsToInsert.add(lineItem);}
                        
                    }
                }
                
                if(quoteLineItem.Quantity__c-quoteLineItem.Sites_Quantity_Roll_Up__c>0) {
  
                    lineItem.Account__c=quoteLineItem.Account__c;
                    lineItem.ItemQuantity__c=quoteLineItem.Quantity__c-quoteLineItem.Sites_Quantity_Roll_Up__c;
                    lineItem.LineTotal__c=(quoteLineItem.Quantity__c-quoteLineItem.Sites_Quantity_Roll_Up__c)*quoteLineItem.Net_Price__c;
                    lineItem.DeliverToAddress__c=quoteLineItem.Deliver_To_Address__c;
                    lineItem.DeliverToContact__c=quoteLineItem.Deliver_To_Contact__c;
                    lineItem.Order__c=quoteToOrderMap.get(quoteLineItem.Cameleon_Quote__c).Id;
                    olinum++;
                    lineItem.LineNo__c=olinum;
                    
                    if(!(orderLineItemsToInsert.contains(lineItem))) {orderLineItemsToInsert.add(lineItem);}
                }
            }
            
            else{
                
                lineItem.Account__c=quoteLineItem.Account__c;
                lineItem.Order__c=quoteToOrderMap.get(quoteLineItem.Cameleon_Quote__c).Id;
                lineItem.DeliverToAddress__c=quoteLineItem.Deliver_To_Address__c;
                lineItem.DeliverToContact__c=quoteLineItem.Deliver_To_Contact__c;
                lineItem.ItemQuantity__c=quoteLineItem.Quantity__c;
                lineItem.LineTotal__c=quoteLineItem.Extended_Price__c;
                olinum++;
                lineItem.LineNo__c=olinum;
  
                orderLineItemsToInsert.add(lineItem);
            }
            
        }
  
        insert orderLineItemsToInsert; 

  }
    
    
    private static OrderLineItem__c mapOrderLineItemFromQuoteLineItem(cameleonquotelineitem__c quoteLineItem) {
        OrderLineItem__c lineItem = new OrderLineItem__c();
        
        
        lineItem.CameleonQuote__c=quoteLineItem.Cameleon_Quote__c;
        lineItem.CameleonQuoteLineItem__c=quoteLineItem.Id;
        lineItem.CPQ_Promo_Description__c=quoteLineItem.CPQ_Promo_Description__c;
        lineItem.CPQ_Promo_Expiration_Date__c=quoteLineItem.CPQ_Promo_Expiration_Date__c;
        lineItem.CurrencyIsoCode=quoteLineItem.CurrencyIsoCode;
        lineItem.DealType__c=quoteLineItem.DealType__c;

        lineItem.Duration__c=quoteLineItem.Duration__c;
        lineItem.DurationUOM__c=quoteLineItem.DurationUOM__c;
        lineItem.FreeShippingFlag__c=quoteLineItem.Free_Indicator__c;
        lineItem.InvoiceToAddress__c=quoteLineItem.Invoice_To_Address__c;
        lineItem.InvoiceToContact__c=quoteLineItem.Invoice_To_Contact__c;
		lineItem.ItemDescription__c=quoteLineItem.Description__c;
		
		lineItem.Ordered_Item__c=quoteLineItem.Name;
		lineItem.Price__c=quoteLineItem.Net_Price__c;
		lineItem.Discount_Amount__c=quoteLineItem.Discount_Amount__c;    //ICOM-1390
		lineItem.Discount_Percentage__c=quoteLineItem.Discount_Percentage__c;    //ICOM-1390
		lineItem.Product__c=quoteLineItem.Product__c;
		lineItem.ProductForService__c=quoteLineItem.ProductForService__c;
		lineItem.ShipToAddress__c=quoteLineItem.Ship_To_Address__c;
		lineItem.ShipToContact__c=quoteLineItem.Ship_To_Contact__c;
		lineItem.UnitOfMeasure__c=quoteLineItem.Unit_Of_Measure__c;
		lineItem.Site_Enrollment__c=quoteLineItem.Site_Enrollment__c;
		lineItem.Line_Item_Product_Grouping__c=quoteLineItem.Line_Item_Product_Grouping__c;
        
        if (quoteLineItem.ERP_Supplier__C != 'Oracle_EBS') {
        	lineItem.Free_Item_Quantity__c = quoteLineItem.FreeQTY__c; //CharlesTeague July 2019
        }

       
        
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
        
        order.Quote_Release__c = release.id;
        
        order.StatusReason__c = quote.CameleonCPQ__Status__c;
        order.Account__c=quote.CameleonCPQ__AccountId__c;
        order.Cameleon_Quote__c=quote.Id;
        order.CurrencyIsoCode=quote.CurrencyIsoCode;
        order.DeliverToAddress__c=quote.Deliver_To_Address__c;
        order.DeliverToContact__c=quote.Deliver_To_Contact__c;
        order.DiscountAmount__c=quote.TCDiscountAmt__c;
        order.InvoiceToAddress__c=quote.Invoice_To_Address__c;
        order.InvoiceToContact__c=quote.Invoice_To_Contact__c;
        order.Opportunity__c=quote.CPQOpportunityId__c;
        order.PONumber__c=quote.PONumber__c;
        order.Salesperson__c=quote.OwnerId;
        order.ShipToAddress__c=quote.Ship_To_Address__c;
        order.ShipToContact__c=quote.Ship_To_Contact__c;
        order.SoldToContact__c=quote.CameleonCPQ__PrimaryContactId__c;
        order.Special_Order_Handling__c=quote.Special_Order_Handling__c;
        order.Sent_to_OASIS__c=quote.Sent_to_OASIS__c;
        order.TransactionNotificationEmail__c=quote.CPQ_Invoice_Email_address__c;
        order.TCOriginalSHTotal__c=quote.TCOriginalSHTotal__c;
        order.TCOriginalSHPct__c=quote.TCOriginalSHPct__c;
        order.TCStandardSHTotal__c=quote.Promo_SH_Amount__c;
        order.TCStandardSHTotalPct__c=quote.Promo_SH_Percentage__c;
        order.TCShippingPercent__c=quote.TCAppliedShippingPercent__c;
        try{order.TCShipping__c=Decimal.valueof(appliedSH);}catch(Exception e){order.TCShipping__c= null;}
        order.SHPromotionCd__c=quote.SHPromotionCd__c;
        order.SHPromotion__c=quote.SHPromotion__c;
        order.FinancialAccountNumber__c=quote.FinancialAccountNumber__c;
        
        return order;
        
    }
}