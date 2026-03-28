/*
Apex Class:scc_ERPNotificationHandler
Author: CTS (MuthuKumar)
Created Date: 31/07/2024
Reason: Class used for guest punchout ERP Integration for Non-Internal Scenario
Modified Date: 16/04/2024
*/
public without sharing class scc_ERPNotificationHandler {
    /**
*  Description: This method update order data  
*  @name: updateOrder
*  @param: String, String, String, String
*  @return: NA
*/
    public static void updateOrder(String accountId, String orderId, String token, String poNumber){
        try{
            List<WebCart> cart = [SELECT Id, Token__c, Status FROM WebCart where Order_Id__c =: orderId AND Token__c=:token AND Order_Id__r.AccountId =: accountId LIMIT 1];
            if (!cart.isEmpty()) {
                List<Order> ord = [SELECT Id, Status, ActivatedDate, PoNumber__c FROM Order WHERE Id =: orderId LIMIT 1];
                if (!ord.isEmpty()) {
                    ord[0].PoNumber__c = poNumber;
                    update ord;
                    callOrderSimulate(cart[0].Id, orderId);
                }
            }
        }
        catch(Exception e){
            System.debug(scc_constantHelper.EXCEPTION_TYPE_CAUGHT+ e.getTypeName());    
            System.debug(scc_constantHelper.MESSAGE+ e.getMessage());    
            System.debug(scc_constantHelper.CAUSE+ e.getCause());    // returns null
            System.debug(scc_constantHelper.LINE_NUMBER + e.getLineNumber());    
            System.debug(scc_constantHelper.STACK_RACE+ e.getStackTraceString());
            throw new AuraHandledException('Failed to update order:'+e.getMessage()+e.getCause());
        }        
    }
    
    /**
*  Description: This future method used for order simulate call
*  @name: callOrderSimulate
*  @param: String, String
*  @return: NA
*/
    @future (callout=true)
    public static void callOrderSimulate(String cartId, String orderId){
        try{
            ensxtx_UTIL_Aura.Response response = ensxtx_CTRL_Cart.createSalesDocument(orderId, 'ensxtx_SR_enosixWebCartB2BAppSettings');
            String detail = JSON.serialize(response.data);
            Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(detail);        
            Boolean isSuccess = (Boolean) responseMap.get('IsSuccess');        
            if(isSuccess){
                updateCartAndOrder(cartId, orderId); 
                String sapDocNum = (String) responseMap.get('SalesDocument');            
                sendOrderStatusToERP(cartId,orderId,'',sapDocNum);
            }else{
                String detail1 = JSON.serialize(responseMap.get('TransactLogs'));
                List<Object> result = (List<Object>) JSON.deserializeUntyped(detail1);
                String errorCode = '';
                for(Object item : result){
                    Map<String,Object>  error = (Map<String,Object>) item;
                    String type = (String) error.get('ensxtx_MessageType__c');
                    String message = (String) error.get('ensxtx_Message__c');
                    if(type == 'ERROR' && message != 'Sales document  was not changed'){
                        errorCode = (String) error.get('ensxtx_SAP_Error_Code__c');
                    }                
                }            
                if(errorCode != ''){
                    sendOrderStatusToERP(cartId,orderId,errorCode,'');
                }
            } 
        }
        catch(Exception e){
            System.debug(scc_constantHelper.EXCEPTION_TYPE_CAUGHT+ e.getTypeName());    
            System.debug(scc_constantHelper.MESSAGE+ e.getMessage());    
            System.debug(scc_constantHelper.CAUSE+ e.getCause());    // returns null
            System.debug(scc_constantHelper.LINE_NUMBER + e.getLineNumber());    
            System.debug(scc_constantHelper.STACK_RACE+ e.getStackTraceString());
            throw new AuraHandledException('Failed during call order simulation:'+e.getMessage()+e.getCause());
        }        
    }
    
    /**
*  Description: This method used to send order status to ERP
*  @name: sendOrderStatusToERP
*  @param: String, String, String, String
*  @return: NA
*/
    public static void sendOrderStatusToERP(String cartId, String orderId, String errorCode, String SAPDocNum){
        if(errorCode != ''){
            Map<String,String> response = new Map<String,String>();
            String errorMsg = '';
            
            List<scc_Order_Submission_Errors__mdt> errorMessages = [SELECT scc_Error_Message__c, MasterLabel FROM scc_Order_Submission_Errors__mdt WHERE MasterLabel =: errorCode];
            
            if(!errorMessages.isEmpty()){
                errorMsg = errorMessages[0].scc_Error_Message__c;
                errorMsg = errorMsg.replace('Cart ID: 999999', 'Cart ID: ' + cartId);
            }else{
                errorMsg = Label.scc_Order_Submission_Error_Message;
                errorMsg = errorMsg.replace('Cart ID: 999999', 'Cart ID: ' + cartId);
                errorMsg = errorMsg.replace('error code', 'error code ' + errorCode);
            }
            
            if(errorMsg != ''){
                Send_Order_Status_to_ERP__e orderEvent = new Send_Order_Status_to_ERP__e(
                    Order_ID__c = orderId,
                    Error_Message__c = errorMsg
                );
                Database.SaveResult sr = EventBus.publish(orderEvent);
                if (!sr.isSuccess()) {
                    throw new AuraHandledException('Failed to send order status to ERP.');
                }
            }
        }
        if(SAPDocNum != ''){
            Send_Order_Status_to_ERP__e orderEvent = new Send_Order_Status_to_ERP__e(
                Order_ID__c = orderId,
                SAP_Document_Number__c = SAPDocNum
            );
            Database.SaveResult sr = EventBus.publish(orderEvent);
            if (!sr.isSuccess()) {
                throw new AuraHandledException('Failed to send order status to ERP.');
            } 
        }
    }
    
    /**
*  Description: This method used to update cart and order
*  @name: updateCartAndOrder
*  @param: String, String
*  @return: NA
*/    
    public static void updateCartAndOrder(String cartId, String orderId){
        try{
            List<WebCart> webCart = [select Id, Status from WebCart where Id=:cartId LIMIT 1];
            if(!webCart.isEmpty()){
                webCart[0].Status = 'Closed';
                update webCart;
            }
            List<Order> order = [select Id, Status, ActivatedDate, Order_Status_Code__c from Order where Id=:orderId LIMIT 1]; 
            if(!order.isEmpty()){
                order[0].Status = 'Activated';
                order[0].ActivatedDate = System.Today();
                order[0].Order_Status_Code__c = 'OPEN';
                update order;
            }
        }catch(Exception e){
            System.debug(scc_constantHelper.EXCEPTION_TYPE_CAUGHT+ e.getTypeName());    
            System.debug(scc_constantHelper.MESSAGE+ e.getMessage());    
            System.debug(scc_constantHelper.CAUSE+ e.getCause());    // returns null
            System.debug(scc_constantHelper.LINE_NUMBER + e.getLineNumber());    
            System.debug(scc_constantHelper.STACK_RACE+ e.getStackTraceString());
            throw new AuraHandledException('Failed to update cart and order:'+e.getMessage()+e.getCause());
        }
    }
}