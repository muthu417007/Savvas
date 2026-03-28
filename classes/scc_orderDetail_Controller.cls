/*
Apex Class:scc_orderDetail_Controller
Author: CTS (Vaibhav Saptal)
Created Date: 31/05/2024
Reason: Bakend logic scc_orderStatusLWC component.
Modified Date: 16/10/2024
*/
public with sharing class scc_orderDetail_Controller {
/**
*  Description: This method queries order status codes    
*  @name: getOrderStatusCodes
*  @param:NA
*  @return: line item status codes
*  @throws exception- Failed to get line item status codes
*/    
    @AuraEnabled(cacheable=true)
    public static Map<String, String> getOrderStatusCodes(){
        try{
            List<scc_SAP_Status_Map__mdt> getOrderStatusCodesData = [SELECT code__c,status__c FROM scc_SAP_Status_Map__mdt];
            Map<String, String> getOrderStatusCodesDataMap = new Map<String, String>();
            
            List<getOrderStatusCodesWrapper> getOrderStatusCodesWrap1 = new List<getOrderStatusCodesWrapper>();
            List<getOrderStatusCodesWrapper> getOrderStatusCodesWrap = new List<getOrderStatusCodesWrapper>();
            for(Integer i=0;i<getOrderStatusCodesData.size();i++)
            {
                getOrderStatusCodesWrap.add(new getOrderStatusCodesWrapper(getOrderStatusCodesData[i].code__c,getOrderStatusCodesData[i].status__c)); 
                getOrderStatusCodesDataMap.put(getOrderStatusCodesData[i].code__c,getOrderStatusCodesData[i].status__c);
            }       
            return getOrderStatusCodesDataMap;
        }catch(Exception e){
            System.debug(scc_constantHelper.EXCEPTION_TYPE_CAUGHT+ e.getTypeName());    
            System.debug(scc_constantHelper.MESSAGE+ e.getMessage());    
            System.debug(scc_constantHelper.CAUSE+ e.getCause());    // returns null
            System.debug(scc_constantHelper.LINE_NUMBER + e.getLineNumber());    
            System.debug(scc_constantHelper.STACK_RACE+ e.getStackTraceString());
            throw new AuraHandledException('Failed to get line item status codes :'+e.getMessage()+e.getCause());
        }
    }
/**
*  Description: This method queries the order method codes     
*  @name: getOrderMethodCodes
*  @param:NA
*  @return: order method codes
*  @throws exception- Failed to get order method codes
*/    
    @AuraEnabled(cacheable=true)
    public static Map<String, String> getOrderMethodCodes(){
        try{
            List<scc_orderMethodMap__mdt> getOrderMethodCodesData = [SELECT code__c,method__c FROM scc_orderMethodMap__mdt];
            Map<String, String> getOrderMethodCodesDataMap = new Map<String, String>();
            
            List<getOrderMethodCodesWrapper> getOrderMethodCodesWrap1 = new List<getOrderMethodCodesWrapper>();
            List<getOrderMethodCodesWrapper> getOrderMethodCodesWrap = new List<getOrderMethodCodesWrapper>();
            for(Integer i=0;i<getOrderMethodCodesData.size();i++)
            {
                getOrderMethodCodesWrap.add(new getOrderMethodCodesWrapper(getOrderMethodCodesData[i].code__c,getOrderMethodCodesData[i].method__c)); 
                getOrderMethodCodesDataMap.put(getOrderMethodCodesData[i].code__c,getOrderMethodCodesData[i].method__c);
            }        
            return getOrderMethodCodesDataMap;
        }catch(Exception e){
            System.debug(scc_constantHelper.EXCEPTION_TYPE_CAUGHT+ e.getTypeName());    
            System.debug(scc_constantHelper.MESSAGE+ e.getMessage());    
            System.debug(scc_constantHelper.CAUSE+ e.getCause());    // returns null
            System.debug(scc_constantHelper.LINE_NUMBER + e.getLineNumber());    
            System.debug(scc_constantHelper.STACK_RACE+ e.getStackTraceString());
            throw new AuraHandledException('Failed to get order method codes :'+e.getMessage()+e.getCause());
        }
    }
/**
*  Description: This method product type,product category type from product2 object.    
*  @name: itemsStatushelper
*  @param:List of items for which data is needed.
*  @return:product data
*  @throws exception- Failed to product data for status helper
*/    
    @AuraEnabled(cacheable=true)
    public static List<Product2> itemsStatushelper(List<String> items){
        try{
            system.debug('Items are'+items);
            List<Product2> productData= [SELECT Id,ProductCode,ISBN10__c, ISBN13__c, Item_Category_Group_ID__c,Product_Type_ID__c FROM Product2 WHERE ISBN13__c IN :items OR ISBN10__c IN :items OR ProductCode IN :items];
            return productData;
        }catch(Exception e){
            System.debug(scc_constantHelper.EXCEPTION_TYPE_CAUGHT+ e.getTypeName());    
            System.debug(scc_constantHelper.MESSAGE+ e.getMessage());    
            System.debug(scc_constantHelper.CAUSE+ e.getCause());    // returns null
            System.debug(scc_constantHelper.LINE_NUMBER + e.getLineNumber());    
            System.debug(scc_constantHelper.STACK_RACE+ e.getStackTraceString());
            throw new AuraHandledException('Failed to product data for status helper :'+e.getMessage()+e.getCause());
        }    
    }
    
/**
*  Description: This method used to stock due date for backordered items.      
*  @name: itemsDueDate
*  @param:List of items for which due date is needed
*  @return: product data with due date
*  @throws exception- 
*/
    //Added for W-014778
    @AuraEnabled(cacheable=true)
    public static List<Product2> itemsDueDate(List<String> itemsDue){
        try{
            system.debug('Items Due Date'+itemsDue);
            List<Product2> productData= [SELECT Id,ProductCode,Due_In_Stock_Date__c,ISBN10__c FROM Product2 WHERE ISBN10__c IN :itemsDue OR ISBN13__c IN :itemsDue OR ProductCode IN :itemsDue];
            system.debug('Due Date'+productData);
            return productData;
        }catch(Exception e){
            System.debug(scc_constantHelper.EXCEPTION_TYPE_CAUGHT+ e.getTypeName());    
            System.debug(scc_constantHelper.MESSAGE+ e.getMessage());    
            System.debug(scc_constantHelper.CAUSE+ e.getCause());    // returns null
            System.debug(scc_constantHelper.LINE_NUMBER + e.getLineNumber());    
            System.debug(scc_constantHelper.STACK_RACE+ e.getStackTraceString());
            throw new AuraHandledException('Failed to product data for due date helper :'+e.getMessage()+e.getCause());
        }
    }
/**
*  Description: This method queries sign for provided tracking Id    
*  @name: getSign
*  @param:tracking id
*  @return: List containing tracking number,sign and delivery date
*  @throws exception- 
*/    
    //Added for W-014802
    @AuraEnabled
    public static List<SAP_Package__c> getSign(List<String> trackId)
    {
        try{
            system.debug('trackId'+trackId);
            List<SAP_Package__c> sAP= [SELECT Signature__c,Tracking_Number__c,Delivery_Date__c FROM SAP_Package__c WHERE Tracking_Number__c IN :trackId];
            system.debug('Data signature'+sAP);
            return sAP;
        }catch(Exception e){
            System.debug(scc_constantHelper.EXCEPTION_TYPE_CAUGHT+ e.getTypeName());    
            System.debug(scc_constantHelper.MESSAGE+ e.getMessage());    
            System.debug(scc_constantHelper.CAUSE+ e.getCause());    // returns null
            System.debug(scc_constantHelper.LINE_NUMBER + e.getLineNumber());    
            System.debug(scc_constantHelper.STACK_RACE+ e.getStackTraceString());
            throw new AuraHandledException('Failed to get sign data for give tracking number:'+e.getMessage()+e.getCause());            
        }
    }
/**
*  Description: This method queries third party tracking numbers for given invoice number.    
*  @name: getThirdPartyTrack
*  @param:Invoice Number
*  @return: List containing third part tracking numbers
*  @throws exception- Failed to get Third Party Tracking for given invoice number
*/    
    @AuraEnabled
    public static List<SAP_Package__c> getThirdPartyTrack(String invoicenumber)
    {
        try{
            List<SAP_Package__c> sapData= [SELECT ThirdParty_Tracking_Number__c,Parcel_ID_Number__c,Signature__c,Delivery_Date__c,OrderId__r.SAP_Document_Number__c,Invoice_Number__c,carrier_name__c FROM SAP_Package__c WHERE Invoice_Number__c =: invoicenumber AND Tracking_Number__c='' AND Tracking_Number__c=null];
            system.debug('thirdpartydata'+sapData);
            return sapData;
        }catch(Exception e){
            System.debug(scc_constantHelper.EXCEPTION_TYPE_CAUGHT+ e.getTypeName());    
            System.debug(scc_constantHelper.MESSAGE+ e.getMessage());    
            System.debug(scc_constantHelper.CAUSE+ e.getCause());    // returns null
            System.debug(scc_constantHelper.LINE_NUMBER + e.getLineNumber());    
            System.debug(scc_constantHelper.STACK_RACE+ e.getStackTraceString());
            throw new AuraHandledException('Failed to get Third Party Tracking for given invoice number:'+e.getMessage()+e.getCause());            
        }           
    }
/**
*  Description: This method queries called items status codes from custom metadata      
*  @name: getOrderCancelCode
*  @param:List of items
*  @return: List of cancelled codes with reasons
*  @throws exception- Failed to get called codes
*/    
    //Added for W-014106
    @AuraEnabled
    public static List<scc_cancelledOrderReasonCodes__mdt> getOrderCancelCode(List<String> itemsCancel){
        try{
            List<scc_cancelledOrderReasonCodes__mdt> getOrderCancelledData = [SELECT Reason__c,ReasonCode__c FROM scc_cancelledOrderReasonCodes__mdt WHERE ReasonCode__c =: itemsCancel ];
            Map<String, String> getOrderCancelCodesDataMap = new Map<String, String>();
            return getOrderCancelledData;
        }catch(Exception e){
            System.debug(scc_constantHelper.EXCEPTION_TYPE_CAUGHT+ e.getTypeName());    
            System.debug(scc_constantHelper.MESSAGE+ e.getMessage());    
            System.debug(scc_constantHelper.CAUSE+ e.getCause());    // returns null
            System.debug(scc_constantHelper.LINE_NUMBER + e.getLineNumber());    
            System.debug(scc_constantHelper.STACK_RACE+ e.getStackTraceString());
            throw new AuraHandledException('Failed to get called codes:'+e.getMessage()+e.getCause());            
        }        
    }
/**
*  Description: This method queries Log pro status for given items     
*  @name: getLogProStatus
*  @param:HomePage parameter to differentiate the between which page request is coming.
*  @return: String values of search by options
*  @throws exception- Failed to get Log Pro status
*/    
    @AuraEnabled
    public static List<getLogProStatusWrapper> getLogProStatus(List<String> itemsPacked,String orderNumber){
        try{
            List<Logpro_status__c> getLogStatus = [SELECT Logpro_Status__c,ISBN10__c,SAP_Document_Number__c FROM Logpro_status__c WHERE ISBN10__c=:itemsPacked AND SAP_Document_Number__c=:orderNumber];
            List<String> logStatus =new List<String>();
            List<getLogProStatusWrapper> logStatusProWrap =new List<getLogProStatusWrapper>();
            if(!getLogStatus.isEmpty())
            {
                for(Logpro_status__c status:getLogStatus )
                {
                    getLogProStatusWrapper lgp = new getLogProStatusWrapper();
                    lgp.ISBN = status.ISBN10__c;
                    lgp.status = status.Logpro_Status__c;
                    logStatusProWrap.add(lgp);                
                }
            }
            return logStatusProWrap;
        }catch(Exception e){
            System.debug(scc_constantHelper.EXCEPTION_TYPE_CAUGHT+ e.getTypeName());    
            System.debug(scc_constantHelper.MESSAGE+ e.getMessage());    
            System.debug(scc_constantHelper.CAUSE+ e.getCause());    // returns null
            System.debug(scc_constantHelper.LINE_NUMBER + e.getLineNumber());    
            System.debug(scc_constantHelper.STACK_RACE+ e.getStackTraceString());
            throw new AuraHandledException('Failed to get Log Pro status:'+e.getMessage()+e.getCause());            
        } 
    }
/**
*  Description: This method queries shipper links from custom metadata      
*  @name: getShipperLink
*  @param:tracking Id and shipper name
*  @return:shipper links data  
*  @throws exception- Failed to get sipper links
*/    
    //Added for W-014106
    @AuraEnabled
    public static List<scc_deliveryTrackingLinks__mdt> getShipperLink(String trackingId,String shipperName,Boolean isThirdParty,List<String> thirdPartyCarrier){
        try{
            String link='';
            String shipperUpperCase='';
            shipperUpperCase = shippername.toUpperCase();
            List<scc_deliveryTrackingLinks__mdt> getShipData2 = new List<scc_deliveryTrackingLinks__mdt>();
            if(isThirdParty == true){
                List<scc_deliveryTrackingLinks__mdt> getShipData = [SELECT ShipperCode__c,ShipperLink__c,ShipperName__c FROM scc_deliveryTrackingLinks__mdt WHERE IsThirdPartyTrackingEnabled__c = true AND ShipperCode__c IN:thirdPartyCarrier];
            	return getShipData;
            }else{
                List<scc_deliveryTrackingLinks__mdt> getShipData = [SELECT ShipperCode__c,ShipperLink__c,ShipperName__c FROM scc_deliveryTrackingLinks__mdt WHERE IsThirdPartyTrackingEnabled__c = false];
                
                for(scc_deliveryTrackingLinks__mdt metadata: getShipData){
                    if(shipperUpperCase.contains(metadata.ShipperCode__c)){
                        getShipData2.add(metadata);                
                    }            
                }                
            }
            return getShipData2;
        }catch(Exception e){
            System.debug(scc_constantHelper.EXCEPTION_TYPE_CAUGHT+ e.getTypeName());    
            System.debug(scc_constantHelper.MESSAGE+ e.getMessage());    
            System.debug(scc_constantHelper.CAUSE+ e.getCause());    // returns null
            System.debug(scc_constantHelper.LINE_NUMBER + e.getLineNumber());    
            System.debug(scc_constantHelper.STACK_RACE+ e.getStackTraceString());
            throw new AuraHandledException('Failed to get shipper links:'+e.getMessage()+e.getCause());            
        }         
    }
    
    public class getOrderStatusCodesWrapper{
        @AuraEnabled public String code {get;set;}
        @AuraEnabled public String status {get;set;}
        getOrderStatusCodesWrapper(String code,String status){
            this.code = code;
            this.status = status;
        }
    }
    public class getLogProStatusWrapper{
        @AuraEnabled public String ISBN {get;set;}
        @AuraEnabled public String status {get;set;}
    }    
    
    public class getOrderMethodCodesWrapper{
        @AuraEnabled public String code {get;set;}
        @AuraEnabled public String method {get;set;}
        getOrderMethodCodesWrapper(String code,String method){
            this.code = code;
            this.method = method;
        }
    }   
}