global class Savvas_SSO_UserProvisioningBatch implements Database.Batchable<Savvas_SSO_UserProvisioningBatch.RequestBody>, Database.Stateful{
    
    global Integer index;
    global Map<Integer, String> errorMap;
    global Map<Integer, String> successMap;
    global Savvas_SSO_UserProvisioningBatch(){
        errorMap = new Map<Integer, String>();
        successMap = new Map<Integer, String>();
        index = 0;
    }

    public Iterable<RequestBody> start(Database.BatchableContext bc){
        return new userProvisioningIterator();
    }

    public void execute(Database.BatchableContext bc, List<RequestBody> scope){
        try{
            for(RequestBody rb : scope){
                index++;
                List<User> userList = Savvas_SSO_UserProvisioningHelper.getUserList(rb.email);
                if(!userList.isEmpty()){
                    Savvas_SSO_UserProvisioningHelper.LogDetailsWrapper ldw = Savvas_SSO_UserProvisioningHelper.updateUserAccess(userList[0], rb.appName);
                    if(ldw.status){ 
                        successMap.put(index, rb.email+','+rb.firstName+','+rb.lastName+','+rb.appName+','+rb.accountId+','+rb.contactId+','+ldw.userId+','+ldw.permId+','+ldw.status+',ACCESS_GRANTED\n');
                    }
                    else{
                        errorMap.put(index, rb.email+','+rb.firstName+','+rb.lastName+','+rb.appName+','+rb.accountId+','+rb.contactId+',NA,NA,'+ldw.status+','+ldw.message+'\n');
                    }
                }
                else{
                    List<Contact> contactList = Savvas_SSO_UserProvisioningHelper.getContactList(rb.email, rb.accountId, rb.contactId);
                    if(!contactList.isEmpty()){
                        Savvas_SSO_UserProvisioningHelper.LogDetailsWrapper ldw = Savvas_SSO_UserProvisioningHelper.registerNewUser(rb.email, rb.firstName, rb.lastName, contactList[0], rb.appName);
                        if(ldw.status){
                            successMap.put(index, rb.email+','+rb.firstName+','+rb.lastName+','+rb.appName+','+rb.accountId+','+rb.contactId+','+ldw.userId+','+ldw.permId+','+ldw.status+',USER_CREATED\n');
                        }                    
                        else{
                            errorMap.put(index, rb.email+','+rb.firstName+','+rb.lastName+','+rb.appName+','+rb.accountId+','+rb.contactId+',NA,NA,'+ldw.status+','+ldw.message+'\n');
                        }
                    }
                    else{
                        errorMap.put(index, rb.email+','+rb.firstName+','+rb.lastName+','+rb.appName+','+rb.accountId+','+rb.contactId+',NA,NA,false,CONTACT_NOT_FOUND\n');
                    }
                }
            }
        }
        catch(Exception e) {
            System.debug(e.getMessage()+ ' --> ' +e.getLineNumber());
        }
    }

    global void finish(Database.BatchableContext context) {
        try{
            if(!successMap.isEmpty() || !errorMap.isEmpty()) {
                //Send an email to the User after your batch completes
                AsyncApexJob a = [
                    SELECT id, ApexClassId, JobItemsProcessed, TotalJobItems, NumberOfErrors, CreatedBy.Email
                    FROM AsyncApexJob
                    WHERE id = :context.getJobId()
                    LIMIT 1
                ];
                Integer recordsSize = errorMap.size() + successMap.size();
                String body = 'Your batch job '
                    + 'Savvas_SSO_UserProvisioningBatch '
                    + 'has finished. \n'
                    + 'There were total '
                    +  recordsSize
                    + ' records. Please find the attached success and error records CSV.';
                String subject = 'Account - Apex Batch Result for Savvas_SSO_UserProvisioningBatch';
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                Messaging.EmailFileAttachment[] emailAttList = new List<Messaging.EmailFileAttachment>();
    
                if(!errorMap.isEmpty()){
                    String finalstr = 'Email, FirstName, LastName, AppName, AccountId, ContactId, UserID, PSA ID, Success, Message \n';               
                    String attName = 'ErrorLog ' + system.now().format('YYYYMMDDhhmm') + '.csv';
                    for(Integer key  : errorMap.keySet()){
                        string data = errorMap.get(key);
                        finalstr = finalstr +data;
                    }
                    // Create the email attachment    
                    Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
                    efa.setFileName(attName);
                    efa.setBody(Blob.valueOf(finalstr));
                    emailAttList.add(efa);
                }
    
                if(! successMap.isEmpty()) {
                    String finalstr = 'Email, FirstName, LastName, AppName, AccountId, ContactId, UserID, PSA ID, Success, Message \n';               
                    String attName = 'SuccessLog ' + system.now().format('YYYYMMDDhhmm') + '.csv';
                    for(Integer key  : successMap.keySet()){
                        string data = successMap.get(key);
                        finalstr = finalstr +data;
                    }
                    // Create the email attachment    
                    Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
                    efa.setFileName(attName);
                    efa.setBody(Blob.valueOf(finalstr));
                    emailAttList.add(efa);
                }
    
                // Sets the paramaters of the email
                email.setSubject( subject );
                email.setToAddresses( new String[] {a.CreatedBy.Email} );
                email.setPlainTextBody( body );
                email.setFileAttachments(emailAttList);
    
                // Sends the email
                Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
            }
        }
        catch(Exception e){
            System.debug(e.getMessage()+ ' --> ' +e.getLineNumber());
        }        
    }

    public class RequestBody {
        public String firstName;
        public String lastName;
        public String email;
        public String accountId;
        public String contactId;
        public String appName;

        public RequestBody(String firstName, String lastName, String email, String accountId, String contactId, String appName){
            this.firstName = firstName;
            this.lastName = lastName;
            this.email = email;
            this.accountId = accountId;
            this.contactId = contactId;
            this.appName = appName;
        }
    }

    @TestVisible
    private without sharing class userProvisioningIterator implements Iterable<RequestBody>, Iterator<RequestBody> {
        private List<RequestBody> requestList;
        private Integer index;
        // Constructor that initializes the list of users from CSV sheet.
        public userProvisioningIterator(){
            requestList = new List<RequestBody>();
            List<ContentVersion> contentVersionList = [SELECT VersionData, Title FROM ContentVersion WHERE Title = 'SavvasSSODataLoad' AND IsLatest=true];
            ContentVersion contentVersion = (ContentVersion)contentVersionList.get(0);
            List<List<String>> csvRecordList =  Savvas_SSO_CSVParser.doParse(contentVersion.versionData);
            List<String> fieldNames = csvRecordList.remove(0);
            while (csvRecordList.size() > 0) {
                List<String> row = csvRecordList.remove(0);
                RequestBody request = new RequestBody(row[0],row[1],row[2],row[3],row[4],row[5]);
                requestList.add(request);
            }
            index = 0;
        }
        // Returns an iterator for the RequestBody Wrapper.
        public Iterator<RequestBody> iterator() {
          return this;
        }
        // Returns true if iteration has more elements.
        public Boolean hasNext() {
          return index < requestList.size();
        }
        public RequestBody next() {
            if (!hasNext()) {
                return null;
            }
            RequestBody rb = requestList.get(index);
            index++;
            return rb;
        }
    }
}