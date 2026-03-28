@isTest
public class ensxtx_TSTD_Customer_Detail
{
    @isTest
    public static void test_customerDetail()
    {
        ensxtx_DS_Customer_Detail customerDetail = createCustomerDetail();
    }

    public static ensxtx_DS_Customer_Detail createCustomerDetail()
    {
        ensxtx_DS_Customer_Detail customerDetail = new ensxtx_DS_Customer_Detail();
        customerDetail.CustomerAccountGroup = '1';
        customerDetail.Name = 'Bob';
        customerDetail.Name2 = 'Bob';
        customerDetail.PhoneNumber = '999';
        customerDetail.FaxNumber = '000';
        customerDetail.EmailAddress = '000';
        customerDetail.StreetAddress = '111 Street';
        customerDetail.City = 'Dayton';
        customerDetail.Region = 'OH';
        customerDetail.PostalCode = '333';
        customerDetail.Country = 'US';
        customerDetail.CustomerNumber = '111';
        customerDetail.SearchTerm1 = 'Hello';
        customerDetail.IsSuccess = true;
        customerDetail.TransportationZone = '000';
        customerDetail.Language = '000';

        ensxtx_DS_Customer_Detail.SALES_TEXT salesText = new ensxtx_DS_Customer_Detail.SALES_TEXT();
        salesText.TextLanguage = 'E';
        customerDetail.SALES_TEXT = new List<ensxtx_DS_Customer_Detail.SALES_TEXT>{salesText};

        ensxtx_DS_Customer_Detail.COMPANY_DATA companyData = new ensxtx_DS_Customer_Detail.COMPANY_DATA();
        companyData.CompanyCode = '1';
        companyData.ReconciliationAccount = '1';
        companyData.PaymentTerms = '1';
        customerDetail.COMPANY_DATA = new List<ensxtx_DS_Customer_Detail.COMPANY_DATA>{companyData};

        ensxtx_DS_Customer_Detail.SALES_DATA salesData = new ensxtx_DS_Customer_Detail.SALES_DATA();
        salesData.SalesOrganization = '1111';
        salesData.DistributionChannel = '111';
        salesData.Division = '0';
        salesData.SalesGroup = '1';
        salesData.SalesDistrict = '1';
        salesData.SalesOffice = '1';
        salesData.PriceGroup = '1';
        salesData.PriceListType = '2';
        salesData.ShippingConditions = '1';
        salesData.DeliveryPlant = '1';
        salesData.PaymentTerms = '1';
        salesData.IncoTerms1 = '1';
        salesData.IncoTerms2 = '2';
        salesData.CurrencyKey = 'US';
        salesData.AccountAssignmentGroup = '1';
        salesData.CustomerPricingProcedure = '3';
        salesData.CustomerBlock = '3';
        customerDetail.SALES_DATA = new List<ensxtx_DS_Customer_Detail.SALES_DATA>{salesData};

        ensxtx_DS_Customer_Detail.TAX_CLASSIFICATION tax = new ensxtx_DS_Customer_Detail.TAX_CLASSIFICATION();
        tax.CountryCode = 'US';
        tax.TaxCategory = '1';
        tax.TaxClassification = '1';
        customerDetail.TAX_CLASSIFICATION = new List<ensxtx_DS_Customer_Detail.TAX_CLASSIFICATION>{tax};

        return customerDetail;
    }
}