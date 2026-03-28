/**************************************************************************************** 
* @Class Name  - scc_addItemsToCartController
* @description - class to perform add items to cart and cleart active cart
* @Created By  - CTS-Muthukumar
* @Created On - 2024-05-14
* ***************************************************************************************/ 
public without sharing class scc_addItemsToCartController {   
        
    /********************************************************************** 
    Class Name :  addcartItems
    Description : common wrapper class to get and return data
    Input       : NA
    Return type : NA
    ***********************************************************************/ 
    public class addcartItems{
        
        @AuraEnabled public Id Product2Id {get; set;}
        @AuraEnabled public Integer Quantity {get; set;}
        @AuraEnabled public Decimal SalesPrice {get; set;}
        @AuraEnabled public String Name {get; set;}
        @AuraEnabled public String PriceCondition {get; set;}
        
    }
    /********************************************************************** 
    Class Name :  addcartItemsUserInputs
    Description : common wrapper class to get and return data
    Input       : NA
    Return type : NA
    ***********************************************************************/ 
     public class addcartItemsUserInputs{
        
        @AuraEnabled public String sapUserBill {get; set;}
        @AuraEnabled public String sapUserShip {get; set;}
        @AuraEnabled public Boolean oneTimeShip {get; set;}
        @AuraEnabled public String billCountry {get; set;}
        @AuraEnabled public String shipAddressId {get; set;}
        @AuraEnabled public String shipStreet {get; set;}
        @AuraEnabled public String shipCountry {get; set;}
        @AuraEnabled public String shipCity {get; set;}
        @AuraEnabled public String shipState {get; set;}
        @AuraEnabled public String shipZipCode {get; set;}
        @AuraEnabled public Boolean schoolDistrict {get; set;}
        @AuraEnabled public String billStreet {get; set;}
        @AuraEnabled public String billCity {get; set;}
        @AuraEnabled public String billState {get; set;}
        @AuraEnabled public String billZipCode {get; set;} 
        @AuraEnabled public String guestCartId {get; set;} 
        @AuraEnabled public String guestAccountId {get; set;} 
        @AuraEnabled public String billingName {get; set;} 
        @AuraEnabled public String shippingName {get; set;} 
             
    }
    
    public class MyCustomException extends Exception {}
    
    public static String getWebStoreId(String storeName) {
        WebStore store = [SELECT Id FROM WebStore WHERE Name = :storeName LIMIT 1];
        return store.Id;
    }
    public static String fetchAccountId(String userId){
        User accountId=[SELECT AccountId,Id FROM User WHERE Id =:userId Limit 1]; 
        return accountId.AccountId;
    }
    
    //get active cart id based on user id
    @AuraEnabled
    public static string getActiveCartId(String userId) {
        try {
            List<WebCart> activeCart = [
                SELECT Id
                FROM Webcart
                WHERE AccountId IN (SELECT AccountId FROM User WHERE Id = :userId) AND OwnerId=:userId AND Status='Active' AND IsSecondary= false
                ORDER BY CreatedDate DESC
            ];
            if(activeCart.size()>0){
                return activeCart[0].Id;
            }
            else{
                return null;
            }  
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    // // ADDED BY SUDHA , this method used for to check duplicate items  before adding cart  
    //  @AuraEnabled
    // public static List<WebCart> getActiveCartItems(String activeCartId) {
    //     try {
    //          return  [SELECT Id, Cart_Id__c,(select id,Product2Id,Product2.Description ,ISBN__c ,name  from cartitems) FROM WebCart where id=:activeCartId];
           
    //     } catch (Exception e) {
    //         throw new AuraHandledException(e.getMessage());
    //     }
    // }
    //commented by sudha  due to functionality not working  as expected
	@AuraEnabled
    public static List<CartItem> getActiveCartItems(String activeCartId) {
        try {
             return  [SELECT Id,ISBN__c,Name,Product2.Description FROM CartItem WHERE cartId=:activeCartId];
           
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
        @AuraEnabled
    public static List<WebCart> getCartDetails(String activeCartId) {
        try {
             return  [SELECT Id,BillingCountry, BillingState, Shipping_Country__c, Shipping_State__c, Specify_One_Time_Shipping__c,School_Or_District__c, AccountId from WebCart WHERE Id=:activeCartId];
           
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    public static String cartId (String accountId, String webStoreId, List<addcartItemsUserInputs>userInputs  ) {
        
		String userShipTo =userInputs[0].sapUserShip;
        String userBillTo =userInputs[0].sapUserBill;
        Boolean oneTimeShip =userInputs[0].oneTimeShip;
        String billingCountry=userInputs[0].billCountry;
        String userShipToId=userInputs[0].shipAddressId;
        String shipStreet=userInputs[0].shipStreet;
        String shipCountry=userInputs[0].shipCountry;
        String shipCity=userInputs[0].shipCity;
        String shipState=userInputs[0].shipState;
        String shipZipCode=userInputs[0].shipZipCode;
        String guestCartId = userInputs[0].guestCartId;
        String guestAccountId = userInputs[0].guestAccountId;
        
        Id currAcctId;
        Boolean isTopLevelAccount = false;
        Boolean promo_Code_Sent = false;
        Boolean new_User_Disc = false;
        User accid=[SELECT Id, 	AccountId FROM User WHERE Id = :UserInfo.getUserId() Limit 1];  
        Id acId=accid.AccountId;
        system.debug('acId>>>'+acId);
        currAcctId = acId;
        system.debug('currAcctId>>>>webcart>>>'+currAcctId);
        String salesOrgValue;
        if(billingCountry == scc_constantHelper.COUNTRY_US){
             salesOrgValue=scc_constantHelper.DEFAULT_US_CODE;
        }
        if(billingCountry == scc_constantHelper.COUNTRY_CANADA){
             salesOrgValue=scc_constantHelper.CANADA_CODE;
        }else
        {
               salesOrgValue=scc_constantHelper.DEFAULT_US_CODE;
        }
         Id userId=UserInfo.getUserId(); 
         String poNumber;
        try{
       List<sobject> orderPoNumber= new List<sobject>();
            
            String maxValue;
            String newMaxValue;
            
          orderPoNumber = [SELECT MAX(PoNumber__c) 
                                             FROM WebCart where 
                                            PoNumber__c LIKE 'WEBORD%'];
            system.debug('orderPoNumber'+ orderPoNumber);
            
              if(!orderPoNumber.isEmpty() && orderPoNumber[0].get('expr0') != null){
           		 maxValue = (String)orderPoNumber[0].get('expr0');
                Integer numericPart = Integer.valueOf(maxValue.substring(6)) + 1;
                 poNumber = 'WEBORD' + String.valueOf(numericPart).leftPad(6,'0');
            }
            
                 
        }
        catch(DmlException e) {
                System.debug('The following exception has occurred: ' + e.getMessage());
            }  
         if(String.isBlank(poNumber)){
            poNumber = scc_constantHelper.WEBORD_KEYWORD;
              }
        Account accData=[SELECT Id, CurrencyIsoCode
						   FROM Account
                           where id=:accountId Limit 1];

       		while (!isTopLevelAccount) {
                
                List<Account> acct = [select Id, ParentId,Registration_Promo_Code_Sent__c,Promo_end_date__c From Account where Id = :currAcctId limit 1];
                system.debug('acct>>>>webcart>>>'+acct);
                if(!acct.isEmpty()){
                    if (acct[0].ParentId != null) {
                    currAcctId = acct[0].ParentID;
                        system.debug('currAcctId>>>>webcart>>>'+currAcctId);
                } else {
                    isTopLevelAccount = true;
                    if(acct[0].Registration_Promo_Code_Sent__c == True && system.today() <= acct[0].Promo_end_date__c){
                        new_User_Disc  = True;
                    } else {
                        new_User_Disc  = False;
                    }
                    system.debug('new_User_Disc>>>>webcart>>>'+new_User_Disc);
                }
                }
                
            }
       
            WebCart webCartCreation = new WebCart(
           	 AccountId=accountId,
             School_Or_District__c = userInputs[0].schoolDistrict,
            // Account_Address_Id__c=userShipToId,
             CurrencyIsoCode=accData.CurrencyIsoCode,
             IsSecondary=scc_constantHelper.FALSE_VALUE,
             Name=scc_constantHelper.DEFAULT_CART,             
             Payment_Terms__c=scc_constantHelper.DEFAULT_PAYMENT_TERM,
             PoNumber__c= poNumber,
             Shipping_Conditions__c='DF',
			 SAP_BillTo__c=userBillTo,
             SAP_Shipto__c=userShipTo,
             SAP_Salesorg__c=salesOrgValue,
             Sold_To_Customer__c=userShipTo,
             Shipping_City__c =shipCity,
             Shipping_Country__c =shipCountry,
             Shipping_State__c =shipState,
             Shipping_Street__c =shipStreet,
             Shipping_Zip_Code__c =shipZipCode,
             Specify_One_Time_Shipping__c=oneTimeShip,
             TaxType=scc_constantHelper.DEFAULT_TAX,
             Master_User__c=userId,
             Status=scc_constantHelper.ACTIVE,
             WebStoreId=webStoreId,
             BillingStreet = userInputs[0].billStreet,
             BillingCity = userInputs[0].billCity,
             BillingState = userInputs[0].billState,
             BillingPostalCode = userInputs[0].billZipCode,
             BillingCountry = userInputs[0].billCountry,
             BillingName__c =userInputs[0].billingName,
             Held_Cart_Reminder__c = '0',
             Shipto_name__c =userInputs[0].shippingName,
             New_registered_user_discount__c = new_User_Disc
             
            
            );
          try{                
                Insert webCartCreation;	
            }catch(DmlException e) { 
                System.debug('The following exception has occurred: ' + e.getMessage());
            }   
         WebCart activeCart = [ SELECT Id
                                FROM Webcart
                                WHERE AccountId IN (SELECT AccountId FROM User WHERE Id = :userId) AND OwnerId=:userId AND Status='Active' AND IsSecondary= false
                                ORDER BY CreatedDate DESC Limit 1];
        
              return activeCart.Id;          
 		    /*   ConnectApi.CartInput cartInput = new ConnectApi.cartinput();
        cartInput.effectiveAccountId = accountId;
        cartInput.isSecondary = false;
        ConnectApi.CartSummary cartResults = ConnectApi.CommerceCart.createCart(webStoreId, cartInput);
        return cartResults.cartId; */
        
        
        
        
    }
    /********************************************************************** 
    Method Name :  update external site user checkout address
    Description :  Method to perform update external site user checkout address
    Input       :  List<addcartItemsUserInputs>userInputs
    Return type :  NA
    ***********************************************************************/ 
    @AuraEnabled
    public static void updateAddress( List<addcartItemsUserInputs>userInputs ){    
         Id userId=UserInfo.getUserId();  
         String activeCartId = '';
         activeCartId =getActiveCartId(userId);
         String salesOrgValue;
         String billingCountry=userInputs[0].billCountry;
          if(billingCountry == scc_constantHelper.COUNTRY_US){
                salesOrgValue=scc_constantHelper.DEFAULT_US_CODE;
          }
          if(billingCountry == scc_constantHelper.COUNTRY_CANADA){
               salesOrgValue=scc_constantHelper.CANADA_CODE;
          }else
          {
              salesOrgValue=scc_constantHelper.DEFAULT_US_CODE;
          }
                
         WebCart webCartUpdate = new WebCart(
           	 Id=activeCartId,
             SAP_BillTo__c=userInputs[0].sapUserBill,
             SAP_Shipto__c=userInputs[0].sapUserShip,
             SAP_Salesorg__c=salesOrgValue,
             Sold_To_Customer__c=userInputs[0].sapUserShip, 
             Shipping_City__c =userInputs[0].shipCity,
             Shipping_Country__c =userInputs[0].shipCountry,
             Shipping_State__c =userInputs[0].shipState,
             Shipping_Street__c =userInputs[0].shipStreet,
             Shipping_Zip_Code__c =userInputs[0].shipZipCode,
             Specify_One_Time_Shipping__c=userInputs[0].oneTimeShip,
             BillingStreet = userInputs[0].billStreet,
             BillingCity = userInputs[0].billCity,
             BillingState = userInputs[0].billState,
             BillingPostalCode = userInputs[0].billZipCode,
             BillingCountry = userInputs[0].billCountry,
             BillingName__c =userInputs[0].billingName,
             Shipto_name__c =userInputs[0].shippingName );                      
            
            try{                
                update webCartUpdate;	
            }catch(DmlException e) {
                System.debug('The following exception has occurred: ' + e.getMessage());
            } 
    }
    /********************************************************************** 
    Method Name :  addItemToCart
    Description :  Method to perform add item to cart
    Input       :  List<addcartItems>selectedProducts
    Return type :  NA
    ***********************************************************************/ 
    
    @AuraEnabled
    public static void addItemToCart(List<addcartItems> selectedProducts, List<addcartItemsUserInputs>userInputs ){    
        system.debug('selectedProducts'+selectedProducts);
           system.debug('userInputs'+userInputs);
                  
		String userShipTo =userInputs[0].sapUserShip;
        String userBillTo =userInputs[0].sapUserBill;
        Boolean oneTimeShip =userInputs[0].oneTimeShip;
        String billingCountry=userInputs[0].billCountry;
        String userShipToId=userInputs[0].shipAddressId;
        String shipStreet=userInputs[0].shipStreet;
        String shipCountry=userInputs[0].shipCountry;
        String shipCity=userInputs[0].shipCity;
        String shipState=userInputs[0].shipState;
        String shipZipCode=userInputs[0].shipZipCode;
        String guestCartId = userInputs[0].guestCartId;
        String guestAccountId = userInputs[0].guestAccountId;
        
        Id currAcctId;
        Boolean isTopLevelAccount = false;
        Boolean promo_Code_Sent = false;
        Boolean new_User_Disc = false;
        User accid=[SELECT Id, 	AccountId FROM User WHERE Id = :UserInfo.getUserId() Limit 1];  
        Id acId=accid.AccountId;
        system.debug('acId>>>'+acId);
        currAcctId = acId;
        system.debug('currAcctId>>>>webcart>>>'+currAcctId);
        
        system.debug('addcartItemsUserInputs'+userInputs+'==='+userBillTo+'=='+oneTimeShip+'shipto'+userShipTo);
        String webStoreId = getWebStoreId(scc_constantHelper.STORE_NAME);  
        String activeCartId = '';
        Id accountId;
        if(!String.isEmpty(guestCartId)){
            activeCartId = guestCartId;
            accountId = guestAccountId;
        }else{
            Id userId=UserInfo.getUserId();        
            activeCartId =getActiveCartId(userId);
            accountId= fetchAccountId(userId);
            system.debug('external user');
        }

        
        Set<Id> productIdSet = new Set<Id>();
        Map<Id, addcartItems> mapCartItemProductinfo = new Map<Id, addcartItems>();
        List<CartItem> updateExistingCartItemsList = new  List<CartItem>();   
        
        if(String.isEmpty(activeCartId)){
            activeCartId=cartId(accountId,webStoreId,userInputs);
        } else{
            if(!String.isEmpty(userBillTo)){
                String salesOrgValue;
                if(billingCountry == scc_constantHelper.COUNTRY_US){
                     salesOrgValue=scc_constantHelper.DEFAULT_US_CODE;
                }
                if(billingCountry == scc_constantHelper.COUNTRY_CANADA){
                     salesOrgValue=scc_constantHelper.CANADA_CODE;
                }else
                {
                       salesOrgValue=scc_constantHelper.DEFAULT_US_CODE;
                }
                
                while (!isTopLevelAccount) {
                    
                    List<Account> acct = [select Id, ParentId,Registration_Promo_Code_Sent__c,Promo_end_date__c From Account where Id = :currAcctId limit 1];
                    system.debug('acct>>>>webcart>>>'+acct);
                    if(!acct.isEmpty()){
                        if (acct[0].ParentId != null) {
                            currAcctId = acct[0].ParentID;
                            system.debug('currAcctId>>>>webcart>>>'+currAcctId);
                        } else {
                            isTopLevelAccount = true;
                            if(acct[0].Registration_Promo_Code_Sent__c == True && system.today() <= acct[0].Promo_end_date__c){
                                new_User_Disc  = True;
                            } else {
                                new_User_Disc  = False;
                            }
                            system.debug('new_User_Disc>>>>webcart>>>'+new_User_Disc);
                        }
                    }
                    
                }
             WebCart webCartUpdate = new WebCart(
           	 Id=activeCartId,
            // Account_Address_Id__c=userShipToId,
             SAP_BillTo__c=userBillTo,
             SAP_Shipto__c=userShipTo,
             SAP_Salesorg__c=salesOrgValue,
             Sold_To_Customer__c=userShipTo, Shipping_City__c =shipCity,
             Shipping_Country__c =shipCountry,
             Shipping_State__c =shipState,
             Shipping_Street__c =shipStreet,
             Shipping_Zip_Code__c =shipZipCode,
             Specify_One_Time_Shipping__c=oneTimeShip,
             BillingStreet = userInputs[0].billStreet,
             BillingCity = userInputs[0].billCity,
             BillingState = userInputs[0].billState,
             BillingPostalCode = userInputs[0].billZipCode,
             BillingCountry = userInputs[0].billCountry,
             BillingName__c =userInputs[0].billingName,
             Shipto_name__c =userInputs[0].shippingName );                      
            
            try{                
                update webCartUpdate;	
            }catch(DmlException e) {
                System.debug('The following exception has occurred: ' + e.getMessage());
            }  
          }  
        }       
        
        for(scc_addItemsToCartController.addcartItems cartItemList: selectedProducts){
            if(cartItemList.Quantity>0){
                productIdSet.add(cartItemList.Product2Id);
                mapCartItemProductinfo.put(cartItemList.Product2Id,cartItemList);
            }
        }
        
    //    List<CartItem> existingCartItemsList = [SELECT Id, CartId, Quantity, SalesPrice,Product2Id, Price_Condition__c  
    //                                             FROM CartItem 
    //                                             WHERE Product2Id IN :mapCartItemProductinfo.keySet() AND cartId=:activeCartId];                
        
    //     If(existingCartItemsList.size() > 0){
    //         for(CartItem updateExistCartItem: existingCartItemsList){
    //             for(scc_addItemsToCartController.addcartItems cartItemList: selectedProducts){
    //                 If(updateExistCartItem.Product2Id == cartItemList.Product2Id){
    //                     updateExistCartItem.Quantity = cartItemList.Quantity + updateExistCartItem.Quantity;
    //                    // updateExistCartItem.SalesPrice = cartItemList.SalesPrice;
    //                     updateExistCartItem.NetUnitPrice= cartItemList.SalesPrice;
    //                     updateExistCartItem.TotalPrice = (cartItemList.Quantity + updateExistCartItem.Quantity) * cartItemList.SalesPrice;
    //                     updateExistCartItem.Price_Condition__c= cartItemList.PriceCondition;                       
    //                     productIdSet.remove(cartItemList.Product2Id);
    //                     updateExistingCartItemsList.add(updateExistCartItem);  
    //                 }
    //             }
    //         }
    //         try{                
    //             update updateExistingCartItemsList;	
    //         }catch(DmlException e) {
    //             System.debug('The following exception has occurred: ' + e.getMessage());
    //         }            
    //     } 
        if (productIdSet.size() > 0){
            CartDeliveryGroup newCDG= new CartDeliveryGroup(
                name=scc_constantHelper.DELIVERY_GROUP_SAVVAS,
                CartId=activeCartId
            );
            try {
                insert newCDG;
            }
            catch(DmlException e) {
                System.debug('The following exception has occurred: ' + e.getMessage());
            } 
            
            CartDeliveryGroup cartDG= [select Id from CartDeliveryGroup WHERE CartId=:activeCartId ORDER BY CreatedDate DESC LIMIT 1];
            
            List<CartItem> insertCartItemList = new List<CartItem>();
            for(scc_addItemsToCartController.addcartItems cartItemList: selectedProducts){
                for(Id prodId: productIdSet){
                    if(prodId == cartItemList.Product2Id){
                        CartItem cartItems = new CartItem(
                            CartId = activeCartId,
                            Product2Id = cartItemList.Product2Id,
                            Quantity = cartItemList.Quantity,
                            //SalesPrice = cartItemList.SalesPrice,
                            NetUnitPrice = cartItemList.SalesPrice,
                            TotalPrice = cartItemList.Quantity*cartItemList.SalesPrice,
                            Price_Condition__c= cartItemList.PriceCondition,   
                            CartDeliveryGroupId = cartDG.Id,
                            Name = cartItemList.Name);
                          system.debug('selectedProductsinaddtocart'+cartItems);
                        insertCartItemList.add(cartItems);                        	
                    }
                    
                }                                                                
            }
            try {
                insert insertCartItemList;
            }
            catch(DmlException e) {
                System.debug('The following exception has occurred: ' + e.getMessage());
            }  	
        }        
    }
    
	/********************************************************************** 
    Method Name :  deleteAllCartItems
    Description :  Method to clear active cart
    Input       :  activeCartId
    Return type :  NA
    ***********************************************************************/     
    @AuraEnabled
    public static void deleteAllCartItems(String activeCartId) {
        System.debug('the user active cart is' + activeCartId );
        
        try{
            List<CartItem> cartItemsListToDelete = new List<CartItem>();
            List<CartItem> cartItemsList = [SELECT Id, Product2Id, Sku, quantity FROM CartItem WHERE CartId =: activeCartId];
            if(cartItemsList.size() > 0){
                system.debug('inside cartitem'+cartItemsList.size());
                for(CartItem ci: cartItemsList){
                    cartItemsListToDelete.add(ci);
                }
            }
            system.debug('inside cartItemsListToDelete'+cartItemsListToDelete);
            if(cartItemsListToDelete.isEmpty()){
                throw new MyCustomException('No cart/items with the cart Id is found');
            }else{
                delete cartItemsListToDelete;
            }
        }catch (Exception e) {
            List<String> errorMessage = new List<String>();
            errorMessage.add(e.getMessage());
            throw new AuraHandledException(e.getMessage());
        } 
    }
  //Session Id
   @AuraEnabled(cacheable=true)
   public static String getSessionId() {
       return UserInfo.getSessionId();
    }   
    
    //Added for W-014850
    @AuraEnabled(cacheable=true)
    public static Integer getActiveCartCount() {
           Id userId=UserInfo.getUserId();
           Integer cartquantity=0;
           String activeCartId='';
           Decimal quant;
			User userNameData = [Select id,Name from User where id=:userId];        
        
        	List<WebCart> webCartData =[ SELECT Id FROM Webcart
                		  WHERE OwnerId=:userId AND Status= :scc_constantHelper.STATUS_ACTIVE AND IsSecondary= :scc_constantHelper.FALSE_VALUE ORDER BY CreatedDate DESC Limit 1];
            if(!webCartData.isEmpty())
            { 
         	     activeCartId = webCartData[0].Id;
            }
            else 
            {
                return cartquantity;
            }
            List<CartItem> cartItems=[SELECT Id,Quantity FROM CartItem
                          WHERE CartId = :activeCartId];
                          system.debug('cartitems'+cartItems);
            for(CartItem item: cartItems){
                quant=item.Quantity;
            	cartquantity+= quant.intValue();
        	} 	
            system.debug('cartquantity'+cartquantity);
            return cartquantity;
            
            
    }
    
    
}