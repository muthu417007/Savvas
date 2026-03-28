/************************************************************************ 
Name: RPAMatchedAccountController
Purpose: W-012205 - Controller for the LWC component that displays the list of Accounts that found the match during the search.
History:
VERSION AUTHOR DATE       DETAIL                DESCRIPITOPN
1.0     CTS               INITIAL DEVELOPMENT   Methods that returns the list of accounts that found a match with data returned by ML APIs.
												These accounts are listed on LWC component placed on Order detail page on Accounts matched tab.
************************************************************************/
public class RPAMatchedAccountController {
    
    @AuraEnabled
    public static list<AccountSearchWrapper> getMatchedAccounts(String orderId){
        set<String> accntAddIds = new set<String>();
        set<String> accntIds = new set<String>();
        list<AccountSearchWrapper> lstAccAddWrapperToReturn = new list<AccountSearchWrapper>();
          
        if(String.isNotBlank(orderId)){
            list<Order__c> lstOrders = new list<Order__c>{[SELECT Id, Account_Address_Ids__c 
                                                           FROM Order__c 
                                                           WHERE Id =:orderId LIMIT 1]};
                if(String.isNotBlank(lstOrders[0].Account_Address_Ids__c)){
                    for(String str : lstOrders[0].Account_Address_Ids__c.split(',')){
                        if(str.startsWith('001'))
                            accntIds.add(str);
                        else
                        	accntAddIds.add(str);
                    }
                }
            
            AccountSearchWrapper accsw;
            if(!accntAddIds.isEmpty()){
                for(Account_Addresses__c addrs: [SELECT Name, Account__c, Account__r.Name, Address_1__c, Address_2__c, Address_Type__c, City__c, Country__c, Id, Source__c, State__c, Zip_Code__c 
                                                 FROM Account_Addresses__c 
                                                 WHERE Id IN: accntAddIds])
                {
                    accsw = new AccountSearchWrapper();
                    accsw.accountName = addrs.Account__r.Name;
                    accsw.street = String.isNotBlank(addrs.Address_1__c)?addrs.Address_1__c:addrs.Address_2__c;
                    accsw.city = addrs.City__c;
                    accsw.state = addrs.State__c;
                    accsw.zip = addrs.Zip_Code__c;
                    accsw.accAddName = addrs.Name;
                    accsw.accountLink = '/'+addrs.Account__c;
                    accsw.accAddLink = '/'+addrs.Id;
                    accsw.source = addrs.Source__c;
                    lstAccAddWrapperToReturn.add(accsw);
                }
            }
            else if(!accntIds.isEmpty()){
                for(Account acc : [SELECT Id, Name, BillingCity, BillingCountry, BillingPostalCode, BillingState, BillingStreet 
                                   FROM Account 
                                   WHERE Id IN : accntIds])
                {
                    accsw = new AccountSearchWrapper();
                    accsw.accountName = acc.Name;
                    accsw.street = String.isNotBlank(acc.BillingStreet)?acc.BillingStreet:null;
                    accsw.city = acc.BillingCity;
                    accsw.state = acc.BillingState;
                    accsw.zip = acc.BillingPostalCode;
                    accsw.accountLink = '/'+acc.Id;
                    lstAccAddWrapperToReturn.add(accsw);
                }
            }
        }
        return lstAccAddWrapperToReturn;
    }
    
     //wrapper class to show values on LWC
    public class AccountSearchWrapper
    {
        @AuraEnabled
        public String accountName;
        @AuraEnabled
        public String street;
        @AuraEnabled
        public String city;
        @AuraEnabled
        public String state;
        @AuraEnabled
        public String zip;
        @AuraEnabled
        public String accAddName;
        @AuraEnabled
        public String accountLink;
        @AuraEnabled
        public String accAddLink;
        @AuraEnabled
        public String source; 
    }
}