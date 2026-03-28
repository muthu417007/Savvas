public without sharing class testRecentController {

    /**
    *  Description: This method queries search by options from custom metadata      
    *  @name: getSearchByOptions
    *  @param:No parameters
    *  @return: String values of search by options
    *  @throws exception- 
    */
        @AuraEnabled(cacheable=true)
        public static String getSearchByOptions(Boolean HomePage){//changes for W-014196 US-163 starts
         //public static String getSearchByOptions(){
            //List<scc_searchByOptions__mdt> scc_searchByOptionsData = [SELECT MasterLabel,Priority__c,IsActive__c FROM scc_searchByOptions__mdt WHERE IsActive__c=true ORDER BY Priority__c ASC NULLS LAST];
            List<User> usr = [select ID,Profile.Name,IsEmployee__c, Contact.AccountID,Contact.Account.SAP_Account_Id__c,contact.name,contact.Account.name from user where id =: userInfo.getUserID()]; 
            String query = 'SELECT MasterLabel,isGuest__c,IsInternal__c,IsExternal__c,Priority__c,IsActive__c FROM scc_searchByOptions__mdt WHERE IsActive__c=true ';
            if(HomePage == true){
                query += ' AND IsHomepage__c=true ';
            }
            if(usr[0].profile.name == 'MySavvasOrders Profile'){
                 query += ' AND isGuest__c=true ';
            }
            if(usr[0].profile.name == 'Savvas External Users Base Profile'){// added by sudha // for community users 
                 query += ' AND IsExternal__c=true ';
            }
            if (usr[0].IsEmployee__c == true) { // added by sudha // for savvas internal  users 
        		query += ' AND IsInternal__c=true '; 
    		}
            query += ' ORDER BY Priority__c ASC NULLS LAST';
               system.debug('query is '+query);
            List<scc_searchByOptions__mdt> scc_searchByOptionsData = Database.query(query);
            //changes for W-014196 US-163 ends
            List<getSearchByOptionsWrapper> getSearchByOptionsWrap = new List<getSearchByOptionsWrapper>();
            for(Integer i=0;i<scc_searchByOptionsData.size();i++){
                getSearchByOptionsWrap.add(new getSearchByOptionsWrapper(scc_searchByOptionsData[i].MasterLabel,scc_searchByOptionsData[i].MasterLabel)); 
            }
      
            return JSON.serialize(getSearchByOptionsWrap);
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
            List<scc_orderStatusOptions__mdt> scc_orderStatusOptionsData = [SELECT MasterLabel,Priority__c,IsActive__c FROM scc_orderStatusOptions__mdt WHERE IsActive__c=true ORDER BY Priority__c ASC NULLS LAST];
            List<getOrderStatusOptionsWrapper> getOrderStatusOptionsWrap = new List<getOrderStatusOptionsWrapper>();
            for(Integer i=0;i<scc_orderStatusOptionsData.size();i++){
                getOrderStatusOptionsWrap.add(new getOrderStatusOptionsWrapper(scc_orderStatusOptionsData[i].MasterLabel,scc_orderStatusOptionsData[i].MasterLabel)); 
            }
            return JSON.serialize(getOrderStatusOptionsWrap);
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
            List<ZVC__Country_Phone_Code__c> getCountrysOptionsData = [SELECT ZVC__Country_Code__c FROM ZVC__Country_Phone_Code__c WHERE ZVC__Country_Code__c NOT IN ('United States','Canada')];        
            List<getCountrysOptionsWrapper> getCountrysOptionsWrap = new List<getCountrysOptionsWrapper>();       
            for(Integer i=0;i<getCountrysOptionsData.size();i++){
                getCountrysOptionsWrap.add(new getCountrysOptionsWrapper(getCountrysOptionsData[i].ZVC__Country_Code__c,getCountrysOptionsData[i].ZVC__Country_Code__c)); 
            }       
            return JSON.serialize(getCountrysOptionsWrap);
        }
    
    /**
    *  Description: This method queries Country order details from Order Object     
    *  @name: getOrderStatusData
    *  @param:No parameters
    *  @return: String values of Order Details
    *  @throws exception- 
    */    
       /* @AuraEnabled(cacheable=true)
        public static String getOrderStatusData() {
            List<User> usr = [select ID,Profile.Name, Contact.AccountID,contact.name,contact.Account.name from user where id =: userInfo.getUserID()];
            //List<User> usr = [select ID,Profile.Name, Contact.AccountID,contact.name,contact.Account.name from user where Contact.AccountID ='0015300000U1p4NAAR'];        
            List<Order> getOrderData = [SELECT OrderNumber,Order_Status_Code__c,ShipTo_Name__c,PoNumber__c,SAP_Document_Number__c,EffectiveDate,Account_PO_Number__c FROM Order WHERE AccountId=:usr[0].Contact.AccountID ORDER BY EffectiveDate DESC,Account_PO_Number__c DESC, SAP_Document_Number__c DESC LIMIT 10 ];              
            List<getOrderStatusDataWrapper> getOrderStatusDataWrap = new List<getOrderStatusDataWrapper>();
            for(Integer i=0;i<getOrderData.size();i++){
                getOrderStatusDataWrap.add(new getOrderStatusDataWrapper(getOrderData[i].OrderNumber,getOrderData[i].Order_Status_Code__c,getOrderData[i].Account_PO_Number__c,getOrderData[i].SAP_Document_Number__c,getOrderData[i].EffectiveDate,getOrderData[i].ShipTo_Name__c)); 
            }
            return JSON.serialize(getOrderStatusDataWrap);
        }*/
    /*********************************************************/   
 	@AuraEnabled(cacheable=true)
	public static String getOrderStatusData(Boolean isCredits) {
    List<User> usr = [SELECT Id, Profile.Name, Contact.AccountID, Contact.Name, Contact.Account.Name 
                      FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
    if (usr.isEmpty()) {
        return 'Error: User information not found';
    }

    String userAccountId = usr[0].Contact.AccountID;
    String profileName = usr[0].Profile.Name;
    String result;
    
    try {
        List<getOrderStatusDataWrapper> getOrderStatusDataWrap = new List<getOrderStatusDataWrapper>();
        
        if (profileName == 'Savvas External Users Base Profile' && userAccountId != null) {
            // External user query
            String orderQuery = 'SELECT OrderNumber, Order_Status_Code__c, ShipTo_Name__c, BillingName__c, ' +
                                'PoNumber__c, scc_LastViewDate__c, scc_Recently_Viewed_User__c, ' +
                                'SAP_Document_Number__c, EffectiveDate, Account_PO_Number__c, SAP_Order_Type__c ' +
                                'FROM Order ' +
                                'WHERE AccountId = \'' + userAccountId + '\' ' +
                                'AND SAP_Document_Number__c != null ';
            
            if (isCredits) {
                orderQuery += 'AND (SAP_Order_Type__c = \'ZCRC\' OR SAP_Order_Type__c = \'ZDMR\') ';
            }

            orderQuery += 'ORDER BY EffectiveDate DESC, Account_PO_Number__c DESC, SAP_Document_Number__c DESC LIMIT 10';
            
            // Execute the Order query and wrap the results
            List<Order> orders = Database.query(orderQuery);
            for (Order ord : orders) {
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
            // Internal user query
            List<RecentlyViewed> recentlyViewedRecords = [SELECT Id, Name, LastViewedDate
                                                           FROM RecentlyViewed
                                                           WHERE Type = 'Order'
                                                           ORDER BY LastViewedDate DESC
                                                           LIMIT 10];
            List<Id> orderIds = new List<Id>();
            for (RecentlyViewed rv : recentlyViewedRecords) {
                orderIds.add(rv.id);
            }
            
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

                orderQuery += 'ORDER BY scc_LastViewDate__c DESC';
                
                List<Order> orders = Database.query(orderQuery);
                for (Order ord : orders) {
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
    } catch (Exception e) {
        result = 'Error: ' + e.getMessage();
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

    } catch (DmlException e) {
       
        System.debug('Error updating order: ' + e.getMessage());
        
        throw new AuraHandledException('Error updating order: ' + e.getMessage());
    }
}
       
    /*********************************************************/ 
    
    /**
    *  Description: This method queries order details from Order based on different Criteria's     
    *  @name: getCriteriaOrderdata
    *  @param:Parameters like PO,ISBN,Dates,Order Status,Order Number,SAN, Search by Values etc.
    *  @return: String values of Order Details
    *  @throws exception- When any issues while querying the data or assigning the data wrapper variables.
    */  
        @AuraEnabled
        public static String getCriteriaOrderdata(String PO,String ISBN,Date startDate,Date endDate,String orderStatus,String OrderNum,String Zip,String State,String City,String Country,String CustNam,String Shipto,String BillTo,String SAN,String Invo,String SearchValue) {
            set<getCriteriaOrderwrapper> getCriteriaOrderDataToSend = new set<getCriteriaOrderwrapper>();
            String Customer_ShipTo_AccName ='';
            String Customer_BillTo_AccName ='';
            String street1;
            String city1;
            String state1;
            String postalCode1;
            String country1;
            String street2;
            String city2;
            String state2;
            String postalCode2;
            String country2;
            String isbnValue = ISBN;
            String combinedPOCheck = PO.replaceAll('[^a-zA-Z0-9]','');
            system.debug('combinedPOCheck is'+combinedPOCheck); 
            boolean internalCheck = false;
            boolean workTextCombined = false;
            String IsbnValues = system.label.scc_OrderDetail_SIOP_ISBNs;
            Boolean ISBNMatch = false;
            ISBN = String.isNotBlank(isbnValue) ? (isbnValue.length() <= 10 ? padZerosLeftforOrder(isbnValue, 10) : (isbnValue.length() <= 13 ? padZerosLeftforOrder(isbnValue, 13) : null)) : null;
            //List<scc_siopIsbnNumbers__mdt> siopIsbnList = new List<scc_siopIsbnNumbers__mdt>();
            try{
                List<User> usr = [select ID,IsActive,Profile.Name,IsEmployee__c, Contact.AccountID,Contact.Account.SAP_Account_Id__c,contact.name,contact.Account.name from user where id =: userInfo.getUserID()]; 
                List<PermissionSetAssignment> permissions = [SELECT Id,Assignee.Email,PermissionSetId,PermissionSet.Name, Assignee.Id,Assignee.Name FROM PermissionSetAssignment WHERE PermissionSet.Name='Savvas_SIOP_Permissions' and Assignee.Id=:userInfo.getUserID()];
                
                system.debug('PO is'+PO);
                   if(orderStatus =='false'){
                    //orderStatus = 'All';
                    orderStatus = scc_constantHelper.ALL;
                }
                system.debug('orderStatus is'+orderStatus);
                String query = 'SELECT ID,Account.SAP_Account_Number__c,Combine_PONumber__c,Account_PO_Number__c,PoNumber__c,scc_Combined_PO_text__c,SAP_Document_Number__c,EffectiveDate,Order_Status_Code__c,ShippingAddress,BillingAddress,SAP_Order_Type__c,BillingName__c,Account.SAP_Account_Id__c,BillingStreet,BillingCity,BillingState,BillingPostalCode,BillingCountry,ShippingStreet,ShippingCity,ShippingState,ShippingPostalCode,ShippingCountry,SAP_Shipto__c,SAP_BillTo__c,Orig_Ord_Lin_Count__c,ShipTo_Name__c,Order_Total_Units__c,Total_Items__c ';
                //String query = 'SELECT ID,Account.SAP_Account_Number__c,Account_PO_Number__c,PoNumber__c,SAP_Document_Number__c,EffectiveDate,Order_Status_Code__c,ShippingAddress,BillingAddress,Original_Order_Qty__c,SAP_Order_Type__c,BillingName__c,Account.SAP_Account_Id__c,BillingStreet,BillingCity,BillingState,BillingPostalCode,BillingCountry,ShippingStreet,ShippingCity,ShippingState,ShippingPostalCode,ShippingCountry,SAP_Shipto__c,SAP_BillTo__c,Order_Total_Units__c,ShipTo_Name__c ';         
                  system.debug(query+'entered1');
                //if(SearchValue == 'Zip/Postal Code' && SearchValue == 'State/Province' && SearchValue == 'Country' ){
                if(SearchValue == scc_constantHelper.ZIP_POSTAL_CODE && SearchValue == scc_constantHelper.STATE_PROVINCE && SearchValue == scc_constantHelper.COUNTRY ){
                    query += 'FROM Order ';
                     system.debug(query+'entered2');
                }else{
                    query += ',(Select OrderItemNumber,SAP_Invoice_Number__c,Product2.ISBN10__c,Product2.ProductCode,Product2.ISBN13__c from OrderItems) FROM Order ';
                     system.debug(query+'entered3');
                }
                
    
                if(usr[0].Profile.Name =='Savvas External Users Base Profile' || usr[0].Profile.Name =='Customer Community Login User'){      
                      String userAccountId =usr[0].Contact.AccountID;
                      query += 'WHERE AccountId=:userAccountId '; 
                      query += 'AND SAP_Document_Number__c != null ';
                    	
                  }else if(usr[0].profile.name == 'MySavvasOrders Profile'){
                    if(Zip != null && Zip !=''){
                        query += 'WHERE (ShippingPostalCode=:Zip OR BillingpostalCode=:Zip) ';
                        query += 'AND SAP_Document_Number__c != null ';
                    }
                 
                }else if(!((usr[0].profile.name == 'Savvas External Users Base Profile') && (usr[0].profile.name == 'MySavvasOrders Profile'))){
                        query += 'WHERE SAP_Document_Number__c != null ';           
                             
                }            
                                
                //if(SearchValue=='PO#' || searchValue =='Our Ship-To Locations Only' || searchValue == 'All Ship-To Locations' ){
                  if(SearchValue==scc_constantHelper.PO_NUMBER || searchValue ==scc_constantHelper.OUR_SHIP_TO_LOCATIONS_ONLY || searchValue == scc_constantHelper.ALL_SHIP_TO_LOCATIONS ){
                    if(PO != null && PO !=''){
                            String likePO = '%' +combinedPOCheck+ '%';
                            query += 'AND ';
                            //query += ' (scc_Combined_PO_text__c LIKE \'%' + likePO + '%\'';
                            //query += ' OR Account_PO_Number__c=:PO) ';
                            query += ' (PoNumber__c=:PO OR Account_PO_Number__c=:PO) ';
                            /*query += 'AND ';
                            query += 'PoNumber__c=:PO ';*/ 
                    }  
                    
                    if(startDate !=null){
                        query += 'AND ';
                        query += 'EffectiveDate >=:startDate ';
                    }
                
                    if(endDate !=null){
                        query += 'AND ';
                        query += 'EffectiveDate <=:endDate ';
                    }
                    
                       //if(orderStatus !=null && orderStatus !='' && orderStatus !='All'){
                    if(orderStatus !=null && orderStatus !='' && orderStatus !=scc_constantHelper.ALL){
                        query += 'AND ';
                        query += 'Order_Status_Code__c=:orderStatus ';
                    }
        
                       //if(searchValue =='Our Ship-To Locations Only'){
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
                
                
                //if(SearchValue=='Containing ISBN'){
                if(SearchValue==scc_constantHelper.CONTAINING_ISBN){
                    if(PO != null && PO !=''){
                        String likePO = '%' +combinedPOCheck+ '%';
                        query += 'AND ';
                        //query += ' (scc_Combined_PO_text__c LIKE \'%' + likePO + '%\'';
                        //query += ' OR Account_PO_Number__c=:PO) ';
                        query += ' (PoNumber__c=:PO OR Account_PO_Number__c=:PO) ';
                        /*query += 'AND ';
                        query += 'PoNumber__c=:PO ';*/ 
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
                        query += '(ShippingCountry=:Country OR BillingCountry=:Country) ';
                    }
                    if(State != null && State !=''){
                        query += 'AND ';
                        query += '(ShippingState=:State OR BillingState=:State) ';
                    }
                    
                       if(Zip != null && Zip !=''){
                        query += 'AND ';
                        query += '(ShippingPostalCode=:Zip OR BillingpostalCode=:Zip) ';
                    }
                    
                }
                
                //if(SearchValue=='Order #'){
                if(SearchValue==scc_constantHelper.ORDER_NUMBER){
                    if(OrderNum != null && OrderNum !=''){
                        query += 'AND ';
                        query += 'SAP_Document_Number__c=:OrderNum ';
                    }
                       if(orderStatus !=null && orderStatus !='' && orderStatus !=scc_constantHelper.ALL){
                        query += 'AND ';
                        query += 'Order_Status_Code__c=:orderStatus ';
                    } 
                }
                
                //if(SearchValue=='Zip/Postal Code'){
                if(SearchValue==scc_constantHelper.ZIP_POSTAL_CODE){
                    if(Zip != null && Zip !=''){
                        query += 'AND ';
                        query += '(ShippingPostalCode=:Zip OR BillingpostalCode=:Zip) ';
                    }
                }
                
                //if(SearchValue=='State/Province'){
                if(SearchValue==scc_constantHelper.STATE_PROVINCE){
                    if(State != null && State !=''){
                        query += 'AND ';
                        query += '(ShippingState=:State OR BillingState=:State) ';
                    }
                    if(City != null && City !=''){
                        query += 'AND ';
                        query += '(ShippingCity=:City OR BillingCity=:City) ';
                    }
                }
                
                //if(SearchValue=='Country'){
                if(SearchValue==scc_constantHelper.COUNTRY){ 
                    if(Country != null && Country !=''){
                           query += 'AND ';
                        query += '(ShippingCountry=:Country OR BillingCountry=:Country) ';
                    } 
                    
                    if(CustNam != null && CustNam !=''){
                            String likeParam = '' +CustNam+'%';
                            query += 'AND '; 
                            query += '(BillingName__c LIKE :likeParam OR ShipTo_Name__c LIKE :likeParam) '; 
                            //query += '(BillingName__c LIKE \' '+ CustNam + '%\' OR ShipTo_Name__c LIKE \' ' +CustNam + '%\') ';  
                        	//query += '(BillingName__c LIKE'+''CustNam'+'+'%'+'OR ShipTo_Name__c LIKE'+''CustNam+'+'%') '; 
                            //query += 'OR ShipTo_Name__c LIKE :likeParam ';  
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
                       String likePO = '%' +combinedPOCheck+ '%';
                       query += 'AND ';
                       //query += ' (scc_Combined_PO_text__c LIKE \'%' + likePO + '%\'';
                       //query += ' OR Account_PO_Number__c=:PO) ';
                        query += ' (PoNumber__c=:PO OR Account_PO_Number__c=:PO) ';
                        /*query += 'AND ';
                         query += 'PoNumber__c=:PO ';*/ 
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
                            query += '(BillingName__c LIKE :likeParam OR ShipTo_Name__c LIKE :likeParam) ';   
                            //query += 'OR ShipTo_Name__c LIKE :likeParam ';  
                    }          
                }
                //End for internal user
                
                //if(SearchValue == 'Customer SAN'){
                if(SearchValue == scc_constantHelper.CUSTOMER_SAN){
                    if(SAN != null && SAN !=''){
                        query += 'AND ';
                        query += 'Account.SAP_Account_Id__c=:SAN ';
                    }
                    
                    if(PO != null && PO !=''){
                         String likePO = '%' +combinedPOCheck+ '%';
                         query += 'AND ';
                         //query += ' (scc_Combined_PO_text__c LIKE \'%' + likePO + '%\'';
                         //query += ' OR Account_PO_Number__c=:PO) ';
                         query += ' (PoNumber__c=:PO OR Account_PO_Number__c=:PO) ';
                         /*query += 'AND ';
                          query += 'PoNumber__c=:PO ';*/ 
                    }
                    
                    //if(orderStatus !=null && orderStatus !='' && orderStatus !='All'){
                    if(orderStatus !=null && orderStatus !='' && orderStatus !=scc_constantHelper.ALL){
                        query += 'AND ';
                        query += 'Order_Status_Code__c=:orderStatus ';
                    } 
               }
                
               //changes for W-014384 US-184 starts
               //if(SearchValue == 'All Orders'){
               if(SearchValue == scc_constantHelper.ALL_ORDERS){
                   //if(orderStatus !=null && orderStatus !='' && orderStatus !='All'){
                   if(orderStatus !=null && orderStatus !='' && orderStatus !=scc_constantHelper.ALL){
                        query += 'AND ';
                        query += 'Order_Status_Code__c=:orderStatus ';
                    }
               }
               //changes for W-014384 US-184 ends
             
                System.debug('query'+query);
                List<Order> orders = Database.query(query);
                 System.debug('orders'+orders);
                
                if(orders.isEmpty() && PO != null && PO !=''){
                    query = query.replace('AND  (PoNumber__c=:PO OR Account_PO_Number__c=:PO) ','');
                    System.debug('query'+query);
                    orders = Database.query(query);
                     System.debug('orders'+orders);
                    workTextCombined = true;
                    //siopIsbnList = [select ISBN_number__c from scc_siopIsbnNumbers__mdt];
                }
                
                for (Order o :orders){
                    ISBNMatch = false;
                    Customer_ShipTo_AccName ='';
                    Customer_BillTo_AccName = '';
                    getCriteriaOrderwrapper ordertoSend = new getCriteriaOrderwrapper();
                    
                      if(o.ShipTo_Name__c != null){
                       Customer_ShipTo_AccName = o.ShipTo_Name__c+' '+'|';
                    }
                    
                    if(o.ShippingStreet != null){
                       street1 = o.ShippingStreet; 
                       Customer_ShipTo_AccName = ' '+Customer_ShipTo_AccName+' '+o.ShippingStreet;
                    }
                    
                    if(o.ShippingCity != null){
                       city1 = o.ShippingCity;
                       Customer_ShipTo_AccName = ' '+Customer_ShipTo_AccName+','+o.ShippingCity;
                    }
                    
                    if(o.ShippingState != null){
                       state1 =  o.ShippingState;
                       Customer_ShipTo_AccName = ' '+Customer_ShipTo_AccName+','+o.ShippingState;
                    }
    
                    if(o.ShippingPostalCode != null){
                       postalCode1 = o.ShippingPostalCode;
                       Customer_ShipTo_AccName = ' '+Customer_ShipTo_AccName+','+o.ShippingPostalCode;
                    }
                    
                    if(o.ShippingCountry != null){
                       country1 = o.ShippingCountry;
                       Customer_ShipTo_AccName = ' '+Customer_ShipTo_AccName+','+o.ShippingCountry;
                    } 
                    
                    
                      if(o.BillingName__c != null){
                       Customer_BillTo_AccName = o.BillingName__c+' '+'|';
                    }
                    
                    if(o.Billingstreet != null){
                       street2 = o.Billingstreet; 
                       Customer_BillTo_AccName = ' '+Customer_BillTo_AccName+' '+o.Billingstreet;
                    }
                    
                    if(o.Billingcity != null){
                       city2 = o.Billingcity;
                       Customer_BillTo_AccName = ' '+Customer_BillTo_AccName+','+o.Billingcity;
                    }
                    
                    if(o.Billingstate != null){
                       state2 =  o.Billingstate;
                       Customer_BillTo_AccName = ' '+Customer_BillTo_AccName+','+o.Billingstate;
                    }
    
                    if(o.BillingpostalCode != null){
                       postalCode2 = o.BillingpostalCode;
                       Customer_BillTo_AccName = ' '+Customer_BillTo_AccName+','+o.BillingpostalCode;
                    }
                    
                    if(o.Billingcountry != null){
                       country2 = o.Billingcountry;
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
                    //ordertoSend.orderStatus = o.Order_Status_Code__c;
                    //ordertoSend.PO = o.Account_PO_Number__c;
                    ordertoSend.PO = o.PoNumber__c;
                    //ordertoSend.OrderDate=o.EffectiveDate;
                    ordertoSend.OrderDate = String.valueOf(o.EffectiveDate.month())+'/'+String.valueOf(o.EffectiveDate.day())+'/'+String.valueOf(o.EffectiveDate.year());               	
                    //ordertoSend.TotalItems=o.Original_Order_Qty__c;
                    ordertoSend.Totalunits=o.Order_Total_Units__c;
                    //ordertoSend.TotalItems = o.Order_Total_Items__c;
                    ordertoSend.TotalItems = o.Total_Items__c;
                    //ordertoSend.Totalunits=o.Orig_Ord_Lin_Count__c;
                    //ordertoSend.OrderMethod= o.SAP_Order_Type__c;

                      
                       if(ISBN !=null && ISBN !=''){
                            System.debug('Inside if ISBN');
                               System.debug('o.OrderItems'+o.OrderItems);
                               List<OrderItem> Oi = new List<OrderItem>();
                               Oi.addAll(o.OrderItems);
                            System.debug('Oi is'+Oi);
                            for (OrderItem item:Oi){
                                System.debug('ISBN is'+item.Product2.ISBN10__c);
                                
                                
                                 if(item.Product2.ISBN13__c !=null){
                                       if(IsbnValues.contains(item.Product2.ISBN13__c)){
                                          ordertoSend.siopOrder = true; 
                                       } 
                                     if(item.Product2.ISBN13__c == ISBN){
                                         ISBNMatch = true;
                                     }
                                     	
                                     //break;
                                 }else if(item.Product2.ProductCode !=null){
                                        if(IsbnValues.contains(item.Product2.ProductCode)){
                                          ordertoSend.siopOrder = true; 
                                       }
                                     if(item.Product2.ProductCode == ISBN){
                                         ISBNMatch = true;
                                     }
									 	
                                     //break;
                                 }else{
                                     if(item.Product2.ISBN10__c !=null){
                                        if(IsbnValues.contains(item.Product2.ISBN10__c)){
                                         ordertoSend.siopOrder = true; 
                                       } 
                                         
                                     if(item.Product2.ISBN10__c == ISBN){
                                         ISBNMatch = true;
                                     } 
                                         
                                     //break;
                                 	}
                                     
                                     
                               }
								
                                if(ISBNMatch == true && ordertoSend.siopOrder == true){
                                    break;
                                }                                
                                

                            }
                           
                            if(SearchValue==scc_constantHelper.PO_NUMBER || SearchValue==scc_constantHelper.CONTAINING_ISBN || SearchValue==scc_constantHelper.CUSTOMER_ACCOUNT || searchValue == scc_constantHelper.OUR_SHIP_TO_LOCATIONS_ONLY || searchValue == scc_constantHelper.ALL_SHIP_TO_LOCATIONS ||SearchValue==scc_constantHelper.ORDER_NUMBER ){
                                  if(String.isNotBlank(o.Combine_PONumber__c) ? true : false){
                                      if(PO !=null && PO !=''){
                                           if(o.Combine_PONumber__c.contains(PO) || o.Account_PO_Number__c==PO || o.PoNumber__c==PO){
                                               		system.debug('inside match1');
                                               if(ISBNMatch == true){
                                                 getCriteriaOrderDataToSend.add(ordertoSend);  
                                               }
                                           }                                          
                                      }else{
                                               if(ISBNMatch == true){
                                               		system.debug('inside match2');
                                                   getCriteriaOrderDataToSend.add(ordertoSend);
                                               }
                                      }

                                   }else{
                                      if(PO !=null && PO !=''){
                                           if(o.Account_PO_Number__c==PO || o.PoNumber__c==PO){
                                               		system.debug('inside match3');
                                               if(ISBNMatch == true){
                                                   getCriteriaOrderDataToSend.add(ordertoSend);
                                               }
                                           }                                          
                                      }else{
                                               if(ISBNMatch == true){
                                               		system.debug('inside match4');
                                                   getCriteriaOrderDataToSend.add(ordertoSend);
                                               }
                                      }
                                    }
   
                             }else{
                                      getCriteriaOrderDataToSend.add(ordertoSend);   
                             }
                                        
                                
                       }else{
                           System.debug('Inside if not ISBN');
                           System.debug('o.OrderItems'+o.OrderItems);
                               List<OrderItem> Oi = new List<OrderItem>();
                               Oi.addAll(o.OrderItems);
                            System.debug('Oi is'+Oi);
                            
                            for (OrderItem item:Oi){
                                System.debug('ISBN is'+item.Product2.ISBN10__c);
                                //if(item.Product2.ISBN10__c=='0000121500'||item.Product2.ISBN13__c=='0000121500' || item.Product2.ProductCode=='0000121500'|| item.Product2.ISBN13__c=='0000125052' || item.Product2.ISBN10__c=='0000125052'){
                                //if(!siopIsbnList.isEmpty()){
                                    //for(scc_siopIsbnNumbers__mdt isbnItem:siopIsbnList){
                                        //if(item.Product2.ISBN10__c == isbnItem.ISBN_number__c){	
                                            //ordertoSend.siopOrder = true; 
                                            //break;
                                        //}
                                    //}                                
                                //}
                                 if(item.Product2.ISBN13__c !=null){
                                       if(IsbnValues.contains(item.Product2.ISBN13__c)){
                                        ordertoSend.siopOrder = true; 
                                          //break;
                                       }  
                                 }else if(item.Product2.ProductCode !=null){
                                        if(IsbnValues.contains(item.Product2.ProductCode)){
                                        ordertoSend.siopOrder = true; 
                                          //break;
                                       } 
                                 }else{
                                     if(item.Product2.ISBN10__c !=null){
                                        if(IsbnValues.contains(item.Product2.ISBN10__c)){
                                        ordertoSend.siopOrder = true; 
                                          //break;
                                       }   
                                     }
                                     
                               }							
    
                            }
                                   //getCriteriaOrderDataToSend.add(ordertoSend); 
                                    if(SearchValue==scc_constantHelper.PO_NUMBER || SearchValue==scc_constantHelper.CONTAINING_ISBN || SearchValue==scc_constantHelper.CUSTOMER_ACCOUNT){
                                        if(String.isNotBlank(o.Combine_PONumber__c) ? true : false){
                                           if(o.Combine_PONumber__c.contains(PO) || o.Account_PO_Number__c==PO || o.PoNumber__c==PO){getCriteriaOrderDataToSend.add(ordertoSend);}
                                        }else{
                                           if(o.Account_PO_Number__c==PO || o.PoNumber__c==PO){getCriteriaOrderDataToSend.add(ordertoSend);}
                                        }
                                    }else{
                                      getCriteriaOrderDataToSend.add(ordertoSend);   
                                    }                                   
                       }
                        
                    //}
                    
                    
               }
        
            }catch(Exception e){
                System.debug('Error--'+e.getMessage());
                System.debug('Error--'+e.getCause());
            }
        
          return JSON.serialize(getCriteriaOrderDataToSend);
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
            while (paddedValue.length() < length) {
                paddedValue = '0' + paddedValue;
            }
            return paddedValue;
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
    
    
    @AuraEnabled
    public static String getStatesOptions(){
        List<SCC_StateInfo__c> getStatesOptionsData = [SELECT Name,State_Code__c FROM SCC_StateInfo__c ORDER BY Name ASC];        
        List<geStatesOptionsWrapper> geStatesOptionsWrap = new List<geStatesOptionsWrapper>();       
        for(Integer i=0;i<getStatesOptionsData.size();i++){
            geStatesOptionsWrap.add(new geStatesOptionsWrapper(getStatesOptionsData[i].Name,getStatesOptionsData[i].State_Code__c)); 
        }       
        return JSON.serialize(geStatesOptionsWrap); 
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

    public getOrderStatusDataWrapper(String OrderNumber, String Status, String PoNumber, String SAP_Document_Number, 
                                     String EffectiveDate, String ShipToName, String BillingName, String Account_PO_Number) {
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
            //@AuraEnabled public Date OrderDate;
            @AuraEnabled public String OrderDate;
            @AuraEnabled public Boolean OurShipTo;
            @AuraEnabled public Boolean AllShipTo;
            @AuraEnabled public Boolean siopOrder;
            @AuraEnabled public Boolean workTextPO;
        }
    }