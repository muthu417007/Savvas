public with sharing class CommunitiesCaseListController {

	/* controller will set the original filter when use
	*  uses "back" link on detail page.
	*/
		
	public CommunitiesCaseListController(ApexPages.StandardSetController  ctrl){
		string filter = ApexPages.currentPage().getParameters().get('filterId');
		ctrl.setPageSize(50);
		
		List<System.SelectOption> listViews = ctrl.getListViewOptions();

		// Set Filter Id if passed in parameter
		if (filter != null) {
			ctrl.setFilterId(filter);
		}
		else {
			// otherwise set to Recently Viewed  (needed for Browser Back Button when
			// viewing Case Detail
			for(System.SelectOption listView : listViews)
			{
				if (listView.getLabel() == 'Recently Viewed Cases')	
					ctrl.setFilterId(listView.getValue());
			}
		}
	}
	
}