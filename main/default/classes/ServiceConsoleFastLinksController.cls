public with sharing class ServiceConsoleFastLinksController {
	
	public List<Service_Console_Fast_Links__c> allLinks;
	public string searchField{get; set;}
	
	public ServiceConsoleFastLinksController () {

		Map<String,Service_Console_Fast_Links__c> flMap = Service_Console_Fast_Links__c.getAll();
		allLinks = flMap.values();
		allLinks.sort();   // will sort the custom setting on the Name field	
		
	}
	

	public List<Service_Console_Fast_Links__c> getFastLinks () {

		List<Service_Console_Fast_Links__c> filteredLinks = new List<Service_Console_Fast_Links__c>();
		
		for (Service_Console_Fast_Links__c fl : allLinks){
			if (this.searchField == null)
				filteredLinks.add(fl);
			else if(fl.name.startsWithIgnoreCase(this.searchField))
					filteredLinks.add(fl);
		}
		
		return filteredLinks;
	}	
	
	public pageReference updateList() {
		return null;
	}
	

}