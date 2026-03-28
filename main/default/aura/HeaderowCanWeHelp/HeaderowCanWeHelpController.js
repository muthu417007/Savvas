({
	doInit : function(component, event, helper) {
        var url = $A.get('$Resource.SavvasHomeBlueBackDrop');
        component.set('v.backgroundImageURL', url);
		
	}
})