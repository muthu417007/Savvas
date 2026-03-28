public  class CommunitiesCaseController {
	
	/* controller will capture the filter in place when user selected
	*  case from case list.
	*/
	
	public string filterId {get; set;}
	
	public CommunitiesCaseController(ApexPages.StandardController  ctrl){
		string filter = ApexPages.currentPage().getParameters().get('filterId');
		if (filter != null)
			filterId = filter;
	}
	
	
}