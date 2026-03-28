/*
    @Author : Cognizant Team
    @Name : Savvas_SSO_AccountsSearchHelper
    @CreateDate : 11-June-2024
    @Description: Helper class for Savvas_SSO_AccountsSearchApi class
    @ModifiedBy: Cognizant Team
    @ModifiedDate: 02-July-2024
    @Ticket Number: W-015367, W-015375
*/
public without sharing class Savvas_SSO_AccountsSearchHelper {
    public class AccountWrapper{
        public String accountId;
        public String accountName;
        public String accountShippingAddress;
        public String accountCountry;
    }
    public class ContactWrapper{
        public List<Contact> contactList;
        public Boolean userFound;
    }
    /*
    *  Method Name : getContactList
    *  Description : Fecth contact using registering user's email and appName
    *  param : email, appName
    *  return : List<Contact>
    */
    public static ContactWrapper getContactList(String email, String appName){
        ContactWrapper contactWrapper = new ContactWrapper();
        contactWrapper.userFound = false;
        List<Contact> contactList = new List<Contact>();
        if(!String.isBlank(appName) && !String.isBlank(email)){
            String query =  'SELECT Id, AccountId, Account.Name, FirstName, LastName, Email, Account.ShippingAddress FROM Contact ' +
                            'WHERE Account.Account_Status__c = \'' + Savvas_SSO_ConstantsUtil.isActive + '\' ' +
                            'AND Email = \'' + String.escapeSingleQuotes(email) + '\' ' +
                            'AND Inactive__c = false ';
            if(String.escapeSingleQuotes(appName)==System.Label.Savvas_SSO_Dealer_Distributor_AppName){
                query += ' AND Account.Is_License_Allocation_Enabled_Dealer__c=true ORDER BY Account.Name';
            }
            else if(String.escapeSingleQuotes(appName)==System.Label.Savvas_SSO_Worktext_AppName){
                query += ' ORDER BY Account.Name'; 
            }
            else if(String.escapeSingleQuotes(appName)==System.Label.Savvas_SSO_VS_AppName){
                query += ' ORDER BY Account.Name';
                List<User> userList = [SELECT Id, ContactId FROM User WHERE Username=:email AND IsActive=true LIMIT 1];
                if(!userList.isEmpty()){
                    String userId = userList[0].Id;
                    List<PermissionSetAssignment> psaList = [
                        SELECT Id FROM PermissionSetAssignment 
                        WHERE AssigneeId=:userId
                        AND PermissionSet.Name=:System.Label.Savvas_Sample_Resources_Permission_Set];
                    if(!psaList.isEmpty()){
                        contactWrapper.userFound = true;
                        query = 'SELECT Id, AccountId, Account.Name, FirstName, LastName, Email, Account.ShippingAddress FROM Contact '+
                                'WHERE Id=\'' + userList[0].ContactId + '\'';
                    }
                }              
            }
            else{
                query = '';
            }
            try{
                contactList = Database.query(query);
            }
            catch (Exception e){
                System.debug(e.getLineNumber() + ' ==>' + e.getMessage());
            }      
        }
        contactWrapper.contactList = contactList;
        return contactWrapper;
    }
    /*
    *  Method Name : getAccounts
    *  Description : Fetch Accounts to return in the Account Search response to Cold Fusion
    *  param : contactList
    *  return : List<AccountWrapper>
    */
    public static List<AccountWrapper> getAccounts(List<Contact> contactList){
        List<AccountWrapper> accountsList = new List<AccountWrapper>();
        Set<Id> addedAccounts = new Set<Id>();
        try{
            for(Contact contact : contactList){
                if(!addedAccounts.contains(contact.accountId)){
                    AccountWrapper accountWrapper = new AccountWrapper();
                    accountWrapper.accountId = contact.AccountId;
                    accountWrapper.accountName = contact.Account.Name;
                    Address address = contact.Account.ShippingAddress;
                    if(address!=null){
                        String[] addr = new String[]{
                            address.street, address.city, address.state + ' ' + address.postalcode
                        };
                        for(Integer i = 2; i >= 0; i--) {
                            if(addr[i] == null) {
                                addr.remove(i);
                            }
                        }
                        accountWrapper.accountShippingAddress = String.join(addr, ', ');
                        accountWrapper.accountCountry = address.country;
                    }
                    accountsList.add(accountWrapper);
                    addedAccounts.add(contact.AccountId);
                }
            }
        }
        catch(Exception e){
            System.debug(e.getLineNumber() + ' ==>' + e.getMessage());
        }
        return accountsList;
    }
}