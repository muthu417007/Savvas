/*
Apex Class:scc_cartPdf_Controller
Author: CTS (Balamurugan D)
Created Date: 27/06/2024
Reason:
Modified Date: 18/10/2024
*/
    public without sharing class scc_cartPdf_Controller {  
    /**
* @description Generates a URL for the Visualforce page that renders the cart PDF
* @return String URL of the Visualforce page for PDF generation
*/
    @AuraEnabled 
    public static String generatePdf() {
        
            PageReference pdfPage = Page.scc_cartPdfPage;
            pdfPage.setRedirect(true);
            String baseUrl = Site.getBaseUrl();
            String vfUrl = baseUrl + pdfPage.getUrl();
            return vfUrl;
                
    } 
}