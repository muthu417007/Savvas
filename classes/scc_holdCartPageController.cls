/**************************************************************************************** 
* @Class Name  - scc_holdCartPageController
* @description - Class to change active cart to held cart when user clicks heldcart button
* @Created By  - CTS-Muthukumar
* @Created On - 2024-05-14
* ***************************************************************************************/ 
public class scc_holdCartPageController {
    /********************************************************************** 
Method Name :  updateToHeldCart
Description :  Method to change active cart to held cart
Input       :  ActiveCartId & CartName
Return type :  NA
***********************************************************************/ 
    @AuraEnabled
    public static void updateToHeldCart(Id activeCartId, String name ){  
        
        try { 
            WebCart  webCartItems=[Select Id,IsSecondary,Master_User__c,User_Cart_Name__c from WebCart where Id=:activeCartId AND IsSecondary= :scc_constantHelper.FALSE_VALUE];
            webCartItems.IsSecondary = true;
            webCartItems.Master_User__c= null;
            webCartItems.User_Cart_Name__c= name;
            update webCartItems;
            return;
        }
        catch(QueryException e) {
            System.debug('Exception type caught: ' + e.getTypeName());    
            System.debug('Message: ' + e.getMessage());    
            System.debug('Cause: ' + e.getCause());
            System.debug('Line number: ' + e.getLineNumber());    
            System.debug('Stack trace: ' + e.getStackTraceString());
        }         
    }
    
    @AuraEnabled
    public static void updateHeldCartName(Id activeCartId, String name ){  
        
        try { 
            WebCart  webCartItems=[Select Id,IsSecondary,Master_User__c,User_Cart_Name__c from WebCart where Id=:activeCartId];
            webCartItems.User_Cart_Name__c= name;
            webCartItems.Name= name;
            update webCartItems;
            return;
        }
        catch(QueryException e) {
            System.debug('Exception type caught: ' + e.getTypeName());    
            System.debug('Message: ' + e.getMessage());    
            System.debug('Cause: ' + e.getCause());
            System.debug('Line number: ' + e.getLineNumber());    
            System.debug('Stack trace: ' + e.getStackTraceString());
        } 
        
    }
}