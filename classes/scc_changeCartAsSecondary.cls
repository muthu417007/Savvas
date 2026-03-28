/**************************************************************************************** 
* @Class Name  - scc_changeCartAsSecondary
* @description - Class to change active cart to held cart when user clicks logout
* @Created By  - CTS-Muthukumar
* @Created On - 2024-05-14
* ***************************************************************************************/ 

public without sharing  class scc_changeCartAsSecondary {
    public static String getWebStoreId(String storeName) {
        WebStore store = [SELECT Id FROM WebStore WHERE Name = :storeName LIMIT 1];
        return store.Id;
    }
    
    /********************************************************************** 
Method Name :  changeActiveCartAsSecondary
Description :  Method to change active cart to held cart
Input       :  Active AccountId
Return type :  NA
***********************************************************************/ 
    @AuraEnabled
    public static void changeActiveCartAsSecondary(Id activeAccountId ){   
        List<WebCart> webCartcartItemsupdate = new List<WebCart>();
        List < WebCart> webCartItems = new List <WebCart>();
        system.debug('activeAccountId>>>>'+ activeAccountId);
        String webStoreId = getWebStoreId(scc_constantHelper.STORE_NAME);
        Id userId=UserInfo.getUserId(); 
        system.debug('webStoreId>>>'+ webStoreId);
        
        webCartItems=[Select AccountId from WebCart
                      where AccountId=:activeAccountId AND IsSecondary= :scc_constantHelper.FALSE_VALUE AND WebStoreId= :webStoreId AND Status= :scc_constantHelper.STATUS_ACTIVE AND ( OwnerId = :userId
                                                                                                                                                                                       OR Master_User__c = :userId)];
        if(!webCartItems.isEmpty()){
            for (WebCart  webCartIn: webCartItems) {
                webCartIn.IsSecondary = true;
                webCartIn.Master_User__c= null;
                webCartcartItemsupdate.add(webCartIn);
            } 
            
            try {
                update webCartcartItemsupdate;
                system.debug('updated webCartcartItemsupdate>>>>'+webCartcartItemsupdate);
            }
            catch(DmlException e) {
                System.debug('The following exception has occurred: ' + e.getMessage());
                System.debug('Exception type caught: ' + e.getTypeName());    
                System.debug('Message: ' + e.getMessage());    
                System.debug('Cause: ' + e.getCause());    // returns null
                System.debug('Line number: ' + e.getLineNumber());    
                System.debug('Stack trace: ' + e.getStackTraceString());  
            } 
        }
        
    }
    
    @AuraEnabled
    public static void clearPromoCode(Id activeCartId ){  
        try{
            system.debug('cartId'+activeCartId);
            Webcart wc = [select id,Coupon__c, Coupon_Discount__c from WebCart where Id =:activeCartId];
            if(wc != null){
                wc.Coupon__c = '';
                wc.Coupon_Discount__c= null ;
                update wc;
            }
        }
        catch(DmlException e) {
            System.debug('The following exception has occurred: ' + e.getMessage());
            System.debug('Exception type caught: ' + e.getTypeName());    
            System.debug('Message: ' + e.getMessage());    
            System.debug('Cause: ' + e.getCause());    // returns null
            System.debug('Line number: ' + e.getLineNumber());    
            System.debug('Stack trace: ' + e.getStackTraceString());  
        } 
    }
    /*****************
Method Name :  changeHeldToActiveCart
Description :  Method to change held cart to active cart
Created By  - CTS-Varshaa
Input       :  AccountId
Return type :  NA
*******************/
    @AuraEnabled
    public static void changeHeldToActiveCart(Id cartId ){   
        List<WebCart> webCartActive = new List<WebCart>();
        Id currentUser = UserInfo.getUserId(); 
        List < WebCart> webCartItems = new List <WebCart>();
        system.debug('cartId>>>>'+ cartId);
        String webStoreId = getWebStoreId(scc_constantHelper.STORE_NAME);
        system.debug('webStoreId>>>'+ webStoreId);
        
        webCartItems=
            [
                SELECT 
                Id 
                FROM WebCart 
                WHERE 
                Id=:cartId 
                AND IsSecondary= :true 
                AND WebStoreId= :webStoreId 
                AND Status= :scc_constantHelper.STATUS_ACTIVE 
                AND Master_User__c =: null
            ];
        if(!webCartItems.isEmpty()){
            for (WebCart  webCart1: webCartItems) {
                webCart1.IsSecondary = false;
                webCart1.Master_User__c = currentUser;
                webCart1.OwnerId =  currentUser;
                webCartActive.add(webCart1);
            } 
            
            try {
                update webCartActive;
                System.debug('*******webcartActive***** ' + webCartActive);
            }
            catch(DmlException e) {
                System.debug('The following exception has occurred: ' + e.getMessage());
            } 
        }
        
    }
}