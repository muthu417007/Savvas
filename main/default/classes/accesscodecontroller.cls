public without sharing class accesscodecontroller {
    @InvocableMethod
    public static FlowOutput[] quantityValidation(List<FlowInput> request){
        List<FlowOutput> results = new List<FlowOutput>();
        List<noAccessCodeWrapper> noaccessWrapper = new List<noAccessCodeWrapper>();
        
        FlowOutput fo = new FlowOutput();
        Map<String,Integer> isbnQntMap = new Map<String,Integer>();
        Map<String,Integer> isbnQntCodesMap = new Map<String,Integer>();
        Set<String> isbnCodes = new Set<String>();
        List<OrderItem> ois = [select id,quantity,ISBN__c from orderitem where orderId =: request[0].ordId AND ISBN__c != ''];
        for(OrderItem oi : ois){
            isbnCodes.add(oi.ISBN__c);
            if(isbnQntMap.containskey(oi.ISBN__c)){
                isbnQntMap.put(oi.ISBN__c, isbnQntMap.get(oi.ISBN__c) + 1);
            }
            else{
                 isbnQntMap.put(oi.ISBN__c, 1);
            }
        }
        List<EAccess_List__c> eaccessCodes = [select id,ISBN__c,EAccess_Imprints__c,EAccess_Code__c,EAccess_Imprints__r.Admin_Email2__c from EAccess_List__c where ISBN__c IN: isbnCodes];
        List<String> imprintcodes = new List<String>();
        List<String> accesscodeisbn = new List<String>();
        Map<String, String> isbnImprintEmailsMap = new Map<String, String>();
         Map<String, Id> isbnImprintIdMap = new Map<String, Id>();
        List<String> accessCodesList = new List<String>();
        for(EAccess_List__c ea : eaccessCodes){
            imprintcodes.add(ea.EAccess_Imprints__c);
            accessCodesList.add(ea.Id);
            
            if (!isbnImprintEmailsMap.containsKey(ea.ISBN__c)) {
                isbnImprintEmailsMap.put(ea.ISBN__c, ea.EAccess_Imprints__r.Admin_Email2__c);
            }
            
            if (!isbnImprintIdMap.containsKey(ea.ISBN__c)) {
                isbnImprintIdMap.put(ea.ISBN__c,ea.EAccess_Imprints__c);
            }

            if(isbnQntCodesMap.containskey(ea.ISBN__c)){
                isbnQntCodesMap.put(ea.ISBN__c, isbnQntCodesMap.get(ea.ISBN__c) + 1);
            }
            else{
                 isbnQntCodesMap.put(ea.ISBN__c, 1);
            }
        }
        fo.outputboolean = true;
        for(String str : isbnQntMap.keyset()){
            noAccessCodeWrapper accessWrapper = new noAccessCodeWrapper();
            if(isbnQntMap.get(str) > isbnQntCodesMap.get(str) ){
               accesscodeisbn.add(str);
               fo.outputboolean = false;
               accessWrapper.outputimprintemail = isbnImprintEmailsMap.get(str);
               accessWrapper.outputnoaccesscodeisbn=str;
               accessWrapper.outputnoaccesscodeimprintid=isbnImprintIdMap.get(str);
               noaccessWrapper.add(accessWrapper);
            }
        }
        fo.noacesscodewrapper=noaccessWrapper;
        fo.exCodes = accessCodesList;
        fo.outputimprints = imprintcodes;
        fo.outputaccessList = eaccessCodes;
        if(fo.outputboolean){
	        List<EAccess_Threshold__c> eaccessThresolds = [select id,Avl_Stock__c,ISBN__c  from EAccess_Threshold__c where ISBN__c IN: isbnCodes];
            for(EAccess_Threshold__c ed : eaccessThresolds){
                ed.Avl_Stock__c = ed.Avl_Stock__c - isbnQntMap.get(ed.ISBN__c);
            }
            Database.update(eaccessThresolds);
        }
        results.add(fo);
        return results;
    }
    
    //input details that comes to apex from flow
    public class FlowInput{
        
        @InvocableVariable
        public String ordId;
        
    }
    
    //output details which goes from apex to flow
    public class FlowOutput{
        
        @InvocableVariable
        public boolean outputboolean;
        @InvocableVariable
        public List<String> outputimprints;
        @InvocableVariable
        public List<EAccess_List__c> outputaccessList;
        @InvocableVariable
        public List<String> exCodes;
        @InvocableVariable
        public List<noAccessCodeWrapper> noacesscodewrapper;
       
       
    }
    
    public class noAccessCodeWrapper
    {
        @InvocableVariable
        public String outputimprintemail;
        @InvocableVariable
        public String outputnoaccesscodeisbn;
        @InvocableVariable
        public Id outputnoaccesscodeimprintid;

    }
        
}