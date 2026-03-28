/**
 * ClassName: Sav_FSL_UpdateManagerHandler
 *
 * Description: handler class for User trigger
 *
 * Author: CTS team
 * Created Date: 9 FEB 2024
 * Version: v1.0
 * Work no : W-013853
 */
 
public without sharing class Sav_FSL_UpdateManagerHandler {

    public Static void  updateServiceResource(Map<Id,User> userList){

    try{
    
    List<ServiceResource> srList = new List<ServiceResource>();
    Set<string> managersPicklist = new Set<string>();
    Set<string> userMngr = new Set<string>();

    
    for(ServiceResource sr : [select RelatedRecordId,Sav_FSL_Manager__c,Id,RelatedRecord.Manager.Name from ServiceResource WHERE RelatedRecordId in: userList.keyset() AND IsActive = true])
    {
        sr.Sav_FSL_Manager__c = sr.RelatedRecord.Manager.Name;
        srList.add(sr);
     //   userMngr.add(sr.RelatedRecord.Manager.Name);
    }

    update srList;

    }
    catch(DmlException  e){
        system.debug(e.getmessage());
    }
    } 

   /* public static Map<String, String> picklistValues(String objectName, String fieldName) {
        Map<String, String> values = new Map<String, String>{};
        List<Schema.DescribeSobjectResult> results = Schema.describeSObjects(new List<String>{objectName});
        for(Schema.DescribeSobjectResult res : results) {
            for (Schema.PicklistEntry entry : res.fields.getMap().get(fieldName).getDescribe().getPicklistValues()) {
                if (entry.isActive()) {
                    values.put(entry.getValue(), entry.getLabel());
                }
            }
        }
        return values;
    }*/
}