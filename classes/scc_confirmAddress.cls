public without sharing class scc_confirmAddress {  
    
    /**
* @description Retrieves the AllowDropShip_Enabled__c flag value for the current user
* @return Boolean Returns true if drop shipping is enabled for the user, false otherwise
* @throws AuraHandledException if there's an error accessing user data
*/
    @AuraEnabled(cacheable=true)
    public static Boolean getAllowDropShip(){
        try {
            Id userId = UserInfo.getUserId(); 
            User userdata = [SELECT Id, AllowDropShip_Enabled__c
                             FROM User 
                             WHERE Id = :userId];
            System.debug('Checking allow dropship: ' + userdata.AllowDropShip_Enabled__c);
            return userdata.AllowDropShip_Enabled__c;
        } catch (Exception e) {
            System.debug(LoggingLevel.ERROR, 'Error in getAllowDropShip: ' + e.getMessage());
            throw new AuraHandledException('Unable to retrieve drop ship settings: ' + e.getMessage());
        }          
    }
    
    /********************************************************************** 
* @Method Name  : getCurrentUserBillingAddress
* @Description  : Method to fetch current user billing address from both Account 
*                and Account_Addresses__c objects
* @Param        : guestAccountId - Account Id for guest users
* @Return       : List<addressWrapper> - List of billing addresses
* @Throws       : AuraHandledException if there's an error retrieving addresses
***********************************************************************/
    @AuraEnabled(cacheable=true)
    public static List<addressWrapper> getCurrentUserBillingAddress(String guestAccountId){
        try {
            List<user> usr= new List<User>();
            List<addressWrapper> billAddress= new List<addressWrapper>();
            String billing='Billing';
            String shipping='shipping';
            Id acId;
            if(guestAccountId != ''){
                acId =  guestAccountId;
            }else{
                Id userId = UserInfo.getUserId(); 
                User accid=[SELECT AccountId,Id FROM User WHERE Id =:userId Limit 1]; 
                acId=accid.AccountId;
            }
            List<Account> accaddr= new List<Account>();
            accaddr=[select Id,Name,BillingCity,BillingPostalCode,BillingState,BillingStreet,BillingCountry,SAP_Account_Id__c,SAP_Account_Number__c,ShippingCity,ShippingCountry,ShippingPostalCode,ShippingState,ShippingStreet
                     From Account 
                     where Id =:acId ];
            
            for (Account acc : accaddr) {
                addressWrapper wrapper = new addressWrapper();
                wrapper.AccountId=acc.Id;
                wrapper.AccId=acc.Id;
                wrapper.AccountName=acc.Name;
                wrapper.BillToNumber=acc.SAP_Account_Number__c;
                wrapper.BillinStreet=acc.BillingStreet;
                wrapper.BillingCity=acc.BillingCity;
                wrapper.State=acc.BillingState;
                wrapper.ZipCode=acc.BillingPostalCode;
                wrapper.BillingCountry=acc.BillingCountry;
                billAddress.add(wrapper);
            }        
            
            
            List<Account_Addresses__c> accountaddr= new List<Account_Addresses__c>();
            
            accountaddr =[SELECT Id,Account__c,ERP_Account_Name__c,Address_1__c,Address_2__c,Address_3__c,Address_4__c,Address_Type__c,City__c,Country__c,ERP_Account_Number__c,State__c,Zip_Code__c 
                          FROM Account_Addresses__c 
                          where Account__c= :acId  AND Address_Type__c=:billing ];
            
            for (Account_Addresses__c acc : accountaddr) {
                addressWrapper wrapper1 = new addressWrapper();
                wrapper1.AccountId = acc.Account__c;
                wrapper1.AccId = acc.Id;
                wrapper1.AccountName = acc.ERP_Account_Name__c;
                wrapper1.BillToNumber = acc.ERP_Account_Number__c;
                wrapper1.BillinStreet = (acc.Address_1__c != null ? acc.Address_1__c+' ' : '')+(acc.Address_2__c != null ? acc.Address_2__c+' ' : ' ')+(acc.Address_3__c != null ? acc.Address_3__c+' ' : ' ')+(acc.Address_4__c != null ? acc.Address_4__c : '');
                wrapper1.BillingCity = (acc.City__c != null ? acc.City__c : '');
                wrapper1.State = (acc.State__c != null ? acc.State__c : '');
                wrapper1.ZipCode = (acc.Zip_Code__c != null ? acc.Zip_Code__c : '');
                wrapper1.BillingCountry = (acc.Country__c != null ? acc.Country__c : '');
                billAddress.add(wrapper1);
            }
            return billAddress;
        } catch(Exception e) {
            System.debug(LoggingLevel.ERROR, 'Error in getCurrentUserBillingAddress: ' + e.getMessage());
            throw new AuraHandledException('Unable to retrieve billing addresses: ' + e.getMessage());
        }
    }
    /**************************************************************************** 
* @Method Name  : getCurrentUserShippingAddress
* @Description  : Method to fetch current user shipping address including affiliated 
*                and child accounts shipping addresses
* @Param        : guestAccountId - Account Id for guest users
* @Return       : List<addressWrapper> - List of shipping addresses
* @Throws       : AuraHandledException if there's an error retrieving addresses
*****************************************************************************/     
    @AuraEnabled(cacheable=true)
    public static List<addressWrapper> getCurrentUserShippingAddress(String guestAccountId){ 
        try {
            List<user> usr= new List<User>();
            List<addressWrapper> shipAddress= new List<addressWrapper>();
            String billing='Billing';
            String shipping='shipping';
            Id acId;
            if(guestAccountId != ''){
                acId = guestAccountId;
            }else{
                Id userId = UserInfo.getUserId(); 
                User accid=[SELECT AccountId,Id FROM User WHERE Id =:userId Limit 1]; 
                acId=accid.AccountId;  
            }
            Set <Id> accountchildIds= new Set <Id>();
            accountchildIds.add(acId);
            for(Affiliation__c affChildaccount: [Select Child_Account__c from Affiliation__c where Parent_Account__c=:acId ]){
                accountchildIds.add(affChildaccount.Child_Account__c);
            }
            
            //Fetching Child Accounts
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
                Wrapper.AccShipId=acc.Id+ 'A';
                wrapper.schoolDistrict = scc_constantHelper.schoolDistrict.contains(acc.Type);
                wrapper.ShipToNumber=acc.SAP_Account_Id__c;
                wrapper.ShipStreet=acc.ShippingStreet;
                wrapper.ShippingCity=acc.ShippingCity;
                wrapper.Provionce=acc.ShippingState;
                wrapper.PostalCode=acc.ShippingPostalCode;
                wrapper.ShippingCountry=acc.ShippingCountry;
                shipAddress.add(wrapper);
            }
            
            List<Account_Addresses__c> accountaddr= new List<Account_Addresses__c>();
            
            accountaddr =[SELECT Id,Account__c,Account__r.Type,ERP_Account_Name__c,Address_1__c,Address_2__c,Address_3__c,Address_4__c,Address_Type__c,City__c,Country__c,ERP_Account_Number__c,State__c,Zip_Code__c
                          FROM Account_Addresses__c 
                          where Account__c= :accountchildIds  AND Address_Type__c=:shipping ];
            if(!accountaddr.isEmpty()){
                for (Account_Addresses__c acc : accountaddr) {
                    addressWrapper wrapper1 = new addressWrapper();
                    wrapper1.SAccountName=acc.ERP_Account_Name__c;
                    wrapper1.ShipToNumber=acc.ERP_Account_Number__c;
                    wrapper1.schoolDistrict = scc_constantHelper.schoolDistrict.contains(acc.Account__r.Type);
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
        } catch(Exception e) {
            System.debug(LoggingLevel.ERROR, 'Error in getCurrentUserShippingAddress: ' + e.getMessage());
            throw new AuraHandledException('Unable to retrieve shipping addresses: ' + e.getMessage());
        }
    }
    
    /**************************************************************************** 
* @Method Name  : getCurrentUserAllShippingAddress
* @Description  : Method to fetch all shipping addresses including affiliated 
*                and child accounts
* @Param        : None
* @Return       : List<addressWrapper> - List of all shipping addresses
* @Throws       : AuraHandledException if there's an error retrieving addresses
*****************************************************************************/     
    @AuraEnabled(cacheable=true)
    public static List<addressWrapper> getCurrentUserAllShippingAddress(){
        try {
            List<user> usr= new List<User>();
            List<addressWrapper> billAddress= new List<addressWrapper>();
            String billing='Billing';
            String shipping='shipping';
            Id userId = UserInfo.getUserId(); 
            User accid=[SELECT AccountId,Id FROM User WHERE Id =:userId Limit 1]; 
            Id acId=accid.AccountId;
            Set <Id> accountchildIds= new Set <Id>();
            accountchildIds.add(acId);
            //Fetching Affiliation Child accounts
            for(Affiliation__c affChildaccount: [Select Child_Account__c from Affiliation__c where Parent_Account__c=:acId ]){
                accountchildIds.add(affChildaccount.Child_Account__c);
            }
            
            //Fetching Child Accounts
            for(Account Childaccount: [Select Id from Account where Parentid=:acId ]){
                accountchildIds.add(Childaccount.Id);
            }
            return new List<addressWrapper>();
        } catch(Exception e) {
            System.debug(LoggingLevel.ERROR, 'Error in getCurrentUserAllShippingAddress: ' + e.getMessage());
            throw new AuraHandledException('Unable to retrieve all shipping addresses: ' + e.getMessage());
        }
    }
    
    /**************************************************************************** 
* @Method Name  : getUserBillingAddress
* @Description  : Method to fetch current user's billing addresses from both Account 
*                and Account_Addresses__c objects
* @Return       : List<addressWrapper> - List of billing addresses
* @Throws       : AuraHandledException if there's an error retrieving addresses
*****************************************************************************/
    @AuraEnabled(cacheable=true)
    public static List<addressWrapper> getUserBillingAddress(){
        try {
            List<user> usr= new List<User>();
            List<addressWrapper> billAddress= new List<addressWrapper>();
            String billing='Billing';
            Id userId = UserInfo.getUserId(); 
            User accid=[SELECT AccountId,Id FROM User WHERE Id =:userId Limit 1]; 
            Id acId=accid.AccountId;
            
            List<Account> accaddr= new List<Account>();
            accaddr=[select Id,Name,BillingCity,BillingPostalCode,BillingState,BillingStreet,BillingCountry,SAP_Account_Id__c,SAP_Account_Number__c,ShippingCity,ShippingCountry,ShippingPostalCode,ShippingState,ShippingStreet
                     From Account 
                     where Id =:acId ];
            
            for (Account acc : accaddr) {
                addressWrapper wrapper = new addressWrapper();      
                wrapper.AccountId=acc.Id;
                wrapper.AccId=acc.Id+ 'A';
                wrapper.AccountName=acc.Name;
                wrapper.BillToNumber=acc.SAP_Account_Number__c;
                wrapper.BillinStreet=acc.BillingStreet;
                wrapper.BillingCity=acc.BillingCity;
                wrapper.State=acc.BillingState;
                wrapper.ZipCode=acc.BillingPostalCode;
                wrapper.BillingCountry=acc.BillingCountry;
                billAddress.add(wrapper);
            }   
            
            List<Account_Addresses__c> accountaddr= new List<Account_Addresses__c>();
            
            accountaddr =[SELECT Id,Account__c,ERP_Account_Name__c,Address_1__c,Address_2__c,Address_3__c,Address_4__c,Address_Type__c,City__c,Country__c,ERP_Account_Number__c,State__c,Zip_Code__c 
                          FROM Account_Addresses__c 
                          where Account__c= :acId  AND Address_Type__c=:billing ];
            
            for (Account_Addresses__c acc : accountaddr) {
                addressWrapper wrapper1 = new addressWrapper();
                wrapper1.AccountId=acc.Id;
                wrapper1.AccId=acc.Id;
                wrapper1.AccountName=acc.ERP_Account_Name__c;
                wrapper1.BillToNumber=acc.ERP_Account_Number__c;
                wrapper1.BillinStreet=(acc.Address_1__c != null ? acc.Address_1__c+' ' : '')+(acc.Address_2__c != null ? acc.Address_2__c+' ' : ' ')+(acc.Address_3__c != null ? acc.Address_3__c+' ' : ' ')+(acc.Address_4__c != null ? acc.Address_4__c : '');
                wrapper1.BillingCity=(acc.City__c != null ? acc.City__c : '');
                wrapper1.State=(acc.State__c != null ? acc.State__c : '');
                wrapper1.ZipCode=(acc.Zip_Code__c != null ? acc.Zip_Code__c : '');
                wrapper1.BillingCountry=(acc.Country__c != null ? acc.Country__c : '');
                billAddress.add(wrapper1);
            }
            return billAddress;
        } catch(Exception e) {
            System.debug(LoggingLevel.ERROR, 'Error in getUserBillingAddress: ' + e.getMessage());
            throw new AuraHandledException('Unable to retrieve billing addresses: ' + e.getMessage());
        }
    }
    
    /**************************************************************************** 
* @Method Name  : getUserShippingAddress
* @Description  : Method to fetch current user's shipping addresses including 
*                affiliated and child accounts
* @Return       : List<addressWrapper> - List of shipping addresses
* @Throws       : AuraHandledException if there's an error retrieving addresses
*****************************************************************************/
    @AuraEnabled(cacheable=true)
    public static List<addressWrapper> getUserShippingAddress(){ 
        try {
            List<user> usr= new List<User>();
            List<addressWrapper> shipAddress= new List<addressWrapper>();
            String shipping='shipping';
            Id userId = UserInfo.getUserId();     
            User accid=[SELECT AccountId,Id FROM User WHERE Id = :userId Limit 1];   
            Id acId=accid.AccountId;
            Set <Id> accountchildIds= new Set <Id>();
            accountchildIds.add(acId);
            
            //Fatching Affiliation Child accounts
            for(Affiliation__c affChildaccount: [Select Child_Account__c from Affiliation__c where Parent_Account__c=:acId ]){
                accountchildIds.add(affChildaccount.Child_Account__c);
            }
            
            //Fetching Child Accounts
            for(Account Childaccount: [Select Id from Account where Parentid=:acId ]){
                accountchildIds.add(Childaccount.Id);
            }     
            
            List<Account> accaddr= new List<Account>();
            accaddr=[select Id,Name,BillingCity,BillingPostalCode,BillingState,BillingStreet,BillingCountry,SAP_Account_Id__c,SAP_Account_Number__c,ShippingCity,ShippingCountry,ShippingPostalCode,ShippingState,ShippingStreet
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
                    wrapper1.ShipStreet=(acc.Address_1__c != null ? acc.Address_1__c+' ' : '')+(acc.Address_2__c != null ? acc.Address_2__c+' ' : ' ')+(acc.Address_3__c != null ? acc.Address_3__c+' ' : ' ')+(acc.Address_4__c != null ? acc.Address_4__c : '') ;
                    Wrapper1.AccShipId=acc.Id;
                    wrapper1.ShippingCity=(acc.City__c != null ? acc.City__c : '');
                    wrapper1.Provionce=(acc.State__c != null ? acc.State__c : '');
                    wrapper1.PostalCode=(acc.Zip_Code__c != null ? acc.Zip_Code__c : '');
                    wrapper1.ShippingCountry=(acc.Country__c != null ? acc.Country__c : '');
                    shipAddress.add(wrapper1);
                }
            }
            return shipAddress;
        } catch(Exception e) {
            System.debug(LoggingLevel.ERROR, 'Error in getUserShippingAddress: ' + e.getMessage());
            throw new AuraHandledException('Unable to retrieve shipping addresses: ' + e.getMessage());
        }
    }
    
    
    /**************************************************************************** 
* @Method Name  : guestCartDetails
* @Description  : Method to fetch guest user's cart details
* @Param        : guestCartId - Id of the guest user's cart
* @Return       : WebCart - Cart details including total product count
* @Throws       : AuraHandledException if there's an error retrieving cart details
*****************************************************************************/
    @AuraEnabled
    public static WebCart guestCartDetails(String guestCartId) {
        try {
            WebCart activeCart;
            if(!String.isEmpty(guestCartId)){
                activeCart = [SELECT Id, TotalProductCount 
                              FROM Webcart 
                              WHERE Id =: guestCartId 
                              LIMIT 1];
                system.debug('**UserInfo'+UserInfo.getUserId());
            }
            return activeCart;
        } catch (Exception e) {
            System.debug(LoggingLevel.ERROR, 'Error in guestCartDetails: ' + e.getMessage());
            throw new AuraHandledException('Unable to retrieve cart details: ' + e.getMessage());
        }
    }
    
    /**************************************************************************** 
* @Method Name  : IsEusageOnly
* @Description  : Method to check if current user is E-usage only
* @Return       : Boolean - Returns true if user is E-usage only, false otherwise
* @Throws       : AuraHandledException if there's an error retrieving user data
*****************************************************************************/
    @AuraEnabled(cacheable=true)
    public static Boolean IsEusageOnly(){
        try {
            Id userId = UserInfo.getUserId(); 
            User userdata = [SELECT Id, AllowDropShip_Enabled__c, IsEusageOnly__c
                             FROM User 
                             WHERE Id =:userId];
            system.debug('checking IsEusageOnly'+userdata.IsEusageOnly__c);
            return userdata.IsEusageOnly__c;
        } catch(Exception e) {
            System.debug(LoggingLevel.ERROR, 'Error in IsEusageOnly: ' + e.getMessage());
            throw new AuraHandledException('Unable to check E-usage status: ' + e.getMessage());
        }
    }       
    /******************************************************************* 
Class Name  :  addressWrapper
Description :  Inner class to wrap address fields and return data
Input       :   N/A
Return type :   N/A
*********************************************************************/
    
    public class addressWrapper{
        
        @AuraEnabled public Id AccountId;
        @AuraEnabled public String AccId;
        @AuraEnabled public String AccountName;
        @AuraEnabled public String BillToNumber;
        @AuraEnabled public String BillinStreet;
        @AuraEnabled public String BillingCity;
        @AuraEnabled public String State;
        @AuraEnabled public String ZipCode;
        @AuraEnabled public String BillingCountry;
        
        @AuraEnabled public String AccShipId;        
        @AuraEnabled public String SAccountName;
        @AuraEnabled public String ShipToNumber;
        @AuraEnabled public String ShipStreet;
        @AuraEnabled public String ShippingCity;
        @AuraEnabled public String Provionce;
        @AuraEnabled public String PostalCode;
        @AuraEnabled public String ShippingCountry;
        @AuraEnabled public Boolean schoolDistrict;
        
    }
}