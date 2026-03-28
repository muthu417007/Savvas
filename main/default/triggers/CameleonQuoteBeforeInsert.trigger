trigger CameleonQuoteBeforeInsert on CameleonCPQ__Quote__c (before insert, before update) {

    set<Id> OppIds = new set<Id>();
    set<Id> OwnerIds = new set<Id>();
    set<Id> ManagerIds = new set<Id>();
    set<Id> quoteReleaseIds = new set<Id>();

    for (CameleonCPQ__Quote__c cq : Trigger.New){
        //if(cq.CameleonCPQ__Status__c == 'Accepted'){
        //    cq.CameleonCPQ__Status__c = 'Released';
        //    quoteReleaseIds.add(cq.Id);
        //}
        
        if(Trigger.isInsert || (Trigger.isUpdate && cq.CameleonCPQ__Status__c=='Needs_Review' && Trigger.OldMap.get(cq.Id).CameleonCPQ__Status__c<>cq.CameleonCPQ__Status__c)){
            OppIds.add(cq.CPQOpportunityId__c);
            //OwnerIds.add(cq.OwnerId);
        }
    }
    
    if(!(quoteReleaseIds.isEmpty())){
                List<CameleonCPQ__QuoteRelease__c> quoteReleases = new List<CameleonCPQ__QuoteRelease__c>([select id, CameleonCPQ__QuoteId__c,
                                                                                                    Active__c, Order__c 
                                                                                                    from CameleonCPQ__QuoteRelease__c 
                                                                                                    where CameleonCPQ__QuoteId__c in :quoteReleaseIds]);
                CreateOrderFromQuoteInvocable.createOrderFromReleasedQuote(quoteReleases);
        }

    
    if(OppIds.size()>0 && Limits.getLimitQueries()>4){    
        User mdUser = [Select Id from User where Opportunity_Role__c='Managing Director' limit 1]; //Managing Director's User Record
        Id mdId = mdUser.Id; //Managing Director's User Id
        GroupMember DealDeskUser = [Select g.UserOrGroupId, g.Group.Name, g.GroupId From GroupMember g where g.Group.Name='Deal Desk' limit 1];
        id DealDeskId = DealDeskUser.UserOrGroupId;
        
        List<Opportunity> lstOpps = [select Id,OwnerId,Has_Quote__c from Opportunity where Id in :OppIds];
        Map<id,id>OppToOwnerMap = new map<id,id>();
        //List of opportunities to update
        List<Opportunity> updateOpsLst=new list<Opportunity>();
        for(Opportunity o:lstOpps){
            OppToOwnerMap.put(o.Id,o.OwnerId);
            OwnerIds.add(o.OwnerId);
            
            //Update the opportunity and set has quote field to true
            o.Has_Quote__c=TRUE;
            updateOpsLst.add(o);
        }
        
        //Update the opportunity
        if(updateOpsLst.size()>0){
            update updateOpsLst;
        }
        
        Map<id,id>OwnerToManagerMap = new map<id,id>();
        Map<id,String> OwnerToRoleName = new map<id,String>();          // ICOM-1154
        //List<User> OwnersList = [select Id, ManagerId from User where id in :OwnerIds];
        List<User> OwnersList = [Select u.id,u.ManagerId,u.UserRole.Name, u.UserRoleId, u.Name From User u where u.id in :OwnerIds]; //New Soql Query ICOM-1154
        for(User o:OwnersList){
            OwnerToManagerMap.put(o.Id,o.ManagerId);
            ManagerIds.add(o.ManagerId);
            OwnerToRoleName.put(o.Id,o.UserRole.Name);      //ICOM-1154
        }
        
        // Commented out for ICOM-1886.  Only 2 tier approval
        //Map<id,id>ManagerToManager2Map = new map<id,id>();
        //List<User> ManagersList = [select Id, ManagerId from User where id in :ManagerIds];
        //for(User o:ManagersList){
        //    ManagerToManager2Map.put(o.Id,o.ManagerId);
        //}
            
        for (CameleonCPQ__Quote__c cq : Trigger.New){
            if(Trigger.isInsert || (Trigger.isUpdate && cq.CameleonCPQ__Status__c=='Needs_Review' && Trigger.OldMap.get(cq.Id).CameleonCPQ__Status__c<>cq.CameleonCPQ__Status__c)){
                id oid = cq.CPQOpportunityId__c; //Quote's Opportunity
                id ooid = OppToOwnerMap.get(oid); //Quote's Opportunity Owner
                string oorn = OwnerToRoleName.get(ooid); // ICOM-1154 - Quote's Opportunity Owner Role Name
                id lmid = OwnerToManagerMap.get(ooid); //Opp Owner's Line Manager
        // Check the Opportunity owner's role for escalation
            If(String.isNotBlank(oorn)){
                if(oorn.contains('SVP') || oorn.contains('VP')){
                cq.First_Level_Manager__c = ooid;
                        cq.Second_Level_Manager__c = ooid;
                }Else if(oorn.contains('MGM')){
                    cq.First_Level_Manager__c = ooid;
                   
                   // Line Below are commented out for ICOM-1886
                   //if(lmid <> null){                    
                   //             cq.Second_Level_Manager__c = lmid;
                   // }else{
                                cq.Second_Level_Manager__c = DealDeskId;
                    //}
                }Else{
                    if(lmid <> null){
                            cq.First_Level_Manager__c = lmid;
                            //id slmid = ManagerToManager2Map.get(lmid); //Opp Owner's Second Level Manager
                            //    if(slmid <> null){
                            //        cq.Second_Level_Manager__c = slmid;
                            //    }else{
                                 cq.Second_Level_Manager__c = DealDeskId;
                            //    }
                        }else{
                                cq.First_Level_Manager__c = DealDeskId;
                                cq.Second_Level_Manager__c = DealDeskId;
                        }
         
                } 
           }Else{
                    if(lmid <> null){
                            cq.First_Level_Manager__c = lmid;
                            //id slmid = ManagerToManager2Map.get(lmid); //Opp Owner's Second Level Manager
                            //    if(slmid <> null){
                            //        cq.Second_Level_Manager__c = slmid;
                            //    }else{
                                 cq.Second_Level_Manager__c = DealDeskId;
                            //    }
                        }else{
                                cq.First_Level_Manager__c = DealDeskId;
                                cq.Second_Level_Manager__c = DealDeskId;
                        }
         //End new If Statement for ICOM-1154
                } 
  
            }
        }
    }
}