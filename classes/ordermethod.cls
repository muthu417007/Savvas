public class ordermethod {
    @AuraEnabled(cacheable=true)
    //public static List<getOrderStatusCodesWrapper> getOrderStatusCodes(){
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
    
    public class getOrderMethodCodesWrapper{
         @AuraEnabled public String code {get;set;}
         @AuraEnabled public String method {get;set;}
        getOrderMethodCodesWrapper(String code,String method){
            this.code = code;
            this.method = method;
        }
    }
   
   
}