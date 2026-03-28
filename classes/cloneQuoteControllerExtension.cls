public class cloneQuoteControllerExtension {

    private final CameleonCPQ__Quote__c quo;
    integer countPrimaryContacts=0;
    integer countQuotes=0;
    string newoppid=null;
    string newoppname=null;
    string errorText=null;
    string newoppaccountid=null;
    string newoppLeaderId=null;
    public string errorURLString = '';

    // The extension constructor initializes the private member
    // variable originalquote by using the getRecord method from the standard
    // controller.

    public cloneQuoteControllerExtension(ApexPages.StandardController stdController) {
        this.quo = (CameleonCPQ__Quote__c)stdController.getRecord();
        newoppid = ApexPages.currentPage().getParameters().get('newoppid');
        Opportunity newopp = [select name,accountid,Opportunity_Leader__c from Opportunity where id=:newoppid];
        newoppname = newopp.Name;
        newoppaccountid = newopp.AccountID;
        newoppLeaderId = newopp.Opportunity_Leader__c;
        countPrimaryContacts = [select count() from OpportunityContactRole where OpportunityId=:newoppid and IsPrimary=true];
        countQuotes = [Select count() from CameleonCPQ__Quote__c where CPQOpportunityId__c=:newoppid];          
    }

    public PageReference getNewQuotePage() {
        PageReference pageRef;
        if(countPrimaryContacts==1 && countQuotes==0){  //this is new to check for a primary contact and no pre-existing quotes on the opp
            Map<String, Schema.SObjectField> flds = Schema.SObjectType.CameleonCPQ__Quote__c.fields.getMap();  //changed to prepend CameleonCPQ__
            Schema.DescribeFieldResult fd = Schema.SObjectType.CameleonCPQ__Quote__c.fields.CameleonCPQ__Status__c;  //changed to prepend CameleonCPQ__
            final String initStatus = null;
            if(fd!=null && fd.getPicklistValues()!=null && !fd.getPicklistValues().isEmpty()){
               initStatus = fd.getPicklistValues()[0].getValue();
            }
            List<String> fieldList = new List<String>();
            fieldList.addAll(flds.keySet());
            String quoFlds = '';
            for(integer i=0; i<fieldList.size(); i++)
              if (flds.get(fieldList[i]).getDescribe().IsCreateable()){
                  quoFlds = quoFlds + (quoFlds.length()>0?', ':'') + fieldList[i];
              }
            SObject[] queryObject = Database.query('SELECT '+quoFlds+' FROM CameleonCPQ__Quote__c where Id=\''+this.quo.Id+'\'');  //changed to prepend CameleonCPQ__
            if(queryObject!=null && queryObject.size()>0) {
               CameleonCPQ__Quote__c[] oriQuoteList = new CameleonCPQ__Quote__c[]{ (CameleonCPQ__Quote__c)queryObject[0] };  //changed to prepend CameleonCPQ__
               CameleonCPQ__Quote__c[] newQuoteList = oriQuoteList.deepClone(false);  //changed to prepend CameleonCPQ__
               newQuoteList[0].put('CameleonCPQ__ActiveRelease__c',1);  //changed to prepend CameleonCPQ__
               newQuoteList[0].put('CameleonCPQ__ExternalId__c','');  //changed to prepend CameleonCPQ__
               newQuoteList[0].put('CPQOpportunityId__c',newoppid);  //this is new to change the cloned quote's Opportunity to what was selected on the previous screen
               newQuoteList[0].put('Name',newoppname);  //this is new to change the name of the cloned quote to match its new Opportunity
               newQuoteList[0].put('Deliver_To_Account__c',newoppaccountid); //Change the Deliver to account
               newQuoteList[0].put('Invoice_to_Account__c',newoppaccountid);
               newQuoteList[0].put('Ship_To_Account__c',newoppaccountid);
               newQuoteList[0].put('ownerid',newoppLeaderid);
               if(initStatus!=null)
                  newQuoteList[0].put('CameleonCPQ__Status__c',initStatus);  //changed to prepend CameleonCPQ__
               insert newQuoteList[0];
    
               // Clone the Release 
               CameleonCPQ__Quote__c q = [select CameleonCPQ__ActiveRelease__c from CameleonCPQ__Quote__c where id=:this.quo.Id];//  added due to error on next line: SObject row was retrieved via SOQL without querying the requested field: CameleonCPQ__Quote__c.CameleonCPQ__ActiveRelease__c
               //String qry = 'SELECT Id '+(UserInfo.isMultiCurrencyOrganization() ? ',CurrencyIsoCode' : '')+' FROM CameleonCPQ__QuoteRelease__c where CameleonCPQ__QuoteId__c=\''+this.quo.Id+'\' and CameleonCPQ__ReleaseNumber__c='+this.quo.CameleonCPQ__ActiveRelease__c;  //changed to prepend CameleonCPQ__
               String qry = 'SELECT Id '+(UserInfo.isMultiCurrencyOrganization() ? ',CurrencyIsoCode' : '')+' FROM CameleonCPQ__QuoteRelease__c where CameleonCPQ__QuoteId__c=\''+this.quo.Id+'\' and CameleonCPQ__ReleaseNumber__c='+q.CameleonCPQ__ActiveRelease__c;  //changed to prepend CameleonCPQ__ and change this.quo to q
               SObject[] oriQrList = (CameleonCPQ__QuoteRelease__c[])Database.query(qry);  //changed to prepend CameleonCPQ__
               if(oriQrList!=null&&oriQrList.size()>0) {
                  CameleonCPQ__QuoteRelease__c[] newQrList = oriQrList.deepClone(false);  //changed to prepend CameleonCPQ__
                  newQrList[0].put('CameleonCPQ__QuoteId__c',newQuoteList[0].Id);  //changed to prepend CameleonCPQ__
                  newQrList[0].put('CameleonCPQ__ReleaseNumber__c',1);  //changed to prepend CameleonCPQ__
                  insert newQrList[0];
               }
    
               System.debug('Cloning Cameleon CPQ Quote ['+this.quo.Id+'] to ['+newQuoteList[0].Id+']');
               //CameleonCPQ.CPQRequestFormatter.sendCPQRequest(this.quo.Id, newQuoteList[0].Id, String.valueOf(this.quo.CameleonCPQ__ActiveRelease__c),'copyCartRelease','');  //changed to prepend CameleonCPQ__ and CameleonCPQ. and remove _asynchronous
               asyncCopyCartRelease(this.quo.Id, newQuoteList[0].Id, String.valueOf(q.CameleonCPQ__ActiveRelease__c));
               
               pageRef = new PageReference('/' + newQuoteList[0].Id+'/e?retURL=/'+newQuoteList[0].Id); 
               pageRef.setRedirect(true); 
            }
        }else if(countPrimaryContacts==0)  {
            errorText=system.label.Quote_Must_Have_Primary_Contact;
        }else if(countQuotes>0) {
            errorText=system.label.Opportunity_already_has_a_Quote;
        }
        return pageRef; 
    
    }
    
   public string getErrorURL(){
     errorURLString = '';
     if (countPrimaryContacts==0)  {
           errorURLString = '/p/opp/ContactRoleEditUi/e?oppid='+newoppid+'&retURL=%2F'+newoppid+'%23'+newoppid+'_00Nd0000007O8FT_target';
           
        }
      
     if(countQuotes>0) {
           errorURLString = URL.getSalesforceBaseUrl().toExternalForm()+'/'+newoppid+'#'+newoppid+'_00Nd0000007O8FT_target';
       }
        return errorURLString;
    }  

    public String getErrorText() {
        return errorText;
    }
    @future (callout=true)
    public static void asyncCopyCartRelease(string tqid, string nql0id, string activerelease) {
        final String[] CPQResult = CameleonCPQ.CPQRequestFormatter.sendCPQRequest(tqid, nql0id, activerelease,'copyCartRelease','');
    }  
}