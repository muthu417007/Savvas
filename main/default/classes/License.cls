public class License {
    
    public String a_eProductName { get; set; }
    public String isbnProduct { get; set; }
    public String customerPO { get; set; }
    public String sapOrderDocumentNumber { get; set; }
    public String sapOrderType { get; set; }
    public String licenseStartDate { get; set; }
    public String licenseExpirationDate { get; set; }
    public Integer numberofLicenses { get; set; }
    public String licenseStatus { get; set; }
    public String organizationName { get; set; }
    public String orgSAPID { get; set; }

    // Constructor
    public License(String a_eProductName, String isbnProduct, String customerPO, String sapOrderDocumentNumber, String sapOrderType, String licenseStartDate, 
                   String licenseExpirationDate, Integer numberofLicenses, String licenseStatus, String organizationName, String orgSAPID) {
        
        this.a_eProductName = a_eProductName;
        this.isbnProduct = isbnProduct;
        this.customerPO = customerPO;
        this.sapOrderDocumentNumber = sapOrderDocumentNumber;
        this.sapOrderType = sapOrderType;
        this.licenseStartDate = licenseStartDate;
        this.licenseExpirationDate = licenseExpirationDate;
        this.numberofLicenses = numberofLicenses;
        this.licenseStatus = licenseStatus;
        this.organizationName = organizationName;
        this.orgSAPID = orgSAPID;
    }
}