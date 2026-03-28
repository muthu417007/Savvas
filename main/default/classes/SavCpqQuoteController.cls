/*
*********************************************************
Class Name       : SavCpqQuoteController
Created Date     : 6/25/2024  
Author           : Frank Berni - Cognizant
Description      : Apex validation controller for New Cpq Quote button

History:
<Date>          <Authors Name>              <Brief Description of Change>
6/25/2024       Frank Berni                 Initial creation: Ticket W-015045 
6/26/2024       Frank Berni                 Removed getQuotesOnOpp method
6/27/2024       Frank Berni                 Added Owner.Profile.Name to getOppInfo query
7/2/2024        Frank Berni                 Added method to query Quote Pricebook so it is available to default to Quote
**********************************************************/
public with sharing class SavCpqQuoteController {
    
    /*
    *********************************************************
    Method Name    : getOppInfo
    Author         : Frank Berni
    Description    : Grabs additional fields from current Opportunity 
    Param          : String oppId
    return         : Opportunity 
    ********************************************************
    */
    @AuraEnabled(cacheable=true)
    public static Opportunity getOppInfo(String oppId) {

        List<Opportunity> opportunities = [SELECT Id, Name, AccountId, SBQQ__PrimaryQuote__c, Owner.Profile.Name FROM Opportunity WHERE Id =:oppId];

        if( opportunities.size() > 0 )  
            return opportunities.get( 0 );  
        else  
            return null;  
    }

    /*
    *********************************************************
    Method Name    : getPrimaryContact
    Author         : Frank Berni
    Description    : Grabs all related Contact Roles where IsPrimary is true and returns the first one in the list
    Param          : String oppId
    return         : OpportunityContactRole 
    ********************************************************
    */
    @AuraEnabled(cacheable=false)
    public static OpportunityContactRole getPrimaryContact(String oppId) {

        List<OpportunityContactRole> oppContact = [SELECT Id, ContactId FROM OpportunityContactRole WHERE IsPrimary = TRUE AND OpportunityID =:oppId LIMIT 1];

        if( oppContact.size() > 0 )  
            return oppContact.get( 0 );  
        else  
            return null;  
    }

    /*
    *********************************************************
    Method Name    : getQuotePricebook
    Author         : Frank Berni
    Description    : Grabs additional the Quote Pricebook
    Param          : 
    return         : Pricebook2 
    ********************************************************
    */
    @AuraEnabled(cacheable=true)
    public static Pricebook2 getQuotePricebook() {

        List<Pricebook2> pricebooks = [SELECT Id, Name FROM Pricebook2 WHERE Name = 'Quote Pricebook'];

        if( pricebooks.size() > 0 )  
            return pricebooks.get( 0 );  
        else  
            return null;  
    }
}