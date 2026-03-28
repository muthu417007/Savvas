public class SampleCreationController {

    public PageReference redirect() {
    	SampleRequest__c sr = new SampleRequest__c();
        insert sr;
        id srid=sr.id;
    	string url = '/'+srid;
        PageReference srStdPage = new PageReference(url);
        srStdPage.setRedirect(true);
        return srStdPage;
    }
    
    @isTest
    public static void testRedirect(){
        SampleCreationController con = new SampleCreationController();
        con.redirect();
    }
    
}