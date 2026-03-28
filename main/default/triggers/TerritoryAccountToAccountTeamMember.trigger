trigger TerritoryAccountToAccountTeamMember on TerritoryAccount__c (before delete, before insert) {
    
    Set<id> accountIdSet = new Set<id>(); // Declare set of affected Account ids across all triggered TerritoryAccount records
    Set<id> territoryIdSet = new Set<id>(); // Declare set of affected Territory ids across all triggered TerritoryAccount records
    Set<id> userIdSet = new Set<id>(); // Declare set of affected User ids across all triggered TerritoryAccount records' Territories
    Id thisTerritoryId; // Declare variable for one Territory record's Id
    Id thisAccountId; // Declare variable for one Account record's Id
    Map<Id,string> thisTerritoryUserIdToRoleMap = new map<id,string>(); // Declare map of User Id to Role for a single Territory
    Set<Id> thisTerritoryUserIds = new set<id>(); // Declare set of affected User ids for a single Territory
    Set<AccountTeamMember> atmstodelete = new Set<AccountTeamMember>(); 
    List<AccountTeamMember> atmstodeletelist = new List<AccountTeamMember>();// Declare list of AccountTeamMembers to delete
    Set<AccountTeamMember> atmstoinsert = new Set<AccountTeamMember>(); 
    List<AccountTeamMember> atmstoinsertlist = new List<AccountTeamMember>(); // Declare list of AccountTeamMembers to insert

    if (Trigger.isDelete) { // Begin code unique to Delete trigger
        for(TerritoryAccount__c ta: Trigger.old){ // Loop through all TerritoryAccount records that initiated the trigger
            accountIdSet.add(ta.Account__c); // Populate set  of affected Account ids
            territoryIdSet.add(ta.Territory__c); // Populate set of affected Territory ids
        }
        
        List<TerritoryUser__c> tuList = [Select Id,Name,User__c,Territory__c,TeamMemberRole__c from TerritoryUser__c where Territory__c in :territoryIdSet limit 50000]; // Query for list of affected TerritoryUser__c records
    
        if(tulist.size()>0){ // Only continue if TerritoryUsers exist for the Territory(ies) related to the TerritoryAccount record(s) initiating the trigger
        
            for(TerritoryUser__c tu: tulist){ // Loop through all affected User records
                userIdSet.add(tu.User__c); // Populate set of affected User ids
            }
            
            List<AccountTeamMember> atmList = [Select Id,AccountId,UserId,TeamMemberRole from AccountTeamMember where AccountId in :accountidset and UserId in :useridset limit 50000]; // Query for list of affected AccountTeamMember records
            if(atmList.size()>0){ // Only continue if AccountTeamMembers exist for the Account(s) and User(s) related to the TerritoryAccount record(s) initiating the trigger
                for(TerritoryAccount__c ta: Trigger.old){ // Loop through all TerritoryAccount records that initiated the trigger
                    
                    thisterritoryid = ta.Territory__c; // This TerritoryAccount record's Territory Id
                    thisaccountid = ta.Account__c; // This TerritoryAccount record's Account Id
                    
                    for(TerritoryUser__c tu:tulist){ // Loop through all TerritoryUsers queried earlier for all TerritoryAccount records that initiated the trigger
                        if(tu.Territory__c == thisterritoryid){ // If this TerritoryUser (inner For loop) is related to the same Territory as this TerritoryAccount (outer For loop)
                            thisterritoryuseridtorolemap.put(tu.User__c,tu.TeamMemberRole__c); // Add this UserId/TeamMemberRole combination to the map
                        }
                    }
                    thisterritoryuserids=thisterritoryuseridtorolemap.keyset(); // Get the unique UserIds from the UserId/TeamMemberRole map generated in For loop just above this
                    for(AccountTeamMember atm:atmlist){ // Loop through all AccountTeamMembers queried earlier for all TerritoryAccountrecords that initiated the trigger
                        if(atm.AccountId==thisaccountid){ // If this AccountTeamMember (inner For loop) is related to the same Account as this TerritoryAccount (outer For loop)
                            for(id uid:thisterritoryuserids){ // Loop through all unique UserIds from the UserId/TeamMemberRolemap generated a couple of For loops earlier
                                if(atm.UserId==uid){ // If this UserId (inner For loop) is related to the this AccountTeamMember (outer For loop)
                                    string atmrole = atm.TeamMemberRole; // Get the TeamMemberRole from the AccountTeamMember
                                    if(atmrole==thisterritoryuseridtorolemap.get(uid)){ // If this AccountTeamMember's TeamMemberRole is the same as the TerritoryUser's TeamMemberRole
                                        atmstodelete.add(atm); // Add the AccountTeamMember to the list of AccountTeamMembers to Delete
                                    }
                                }
                            }
                        }
                    }
                }
                if(atmstodelete.size()>0){ // If any AccountTeamMembers were selected for deletion
                    atmstodeletelist.addAll(atmstodelete);
                    delete atmstodeletelist; // Delete the selected AccountTeamMember records
                }
            }
        }
    } // End code unique to Delete trigger
    
    if (Trigger.isInsert) { // Begin code unique to Insert trigger
        for(TerritoryAccount__c ta: Trigger.new){ // Loop through all TerritoryAccount records that initiated the trigger
            accountIdSet.add(ta.Account__c); // Populate set  of affected Account ids
            territoryIdSet.add(ta.Territory__c); // Populate set of affected Territory ids
        }
        
        List<TerritoryUser__c> tuList = [Select Id,Name,User__c,User__r.isActive,Territory__c,TeamMemberRole__c from TerritoryUser__c where Territory__c in :territoryIdSet limit 50000]; // Query for list of affected TerritoryUser__c records
    
        if(tulist.size()>0){ // Only continue if TerritoryUsers exist for the Territory(ies) related to the TerritoryAccount record(s) initiating the trigger
    
            for(TerritoryUser__c tu: tulist){ // Loop through all affected User records
                userIdSet.add(tu.User__c); // Populate set of affected User ids
            }
        
            for(TerritoryAccount__c ta: Trigger.new){ // Loop through all TerritoryAccount records that initiated the trigger
            
                thisterritoryid = ta.Territory__c; // This TerritoryAccount record's Territory Id
                thisaccountid = ta.Account__c; // This TerritoryAccount record's Account Id
                
                for(TerritoryUser__c tu:tulist){ // Loop through all TerritoryUsers queried earlier for all TerritoryAccount records that initiated the trigger
                    if(tu.Territory__c == thisterritoryid){ // If this TerritoryUser (inner For loop) is related to the same Territory as this TerritoryAccount (outer For loop)
                        if(tu.user__r.isActive==TRUE)
                        atmstoinsert.add(new AccountTeamMember(AccountId=thisaccountid,UserId=tu.User__c,TeamMemberRole=tu.TeamMemberRole__c)); // Add a new AccountTeamMember to the list of AccountTeamMembers to Insert
                    }
                }
            }
            if(atmstoinsert.size()>0){ // If any AccountTeamMembers were generated for insertion
                atmstoinsertlist.addAll(atmstoinsert);
                insert atmstoinsertlist; // Insert the selected AccountTeamMember records
            }
        }
    
    } // End code unique to Insert trigger

}