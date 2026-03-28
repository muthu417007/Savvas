trigger KnowledgeUserCheckbox on User (before insert, before update) {
    for(User usr: Trigger.new){
        If (usr.UserPermissionsKnowledgeUser == true){
           usr.Knowledge_License__c = true;
        } else {
            usr.Knowledge_License__c = false;
        }
    }
}