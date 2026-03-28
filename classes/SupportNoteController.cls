public class SupportNoteController {
    
    public list<itemWrapper>  			queriedItems 	{get; set;}
    public list<itemWrapper>  			selectedItems 	{get; set;}
    public string    					nameCriteria 	{get; set;}
    public string    					cityCriteria 	{get; set;}
    public string    					stateCriteria 	{get; set;}
    public string    					zipCriteria 	{get; set;}
    public Account_Support_Note__c		note 			{get; set;}
    public string						noteType;
    public string 						parentId;
    public class 						baseException extends exception{}
    public boolean						recordsSaved	{get; set;}
    
    // for display on page
    public string 						pageTitle 		{get; set;}
    public string 						queriedTitle 	{get; set;}
    public string 						selectedTitle 	{get; set;}
    
    // to prevent duplicates
    public set<Id>					selectedIds;
    /*
    * 
    */
    
    
    public SupportNoteController() {
    	
    	// get note type & set page titles
    	noteType = ApexPages.currentPage().getParameters().get('noteType');
     	if (noteType != 'Contact' && noteType != 'Account')
    		throw new baseException('noteType=Contact or noteType=Account must be a parameter in URL');
    	pageTitle = 'Create ' + noteType + ' Support Note';
    	queriedTitle = 'Queried ' + noteType + 's';
    	selectedTitle = 'Selected ' + noteType + 's';
    	// initialize other variables
    	selectedItems = new List<itemWrapper>();
	    queriedItems = new List<itemWrapper>();
	    selectedIds = new set<Id>();
      	note = new Account_Support_Note__c(Startdate__c = system.today(), ExpirationDate__c = system.today());
      	init();
    }

    /*
    * 
    */
    
	public void init() {
		
		// select initial account/contact
		    string thisId = Apexpages.currentPage().getParameters().get('Id');
    	    string queryString = noteType == 'Account' 
    	    	  ? 'select Id, Name, BillingCity, BillingState from account where Id = :thisId limit 1'
    	    	  : 'select Id, Name, Account.BillingCity, Account.BillingState, Account.Name from contact where Id = :thisId limit 1';
    	    	  
    	    
    	    sObject s = database.query(queryString);
    	    system.debug('**** SupportNoteController: items: ' + s);

    		if(noteType == 'Account')
	    		selectedItems.add(new itemWrapper((string)s.get('Id'), 
				    		(string)s.get('Name'), 
				    		(string)s.get('BillingCity')+', ' + 
				    		(string)s.get('BillingState')));
			else {
				SObject a = s.getSObject('Account');	 // must split out foreign table
	    		selectedItems.add(new itemWrapper((string)s.get('Id'), 
				    		(string)s.get('Name'), 
				    		(string)a.get('Name') + ' / ' +
				    		(string)a.get('BillingCity')+', ' + 
				    		(string)a.get('BillingState')));
			}
		  selectedIds.add(thisId);
	}
	
	
    /*
    * 
    */
    
    public void search() {
    	
	    queriedItems = new List<itemWrapper>();
    	string whereClause = '';
		List<string> lstWhereNames = new List<string>(); 
        string sCity = '';
        string sState = '';
        string sZip = '';
    	if (nameCriteria != '') {
    		List<string> names = nameCriteria.split(',');
            
    		for (string s : names) {
    			s = s.trim();
                s = '%'+s+'%';
                lstWhereNames.add(s);
    			//whereClause += whereClause=='' ? ' where (name like \'%'+s+'%\''  : ' or name like \'%'+s+'%\'';
    		}
    		whereClause +=' Where (name Like: lstWhereNames) ';
    	}
    	
    	if(cityCriteria != '') {
    		sCity = cityCriteria.trim();
    		whereClause += whereClause=='' ? ' where Account.BillingCity =:sCity '  : ' and ( Account.BillingCity =:sCity ) ';
    		
    	}   	
    	
   
    	if(stateCriteria != '') {
    		sState = stateCriteria.trim();
    		whereClause += whereClause=='' ? ' where Account.BillingState =:sState '  : ' and ( Account.BillingState =: sState ) ';
    		
    	}   	
    	
  
    	if(zipCriteria != '') {
    		sZip = zipCriteria.trim();
            sZip = sZip+'%';
    		whereClause += whereClause=='' ? ' where Account.BillingPostalCode like: sZip '  : ' and ( Account.BillingPostalCode like:sZip  ) ';
    		
    	}   	
    	
    	
    	  	
    	if (whereClause == '') {
             ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.info, 
                 'Please complete at least one search field before searching.'));    
             return;		
    	}
    	
	    string queryString = noteType == 'Account' 
	    	  ? 'select Id, Name, BillingCity, BillingState,BillingPostalCode from account' + whereClause + '  order by name limit 200'
	    	  : 'select Id, Name, Account.BillingCity, Account.BillingState, Account.Name, Account.BillingPostalCode from contact' + whereClause + '  order by name limit 200';
	    	  
	    system.debug('**** SupportNoteController: queryString: ' + queryString);
	    
	    List<sObject> items = database.query(queryString);
	    system.debug('**** SupportNoteController: items: ' + items);
	    
    	for (sObject s : items) {
    		if(noteType == 'Account')
	    		queriedItems.add(new itemWrapper((string)s.get('Id'), 
				    		(string)s.get('Name'), 
				    		(string)s.get('BillingCity')+', ' + 
				    		(string)s.get('BillingState') +'  ' +
				    		(string)s.get('BillingPostalCode')));
			else {
				SObject a = s.getSObject('Account');	 // must split out foreign table
	    		queriedItems.add(new itemWrapper((string)s.get('Id'), 
				    		(string)s.get('Name'), 
				    		(string)a.get('Name') + ' / ' +
				    		(string)a.get('BillingState') + '  '+
				    		(string)a.get('BillingPostalCode')));
			}
			
    	}
		if (items.size() == 0)
             ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.info, 
                 'No records found matching search criteria.'));        	
    }
    
    /*
    * 
    */
    
    public void save() {
    	boolean errorFound = false;
    	if(note.Name=='' || note.Message__c =='' || note.StartDate__c == null || note.ExpirationDate__c == null) {
             ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.fatal, 
                 'All fields in the Note Detail section must be completed to create notes.'));
             errorFound = true;
    	}
    	
    	if(selectedItems.isEmpty()){
             ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.fatal, 
                 'Please add items to ' + selectedTitle + ' to create notes.'));
             errorFound = true;
    	}
    	
    	if(errorFound)
    		return;
    		
    	List<sObject> itemsToSave = new List<sObject>();
        for(itemWrapper i : selectedItems) {
        	
        	if(noteType == 'Account') {
        		
        		itemsToSave.add(new Account_Support_Note__c(
        			Account__c = i.Id, Name = note.Name, Message__c = note.Message__c, StartDate__c = note.StartDate__c, 
        			            ExpirationDate__c = note.ExpirationDate__c));
         	}
        	else {
        		
        		itemsToSave.add(new Contact_Support_Note__c(
        			Contact__c = i.Id, Name = note.Name, Message__c = note.Message__c, StartDate__c = note.StartDate__c, 
        			            ExpirationDate__c = note.ExpirationDate__c));
        	}
        	
        }
        
        try{
        	database.insert(itemsToSave);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.info, itemsToSave.size() + ' Note(s) Created.'));
            recordsSaved = true;
        }
        catch(dmlException e){
             ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.fatal, e.getMessage()));
             system.debug('**** SupportNoteController ERROR: ' + e.getMessage());        	
        }
        
        //clear note
      	note = new Account_Support_Note__c(Startdate__c = system.today(), ExpirationDate__c = system.today());
    }  
    
    /*
    * 
    */
    
    
    public pageReference continueOn() {
     	pageReference pr = new pageReference('/' + Apexpages.currentPage().getParameters().get('Id'));
     	pr.setRedirect(true);
     	return pr;
    }
    
 
    /*
    * 
    */
       
    public void addSelected() {
    	for (integer i = 0; i < queriedItems.size(); i++) {
    		if(queriedItems[i].selected) 
    			if (!selectedIds.contains(queriedItems[i].Id)) {
	    			selectedItems.add(new itemWrapper(queriedItems[i].Id,queriedItems[i].Name, queriedItems[i].Location));
	    			selectedIds.add(queriedItems[i].Id);
	    			queriedItems.remove(i);
	    			i--;
    			}
    			else
            	  ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.info, 'Item already selected.'));
    	}
    }


    /*
    * 
    */
     
    public void removeSelected() {
    	for (integer i = 0; i < selectedItems.size(); i++) {
    		if(selectedItems[i].selected) {
    			queriedItems.add(new itemWrapper(selectedItems[i].Id,selectedItems[i].Name, selectedItems[i].Location));
    			selectedIds.remove(selectedItems[i].Id);
    			selectedItems.remove(i);
    			i--;
    		}
    	}
    }
  
    /*
    * 
    */
      
    public void addAll() {
    	for(itemWrapper i : queriedItems) {
    		i.selected = true;
    	}
    	addSelected();
    }
 
    /*
    * 
    */
       
    public void removeAll() {
    	for(itemWrapper i : selectedItems) {
    		i.selected = true;
    	}
    	removeSelected();
    }
 
    /*
    * 
    */
       
      public class itemWrapper {
    	public string Id;
    	public string Name {get; set;}
    	public string Location {get; set;}
        public boolean selected {get;  set;}
        public itemWrapper(string Id, string Name, string Location) {
        	
            this.Id = Id;
            this.Name = Name;
            this.Location = Location;
            this.selected = false;

        } 
    }
}