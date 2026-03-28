public class testcheckoutctr {
     @AuraEnabled(cacheable=true)
    public static Boolean isGuestUser(){
        return UserInfo.getUserType() == 'Guest';
    }    
    
    @AuraEnabled(cacheable=true)
    //public static List<scc_shipping_Service_Level__mdt> getServiceLvlOptions(){
	public static String getServiceLvlOptions(){
       List<scc_shipping_Service_Level__mdt> ServiceLvl = [SELECT Id,isActive__c, priority__c,Label,Value__c  From scc_shipping_Service_Level__mdt WHERE IsActive__c=true ORDER BY Priority__c ASC NULLS LAST];
        system.debug('Service line options '+ServiceLvl);
         List<getServiceOptionsWrapper> getServiceOptionsWrapper = new List<getServiceOptionsWrapper>();
        for(Integer i=0;i<ServiceLvl.size();i++){
            getServiceOptionsWrapper.add(new getServiceOptionsWrapper(ServiceLvl[i].Label,ServiceLvl[i].Value__c )); 
        }
        return JSON.serialize(getServiceOptionsWrapper);
        //return ServiceLvl ;
    }
    

    
    @AuraEnabled
    public static string updateShipAddress(Id cartID, String name,String street,String city,String province,String postalCode,String country, String shipToNumber){
    try{
        Webcart wc = [select id,AccountId,Shipping_Street__c,Shipping_City__c,Shipping_State__c,Shipping_Country__c,Shipping_Zip_Code__c,SAP_Shipto__c from Webcart where id=:cartID];
        wc.Shipping_Street__c = street;
        wc.Shipping_City__c = city;
        wc.Shipping_State__c = province;
        wc.Shipping_Country__c = country;
        wc.Shipping_Zip_Code__c = postalCode;
        wc.SAP_Shipto__c = shipToNumber;
        upsert wc;
        return 'Success';
      }catch(Exception e){
            system.debug('Exception:'+e.getMessage());
            throw new AuraHandledException('Failed to update Ship address :'+e.getMessage());
        }  
    }
    
     @AuraEnabled
    public static string updateLicenseToAddress(Id cartID, String name,String street,String city,String province,String postalCode,String country, String shipToNumber){
    try{
        Webcart wc = [select id,AccountId,License_Partner__c, License_To__Street__s, License_To__City__s, License_To__PostalCode__s, License_To__StateCode__s, License_To__CountryCode__s, License_To__c,SAP_Shipto__c from Webcart where id=:cartID];
        wc.License_To__Street__s = street;
        wc.License_To__City__s = city;
        //wc.Shipping_State__c = province;
        //wc.Shipping_Country__c = country;
        wc.License_To__PostalCode__s = postalCode;
        wc.License_Partner__c = shipToNumber;
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
    
    //wrapper class for shipping information options
      public class getShippingInfoOptionsWrapper{
            public String label;
            public String value;
           getShippingInfoOptionsWrapper(String label,String value){
               this.label = label;
               this.value = value;
           }
            
       }
    
    //Ship to address change
     @AuraEnabled(cacheable=true)
    public static List<addressWrapper> getCurrentUserShippingAddress(){ 
       
        List<user> usr= new List<User>();
        List<addressWrapper> shipAddress= new List<addressWrapper>();
        String billing='Billing';
        String shipping='shipping';
        Id userId = UserInfo.getUserId();     
        User accid=[SELECT AccountId,Id FROM User WHERE Id = :userId Limit 1];   
        Id acId=accid.AccountId;
        //Id acId='0015300000U1p4NAAR';
        List<Account> accaddr= new List<Account>();
        accaddr=[select Id,Name,BillingCity,BillingPostalCode,BillingState,BillingStreet,BillingCountry,SAP_Account_Id__c,SAP_Account_Number__c,ShippingCity,ShippingCountry,ShippingPostalCode,ShippingState,ShippingStreet
                 From Account 
                 where Id=:acId];
        
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
        
        accountaddr =[SELECT Id,Account__c,ERP_Account_Name__c,Address_1__c,Address_2__c,Address_3__c,Address_4__c,Address_Type__c,City__c,County__c,ERP_Account_Number__c,State__c,Zip_Code__c
                      FROM Account_Addresses__c 
                      where Account__c= :acId  AND Address_Type__c=:shipping Limit 100];
        if(!accountaddr.isEmpty()){
            for (Account_Addresses__c acc : accountaddr) {
                addressWrapper wrapper1 = new addressWrapper();
                wrapper1.SAccountName=acc.ERP_Account_Name__c;
                wrapper1.ShipToNumber=acc.ERP_Account_Number__c;
                wrapper1.ShipStreet=acc.Address_1__c+acc.Address_2__c+acc.Address_3__c+acc.Address_4__c;
                Wrapper1.AccShipId=acc.Id;
                wrapper1.ShippingCity=acc.City__c;
                wrapper1.Provionce=acc.State__c;
                wrapper1.PostalCode=acc.Zip_Code__c;
                wrapper1.ShippingCountry=acc.County__c;
                shipAddress.add(wrapper1);
            }
        }
        return shipAddress;    
        
      }
    
    //Get Ship to address from Confirm Address Page
    @AuraEnabled(cacheable=true)
    public static List<WebCart> getCurrShipTo(){ 
       List<user> usr= new List<User>();
       List<addressWrapper> shipAddress= new List<addressWrapper>(); 
       String shipping='Shipping';
       Id userId = UserInfo.getUserId(); 

       User accid=[SELECT AccountId,Id FROM User WHERE Id = :userId Limit 1];  
       Id acId=accid.AccountId;
       List<WebCart> cartaddr =[SELECT Id,AccountId,Account.Name,IsSecondary,SAP_Shipto__c,Master_User__c,Status,WebStoreId,Shipping_Street__c,Shipping_City__c,Shipping_State__c,Shipping_Country__c,Shipping_Zip_Code__c,Specify_One_Time_Shipping__c,TotalProductAmount, Shipping_Amount__c, Coupon_Discount__c, PoNumber__c FROM WebCart WHERE AccountId =: acId AND IsSecondary = False AND Status ='Active' AND Master_User__c=: userId ];
       String shipTo;
        if(!Test.isRunningTest()){
          shipTo = cartaddr[0].SAP_Shipto__c;  
        }else{
          shipTo = '1234';   
        } 
       List<Account_Addresses__c> accountShipToAddr =[SELECT Id,Account__c,ERP_Account_Name__c,Address_1__c,Address_2__c,Address_3__c,Address_4__c,Address_Type__c,City__c,County__c,ERP_Account_Number__c,State__c,Zip_Code__c,Account__r.SAP_Account_Id__c
                      FROM Account_Addresses__c 
                      where (ERP_Account_Number__c=:shipTo OR Account__r.SAP_Account_Id__c=:shipTo) AND Address_Type__c=:shipping];
       return cartaddr;
    }
    
    @AuraEnabled
    public static Id createOrderRecord(String firstName, String lastName, String phone, String email, String ship_email, Date CancelBackOrderDate, Date RequestedShipDate, String BillToAttention, String ShipToAttention,String Warehouse,String DeliveryContactPhone, String DeliveryContactEmail, String cartID, String promoCd, String shippingServiceLvl, String delivryInstruction,
                                      Boolean isCreditCardSelected, Map<String,String> cardDetails, String poNumber,boolean isProvisionDisabled,String lName,String lStreet, String lCity, String lCountry, String lPostalCode){
        try{
            List<user> usr= new List<User>();
            List<OrderItem> OrderItems = new List<OrderItem>();
            Id userId = UserInfo.getUserId();
            Id profileId=userinfo.getProfileId();
            String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
    
            User accid=[SELECT AccountId,Id,ContactId FROM User WHERE Id = :userId Limit 1];  
            Id acId=accid.AccountId;
            Date EffectiveDate1 = System.Today();
            //Id ConId=accid.ContactId;
            Webcart wc = [select id,AccountId,Shipping_Street__c,Shipping_City__c,Shipping_State__c,Shipping_Country__c,Sold_To_Customer__c,Shipping_Zip_Code__c,Shipping_Conditions__c,Coupon__c,PoNumber__c, SAP_Shipto__c, SAP_BillTo__c, SAP_Salesorg__c,BillingStreet, BillingCity, BillingState, BillingCountry, BillingPostalCode,
                           License_Partner__c, License_To__Street__s, License_To__City__s, License_To__PostalCode__s, License_To__StateCode__s, License_To__CountryCode__s,TotalProductAmount,Coupon_Discount__c,Shipping_Amount__c from Webcart where id=:cartID];
            List<CartItem> CartItems = [select id,Name,Title_Desc_Full__c,Line_Item_Status__c,Price_Override__c,CartId,Discount__c,Quantity,Product2Id,NetUnitPrice,Product2.Name From CartItem Where CartId=:cartID];
            Order ord = new Order();
                ord.AccountId = acId;
            	ord.SAP_BillTo__c = wc.SAP_BillTo__c;
            	ord.SAP_Shipto__c = wc.SAP_Shipto__c;
            	ord.Account_PO_Number__c = wc.PoNumber__c; 
            	ord.Sold_To_Customer__c = wc.Sold_To_Customer__c;
            	ord.SAP_SalesOrg__c = wc.SAP_Salesorg__c;
                ord.ShipTo_Name__c = firstName + lastName;
                ord.BillingPhoneNumber = String.valueOf(phone);
                ord.Customer_Email__c = email;
                ord.Shipment_Confirmation_Email__c = ship_email;
                ord.Cancel_After_Date__c = CancelBackOrderDate;
                //ord.Requested_Delivery_Date__c = RequestedShipDate;
                ord.Attention_Billing__c = BillToAttention;
                ord.Attention_Shipping__c = ShipToAttention;
                ord.Warehouse_text__c = Warehouse;
                ord.Shipping_instruction__c  = DeliveryContactEmail + DeliveryContactPhone;
                ord.ShippingStreet = wc.Shipping_Street__c;
                ord.ShippingCity = wc.Shipping_City__c;
                ord.ShippingState = wc.Shipping_State__c;
                ord.ShippingCountry = wc.Shipping_Country__c;
                ord.ShippingPostalCode = wc.Shipping_Zip_Code__c;
                ord.Status = 'Draft';
                ord.EffectiveDate = System.Today();
               // ord.EffectiveDate = String.valueOf(EffectiveDate1.month())+'/'+String.valueOf(EffectiveDate1.day())+'/'+String.valueOf(EffectiveDate1.year());
                ord.Coupon__c = promoCd;
                ord.Shipping_Conditions__c = wc.Shipping_Conditions__c;
                ord.BillingStreet = wc.BillingStreet;
                ord.BillingCity = wc.BillingCity;
                ord.BillingState = wc.BillingState;
                ord.BillingCountry = wc.BillingCountry;
                ord.BillingPostalCode = wc.BillingPostalCode;
                ord.License_To__Street__s = wc.License_To__Street__s;
                ord.License_To__City__s = wc.License_To__City__s;
                ord.License_To__PostalCode__s = wc.License_To__PostalCode__s;
                ord.License_Partner__c = wc.SAP_Shipto__c;
                ord.Delivery_Contact_Phone__c = DeliveryContactPhone;
                ord.Delivery_Contact_Email__c = DeliveryContactEmail;
            	ord.PO_Date__c = system.today();
                ord.Coupon_Discount__c = wc.Coupon_Discount__c;
    
                if (profileName == 'MySavvasOrders Profile'){
                    ord.Order_Source__c = 'E-Web';
                } else {
                    ord.Order_Source__c = 'O-Web';
                }
    
              //  ord.Shipping_instruction__c = delivryInstruction;
               
                if(isCreditCardSelected){
                    String expDate = cardDetails.get('expYear')+'-'+cardDetails.get('expMonth')+'-01';
                    ord.cctype__c = cardDetails.get('cardType');
                    ord.ccNumberEnc__c = cardDetails.get('tokenizedCardNumber');
                    ord.ccExpDate__c = Date.valueOf(expDate);
                    ord.BillingName__c = cardDetails.get('cardHolderName');
                    ord.PO_Number__c = wc.PoNumber__c;
                }else{
                    ord.isPOSelected__c = true;
                    ord.PoNumber__c = poNumber;
                }
            
              insert ord;
            for(CartItem ci:CartItems){
            OrderItem oi = new OrderItem();
            
            oi.ISBN__c = ci.Name;
            oi.Requested_Delivery_Date__c = RequestedShipDate;
            oi.Description = ci.Title_Desc_Full__c;
            oi.SAP_Order_Item_status__c = ci.Line_Item_Status__c;
            oi.UnitPrice = ci.NetUnitPrice;
            oi.ListPrice = ci.NetUnitPrice;
            oi.Discount__c = ci.Discount__c;
            oi.Quantity = ci.Quantity;
            oi.OrderId = ord.Id;
            oi.Product2Id = ci.Product2Id;
                OrderItems.add(oi);
          } 
            if(!OrderItems.isEmpty()){
               insert OrderItems;
            }
            
            return ord.Id;
        }catch(Exception e){
            system.debug('Exception:'+e.getMessage());
            throw new AuraHandledException('Failed to create SF order :'+e.getMessage());
        }
        
    }
    
    @AuraEnabled
    public static Id createGuestOrderRecord(String firstName, String lastName, String phone, String email, String ship_email, Date CancelBackOrderDate, Date RequestedShipDate, String ShipToAttention, String cartId, String guestAccountId, String promoCd, String shippingServiceLvl,
                                      Map<String,String> cardDetails, Map<String,String> shipAddressMap, Boolean isBillAddressSame, Map<String,String> billAddressMap){
        try{
            String expDate = cardDetails.get('expYear')+'-'+cardDetails.get('expMonth')+'-01';
            List<OrderItem> OrderItems = new List<OrderItem>();
    
            Webcart wc = [select id,AccountId,Shipping_Street__c,Shipping_City__c,Shipping_State__c,Shipping_Country__c,Sold_To_Customer__c,Shipping_Zip_Code__c,Shipping_Conditions__c,Coupon__c,PoNumber__c, SAP_Shipto__c, SAP_BillTo__c, SAP_Salesorg__c,BillingStreet, BillingCity, BillingState, BillingCountry, BillingPostalCode,
                           License_Partner__c, License_To__Street__s, License_To__City__s, License_To__PostalCode__s, License_To__StateCode__s, License_To__CountryCode__s,TotalProductAmount,Coupon_Discount__c,Shipping_Amount__c from Webcart where id=:cartId];
            List<CartItem> CartItems = [select id,Name,Title_Desc_Full__c,Line_Item_Status__c,Price_Override__c,CartId,Discount__c,Quantity,Product2Id,NetUnitPrice,Product2.Name From CartItem Where CartId=:cartId];
            Order ord = new Order();
            ord.AccountId = guestAccountId;
            ord.SAP_BillTo__c = wc.SAP_BillTo__c;
            ord.SAP_Shipto__c = wc.SAP_Shipto__c;
            ord.Account_PO_Number__c = wc.PoNumber__c; 
            ord.Sold_To_Customer__c = wc.Sold_To_Customer__c;
            ord.SAP_SalesOrg__c = wc.SAP_Salesorg__c;
            ord.ShipTo_Name__c = shipAddressMap.get('shipName');
            ord.BillingPhoneNumber = String.valueOf(phone);
            ord.Customer_Email__c = email;
            ord.Shipment_Confirmation_Email__c = ship_email;
            ord.Cancel_After_Date__c = CancelBackOrderDate;
            ord.Attention_Shipping__c = ShipToAttention;
            ord.ShippingStreet = shipAddressMap.get('shipStreet');
            ord.ShippingCity = shipAddressMap.get('shipCity');
            ord.ShippingState = shipAddressMap.get('shipState');
            ord.ShippingCountry = shipAddressMap.get('shipCountry');
            ord.ShippingPostalCode = shipAddressMap.get('shipZip');
            ord.Status = 'Draft';
            ord.EffectiveDate = System.Today();
            ord.Coupon__c = promoCd;
            ord.Shipping_Conditions__c = wc.Shipping_Conditions__c;
            ord.PO_Date__c = system.today();
            ord.Coupon_Discount__c = wc.Coupon_Discount__c;
            ord.Order_Source__c = 'O-Web';            
            ord.cctype__c = cardDetails.get('cardType');
            ord.ccNumberEnc__c = cardDetails.get('tokenizedCardNumber');
            ord.ccExpDate__c = Date.valueOf(expDate);
            ord.BillingName__c = cardDetails.get('cardHolderName');
            ord.PO_Number__c = wc.PoNumber__c;
            
            if(!isBillAddressSame){
                ord.BillingName__c = billAddressMap.get('billName');
                ord.BillingStreet = billAddressMap.get('billStreet');
                ord.BillingCity = billAddressMap.get('billCity');
                ord.BillingState = billAddressMap.get('billState');
                ord.BillingCountry = billAddressMap.get('billCountry');
                ord.BillingPostalCode = billAddressMap.get('billZip');
            }else{
                ord.BillingName__c = shipAddressMap.get('shipName');
                ord.BillingStreet = shipAddressMap.get('shipStreet');
                ord.BillingCity = shipAddressMap.get('shipCity');
                ord.BillingState = shipAddressMap.get('shipState');
                ord.BillingCountry = shipAddressMap.get('shipCountry');
                ord.BillingPostalCode = shipAddressMap.get('shipZip');
            }
                        
            insert ord;
            
            for(CartItem ci:CartItems){
            OrderItem oi = new OrderItem();
            
            oi.ISBN__c = ci.Name;
            oi.Requested_Delivery_Date__c = RequestedShipDate;
            oi.Description = ci.Title_Desc_Full__c;
            oi.SAP_Order_Item_status__c = ci.Line_Item_Status__c;
            oi.UnitPrice = ci.NetUnitPrice;
            oi.ListPrice = ci.NetUnitPrice;
            oi.Discount__c = ci.Discount__c;
            oi.Quantity = ci.Quantity;
            oi.OrderId = ord.Id;
            oi.Product2Id = ci.Product2Id;
                OrderItems.add(oi);
          } 
            if(!OrderItems.isEmpty()){
               insert OrderItems;
            }
            
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
    public List<Order> orders{
        get;set;
    }
    public testcheckoutctr(){
        String orderId = ApexPages.currentPage().getParameters().get('ordrId');
        if(orderId != null){
            orders = fetchOrderData(orderId);
        }
    }
    @AuraEnabled
    public static List<Order> fetchOrderData(Id ordrId){
        List<Order> ordr = [Select id,SAP_Document_Number__c,ShippingAddress,BillingAddress,OrderNumber,PoNumber__c,isPOSelected__c,AccountId,ShipTo_Name__c,BillingPhoneNumber,Customer_Email__c,Shipment_Confirmation_Email__c,Cancel_After_Date__c,Attention_Billing__c,Attention_Shipping__c,Warehouse_text__c,Shipping_instruction__c,ShippingStreet,ShippingCity,ShippingState,ShippingCountry,ShippingPostalCode,Status,EffectiveDate,Coupon__c,
                            SAP_BillTo__c,SAP_Shipto__c,Shipping_Conditions__c,BillingCity, BillingStreet, BillingState, BillingPostalCode, BillingCountry,License_To__Street__s, License_To__City__s, License_To__PostalCode__s, License_Partner__c,Delivery_Contact_Phone__c, Delivery_Contact_Email__c from Order Where Id=: ordrId Limit 1];
        
        return ordr;
    }
    
    @AuraEnabled
    public static List<Webcart> fetchCartData(Id cartId){
        List<Webcart> WebC = [Select id,TotalProductAmount,Coupon_Discount__c,Coupon__c,Shipping_Amount__c from Webcart Where Id=:cartId Limit 1];
        
        return WebC;
    }
    
    @AuraEnabled
    public static List<OrderItemWrapper> fetchOrderItemData(Id ordrId){
        List<OrderItem> ordritem = [Select id,Product2.ISBN13__c,Product2.ISBN10__c,OrderId,Product2.ProductCode,ISBN__c,SAP_Order_Item_status__c,UnitPrice,ListPrice,Discount__c,Quantity,Product2Id,Product2.Name,Requested_Delivery_Date__c from OrderItem Where OrderId=: ordrId];
            
        List<OrderItemWrapper> orderItemsWrap = new List<OrderItemWrapper>();
        Boolean siopIsbn = false;
        String IsbnValues = system.label.scc_OrderDetail_SIOP_ISBNs;
        try{
            
            for(OrderItem oi:ordritem){
            OrderItemWrapper wrapper1 = new OrderItemWrapper();
             wrapper1.id = oi.id;
             wrapper1.OrderId = oi.OrderId;
             wrapper1.ISBN = oi.ISBN__c;
             wrapper1.SAP_Order_Item_status = oi.SAP_Order_Item_status__c;
             wrapper1.UnitPrice = oi.UnitPrice;
             wrapper1.ListPrice = oi.ListPrice;
             wrapper1.Discount = oi.Discount__c;
             wrapper1.Quantity = oi.Quantity;
             wrapper1.Product2Id = oi.Product2Id;
             wrapper1.Name = oi.Product2.Name;
             wrapper1.siopOrder = false; 
             wrapper1.Requested_Delivery_Date = oi.Requested_Delivery_Date__c; 
            
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
        @AuraEnabled public Decimal Discount;
        @AuraEnabled public Boolean siopOrder;
        @AuraEnabled public Date Requested_Delivery_Date;
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