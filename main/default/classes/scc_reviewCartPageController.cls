/**************************************************************************************** 
* @Class Name  - scc_reviewCartPageController
* @description - Class to get items on review cart page
* @Created By  - CTS-Muthukumar
* @Created On - 2024-05-14
* ***************************************************************************************/ 
public without sharing class scc_reviewCartPageController {
    /********************************************************************** 
Class Name :  reviewCartWrapper
Description : common wrapper class to return data
Input       : NA
Return type : NA
***********************************************************************/ 
    public class reviewCartWrapper{
        
        @AuraEnabled public Id cartId;
        @AuraEnabled public String description;
        @AuraEnabled public String isbn;
        @AuraEnabled public String copyRight;
        @AuraEnabled public String gradeLevel;
        @AuraEnabled public Decimal price;
        @AuraEnabled public String status;
        @AuraEnabled public String stockAvailability;
        @AuraEnabled public decimal quantity;
        @AuraEnabled public decimal totalPrice;
        @AuraEnabled public String cartName;
        @AuraEnabled public String webCartId;
        @AuraEnabled public String PriceCondition;
        @AuraEnabled public Decimal discount;
        
    }
    /********************************************************************** 
Method Name :  getActiveCartItems
Description :  Method to get active cart items list
Input       :  NA
Return type :  List
***********************************************************************/ 
    @AuraEnabled
    public static List<reviewCartWrapper> getActiveCartItems(String guestCartId){
        List<reviewCartWrapper> itemsFromCart = new  List<reviewCartWrapper>();
        try{            
            List<CartItem> cartItems = new  List<CartItem>();
            String activeCartId;
            if(guestCartId != ''){
                activeCartId = guestCartId;
            }else{
                Id userId=UserInfo.getUserId();        
                List < WebCart> webCartItem = new List <WebCart>();
                webCartItem =[  SELECT Id,Name FROM Webcart
                              WHERE AccountId IN (SELECT AccountId FROM User WHERE Id = :userId) AND OwnerId=:userId AND  Status= :scc_constantHelper.STATUS_ACTIVE AND IsSecondary= :scc_constantHelper.FALSE_VALUE ORDER BY CreatedDate DESC Limit 1];
                activeCartId = webCartItem[0].Id;
            }
            
            cartItems=[SELECT Id, SalesPrice,Price_Per_Unit__c,Discount__c,NetUnitPrice,cart.Coupon_Discount__c,cart.ID,cart.Name,Quantity,cart.User_Cart_Name__c ,cart.Cart_Name_Auto_Number__c, TotalPrice, Product2.Id, Product2.Availability__c,Product2.Copyright_Year__c, Product2.Grade_Level__c, Product2.ISBN13__c,Product2.Product_Status__c, Product2.Description, Product2.ISBN10__c, Price_Condition__c
                       FROM CartItem
                       WHERE CartId = :activeCartId]; 
            
            for(CartItem itemsIncart: cartItems){
                reviewCartWrapper reviewCartItems = new reviewCartWrapper();
                reviewCartItems.cartId = itemsIncart.Id;
                reviewCartItems.description = itemsIncart.Product2.Description;
                reviewCartItems.copyRight = itemsIncart.Product2.Copyright_Year__c;
                reviewCartItems.gradeLevel = itemsIncart.Product2.Grade_Level__c;            
                reviewCartItems.price = itemsIncart.Price_Per_Unit__c;
                reviewCartItems.status = itemsIncart.Product2.Product_Status__c ;
                reviewCartItems.stockAvailability = itemsIncart.Product2.Availability__c;
                reviewCartItems.quantity = itemsIncart.Quantity;
                reviewCartItems.isbn = itemsIncart.Product2.ISBN13__c;
                reviewCartItems.totalPrice=itemsIncart.TotalPrice+ (itemsIncart.Discount__c == null ? 0.00 : math.abs(itemsIncart.Discount__c));
                reviewCartItems.PriceCondition=itemsIncart.Price_Condition__c;
                reviewCartItems.discount = itemsIncart.cart.Coupon_Discount__c;            
                If(itemsIncart.cart.User_Cart_Name__c == '' || itemsIncart.cart.User_Cart_Name__c  == null){
                    reviewCartItems.cartName=itemsIncart.cart.Cart_Name_Auto_Number__c;
                } else {
                    reviewCartItems.cartName=itemsIncart.cart.User_Cart_Name__c ;
                }
                reviewCartItems.webCartId =itemsIncart.cart.Id;
                if(String.isBlank(itemsIncart.Product2.ISBN13__c)){
                    reviewCartItems.isbn = itemsIncart.Product2.ISBN10__c;
                }           
                itemsFromCart.add(reviewCartItems);   
            }
            
        }
        catch(Exception e){
            System.debug('Exception type caught: ' + e.getTypeName());    
            System.debug('Message: ' + e.getMessage());    
            System.debug('Cause: ' + e.getCause());    // returns null
            System.debug('Line number: ' + e.getLineNumber());    
            System.debug('Stack trace: ' + e.getStackTraceString());
        }
        return itemsFromCart;
    }
    
    /********************************************************************** 
Method Name :  getActiveCart
Description :  Method get active cart
Input       :  guestCartId
Return type :  List
***********************************************************************/ 
    @AuraEnabled(cacheable=false)
    public static List<Webcart> getActiveCart(String guestCartId){
       List < WebCart> webCart = new List <WebCart>();
        try{          
            if(guestCartId != ''){
                webCart = [SELECT Id, TotalProductCount FROM Webcart WHERE Id =: guestCartId LIMIT 1];
            }else{
                Id userId=UserInfo.getUserId();   
                webCart =[SELECT Id,TotalProductCount, Name FROM Webcart
                          WHERE AccountId IN (SELECT AccountId FROM User WHERE Id = :userId) AND OwnerId=:userId AND  Status= :scc_constantHelper.STATUS_ACTIVE AND IsSecondary= :scc_constantHelper.FALSE_VALUE ORDER BY CreatedDate DESC Limit 1];
            }
          
        }
        catch(Exception e){
            System.debug('Exception type caught: ' + e.getTypeName());    
            System.debug('Message: ' + e.getMessage());    
            System.debug('Cause: ' + e.getCause());    // returns null
            System.debug('Line number: ' + e.getLineNumber());    
            System.debug('Stack trace: ' + e.getStackTraceString());
          //  throw new AuraHandledException('Failed to getActiveCart :'+e.getMessage());	   
        }   
          return webCart;
    }
    
    /********************************************************************** 
Method Name :  deleteCartItem
Description :  Method to delete cart item
Input       :  cartItemId
Return type :  Boolean
***********************************************************************/ 
    @AuraEnabled(cacheable=false)
    public static Boolean deleteCartItem(String cartItemId){
        Boolean isSuccess = false;
        try{
            List<CartItem> items = [SELECT Id FROM CartItem where Id=:cartItemId];
            if(!items.isEmpty()){
                delete items;
                isSuccess = true;
            }
            return isSuccess;
        }catch (Exception e) {
            System.debug('Exception type caught: ' + e.getTypeName());    
            System.debug('Message: ' + e.getMessage());    
            System.debug('Cause: ' + e.getCause());    // returns null
            System.debug('Line number: ' + e.getLineNumber());    
            System.debug('Stack trace: ' + e.getStackTraceString());
            throw new AuraHandledException('Failed to deleteCartItem :'+e.getMessage());
        }
        
    }
    /********************************************************************** 
Method Name :  digitalProductsCheck
Description :  Method to check cart contains digital product or not
Input       :  guestcartId
Return type :  Boolean
***********************************************************************/    
    @AuraEnabled
    public static Boolean digitalProductsCheck(String guestcartId){
        Boolean isSuccess = false;
        try{
            List < WebCart> webCartItem = new List <WebCart>();
            Id activeCartId;
            if(guestcartId != ''){
                activeCartId = guestcartId;
            }else{
                Id userId=UserInfo.getUserId();  
                
                webCartItem =[  SELECT Id,Name FROM Webcart
                              WHERE AccountId IN (SELECT AccountId FROM User WHERE Id = :userId) AND OwnerId=:userId AND  Status= :scc_constantHelper.STATUS_ACTIVE AND IsSecondary= :scc_constantHelper.FALSE_VALUE ORDER BY CreatedDate DESC Limit 1];
                activeCartId = webCartItem[0].Id;
            }
            for(CartItem item:[Select id, Product2.Product_Type_ID__c  from CartItem  where CartId=:activeCartId]){
                if(item.Product2.Product_Type_ID__c != null){
                    if(scc_constantHelper.DIGITAL_PRODUCT.contains(item.Product2.Product_Type_ID__c)){
                        isSuccess = true;
                    }
                }
            }
            return isSuccess;
        }catch(Exception e){
            System.debug('Exception type caught: ' + e.getTypeName());    
            System.debug('Message: ' + e.getMessage());    
            System.debug('Cause: ' + e.getCause());    // returns null
            System.debug('Line number: ' + e.getLineNumber());    
            System.debug('Stack trace: ' + e.getStackTraceString());            
            throw new AuraHandledException('Failed to fetch digitalProductsCheck :'+e.getMessage());
        }
    }
    
    
    /********************************************************************** 
Method Name :  updateCartItemQuantity
Description :  Method to update quantity of cart Items
Input       :  ItemId, Quantity and Price
Return type :  NA
***********************************************************************/  
    
    @AuraEnabled
    public static void updateCartItemQuantity(Id itemId, Integer Quantity,Decimal price){
        try{
        CartItem cartItemIncart = [select   Id,  Quantity, SalesPrice, Product2Id  FROM CartItem where id=:itemId ];
        cartItemIncart.Quantity= Quantity;
        cartItemIncart.NetUnitPrice =price;       
        cartItemIncart.TotalPrice= Quantity * price;      
        update cartItemIncart;
        }
        catch(Exception e) {
            System.debug('Exception type caught: ' + e.getTypeName());    
            System.debug('Message: ' + e.getMessage());    
            System.debug('Cause: ' + e.getCause());    // returns null
            System.debug('Line number: ' + e.getLineNumber());    
            System.debug('Stack trace: ' + e.getStackTraceString());
        } 
    }
    /********************************************************************** 
Method Name :  getPromoCode
Description :  Method to verify user entered promo code
Input       : promocode
Return type : Boolean
***********************************************************************/  
    @AuraEnabled 
    public static Boolean getPromoCode(String promocode,Id activeCartId){
        try{
            List<Promotion> promotionWorkSpace =[SELECT Id, Name, IsCommercePromotion, IsActive, EndDateTime FROM Promotion WHERE (Name=:promocode) AND (IsCommercePromotion=True) AND (IsActive=True) AND (EndDateTime > Today)];
            Webcart wi =[Select id, Name,Coupon__c From Webcart Where id=:activeCartId];
            if(promotionWorkSpace.size()>0){
                if(wi != null){ wi.Coupon__c = promocode; update wi; } 	return true;
            }else{
                return false;
            }            
        }catch(Exception e){
            System.debug('Exception type caught: ' + e.getTypeName());    
            System.debug('Message: ' + e.getMessage());    
            System.debug('Cause: ' + e.getCause());    // returns null
            System.debug('Line number: ' + e.getLineNumber());    
            System.debug('Stack trace: ' + e.getStackTraceString());
            throw new AuraHandledException('Failed to update promo code :'+e.getMessage());     
        }
    }
}