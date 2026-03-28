/*
Apex Class:scc_orderStatusLWC_Controller
Author: CTS (Vaibhav Saptal)
Created Date: 03/04/2024
Reason: Bakend logic scc_orderStatusLWC component.
Modified Date: 31/05/2024
*/

public without sharing class scc_orderStatusLWC_Controller {
    /**
*  Description: This method queries search by options from custom metadata      
*  @name: getSearchByOptions
*  @param:HomePage parameter to differentiate the between which page request is coming.
*  @return: String values of search by options
*  @throws exception- 
*/
    @AuraEnabled(cacheable=true)
    public static String getSearchByOptions(Boolean HomePage){
        try{
            List<User> usr = [select ID,Profile.Name,IsEmployee__c, Contact.AccountID,Contact.Account.SAP_Account_Id__c,contact.name,contact.Account.name from user where id =: userInfo.getUserID()]; 
            String query = 'SELECT MasterLabel,isGuest__c,IsInternal__c,IsExternal__c,Priority__c,IsActive__c FROM scc_searchByOptions__mdt WHERE IsActive__c=true ';
            if(HomePage == true){
                query += ' AND IsHomepage__c=true ';
            }
            if(usr[0].profile.name == scc_constantHelper.MY_SAVVAS_ORDERS_PROFILE){
                query += ' AND isGuest__c=true ';
            }
            if(usr[0].profile.name == scc_constantHelper.SAVVAS_EXTERNAL_USERS_BASE_PROFILE){// added by sudha // for community users 
                query += ' AND IsExternal__c=true ';
            }
            if (usr[0].IsEmployee__c == true) { // added by sudha // for savvas internal  users 
                query += ' AND IsInternal__c=true '; 
            }
            query += ' ORDER BY Priority__c ASC NULLS LAST';
            List<scc_searchByOptions__mdt> scc_searchByOptionsData = Database.query(query);
            List<getSearchByOptionsWrapper> getSearchByOptionsWrap = new List<getSearchByOptionsWrapper>();
            for(Integer i=0;i<scc_searchByOptionsData.size();i++){
                getSearchByOptionsWrap.add(new getSearchByOptionsWrapper(scc_searchByOptionsData[i].MasterLabel,scc_searchByOptionsData[i].MasterLabel)); 
            }
            
            return JSON.serialize(getSearchByOptionsWrap);
        }catch(Exception e){
            System.debug(scc_constantHelper.EXCEPTION_TYPE_CAUGHT+ e.getTypeName());    
            System.debug(scc_constantHelper.MESSAGE+ e.getMessage());    
            System.debug(scc_constantHelper.CAUSE+ e.getCause());    // returns null
            System.debug(scc_constantHelper.LINE_NUMBER + e.getLineNumber());    
            System.debug(scc_constantHelper.STACK_RACE+ e.getStackTraceString());
            throw new AuraHandledException('Failed to get search options:'+e.getMessage()+e.getCause());
        }
    }
    
/**
*  Description: This method queries Order Status options from custom metadata      
*  @name: getOrderStatusOptions
*  @param:No parameters
*  @return: String values of Order Status options
*  @throws exception- 
*/
    @AuraEnabled(cacheable=true)
    public static String getOrderStatusOptions(){
        try{
            List<scc_orderStatusOptions__mdt> scc_orderStatusOptionsData = [SELECT MasterLabel,Priority__c,IsActive__c FROM scc_orderStatusOptions__mdt WHERE IsActive__c=true ORDER BY Priority__c ASC NULLS LAST];
            List<getOrderStatusOptionsWrapper> getOrderStatusOptionsWrap = new List<getOrderStatusOptionsWrapper>();
            for(Integer i=0;i<scc_orderStatusOptionsData.size();i++){
                getOrderStatusOptionsWrap.add(new getOrderStatusOptionsWrapper(scc_orderStatusOptionsData[i].MasterLabel,scc_orderStatusOptionsData[i].MasterLabel)); 
            }
            return JSON.serialize(getOrderStatusOptionsWrap);
        }catch(Exception e){
            System.debug(scc_constantHelper.EXCEPTION_TYPE_CAUGHT+ e.getTypeName());    
            System.debug(scc_constantHelper.MESSAGE+ e.getMessage());    
            System.debug(scc_constantHelper.CAUSE+ e.getCause());    // returns null
            System.debug(scc_constantHelper.LINE_NUMBER + e.getLineNumber());    
            System.debug(scc_constantHelper.STACK_RACE+ e.getStackTraceString());
            throw new AuraHandledException('Failed to get order status values :'+e.getMessage()+e.getCause());
        }
    }
    
    /**
*  Description: This method queries Country options from ZVC__Country_Phone_Code__c object      
*  @name: getCountrysOptions
*  @param:No parameters
*  @return: String values of Country options
*  @throws exception- 
*/
    @AuraEnabled(cacheable=true)
    public static String getCountrysOptions(){
        try{
            List<ZVC__Country_Phone_Code__c> getCountrysOptionsData = [SELECT ZVC__Country_Code__c FROM ZVC__Country_Phone_Code__c WHERE ZVC__Country_Code__c NOT IN ('United States','Canada')];        
            List<getCountrysOptionsWrapper> getCountrysOptionsWrap = new List<getCountrysOptionsWrapper>();       
            for(Integer i=0;i<getCountrysOptionsData.size();i++){
                getCountrysOptionsWrap.add(new getCountrysOptionsWrapper(getCountrysOptionsData[i].ZVC__Country_Code__c,getCountrysOptionsData[i].ZVC__Country_Code__c)); 
            }       
            return JSON.serialize(getCountrysOptionsWrap);
        }catch(Exception e){
            System.debug(scc_constantHelper.EXCEPTION_TYPE_CAUGHT+ e.getTypeName());    
            System.debug(scc_constantHelper.MESSAGE+ e.getMessage());    
            System.debug(scc_constantHelper.CAUSE+ e.getCause());    // returns null
            System.debug(scc_constantHelper.LINE_NUMBER + e.getLineNumber());    
            System.debug(scc_constantHelper.STACK_RACE+ e.getStackTraceString());
            throw new AuraHandledException('Failed to get country options :'+e.getMessage()+e.getCause());
        }
    }
    
    /**
*  Description: This method queries home screen recent order details from Order Object     
*  @name: getOrderStatusData
*  @param:isCredits which is used differentiate order between credit and non-credit
*  @return: String values of Order Details or credit details
*  @throws exception- 
*/        
    @AuraEnabled(cacheable=false)
    public static String getOrderStatusData(Boolean isCredits) {
        system.debug('***getCpuTime()***'+Limits.getCpuTime());
        List<User> usr = [SELECT Id, Profile.Name, Contact.AccountID, Contact.Name, Contact.Account.Name ,contact.Account.AccountNumber
                          FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
        if (usr.isEmpty()) {
            return 'Error: User information not found';
        }
        
        String userAccountId = usr[0].Contact.AccountID;
        String userAccountNumber=usr[0].Contact.Account.AccountNumber;// added by sudha
        String profileName = usr[0].Profile.Name;
        String result;
        
        try {
            List<getOrderStatusDataWrapper> getOrderStatusDataWrap = new List<getOrderStatusDataWrapper>();
            
            if (profileName == scc_constantHelper.SAVVAS_EXTERNAL_USERS_BASE_PROFILE && userAccountId != null) {
                // External user query
                String orderQuery = 'SELECT OrderNumber, Order_Status_Code__c, ShipTo_Name__c, BillingName__c, ' +
                    'PoNumber__c, scc_LastViewDate__c, scc_Recently_Viewed_User__c, License_Partner__c,' +
                    'SAP_Document_Number__c, EffectiveDate, Account_PO_Number__c, SAP_Order_Type__c ' +
                    'FROM Order ' +
                    'WHERE (AccountId = \'' + userAccountId + '\' ' +
                    'OR License_Partner__c = \'' + userAccountNumber + '\' )' +     // added by sudha 
                    'AND SAP_Document_Number__c != null ';
                
                if (isCredits) {
                    orderQuery += 'AND (SAP_Order_Type__c = \'ZCRC\' OR SAP_Order_Type__c = \'ZDMR\') ';
                }
                
                orderQuery += 'ORDER BY EffectiveDate DESC, Account_PO_Number__c DESC, SAP_Document_Number__c DESC LIMIT 10';
                
                // Execute the Order query and wrap the results
                //List<Order> orders = Database.query(orderQuery);
                for (Order ord : Database.query(orderQuery)) {
                    getOrderStatusDataWrap.add(new getOrderStatusDataWrapper(
                        ord.OrderNumber,
                        ord.Order_Status_Code__c,
                        ord.PoNumber__c,
                        ord.SAP_Document_Number__c,
                        ord.EffectiveDate != null ? ord.EffectiveDate.format() : null,
                        ord.ShipTo_Name__c,
                        ord.BillingName__c,
                        ord.Account_PO_Number__c
                    ));
                }
            } else {
                system.debug('entered to internal');
                List<RecentlyViewed> recentlyViewedRecords = [SELECT Id, Name, LastViewedDate
                                                              FROM RecentlyViewed
                                                              WHERE Type = 'Order'
                                                              ORDER BY LastViewedDate DESC
                                                              LIMIT 10];
                List<Id> orderIds = new List<Id>();
                for (RecentlyViewed rv : recentlyViewedRecords) {
                    orderIds.add(rv.id);
                    system.debug('entered to  Name '+rv.name);
                }
                system.debug('entered to internal2'+orderIds) ;      
                // Query Order records using the collected IDs
                if (!orderIds.isEmpty()) {
                    String orderQuery = 'SELECT OrderNumber, Order_Status_Code__c, ShipTo_Name__c, BillingName__c, ' +
                        'PoNumber__c, scc_LastViewDate__c, scc_Recently_Viewed_User__c, ' +
                        'SAP_Document_Number__c, EffectiveDate, Account_PO_Number__c, SAP_Order_Type__c ' +
                        'FROM Order ' +
                        'WHERE Id IN :orderIds AND SAP_Document_Number__c != null ';
                    
                    if (isCredits) {
                        orderQuery += 'AND (SAP_Order_Type__c = \'ZCRC\' OR SAP_Order_Type__c = \'ZDMR\') ';
                    }
                    system.debug('entered to internal3'+orderIds) ;     
                    orderQuery += 'ORDER BY scc_LastViewDate__c DESC';
                    system.debug('entered to internal3'+orderIds) ;    
                    //List<Order> orders = Database.query(orderQuery);
                    for (Order ord : Database.query(orderQuery)) {
                        getOrderStatusDataWrap.add(new getOrderStatusDataWrapper(
                            ord.OrderNumber,
                            ord.Order_Status_Code__c,
                            ord.PoNumber__c,
                            ord.SAP_Document_Number__c,
                            ord.EffectiveDate != null ? ord.EffectiveDate.format() : null,
                            ord.ShipTo_Name__c,
                            ord.BillingName__c,
                            ord.Account_PO_Number__c
                        ));
                    }
                }
            }
            
            result = JSON.serialize(getOrderStatusDataWrap);
            system.debug('***getCpuTime()***'+Limits.getCpuTime());
            system.debug('result'+result);
        } catch (Exception e) {
            System.debug(scc_constantHelper.EXCEPTION_TYPE_CAUGHT+ e.getTypeName());    
            System.debug(scc_constantHelper.MESSAGE+ e.getMessage());    
            System.debug(scc_constantHelper.CAUSE+ e.getCause());    // returns null
            System.debug(scc_constantHelper.LINE_NUMBER + e.getLineNumber());    
            System.debug(scc_constantHelper.STACK_RACE+ e.getStackTraceString());
            throw new AuraHandledException('Failed to get country options :'+e.getMessage()+e.getCause());
        }
        
        return result;    
    }
    
    // Calling Enosix 
    @AuraEnabled(cacheable=false)
    public static void updateOrder(String orderId) {
        
        if (String.isBlank(orderId)) {
            throw new AuraHandledException('Order ID cannot be null or empty.');
        }
        try {     
            Order orderToUpdate = [
                SELECT Id, SAP_Document_Number__c, scc_Recently_Viewed_User__c, scc_LastViewDate__c 
                FROM Order 
                WHERE SAP_Document_Number__c = :orderId 
                LIMIT 1
            ];        
            if (orderToUpdate == null) {
                throw new AuraHandledException('No order found with the specified SAP Document Number.');
            }
            
            // orderToUpdate.scc_Recently_Viewed_User__c = true;
            orderToUpdate.scc_LastViewDate__c = System.now();
            
            
            update orderToUpdate;
            system.debug('orderToUpdate'+orderToUpdate);
            
        } catch (DmlException e) {            
            System.debug(scc_constantHelper.EXCEPTION_TYPE_CAUGHT+ e.getTypeName());    
            System.debug(scc_constantHelper.MESSAGE+ e.getMessage());    
            System.debug(scc_constantHelper.CAUSE+ e.getCause());    // returns null
            System.debug(scc_constantHelper.LINE_NUMBER + e.getLineNumber());    
            System.debug(scc_constantHelper.STACK_RACE+ e.getStackTraceString());            
            throw new AuraHandledException('Error updating order: ' + e.getMessage());
        }
    }
    
/**
*  Description: This method queries order details from Order based on different Criteria's     
*  @name: getCriteriaOrderdata
*  @param:Parameters like PO,ISBN,Dates,Order Status,Order Number,SAN, Search by Values etc.
*  @return: String values of Order Details
*  @throws exception- When any issues while querying the data or assigning the data wrapper variables.
*/  
    @AuraEnabled
    public static String getCriteriaOrderdata(String PO,String ISBN,Date startDate,Date endDate,String orderStatus,String OrderNum,String Zip,String State,String City,String Country,String CustNam,String Shipto,String BillTo,String SAN,String Invo,String SearchValue, String Acid) {
        set<getCriteriaOrderwrapper> getCriteriaOrderDataToSend = new set<getCriteriaOrderwrapper>();
        String Customer_ShipTo_AccName ='';
        String Customer_BillTo_AccName ='';
        String isbnValue = ISBN;
        boolean workTextCombined = false;
        Boolean ISBNMatch = false;
        system.debug('***getCpuTime()***'+Limits.getCpuTime());
        ISBN = String.isNotBlank(isbnValue) ? (isbnValue.length() <= 10 ? padZerosLeftforOrder(isbnValue, 10) : (isbnValue.length() <= 13 ? padZerosLeftforOrder(isbnValue, 13) : null)) : null;
        try{
            List<User> usr = [select ID,IsActive,Profile.Name,IsEmployee__c, Contact.AccountID,Contact.Account.SAP_Account_Id__c,contact.name,contact.Account.name, contact.Account.AccountNumber from user where id =: userInfo.getUserID()]; 
            
            system.debug('PO is'+PO);
            if(orderStatus =='false'){
                orderStatus = scc_constantHelper.ALL;
            }
            system.debug('orderStatus is'+orderStatus);
            String query = 'SELECT ID,Account.SAP_Account_Number__c,License_Partner__c,Combine_PONumber__c,Account_PO_Number__c,PoNumber__c,SAP_Document_Number__c,EffectiveDate,Order_Status_Code__c,ShippingAddress,BillingAddress,SAP_Order_Type__c,BillingName__c,Account.SAP_Account_Id__c,BillingStreet,BillingCity,BillingState,BillingPostalCode,BillingCountry,ShippingStreet,ShippingCity,ShippingState,ShippingPostalCode,ShippingCountry,SAP_Shipto__c,SAP_BillTo__c,Orig_Ord_Lin_Count__c,ShipTo_Name__c,Order_Total_Units__c,Total_Items__c,SIOP_Order__c ';
            
            if(ISBN !=null && ISBN !=''){
                query += ',(Select OrderItemNumber,SAP_Invoice_Number__c,Product2.ISBN10__c,Product2.ProductCode,Product2.ISBN13__c from OrderItems WHERE (Product2.ISBN10__c=:ISBN OR Product2.ProductCode=:ISBN OR Product2.ISBN13__c=:ISBN) LIMIT 1) FROM Order ';
                system.debug(query+'entered3');
            }else{
                query += 'FROM Order ';
                system.debug(query+'entered2');
            }
            
            
            if(usr[0].Profile.Name == scc_constantHelper.SAVVAS_EXTERNAL_USERS_BASE_PROFILE){      
                String userAccountId =usr[0].Contact.AccountID;
                if(usr[0].Contact.Account.AccountNumber != null && usr[0].Contact.Account.AccountNumber != ''){
                    String userAccountNumber=usr[0].Contact.Account.AccountNumber;// added by sudha
                    query += 'WHERE (AccountId=:userAccountId OR License_Partner__c= :userAccountNumber)'; //added by sudha or Condition                          
                }else{
                    query += 'WHERE AccountId=:userAccountId ';
                }
                query += ' AND SAP_Document_Number__c != null ';
                
            }else if(usr[0].profile.name == scc_constantHelper.MY_SAVVAS_ORDERS_PROFILE){
                if(Zip != null && Zip !=''){
                    String zipLikeParam = '' + Zip + '%';
                    system.debug('zipLikeParam>>'+zipLikeParam);                    
                    query += ' WHERE (ShippingPostalCode LIKE \''+zipLikeParam+'\' OR BillingpostalCode LIKE \''+zipLikeParam+'\') ';
                } 
                if(Acid != null && Acid !=''){
                    String zipLikeParam = '%' + Zip + '%';
                    if(Zip != null && Zip !=''){
                        query += ' AND AccountId=:Acid ';
                    }else{
                        query += ' WHERE AccountId=:Acid ';
                    }
                }  
                query += ' AND SAP_Document_Number__c != null ';
            }else if(!((usr[0].profile.name == scc_constantHelper.SAVVAS_EXTERNAL_USERS_BASE_PROFILE) && (usr[0].profile.name == scc_constantHelper.MY_SAVVAS_ORDERS_PROFILE))){
                
                query += 'WHERE SAP_Document_Number__c != null ';           
                
            }            
            
            if(SearchValue==scc_constantHelper.PO_NUMBER || searchValue ==scc_constantHelper.OUR_SHIP_TO_LOCATIONS_ONLY || searchValue == scc_constantHelper.ALL_SHIP_TO_LOCATIONS ){
                if(PO != null && PO !=''){
                    query += 'AND ';
                    query += ' (PoNumber__c=:PO OR Account_PO_Number__c=:PO) ';
                }  
                
                if(startDate !=null){
                    query += 'AND ';
                    query += 'EffectiveDate >=:startDate ';
                }
                
                if(endDate !=null){
                    query += 'AND ';
                    query += 'EffectiveDate <=:endDate ';
                }
                
                if(orderStatus !=null && orderStatus !='' && orderStatus !=scc_constantHelper.ALL){
                    query += 'AND ';
                    query += 'Order_Status_Code__c=:orderStatus ';
                }
                
                if(searchValue ==scc_constantHelper.OUR_SHIP_TO_LOCATIONS_ONLY){
                    query += 'AND ';
                    String accountShipTo = usr[0].Contact.Account.SAP_Account_Id__c;
                    system.debug('account ship to is'+accountShipTo);
                    query += 'SAP_Shipto__c =:accountShipTo ';
                }             
            }
            
            if(SearchValue == scc_constantHelper.INVOICE_NUMBER){
                List<SAP_Invoice__c> getInvoiceNumberData = [SELECT Invoice_Number__c,Order_Number__c from SAP_Invoice__c Where Invoice_Number__c =:Invo];
                OrderNum = getInvoiceNumberData[0].Order_Number__c;
                SearchValue=scc_constantHelper.ORDER_NUMBER;
                orderStatus = scc_constantHelper.ALL;
                Invo=null; 
            }
            
            
            if(SearchValue==scc_constantHelper.CONTAINING_ISBN){
                if(PO != null && PO !=''){
                    query += 'AND ';
                    query += ' (PoNumber__c=:PO OR Account_PO_Number__c=:PO) ';
                }  
                
                if(startDate !=null){
                    query += 'AND ';
                    query += 'EffectiveDate >=:startDate ';
                }
                
                if(endDate !=null){
                    query += 'AND ';
                    query += 'EffectiveDate <=:endDate ';
                }
                
                if(orderStatus !=null && orderStatus !='' && orderStatus !=scc_constantHelper.ALL){
                    query += 'AND ';
                    query += 'Order_Status_Code__c=:orderStatus ';
                }  
                if(Country != null && Country !=''){
                    query += 'AND ';
                    if(Country == scc_constantHelper.COUNTRY_UNITED_STATES){                        
                      List<String> countries = new List<String>{'US', 'USA', 'United States'};
                      List<String> conditions = new List<String>();
                      for (String country1 : countries) {
    						conditions.add('(ShippingCountry = \'' + country1 + '\' OR BillingCountry = \'' + country1 + '\')');
					  }
                      query += ' (' + String.join(conditions, ' OR ') + ') ';
                        
                    }else if(Country == scc_constantHelper.COUNTRY_CANADA){
                      List<String> countries = new List<String>{'Canada', 'CA'};
                      List<String> conditions = new List<String>();
                      for (String country1 : countries) {
    						conditions.add('(ShippingCountry = \'' + country1 + '\' OR BillingCountry = \'' + country1 + '\')');
					  }
                      query += ' (' + String.join(conditions, ' OR ') + ') ';  
                    }else{
                      query += '(ShippingCountry=:Country OR BillingCountry=:Country) ';  
                    }
                }
                if(State != null && State !=''){
                    query += 'AND ';
                    query += '(ShippingState=:State OR BillingState=:State) ';
                }
                
                if(Zip != null && Zip !=''){
                    query += 'AND ';
                    String zipLikeParam = Zip + '%'; 
                    system.debug('entered23'+zip);
                    query += ' (ShippingPostalCode LIKE \''+zipLikeParam+'\' OR BillingpostalCode LIKE \''+zipLikeParam+'\') ';
                }
                
            }
            
            if(SearchValue==scc_constantHelper.ORDER_NUMBER){
                system.debug('OrderNum'+OrderNum);
                if(OrderNum != null && OrderNum !=''){
                    query += 'AND ';
                    query += 'SAP_Document_Number__c=:OrderNum ';
                }
                if(orderStatus !=null && orderStatus !='' && orderStatus !=scc_constantHelper.ALL){
                    query += 'AND ';
                    query += 'Order_Status_Code__c=:orderStatus ';
                } 
            }
            
            if(SearchValue==scc_constantHelper.ZIP_POSTAL_CODE){
                if(Zip != null && Zip !=''){
                    
                    query += 'AND ';
                    system.debug('entered2'+Zip);
                    String zipLikeParam = Zip + '%'; 
                    query += ' (ShippingPostalCode LIKE \''+zipLikeParam+'\' OR BillingpostalCode LIKE \''+zipLikeParam+'\') ';
                }
                
                if(CustNam != null && CustNam !=''){
                    String likeParam = '' +CustNam+'%';
                    query += 'AND '; 
                    query += '(BillingName__c LIKE \''+likeParam+'\' OR ShipTo_Name__c LIKE \''+likeParam+'\') '; 
                }  
                
            }
            
            if(SearchValue==scc_constantHelper.STATE_PROVINCE){
                if(State != null && State !=''){
                    query += 'AND ';
                    query += '(ShippingState=:State OR BillingState=:State) ';
                }
                if(City != null && City !=''){
                    query += 'AND ';
                    query += '(ShippingCity=:City OR BillingCity=:City) ';
                }
                if(CustNam != null && CustNam !=''){
                    String likeParam = '' +CustNam+'%';
                    query += 'AND '; 
                    query += '(BillingName__c LIKE \''+likeParam+'\' OR ShipTo_Name__c LIKE \''+likeParam+'\') '; 
                }
            }
            
            if(SearchValue==scc_constantHelper.COUNTRY){ 
                if(Country != null && Country !=''){
                    query += 'AND ';
                    if(Country == scc_constantHelper.COUNTRY_UNITED_STATES){                        
                      List<String> countries = new List<String>{'US', 'USA', 'United States'};
                      List<String> conditions = new List<String>();
                      for (String country1 : countries) {
    						conditions.add('(ShippingCountry = \'' + country1 + '\' OR BillingCountry = \'' + country1 + '\')');
					  }
                      query += ' (' + String.join(conditions, ' OR ') + ') ';
                        
                    }else if(Country == scc_constantHelper.COUNTRY_CANADA){
                      List<String> countries = new List<String>{'Canada', 'CA'};
                      List<String> conditions = new List<String>();
                      for (String country1 : countries) {
    						conditions.add('(ShippingCountry = \'' + country1 + '\' OR BillingCountry = \'' + country1 + '\')');
					  }
                      query += ' (' + String.join(conditions, ' OR ') + ') ';  
                    }else{
                      query += '(ShippingCountry=:Country OR BillingCountry=:Country) ';  
                    }
                } 
                
                if(CustNam != null && CustNam !=''){
                    String likeParam = '' +CustNam+'%';
                    query += 'AND '; 
                    query += '(BillingName__c LIKE \''+likeParam+'\' OR ShipTo_Name__c LIKE \''+likeParam+'\') '; 
                }                
            }
            System.debug('Shipto: '+Shipto);
            System.debug('BillTo: '+BillTo);
            //For internal user added by zubiya
            
            if(SearchValue==scc_constantHelper.CUSTOMER_ACCOUNT){
                
                if(Shipto != null && Shipto !=''){
                    query += ' AND ';   
                    query += 'SAP_Shipto__c =: Shipto ';
                }
                if(BillTo != null && BillTo !=''){ 
                    query += ' AND ';
                    query += 'SAP_BillTo__c =: BillTo ';
                }
                
                if(PO != null && PO !=''){
                    query += 'AND ';
                    query += ' (PoNumber__c=:PO OR Account_PO_Number__c=:PO) ';
                }  
                
                if(startDate !=null){
                    query += 'AND ';
                    query += 'EffectiveDate >=:startDate ';
                }
                
                if(endDate !=null){
                    query += 'AND ';
                    query += 'EffectiveDate <=:endDate ';
                }
                
                if(orderStatus !=null && orderStatus !='' && orderStatus !=scc_constantHelper.ALL){
                    query += 'AND ';
                    query += 'Order_Status_Code__c=:orderStatus ';
                }  
            }
            
            //Customer Name 
            if(SearchValue==scc_constantHelper.CUSTOMER_NAME){
                if(CustNam != null && CustNam !=''){
                    String likeParam = '' +CustNam+'%';
                    query += 'AND '; 
                    query += '(BillingName__c LIKE \''+likeParam+'\' OR ShipTo_Name__c LIKE \''+likeParam+'\') '; 
                }
            }
            //End for internal user
            
            if(SearchValue == scc_constantHelper.CUSTOMER_SAN){
                if(SAN != null && SAN !=''){
                    query += 'AND ';
                    query += 'Account.SAP_Account_Id__c=:SAN ';
                }
                
                if(PO != null && PO !=''){
                    query += 'AND ';
                    query += ' (PoNumber__c=:PO OR Account_PO_Number__c=:PO) ';
                }
                
                if(orderStatus !=null && orderStatus !='' && orderStatus !=scc_constantHelper.ALL){
                    query += 'AND ';
                    query += 'Order_Status_Code__c=:orderStatus ';
                } 
            }
            
            //changes for W-014384 US-184 starts
            if(SearchValue == scc_constantHelper.ALL_ORDERS){
                if(orderStatus !=null && orderStatus !='' && orderStatus !=scc_constantHelper.ALL){
                    query += 'AND ';
                    query += 'Order_Status_Code__c=:orderStatus ';
                }
            }
            //changes for W-014384 US-184 ends
            
            
            String query2 = query +' ORDER BY EffectiveDate DESC LIMIT 1 ';//query to check if query is returning atleast one value or not.
            query += ' ORDER BY EffectiveDate DESC LIMIT 40000 ';
            
            System.debug('query'+query);
            
            if(Database.query(query2).isEmpty() && PO != null && PO !=''){
                query = query.replace('AND  (PoNumber__c=:PO OR Account_PO_Number__c=:PO) ','');
                System.debug('query'+query);
                workTextCombined = true;
            }
            
            for (Order o :Database.query(query)){
                ISBNMatch = false;
                Customer_ShipTo_AccName ='';
                Customer_BillTo_AccName = '';
                getCriteriaOrderwrapper ordertoSend = new getCriteriaOrderwrapper();
                
                if(o.ShipTo_Name__c != null){
                    Customer_ShipTo_AccName = o.ShipTo_Name__c+' '+'|';
                }
                
                if(o.ShippingStreet != null){
                    Customer_ShipTo_AccName = ' '+Customer_ShipTo_AccName+' '+o.ShippingStreet;
                }
                
                if(o.ShippingCity != null){
                    Customer_ShipTo_AccName = ' '+Customer_ShipTo_AccName+','+o.ShippingCity;
                }
                
                if(o.ShippingState != null){
                    Customer_ShipTo_AccName = ' '+Customer_ShipTo_AccName+','+o.ShippingState;
                }
                
                if(o.ShippingPostalCode != null){
                    Customer_ShipTo_AccName = ' '+Customer_ShipTo_AccName+','+o.ShippingPostalCode;
                }
                
                if(o.ShippingCountry != null){
                    Customer_ShipTo_AccName = ' '+Customer_ShipTo_AccName+','+o.ShippingCountry;
                } 
                
                
                if(o.BillingName__c != null){
                    Customer_BillTo_AccName = o.BillingName__c+' '+'|';
                }
                
                if(o.Billingstreet != null){
                    Customer_BillTo_AccName = ' '+Customer_BillTo_AccName+' '+o.Billingstreet;
                }
                
                if(o.Billingcity != null){
                    Customer_BillTo_AccName = ' '+Customer_BillTo_AccName+','+o.Billingcity;
                }
                
                if(o.Billingstate != null){
                    Customer_BillTo_AccName = ' '+Customer_BillTo_AccName+','+o.Billingstate;
                }
                
                if(o.BillingpostalCode != null){
                    Customer_BillTo_AccName = ' '+Customer_BillTo_AccName+','+o.BillingpostalCode;
                }
                
                if(o.Billingcountry != null){
                    Customer_BillTo_AccName = ' '+Customer_BillTo_AccName+','+o.Billingcountry;
                }
                
                if(workTextCombined == true){
                    ordertoSend.workTextPO = true;
                }else{
                    ordertoSend.workTextPO = false;
                }
                ordertoSend.siopOrder = false;
                ordertoSend.CustShpippingAddress = Customer_ShipTo_AccName;
                ordertoSend.CustBillingAddress = Customer_BillTo_AccName;
                ordertoSend.Identi = o.ID;
                ordertoSend.SAP_Document_Number = o.SAP_Document_Number__c;
                ordertoSend.PO = o.PoNumber__c;
                ordertoSend.OrderDate = String.valueOf(o.EffectiveDate.month())+'/'+String.valueOf(o.EffectiveDate.day())+'/'+String.valueOf(o.EffectiveDate.year());               	
                ordertoSend.Totalunits=o.Order_Total_Units__c;
                ordertoSend.TotalItems = o.Total_Items__c;
                ordertoSend.siopOrder = o.SIOP_Order__c;
                
                if(ISBN !=null && ISBN !=''){
                    System.debug('Inside if ISBN');
                    System.debug('o.OrderItems'+o.OrderItems);
                    
                    if(o.OrderItems.size() > 0){
                        ISBNMatch = true;
                    }
                    
                    if(ISBNMatch == true){
                        if(PO !=null && PO !='' && workTextCombined != false){
                            if(String.isNotBlank(o.Combine_PONumber__c) ? true : false){
                                if(o.Combine_PONumber__c.contains(PO) || o.Account_PO_Number__c==PO || o.PoNumber__c==PO){
                                    getCriteriaOrderDataToSend.add(ordertoSend);
                                }else{
                                    system.debug('do nothing1');
                                }
                            }else{
                                if(o.Account_PO_Number__c==PO || o.PoNumber__c==PO){
                                    getCriteriaOrderDataToSend.add(ordertoSend);
                                }else{
                                    system.debug('do nothing2');
                                }
                            }
                        }else{
                            getCriteriaOrderDataToSend.add(ordertoSend);   
                        }
                    }                                                                                             
                }else{
                    if(PO !=null && PO !='' && workTextCombined != false){
                        if(String.isNotBlank(o.Combine_PONumber__c) ? true : false){
                            if(o.Combine_PONumber__c.contains(PO) || o.Account_PO_Number__c==PO || o.PoNumber__c==PO){
                                getCriteriaOrderDataToSend.add(ordertoSend);
                            }else{
                                system.debug('do nothing1');
                            }
                        }else{
                            if(o.Account_PO_Number__c==PO || o.PoNumber__c==PO){
                                getCriteriaOrderDataToSend.add(ordertoSend);
                            }else{
                                system.debug('do nothing2');
                            }
                        }
                    }else{
                        getCriteriaOrderDataToSend.add(ordertoSend);   
                    }                              
                }               
            }
            system.debug('***getCpuTime()***'+Limits.getCpuTime());
            system.debug('final data to send'+getCriteriaOrderDataToSend);
            return JSON.serialize(getCriteriaOrderDataToSend);
            
        }catch(Exception e){
            System.debug(scc_constantHelper.EXCEPTION_TYPE_CAUGHT+ e.getTypeName());    
            System.debug(scc_constantHelper.MESSAGE+ e.getMessage());    
            System.debug(scc_constantHelper.CAUSE+ e.getCause());    // returns null
            System.debug(scc_constantHelper.LINE_NUMBER + e.getLineNumber());    
            System.debug(scc_constantHelper.STACK_RACE+ e.getStackTraceString());
            return '';
        }
    }
    
    /**
*  Description: This method padds zero for ISBNs having length less than 10 to make it 10 or for length between 10-13 to make it 13   
*  @name: padZerosLeftforOrder
*  @param:Parameters like ISBN Value, Length of ISBN
*  @return: Padded value of ISBN
*  @throws exception- 
*/  
    public static String padZerosLeftforOrder(String input, Integer length) {
        String paddedValue = input;
        try{
            while (paddedValue.length() < length) {
                paddedValue = '0' + paddedValue;
            }
            return paddedValue;
        }catch(Exception e){
            System.debug(scc_constantHelper.EXCEPTION_TYPE_CAUGHT+ e.getTypeName());    
            System.debug(scc_constantHelper.MESSAGE+ e.getMessage());    
            System.debug(scc_constantHelper.CAUSE+ e.getCause());    // returns null
            System.debug(scc_constantHelper.LINE_NUMBER + e.getLineNumber());    
            System.debug(scc_constantHelper.STACK_RACE+ e.getStackTraceString());
            return paddedValue;
        }
    }
    
    //wrapper class for search by options 
    public class getSearchByOptionsWrapper{
        public String label;
        public String value;
        getSearchByOptionsWrapper(String label,String value){
            this.label = label;
            this.value = value;
        }
        
    }
    //wrapper class for order status options
    public class getOrderStatusOptionsWrapper{
        public String label;
        public String value;
        getOrderStatusOptionsWrapper(String label,String value){
            this.label = label;
            this.value = value;
        }
        
    }
    
    /**
*  Description: This method queries state options from SCC_StateInfo__c object.   
*  @name: getStatesOptions
*  @param:NA
*  @return: String of state options
*  @throws exception- 
*/ 
    @AuraEnabled
    public static String getStatesOptions(){
        try{
            List<SCC_StateInfo__c> getStatesOptionsData = [SELECT Name,State_Code__c FROM SCC_StateInfo__c ORDER BY Name ASC];        
            List<geStatesOptionsWrapper> geStatesOptionsWrap = new List<geStatesOptionsWrapper>();       
            for(Integer i=0;i<getStatesOptionsData.size();i++){
                geStatesOptionsWrap.add(new geStatesOptionsWrapper(getStatesOptionsData[i].Name,getStatesOptionsData[i].State_Code__c)); 
            }       
            return JSON.serialize(geStatesOptionsWrap); 
        }catch(Exception e){
            System.debug(scc_constantHelper.EXCEPTION_TYPE_CAUGHT+ e.getTypeName());    
            System.debug(scc_constantHelper.MESSAGE+ e.getMessage());    
            System.debug(scc_constantHelper.CAUSE+ e.getCause());    // returns null
            System.debug(scc_constantHelper.LINE_NUMBER + e.getLineNumber());    
            System.debug(scc_constantHelper.STACK_RACE+ e.getStackTraceString());
            throw new AuraHandledException('Failed to get state options:'+e.getMessage()+e.getCause());
        }
    }
    
    public class geStatesOptionsWrapper{
        public String label;
        public String value;
        geStatesOptionsWrapper(String label,String value){
            this.label = label;
            this.value = value;
        }    
    }
    //wrapper class for country options
    public class getCountrysOptionsWrapper{
        public String label;
        public String value;
        getCountrysOptionsWrapper(String label,String value){
            this.label = label;
            this.value = value;
        }    
    }
    
    public class getOrderStatusDataWrapper {
        @AuraEnabled 
        public String OrderNumber {get; set;}
        @AuraEnabled 
        public String Status {get; set;}
        @AuraEnabled 
        public String PoNumber {get; set;}
        @AuraEnabled
        public String SAP_Document_Number {get; set;}
        @AuraEnabled 
        public String Account_PO_Number {get; set;}
        @AuraEnabled 
        public String EffectiveDate {get; set;}
        @AuraEnabled 
        public String ShipToName {get; set;}
        @AuraEnabled
        public String BillingName {get; set;}
        
        public getOrderStatusDataWrapper(String OrderNumber, String Status, String PoNumber, String SAP_Document_Number,String EffectiveDate, String ShipToName, String BillingName, String Account_PO_Number) {
            this.OrderNumber = OrderNumber;
            this.Status = Status;
            this.PoNumber = PoNumber;
            this.SAP_Document_Number = SAP_Document_Number;
            this.EffectiveDate = EffectiveDate;
            this.ShipToName = ShipToName;
            this.BillingName = BillingName;
            this.Account_PO_Number = Account_PO_Number;
       }  
    }
    
    //Wrapper class data for Order fiters conditions
    public class getCriteriaOrderwrapper{
        @AuraEnabled public String Identi;
        @AuraEnabled public String PO;
        @AuraEnabled public String ISBN;
        @AuraEnabled public Date startDate;
        @AuraEnabled public Date endDate;
        @AuraEnabled public String orderStatus;
        @AuraEnabled public String SAP_Document_Number;
        @AuraEnabled public String CustShpippingAddress;
        @AuraEnabled public String CustBillingAddress;
        @AuraEnabled public String OrderMethod;
        @AuraEnabled public Decimal TotalItems;
        @AuraEnabled public Decimal Totalunits;
        @AuraEnabled public String OrderDate;
        @AuraEnabled public Boolean OurShipTo;
        @AuraEnabled public Boolean AllShipTo;
        @AuraEnabled public Boolean siopOrder;
        @AuraEnabled public Boolean workTextPO;
    }
}