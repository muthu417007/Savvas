/*
*********************************************************
Class Name       : CustomHeaderController
Created Date     : 10/30/2024  
Author           : Frank Berni - Cognizant
Description      : Custom controller for Header section on Quote Document Gen. Conditionally displays specific fields

History:
<Date>          <Authors Name>              <Brief Description of Change>
10/30/2024       Frank Berni               W-016391 : Initial creation
**********************************************************/
public with sharing class CustomHeaderController {

    public string quoteId {get; set;}
    public string templateId {get; set;}
    public SBQQ__Quote__c quote {get;set;}
    public SBQQ__QuoteTemplate__c template {get;set;}

    // Controlling fields for visibility
    public boolean showShipAddress {get; set;}
    public boolean showSpecialNotes {get; set;}
    public boolean showDistrictLicense {get; set;}
    public boolean showFutureShipDate {get; set;}
    

    public CustomHeaderController() {
        quoteId = ApexPages.currentPage().getParameters().get('qid');
        templateId = ApexPages.currentPage().getParameters().get('tid');
        
        // default booleans as false
        showShipAddress = false;
        showSpecialNotes = false;
        showDistrictLicense = false;
        showFutureShipDate = false;

        // Call queries for Quote Template and Quote
        this.populateTemplate();
        this.populateQuoteData();
    }

    /*
    *********************************************************
    Method Name    : populateTemplate
    Author         : Frank Berni
    Description    : Queries SBQQ__QuoteTemplate__c from getter and populates template class variable
    Param          : 
    return         : template
    ********************************************************
  */
  public void populateTemplate() {
    template = [
      SELECT Id, SBQQ__FontFamily__c, SBQQ__FontSize__c, SBQQ__ShadingColor__c 
      FROM SBQQ__QuoteTemplate__c 
      WHERE Id = :templateId
    ];
  }

  /*
    *********************************************************
    Method Name    : populateQuoteData
    Author         : Frank Berni
    Description    : Queries Quote fields to display in VF page
    Param          : 
    return         : template
    ********************************************************
  */
  public void populateQuoteData() {
    quote = [
      SELECT Id, ShippingAddress__c, SBQQ__BillingCity__c,
            SBQQ__BillingPostalCode__c, SBQQ__BillingState__c, SBQQ__BillingStreet__c,
            SBQQ__StartDate__c, Future_Ship_Start_Date__c, Include_Ship_To__c,
            InvoiceForFutureDate__c, License_to_District__c, PrimaryContactName__c,
            PrimaryContactRole__c, CPQ_Quote_Expiry_Date__c, Quote_Name__c, Special_Notes__c,
            SBQQ__Account__r.Name 
      FROM SBQQ__Quote__c 
      WHERE Id = :quoteId 
      LIMIT 1
    ];

    // Set controlling booleans based on following conditions
    // Check Include_Ship_To__c == true for showShipAddress
    showShipAddress = quote.Include_Ship_To__c ? true : false;
    // Check Special_Notes__c != null for showSpecialNotes
    showSpecialNotes = quote.Special_Notes__c != null ? true : false;
    // Check License_to_District__c != null for showDistrictLicense
    showDistrictLicense = quote.License_to_District__c != null ? true : false;
    // Check InvoiceForFutureDate__c == true for showFutureShipDate
    showFutureShipDate = quote.InvoiceForFutureDate__c ? true : false;
  }
}