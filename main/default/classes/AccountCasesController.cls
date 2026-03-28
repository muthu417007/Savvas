public class AccountCasesController {
    
    private ApexPages.StandardController controller {get; set;}
    public Account a;
    public List<sobjectMashupSoapSforceCom.sObject_x> records;  
    
    public AccountCasesController(ApexPages.StandardController controller) {
        this.controller = controller;
        this.a = (Account)controller.getRecord();
    }
    
    public List<casemashuprecord__c> getRecords(){
        account thisaccount=[select A_I_SFDC_Account_ID__c from Account where id=:a.id limit 1];
        string acctid=thisaccount.A_I_SFDC_Account_ID__c;
        mashupSoapSforceCom.Soap sp = new mashupSoapSforceCom.Soap();
        
        String username = 'icomapi@pearson.com.icom';
        AISoapLogin__c cs = AISoapLogin__c.getInstance('Default');
        string Base64EncodedAES256Password = cs.Base64EncodedAES256Password__c;
        string Base64EncodedAES256CryptoKey = cs.Base64EncodedAES256CryptoKey__c;
        blob AES256Password = EncodingUtil.base64Decode(Base64EncodedAES256Password);
        blob AES256CryptoKey = EncodingUtil.base64Decode(Base64EncodedAES256CryptoKey);
        blob passwordblob = Crypto.decryptWithManagedIV('AES256', AES256CryptoKey, AES256Password);
        string password = passwordblob.toString();
        
        mashupSoapSforceCom.LoginResult loginResult = sp.login(username, password);
        
        system.debug('   loginResult ' + loginResult);
        
        mashupSoapSforceCom.Soap soapWebSvc = new mashupSoapSforceCom.Soap();
        mashupSoapSforceCom.SessionHeader_element sessionHeader = new mashupSoapSforceCom.SessionHeader_element();
        
        sessionHeader.sessionId = loginResult.sessionId; 
        
        soapWebSvc.timeout_x = 120000;
        soapWebSvc.endpoint_x = loginResult.serverUrl;
        soapWebSvc.SessionHeader = sessionHeader;       
        string acctidquoted = '\''+acctid+'\'';
        string query = 'SELECT CaseNumber,Contact.FirstName,Contact.LastName,Subject,Priority,CreatedDate,Status,Owner.Name,Type from Case where AccountId='+acctidquoted+' Order By LastModifiedDate DESC Limit 1000';

        List<casemashuprecord__c> caserecordslist = new List<casemashuprecord__c>();
        Date tdy = system.today();
        caserecordslist.add(new casemashuprecord__c(Subject__c='There was an error querying Cases from the legacy instance. Verify the A&I SFDC Account ID in the Account Integration Detail section above.'));
        try{
            mashupSoapSforceCom.QueryResult qr = soapWebSvc.query(query);
            records=qr.records;
            caserecordslist.clear();
            for(sobjectMashupSoapSforceCom.sObject_x r:records){
                system.debug(r);
                caserecordslist.add(new casemashuprecord__c(CaseNumber__c=r.CaseNumber,ContactName__c=r.FirstName+' '+r.LastName,Subject__c=r.Subject,Priority__c=r.Priority,DateOpened__c=r.CreatedDate.date(),Status__c=r.Status,Owner__c=r.Name,CaseRecordType__c=r.Type));
            }
            } catch (Exception e) {
                system.debug(e);
            }
        return caserecordslist;
    }
}