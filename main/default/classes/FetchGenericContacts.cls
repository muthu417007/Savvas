/* -----------------------------------------------------------------------------------------------------------------------
Name:        FetchGenericContacts
WI:			 W-010962
Description: This is the new class created which will be called from 'massSampleGenericContact' LWC component
			 to display the Mass sample Generic Contact details

Date         Version  Author             Summary of Changes
-----------  -------  -----------------  ------------------------------------------------------------------------------
12/14/2022     1.0    Soundhariya     Initial Release
------------------------------------------------------------------------------------------------------------------*/
public with sharing class FetchGenericContacts{
    @AuraEnabled(cacheable=true)
    public static List<GenericWrapper> searchSampleContacts(Id massSampleId){
        
		List<GenericWrapper> genericContactsList = new list<GenericWrapper>();
		GenericWrapper genericConWrap;
        for(Mass_Sample_Generic_Contacts__c genCon: [Select ID, Name,Account__r.name,Account__c,Generic_Contact__c,Account__r.BillingCountry,
                                                     Account__r.BillingCity,Account__r.BillingState, Account__r.MDR_PID__c,Account__r.BillingPostalCode,
                                                     Account__r.Type FROM Mass_Sample_Generic_Contacts__c WHERE Mass_Sample_Generic__c = :massSampleId]){
			genericConWrap = new GenericWrapper();
            genericConWrap.genericId = genCon.ID;
			genericConWrap.name = genCon.Name;
			genericConWrap.nameLink = '/'+genCon.ID;
            genericConWrap.accID = '/'+genCon.Account__c;
            genericConWrap.accName = genCon.Account__r.name;
            genericConWrap.conName = genCon.Generic_Contact__c;
            genericConWrap.accBillCity = genCon.Account__r.BillingCity;
			genericConWrap.accBillState = genCon.Account__r.BillingState;
            genericConWrap.accBillCountry = genCon.Account__r.BillingCountry;
			genericConWrap.accMDR = genCon.Account__r.MDR_PID__c;
            genericConWrap.accBillCityLink = genCon.Account__r.BillingCity != null ? '/'+genCon.Account__c : null;
			genericConWrap.accBillStateLink = genCon.Account__r.BillingState != null ? '/'+genCon.Account__c : null;
            genericConWrap.accBillCountryLink = genCon.Account__r.BillingCountry != null ? '/'+genCon.Account__c : null;
			genericConWrap.accMDRLink = genCon.Account__r.MDR_PID__c != null ? '/'+genCon.Account__c : null;
            genericConWrap.accBillZip =  genCon.Account__r.BillingPostalCode;  
            genericConWrap.accBillZipLink = genCon.Account__r.BillingPostalCode != null ? '/'+genCon.Account__c : null;
            genericConWrap.accType =  genCon.Account__r.Type;  
            genericConWrap.accTypeLink = genCon.Account__r.Type != null ? '/'+genCon.Account__c : null;
			genericContactsList.add(genericConWrap);	
		}
		system.debug('genericContactsList: '+genericContactsList);
		system.debug('genericContactsList size: '+genericContactsList.size());
		return genericContactsList;
    }
	//W-010962 wrapper class to show values on LWC
    public class GenericWrapper{	
		@AuraEnabled
        public String name;
        @AuraEnabled
        public String nameLink;
        @AuraEnabled
        public String genericId;
        @AuraEnabled
        public String accID;
        @AuraEnabled
        public String accName;
        @AuraEnabled
        public String conName;
        @AuraEnabled
        public String accBillCity;
		@AuraEnabled
        public String accBillCityLink;
        @AuraEnabled
        public String accBillState;
		@AuraEnabled
        public String accBillStateLink;
        @AuraEnabled
        public String accBillCountry;
		@AuraEnabled
        public String accBillCountryLink;
        @AuraEnabled
        public String accMDR;
		@AuraEnabled
        public String accMDRLink;
        @AuraEnabled
        public String accBillZip;
        @AuraEnabled
        public String accBillZipLink;
        @AuraEnabled
        public String accType;
        @AuraEnabled
        public String accTypeLink;
    }

}