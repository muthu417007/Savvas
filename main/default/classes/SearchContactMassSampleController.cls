public with Sharing class SearchContactMassSampleController {
  private String baseQuery;
  public String ContFilterId {get; set;}
  private Integer pageSize = 20;
  @testVisible private string SampleId;
  Public string passSampleId {get; set;} 
  public string withinLimit {get;set;}
  public list<wrapContacts> wrapContList{get;set;}
  Map <id,wrapContacts> SelectedContactsMap=new map<id,wrapContacts>();

  //Constructor Method
  public SearchContactMassSampleController (){
     	passSampleId=ApexPages.currentPage().getParameters().get('sampleId');
  }
  public SearchContactMassSampleController(ApexPages.StandardSetController c){
  }
  
  //Return's list of fields on the Field Sets
  public List<Schema.FieldSetMember> getFields() {
        return SObjectType.Contact.FieldSets.MassSampleContactField.getFields();
  }
    
  public ApexPages.StandardSetController ContSetController {
        get{
            sampleId=ApexPages.currentPage().getParameters().get('sampleId');
            if(ContSetController == null){
                //Build the query by getting all the fields that was specified on the GenericMassSampleAccountField Account Field set
                baseQuery='SELECT ';
                for(Schema.FieldSetMember f : this.getFields()) {
                    baseQuery+= f.getFieldPath() + ', ';
                }
                baseQuery+= 'Id FROM Contact Limit 40';
                //End of building the base Query
                
               ContSetController = new ApexPages.StandardSetController(Database.getQueryLocator(baseQuery));
               ContSetController.setPageSize(pageSize);
            
               if(ContFilterId != null){
                  ContSetController.setFilterId(ContFilterId);      
               }
            }
            
            return ContSetController;

        }set;
    }

    //Add all selected accounts to the Sampling Object
    public PageReference Add()
    {	
		list<SampleRequestContact__c> mscList = new list<SampleRequestContact__c>();
		Integer totalContactCount = 0;
		String userTheme = getContextUserUiThemeDisplayed();
		List<SampleRequest__c> parentSampleList = [Select id, Number_of_Contacts__c, Number_of_Generic_Contacts__c from SampleRequest__c where id=:sampleId];
		for(SampleRequest__c parentData : parentSampleList){
		totalContactCount = Integer.valueof(parentData.Number_of_Contacts__c + parentData.Number_of_Generic_Contacts__c);
		system.debug('no of contact: '+parentData.Number_of_Contacts__c);
		system.debug('no of generic: '+parentData.Number_of_Generic_Contacts__c);
		}
		totalContactCount = totalContactCount + SelectedContactsMap.size();
		system.debug('totalContactCount: '+totalContactCount);
		system.debug('SelectedContactsMap: '+SelectedContactsMap.size());
		
        if(totalContactCount<=20){
			withinLimit = 'Yes';
			for(Id mapId:SelectedContactsMap.keyset()){
				 SampleRequestContact__c src = new SampleRequestContact__c();
				 WrapContacts c=SelectedContactsMap.get(mapId);
				 src.Contact__c=mapId;
				 src.Account__c=c.cont.accountId;
				 src.SampleRequest__c=sampleId;
				 mscList.add(src);       
			   }
           insert msclist;
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

    return null;
    }
	
	public String getContextUserUiThemeDisplayed() {
        return UserInfo.getUiThemeDisplayed();
    }

    
  //Keeps track of selected Contacts using Map
   public void runSelectedQuery() {
       
        for(wrapContacts wrapobj:wrapContList){
            //Add's or removes the Contacts from the Selected Contact Map
            if(wrapobj.isSelected==true){
                wrapContacts wp=SelectedContactsMap.get(wrapobj.cont.id);
                if(wp==null){
                   SelectedContactsMap.put(wrapobj.cont.id,wrapobj);
                }
            }else{
                 if(SelectedContactsMap.size()>0){
                    for(integer i=0;i<SelectedContactsMap.size();i++){
                            SelectedContactsMap.remove(wrapobj.cont.id);                                          
                    }
                 }             
            }       
        }
    }
    //Toggle the checkboxes
    public void toggleSelectAll() {
        if(SelectedContactsMap.size()==0){
            for(wrapContacts wAcc:wrapContList){
                wAcc.isSelected=true;
                selectedContactsMap.put(wAcc.cont.Id,wAcc);
            }
        }else
            selectedContactsMap.clear();
            
    }
    //Wrapper class for Contacts
    public class wrapContacts{
        public Contact cont{get;set;}
        public boolean isSelected{get;set;}
        public wrapContacts(Contact c){
            cont=c;
            isSelected=false;
        }
    }
    
    //Navigate to first Page
    public void firstPage()
    {
      ContSetController.first();
    }
    
    // indicates whether there are more records after the current page set.
    public Boolean hasNext {
        get {
            return ContSetController.getHasNext();
        }
        set;
    }

    // indicates whether there are more records before the current page set.
    public Boolean hasPrevious {
        get {
            return ContSetController.getHasPrevious();
        }
        set;
    }
    //Navigate to last Page
    public void lastPage()
    {
      ContSetController.last();
    }

    //Navigate to Next page
    public void next()
    {
        ContSetController.next();
    }

    //Navigate to Prev Page
    public void prev()
    {
        ContSetController.previous();
    }
    
    // returns the PageReference of the original page, if known, or the home page.
     public PageReference cancel() {
			String userTheme = getContextUserUiThemeDisplayed();
			if(userTheme == 'Theme3' || userTheme == 'Theme2'){
				PageReference pageRef = new PageReference('/apex/MassSampleOverride?id='+sampleId);				
				return pageRef;
			}else{
			   return null;
			}
     }

    //Returns the list of Wrapper class Contacts
    public List<wrapContacts> getContacts()
    {
      wrapContList = new list<wrapContacts>();
      for(Contact cnt:(list<Contact>)ContSetController.getRecords())
      {
          //Check if the Contact was already selected
          //If Contact was already selected,  add's the Contacts with the selected value set to true
          wrapContacts wc=SelectedContactsMap.get(cnt.Id);
          if(wc!=null){
              wrapContList.add(wc);
          }else{
            wrapContList.add(new wrapContacts(cnt));
          }
      }
      return wrapContList;
    }

    //Get all available list view for Contacts
    public SelectOption[] getContactExistingViews(){
        return ContSetController.getListViewOptions();
    }

    /**
    * Reset List View
    */
    public PageReference resetFilter()
    {
      ContSetController = null;
      ContSetController.setPageNumber(1);
      return null;
    }
}