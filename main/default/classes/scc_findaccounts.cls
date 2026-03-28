/**************************************************************************************** 
* @Class Name  - scc_findaccounts
* @description - This class is used to find active accounts in United States and Canada
* @Created By  - CTS-Suresh Kalshetti
* @Created On - 2024-05-21
* ***************************************************************************************/ 
global class scc_findaccounts {
    /**
*  Description: This method will find account names
*  @name: findAccountNames
*  @param: String email, String zipCode
*  @return: List<Map<String, String>> 
*/
    @AuraEnabled(cacheable = true)
    global static List<Map<String, String>> findAccountNames(String email, String zipCode) {
        List<Map<String, String>> accountOptions = new List<Map<String, String>>();
        try{
            String varAccountStatus = scc_constantHelper.ACTIVE;
            String varUnitedStates = scc_constantHelper.COUNTRY_UNITED_STATES;
            String varCanada = scc_constantHelper.COUNTRY_CANADA;
            // Check if the email is provided and not blank
            if (String.isNotBlank(email)) {
                // Fetch account names associated with the contact's email
                List<Contact> contacts = [SELECT Account.Id, Account.Name FROM Contact WHERE Email = :email];            
                
                for (Contact contact : contacts) {
                    Map<String, String> accountMap = new Map<String, String>();
                    accountMap.put('accountId', contact.Account.Id); accountMap.put('accountName', contact.Account.Name);accountOptions.add(accountMap);                
                }
            }
            
            // If email is not available or not associated with any contact, fetch accounts based on zip code
            if (String.isNotBlank(zipCode)) {
                // Fetch account names and IDs based on the provided zip code           
                List<Account> accounts =[SELECT Id,Name,MDR_PID__c,Owner.Email,BillingStreet,BillingCity,BillingState,BillingPostalCode,BillingCountry,BillingLatitude,BillingLongitude,BillingGeocodeAccuracy,BillingAddress,County__c FROM Account WHERE 
                                         (BillingCountry=: varUnitedStates OR BillingCountry=: varCanada) 
                                         AND MDR_PID__c!=NULL AND Account_Status__c=:varAccountStatus AND BillingPostalCode LIKE :zipCode + '%' Order By Name  ];
                for (Account account : accounts) {
                    Map<String, String> accountMap = new Map<String, String>();
                    accountMap.put('accountId', account.Id);accountMap.put('accountName', account.Name);accountOptions.add(accountMap);
                }
            }
        }
        catch(Exception e){
            System.debug('Exception type caught: ' + e.getTypeName());    
            System.debug('Message: ' + e.getMessage());    
            System.debug('Cause: ' + e.getCause());
            System.debug('Line number: ' + e.getLineNumber());    
            System.debug('Stack trace: ' + e.getStackTraceString());
        }        
        return accountOptions;
        
    }
    /**
*  Description: This method will get buiding address
*  @name: getBuildingAddress
*  @param: String accountId
*  @return: Map<String, String>
*/
    @AuraEnabled(cacheable = true)
    global static Map<String, String> getBuildingAddress(String accountId) {
        Map<String, String> addressMap = new Map<String, String>();
        try{
            // Query to fetch the account details based on the account ID
            Account acc = [SELECT BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry, Name 
                           FROM Account WHERE Id = :accountId LIMIT 1];
            
            // If the account is found, construct the address map
            if (acc != null) {
                addressMap.put('street', acc.BillingStreet);
                addressMap.put('city', acc.BillingCity);
                addressMap.put('state', acc.BillingState);
                addressMap.put('postalCode', acc.BillingPostalCode);
                addressMap.put('country', acc.BillingCountry);
                addressMap.put('companyName', acc.Name);
            }
        }
        catch(Exception e){
            System.debug('Exception type caught: ' + e.getTypeName());    
            System.debug('Message: ' + e.getMessage());    
            System.debug('Cause: ' + e.getCause());
            System.debug('Line number: ' + e.getLineNumber());    
            System.debug('Stack trace: ' + e.getStackTraceString());
        }
        
        return addressMap;
    }       
}