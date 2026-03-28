public class testgenerateurl {
 @AuraEnabled(cacheable=true)
    public static String geturl(){
        String sfdcBaseURL = URL.getOrgDomainURL().toExternalForm();
        return site.getDomain();
     
}
}