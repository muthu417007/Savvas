public class scc_internal_orderDetail_Controller {
    @AuraEnabled(cacheable=true)
    //public static List<getOrderStatusCodesWrapper> getOrderStatusCodes(){
    public static Map<String, String> getOrderStatusCodes(){
        List<scc_SAP_Status_Map__mdt> getOrderStatusCodesData = [SELECT code__c,status__c FROM scc_SAP_Status_Map__mdt];
		Map<String, String> getOrderStatusCodesDataMap = new Map<String, String>();
         
        List<getOrderStatusCodesWrapper> getOrderStatusCodesWrap1 = new List<getOrderStatusCodesWrapper>();
        List<getOrderStatusCodesWrapper> getOrderStatusCodesWrap = new List<getOrderStatusCodesWrapper>();
		for(Integer i=0;i<getOrderStatusCodesData.size();i++)
		{
            getOrderStatusCodesWrap.add(new getOrderStatusCodesWrapper(getOrderStatusCodesData[i].code__c,getOrderStatusCodesData[i].status__c)); 
			getOrderStatusCodesDataMap.put(getOrderStatusCodesData[i].code__c,getOrderStatusCodesData[i].status__c);
		}
		
        //return getOrderStatusCodesWrap;
        return getOrderStatusCodesDataMap;
    }
    
    @AuraEnabled(cacheable=true)
    public static Map<String, String> getOrderMethodCodes(){
        List<scc_orderMethodMap__mdt> getOrderMethodCodesData = [SELECT code__c,method__c FROM scc_orderMethodMap__mdt];
		Map<String, String> getOrderMethodCodesDataMap = new Map<String, String>();
         
        List<getOrderMethodCodesWrapper> getOrderMethodCodesWrap1 = new List<getOrderMethodCodesWrapper>();
        List<getOrderMethodCodesWrapper> getOrderMethodCodesWrap = new List<getOrderMethodCodesWrapper>();
		for(Integer i=0;i<getOrderMethodCodesData.size();i++)
		{
            getOrderMethodCodesWrap.add(new getOrderMethodCodesWrapper(getOrderMethodCodesData[i].code__c,getOrderMethodCodesData[i].method__c)); 
			getOrderMethodCodesDataMap.put(getOrderMethodCodesData[i].code__c,getOrderMethodCodesData[i].method__c);
		}
		
        //return getOrderStatusCodesWrap;
        return getOrderMethodCodesDataMap;
    }
    
    @AuraEnabled(cacheable=true)
    public static List<Product2> itemsStatushelper(List<String> items){
        system.debug('Items are'+items);
        List<Product2> productData= [SELECT Id,ProductCode,ISBN10__c, ISBN13__c, Item_Category_Group_ID__c,Product_Type_ID__c FROM Product2 WHERE ISBN10__c IN :items OR ProductCode IN :items];
        return productData;
    }
    
    public class getOrderStatusCodesWrapper{
         @AuraEnabled public String code {get;set;}
         @AuraEnabled public String status {get;set;}
        getOrderStatusCodesWrapper(String code,String status){
            this.code = code;
            this.status = status;
        }
    }
    public class getOrderMethodCodesWrapper{
         @AuraEnabled public String code {get;set;}
         @AuraEnabled public String method {get;set;}
        getOrderMethodCodesWrapper(String code,String method){
            this.code = code;
            this.method = method;
        }
    }
    //Added for W-014778
    @AuraEnabled(cacheable=true)
    public static List<Product2> itemsDueDate(List<String> itemsDue){
        system.debug('Items Due Date'+itemsDue);
        List<Product2> productData= [SELECT Id,ProductCode,Due_In_Stock_Date__c,ISBN10__c FROM Product2 WHERE ISBN10__c IN :itemsDue OR ProductCode IN :itemsDue];
        system.debug('Due Date'+productData);
        return productData;
    }
    
      //Added for W-014802
    @AuraEnabled(cacheable=true)
    public static List<SAP_Package__c> getSign(String trackId)
    {
        
       system.debug('trackId'+trackId);
       List<SAP_Package__c> sAP= [SELECT Signature__c,Tracking_Number__c FROM SAP_Package__c WHERE Tracking_Number__c =: trackId];
       system.debug('Data signature'+sAP);
       return sAP;
    }
    //Added for W-014106
    @AuraEnabled
   public static List<scc_cancelledOrderReasonCodes__mdt> getOrderCancelCode(List<String> itemsCancel){
        List<scc_cancelledOrderReasonCodes__mdt> getOrderCancelledData = [SELECT Reason__c,ReasonCode__c FROM scc_cancelledOrderReasonCodes__mdt WHERE ReasonCode__c =: itemsCancel ];
		Map<String, String> getOrderCancelCodesDataMap = new Map<String, String>();
        return getOrderCancelledData;

    }

     @AuraEnabled
   public static List<String> getLogProStatus(List<String> itemsPacked){
        List<Logpro_status__c> getLogStatus = [SELECT Logpro_Status__c,ISBN10__c FROM Logpro_status__c WHERE ISBN10__c =: itemsPacked ];
        List<String> logStatus =new List<String>();
        
        if(!getLogStatus.isEmpty())
        {
            for(Logpro_status__c status:getLogStatus )
            {
                logStatus.add(status.Logpro_Status__c);
                //logStatus.add(status.ISBN10__c);
            }
            return logStatus;
        }
        else{
            logStatus.add('In Queue');
           // logStatus.addAll(itemsPacked);
            return logStatus;
        }
        
   }

    //Added for W-014106
    @AuraEnabled
    public static List<scc_deliveryTrackingLinks__mdt> getShipperLink(String trackingId,String shipperName){
    //    String shipName = shipperName.split('-')[1];
    //    system.debug('shipname'+shipName);
    //    List<scc_deliveryTrackingLinks__mdt> getShipData = [SELECT ShipperCode__c,ShipperLink__c,ShipperName__c FROM scc_deliveryTrackingLinks__mdt WHERE ShipperCode__c =: shipName ];
    //    List<scc_deliveryTrackingLinks__mdt> getShipData2 = new List<scc_deliveryTrackingLinks__mdt>();
    //    //getShipData2.add
    //    return getShipData;
       
       String link='';
       List<scc_deliveryTrackingLinks__mdt> getShipData = [SELECT ShipperCode__c,ShipperLink__c,ShipperName__c FROM scc_deliveryTrackingLinks__mdt];
       List<scc_deliveryTrackingLinks__mdt> getShipData2 = new List<scc_deliveryTrackingLinks__mdt>();
       for(scc_deliveryTrackingLinks__mdt metadata: getShipData){
            if(shipperName.contains(metadata.ShipperCode__c)){
                getShipData2.add(metadata);
                system.debug('Shipper code'+metadata.ShipperCode__c);
                system.debug('Shipper data'+getShipData2);
           
            }
            
            }
             return getShipData2;

        }
}