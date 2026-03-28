/**
 * Rest Class responsible for returning menut items
 */
@RestResource(urlMapping='/menu/*')
global class RESTMenu {
    //
    @HttpGet global static void doGet() {
        RestResponse rr = RestContext.response;
        // Check if menuVar parameter was set
        string menuVar; 
        try {
        	 menuVar = RestContext.request.params.get('menuVar');
        }
        // for test method
        catch(exception e) {
        	menuVar = 'menu';
        }
        if (String.isNotBlank(menuVar)) {
            if (Pattern.compile('^[a-z][a-z0-9_]*$').matcher(menuVar).matches()) {
                menuVar += ' = ';
            } else {
                menuVar = '';
            }
        } else {
            menuVar = '';            
        }

        MenuHolder m = RESTMenu.getMenu();

		if (!test.isRunningTest()) {
	        // Set Content-Type header for the respone
	        rr.addHeader('Content-Type', 'text/javascript');
	        // Set response content - JSON string
	        if ( m != null) {
	            m.sort();
	            rr.responseBody = Blob.valueOf(menuVar + m.getJSON());
	        } else {
	            rr.responseBody = Blob.valueOf(menuVar + '{}');
	        }
		}
    }



    // Return top level item with all subitems
    // this was formerly getMenu2()
    global static MenuHolder getMenu() {
        // Get all menu items
        Map<String, MenuHolder> menus = new Map<String, MenuHolder>();
        
        List<CocoMenu__c> mmenus = CocoMenu__c.getall().values();
        for (CocoMenu__c mmenu : mmenus) {
            String tmpId = mmenu.order__c;
            String tmpOrder = tmpId.substringAfterLast('.');
            if (String.isBlank(tmpOrder)) {
                tmpOrder = '0';
                tmpId = '-1';
            } else {
                tmpId = tmpId.substringBeforeLast('.');
            }            
            menus.put(mmenu.order__c, new MenuHolder (mmenu.order__c, mmenu.Label__c, mmenu.url__c, Integer.valueOf(tmpOrder), tmpId));
        }
system.debug(menus);
        // Build menu tree
        Map<String, MenuHolder> topMenus  = new Map<String, MenuHolder>();
        for (MenuHolder mh : menus.values()) {
            if (mh.parent != '-1') {
                menus.get(mh.parent).addItem(mh);
            } else {
                topMenus.put(mh.Id, mh);
            }
        }

        // Return menu
        if (topMenus.size() > 0) {
            return topMenus.values()[0];
        } else {
            return null;
        }
    }
}