trigger TerritoryUserToAccountTeamMember on TerritoryUser__c (before delete, after insert, after update) {
    Set<String> UserToTerritoryMap = new Set<String>();
    Set<id> territoryIdSet = new Set<id>(); // Declare set of affected Territory ids across all triggered TerritoryUser records
    Set<id> userIdSet = new Set<id>(); // Declare set of affected User ids across all triggered TerritoryUser records
    Set<id> accountIdSet = new Set<id>();
    Set<String> TerritoryToAccountMap = new Set<String>();
    Set<String> UserToAccountMap = new Set<String>();
    List<AccountTeamMember> atmstodelete = new List<AccountTeamMember>(); // Declare list of AccountTeamMembers to delete
    List<AccountTeamMember> atmstoinsert = new List<AccountTeamMember>(); // Declare list of AccountTeamMembers to insert
    
    if (Trigger.isDelete) { // Begin code unique to Delete trigger
        for(TerritoryUser__c tu: Trigger.old){ // Loop through all TerritoryUser records that initiated the trigger
            BatchDeleteATMsForTerritoryUser myBatchObject = new BatchDeleteATMsForTerritoryUser(tu.id);
            Database.executeBatch(myBatchObject);
        }

    } // End code unique to Delete trigger
    
    if (Trigger.isInsert || Trigger.isUpdate) { // Begin code unique to Insert/Update trigger
        for(TerritoryUser__c tu: Trigger.new){ // Loop through all TerritoryUser records that initiated the trigger
            BatchInsertATMsForTerritoryUser myBatchObject = new BatchInsertATMsForTerritoryUser(tu.id);
            Database.executeBatch(myBatchObject);
        }
    } // End code unique to Insert trigger

}