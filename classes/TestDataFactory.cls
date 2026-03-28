//  This is a test Utility Class that creates test data.
//  Data that can be created are, accounts, contacts, opportunities and cases
@isTest
public class TestDataFactory {
    //Creates accounts with corresponding Opportunities and contacts
    //First parameter identifies how many accounts will be created
    //Second parameter identifies how many opportunities will be created per account
    //Third parameter identifies how many contacts will be created per account
    public static List<Account> createAccountsWithOppsAndCont(Integer numAccts, Integer numOppsPerAcct,Integer numContPerAcct) {
        List<Account> accts = new List<Account>();
        Recordtype r = [select ID, name,isactive,SobjectType from recordtype where sObjectType='Account' and name like '%Schools%' limit 1];
        Integer rand=math.round(Math.random()*1000);
        for(Integer i=0;i<numAccts;i++) {
            Account a = new Account(Name='TestAccount' + i,Recordtypeid=r.Id,type='Public School',BillingCity='New York',BillingStreet=String.valueOf(rand)+' Hudson Street',BillingPostalCode='10013',BillingState='NY',BillingCountry='United States');
            accts.add(a);
        }
        insert accts;
        
        List<Opportunity> opps = new List<Opportunity>();
        List<Contact> cont = new List<Contact>();
        for (Integer j=0;j<numAccts;j++) {
            Account acct = accts[j];
            // For each account just inserted, add opportunities
            for (Integer k=0;k<numOppsPerAcct;k++) {
                opps.add(new Opportunity(Name=acct.Name + ' Opportunity ' + k,
                                       StageName='Prospect',
                                       type='New',
                                       Amount=1000,
                                       Total_Contract_Value__c=1001,
                                       Probability=10,
                                       LeadSource='Employee Referral',
                                       CloseDate=System.today().addMonths(1),
                                       AccountId=acct.Id));
            }
            //for each account just inserted, add a contact
            for (Integer c=0;c<numContPerAcct;c++){
                cont.add(new Contact(FirstName='Test'+c,
                                     LastName='Contact'+c,
                                     AccountId=acct.ID,
                                     Email='Test'+c+'.'+'Contact'+c+'@test.com'));
            }
        }
        // Insert all opportunities and contacts for all accounts.
        insert opps;
        insert cont;
        return accts;
    }
    
    //Class that creates cases for each contact and returns list of cases
    //first parameter accepts the list of contacts.  Need to provide a list of contacts with ID, accountId
    //Second parameter identifies how many cases will be created for each contact
    public static List<case> createCasesOnAccount(List<Contact> contList,Integer numCases){
        list<case> caseList=new List<case>();
        Recordtype rt=[select ID, name,isactive,SobjectType from recordtype where sObjectType='case' and name like '%customer%' limit 1];
        For(Contact c:contList){
            for(Integer cs=0;cs<numCases;cs++){
                caseList.add(new case(Recordtypeid=rt.Id,
                                     contactid=c.id,
                                     accountid=c.accountId,
                                     status='New',
                                     Origin='Phone',
                                     subject='Test Case: '+c.id+'-'+cs
                                     ));
            }
        }
        insert caseList;
        return caseList;
    }
    public static Id createAccount(){
        Account theAccount = new Account();
        theAccount.Name = 'testAcc';
        theAccount.SAP_Account_Id__c = '123456';
        theAccount.BillingCity = 'BCity';
        theAccount.BillingCountry = 'BCountry';
        theAccount.BillingStreet = 'BStreet';
        theAccount.BillingState = 'BState';
        theAccount.BillingPostalCode = '23201';
        insert theAccount;
        return theAccount.Id;
    }
    public static ID createContact(Id accID){
        Contact theCon = new Contact();
        theCon.LastName = 'testContact';
        theCon.FirstName = 'testCon';
        theCon.AccountId = accID;
        theCon.Email = 'Abc@gmail.com';
        theCon.Phone = '1234';
        insert theCon;
        return theCon.Id;
        
    }   
    public static case createCase(Id accId, Id conId, string caseDesc){
        Case theCase = new Case();
        theCase.AccountId = accId;
        theCase.ContactId = conId;
        theCase.Subject = 'HomeSchoolTest';
        theCase.Status = 'New';
        theCase.Origin = 'Phone';
        theCase.Case_Role__c = 'HomeSchool Parent'; //W-012409 JC 3/1/23 Added because the test was failing because Case Role is reequired for case insert
        theCase.Description = caseDesc;
        theCase.Email_Address__c = 'Abc@gmail.com';
        insert theCase;
        return theCase;
        
    }
    public static Product2 createProduct(String pdtName, String cameleonId, String pdtDesc){
        Product2 pdt = new Product2();
		pdt.Name = pdtName;
		pdt.Cameleon_External_ID__c = cameleonId;
		pdt.Description = pdtDesc;
		insert pdt;
        return pdt;
    }
}