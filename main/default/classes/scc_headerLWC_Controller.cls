/*
Apex Class:scc_headerLWC_Controller
Author: CTS (Vaibhav Saptal)
Created Date: 23/03/2024
Reason: get user information whenever needed in components 
Modified Date: 16/10/2024
*/
public without sharing class scc_headerLWC_Controller {
    /**
*  Description: This method queries the user information for loggedin, guest and Internal users      
*  @name: getUserInformation
*  @param:NA
*  @return: String of user information
*  @throws exception- 
*/
    public static string userinfo1;
    @AuraEnabled(cacheable=true)
    public static String getUserInformation() {
        try{
            String BillingCountry;
            List<User> usr = [select ID,ContactId, Alias, FirstName, LastName, Email, IsEmployee__c ,Contact.Account.AccountNumber,Contact.Account.Type,Contact.AccountID,contact.name,contact.Account.name,contact.Account.Billing_County__c,contact.Account.BillingCountry,Contact.Account.BillingState, Contact.Account.ShippingState,contact.Account.BillingPostalCode, profile.name from user where id =: userInfo.getUserID()]; 
            
            List<UserInfoWrapper> userInfoList = new  List<UserInfoWrapper>();
            Boolean isGuest = false;
            String profile=usr[0].profile.name;
            String ContactId=usr[0].ContactId;
            Boolean isinternal = false;
            String fullName = usr[0].FirstName + ' ' + usr[0].LastName;
            if(usr[0].IsEmployee__c == true){
                isInternal=true;
            }
            if(usr[0].profile.name == scc_constantHelper.MY_SAVVAS_ORDERS_PROFILE){
                isGuest=true;
            }
            if(usr[0].contact.Account.BillingCountry != null &&  usr[0].contact.Account.BillingCountry != ''){
                BillingCountry = usr[0].contact.Account.BillingCountry;
            }else{
                BillingCountry = usr[0].contact.Account.Billing_County__c;
            }
            
            if((usr[0].contact.Account.Type == scc_constantHelper.INTERNATIONAL_SCHOOL) || (usr[0].contact.Account.Type == scc_constantHelper.INTERNATIONAL_DISTRIBUTOR)){
                 BillingCountry = scc_constantHelper.COUNTRY_UNITED_STATES;
            }
            userInfoList.add(new UserInfoWrapper(
                usr[0].contact.name,
                fullName,
                ContactId,
                usr[0].contact.Account.name,
                usr[0].contact.AccountID,
                BillingCountry,
                isGuest,
                usr[0].profile.name,
                isInternal,
                usr[0].contact.Account.AccountNumber,
                usr[0].contact.Account.Type,
                usr[0].contact.Account.BillingPostalCode,
                usr[0].Email,
                usr[0].Alias,
                usr[0].contact.Account.BillingState,  
                usr[0].contact.Account.ShippingState 
                ));
            
            return JSON.serialize(userInfoList);
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
*  Description: This method queries the cart data to validate it for registered user punch out     
*  @name: validateCartsData
*  @param:cart ID, account ID, Token
*  @return: String of cart data
*  @throws exception- 
*/    
    @AuraEnabled(cacheable=false)
    public static String validateCartsData(Id accountID, ID cartID,String Token){
        try{
            List<User> usr = [select ID,Contact.AccountID,contact.name,contact.Account.name,contact.Account.Billing_County__c,profile.name from user where id =:userInfo.getUserID()];                               
            Webcart wc = [select id,AccountId,Account.Name,Token__c,TotalProductCount from Webcart where id=:cartID AND AccountId=:accountID AND Token__c=:Token];
            system.debug('wc'+wc);
            wc.AccountID = usr[0].contact.AccountID;
            update wc; 
            cartDataWrapper cartData = new cartDataWrapper();
            cartData.accountId = usr[0].contact.AccountID;
            cartData.cartQuantity = wc.TotalProductCount;
            return JSON.serialize(cartData);
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
*  Description: This method sets enable console logs true or false     
*  @name: getEnableConsoleLogsTrue
*  @param:NA
*  @return: Boolean value to enable logs
*  @throws exception- 
*/    
    @AuraEnabled(cacheable=true)
    public static Boolean getEnableConsoleLogsTrue(){
			Boolean enableLogsValue = Boolean.ValueOf(System.Label.scc_Enable_Console_Log);
            return enableLogsValue; 
    }    
        
    public class UserInfoWrapper{
        public String userName;
        public String fullName;
        public String ContactId;
        public String accountName; 
        public String accountId;
        public String billing_County;
        public String profile ;
        Boolean isGuest;
        public Boolean isInternal;
        public String AccountNumber;
        public String accountType;
        public String billingPostalCode;
        public String Email;
        public String Alias;
        public String billing_State;
        public String shipping_State; 
        UserInfoWrapper(String userName,String fullName, String ContactId, String accountName,String accountId,String billing_County,Boolean isGuest,string profile,Boolean isInternal,String AccountNumber,String accountType, String billingPostalCode, String Email, String Alias, String billing_State, String shipping_State){
            this.userName =userName;
            this.fullName =fullName;
            this.accountName=accountName;
            this.accountId=accountId;
            this.billing_County = billing_County;
            this.isGuest = isGuest;
            this.profile=profile;
            this.isInternal=isInternal;
            this.AccountNumber = AccountNumber;
            this.accountType = accountType;
            this.billingPostalCode = billingPostalCode;
            this.Email = Email;
            this.Alias = Alias;
            this.billing_State = billing_State;       
            this.shipping_State = shipping_State;     

        }
    }
    
    public class cartDataWrapper{
        @AuraEnabled public String accountId;
        @AuraEnabled public Decimal cartQuantity;   
    }
    
    /**
*  Description: This method queries create case categories options from custom metadata   
*  @name: getCreateCaseCatgories
*  @param:No parameters
*  @return: String values of create case categories options
*  @throws exception- 
*/
    @AuraEnabled(cacheable=true)
    public static String getCreateCaseCategories(){
        try{
            List<scc_CreateSupportCaseCategory__mdt> scc_orderStatusOptionsData = [SELECT MasterLabel FROM scc_CreateSupportCaseCategory__mdt];            
            List<getSupportCaseCatListWrapper> getSupportCaseCatListWrap = new List<getSupportCaseCatListWrapper>();   
            for(Integer i=0;i<scc_orderStatusOptionsData.size();i++){
            getSupportCaseCatListWrap.add(new getSupportCaseCatListWrapper(scc_orderStatusOptionsData[i].MasterLabel)); 
        	} 
            return JSON.serialize(getSupportCaseCatListWrap);
        }catch(Exception e){
            System.debug(scc_constantHelper.EXCEPTION_TYPE_CAUGHT+ e.getTypeName());    
            System.debug(scc_constantHelper.MESSAGE+ e.getMessage());    
            System.debug(scc_constantHelper.CAUSE+ e.getCause());    // returns null
            System.debug(scc_constantHelper.LINE_NUMBER + e.getLineNumber());    
            System.debug(scc_constantHelper.STACK_RACE+ e.getStackTraceString());
            throw new AuraHandledException('Failed to get order status values :'+e.getMessage()+e.getCause());
        }
    }
    
    public class getSupportCaseCatListWrapper{
            public String label; 
        	public String value; 
           getSupportCaseCatListWrapper(String label){
               this.label = label;   
               this.value = label;      
           }    
       }
}