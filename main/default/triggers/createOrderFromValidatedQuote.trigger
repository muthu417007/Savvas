trigger createOrderFromValidatedQuote on CameleonCPQ__Quote__c (after update) {

    Map<Id,CameleonCPQ__Quote__c> qmap=new map<id,cameleoncpq__quote__c>();         //Map list of quotes that need an order created
    Map<Id,CameleonCPQ__Quote__c> quotemap=new map<id,cameleoncpq__quote__c>();     //Map list of quotes thats already been validated and Sent to Oasis was recently checked
    for(CameleonCPQ__Quote__c q:Trigger.new){
        if(q.CameleonCPQ__Status__c=='Validated'){
            if (trigger.oldmap.get(q.id).CameleonCPQ__Status__c<>'Validated'){
                qmap.put(q.id,q);
            }
            If(q.Sent_to_OASIS__c == True && trigger.oldmap.get(q.id).CameleonCPQ__Status__c=='Validated'){
                If (trigger.oldmap.get(q.id).Sent_to_OASIS__c<>True){
                    quotemap.put(q.id,q);
                }       
            }
        }
    }
    list<id> qids = new list<id>(qmap.keyset());
    Map<Id,CameleonQuoteLineItem__c> qlimap = new map<id,cameleonquotelineitem__c>([select Account__c, Cameleon_Quote__c, Cameleon_Quote__r.Id, CPQ_Promo_Description__c, CPQ_Promo_Expiration_Date__c,CurrencyIsoCode, DealType__c, Deliver_To_Address__c, Deliver_To_Contact__c, Description__c, Duration__c, DurationUOM__c, Extended_Price__c, Free_Indicator__c, Id, Invoice_To_Address__c, Invoice_To_Contact__c, Name, Net_Price__c, Product__c, ProductForService__c, Quantity__c, Ship_To_Address__c, Ship_To_Contact__c, Sites_Quantity_Roll_Up__c, Unit_Of_Measure__c,Discount_Amount__c,Discount_Percentage__c,Site_Enrollment__c,Line_Item_Product_Grouping__c,ERP_Supplier__c from CameleonQuoteLineItem__c where Cameleon_Quote__r.Id in :qids]);
    list<id> qliids = new list<id>(qlimap.keyset());
    Map<Id,CameleonQuoteLineItemSite__c> qlismap = new map<id,CameleonQuoteLineItemSite__c>([select Id, Account__c, Quantity__c, Quote_Line_Item__c, Site_Address__c, Site_Contact__c from CameleonQuoteLineItemSite__c where Quote_Line_Item__c in :qliids]);
    Set<Id> qliidswithsites  = new set<Id>();
    for (CameleonQuoteLineItemSite__c qlis:qlismap.values()) {
     qliidswithsites.add(qlis.Quote_Line_Item__c);   
    }
    list<order__c> olist = new list<order__c>();
    list<order__c> olist2 = new list<order__c>();       // Second order list to handle IR orders
    String appliedSH;    
    //  Create Orders from Quotes
    for(id qid:qids){
        //  Code below strips out the comma on the string  
        If(String.isNotBlank(qmap.get(qid).TCAppliedShipping__c)){
            Pattern appliedSHPattern = Pattern.compile (',');
            appliedSH = appliedSHPattern.matcher(qmap.get(qid).TCAppliedShipping__c).replaceAll('');
        }Else{
            appliedSH = null;
        }
      // End Code to strip out the comma on the string
      If(qmap.get(qid).Count_Oracle_Products__c > 0){
        Order__c o = new Order__c();
        o.Account__c=qmap.get(qid).CameleonCPQ__AccountId__c;
        o.Cameleon_Quote__c=qid;
        o.CurrencyIsoCode=qmap.get(qid).CurrencyIsoCode;
        o.DeliverToAddress__c=qmap.get(qid).Deliver_To_Address__c;
        o.DeliverToContact__c=qmap.get(qid).Deliver_To_Contact__c;
        o.DiscountAmount__c=qmap.get(qid).TCDiscountAmt__c;
        o.InvoiceToAddress__c=qmap.get(qid).Invoice_To_Address__c;
        o.InvoiceToContact__c=qmap.get(qid).Invoice_To_Contact__c;
        o.Opportunity__c=qmap.get(qid).CPQOpportunityId__c;
        o.PONumber__c=qmap.get(qid).PONumber__c;
        o.Salesperson__c=qmap.get(qid).OwnerId;
        o.ShipToAddress__c=qmap.get(qid).Ship_To_Address__c;
        o.ShipToContact__c=qmap.get(qid).Ship_To_Contact__c;
        o.SoldToContact__c=qmap.get(qid).CameleonCPQ__PrimaryContactId__c;
        o.Special_Order_Handling__c=qmap.get(qid).Special_Order_Handling__c;
        o.Sent_to_OASIS__c=qmap.get(qid).Sent_to_OASIS__c;
        o.Order_Destination__c = 'Oracle';
        o.Status__c='New';
        o.TransactionNotificationEmail__c=qmap.get(qid).CPQ_Invoice_Email_address__c;
        o.TCOriginalSHTotal__c=qmap.get(qid).TCOriginalSHTotal__c;
        o.TCOriginalSHPct__c=qmap.get(qid).TCOriginalSHPct__c;
        o.TCStandardSHTotal__c=qmap.get(qid).Promo_SH_Amount__c;
        o.TCStandardSHTotalPct__c=qmap.get(qid).Promo_SH_Percentage__c;
        o.TCShippingPercent__c=qmap.get(qid).TCAppliedShippingPercent__c;
        try{o.TCShipping__c=Decimal.valueof(appliedSH);}catch(Exception e){o.TCShipping__c= null;}
        o.SHPromotionCd__c=qmap.get(qid).SHPromotionCd__c;
        o.SHPromotion__c=qmap.get(qid).SHPromotion__c;
        o.FinancialAccountNumber__c=qmap.get(qid).FinancialAccountNumber__c;
        olist.add(o);
        }
    If(qmap.get(qid).Count_IR_Products__c > 0){
        Order__c o2 = new Order__c();
        o2.Account__c=qmap.get(qid).CameleonCPQ__AccountId__c;
        o2.Cameleon_Quote__c=qid;
        o2.CurrencyIsoCode=qmap.get(qid).CurrencyIsoCode;
        o2.DeliverToAddress__c=qmap.get(qid).Deliver_To_Address__c;
        o2.DeliverToContact__c=qmap.get(qid).Deliver_To_Contact__c;
        o2.DiscountAmount__c=qmap.get(qid).TCDiscountAmt__c;
        o2.InvoiceToAddress__c=qmap.get(qid).Invoice_To_Address__c;
        o2.InvoiceToContact__c=qmap.get(qid).Invoice_To_Contact__c;
        o2.Opportunity__c=qmap.get(qid).CPQOpportunityId__c;
        o2.PONumber__c=qmap.get(qid).PONumber__c;
        o2.Salesperson__c=qmap.get(qid).OwnerId;
        o2.ShipToAddress__c=qmap.get(qid).Ship_To_Address__c;
        o2.ShipToContact__c=qmap.get(qid).Ship_To_Contact__c;
        o2.SoldToContact__c=qmap.get(qid).CameleonCPQ__PrimaryContactId__c;
        o2.Special_Order_Handling__c=qmap.get(qid).Special_Order_Handling__c;
        o2.Sent_to_OASIS__c=qmap.get(qid).Sent_to_OASIS__c;
        o2.Status__c='New';
        o2.Order_Destination__c = 'Oasis';
        o2.TransactionNotificationEmail__c=qmap.get(qid).CPQ_Invoice_Email_address__c;
        o2.TCOriginalSHTotal__c=qmap.get(qid).TCOriginalSHTotal__c;
        o2.TCOriginalSHPct__c=qmap.get(qid).TCOriginalSHPct__c;
        o2.TCStandardSHTotal__c=qmap.get(qid).Promo_SH_Amount__c;
        o2.TCStandardSHTotalPct__c=qmap.get(qid).Promo_SH_Percentage__c;
        o2.TCShippingPercent__c=qmap.get(qid).TCAppliedShippingPercent__c;
        try{o2.TCShipping__c=Decimal.valueof(appliedSH);}catch(Exception e){o2.TCShipping__c= null;}
        o2.SHPromotionCd__c=qmap.get(qid).SHPromotionCd__c;
        o2.SHPromotion__c=qmap.get(qid).SHPromotion__c;
        o2.FinancialAccountNumber__c=qmap.get(qid).FinancialAccountNumber__c;
        olist2.add(o2);
        }
    }
    insert olist;
    insert olist2;

    map<id,id> quoteToOrderMap = new map<id,id>();
    for(Order__c o:olist){
        quoteToOrderMap.put(o.Cameleon_Quote__c,o.id);
    }
    map<id,id> quoteToOrder2Map = new map<id,id>();
    for(Order__c o:olist2){
        quoteToOrder2Map.put(o.Cameleon_Quote__c,o.id);
    }
    
    list<orderlineitem__c> olilist = new list<orderlineitem__c>();
    integer olinum=0;
    //Creates Order Line Items from Quote Line Items    
    for(cameleonquotelineitem__c qli:qlimap.values()){
        if(qliidswithsites.contains(qli.id)){
            for(cameleonquotelineitemsite__c qlis : qlismap.values()){
                if(qlis.Quote_Line_Item__c == qli.id){
                    OrderLineItem__c oli = new OrderLineItem__c();
                    oli.Account__c=qlis.Account__c;
                    oli.CameleonQuote__c=qli.Cameleon_Quote__c;
                    oli.CameleonQuoteLineItem__c=qli.Id;
                    oli.CPQ_Promo_Description__c=qli.CPQ_Promo_Description__c;
                    oli.CPQ_Promo_Expiration_Date__c=qli.CPQ_Promo_Expiration_Date__c;
                    oli.CurrencyIsoCode=qli.CurrencyIsoCode;
                    oli.DealType__c=qli.DealType__c;
                    oli.DeliverToAddress__c=qlis.Site_Address__c;
                    oli.DeliverToContact__c=qlis.Site_Contact__c;
                    oli.Duration__c=qli.Duration__c;
                    oli.DurationUOM__c=qli.DurationUOM__c;
                    oli.FreeShippingFlag__c=qli.Free_Indicator__c;
                    oli.InvoiceToAddress__c=qli.Invoice_To_Address__c;
                    oli.InvoiceToContact__c=qli.Invoice_To_Contact__c;
                    oli.ItemDescription__c=qli.Description__c;
                    oli.ItemQuantity__c=qlis.Quantity__c;
                    oli.LineTotal__c=qlis.Quantity__c*qli.Net_Price__c;
                    If (qli.ERP_Supplier__C == 'Oracle_EBS')
                        oli.Order__c=quoteToOrderMap.get(qli.Cameleon_Quote__c);      
                    Else 
                        oli.Order__c=quoteToOrder2Map.get(qli.Cameleon_Quote__c);
                    oli.Ordered_Item__c=qli.Name;
                    oli.Price__c=qli.Net_Price__c;
                    oli.Discount_Amount__c=qli.Discount_Amount__c;    //ICOM-1390
                    oli.Discount_Percentage__c=qli.Discount_Percentage__c;    //ICOM-1390
                    oli.Product__c=qli.Product__c;
                    oli.ProductForService__c=qli.ProductForService__c;
                    oli.ShipToAddress__c=qli.Ship_To_Address__c;
                    oli.ShipToContact__c=qli.Ship_To_Contact__c;
                    oli.Site__c=qlis.Id;
                    oli.UnitOfMeasure__c=qli.Unit_Of_Measure__c;
                    oli.Site_Enrollment__c=qli.Site_Enrollment__c;
                    oli.Line_Item_Product_Grouping__c=qli.Line_Item_Product_Grouping__c;
                    olinum++;
                    oli.LineNo__c=olinum;
                    olilist.add(oli);
                }
            }
            if(qli.Quantity__c-qli.Sites_Quantity_Roll_Up__c>0){
                OrderLineItem__c oli = new OrderLineItem__c();
                oli.Account__c=qli.Account__c;
                oli.CameleonQuote__c=qli.Cameleon_Quote__c;
                oli.CameleonQuoteLineItem__c=qli.Id;
                oli.CPQ_Promo_Description__c=qli.CPQ_Promo_Description__c;
                oli.CPQ_Promo_Expiration_Date__c=qli.CPQ_Promo_Expiration_Date__c;
                oli.CurrencyIsoCode=qli.CurrencyIsoCode;
                oli.DealType__c=qli.DealType__c;
                oli.DeliverToAddress__c=qli.Deliver_To_Address__c;
                oli.DeliverToContact__c=qli.Deliver_To_Contact__c;
                oli.Duration__c=qli.Duration__c;
                oli.DurationUOM__c=qli.DurationUOM__c;
                oli.FreeShippingFlag__c=qli.Free_Indicator__c;
                oli.InvoiceToAddress__c=qli.Invoice_To_Address__c;
                oli.InvoiceToContact__c=qli.Invoice_To_Contact__c;
                oli.ItemDescription__c=qli.Description__c;
                oli.ItemQuantity__c=qli.Quantity__c-qli.Sites_Quantity_Roll_Up__c;
                oli.LineTotal__c=(qli.Quantity__c-qli.Sites_Quantity_Roll_Up__c)*qli.Net_Price__c;
                If (qli.ERP_Supplier__C == 'Oracle_EBS')
                        oli.Order__c=quoteToOrderMap.get(qli.Cameleon_Quote__c);       
                    Else 
                        oli.Order__c=quoteToOrder2Map.get(qli.Cameleon_Quote__c);
                oli.Ordered_Item__c=qli.Name;
                oli.Price__c=qli.Net_Price__c;
                oli.Discount_Amount__c=qli.Discount_Amount__c;    //ICOM-1390
                oli.Discount_Percentage__c=qli.Discount_Percentage__c;    //ICOM-1390
                oli.Product__c=qli.Product__c;
                oli.ProductForService__c=qli.ProductForService__c;
                oli.ShipToAddress__c=qli.Ship_To_Address__c;
                oli.ShipToContact__c=qli.Ship_To_Contact__c;
                oli.UnitOfMeasure__c=qli.Unit_Of_Measure__c;
                oli.Site_Enrollment__c=qli.Site_Enrollment__c;
                oli.Line_Item_Product_Grouping__c=qli.Line_Item_Product_Grouping__c;
                olinum++;
                oli.LineNo__c=olinum;
                olilist.add(oli);
            }
        }else{
        OrderLineItem__c oli = new OrderLineItem__c();
        oli.Account__c=qli.Account__c;
        oli.CameleonQuote__c=qli.Cameleon_Quote__c;
        oli.CameleonQuoteLineItem__c=qli.id;
        oli.CPQ_Promo_Description__c=qli.CPQ_Promo_Description__c;
        oli.CPQ_Promo_Expiration_Date__c=qli.CPQ_Promo_Expiration_Date__c;
        oli.CurrencyIsoCode=qli.CurrencyIsoCode;
        oli.DealType__c=qli.DealType__c;
        oli.DeliverToAddress__c=qli.Deliver_To_Address__c;
        oli.DeliverToContact__c=qli.Deliver_To_Contact__c;
        oli.Duration__c=qli.Duration__c;
        oli.DurationUOM__c=qli.DurationUOM__c;
        oli.FreeShippingFlag__c=qli.Free_Indicator__c;
        oli.InvoiceToAddress__c=qli.Invoice_To_Address__c;
        oli.InvoiceToContact__c=qli.Invoice_To_Contact__c;
        oli.ItemDescription__c=qli.Description__c;
        oli.ItemQuantity__c=qli.Quantity__c;
        oli.LineTotal__c=qli.Extended_Price__c;
        If (qli.ERP_Supplier__C == 'Oracle_EBS')
              oli.Order__c=quoteToOrderMap.get(qli.Cameleon_Quote__c);
        Else 
              oli.Order__c=quoteToOrder2Map.get(qli.Cameleon_Quote__c);
        oli.Ordered_Item__c=qli.Name;
        oli.Price__c=qli.Net_Price__c;
        oli.Discount_Amount__c=qli.Discount_Amount__c;    //ICOM-1390
        oli.Discount_Percentage__c=qli.Discount_Percentage__c;    //ICOM-1390
        oli.Product__c=qli.Product__c;
        oli.ProductForService__c=qli.ProductForService__c;
        oli.ShipToAddress__c=qli.Ship_To_Address__c;
        oli.ShipToContact__c=qli.Ship_To_Contact__c;
        oli.UnitOfMeasure__c=qli.Unit_Of_Measure__c;
        oli.Site_Enrollment__c=qli.Site_Enrollment__c;
        oli.Line_Item_Product_Grouping__c=qli.Line_Item_Product_Grouping__c;
        olinum++;
        oli.LineNo__c=olinum;
        olilist.add(oli);
        }
    }
    insert olilist;
    
    //Update the Order status if quote was already validated and Send to Oasis field was checked
    list<id> quoteids = new list<id>(quotemap.keyset());
    Map<Id,Order__c> ordermap = new map<id,Order__c>([select Sent_to_OASIS__c,Status__c,Cameleon_Quote__r.Id from Order__c where Cameleon_Quote__r.Id in :quoteids and Order_Destination__c='Oasis']);
    list<order__c> o2uplist = new list<order__c>();
    for(Order__c ord:ordermap.values()){
        If(ord.Status__c<>'Approved'){
            ord.Sent_to_OASIS__c = True;
            o2uplist.add(ord);
        }
    }
    update o2uplist;
}