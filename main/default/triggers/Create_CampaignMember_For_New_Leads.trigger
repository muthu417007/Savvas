trigger Create_CampaignMember_For_New_Leads on Lead (after insert) {
    list <CampaignMember> theCampaignMembers = new list<CampaignMember>();
    for(Lead l:trigger.new) { 
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