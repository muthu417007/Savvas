({
    onSortClick: function(component, event, helper) {
        var evt = component.getEvent('sortItemsEvent');
        evt.setParams({itemsJson:JSON.stringify(component.get('v.items'))});
        evt.fire();
        component.find('overlayLibItemSort').notifyClose();
    },

    onClickCancel: function(component, event, helper) {
        component.find("overlayLibItemSort").notifyClose();
    },
})