public with sharing class CommunitiesTemplateController {
    public String menuJSon {get; protected set;}

    public CommunitiesTemplateController() {
        // Get menu items for the top navigation bar
        MenuHolder m = RESTMenu.getMenu();
        if ( m != null) {
            m.sort();
            menuJSon =  m.getJSON();
        } else {
            menuJSon = 'false';
        }
    }
}