/*
Apex Class:scc_pdfCartController
Author: CTS 
Created Date: 2024-06-08
Reason:
Modified Date:
*/
public without sharing class scc_pdfCartController {
    
    @AuraEnabled
    public static List<CartItem> cartItems {
        get;set;
    }
    @AuraEnabled
    public static List<WebCart> webCartData{
        get;set;
    }
    @AuraEnabled
    public static String creationDate{
        get;set;
    }
    @AuraEnabled
    public static String expirationDate{
        get;set;
    }
    @AuraEnabled
    public static String activeCartId{
        get;set;
    }
    @AuraEnabled
    public static Decimal cartTotalPrice{
        get;set;
    }
    
    @AuraEnabled
    public static User userNameData{
        get;set;
    }
    
    @AuraEnabled public String Line_Item_Number{
            get; set;
     }
    @AuraEnabled public String NetUnit{
            get; set;
     }
    @AuraEnabled public String Total{
            get; set;
     }
    @AuraEnabled public String Quant{
            get; set;
     }
    
     @AuraEnabled
    public static String formattedTotalPrice{
        get;set;
    }
    @AuraEnabled
    public static List<CartItemWrapper> cartwrap
    {
        get; set;
    }
    
    
    public List<CartItem> guestCartItems{get;set;}

    /**
     * Description: Constructor for scc_pdfCartController class. Initializes cart data and user information.
     * @param: none
     * @return: none
     */
    public scc_pdfCartController() {
        guestCartItems = new List<CartItem>();
        Id userId=UserInfo.getUserId();
        userNameData = [Select id,Name from User where id=:userId]; 
        webCartData =[ SELECT Id,Name,CreatedDate,Shipping_City__c,Shipping_Country__c,Shipping_State__c,Shipping_Street__c,Shipping_Zip_Code__c FROM Webcart
                		  WHERE OwnerId=:userId AND Status= :scc_constantHelper.STATUS_ACTIVE AND IsSecondary= :scc_constantHelper.FALSE_VALUE ORDER BY CreatedDate DESC Limit 1];
        activeCartId = webCartData[0].Id;
        creationDate = webCartData[0].createdDate.format('MM-dd-YYYY');
        if(webCartData[0].CreatedDate.month()<=9){
            expirationDate = '09-30-'+ webCartData[0].CreatedDate.year();
        }else{
            expirationDate = '09-30-'+ webCartData[0].CreatedDate.addYears(1).year();
        }
        //expirationDate = '09-30-2024';
        cartItems=[SELECT Id,Line_Item_Number__c, SalesPrice,NetUnitPrice, Price_condition__c, cart.Coupon_Discount__c,cart.ID,cart.Name,Quantity, TotalPrice, Product2.Id, Product2.Availability__c,Product2.Copyright_Year__c, Product2.Grade_Level__c, Product2.ISBN13__c,Product2.Product_Status__c, Product2.Description, Product2.ISBN10__c
                   FROM CartItem
                   WHERE CartId = :webCartData[0].Id];
        guestCartItems=[SELECT Id,Line_Item_Number__c, SalesPrice,NetUnitPrice, Price_condition__c, cart.Coupon_Discount__c,cart.ID,cart.Name,Quantity, TotalPrice, Product2.Id, Product2.Availability__c,Product2.Copyright_Year__c, Product2.Grade_Level__c, Product2.ISBN13__c,Product2.Product_Status__c, Product2.Description, Product2.ISBN10__c
                   FROM CartItem
                   WHERE CartId = :webCartData[0].Id];
        cartTotalPrice=0;
        Line_Item_Number = string.valueof(cartItems[0].Line_Item_Number__c);
        cartwrap = new List<CartItemWrapper>();
     
        for(CartItem item: cartItems){
             cartTotalPrice+= item.TotalPrice;
        
        CartItemWrapper wrapper = new CartItemWrapper();
        wrapper.Id= item.Id;
        wrapper.Description = item.Product2.Description;
        wrapper.ISBN10=item.Product2.ISBN10__c;
        wrapper.ISBN13=item.Product2.ISBN13__c; 
        wrapper.PriceCondition=item.Price_Condition__c;
        wrapper.NetUnit = formatWithCommas(item.NetUnitPrice);      
        wrapper.Total = formatWithCommas(item.TotalPrice);
        wrapper.Quant = formatWithCommas(item.Quantity);
        cartwrap.add(wrapper);
        }
        formattedTotalPrice = formatWithCommas(cartTotalPrice);
    }

    /**
     * Description: Formats a decimal value with commas and two decimal places
     * @param value: The decimal value to be formatted
     * @return: String representation of the formatted decimal value
     */
    public static String formatWithCommas(Decimal value)
    {
        if(value != null)
        {
            return String.valueOf(value.setScale(2)).replaceAll('(\\d)(?=(\\d{3})+\\.)','$1,'); 
        }
        return '0.00';
    }
    
    /**
     * Description: Formats an integer value with commas
     * @param value: The integer value to be formatted
     * @return: String representation of the formatted integer value
     */
    public static String formatWithCommas(Integer value)
    {
        if(value != null)
        {
            return String.valueOf(value).replaceAll('(\\d)(?=(\\d{3})+$)','$1,'); 
        }
        return '0';
    }

    /**
     * Description: Inner class to wrap CartItem details for easier handling
     */
    public class CartItemWrapper {
        @AuraEnabled public Id Id{
            get; set;
        }
		
		 @AuraEnabled public String Description{
            get; set;
        }
         @AuraEnabled public String ISBN10{
            get; set;
        }
         @AuraEnabled public String ISBN13{
            get; set;
        }
         @AuraEnabled public String PriceCondition{
            get; set;
        }
         @AuraEnabled public String NetUnit{
            get; set;
        }
         @AuraEnabled public String Total{
            get; set;
        }
         @AuraEnabled public String Quant{
            get; set;
        }
    }
    
}