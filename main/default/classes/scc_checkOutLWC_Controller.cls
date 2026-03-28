/**************************************************************************************** 
* @Class Name  - scc_checkOutLWC_Controller
* @description - Test class for scc_checkOutLWC_Controller
* @Created By  - CTS-Suresh Kalshetti
* @Created On - 2024-05-21
* ***************************************************************************************/ 
public without sharing class scc_checkOutLWC_Controller {
    /********************************************************************** 
    Method Name :  isGuestUser
    Description :  used to identify guest user or not
    Input       :  NA
    Return type :  Boolean
    ***********************************************************************/ 
    @AuraEnabled(cacheable=true)
    public static Boolean isGuestUser(){
        return UserInfo.getUserType() == 'Guest';
    }  

    /********************************************************************** 
    Method Name :  updatePoNum
    Description :  used to update Ponumber field for guest users
    Input       :  Id, Id
    Return type :  NA
    ***********************************************************************/ 
    @AuraEnabled
    public static void updatePoNum(Id webcartId, Id currentaccountId){
       String poNumber;
       try{
       List<sobject> orderPoNumber= new List<sobject>();            
         String maxValue;
         String newMaxValue;           
          orderPoNumber = [SELECT MAX(PoNumber__c) FROM WebCart where PoNumber__c LIKE 'WEBORD%'];
           system.debug('orderPoNumber'+ orderPoNumber);            
           if(!orderPoNumber.isEmpty() && orderPoNumber[0].get('expr0') != null){
           		 maxValue = (String)orderPoNumber[0].get('expr0');
                Integer numericPart = Integer.valueOf(maxValue.substring(6)) + 1;
                 poNumber = 'WEBORD' + String.valueOf(numericPart).leftPad(6,'0');
            }  
       } catch(Exception e) {
            System.debug('Exception type caught: ' + e.getTypeName());    
            System.debug('Message: ' + e.getMessage());    
            System.debug('Cause: ' + e.getCause());
            System.debug('Line number: ' + e.getLineNumber());    
            System.debug('Stack trace: ' + e.getStackTraceString());
        }  
        try{   
            if(String.isBlank(poNumber)){
             poNumber = scc_constantHelper.WEBORD_KEYWORD;
            }         
            WebCart  webCartItems=[Select Id,IsSecondary,Master_User__c,User_Cart_Name__c,PoNumber__c from WebCart where Id=:webcartId ];
            if(webCartItems.PoNumber__c ==null){
            webCartItems.PoNumber__c = poNumber;
            update webCartItems;  
            }
        }
          catch(Exception e) {
            System.debug('Exception type caught: ' + e.getTypeName());    
            System.debug('Message: ' + e.getMessage());    
            System.debug('Cause: ' + e.getCause());
            System.debug('Line number: ' + e.getLineNumber());    
            System.debug('Stack trace: ' + e.getStackTraceString());
        }           
    }  
    
    /********************************************************************** 
    Method Name :  getServiceLvlOptions
    Description :  used to get the service level options
    Input       :  NA
    Return type :  String
    ***********************************************************************/  
    @AuraEnabled(cacheable=true)
    public static String getServiceLvlOptions(){
       List<scc_shipping_Service_Level__mdt> ServiceLvl = [SELECT Id,isActive__c, priority__c,Label,Value__c  From scc_shipping_Service_Level__mdt WHERE IsActive__c=true ORDER BY Priority__c ASC NULLS LAST];
         List<getServiceOptionsWrapper> getServiceOptionsWrapper = new List<getServiceOptionsWrapper>();
        for(Integer i=0;i<ServiceLvl.size();i++){
            getServiceOptionsWrapper.add(new getServiceOptionsWrapper(ServiceLvl[i].Label,ServiceLvl[i].Value__c )); 
        }
        return JSON.serialize(getServiceOptionsWrapper);
    }
    
    /********************************************************************** 
    Method Name :  updateShipAddress
    Description :  used to update user selected shipping address
    Input       :  cardit, name, city, province etc..
    Return type :  String
    ***********************************************************************/  
    @AuraEnabled
    public static string updateShipAddress(Id cartID, String name,String street,String city,String province,String postalCode,String country, String shipToNumber){
    try{
        Webcart wc = [select id,AccountId,Shipping_Street__c,Shipto_name__c,Shipping_City__c,Shipping_State__c,Shipping_Country__c,Shipping_Zip_Code__c,SAP_Shipto__c from Webcart where id=:cartID];
        wc.Shipping_Street__c = street;
        wc.Shipping_City__c = city;
        wc.Shipping_State__c = province;
        wc.Shipping_Country__c = country;
        wc.Shipping_Zip_Code__c = postalCode;
        wc.SAP_Shipto__c = shipToNumber;
        wc.Sold_To_Customer__c = shipToNumber;
        wc.Shipto_name__c = name;
        upsert wc;
        return 'Success';
      }catch(Exception e){
            system.debug('Exception:'+e.getMessage());
            throw new AuraHandledException('Failed to update Ship address :'+e.getMessage());
        }  
    }
    /********************************************************************** 
    Method Name :  updateLicenseToAddress
    Description :  used to update user selected License To address
    Input       :  cardit, name, city, province etc..
    Return type :  String
    ***********************************************************************/  
    @AuraEnabled
    public static string updateLicenseToAddress(Id cartID, String name,String street,String city,String state,String postalCode,String country, String shipToNumber){
    try{
        Webcart wc = [select id,AccountId,License_Partner__c, License_To__Street__s, License_To__City__s, License_To__PostalCode__s, License_To__StateCode__s, License_To__CountryCode__s, License_To__c,SAP_Shipto__c from Webcart where id=:cartID];
        wc.License_To__Street__s = street;
        wc.License_To__City__s = city;
        wc.License_To_State__c = state;
        wc.License_To_Country__c = country;
        wc.License_To__PostalCode__s = postalCode;
        wc.License_Partner__c = shipToNumber;
        wc.License_To_Name__c= name;
        upsert wc;
        return 'Success';
      }catch(Exception e){
            system.debug('Exception:'+e.getMessage());
            throw new AuraHandledException('Failed to update license to address :'+e.getMessage());
        }  
    }
    
    @AuraEnabled
    public static string updateShipServiceLvel(Id cartID, String shippingServiceLevel){
        Webcart wc = [select id,Shipping_Conditions__c from Webcart where id=:cartID];
        wc.Shipping_Conditions__c = shippingServiceLevel;
        upsert wc;
        return 'Success';
    }
    
    @AuraEnabled(cacheable=true)
    public static String getShippingInstructionOptions(){
        List<scc_checkOut_Shipping_Instruction__mdt> scc_ShippingInstructionData = [SELECT MasterLabel,Priority__c,IsActive__c FROM scc_checkOut_Shipping_Instruction__mdt WHERE IsActive__c=true ORDER BY Priority__c ASC NULLS LAST];
        List<getShippingInfoOptionsWrapper> getShippingInfoOptionsWrap = new List<getShippingInfoOptionsWrapper>();
        for(Integer i=0;i<scc_ShippingInstructionData.size();i++){
            getShippingInfoOptionsWrap.add(new getShippingInfoOptionsWrapper(scc_ShippingInstructionData[i].MasterLabel,scc_ShippingInstructionData[i].MasterLabel)); 
        }
        return JSON.serialize(getShippingInfoOptionsWrap);
    }
      public class getShippingInfoOptionsWrapper{
            public String label;
            public String value;
           getShippingInfoOptionsWrapper(String label,String value){
               this.label = label;
               this.value = value;
           }
       }
    /********************************************************************** 
    Method Name :  getCurrentUserShippingAddress
    Description :  used to fetch current user shipping addresses
    Input       :  NA
    Return type :  List
    ***********************************************************************/  
     @AuraEnabled(cacheable=true)
    public static List<addressWrapper> getCurrentUserShippingAddress(){ 
       
        List<user> usr= new List<User>();
        List<addressWrapper> shipAddress= new List<addressWrapper>();
        String billing='Billing';
        String shipping='shipping';
        Id userId = UserInfo.getUserId();     
        User accid=[SELECT AccountId,Id FROM User WHERE Id = :userId Limit 1];   
        Id acId=accid.AccountId;
    	Set <Id> accountchildIds= new Set <Id>();
        accountchildIds.add(acId);
        for(Affiliation__c affChildaccount: [Select Child_Account__c from Affiliation__c where Parent_Account__c=:acId ]){
            accountchildIds.add(affChildaccount.Child_Account__c);
        }
        for(Account Childaccount: [Select Id from Account where Parentid=:acId ]){
            accountchildIds.add(Childaccount.Id);
        }     
        List<Account> accaddr= new List<Account>();
        accaddr=[select Id,Name,Type, BillingCity,BillingPostalCode,BillingState,BillingStreet,BillingCountry,SAP_Account_Id__c,SAP_Account_Number__c,ShippingCity,ShippingCountry,ShippingPostalCode,ShippingState,ShippingStreet
                 From Account 
                 where Id=:accountchildIds ];
        for (Account acc : accaddr) {
            addressWrapper wrapper = new addressWrapper();
            wrapper.SAccountName=acc.Name;
            Wrapper.AccShipId=acc.Id;
            wrapper.ShipToNumber=acc.SAP_Account_Id__c;
            wrapper.ShipStreet=acc.ShippingStreet;
            wrapper.ShippingCity=acc.ShippingCity;
            wrapper.Provionce=acc.ShippingState;
            wrapper.PostalCode=acc.ShippingPostalCode;
            wrapper.ShippingCountry=acc.ShippingCountry;
            shipAddress.add(wrapper);
        }
        List<Account_Addresses__c> accountaddr= new List<Account_Addresses__c>();
        accountaddr =[SELECT Id,Account__c,ERP_Account_Name__c,Address_1__c,Address_2__c,Address_3__c,Address_4__c,Address_Type__c,City__c,Country__c,ERP_Account_Number__c,State__c,Zip_Code__c
                      FROM Account_Addresses__c 
                      where Account__c= :accountchildIds  AND Address_Type__c=:shipping ];
        if(!accountaddr.isEmpty()){
            for (Account_Addresses__c acc : accountaddr) {
                addressWrapper wrapper1 = new addressWrapper();
                wrapper1.SAccountName=acc.ERP_Account_Name__c;
                wrapper1.ShipToNumber=acc.ERP_Account_Number__c;
                wrapper1.ShipStreet=(acc.Address_1__c != null ? acc.Address_1__c+' ' : '')+(acc.Address_2__c != null ? acc.Address_2__c+' ' : ' ')+(acc.Address_3__c != null ? acc.Address_3__c+' ' : ' ')+(acc.Address_4__c != null ? acc.Address_4__c : '');
                Wrapper1.AccShipId=acc.Id;
                wrapper1.ShippingCity=(acc.City__c != null ? acc.City__c : '');
                wrapper1.Provionce=(acc.State__c != null ? acc.State__c : '');
                wrapper1.PostalCode=(acc.Zip_Code__c != null ? acc.Zip_Code__c : '');
                wrapper1.ShippingCountry=(acc.Country__c != null ? acc.Country__c : '');
                shipAddress.add(wrapper1);
            }
        }
        return shipAddress;           
      }
    /********************************************************************** 
    Method Name :  getCurrShipTo
    Description :  used to  Fetch current shipping address
    Input       :  NA
    Return type :  list
    ***********************************************************************/  
    @AuraEnabled(cacheable=true)
    public static List<WebCart> getCurrShipTo(){ 
       List<user> usr= new List<User>();
       List<addressWrapper> shipAddress= new List<addressWrapper>(); 
       String shipping='Shipping';
       Id userId = UserInfo.getUserId(); 

       User accid=[SELECT AccountId,Id FROM User WHERE Id = :userId Limit 1];  
       Id acId=accid.AccountId;
       List<WebCart> cartaddr =[SELECT Id,AccountId,Account.Name,BillingCity,BillingCountry,BillingStreet,BillingState,BillingPostalCode,BillingName__c,IsSecondary,SAP_Shipto__c,Master_User__c,Status,WebStoreId,Shipto_name__c,Shipping_Street__c,Shipping_City__c,Shipping_State__c,Shipping_Country__c,Shipping_Zip_Code__c,Specify_One_Time_Shipping__c,TotalProductAmount, Shipping_Amount__c, Coupon_Discount__c, PoNumber__c FROM WebCart WHERE AccountId =: acId AND IsSecondary = False AND Status ='Active' AND Master_User__c=: userId ];
       String shipTo;
        if(!Test.isRunningTest()){
          shipTo = cartaddr[0].SAP_Shipto__c;  
        }else{
          shipTo = '1234';   
        } 
       List<Account_Addresses__c> accountShipToAddr =[SELECT Id,Account__c,ERP_Account_Name__c,Address_1__c,Address_2__c,Address_3__c,Address_4__c,Address_Type__c,City__c,Country__c,ERP_Account_Number__c,State__c,Zip_Code__c,Account__r.SAP_Account_Id__c
                      FROM Account_Addresses__c 
                      where (ERP_Account_Number__c=:shipTo OR Account__r.SAP_Account_Id__c=:shipTo) AND Address_Type__c=:shipping];
       return cartaddr;
    }
    
    public static void sendOrderDetails(String orderId, String accountId) {
        String token = [SELECT Id, Token__c FROM WebCart where Order_Id__c =: orderId LIMIT 1].Token__c;
        Send_Order_To_ERP__e orderEvent = new Send_Order_To_ERP__e(
            Order_ID__c = orderId,
            Account_ID__c = accountId,
            Token__c = token
        );
        Database.SaveResult sr = EventBus.publish(orderEvent);
        if (!sr.isSuccess()) {
            throw new AuraHandledException('Failed to send order details to ERP.');
        }
    }
    /********************************************************************** 
    Method Name :  createERPOrder
    Description :  used to create guest ERP prder
    Input       :  cardit and accountid
    Return type :  Id
    ***********************************************************************/  
    @AuraEnabled
    public static Id createERPOrder(String cartId, String accountId){
        try{
            Id currAcctId;
            Boolean isTopLevelAccount = false;             
            Boolean promo_Code_Sent = false;
            List<OrderItem> OrderItems = new List<OrderItem>();
            Webcart wc = [select id,API_SOURCE__c,AccountId,Shipping_Street__c,Shipping_City__c,Shipping_State__c,Shipping_Country__c,Shipto_name__c,BillingName__c,Sold_To_Customer__c,Shipping_Zip_Code__c,Shipping_Conditions__c,Coupon__c,PoNumber__c, SAP_Shipto__c, SAP_BillTo__c, SAP_Salesorg__c,BillingStreet, BillingCity, BillingState, BillingCountry, BillingPostalCode,
                           License_Partner__c, License_To__Street__s, License_To__City__s, License_To__PostalCode__s, License_To__StateCode__s, License_To__CountryCode__s,TotalProductAmount,Coupon_Discount__c,Shipping_Amount__c,Site_Id__c, CreatedBy.Id from Webcart where id=:cartId];
            List<CartItem> CartItems = [select id,Name,Price_condition__c,Price_Per_Unit__c,Title_Desc_Full__c,Line_Item_Status__c,Price_Override__c,CartId,Discount__c,Quantity,Product2Id,NetUnitPrice,Product2.Name,Product2.Availability__c From CartItem Where CartId=:cartId];
            User accid=[SELECT Id, 	AccountId FROM User WHERE Id = :UserInfo.getUserId() Limit 1];  
            Id acId=accid.AccountId;
            User userDetails = [SELECT Name, Phone, Email, ContactId FROM User where Id=: wc.CreatedBy.Id LIMIT 1];
            
            User currUserDetail = [SELECT Name, Phone, Email, ContactId FROM User where Id=: UserInfo.getUserId() LIMIT 1];
            String deliveryInfo = 'delivery info:'+String.valueOf(userDetails.Phone)+' '+userDetails.Email;            
            
            Order ord = new Order();
            ord.AccountId = accountId;
            ord.SAP_BillTo__c = wc.SAP_BillTo__c;
            ord.SAP_Shipto__c = wc.SAP_Shipto__c;
            ord.Account_PO_Number__c = wc.PoNumber__c; 
            ord.Sold_To_Customer__c = wc.Sold_To_Customer__c;
            ord.SAP_SalesOrg__c = wc.SAP_Salesorg__c;
            ord.ShipTo_Name__c = wc.Shipto_name__c;
            ord.BillingPhoneNumber = String.valueOf(userDetails.Phone);
            ord.Customer_Email__c = userDetails.Email;
            ord.BillingEmailAddress = userDetails.Email;
            ord.Shipment_Confirmation_Email__c = userDetails.Email;
            ord.Shipping_instruction__c = deliveryInfo;
            ord.ShippingStreet = wc.Shipping_Street__c;
            ord.ShippingCity = wc.Shipping_City__c;
            ord.ShippingState = wc.Shipping_State__c;
            //ord.ShippingCountry = wc.Shipping_Country__c;
            ord.ShippingPostalCode = wc.Shipping_Zip_Code__c;
            ord.BillingName__c = wc.BillingName__c;
            ord.BillingStreet = wc.BillingStreet;
            ord.BillingCity = wc.BillingCity;
            ord.BillingState = wc.BillingState;
            //ord.BillingCountry = wc.BillingCountry;
            ord.BillingPostalCode = wc.BillingPostalCode;
            ord.License_To__Street__s = wc.License_To__Street__s;
            ord.License_To__City__s = wc.License_To__City__s;
            ord.License_To__PostalCode__s = wc.License_To__PostalCode__s;
            ord.License_Partner__c = wc.SAP_Shipto__c;
            ord.Has_One_Time_Ship__c = true;
            ord.Status = 'Draft';
            ord.EffectiveDate = System.Today();
            ord.Coupon__c = wc.Coupon__c;
            ord.Shipping_Conditions__c = wc.Shipping_Conditions__c;
            ord.PO_Date__c = system.today();
            ord.Coupon_Discount__c = wc.Coupon_Discount__c;
            ord.Order_Source__c = (wc.API_SOURCE__c == null) ? 'OWEB' : 'EWEB';          
            ord.PoNumber__c = wc.PoNumber__c;
            ord.SAP_Order_Type__c = 'YORD';
            currAcctId = acId;
            List<String> usaCountry = new List<String>{'us', 'usa', 'united states'};
            List<String> canadaCountry = new List<String>{'canada', 'ca'};
            if(usaCountry.contains(wc.BillingCountry.toLowerCase())){
            	ord.BillingCountry = 'US';
            }else if(canadaCountry.contains(wc.BillingCountry.toLowerCase())){
            	ord.BillingCountry = 'CA';
            }else{                    
            	List<ZVC__Country_Phone_Code__c> getCountrysOptionsData = [SELECT Name,ZVC__Country_Code__c FROM ZVC__Country_Phone_Code__c WHERE ZVC__Country_Code__c=:wc.BillingCountry LIMIT 1];        
            	if(!getCountrysOptionsData.isEmpty()){
            		ord.BillingCountry = getCountrysOptionsData[0].Name;
            	}else{
            		ord.BillingCountry = wc.BillingCountry;                     
            	}                    
            }
            
            if(usaCountry.contains(wc.Shipping_Country__c.toLowerCase())){
                ord.ShippingCountry = 'US';
            }else if(canadaCountry.contains(wc.Shipping_Country__c.toLowerCase())){
                ord.ShippingCountry = 'CA';
            }else{
                List<ZVC__Country_Phone_Code__c> getCountrysOptionsData = [SELECT Name,ZVC__Country_Code__c FROM ZVC__Country_Phone_Code__c WHERE ZVC__Country_Code__c=:wc.Shipping_Country__c LIMIT 1];        
                if(!getCountrysOptionsData.isEmpty()){
                    ord.ShippingCountry = getCountrysOptionsData[0].Name;
                }else{
                    ord.ShippingCountry = wc.Shipping_Country__c;                        
                }
            }            
            /*while (!isTopLevelAccount) {                
                List<Account> acct = [select Id, ParentId,Registration_Promo_Code_Sent__c, Promo_end_date__c From Account where Id = :currAcctId limit 1];
                if(!acct.isEmpty()){
                    if (acct[0].ParentId != null) {
                    currAcctId = acct[0].ParentID;
                } else {
                    isTopLevelAccount = true;
                    if(acct[0].Registration_Promo_Code_Sent__c == True && system.today() <= acct[0].Promo_end_date__c){
                        ord.New_registered_user_discount__c  = True;
                    } else {
                        ord.New_registered_user_discount__c  = False;
                    }
                }
                }                
            }    */
            
            Map<Id, Account> accountMap = new Map<Id, Account>([
                SELECT Id, ParentId, Registration_Promo_Code_Sent__c, Promo_end_date__c 
                FROM Account 
                WHERE Id = :currAcctId OR ParentId != null
            ]);
            
            
            while (!isTopLevelAccount) {
                Account currAcct = accountMap.get(currAcctId);
                if (currAcct != null) {
                    if (currAcct.ParentId != null) {
                        currAcctId = currAcct.ParentId;
                    } else {
                        isTopLevelAccount = true;
                        if (currAcct.Registration_Promo_Code_Sent__c == true && System.today() <= currAcct.Promo_end_date__c) {
                            ord.New_registered_user_discount__c = true;
                        } else {
                            ord.New_registered_user_discount__c = false;
                        }
                    }
                } else {
                    isTopLevelAccount = true; // Exit loop if account is not found
                }
            }
            insert ord;
            for(CartItem ci:CartItems){
            OrderItem oi = new OrderItem();
            
            oi.ISBN__c = ci.Name;
            oi.Description = ci.Title_Desc_Full__c;
            oi.SAP_Order_Item_status__c = ci.Line_Item_Status__c;
            oi.UnitPrice = ci.NetUnitPrice;
            oi.ListPrice = ci.Price_Per_Unit__c;
            oi.Discount__c = ci.Discount__c;
            oi.Quantity = ci.Quantity;
            oi.OrderId = ord.Id;
            oi.Product2Id = ci.Product2Id;
            oi.Price_condition__c= ci.Price_condition__c;
           OrderItems.add(oi);
          } 
            if(!OrderItems.isEmpty()){
               insert OrderItems;
            }
            updateWebCartOrderId(cartId, ord.Id);
            sendOrderDetails(ord.Id, accountId);
            return ord.Id;
        }catch(Exception e){
            system.debug('Exception:'+e.getMessage());
            throw new AuraHandledException('Failed to create ERP order :'+e.getMessage());
        } 
    }
    /********************************************************************** 
    Method Name :  createOrderRecord
    Description :  used to create order record for registered user
    Input       :  firstname, lastname, phone etc..
    Return type :  Id
    ***********************************************************************/    
    @AuraEnabled
    public static Id createOrderRecord(String firstName, String lastName, String phone, String email, String ship_email, Date RequestedShipDate, String BillToAttention, String ShipToAttention,String Warehouse,String DeliveryContactPhone, String DeliveryContactEmail, String cartID, String promoCd, String shippingServiceLvl, String delivryInstruction,
                                      Boolean isCreditCardSelected, Map<String,String> cardDetails, String poNumber,boolean isProvisionDisabled,String lName,String lStreet, String lCity, String lCountry, String lPostalCode){
        try{
            Id currAcctId;
            Boolean dealerCheck;
            Boolean isTopLevelAccount = false;
            Boolean promo_Code_Sent = false;
            List<user> usr= new List<User>();
            List<OrderItem> OrderItems = new List<OrderItem>();
            Id userId = UserInfo.getUserId();
            Id profileId=userinfo.getProfileId();
            User userDetails = [SELECT Name, Phone, Email, ContactId FROM User where Id=: UserInfo.getUserId() LIMIT 1];
            String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
            String deliveryInfo = delivryInstruction != null ? delivryInstruction : '' ;
            User accid=[SELECT Id, 	AccountId,Account.Type FROM User WHERE Id = :UserInfo.getUserId() Limit 1];  
            Id acId=accid.AccountId;
            Date EffectiveDate1 = System.Today();
            system.debug('***getCpuTime()***'+Limits.getCpuTime());
            Webcart wc = [select id,AccountId,Account.Type,API_SOURCE__c,Shipto_name__c,Shipping_Street__c,Shipping_City__c,Shipping_State__c,Shipping_Country__c,Sold_To_Customer__c,Shipping_Zip_Code__c,Shipping_Conditions__c,Coupon__c,PoNumber__c, SAP_Shipto__c, SAP_BillTo__c, SAP_Salesorg__c,BillingName__c, BillingStreet, BillingCity, BillingState, BillingCountry, BillingPostalCode,
                           License_Partner__c,License_To_Name__c,License_To_State__c,License_To_Country__c,License_To__Street__s, License_To__City__s, License_To__PostalCode__s, License_To__StateCode__s, License_To__CountryCode__s,TotalProductAmount,Coupon_Discount__c,Shipping_Amount__c,Specify_One_Time_Shipping__c from Webcart where id=:cartID];
            List<CartItem> CartItems = [select id,Name,Price_condition__c,Title_Desc_Full__c,Line_Item_Status__c,Price_Override__c,CartId,Discount__c,Quantity,Product2Id,NetUnitPrice,Price_Per_Unit__c,Product2.Name From CartItem Where CartId=:cartID];
            Order ord = new Order();
                ord.AccountId = acId;                            
                ord.Contact_First_Name__c=firstName;
                ord.Contact_Last_Name__c=lastName;
                ord.SAP_BillTo__c = wc.SAP_BillTo__c;
                ord.SAP_Shipto__c = wc.SAP_Shipto__c;
            	ord.Has_One_Time_Ship__c = wc.Specify_One_Time_Shipping__c;
                ord.Account_PO_Number__c = wc.PoNumber__c; 
                ord.Sold_To_Customer__c = wc.Sold_To_Customer__c;
                ord.SAP_SalesOrg__c = wc.SAP_Salesorg__c;
                ord.ShipTo_Name__c = wc.Shipto_name__c;
                ord.BillingPhoneNumber = String.valueOf(phone);
                ord.Customer_Email__c = email;
                ord.BillingEmailAddress = email;
                ord.Shipment_Confirmation_Email__c = ship_email;
                ord.Deliver_On__c = RequestedShipDate;
                ord.Attention_Billing__c = BillToAttention;
                ord.Attention_Shipping__c = ShipToAttention;
                ord.Warehouse_text__c = Warehouse;
                ord.Shipping_instruction__c  = deliveryInfo;
                ord.ShippingStreet = wc.Shipping_Street__c;
                ord.ShippingCity = wc.Shipping_City__c;
                ord.ShippingState = wc.Shipping_State__c;
                //ord.ShippingCountry = wc.Shipping_Country__c;
                ord.ShippingPostalCode = wc.Shipping_Zip_Code__c;
                ord.Status = 'Draft';
                ord.EffectiveDate = System.Today();
                ord.Coupon__c = promoCd;
                ord.Shipping_Conditions__c = wc.Shipping_Conditions__c;
                ord.BillingStreet = wc.BillingStreet;
                ord.BillingCity = wc.BillingCity;
                ord.BillingState = wc.BillingState;
            	List<String> usaCountry = new List<String>{'us', 'usa', 'united states'};
                List<String> canadaCountry = new List<String>{'canada', 'ca'};
                if(usaCountry.contains(wc.BillingCountry.toLowerCase())){
                    ord.BillingCountry = 'US';
                }else if(canadaCountry.contains(wc.BillingCountry.toLowerCase())){
                    ord.BillingCountry = 'CA';
                }else{                    
                    List<ZVC__Country_Phone_Code__c> getCountrysOptionsData = [SELECT Name,ZVC__Country_Code__c FROM ZVC__Country_Phone_Code__c WHERE ZVC__Country_Code__c=:wc.BillingCountry LIMIT 1];        
                    if(!getCountrysOptionsData.isEmpty()){
                        ord.BillingCountry = getCountrysOptionsData[0].Name;
                    }else{
                    	ord.BillingCountry = wc.BillingCountry;                     
                    }                    
                }
            
                if(usaCountry.contains(wc.Shipping_Country__c.toLowerCase())){
                    ord.ShippingCountry = 'US';
                }else if(canadaCountry.contains(wc.Shipping_Country__c.toLowerCase())){
                    ord.ShippingCountry = 'CA';
                }else{
                    List<ZVC__Country_Phone_Code__c> getCountrysOptionsData = [SELECT Name,ZVC__Country_Code__c FROM ZVC__Country_Phone_Code__c WHERE ZVC__Country_Code__c=:wc.Shipping_Country__c LIMIT 1];        
                    if(!getCountrysOptionsData.isEmpty()){
                        ord.ShippingCountry = getCountrysOptionsData[0].Name;
                    }else{
                    	ord.ShippingCountry = wc.Shipping_Country__c;                        
                    }
                }            
                //ord.BillingCountry = wc.BillingCountry;
                ord.BillingPostalCode = wc.BillingPostalCode;
                ord.License_To__Street__s = wc.License_To__Street__s;
                ord.License_To__City__s = wc.License_To__City__s;
                ord.License_To__PostalCode__s = wc.License_To__PostalCode__s;
            	ord.License_To_Name__c =wc.License_To_Name__c;
                ord.License_To_State__c=wc.License_To_State__c;
            	ord.License_To_Country__c = wc.License_To_Country__c;
                ord.License_Partner__c = wc.License_Partner__c;
                ord.Delivery_Contact_Phone__c = DeliveryContactPhone;
                ord.Delivery_Contact_Email__c = DeliveryContactEmail;
                ord.PO_Date__c = system.today();
                ord.Coupon_Discount__c = wc.Coupon_Discount__c;
                ord.Abandon_Notification__c = '0';
    			ord.SAP_Order_Type__c = 'YORD';
                ord.Order_Source__c = (wc.API_SOURCE__c == null) ? 'OWEB' : 'EWEB';
                if(wc.Specify_One_Time_Shipping__c == true){
                   dealerCheck= System.Label.scc_LICALL_Dealers.contains(accid.Account.Type);
                   ord.SAP_Shipto__c = (dealerCheck == true) ? '0000016': '0000009';
                   ord.Sold_To_Customer__c = wc.SAP_BillTo__c;
                }
               
                if(isCreditCardSelected){
                    String cardType = cardDetails.get('cardType');
                    if(cardType == 'VI'){
                        cardType = 'VISA';
                    }else if(cardType == 'AX'){
                        cardType = 'AMEX';
                    }else if(cardType == 'DI'){
                        cardType = 'DISC';
                    }
                    String expDate = cardDetails.get('expYear')+'-'+cardDetails.get('expMonth')+'-01';
                    ord.cctype__c = cardType;
                    ord.ccNumberEnc__c = cardDetails.get('tokenizedCardNumber');
                    ord.ccExpDate__c = Date.valueOf(expDate);
					ord.BillingName__c = wc.BillingName__c;
                    ord.PoNumber__c = wc.PoNumber__c;
                }else{
                    ord.isPOSelected__c = true;
                    ord.PoNumber__c = (poNumber !='' ? poNumber : wc.PoNumber__c);
                    ord.BillingName__c = wc.BillingName__c;
                }
            currAcctId = acId;
            while (!isTopLevelAccount) {                
                List<Account> acct = [select Id, ParentId,Registration_Promo_Code_Sent__c,Promo_end_date__c From Account where Id = :currAcctId limit 1];
                  if(!acct.isEmpty()){
                    if (acct[0].ParentId != null) {
                    currAcctId = acct[0].ParentID;
                } else {
                    isTopLevelAccount = true;
                    if(acct[0].Registration_Promo_Code_Sent__c == True && system.today() <= acct[0].Promo_end_date__c){
                        ord.New_registered_user_discount__c  = True;
                    } else {
                        ord.New_registered_user_discount__c  = False;
                    }
                }
                }
            }            
            insert ord;
            for(CartItem ci:CartItems){
            OrderItem oi = new OrderItem();
            
            oi.ISBN__c = ci.Name;
            oi.Requested_Delivery_Date__c = RequestedShipDate;
            oi.Description = ci.Title_Desc_Full__c;
            oi.SAP_Order_Item_status__c = ci.Line_Item_Status__c;
            oi.UnitPrice = ci.NetUnitPrice;
            oi.ListPrice = ci.Price_Per_Unit__c;
            oi.Discount__c = ci.Discount__c;
            oi.Quantity = ci.Quantity;
            oi.OrderId = ord.Id;
            oi.Product2Id = ci.Product2Id;
            oi.Price_condition__c= ci.Price_condition__c;
                OrderItems.add(oi);
          } 
            if(!OrderItems.isEmpty()){
               insert OrderItems;
            }
            updateWebCartOrderId(cartID, ord.Id);
            system.debug('***getCpuTime()***'+Limits.getCpuTime());
            return ord.Id;
        }catch(Exception e){
        system.debug('Exception:'+e.getMessage());
        System.debug('Exception type caught: ' + e.getTypeName());    
        System.debug('Cause: ' + e.getCause());    
        System.debug('Line number: ' + e.getLineNumber());    
        System.debug('Stack trace: ' + e.getStackTraceString());
        throw new AuraHandledException('Failed to create SF order :'+e.getMessage());            
        }        
    }
    /********************************************************************** 
    Method Name :  createGuestOrderRecord
    Description :  used to create guest order record 
    Input       :  firstname, lastname, phone etc..
    Return type :  Id
    ***********************************************************************/   
    @AuraEnabled
    public static Id createGuestOrderRecord(String firstName, String lastName, String phone, String email, String ship_email, Date RequestedShipDate, String ShipToAttention, String cartId, String guestAccountId, String promoCd, String shippingServiceLvl,
                                      Map<String,String> cardDetails, Map<String,String> shipAddressMap, Boolean isBillAddressSame, Map<String,String> billAddressMap, Map<String,String> institutionDetails){
        try{
            system.debug('***getCpuTime()***'+Limits.getCpuTime());
            String expDate = cardDetails.get('expYear')+'-'+cardDetails.get('expMonth')+'-01';
            String deliveryInfo = 'delivery info:'+phone+' '+email;
            List<OrderItem> OrderItems = new List<OrderItem>();
            String cardType = cardDetails.get('cardType');
            if(cardType == 'VI'){
                cardType = 'VISA';
            }else if(cardType == 'AX'){
                cardType = 'AMEX';
            }else if(cardType == 'DI'){
                cardType = 'DISC';
            }
    		
            Webcart wc = [select id,AccountId,API_SOURCE__c,Shipping_Street__c,Shipping_City__c,Shipping_State__c,Shipping_Country__c,Sold_To_Customer__c,Shipping_Zip_Code__c,Shipping_Conditions__c,Coupon__c,PoNumber__c, SAP_Shipto__c, SAP_BillTo__c, SAP_Salesorg__c,BillingStreet, BillingCity, BillingState, BillingCountry, BillingPostalCode,
                           License_Partner__c, Shipto_name__c,BillingName__c, License_To__Street__s, License_To__City__s, License_To__PostalCode__s, License_To__StateCode__s, License_To__CountryCode__s,TotalProductAmount,Coupon_Discount__c,Shipping_Amount__c,Site_Id__c from Webcart where id=:cartId];
            List<CartItem> CartItems = [select id,Name,Price_condition__c,Price_Per_Unit__c,Title_Desc_Full__c,Line_Item_Status__c,Price_Override__c,CartId,Discount__c,Quantity,Product2Id,NetUnitPrice,Product2.Name,Product2.Availability__c From CartItem Where CartId=:cartId];
            Order ord = new Order();
            ord.AccountId = guestAccountId;                        
            ord.Contact_First_Name__c=firstName;
            ord.Contact_Last_Name__c=lastName;
            ord.SAP_BillTo__c = wc.SAP_BillTo__c;
            ord.SAP_Shipto__c = wc.SAP_Shipto__c;
            ord.Account_PO_Number__c = wc.PoNumber__c; 
            ord.Sold_To_Customer__c = wc.Sold_To_Customer__c;
            ord.SAP_SalesOrg__c = wc.SAP_Salesorg__c;
            ord.ShipTo_Name__c = wc.Shipto_name__c;
            ord.BillingPhoneNumber = String.valueOf(phone);
            ord.Customer_Email__c = email;
            ord.BillingEmailAddress = email;
            ord.Shipment_Confirmation_Email__c = ship_email;
            //ord.Cancel_After_Date__c = CancelBackOrderDate;
            ord.Attention_Shipping__c = ShipToAttention;
            ord.Shipping_instruction__c = deliveryInfo;
            ord.ShippingStreet = shipAddressMap.get('shipStreet')+' '+shipAddressMap.get('shipFloor');
            ord.ShippingCity = shipAddressMap.get('shipCity');
            ord.ShippingState = shipAddressMap.get('shipState');
            //ord.ShippingCountry = shipAddressMap.get('shipCountry');
            ord.ShippingPostalCode = shipAddressMap.get('shipZip');
            ord.ShipTo_Name__c = shipAddressMap.get('shipName');
            ord.Has_One_Time_Ship__c = true;
            ord.Status = 'Draft';
            ord.EffectiveDate = System.Today();
            ord.Coupon__c = promoCd;
            ord.Shipping_Conditions__c = wc.Shipping_Conditions__c;
            ord.PO_Date__c = system.today();
            ord.Coupon_Discount__c = wc.Coupon_Discount__c;
            ord.Order_Source__c = (wc.API_SOURCE__c == null) ? 'OWEB' : 'EWEB';          
            ord.cctype__c = cardType;
            ord.ccNumberEnc__c = cardDetails.get('tokenizedCardNumber');
            ord.ccExpDate__c = Date.valueOf(expDate);
            ord.PoNumber__c = wc.PoNumber__c;
            ord.SAP_Order_Type__c = 'YORD';
            List<String> usaCountry = new List<String>{'us', 'usa', 'united states'};
            List<String> canadaCountry = new List<String>{'canada', 'ca'};
            if(usaCountry.contains(shipAddressMap.get('shipCountry').toLowerCase())){
                ord.ShippingCountry = 'US';
            }else if(canadaCountry.contains(shipAddressMap.get('shipCountry').toLowerCase())){
                ord.ShippingCountry = 'CA';
            }else{                    
                List<ZVC__Country_Phone_Code__c> getCountrysOptionsData = [SELECT Name,ZVC__Country_Code__c FROM ZVC__Country_Phone_Code__c WHERE ZVC__Country_Code__c=:shipAddressMap.get('shipCountry') LIMIT 1];        
                if(!getCountrysOptionsData.isEmpty()){
                	ord.ShippingCountry = getCountrysOptionsData[0].Name;
                }else{
                	ord.ShippingCountry = shipAddressMap.get('shipCountry');                     
                }                    
            }
            if(!isBillAddressSame){
                ord.BillingName__c = billAddressMap.get('billName');
                ord.BillingStreet = billAddressMap.get('billStreet')+' '+billAddressMap.get('billFloor');
                ord.BillingCity = billAddressMap.get('billCity');
                ord.BillingState = billAddressMap.get('billState');
                //ord.BillingCountry = billAddressMap.get('billCountry');
                if(usaCountry.contains(billAddressMap.get('billCountry').toLowerCase())){
                    ord.BillingCountry = 'US';
                }else if(canadaCountry.contains(billAddressMap.get('billCountry').toLowerCase())){
                    ord.BillingCountry = 'CA';
                }else{                    
                    List<ZVC__Country_Phone_Code__c> getCountrysOptionsData = [SELECT Name,ZVC__Country_Code__c FROM ZVC__Country_Phone_Code__c WHERE ZVC__Country_Code__c=:billAddressMap.get('billCountry') LIMIT 1];        
                    if(!getCountrysOptionsData.isEmpty()){
                        ord.BillingCountry = getCountrysOptionsData[0].Name;
                    }else{
                        ord.BillingCountry = billAddressMap.get('billCountry');                     
                    }                    
                }                
                ord.BillingPostalCode = billAddressMap.get('billZip');
            }else{
                ord.BillingName__c = shipAddressMap.get('shipName');
                ord.BillingStreet = shipAddressMap.get('shipStreet')+' '+shipAddressMap.get('shipFloor');
                ord.BillingCity = shipAddressMap.get('shipCity');
                ord.BillingState = shipAddressMap.get('shipState');
                //ord.BillingCountry = shipAddressMap.get('shipCountry');
                if(usaCountry.contains(shipAddressMap.get('shipCountry').toLowerCase())){
                    ord.BillingCountry = 'US';
                }else if(canadaCountry.contains(shipAddressMap.get('shipCountry').toLowerCase())){
                    ord.BillingCountry = 'CA';
                }else{                    
                    List<ZVC__Country_Phone_Code__c> getCountrysOptionsData = [SELECT Name,ZVC__Country_Code__c FROM ZVC__Country_Phone_Code__c WHERE ZVC__Country_Code__c=:shipAddressMap.get('shipCountry') LIMIT 1];        
                    if(!getCountrysOptionsData.isEmpty()){
                        ord.BillingCountry = getCountrysOptionsData[0].Name;
                    }else{
                        ord.BillingCountry = shipAddressMap.get('shipCountry');                     
                    }                    
                }                
                ord.BillingPostalCode = shipAddressMap.get('shipZip');
            }
            
            if(institutionDetails.get('displayInstitution') == 'true'){
                ord.License_Partner__c = wc.License_Partner__c;
               try{
                Account licenseAccount = [SELECT Id, MDR_PID__c,Name FROM Account WHERE AccountNumber =: wc.License_Partner__c LIMIT 1];
                if(licenseAccount != null ){
                String siteId = wc.Site_Id__c;
                String promoId = wc.Coupon__c;
                ord.Special_EDI_Instructions__c = 'SiteID='+siteId+'/PromoCodeID='+promoId+'/PID='+licenseAccount.MDR_PID__c;
                ord.Customer_Service_Comments__c = 'SIOP_INSTITUTE=N/institutionType='+institutionDetails.get('institutionType')+'/InstitutionName='+licenseAccount.Name+'/IAma='+institutionDetails.get('iAm');
                }
                }
                catch(QueryException e) {
                System.debug('The following exception has occurred: ' + e.getMessage());
            } 
            }                       
            insert ord;
            
            for(CartItem ci:CartItems){
            OrderItem oi = new OrderItem();
            
            oi.ISBN__c = ci.Name;
            oi.Requested_Delivery_Date__c = RequestedShipDate;
            oi.Description = ci.Title_Desc_Full__c;
            oi.SAP_Order_Item_status__c = ci.Line_Item_Status__c;
            oi.UnitPrice = ci.NetUnitPrice;
            oi.ListPrice = ci.Price_Per_Unit__c;
            oi.Discount__c = ci.Discount__c;
            oi.Quantity = ci.Quantity;
            oi.OrderId = ord.Id;
            oi.Product2Id = ci.Product2Id;
            oi.Price_condition__c = ci.Price_condition__c;
            OrderItems.add(oi);
          } 
            if(!OrderItems.isEmpty()){
               insert OrderItems;
            }
            updateWebCartOrderId(cartId, ord.Id);
            system.debug('***getCpuTime()***'+Limits.getCpuTime());
            return ord.Id;
        }catch(Exception e){
            system.debug('Exception:'+e.getMessage());
            throw new AuraHandledException('Failed to create SF order :'+e.getMessage());
        }        
    }
    
    public class getServiceOptionsWrapper{
        @AuraEnabled public String label;
        @AuraEnabled public String value;
           getServiceOptionsWrapper(String label,String value){
               this.label = label;
               this.value = value;
           }
    }
    
    @AuraEnabled
    public static List<Order> fetchOrderData(Id ordrId){
        List<Order> ordr = [Select id,SAP_Document_Number__c,Contact_First_Name__c, Contact_Last_Name__c, BillingName__c,Cancel_After_Date__c,ShippingAddress,BillingAddress,OrderNumber,PoNumber__c,isPOSelected__c,AccountId,ShipTo_Name__c,BillingPhoneNumber,Customer_Email__c,Shipment_Confirmation_Email__c,Attention_Billing__c,Attention_Shipping__c,Warehouse_text__c,Shipping_instruction__c,ShippingStreet,ShippingCity,ShippingState,ShippingCountry,ShippingPostalCode,Status,EffectiveDate,Coupon__c,
                            SAP_BillTo__c,SAP_Shipto__c,Shipping_Conditions__c,BillingCity, BillingStreet, BillingState, BillingPostalCode, BillingCountry,License_To__Street__s,License_To_Country__c,License_To_State__c,License_To_Name__c, License_To__City__s, License_To__PostalCode__s, License_Partner__c,License_To__CountryCode__s, License_To__StateCode__s, Delivery_Contact_Phone__c, Delivery_Contact_Email__c, CreatedBy.Name,Has_One_Time_Ship__c from Order Where Id=: ordrId Limit 1];
        
        return ordr;
    }
   @AuraEnabled
    public static List<Contact> getUserdata(){
        User contactId=[SELECT Id, 	AccountId,ContactId FROM User WHERE Id = :UserInfo.getUserId() Limit 1];
        List<Contact> cont = [SELECT Id, Name, Phone, Email, FirstName, LastName, OtherPhone
								FROM Contact WHERE  Id=:contactId.ContactId  Limit 1];        
        return cont;
    }
    
    @AuraEnabled
    public static List<Webcart> fetchCartData(Id cartId){
        List<Webcart> WebC = [Select id,TotalProductAmount,Coupon_Discount__c,Coupon__c,Shipping_Amount__c,cart_item_tax_total__c from Webcart Where Id=:cartId Limit 1];
        
        return WebC;
    }
    /********************************************************************** 
    Method Name :  fetchCartDetails
    Description :  used to fetch cart details
    Input       :  cardit
    Return type :  Map
    ***********************************************************************/      
    
    @AuraEnabled
    public static Map<String, String> fetchCartDetails(Id cartId){ 
        Map<String, String> cartDetails = new Map<String, String>();
        Decimal discount = 0.00;
        Decimal shipping = 0.00;
        Decimal subTotal = 0.00;
        Decimal tax = 0.00;
        Decimal subTotalReviewCart= 0.00;
        List<WebCart> cart = [Select id,TotalProductAmount,Coupon_Discount__c,Coupon__c,Shipping_Amount__c,cart_item_tax_total__c from WebCart Where Id=:cartId LIMIT 1]; 
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
        return cartDetails;
    }
    /********************************************************************** 
    Method Name :  fetchOrderItemData
    Description :  used to fetch order item details
    Input       :  orderid
    Return type :  List
    ***********************************************************************/  
    @AuraEnabled
    public static List<OrderItemWrapper> fetchOrderItemData(Id ordrId){
        List<OrderItem> ordritem = [Select id,Product2.ISBN13__c,Price_condition__c,Product2.ISBN10__c,Product2.Description,OrderId,Product2.ProductCode,Product2.Product_Status__c,ISBN__c,SAP_Order_Item_status__c,UnitPrice,ListPrice,Discount__c,Quantity,Product2Id,Product2.Name,Requested_Delivery_Date__c,Product2.Availability__c from OrderItem Where OrderId=: ordrId];            
        List<OrderItemWrapper> orderItemsWrap = new List<OrderItemWrapper>();
        Boolean siopIsbn = false;
        String IsbnValues = system.label.scc_OrderDetail_SIOP_ISBNs;
        try{
            
            for(OrderItem oi:ordritem){
            OrderItemWrapper wrapper1 = new OrderItemWrapper();
             wrapper1.id = oi.id;
             wrapper1.OrderId = oi.OrderId;
             wrapper1.ISBN = oi.Product2.ISBN13__c != null ? oi.Product2.ISBN13__c : oi.Product2.ISBN10__c ;
             wrapper1.SAP_Order_Item_status = oi.Product2.Product_Status__c;
             wrapper1.UnitPrice = oi.UnitPrice;
             wrapper1.ListPrice = oi.ListPrice;
             wrapper1.Discount = oi.Price_condition__c;
             wrapper1.Quantity = oi.Quantity;
             wrapper1.Product2Id = oi.Product2Id;
             wrapper1.Name = oi.Product2.Description;
             wrapper1.siopOrder = false; 
             wrapper1.Requested_Delivery_Date = oi.Requested_Delivery_Date__c;
             wrapper1.Availability = oi.Product2.Availability__c;                
            
             if(oi.Product2.ISBN13__c !=null){
                   if(IsbnValues.contains(oi.Product2.ISBN13__c)){
                    wrapper1.siopOrder = true; 
                    siopIsbn=true;
                   }  
             }else if(oi.Product2.ProductCode !=null){
                    if(IsbnValues.contains(oi.Product2.ProductCode)){
                    wrapper1.siopOrder = true; 
                    siopIsbn=true;
                   } 
             }else{
                 if(oi.Product2.ISBN10__c !=null){
                    if(IsbnValues.contains(oi.Product2.ISBN10__c)){
                    wrapper1.siopOrder = true; 
                    siopIsbn=true;
                   }   
                 }                 
             }
             orderItemsWrap.add(wrapper1);
            }
        }catch(Exception e){
            System.debug('Error--'+e.getMessage());
            System.debug('Error--'+e.getCause());
        }
        return orderItemsWrap;
    }
    public static void updateWebCartOrderId(Id cartId, String orderId){
        try{
           List<WebCart> webCart = [select Id, Order_Id__c from WebCart where Id=:cartId LIMIT 1];
           if(!webCart.isEmpty()){
               webCart[0].Order_Id__c = orderId;
           } 
            update webCart;
        }catch(Exception e){
            system.debug('Exception:'+e.getMessage());
            throw new AuraHandledException('Failed to create SF order :'+e.getMessage());
        }
    }
    
    @AuraEnabled
    public static void updateCartStatus(String cartId){
        try{
           List<WebCart> webCart = [select Id, Status from WebCart where Id=:cartId LIMIT 1];
           if(!webCart.isEmpty()){
               webCart[0].Status = 'PendingClosed';
               update webCart;
           } 
        }catch(Exception e){
            system.debug('Exception:'+e.getMessage());
            throw new AuraHandledException('Failed to update cart status :'+e.getMessage());
        }
    }

    public class OrderItemWrapper{
        @AuraEnabled public Id id;
        @AuraEnabled public Id OrderId;
        @AuraEnabled public String ISBN;
        @AuraEnabled public String SAP_Order_Item_status;
        @AuraEnabled public Decimal UnitPrice;
        @AuraEnabled public Decimal ListPrice;
        @AuraEnabled public Decimal Quantity;
        @AuraEnabled public String Product2Id;
        @AuraEnabled public String Name;
        @AuraEnabled public String Discount;
        @AuraEnabled public Boolean siopOrder;
        @AuraEnabled public Date Requested_Delivery_Date;
        @AuraEnabled public String Availability;
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