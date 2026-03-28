public class OpportunityTeamProcessor {
    @future
    public static void createOpportunityTeamMember(Set<Id> oppIds) {
        
        // List of Opportunities
        List<Opportunity> lstOpps = [select Id, OwnerId, Opportunity_Leader__c,createdbyId from Opportunity where Id in :oppIds];
        
        // List of existing OpportunityTeamMembers
        List<OpportunityTeamMember> lstExistingOTMs = [select Id, UserId, OpportunityId from OpportunityTeamMember where OpportunityId in :oppIds];
        
        List<OpportunityShare> lstExistingShares=[SELECT Id, OpportunityAccessLevel, userorgroupid, RowCause,opportunityid FROM OpportunityShare where OpportunityId in:oppIds];
        // Lists to store OpportunityTeamMembers and OpportunityShares to create
        List<OpportunityTeamMember> lstNewOTMs = new List<OpportunityTeamMember>();
        List<OpportunityShare> lstNewOppShares = new List<OpportunityShare>();
        
        // Set of Users who are Opp Owners or Leaders
        Set<Id> setUserIdsOppOwnersLeaders=new Set<Id>();
        for(Opportunity opp:lstOpps){
            setUserIdsOppOwnersLeaders.add(opp.OwnerId);
            setUserIdsOppOwnersLeaders.add(opp.Opportunity_Leader__c);
            setUserIdsOppOwnersLeaders.add(opp.createdbyId);
        }
        
        // Map of User IDs to User records for Opp Owners
        Map<Id,User> mapUserOppOwnersLeaders = new Map<Id,User>([select Id, Opportunity_Role__c from User where Id in :setUserIdsOppOwnersLeaders]);
        
        // Keep track of which Opps have owners and leaders not yet in Opp Teams
        boolean ownerFoundInTeam = false;
        boolean leaderFoundInTeam = false;
        boolean creatorFoundInTeam = false;
        
        // Keep track of which Opps have owners and leaders not yet in Opp Shares
        boolean ownerFoundInshare = false;
        boolean leaderFoundInShare = false;
        boolean creatorFoundInShare = false;        
        
        // Iterate through the list of Opportunities
        for (Opportunity opp : lstOpps) {
           
            for(OpportunityTeamMember OTM:lstExistingOTMs){ 
                if(OTM.OpportunityId==opp.Id && OTM.UserId==opp.OwnerId){
                    ownerFoundInTeam=true; //There is already an OTM for the Owner
                }
                if(OTM.OpportunityId==opp.Id && OTM.UserId==opp.Opportunity_Leader__c){
                    leaderFoundInTeam=true; //There is already an OTM for the Leader
                }
                if(OTM.OpportunityId==opp.Id && OTM.UserId==opp.createdbyId){
                    creatorFoundInTeam=true; //There is already an OTM for the creator
                }

            }
            
            if(ownerFoundInTeam==false){
                user u = mapUserOppOwnersLeaders.get(opp.OwnerId);
                lstNewOTMs.add(new OpportunityTeamMember(TeamMemberRole=u.Opportunity_Role__c,OpportunityId=opp.Id,UserId=opp.OwnerId));
                //lstNewOppShares.add(new OpportunityShare(OpportunityAccessLevel='Edit',OpportunityId=opp.Id,UserOrGroupId=opp.OwnerId));
            }
            if(opp.OwnerId <> opp.Opportunity_Leader__c && leaderFoundInTeam==false){  //if Leader is same as Owner, it was already caught in the previous IF statement, so don't add the OTM and Share a second time for Leader
                user u = mapUserOppOwnersLeaders.get(opp.Opportunity_Leader__c);
                lstNewOTMs.add(new OpportunityTeamMember(TeamMemberRole=u.Opportunity_Role__c,OpportunityId=opp.Id,UserId=opp.Opportunity_Leader__c));
                //lstNewOppShares.add(new OpportunityShare(OpportunityAccessLevel='Edit',OpportunityId=opp.Id,UserOrGroupId=opp.Opportunity_Leader__c));
            }
            if(opp.Opportunity_Leader__c<>opp.createdbyId && opp.OwnerId<>opp.createdbyId && creatorFoundInTeam==false){  //if leader is same as Owner and not the same as creator
                user u = mapUserOppOwnersLeaders.get(opp.createdbyId);
                lstNewOTMs.add(new OpportunityTeamMember(TeamMemberRole=u.Opportunity_Role__c,OpportunityId=opp.Id,UserId=opp.createdbyId));
                //lstNewOppShares.add(new OpportunityShare(OpportunityAccessLevel='Edit',OpportunityId=opp.Id,UserOrGroupId=opp.createdbyId));
            }
           
            for(OpportunityShare OS:lstExistingShares){
                if(OS.OpportunityId==opp.Id && Opp.ownerId==OS.userorgroupid){
                    ownerFoundInShare=true; //There is already an Opportunity Share for the Owner
                }
                if(OS.OpportunityId==opp.Id && opp.Opportunity_Leader__c==OS.userorgroupid){
                    leaderFoundInShare=true; //There is already an Opportunity Share for the Leader
                }
                if(OS.OpportunityId==opp.Id && opp.createdbyId==OS.userorgroupid){
                    creatorFoundInShare=true; //There is already an Opportunity Share for the creator
                }
            }
            
            if(ownerFoundInShare==false){
                user u = mapUserOppOwnersLeaders.get(opp.OwnerId);
                lstNewOppShares.add(new OpportunityShare(OpportunityAccessLevel='Edit',OpportunityId=opp.Id,UserOrGroupId=opp.OwnerId));
            }
            if(opp.OwnerId <> opp.Opportunity_Leader__c && leaderFoundInShare==false){  //if Leader is same as Owner, it was already caught in the previous IF statement, so don't add the OTM and Share a second time for Leader
                user u = mapUserOppOwnersLeaders.get(opp.Opportunity_Leader__c);
                lstNewOppShares.add(new OpportunityShare(OpportunityAccessLevel='Edit',OpportunityId=opp.Id,UserOrGroupId=opp.Opportunity_Leader__c));
            }
            if(opp.Opportunity_Leader__c<>opp.createdbyId && opp.OwnerId<>opp.createdbyId && creatorFoundInShare==false){  //if leader is same as Owner and not the same as creator
                user u = mapUserOppOwnersLeaders.get(opp.createdbyId);
                lstNewOppShares.add(new OpportunityShare(OpportunityAccessLevel='Edit',OpportunityId=opp.Id,UserOrGroupId=opp.createdbyId));
            }
        }

        if(lstNewOTMs.size()>0){
            try {
                Database.SaveResult[] OTMsrs = Database.insert(lstNewOTMs,false);  //The optional opt_allOrNone parameter specifies whether the operation allows partial success. If you specify false for this parameter and a record fails, the remainder of the DML operation can still succeed. This method returns a result object that can be used to verify which records succeeded, which failed, and why.
                            
                for (Database.SaveResult OTMsr : OTMsrs) {
                    if (OTMsr.isSuccess()) {
                        // Operation was successful, so get the ID of the record that was processed
                        // System.debug('Successfully inserted account. Account ID: ' + OTMsr.getId());
                    }else{
                        for(Database.Error err : OTMsr.getErrors()) {
                            System.debug('The following error has occurred.');                    
                            System.debug(err.getStatusCode() + ': ' + err.getMessage());
                            System.debug('Fields that affected this error: ' + err.getFields());
                        }
                    }
                }
            } catch(DmlException e) {
                System.debug('The following exception has occurred: ' + e.getMessage());
            }
        }
        if(lstNewOppShares.size()>0){
            try {
               
                Database.SaveResult[] OSsrs = Database.insert(lstNewOppShares,false);  //The optional opt_allOrNone parameter specifies whether the operation allows partial success. If you specify false for this parameter and a record fails, the remainder of the DML operation can still succeed. This method returns a result object that can be used to verify which records succeeded, which failed, and why.
                for (Database.SaveResult OSsr : OSsrs) {
                    if (OSsr.isSuccess()) {
                        // Operation was successful, so get the ID of the record that was processed
                        // System.debug('Successfully inserted account. Account ID: ' + OSsr.getId());
                    }else{
                        for(Database.Error err : OSsr.getErrors()) {
                            System.debug('The following error has occurred.');                    
                            System.debug(err.getStatusCode() + ': ' + err.getMessage());
                            System.debug('Fields that affected this error: ' + err.getFields());
                        }
                    }
                }
            } catch(DmlException e) {
                System.debug('The following exception has occurred: ' + e.getMessage());
            }
        }
    }
}