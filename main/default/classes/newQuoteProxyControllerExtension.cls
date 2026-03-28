public class newQuoteProxyControllerExtension {

    private final Opportunity opp;
    public String pageRefString = null;
    public boolean hasPrimaryContact = false;
    public boolean hasQuote = false;
    public string errorText='';
   public string errorURLString = '';
    
    // The extension constructor initializes the private member
    // variable acct by using the getRecord method from the standard
    // controller.
    public newQuoteProxyControllerExtension(ApexPages.StandardController stdController) {
        this.opp = (Opportunity)stdController.getRecord();
        integer countPrimaryContacts = [select count() from OpportunityContactRole where OpportunityId=:opp.id and IsPrimary=true];
        integer countQuotes = [Select count() from CameleonCPQ__Quote__c where CPQOpportunityId__c=:opp.id];
        if(countPrimaryContacts==1 && countQuotes==0){
            hasPrimaryContact = true;
            hasQuote = false;
            map<string,string> paramMap = ApexPages.currentPage().getParameters();
            pageRefString = '/apex/RedirectWithVariables?object=CameleonCPQ__Quote__c';
            for(string paramName:paramMap.keyset()){
                if(paramName<>'id'){
                    pageRefString=pageRefString+'&'+paramName+'='+paramMap.get(paramName);
                  
                }
            }
        }else if(countPrimaryContacts==0)  {
            errorText=system.label.Quote_Must_Have_Primary_Contact;
        }else if(countQuotes>0) {
            errorText=system.label.Opportunity_already_has_a_Quote;
            hasQuote = true;
            } 
        
    }
    
    
    public PageReference getNewQuotePage() {
        PageReference pageRef=null;
        if(hasPrimaryContact && !hasQuote){
            pageref = new PageReference(pageRefString);
        }
        return pageref;
    }
    

    public string getErrorURL(){
     errorURLString = '';
     if (hasPrimaryContact==false)  {
           errorURLString = '/p/opp/ContactRoleEditUi/e?oppid='+opp.id+'&retURL=%2F'+opp.id+'%23'+opp.id+'_00Nd0000007O8FT_target';
           
        }
      
     if(hasQuote==true) {
           errorURLString = URL.getSalesforceBaseUrl().toExternalForm()+'/'+opp.id+'#'+opp.id+'_00Nd0000007O8FT_target';
       }
        return errorURLString;
    }


    public String getErrorText() {
        return errorText;
    }
}