/**************************************************************************************** 
* @Class Name  - scc_FetchHeldCart_Controller
* @description - Class to fetch held card information for current user
* @Created By  - CTS-Sameer Pujari
* @Created On - 2024-05-24 
* ***************************************************************************************/
public without sharing class scc_FetchHeldCart_Controller {
    @TestVisible private static Boolean forcedExcption = false; 
    
    /**
*  Description: This method will fetch 4 recent modified held cart records     
*  @name: getHeldCartRecords
*  @param: NA
*  @return:LIST
*/
    @AuraEnabled(cacheable=false)
    public static List<Webcart> getHeldCartRecords(){
        try{
            List<WebCart> heldCartList = [SELECT Id, Name, User_Cart_Name__c, StdCartNameOrCustomCartName__c, CreatedDate, LastModifiedDate, Shipto_name__c, TotalProductLineItemCount, AccountId, OwnerId, Master_User__c FROM Webcart
                                          WHERE AccountId IN (SELECT AccountId FROM User WHERE Id =: userInfo.getUserID()) 
                                          AND Status='Active' 
                                          AND Master_User__c = ''
                                          AND IsSecondary= true
                                          ORDER BY LastModifiedDate DESC
                                          LIMIT 4
                                         ];
            return heldCartList;   
        }catch(Exception e){
            System.debug('Exception type caught: ' + e.getTypeName());    
            System.debug('Message: ' + e.getMessage());    
            System.debug('Cause: ' + e.getCause());
            System.debug('Line number: ' + e.getLineNumber());    
            System.debug('Stack trace: ' + e.getStackTraceString());
            throw new AuraHandledException('Failed to get 4 held cart records:'+e.getMessage()+e.getCause());
        }                   
    }
    
    /**
*  Description: This method will all held cart records     
*  @name: getAllHeldCartRecords
*  @param: NA
*  @return:LIST
*/
    @AuraEnabled(cacheable=false)
    public static List<Webcart> getAllHeldCartRecords(){
        try{
            List<WebCart> heldCartList = [SELECT Id, Name, User_Cart_Name__c, StdCartNameOrCustomCartName__c, CreatedDate,  LastModifiedDate, Shipto_name__c, TotalProductLineItemCount, AccountId, OwnerId, Master_User__c FROM Webcart
                                          WHERE AccountId IN (SELECT AccountId FROM User WHERE Id =: userInfo.getUserID()) 
                                          AND Status='Active' 
                                          AND Master_User__c = ''
                                          AND IsSecondary= true
                                          ORDER BY LastModifiedDate DESC
                                         ];
            return heldCartList; 
        }catch(Exception e){
            System.debug('Exception type caught: ' + e.getTypeName());    
            System.debug('Message: ' + e.getMessage());    
            System.debug('Cause: ' + e.getCause());
            System.debug('Line number: ' + e.getLineNumber());    
            System.debug('Stack trace: ' + e.getStackTraceString());
            throw new AuraHandledException('Failed to get all held cart records:'+e.getMessage()+e.getCause());
        }
    }
    
    /**
*  Description: This method retrive all held cart records by cart name     
*  @name: getAllHeldCartRecordsByCartName
*  @param: NA
*  @return:LIST
*/
    @AuraEnabled(cacheable=false)
    public static List<Webcart> getAllHeldCartRecordsByCartName(String strCartName){
        String strKey = '%'+strCartName+'%'; 
        try{
            List<WebCart> heldCartList = [SELECT Id, Name, User_Cart_Name__c, StdCartNameOrCustomCartName__c, CreatedDate,  LastModifiedDate, Shipto_name__c, TotalProductLineItemCount, AccountId, OwnerId, Master_User__c FROM Webcart
                                          WHERE AccountId IN (SELECT AccountId FROM User WHERE Id =: userInfo.getUserID()) 
                                          AND Status='Active' 
                                          AND Master_User__c = ''
                                          AND IsSecondary= true
                                          AND StdCartNameOrCustomCartName__c Like: strKey
                                          ORDER BY LastModifiedDate DESC
                                         ];
            return heldCartList; 
        }catch(Exception e){
            System.debug('Exception type caught: ' + e.getTypeName());    
            System.debug('Message: ' + e.getMessage());    
            System.debug('Cause: ' + e.getCause());
            System.debug('Line number: ' + e.getLineNumber());    
            System.debug('Stack trace: ' + e.getStackTraceString());
            throw new AuraHandledException('Failed to get all held cart by cart name records:'+e.getMessage()+e.getCause());
        }  
    }
    
    /**
*  Description: This method delete held cart     
*  @name: deleteCartItem
*  @param: cartItemId
*  @return:Boolean
*/
    @AuraEnabled(cacheable=false)
    public static Boolean deleteCartItem(String cartItemId){
        Boolean isSuccess = false;
        try{
            List<Webcart> items = [SELECT Id FROM Webcart where Id=:cartItemId];
            if(!items.isEmpty()){
                delete items;
                isSuccess = true;
            }
            return isSuccess;
        }catch (Exception e) {
            System.debug('Exception type caught: ' + e.getTypeName());    
            System.debug('Message: ' + e.getMessage());    
            System.debug('Cause: ' + e.getCause());
            System.debug('Line number: ' + e.getLineNumber());    
            System.debug('Stack trace: ' + e.getStackTraceString());
            throw new AuraHandledException('Failed to delete held cart item:'+e.getMessage()+e.getCause());
        }        
    }
}