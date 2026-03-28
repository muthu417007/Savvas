public class LeadTriggerHandler {
    
    //Updates the status of the Campaign member
    public static void UpdateCampaignMemberStatus(list<lead> cmToUpdate,List<string>campaignList){
       list<CampaignMember> cmList=[Select ID, name,leadid,campaignid,status from CampaignMember where campaignid in:campaignList and leadid!=null and status!='Responded']; 
       list<CampaignMember> cmUpdateStatusList=new list<CampaignMember>();
       
        for(Lead l:cmToUpdate){
            for(CampaignMember cm:cmList){
                if(l.id==cm.leadid && l.Campaign_Tracking__c.equals(cm.campaignId)){
                    cm.status='Responded';
                    cmUpdateStatusList.add(cm);
                }
            }
        }
        
        //Updates the campaign members
        if(cmUpdateStatusList.size()>0){
         	update cmUpdateStatusList;

        }
    }
    
     public static void handlerBeforeUpdate(List<Lead> UpdatedLead,Map<ID,Lead> OldLeadMap){
         list<lead> CampaignMemberToUpdate=new list<lead>();
         list<string>CampaignIdList=new list<string>();
         String newCampaignTracking;
         String oldCampaignTracking;
         
         For(Lead ld:UpdatedLead){
             Lead oldLead=oldLeadMap.get(ld.id);
            
             // If the Campaign Tracking field on the lead changes
             if(ld.Campaign_Tracking__c!=null){       
             	newCampaignTracking=ld.Campaign_Tracking__c; 
             	oldCampaignTracking=oldlead.Campaign_Tracking__c;
                
             	if(!newCampaignTracking.equals(oldCampaignTracking)){
                 	CampaignMemberToUpdate.add(ld);
                 	CampaignIdList.add(newCampaignTracking.trim());
                }
         	}
         }
        
         if(CampaignMemberToUpdate.size()>0){
             UpdateCampaignMemberStatus(CampaignMemberToUpdate,campaignIdList);
         }
             
     }
    
    //If a new lead has the campaign field populated, add the leads as a campaign member
    public static void handlerAfterInsert(List<Lead> newLead){
            list <CampaignMember> theCampaignMembers = new list<CampaignMember>();
    		for(Lead l:newLead) { 
                String campaignId=l.campaign__c;
        		if(l.Campaign__c != null && campaignId.startsWith('701')){
            		CampaignMember cml = new CampaignMember();
            		cml.leadid = l.id;
            		cml.CampaignId = l.Campaign__c;
            		cml.Status = 'Responded';
            		theCampaignMembers.add(cml);
        		}   
    		}
    		if(!theCampaignMembers.isEmpty()){
        		insert theCampaignMembers;
    		}
    }
}