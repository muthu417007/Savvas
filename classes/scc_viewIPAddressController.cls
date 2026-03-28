public class scc_viewIPAddressController{
    public String ipAddress {get; set;}

    public scc_ViewIPAddressController(){
        //this will work if no caching is in place or
        //user is logged in via secure URL
        ipAddress = ApexPages.currentPage().getHeaders().get('X-Salesforce-SIP');
         
        //this logic will execute if proxy is in use
        if(String.isEmpty(ipAddress)){
            
            //ipAddress = ApexPages.currentPage().getHeaders().get('X-Salesforce-SIP');
           ipAddress = ApexPages.currentPage().getHeaders().get('X-Forwarded-For');
           System.debug('X-Salesforce-SIP'+ApexPages.currentPage().getHeaders().get('X-Salesforce-SIP'));
            System.debug('X-Forwarded-For'+ApexPages.currentPage().getHeaders().get('X-Forwarded-For'));
        }
    }
 }