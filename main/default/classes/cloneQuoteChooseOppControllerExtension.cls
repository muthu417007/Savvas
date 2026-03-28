public class cloneQuoteChooseOppControllerExtension {

    private final CameleonCPQ__Quote__c originalquote;
    
    // The extension constructor initializes the private member
    // variable acct by using the getRecord method from the standard
    // controller.
    public cloneQuoteChooseOppControllerExtension(ApexPages.StandardController stdController) {
        this.originalquote = (CameleonCPQ__Quote__c)stdController.getRecord();
    }
    
    public PageReference getCloneQuotePage(){
    string url='/apex/clonequote?id='+originalquote.Id+'&newoppid='+originalquote.CPQOpportunityId__c;
    pagereference clonequotepage = new pagereference(url);
    clonequotepage.setRedirect(true);
    return clonequotepage;
    }
}