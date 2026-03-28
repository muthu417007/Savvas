public class Usedtoclass {
    @AuraEnabled(cacheable=true)
    public static String getOrderStatusCodes(){
        List<scc_SAP_Status_Map__mdt> getOrderStatusCodesData = [SELECT MasterLabel,code__c,status__c FROM scc_SAP_Status_Map__mdt];
		Map<String, String> getOrderStatusCodesDataMap = new Map<String, String>();
		for(Integer i=0;i<getOrderStatusCodesData.size();i++)
		{
     		getOrderStatusCodesDataMap.put(getOrderStatusCodesData[i].code__c, getOrderStatusCodesData[i].status__c);
		}	        
        return JSON.serialize(getOrderStatusCodesDataMap);
    }
}