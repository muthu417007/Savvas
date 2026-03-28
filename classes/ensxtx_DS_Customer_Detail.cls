public with sharing class ensxtx_DS_Customer_Detail
{
    // HEADER
    @AuraEnabled public String CustomerNumber { get; set; }
    @AuraEnabled public String CustomerAccountGroup { get; set; }
    @AuraEnabled public String Name { get; set; }
    @AuraEnabled public String Name2 { get; set; }
    @AuraEnabled public String PhoneNumber { get; set; }
    @AuraEnabled public String FaxNumber { get; set; }
    @AuraEnabled public String EmailAddress { get; set; }
    @AuraEnabled public String StreetAddress { get; set; }
    @AuraEnabled public String City { get; set; }
    @AuraEnabled public String Region { get; set; }
    @AuraEnabled public String PostalCode { get; set; }
    @AuraEnabled public String Country { get; set; }
    @AuraEnabled public String SearchTerm1 { get; set; }
    @AuraEnabled public Boolean IsSuccess { get; set; }
    @AuraEnabled public String TransportationZone { get; set; }
    @AuraEnabled public String Language { get; set; }

    @AuraEnabled public List<SALES_TEXT> SALES_TEXT { get; set; }
    @AuraEnabled public List<COMPANY_DATA> COMPANY_DATA { get; set; }
    @AuraEnabled public List<SALES_DATA> SALES_DATA { get; set; }
    @AuraEnabled public List<TAX_CLASSIFICATION> TAX_CLASSIFICATION { get; set; }

    //SALES_TEXT
    public class SALES_TEXT
    {
        @AuraEnabled public String TextLanguage { get; set; }
    }

    //COMPANY_DATA
    public class COMPANY_DATA
    {
        @AuraEnabled public String CompanyCode { get; set; }
        @AuraEnabled public String ReconciliationAccount { get; set; }
        @AuraEnabled public String PaymentTerms { get; set; }
    }

    //SALES_DATA
    public class SALES_DATA
    {
        @AuraEnabled public String SalesOrganization { get; set; }
        @AuraEnabled public String DistributionChannel { get; set; }
        @AuraEnabled public String Division { get; set; }
        @AuraEnabled public String SalesDistrict { get; set; }
        @AuraEnabled public String SalesOffice { get; set; }
        @AuraEnabled public String SalesGroup { get; set; }
        @AuraEnabled public String PriceGroup { get; set; }
        @AuraEnabled public String PriceListType { get; set; }
        @AuraEnabled public String ShippingConditions { get; set; }
        @AuraEnabled public String DeliveryPlant { get; set; }
        @AuraEnabled public String PaymentTerms { get; set; }
        @AuraEnabled public String IncoTerms1 { get; set; }
        @AuraEnabled public String IncoTerms2 { get; set; }
        @AuraEnabled public String CurrencyKey { get; set; }
        @AuraEnabled public String AccountAssignmentGroup { get; set; }
        @AuraEnabled public String CustomerPricingProcedure { get; set; }
        @AuraEnabled public String CustomerBlock { get; set; }
    }

    //TAX_CLASSIFICATION
    public class TAX_CLASSIFICATION
    {
        @AuraEnabled public String CountryCode { get; set; }
        @AuraEnabled public String TaxCategory { get; set; }
        @AuraEnabled public String TaxClassification { get; set; }
    }

    // Constructor
    public ensxtx_DS_Customer_Detail()
    {
        this.COMPANY_DATA = new List<ensxtx_DS_Customer_Detail.COMPANY_DATA>();
        this.SALES_DATA = new List<ensxtx_DS_Customer_Detail.SALES_DATA>();
        this.SALES_TEXT = new List<ensxtx_DS_Customer_Detail.SALES_TEXT>();
        this.TAX_CLASSIFICATION = new List<ensxtx_DS_Customer_Detail.TAX_CLASSIFICATION>();
    }
}