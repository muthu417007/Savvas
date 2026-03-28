/**
 * Wrapper class for the top novigation menu items
   This was formerly MenuHolder2
 */
global without sharing class MenuHolder implements Comparable {
    // Menu item id
    public String id {get; protected set;}
    // Parent item id
    public String parent {get; protected set;}
    // Item name
    public String name {get; protected set;}
    // Item url
    public String url {get; protected set;}
    // Sub items list
    public List<MenuHolder> items {get; protected set;}
    // Item order
    private Integer order;

    public MenuHolder() {
        this.name   = null;
        this.url    = null;
        this.id     = null;
        this.parent = null;
        this.order  = 0;
        items       = new List<MenuHolder>();
    }

    public MenuHolder(String itemId, String name, String url, Integer order) {
        this.name   = name;
        this.url    = url;
        this.id     = itemId;
        this.parent = null;
        this.order  = order == null ? 999 : order;
        items       = new List<MenuHolder>();
    }

    public MenuHolder(String itemId, String name, String url, Integer order, String parent) {
        this.name   = name;
        this.url    = url;
        this.id     = itemId;
        this.parent = parent;
        this.order  = order == null ? 999 : order;
        items       = new List<MenuHolder>();
    }

    // Add sub items
    public void addItem(MenuHolder mh) {
        items.add(mh);
    }

    // Sort items by the order field
    public void sort() {
        if (items.isEmpty()) {
            return;
        }
        this.items.sort();
        for (MenuHolder mh : items) {
            mh.sort();
        }            
    }

    // Serialize object to JSON
    public String getJSON() {
        return JSON.serialize(this);
    }

/*
    static global void importMenu() { 
        list<CocoMenu__c> cms = new list<CocoMenu__c>();
        String order = '0';

        MenuHolder mh = RESTMenu.getMenu();
        mh.sort();
        //import top level item
        CocoMenu__c cm = new CocoMenu__c();
        cm.Url__c = mh.url;
        cm.order__c = order;
        cm.Name = mh.name.substring(0, mh.name.length()>38 ? 38 : mh.name.length());
        cm.Label__c = mh.name;
        cms.add(cm);
        //import sub items
        importSubItems(mh.items, order, cms);

        insert cms;
    }

    static private void importSubItems(List<MenuHolder> mhs, String order, list<CocoMenu__c> cms) {
        if (mhs != null && mhs.size() > 0) {
            Integer i = 0;
            for (MenuHolder mh: mhs) {
                CocoMenu__c cm = new CocoMenu__c();
                cm.Url__c = mh.url;
                cm.order__c = order + '.' + String.valueOf(i);
                cm.Name = mh.name.substring(0, mh.name.length()>38 ? 38 : mh.name.length());
                cm.Label__c = mh.name;
                cms.add(cm);
                importSubItems(mh.items, cm.order__c, cms);
                i++;
            }
        }
    }
*/

    // Method required by Comparable interface. Compares menu items by the order field
    global Integer compareTo(Object compareTo) {
        MenuHolder mh = (MenuHolder) compareTo;
        Integer returnValue = 0;
        if (order > mh.order) {
            returnValue = 1;
        } else if (order < mh.order) {
            returnValue = -1;
        }
        return returnValue;
    }
}