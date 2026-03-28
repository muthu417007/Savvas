public class IPAddressUtilityController {
   public String getGuestUserIPAddress() {
       String ipAddress = 'IP address not found';
       try {
           Map<String, String> headers = ApexPages.currentPage().getHeaders();
           if (headers == null) {
               System.debug('Headers are null');
               return 'Headers not available';
           }
           System.debug('Headers: ' + headers);
           // Retrieve the IP address from the headers
           if (headers.containsKey('X-Salesforce-SIP')) {
               ipAddress = headers.get('X-Salesforce-SIP');
           } else if (headers.containsKey('REMOTE_ADDR')) {
               ipAddress = headers.get('REMOTE_ADDR');
           }
           System.debug('IP Address: ' + ipAddress);
           return ipAddress != null ? ipAddress : 'IP address not found';
       } catch (Exception e) {
           System.debug('Error retrieving IP address: ' + e.getMessage());
           return 'Error retrieving IP address: ' + e.getMessage();
       }
   }
}