/* -----------------------------------------------------------------------------------------------------------------------
Name:        FetchMassSampleContactsClass
WI:			 W-010962
Description: This is the new class created which will be called from 'massSampleFreeContact' LWC component
			 to display the Mass Sample/Free Contact details

Date         Version  Author             Summary of Changes
-----------  -------  -----------------  ------------------------------------------------------------------------------
12/14/2022     1.0    Soundhariya     Initial Release
------------------------------------------------------------------------------------------------------------------*/
public with sharing class FetchMassSampleContactsClass{
    @AuraEnabled(cacheable=true)
    public static List<MassSampleConWrapper> searchSampleContacts(Id massSampleId){
		List<MassSampleConWrapper> sampleContactsList = new list<MassSampleConWrapper>();
		MassSampleConWrapper sampleConWrap;
        system.debug('massSampleId: '+massSampleId);
        for(SampleRequestContact__c samCon: [Select ID, Name,Contact__c,Contact__r.Firstname, Contact__r.Lastname,Contact__r.Email,Account__c,SampleRequest__c,SampleRequest__r.name, 
											 Account__r.Name,Account__r.BillingCity,Account__r.BillingState, Account__r.MDR_PID__c,CurrencyIsoCode,Account__r.BillingPostalCode
											 FROM SampleRequestContact__c WHERE SampleRequest__c = :massSampleId]){
			sampleConWrap = new MassSampleConWrapper();
            sampleConWrap.massSampleId = samCon.Id;
			sampleConWrap.name = samCon.Name;
			sampleConWrap.conFirstName = samCon.Contact__r.Firstname;
			sampleConWrap.accName = samCon.Account__r.Name;
			sampleConWrap.conEmail = samCon.Contact__r.Email;
			sampleConWrap.conLastName = samCon.Contact__r.Lastname;
			sampleConWrap.accBillCity = samCon.Account__r.BillingCity;
			sampleConWrap.accBillState = samCon.Account__r.BillingState;
			sampleConWrap.accMDR = samCon.Account__r.MDR_PID__c;
			sampleConWrap.nameLink = '/'+samCon.ID;
			sampleConWrap.conFirstNameLink = samCon.Contact__r.Firstname != null ? '/'+samCon.Contact__c : null;
			sampleConWrap.conLastNameLink = samCon.Contact__r.Lastname != null ? '/'+samCon.Contact__c : null;
			sampleConWrap.conEmailLink = samCon.Contact__r.Email != null ? '/'+samCon.Contact__c : null;
			sampleConWrap.accLink = samCon.Account__r.Name != null ? '/'+samCon.Account__c : null;
			sampleConWrap.accBillCityLink = samCon.Account__r.BillingCity != null ? '/'+samCon.Account__c : null;
			sampleConWrap.accBillStateLink = samCon.Account__r.BillingState != null ? '/'+samCon.Account__c : null;
			sampleConWrap.accMDRLink = samCon.Account__r.MDR_PID__c != null ? '/'+samCon.Account__c : null;
            sampleConWrap.currencyCode = samCon.CurrencyIsoCode;
            sampleConWrap.accBillZip =  samCon.Account__r.BillingPostalCode;  
            sampleConWrap.accBillZipLink = samCon.Account__r.BillingPostalCode != null ? '/'+samCon.Account__c : null;
			sampleContactsList.add(sampleConWrap);	
		}
		system.debug('sampleContactsList: '+sampleContactsList);
		system.debug('sampleContactsList size: '+sampleContactsList.size());
		return sampleContactsList;
    }
	//W-010962 wrapper class to show values on LWC
    public class MassSampleConWrapper
    {	
        @AuraEnabled
        public String massSampleId;
		@AuraEnabled
        public String name;
        @AuraEnabled
        public String nameLink;
        @AuraEnabled
        public String conFirstName;
		@AuraEnabled
        public String conFirstNameLink;
        @AuraEnabled
        public String conLastName;
		@AuraEnabled
        public String conLastNameLink;
		@AuraEnabled
        public String conEmail;
		@AuraEnabled
        public String conEmailLink;
		@AuraEnabled
        public String accName;
        @AuraEnabled
        public String accLink;
        @AuraEnabled
        public String accBillCity;
		@AuraEnabled
        public String accBillCityLink;
        @AuraEnabled
        public String accBillState;
		@AuraEnabled
        public String accBillStateLink;
        @AuraEnabled
        public String accMDR;
		@AuraEnabled
        public String accMDRLink;
        @AuraEnabled
        public String currencyCode;
        @AuraEnabled
        public String accBillZip;
        @AuraEnabled
        public String accBillZipLink;
    }
    @AuraEnabled
    public static List<Contact> fetchContactAccount(Id conID){
        return [Select id,accountid from Contact where id = :conID];
    }
    @AuraEnabled
    public static List<SampleRequest__c> fetchParentData(Id parentID){
        return [Select id,Number_of_Contacts__c,Number_of_Generic_Contacts__c from SampleRequest__c where id = :parentID];
    }

}