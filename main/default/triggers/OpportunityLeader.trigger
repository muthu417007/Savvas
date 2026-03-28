trigger OpportunityLeader on Opportunity (before insert,before update,after insert,after update) {
    
    //local parameters
    /* Commented Out because No longer need to push Opportunity to OneCRM
    List<Opportunity> localOpportunities = new List<Opportunity>();
    Id networkId=null;
    String myConn = System.Label.OneCRM_CONN_NAME;
    Group sf2sfGroup = ([SELECT  id FROM Group where name  = 'SF2SF Users']);
    //System.debug('the group id is = ' + String.valueOf(sf2sfGroup.Id) );
    
    List<GroupMember> sf2sfMembers = new List<GroupMember>();
    sf2sfMembers = ([SELECT Id, UserOrGroupId FROM GroupMember WHERE GroupId = :sf2sfGroup.Id]);
    //System.debug(' Did we get to the group? size= ' + sf2sfMembers.size());
    */
    
    if(trigger.isbefore){
        for(Opportunity o:Trigger.new){
            if (o.Opportunity_Leader__c==null){
                o.Opportunity_Leader__c = o.Ownerid;
            }
        }  
       /* Commented Out because No longer need to push Opportunity to OneCRM
       if(trigger.isInsert){
            // 01/12/2017 CP - only share records created in this org, and that match the criteria of owner in group SF2SF Users
            
            for (Opportunity newOpportunity : TRIGGER.new) {
               for (GroupMember sf2sfuser : sf2sfMembers ) {
                   if (newOpportunity.OwnerId.equals(sf2sfuser.UserOrGroupId)) {
                      newopportunity.Is_SF2SF_Shared__c = true;
                      newopportunity.Market__c = 'US';
                      newopportunity.Line_of_Business__c = 'Schools';
                      newopportunity.Business_unit__c = 'Pearson Assessment';
                      newopportunity.Group__c = 'School Assessments';
                      localOpportunities.add(newOpportunity);
                  }  
                }
              } 
          }
         */
    }else{
        Set<Id> allIds = Trigger.newmap.keyset();
        Set<Id> oppIds = new set<Id>();
        for(Id thisId:allIds){
            
            if(Trigger.isupdate){
                if(Trigger.newmap.get(thisId).Opportunity_Leader__c != Trigger.oldmap.get(thisId).Opportunity_Leader__c ||Trigger.newmap.get(thisId).OwnerId != Trigger.oldmap.get(thisId).OwnerId){
                    oppIds.add(thisId);
                }
            }
            
            if(Trigger.isinsert){
            
                oppIds.add(thisId);
                /* Commented Out because No longer need to push Opportunity to OneCRM
                // 01/12/2017 - CP - to send the opptys to shared cionnection'
                 // Define connection id
                List<PartnerNetworkConnection> partnerNetConList =
                     [Select id from PartnerNetworkConnection where connectionStatus = 'Accepted' and connectionName = :myConn];
            
                 if ( partnerNetConList.size() != 0 ) {
                     networkId= partnerNetConList.get(0).Id;
                 }
              
                  // only share records created in this org, and that match the criteria of owner in group SF2SF Users
                  for (Opportunity newOpportunity : TRIGGER.new) {
                      for (GroupMember sf2sfuser : sf2sfMembers ) {
                          System.debug('newOpportunity.OwnerId.equals= ' + newOpportunity.OwnerId + ' -- sf2sfuser.UserOrGroupId= '+ sf2sfuser.UserOrGroupId );
                          if (newOpportunity.ConnectionReceivedId == null && newOpportunity.OwnerId.equals(sf2sfuser.UserOrGroupId)) {
                              localOpportunities.add(newOpportunity);
                              System.debug(' sf2sf shared is ' + newOpportunity.Is_SF2SF_Shared__c);
                          }  
                      }
                  }
               if (localOpportunities.size() > 0) {
                      List<PartnerNetworkRecordConnection> opptyConnections =  new  List<PartnerNetworkRecordConnection>();
            
                      for (Opportunity newOppty : localOpportunities) {
                              PartnerNetworkRecordConnection newConnection =
                                new PartnerNetworkRecordConnection();
                                    newConnection.ConnectionId = networkId;
                                    newConnection.LocalRecordId = newOppty.Id;
                                    newConnection.SendClosedTasks = false;
                                    newConnection.SendOpenTasks = false;
                                    newConnection.SendEmails = false;
                                    //newConnection.ParentRecordId = newOppty.AccountId); we have no account mapping
                                opptyConnections.add(newConnection);
                      }
                     if (opptyConnections.size() > 0 ) {
                             database.insert(opptyConnections);
                      }
                }
                */
                
            }
            
        }
        if(oppIds.size()>0){
            OpportunityTeamProcessor.createOpportunityTeamMember(oppIds); 
        }
    } 
}