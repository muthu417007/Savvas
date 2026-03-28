public class scc_cloneOrderController {
    /********************************************************************** 
Class Name :  addcartItemsUserInputs
Description : common wrapper class to get and return data
Input       : NA
Return type : NA
***********************************************************************/ 
    public class addcartItemsUserInputs{
        
        @AuraEnabled public String sapUserShip {get; set;}
        @AuraEnabled public Boolean oneTimeShip {get; set;}
        @AuraEnabled public String shipAddressId {get; set;}
        @AuraEnabled public String shipStreet {get; set;}
        @AuraEnabled public String shipCountry {get; set;}
        @AuraEnabled public String shipCity {get; set;}
        @AuraEnabled public String shipState {get; set;}
        @AuraEnabled public String shipZipCode {get; set;}         
        
    }
    
    /**************************************************************************** 
* @Method Name  : cloneOrderController
* @Description  : Clones an existing cart with its items and delivery group for a given user
* @Param        : currentcartId - Id of the cart to be cloned
*                userInputs - List of user inputs containing shipping details
* @Throws       : AuraHandledException if there's an error in cart cloning process
*****************************************************************************/
    
    @AuraEnabled
    public static void cloneOrderController(Id currentcartId,List<addcartItemsUserInputs> userInputs ){  
        
        Id currAcctId;
        Boolean isTopLevelAccount = false;
        Boolean promo_Code_Sent = false;
        Boolean new_User_Disc = false;
        User accid=[SELECT Id, 	AccountId FROM User WHERE Id = :UserInfo.getUserId() Limit 1];  
        Id acId=accid.AccountId;
        system.debug('acId>>>'+acId);
        currAcctId = acId;
        system.debug('currAcctId>>>>webcart>>>'+currAcctId);
        
        
        system.debug('the user inputs are'+userInputs);
        Id userId = UserInfo.getUserId(); 
        system.debug('current accound id is'+acId);
        scc_changeCartAsSecondary.changeActiveCartAsSecondary(acId);
        
        List < WebCart> webCartItem = new List <WebCart>();
        webCartItem =[ SELECT Id,Name,AccountId,CurrencyIsoCode,License_Partner__c,Payment_Terms__c,PoNumber__c,SAP_BillTo__c,SAP_Salesorg__c,SAP_Shipto__c,TaxType,WebStoreId 
                      FROM Webcart
                      WHERE Id=:currentcartId];
        system.debug('the webCartItem are'+webCartItem);
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
            AccountId=accid.AccountId,
            
            CurrencyIsoCode=webCartItem[0].CurrencyIsoCode,
            IsSecondary=scc_constantHelper.FALSE_VALUE,
            Master_User__c=userId,
            Name=scc_constantHelper.DEFAULT_CART,             
            Payment_Terms__c=scc_constantHelper.DEFAULT_PAYMENT_TERM,
            PoNumber__c= webCartItem[0].PoNumber__c,
            Shipping_Conditions__c='DF',
            SAP_Salesorg__c=webCartItem[0].SAP_Salesorg__c,
            SAP_BillTo__c=webCartItem[0].SAP_BillTo__c,
            SAP_Shipto__c=userInputs[0].sapUserShip,
            Shipping_City__c =userInputs[0].shipCity,
            Shipping_Country__c =userInputs[0].shipCountry,
            Shipping_State__c =userInputs[0].shipState,
            Shipping_Street__c =userInputs[0].shipStreet,
            Shipping_Zip_Code__c =userInputs[0].shipZipCode,
            Sold_To_Customer__c=userInputs[0].sapUserShip,
            Specify_One_Time_Shipping__c=userInputs[0].oneTimeShip,
            Status=scc_constantHelper.ACTIVE,
            TaxType=scc_constantHelper.DEFAULT_TAX,
            WebStoreId=webCartItem[0].WebStoreId,
            Held_Cart_Reminder__c = '0'
        );
        try{                
            Insert webCartCreation;	
            system.debug('the webCartCreation are'+webCartCreation);
        }catch(DmlException e) {
            System.debug('The following exception has occurred: ' + e.getMessage());
        }  
        List<WebCart> activeCart = new  List<WebCart>();
        activeCart = [ SELECT Id
                      FROM Webcart
                      WHERE AccountId =:acId AND OwnerId=:userId AND Master_User__c=:userId AND Status='Active' AND IsSecondary= false
                      ORDER BY CreatedDate DESC Limit 1];
        system.debug('the activeCart are'+activeCart);
        
        List<CartItem> cartItemsData = new  List<CartItem>();
        cartItemsData=[SELECT Id, SalesPrice,NetUnitPrice,cart.Coupon_Discount__c,cart.ID,cart.Name,Quantity, TotalPrice, Product2.Id, Product2.Availability__c,Product2.Copyright_Year__c, Product2.Grade_Level__c, Product2.ISBN13__c,Product2.Product_Status__c, Product2.Description, Product2.ISBN10__c
                       FROM CartItem
                       WHERE CartId = :currentcartId]; 
        system.debug('the cartItemsData are'+cartItemsData);
        CartDeliveryGroup newCDG= new CartDeliveryGroup(
            name=scc_constantHelper.DELIVERY_GROUP_SAVVAS,
            CartId=activeCart[0].Id
        );
        try {
            insert newCDG;
        }
        catch(DmlException e) {
            System.debug('The following exception has occurred: ' + e.getMessage());
        } 
        List<CartItem> insertCartItemList = new List<CartItem>();
        CartDeliveryGroup cartDG= [select Id from CartDeliveryGroup WHERE CartId=:activeCart[0].Id ORDER BY CreatedDate DESC LIMIT 1];
        for(CartItem cartCreation: cartItemsData){
            CartItem cartItems1 = new CartItem(
                CartId = activeCart[0].Id,
                Product2Id = cartCreation.Product2.Id,
                Quantity = cartCreation.Quantity,
                NetUnitPrice = cartCreation.NetUnitPrice,
                TotalPrice = cartCreation.Quantity*cartCreation.NetUnitPrice,
                CartDeliveryGroupId = cartDG.Id,
                Name = cartCreation.cart.Name);
            insertCartItemList.add(cartItems1); 
        }
        try {
            insert insertCartItemList;
        }
        catch(DmlException e) {
            System.debug('The following exception has occurred: ' + e.getMessage());
        }  	
    }
    /**************************************************************************** 
* @Method Name  : getCurrentUserShippingAddress
* @Description  : Method to fetch shipping addresses based on restriction flag
*                If restricted, only returns school district addresses
*                If not restricted, returns all related addresses
* @Param        : isRestricted - Boolean flag to determine address filtering
* @Return       : List<addressWrapper> - List of shipping addresses
* @Throws       : AuraHandledException if there's an error retrieving addresses
*****************************************************************************/
    @AuraEnabled
    public static List<addressWrapper> getCurrentUserShippingAddress(Boolean isRestricted){
        try {
            List<addressWrapper> shipping = new List<addressWrapper>();
            Id userId = UserInfo.getUserId(); 
            String shipping1='shipping';
            User accid=[SELECT AccountId,Id FROM User WHERE Id =:userId Limit 1]; 
            Id acId=accid.AccountId;
            Set <Id> accountchildIds= new Set <Id>();
            //accountchildIds.add(acId);
            List<Account> accaddr= new List<Account>();
            List<Account_Addresses__c> accountaddr= new List<Account_Addresses__c>();
            
            if(isRestricted==false){
                accountchildIds.add(acId);
                for(Affiliation__c affChildaccount: [Select Child_Account__c from Affiliation__c where Parent_Account__c=:acId ]){
                    accountchildIds.add(affChildaccount.Child_Account__c);
                }
                
                //Fetching Child Accounts
                for(Account Childaccount: [Select Id from Account where Parentid=:acId ]){
                    accountchildIds.add(Childaccount.Id);
                }
                
                accountaddr =[SELECT Id,Account__c,ERP_Account_Name__c,Address_1__c,Address_2__c,Address_3__c,Address_4__c,Address_Type__c,City__c,Country__c,ERP_Account_Number__c,State__c,Zip_Code__c 
                              FROM Account_Addresses__c 
                              WHERE Account__c IN :accountchildIds AND Address_Type__c =:shipping1];
                
                accaddr=[SELECT Id,Name,BillingCity,BillingPostalCode,BillingState,BillingStreet,BillingCountry,SAP_Account_Id__c,SAP_Account_Number__c,ShippingCity,ShippingCountry,ShippingPostalCode,ShippingState,ShippingStreet
                         FROM Account 
                         WHERE Id IN :accountchildIds ];
                
            } else {
                List<Account> userAccType = [SELECT Id, Type FROM Account WHERE Id=:acId];
                if(!userAccType.isEmpty()){
                    if(scc_constantHelper.schoolDistrict.contains(userAccType[0].Type)){
                        accountchildIds.add(acId);
                    }
                }
                for(Affiliation__c affChildaccount: [Select Child_Account__c from Affiliation__c where Parent_Account__c=:acId AND (Child_Account__r.Type IN :scc_constantHelper.schoolDistrict) ]){
                    accountchildIds.add(affChildaccount.Child_Account__c);
                }
                
                //Fetching Child Accounts
                for(Account Childaccount: [Select Id from Account where Parentid=:acId AND (Type IN :scc_constantHelper.schoolDistrict) ]){
                    accountchildIds.add(Childaccount.Id);
                }
                
                accountaddr =[SELECT Id,Account__c,ERP_Account_Name__c,Address_1__c,Address_2__c,Address_3__c,Address_4__c,Address_Type__c,City__c,ERP_Account_Number__c,State__c,Zip_Code__c, Country__c
                              FROM Account_Addresses__c 
                              WHERE Account__c IN :accountchildIds 
                              AND Address_Type__c =:shipping1 
                              AND (Account__r.Type IN :scc_constantHelper.schoolDistrict)];
                
                accaddr=[SELECT Id,Name,BillingCity,BillingPostalCode,BillingState,BillingStreet,BillingCountry,SAP_Account_Id__c,SAP_Account_Number__c,ShippingCity,ShippingCountry,ShippingPostalCode,ShippingState,ShippingStreet
                         FROM Account 
                         WHERE Id IN :accountchildIds 
                         AND (Type IN :scc_constantHelper.schoolDistrict) ];
            }
            
            // Process Account_Addresses__c records
            for (Account_Addresses__c acc : accountaddr) {
                addressWrapper wrapper1 = new addressWrapper();
                wrapper1.AccShipId=acc.Id;
                wrapper1.SAccountName=acc.ERP_Account_Name__c;
                wrapper1.ShipToNumber=acc.ERP_Account_Number__c;
                wrapper1.ShipStreet=(acc.Address_1__c != null ? acc.Address_1__c+' ' : '')+(acc.Address_2__c != null ? acc.Address_2__c+' ' : ' ')+(acc.Address_3__c != null ? acc.Address_3__c+' ' : ' ')+(acc.Address_4__c != null ? acc.Address_4__c : '');
                wrapper1.ShippingCity=(acc.City__c != null ? acc.City__c : '');
                wrapper1.Provionce=(acc.State__c != null ? acc.State__c : '');
                wrapper1.PostalCode=(acc.Zip_Code__c != null ? acc.Zip_Code__c : '');
                wrapper1.ShippingCountry=(acc.Country__c != null ? acc.Country__c : '');            
                shipping.add(wrapper1);
            }
            
            // Process Account records
            for (Account acc : accaddr) {
                addressWrapper wrapper = new addressWrapper();
                wrapper.AccShipId=acc.Id;
                wrapper.SAccountName=acc.Name;
                wrapper.ShipToNumber=acc.SAP_Account_Id__c;
                wrapper.ShipStreet=acc.ShippingStreet;
                wrapper.ShippingCity=acc.ShippingCity;
                wrapper.Provionce=acc.ShippingState;
                wrapper.PostalCode=acc.ShippingPostalCode;
                wrapper.ShippingCountry=acc.ShippingCountry;
                shipping.add(wrapper);
            }        
            
            return shipping;
            
        } catch(Exception e) {
            System.debug(LoggingLevel.ERROR, 'Error in getCurrentUserShippingAddress: ' + e.getMessage());
            throw new AuraHandledException('Unable to retrieve shipping addresses: ' + e.getMessage());
        }
    }
    /**************************************************************************** 
* @Method Name  : checkRestrictedCartItems
* @Description  : Checks if cart contains any items with sales restriction code '07'
* @Param        : cartId - Id of the cart to check
* @Return       : Boolean - Returns true if restricted items exist, false otherwise
* @Throws       : AuraHandledException if there's an error checking cart items
*****************************************************************************/
    @AuraEnabled(cacheable=true)
    public static Boolean checkRestrictedCartItems(String cartId){
        try {
            for(CartItem item:[Select id, Product2.Sales_Restriction_Code__c  
                               from CartItem  
                               where CartId=:cartId]){
                                   if(item.Product2.Sales_Restriction_Code__c=='07'){
                                       return true;
                                   }
                               }
            return false;
        } catch(Exception e) {
            System.debug(LoggingLevel.ERROR, 'Error in checkRestrictedCartItems: ' + e.getMessage());
            throw new AuraHandledException('Unable to check cart restrictions: ' + e.getMessage());
        }
    }
    
    public class addressWrapper{
        
        @AuraEnabled public Id AccountId;
        @AuraEnabled public Id AccId;
        @AuraEnabled public String AccountName;
        @AuraEnabled public String BillToNumber;
        @AuraEnabled public String BillinStreet;
        @AuraEnabled public String BillingCity;
        @AuraEnabled public String State;
        @AuraEnabled public String ZipCode;
        @AuraEnabled public String BillingCountry;
        @AuraEnabled public Id AccShipId;        
        @AuraEnabled public String SAccountName;
        @AuraEnabled public String ShipToNumber;
        @AuraEnabled public String ShipStreet;
        @AuraEnabled public String ShippingCity;
        @AuraEnabled public String Provionce;
        @AuraEnabled public String PostalCode;
        @AuraEnabled public String ShippingCountry;
        
    }
    
}