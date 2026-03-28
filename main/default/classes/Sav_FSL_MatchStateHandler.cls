/**
 * ClassName: Sav_FSL_MatchStateHandler
 *
 * Description: Helper class for Service territory member trigger
 *
 * Author: Mukkesh
 * Created Date: 9 FEB 2024
 * Version: v1.0
 * Work no : W-013853
 */

public without sharing class Sav_FSL_MatchStateHandler {
    public static void updateServiceResource(List<ServiceTerritoryMember> sRTMList){
      try{
           Set<Id> sRId = new Set<Id>();
        for(ServiceTerritoryMember serviceTerMem : sRTMList){
          sRId.add(serviceTerMem.ServiceResourceId);
        }
       //system.debug('sRId: ' + sRId);
    	
    	//List of SR to update
    	List<ServiceResource> sRToUpdate = [Select id, Sav_FSL_state__c From ServiceResource Where id IN:sRId];
   // system.debug('before update sRToUpdate: ' + sRToUpdate);
    
          Map<Id,ServiceTerritoryMember> sTM = new Map<Id,ServiceTerritoryMember>();
        
            for(ServiceTerritoryMember sR : sRTMList){
                sTM.put(sR.ServiceResourceId,sR);
            }
    
  //  system.debug('sTM: ' + sTM);
    //Update SR
        for(ServiceResource sR : sRToUpdate){
            if(sR.Sav_FSL_state__c != sTM.get(sR.Id).state){
                 sR.Sav_FSL_state__c = sTM.get(sR.Id).state;
            }
               
        }   
    if(!sRToUpdate.isEmpty()){
        update sRToUpdate;
    }
    
  //  system.debug('after update sRToUpdate: ' + sRToUpdate);
	    
    }
    catch(exception ee){

    }
    }

}