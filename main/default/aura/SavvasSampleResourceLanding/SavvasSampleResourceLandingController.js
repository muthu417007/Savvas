({
    redirectToHome : function(component, event, helper) {
        var url = $A.get("$Label.c.Sitecore_URL_to_whitelist");
        window.open(url);
    },
   
	doInit : function(component, event, helper) {
        var url = $A.get('$Resource.Savvas_Sample_Resources_Header_Image');
        component.set('v.backgroundImageURL', url);
        window.screen.width>900?component.set('v.isMobile', false):component.set('v.isMobile', true);
    }
})