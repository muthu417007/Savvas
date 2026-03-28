/*
Apex Class:scc_googleAnalyticsController
Author: CTS (Balamurugan)
Created Date: 03/04/2024
Reason: Ability for portal to be linked to Google Analytics and  push applicable events from SFCC to GTM
Modified Date: 16/04/2024
*/
public without sharing class scc_googleAnalyticsController {
    /**
*  Description: This method will fetch cart details     
*  @name: fetchCartDetailsGA
*  @param: Id
*  @return: Map
*/
    @AuraEnabled
    public static Map<String, String> fetchCartDetailsGA(Id cartId){
        Map<String, String> cartDetails = new Map<String, String>();
        Decimal discount = 0.00;
        Decimal shipping = 0.00;
        Decimal subTotal = 0.00;
        Decimal tax = 0.00;
        Decimal subTotalReviewCart= 0.00;
        List<WebCart> cart = [Select id,TotalProductAmount,Coupon_Discount__c,Coupon__c,Shipping_Amount__c,cart_item_tax_total__c, cart_Id__c, Site_Id__c, API_Source__c from WebCart where Id=:cartId LIMIT 1];
        
        if(cart[0].Coupon__c != ''){
            cartDetails.put('Coupon', cart[0].Coupon__c); 
        }
        if(cart[0].Coupon_Discount__c != null){
            discount = (cart[0].Coupon_Discount__c).setScale(2, System.RoundingMode.HALF_UP);
            cartDetails.put('CouponDiscount', String.valueof(cart[0].Coupon_Discount__c)); 
        }
        if(cart[0].TotalProductAmount != null  && cart[0].Coupon_Discount__c != null){
            subTotal = (cart[0].TotalProductAmount +math.abs(cart[0].Coupon_Discount__c)).setScale(2, System.RoundingMode.HALF_UP);
            cartDetails.put('SubTotal', String.valueof(subTotal)); 
        }else{
            subTotal = (cart[0].TotalProductAmount).setScale(2, System.RoundingMode.HALF_UP);
            cartDetails.put('SubTotal', String.valueof(subTotal)); 
        }
        if(cart[0].Shipping_Amount__c != null){
            shipping = (cart[0].Shipping_Amount__c).setScale(2, System.RoundingMode.HALF_UP);
            cartDetails.put('ShippingAmount', String.valueof(cart[0].Shipping_Amount__c)); 
        }
        if(cart[0].cart_item_tax_total__c != 0 && cart[0].cart_item_tax_total__c != null){
            tax = (cart[0].cart_item_tax_total__c).setScale(2, System.RoundingMode.HALF_UP);
            cartDetails.put('Tax', String.valueof(cart[0].cart_item_tax_total__c)); 
        }
        if(cart[0].TotalProductAmount != null){
            cartDetails.put('subTotalReviewCart', String.valueof(cart[0].TotalProductAmount));
        }
        Decimal finalAmount = cart[0].TotalProductAmount+ shipping + tax;
        cartDetails.put('Total', String.valueof(finalAmount));
        cartDetails.put('CartId', String.valueOf(cart[0].cart_Id__c)); 
        cartDetails.put('SiteId', String.valueOf(cart[0].Site_Id__c)); 
        cartDetails.put('SiteName', String.valueOf(cart[0].API_Source__c)); 
        cartDetails.put('Total', String.valueof(finalAmount));
        return cartDetails;
    }
    /**
*  Description: This method will fetch order item details 
*  @name: fetchOrderItemDetails
*  @param: Id
*  @return: List
*/
    @AuraEnabled
    public static List<OrderItemWrapper> fetchOrderItemDetails(Id ordrId){
        List<OrderItem> ordritem = [Select id,Order.OrderNumber, Product2.ISBN13__c,Product2.ISBN10__c,OrderId,Product2.ProductCode,ISBN__c,SAP_Order_Item_status__c,UnitPrice,ListPrice,Discount__c,Quantity,Product2Id,Product2.Name,Requested_Delivery_Date__c,Product2.Availability__c,Product2.MasterProgram__c, Shipping_amount__c, Tax__c  from OrderItem Where OrderId=: ordrId];
        
        List<OrderItemWrapper> orderItemsWrap = new List<OrderItemWrapper>();
        Boolean siopIsbn = false;
        String IsbnValues = system.label.scc_OrderDetail_SIOP_ISBNs;
        try{
            
            for(OrderItem oi:ordritem){
                OrderItemWrapper wrapper1 = new OrderItemWrapper();
                wrapper1.id = oi.id;
                wrapper1.orderNumber = oi.Order.OrderNumber;
                wrapper1.OrderId = oi.OrderId;
                wrapper1.ISBN = oi.ISBN__c;
                wrapper1.ISBN13 = oi.Product2.ISBN13__c;
                wrapper1.ISBN10 = oi.Product2.ISBN10__c;
                wrapper1.SAP_Order_Item_status = oi.SAP_Order_Item_status__c;
                wrapper1.UnitPrice = oi.UnitPrice;
                wrapper1.ListPrice = oi.ListPrice;
                wrapper1.Discount = oi.Discount__c;
                wrapper1.Quantity = oi.Quantity;
                wrapper1.Product2Id = oi.Product2Id;
                wrapper1.Name = oi.Product2.Name;
                wrapper1.siopOrder = false; 
                wrapper1.Requested_Delivery_Date = oi.Requested_Delivery_Date__c;
                wrapper1.Availability = oi.Product2.Availability__c;
                wrapper1.programName = oi.Product2.MasterProgram__c;
                wrapper1.shippingAmount = oi.Shipping_amount__c;
                wrapper1.tax = oi.Tax__c;
                
                orderItemsWrap.add(wrapper1);
            }
        }catch(Exception e){
            System.debug(scc_constantHelper.EXCEPTION_TYPE_CAUGHT+ e.getTypeName());    
            System.debug(scc_constantHelper.MESSAGE+ e.getMessage());    
            System.debug(scc_constantHelper.CAUSE+ e.getCause());    // returns null
            System.debug(scc_constantHelper.LINE_NUMBER + e.getLineNumber());    
            System.debug(scc_constantHelper.STACK_RACE+ e.getStackTraceString());
            throw new AuraHandledException('Failed to fetch order item details :'+e.getMessage()+e.getCause());
        }
        return orderItemsWrap;
    }
    
    /**
*  Description: This method will get cart items GA
*  @name: getCartItemsGA
*  @param: Id
*  @return: List
*/
    @AuraEnabled(cacheable=true)
    public static list<cartItem> getCartItemsGA(Id cartId){
        return [Select Product2.ISBN10__c, Product2.ISBN13__c, Product2.Name, Quantity, Product2.MasterProgram__c  from cartItem Where Cart.Id =:cartId];       
    }
    
    /**
*  Description: This method create wrapper
*  @name: OrderItemWrapper
*  @param: NA
*  @return: NA
*/
    public class OrderItemWrapper{
        @AuraEnabled public Id id;
        @AuraEnabled public String orderNumber;
        @AuraEnabled public Id OrderId;
        @AuraEnabled public String ISBN;
        @AuraEnabled public String ISBN13;
        @AuraEnabled public String ISBN10;
        @AuraEnabled public String SAP_Order_Item_status;
        @AuraEnabled public Decimal UnitPrice;
        @AuraEnabled public Decimal ListPrice;
        @AuraEnabled public Decimal Quantity;
        @AuraEnabled public String Product2Id;
        @AuraEnabled public String Name;
        @AuraEnabled public Decimal Discount;
        @AuraEnabled public Boolean siopOrder;
        @AuraEnabled public Date Requested_Delivery_Date;
        @AuraEnabled public String Availability;
        @AuraEnabled public String programName;
        @AuraEnabled public decimal shippingAmount;
        @AuraEnabled public decimal tax;
    }
    
}