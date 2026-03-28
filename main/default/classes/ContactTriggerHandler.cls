public class ContactTriggerHandler {
 //Updates the status of the Campaign member
    public static void UpdateCampaignMemberStatus(list<Contact> cmToUpdate,List<string>campaignList){
       list<CampaignMember> cmList=[Select ID, name,Contactid,campaignid,status from CampaignMember where campaignid in:campaignList and ContactId!=null and status!='Responded']; 
       list<CampaignMember> cmUpdateStatusList=new list<CampaignMember>();
       
        for(Contact c:cmToUpdate){
            for(CampaignMember cm:cmList){
                if(c.id==cm.ContactId && c.Campaign_Tracking__c.equals(cm.campaignId)){
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
    
     public static void handlerBeforeUpdate(List<Contact> UpdatedContact,Map<ID,Contact> OldContactMap){
         list<Contact> CampaignMemberToUpdate=new list<Contact>();
         list<string>CampaignIdList=new list<string>();
         String newCampaignTracking;
         String oldCampaignTracking;
         
         For(Contact cont:UpdatedContact){
             Contact oldContact=oldContactMap.get(cont.id);
            
             // If the Campaign Tracking field on the Contact changes
             if(cont.Campaign_Tracking__c!=null){       
             	newCampaignTracking=cont.Campaign_Tracking__c; 
             	oldCampaignTracking=oldContact.Campaign_Tracking__c;
                
             	if(!newCampaignTracking.equals(oldCampaignTracking)){
                 	CampaignMemberToUpdate.add(Cont);
                 	CampaignIdList.add(newCampaignTracking.trim());
                }
         	}
         }
        
         if(CampaignMemberToUpdate.size()>0){
             UpdateCampaignMemberStatus(CampaignMemberToUpdate,campaignIdList);
         }
             
     }
    
}