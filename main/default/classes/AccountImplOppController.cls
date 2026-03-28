public class AccountImplOppController {
    
    private ApexPages.StandardController controller {get; set;}
    public Account a;
    public List<implOppSobjectMashupSoapSforceCom.sObject_x> records;   
    
    public AccountImplOppController(ApexPages.StandardController controller) {
        this.controller = controller;
        this.a = (Account)controller.getRecord();
    }
    
    public List<impoppmashuprecord__c> getRecords(){
        account thisaccount=[select A_I_SFDC_Account_ID__c from Account where id=:a.id limit 1];
        string acctid=thisaccount.A_I_SFDC_Account_ID__c;
        implOppMashupSoapSforceCom.Soap sp = new implOppMashupSoapSforceCom.Soap();
        
        String username = 'icomapi@pearson.com.icom';
        AISoapLogin__c cs = AISoapLogin__c.getInstance('Default');
        string Base64EncodedAES256Password = cs.Base64EncodedAES256Password__c;
        string Base64EncodedAES256CryptoKey = cs.Base64EncodedAES256CryptoKey__c;
        blob AES256Password = EncodingUtil.base64Decode(Base64EncodedAES256Password);
        blob AES256CryptoKey = EncodingUtil.base64Decode(Base64EncodedAES256CryptoKey);
        blob passwordblob = Crypto.decryptWithManagedIV('AES256', AES256CryptoKey, AES256Password);
        string password = passwordblob.toString();
        
        implOppMashupSoapSforceCom.LoginResult loginResult = sp.login(username, password);
        
        system.debug('   loginResult ' + loginResult);
        
        implOppMashupSoapSforceCom.Soap soapWebSvc = new implOppMashupSoapSforceCom.Soap();
        implOppMashupSoapSforceCom.SessionHeader_element sessionHeader = new implOppMashupSoapSforceCom.SessionHeader_element();
        
        sessionHeader.sessionId = loginResult.sessionId; 
        
        soapWebSvc.timeout_x = 120000;
        soapWebSvc.endpoint_x = loginResult.serverUrl;
        soapWebSvc.SessionHeader = sessionHeader;       
        string acctidquoted = '\''+acctid+'\'';
        string impquoted = '\'%IMP%\'';
//      string query = 'Select Name, Amount, CloseDate, Owner.FirstName, Owner.LastName, StageName, ImplementationFees__c, ImpSpecialist__c, Oracle_Project_Number__c, PRDl_Data_Customer_Upload_Date__c, Support_Target_Date__c, Test_Data_Delivered_Date__c, Test_Data_Est_Cnv_Complete_Date__c, PRD_Data_Est_Cnv_Complete_Date__c from Opportunity where Name Like '+impquoted+' and AccountId='+acctidquoted;
        string query = 'Select Name, RecordType.Name, Type, Owner.FirstName, Owner.LastName, ImplementationFees__c, Project_Management_Fees__c, Oracle_Project_Number__c, StageName, Booking_Start_Date__c, Kick_off_Call_Completed_Date__c, Support_Target_Date__c, IMP_Project_Status__c, Imp_Current_Status_Overview__c, IPP_Project_Link__c from Opportunity where Name Like '+impquoted+' and AccountId='+acctidquoted+' Order By LastModifiedDate DESC Limit 1000';

        List<impoppmashuprecord__c> impopprecordslist = new List<impoppmashuprecord__c>();
        Date tdy = system.today();
        impopprecordslist.add(new impoppmashuprecord__c(Name='There was an error querying Implementations from the legacy instance. Verify the A&I SFDC Account ID in the Account Integration Detail section above.'));
        try{
            implOppMashupSoapSforceCom.QueryResult qr = soapWebSvc.query(query);
            records=qr.records;
            impopprecordslist.clear();
            for(implOppSobjectMashupSoapSforceCom.sObject_x r:records){
                system.debug(r);
                impoppmashuprecord__c impopprecord = new impoppmashuprecord__c();
//              impopprecord.Amount__c=r.Amount;
//              if(string.isnotblank(r.CloseDate)){
//                  impopprecord.CloseDate__c=date.valueof(r.CloseDate);
//              }
                impopprecord.Name=r.Name;
                impopprecord.RecordTypeName__c=r.RecordTypeName;
                impopprecord.Type__c=r.Type;
                impopprecord.OwnerFirstName__c=r.FirstName;
                impopprecord.OwnerLastName__c=r.LastName;
                impopprecord.OwnerName__c=r.FirstName+' '+r.LastName;
                impopprecord.ImplementationFees__c=r.ImplementationFees;
                impopprecord.Project_Management_Fees__c=r.Project_Management_Fees;
                impopprecord.Oracle_Project_Number__c=r.Oracle_Project_Number;
                impopprecord.StageName__c=r.StageName;
                if(string.isnotblank(r.Booking_Start_Date)){
                    impopprecord.Booking_Start_Date__c=date.valueof(r.Booking_Start_Date);
                }
                if(string.isnotblank(r.Kick_off_Call_Completed_Date)){
                    impopprecord.Kick_off_Call_Completed_Date__c=date.valueof(r.Kick_off_Call_Completed_Date);
                }
                if(string.isnotblank(r.Support_Target_Date)){
                    impopprecord.Support_Target_Date__c=date.valueof(r.Support_Target_Date);
                }
                impopprecord.IMP_Project_Status__c=r.IMP_Project_Status;
                impopprecord.Imp_Current_Status_Overview__c=r.Imp_Current_Status_Overview;              
                if(string.isnotblank(r.IPP_Project_Link)){
                    impopprecord.IPP_Project_Link__c=r.IPP_Project_Link;
                }
                impopprecordslist.add(impopprecord);
            }
            } catch (Exception e) {
                system.debug(e);
            }
        return impopprecordslist;
    }
}