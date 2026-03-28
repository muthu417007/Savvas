global class scc_Contact_Update_Job implements Database.Batchable<SObject>,Database.Stateful{
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        set<Id> set1 = new set<Id>();
        List<User> userList = [SELECT Contact.Id FROM User WHERE (NOT Email LIKE '%invalid%') AND Contact.Email != null];
        
        for(User u :userList){
            set1.add(u.contact.id);
        }
        String queryForContacts = 'Select Id, Email From Contact Where (NOT Email LIKE '+'\'%@savvas.com%\''+') AND Id NOT In:set1';
        return Database.getQueryLocator(queryForContacts);
    }
    global void execute(Database.BatchableContext BC, List<Contact> scope)
    {
        for(Contact con : scope)
        {
            con.Email = con.Email + '.invalid';
        }
        //update scope;
    }
    global void finish(Database.BatchableContext BC){
        
    }
}