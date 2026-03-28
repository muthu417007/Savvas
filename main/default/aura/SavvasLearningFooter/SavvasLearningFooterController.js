({
	doInit : function(component, event, helper) {
        var url = $A.get('$Resource.Savvas_Sample_Resources_Logo');
        component.set('v.logo', url);
    }
})