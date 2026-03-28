public with sharing class SearchAccountGenericMassSampleController {
  private String baseQuery;
  public String AccFilterId {get; set;}
  public string genericContact{get;set;}
  private Integer pageSize = 20;
  @testVisible private string SampleId;
  Public string passSampleId {get; set;}
  public Boolean requireContact {get;set;}
  public string contactFilled {get;set;}
  public string withinLimit {get;set;}
  public list<wrapAccount> wrapAccList{get;set;}
  Map <id,wrapAccount> SelectedAccountMap=new map<id,wrapAccount>();

  //Constructor Method
  public SearchAccountGenericMassSampleController (){
      passSampleId=ApexPages.currentPage().getParameters().get('sampleId');
  }
  public SearchAccountGenericMassSampleController(ApexPages.StandardSetController c){}
  
  //Return's list of fields on the Field Sets
  public List<Schema.FieldSetMember> getFields() {
        return SObjectType.Account.FieldSets.GenericMassSampleAccountField.getFields();
  }
    
  public ApexPages.StandardSetController AccSetController {
        get{
            sampleId=ApexPages.currentPage().getParameters().get('sampleId');
            if(AccSetController == null){
            	//Build the query by getting all the fields that was specified on the GenericMassSampleAccountField Account Field set
            	baseQuery='SELECT ';
            	for(Schema.FieldSetMember f : this.getFields()) {
            		baseQuery+= f.getFieldPath() + ', ';
        		}
        		baseQuery+= 'Id FROM Account Limit 40';
            	//End of building the base Query
            	
               AccSetController = new ApexPages.StandardSetController(Database.getQueryLocator(baseQuery));
               AccSetController.setPageSize(pageSize);
            
               if(AccFilterId != null){
                  AccSetController.setFilterId(AccFilterId);      
               }
            }
			
            return AccSetController;

        }set;
    }

    //Add all selected accounts to the Sampling Object
    public PageReference Add()
    {
        list<Mass_Sample_Generic_Contacts__c> msgcList = new list<Mass_Sample_Generic_Contacts__c>();
        system.debug('genericContact: '+genericContact);
        system.debug('SelectedAccountMap: '+SelectedAccountMap.size());
        String userTheme = getContextUserUiThemeDisplayed();
		Integer totalContactCount = 0;
        if(genericContact!=null&&genericContact!=''){
            requireContact = false;
            contactFilled = 'Yes';
			List<SampleRequest__c> parentSampleList = [Select id, Number_of_Contacts__c, Number_of_Generic_Contacts__c from SampleRequest__c where id=:sampleId];
			for(SampleRequest__c parentData : parentSampleList){
				totalContactCount = Integer.valueof(parentData.Number_of_Contacts__c + parentData.Number_of_Generic_Contacts__c);
			}
			totalContactCount = totalContactCount + SelectedAccountMap.size();
			system.debug('totalContactCount: '+totalContactCount);
            if(totalContactCount<=20){
                withinLimit = 'Yes';
        		for(Id mapId:SelectedAccountMap.keyset()){
					Mass_Sample_Generic_Contacts__c gc = new Mass_Sample_Generic_Contacts__c();
					gc.Account__c=mapId;
       				gc.Generic_Contact__c=genericContact;
       				gc.Mass_Sample_Generic__c=sampleId;
        			msgcList.add(gc);       
        		}
        		insert msgclist;
				if(userTheme == 'Theme3' || userTheme == 'Theme2'){
					PageReference pageRef = new PageReference('/apex/MassSampleOverride?id='+sampleId);				
					return pageRef;
				}else{
				   return null;
				}
            }else{
                 withinLimit = 'No';
                if(userTheme == 'Theme3' || userTheme == 'Theme2'){
                 ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Maximum number of Account is 20'));  
                }
           }
        }
        else{
                system.debug('went else generic:'+userTheme);
                requireContact = true;
            	contactFilled = 'No';
            if(userTheme == 'Theme3' || userTheme == 'Theme2'){
                ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Please enter an Generic Contact'));     
            } 
                return null;
        }
        return null;
    }
    
  //Keeps track of selected Accounts using Map
   public void runSelectedQuery() {
       
        for(wrapAccount wrapobj:wrapAccList){
            //Add's or removes the account from the Selected Account Map
            if(wrapobj.isSelected==true){
                wrapAccount wp=SelectedAccountMap.get(wrapobj.acc.id);
                if(wp==null){
                   SelectedAccountMap.put(wrapobj.acc.id,wrapobj);
                }
            }else{
                 if(SelectedAccountMap.size()>0){
                	for(integer i=0;i<SelectedAccountMap.size();i++){
                            SelectedAccountMap.remove(wrapobj.acc.id);                   		              	
                	}
                 }             
            }	    
        }
  	}
    //Toggle the checkboxes
    public void toggleSelectAll() {
        if(SelectedAccountMap.size()==0){
            for(wrapAccount wAcc:wrapAccList){
                wAcc.isSelected=true;
                selectedAccountMap.put(wAcc.acc.Id,wAcc);
            }
        }else
			selectedAccountMap.clear();
            
    }
    //Wrapper class for Account
    public class wrapAccount{
        public Account acc{get;set;}
        public boolean isSelected{get;set;}
        public wrapAccount(Account a){
            acc=a;
            isSelected=false;
        }
    }
    
    //Navigate to first Page
    public void firstPage()
    {
      AccSetController.first();
    }
    
    // indicates whether there are more records after the current page set.
	public Boolean hasNext {
        get {
            return AccSetController.getHasNext();
        }
        set;
    }

    // indicates whether there are more records before the current page set.
    public Boolean hasPrevious {
        get {
            return AccSetController.getHasPrevious();
        }
        set;
    }
    //Navigate to last Page
    public void lastPage()
    {
      AccSetController.last();
    }

    //Navigate to Next page
    public void next()
    {
        AccSetController.next();
    }

    //Navigate to Prev Page
    public void prev()
    {
        AccSetController.previous();
    }
    
    // returns the PageReference of the original page, if known, or the home page.
     public PageReference cancel() {
          system.debug('went4: ');
		  String userTheme = getContextUserUiThemeDisplayed();
			if(userTheme == 'Theme3' || userTheme == 'Theme2'){
				PageReference pageRef = new PageReference('/apex/MassSampleOverride?id='+sampleId);				
				return pageRef;
			}else{
			   return null;
			}
     }

    //Returns the list of Wrapper class accounts
    public List<wrapAccount> getAccounts()
    {
      wrapAccList = new list<wrapAccount>();
      for(Account acc:(list<Account>)AccSetController.getRecords())
      {
          //Check if the account was already selected
          //If Account was already selected,  add's the account with the selected value set to true
          wrapAccount wa=SelectedAccountMap.get(acc.Id);
          if(wa!=null){
              wrapAccList.add(wa);
          }else{
          	wrapAccList.add(new wrapAccount(acc));
      	  }
      }
      return wrapAccList;
    }

    //Get all available list view for Account
    public SelectOption[] getAccountExistingViews(){
        return AccSetController.getListViewOptions();
    }

    /**
    * Reset List View
    */
    public PageReference resetFilter()
    {
      AccSetController = null;
      AccSetController.setPageNumber(1);
      return null;
    }
	public String getContextUserUiThemeDisplayed() {
        return UserInfo.getUiThemeDisplayed();
    }
      
}