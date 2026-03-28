public class AccountAssetsController {
    
    private ApexPages.StandardController controller {get; set;}
    public Account a;
    public List<assetSobjectMashupSoapSforceCom.sObject_x> records; 
    
    public AccountAssetsController(ApexPages.StandardController controller) {
        this.controller = controller;
        this.a = (Account)controller.getRecord();
    }
    
    public List<assetmashuprecord__c> getRecords(){
        account thisaccount=[select A_I_SFDC_Account_ID__c from Account where id=:a.id limit 1];
        string acctid=thisaccount.A_I_SFDC_Account_ID__c;
        assetMashupSoapSforceCom.Soap sp = new assetMashupSoapSforceCom.Soap();
        
        String username = 'icomapi@pearson.com.icom';
        AISoapLogin__c cs = AISoapLogin__c.getInstance('Default');
        string Base64EncodedAES256Password = cs.Base64EncodedAES256Password__c;
        string Base64EncodedAES256CryptoKey = cs.Base64EncodedAES256CryptoKey__c;
        blob AES256Password = EncodingUtil.base64Decode(Base64EncodedAES256Password);
        blob AES256CryptoKey = EncodingUtil.base64Decode(Base64EncodedAES256CryptoKey);
        blob passwordblob = Crypto.decryptWithManagedIV('AES256', AES256CryptoKey, AES256Password);
        string password = passwordblob.toString();
        
        assetMashupSoapSforceCom.LoginResult loginResult = sp.login(username, password);
        
        system.debug('   loginResult ' + loginResult);
        
        assetMashupSoapSforceCom.Soap soapWebSvc = new assetMashupSoapSforceCom.Soap();
        assetMashupSoapSforceCom.SessionHeader_element sessionHeader = new assetMashupSoapSforceCom.SessionHeader_element();
        
        sessionHeader.sessionId = loginResult.sessionId; 
        
        soapWebSvc.timeout_x = 120000;
        soapWebSvc.endpoint_x = loginResult.serverUrl;
        soapWebSvc.SessionHeader = sessionHeader;       
        string acctidquoted = '\''+acctid+'\'';
//      string query = 'Select Name, Amount, CloseDate, Owner.FirstName, Owner.LastName, StageName, ImplementationFees__c, ImpSpecialist__c, Oracle_Project_Number__c, PRDl_Data_Customer_Upload_Date__c, Support_Target_Date__c, Test_Data_Delivered_Date__c, Test_Data_Est_Cnv_Complete_Date__c, PRD_Data_Est_Cnv_Complete_Date__c from Opportunity where Name Like '+impquoted+' and AccountId='+acctidquoted;
        string query = 'Select Name, Product2.Name, SerialNumber, InstallDate, Quantity, Contact.FirstName, Contact.LastName, Status from Asset where AccountId='+acctidquoted+' Order By LastModifiedDate DESC Limit 1000';

        List<assetmashuprecord__c> assetrecordslist = new List<assetmashuprecord__c>();
        Date tdy = system.today();
        assetrecordslist.add(new assetmashuprecord__c(Name='There was an error querying Implementations from the legacy instance. Verify the A&I SFDC Account ID in the Account Integration Detail section above.'));
        try{
            assetMashupSoapSforceCom.QueryResult qr = soapWebSvc.query(query);
            records=qr.records;
            assetrecordslist.clear();
            for(assetSobjectMashupSoapSforceCom.sObject_x r:records){
                system.debug(r);
                assetmashuprecord__c assetrecord = new assetmashuprecord__c();
                assetrecord.Name=r.Name;
                assetrecord.Product2Name__c=r.Product2Name;
                assetrecord.SerialNumber__c=r.SerialNumber;
                if(string.isnotblank(r.InstallDate)){
                    assetrecord.InstallDate__c=date.valueof(r.InstallDate);
                }
                assetrecord.Quantity__c=r.Quantity;
                if(string.isnotblank(r.FirstName)){
                    assetrecord.ContactFirstName__c=r.FirstName;
                }
                if(string.isnotblank(r.LastName)){
                    assetrecord.ContactLastName__c=r.LastName;
                }
                if(string.isnotblank(r.FirstName) || string.isnotblank(r.LastName)){
                    assetrecord.ContactName__c=r.FirstName+' '+r.LastName;
                }
                assetrecord.Status__c=r.Status;
                assetrecordslist.add(assetrecord);
            }
            } catch (Exception e) {
                system.debug(e);
            }
        return assetrecordslist;
    }
}