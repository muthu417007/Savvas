/**
 * ClassName: Sav_FSL_UpdateManagerHandler
 *
 * Description: handler class for service resource trigger
 *
 * Author: CTS team
 * Created Date: 9 FEB 2024
 * Version: v1.0
 * Work no : W-013853
 */
 
public without sharing class Sav_FSL_UpdateManagerHandler_SR {

    public Static void  updateServiceResource(List<ServiceResource> srList){
        try{

    Set<string> managersList = new Set<String>();
    Set<string> managersPicklist = new Set<string>();
    Map<String, ServiceResource> idSRMap = new Map<String, ServiceResource>();

    for(ServiceResource sr2 : srList){
        idSRMap.put(sr2.RelatedRecordId, sr2);
    }
    
    for(user usr : [select Id,Manager.Name from user WHERE ID in: idSRMap.keyset()])
    {
       idSRMap.get(usr.Id).Sav_FSL_Manager__c = usr.Manager.name;
    }

    //To call the future method which updates the picklist values
    Sav_FSL_Tooling_picklist.createPicklist();
    
    }
    catch(DmlException  e){
       // system.debug(e.getmessage());
    }
    } 

}