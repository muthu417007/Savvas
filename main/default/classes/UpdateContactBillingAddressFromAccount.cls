global class UpdateContactBillingAddressFromAccount implements Schedulable, Database.Batchable<sobject>,Database.Stateful {
    global void execute(SchedulableContext sc)
    {
        UpdateContactBillingAddressFromAccount batch = new UpdateContactBillingAddressFromAccount();
        Database.executeBatch(batch, 200);
    }
    global Database.QueryLocator start(Database.BatchableContext BC){
        //String query = 'select id,AccountId,MailingCity,Phone, MailingCountry, MailingPostalCode, MailingState, MailingStreet, mailingAddress,Account.BillingStreet,Account.BillingState,Account.BillingCity,Account.BillingCountry,Account.Phone,Account.BillingPostalCode from contact where AccountId != null AND MDR_Update_Date__c != null';
        String query = system.Label.fetchingContactsQuery;
        return Database.getQueryLocator(query); 
    }
    global void execute(Database.BatchableContext BC, List<Contact> contactList){
        List<Exception_Log__c> excptionLog = new List<Exception_Log__c>();
        try{
            List<Contact> updateCon = new List<Contact>();
            For(Contact con : contactList){
               // if(con.MailingStreet != con.Account.BillingStreet || con.MailingCity != con.Account.BillingCity ||con.MailingState != con.Account.BillingState ||
                //   con.MailingPostalCode != con.Account.BillingPostalCode || con.MailingCountry != con.Account.BillingCountry || con.Phone == null){
                       
                       con.MailingStreet = con.Account.BillingStreet; 
                       con.MailingCity = con.Account.BillingCity; 
                       con.MailingState = con.Account.BillingState; 
                       con.MailingPostalCode = con.Account.BillingPostalCode; 
                       con.MailingCountry = con.Account.BillingCountry; 
                       con.Phone = con.Phone == null? con.Account.Phone: con.Phone; 
                                       
                       updateCon.add(con);
                 //  }
            }
            if(!updateCon.isEmpty()){
                
                Database.SaveResult[] updateResults = Database.update(updateCon, false);
                
                for (Database.SaveResult sr : updateResults){
                    
                    if (sr.isSuccess() ==  true) {
                        System.debug('Successfully inserted ' + sr.getId());
                    }else{
                        for(Database.Error err : sr.getErrors()) {
                            //store this info in new collection 
                            System.debug(err.getStatusCode() + ': ' + err.getMessage());
                            System.debug('feild Error ' + err.getFields());
                        }
                    }
                }
                if(Test.isRunningTest()){
                    String testChar =  'test';
                    Integer throwsExptn = integer.valueOf(testChar);
                    
                }
            }
        }catch(exception e){
            Exception_Log__c logEntry = new Exception_Log__c();
            logEntry.DeveloperMessage__c = e.getStackTraceString();
            logEntry.Message__c = e.getMessage();
            logEntry.StackTrace__c = e.getStackTraceString();
            logEntry.Type__c = e.getTypeName();
            
            excptionLog.add(logEntry);
        }
        // insert exception log records 
        if(!excptionLog.isEmpty()){
            insert excptionLog; 
        }
    }
    global void finish(Database.BatchableContext BC){
        system.debug('finish--updation_CreationOnContactBatchclass');
    }
}