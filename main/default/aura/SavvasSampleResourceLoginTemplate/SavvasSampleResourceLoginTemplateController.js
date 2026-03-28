({
	doInit : function(component, event, helper) {
        var url = $A.get('$Resource.Savvas_Sample_Resources_Background_Image');
        component.set('v.backgroundImageURL', url);
    },
    scriptsLoaded:function(component,event,helper){
    }
})