/**************************************************************************************** 
* @Class Name  - scc_profileDetailController
* @description - class to get User details
* @Created By  - CTS-Varshaa
* @Created On - 2024-07-28
* ***************************************************************************************/ 
public without sharing class scc_profileDetailController {
    /**
*  Description: This method will get user details and return data in wrapper      
*  @name: getUserDetails
*  @param: NA
*  @return: profileDetailWrapper
*/
    @AuraEnabled(cacheable=true)
    public static profileDetailWrapper getUserDetails(){
        Id userId = UserInfo.getUserId(); 
        List<user> usr= new List<User>();
        profileDetailWrapper profile = new profileDetailWrapper();
        User userdata=[SELECT Id,Name,Email,Account.SAP_Account_Id__c,Account.Type,Account.Name,Account.BillingCountry,Account.BillingCity,Account.BillingState ,Account.BillingStreet,Account.BillingPostalCode,Ordering_Enabled__c,CheckStatusPriceAvailability__c,AllowDropShip_Enabled__c FROM User where Id=:userId];
        if(userdata !=null)
        {
            profile.Name = userdata.Name;
            profile.Email = userdata.Email;
            profile.AccountId = userdata.Account.SAP_Account_Id__c;
            profile.street = userdata.Account.BillingStreet;
            profile.state = userdata.Account.BillingState;
            profile.city = userdata.Account.BillingCity;
            profile.country = userdata.Account.BillingCountry;
            profile.code = userdata.Account.BillingPostalCode;
            profile.School_District = userdata.Account.Name;
            profile.AccountType=userdata.Account.Type;
            profile.Ordering_Enabled = userdata.Ordering_Enabled__c;
            profile.CheckStatusPriceAvailability = userdata.CheckStatusPriceAvailability__c;
            profile.AllowDropShip_Enabled = userdata.AllowDropShip_Enabled__c;           
        }
        return profile;          
    }
    public class profileDetailWrapper{
        
        @AuraEnabled public String Name;
        @AuraEnabled public String Email;
        @AuraEnabled public String AccountId;
        @AuraEnabled public String street;
        @AuraEnabled public String state;
        @AuraEnabled public String city;
        @AuraEnabled public String country;
        @AuraEnabled public String code;
        @AuraEnabled public String AccountType;
        @AuraEnabled public Boolean Ordering_Enabled;
        @AuraEnabled public Boolean CheckStatusPriceAvailability;
        @AuraEnabled public Boolean AllowDropShip_Enabled;
        @AuraEnabled public String School_District;
        
    }
}