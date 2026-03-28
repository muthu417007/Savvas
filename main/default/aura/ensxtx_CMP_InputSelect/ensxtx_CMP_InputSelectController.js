({
    onInit: function(component, event, helper) {
        helper.updateOptionValues(component);
    },

    onChangeOptionValues: function(component, event, helper) {
        helper.updateOptionValues(component);
    },

    onOptionChange: function(component, event, helper) {
        var evt = component.getEvent('inputSelectChangeEvent');
        evt.setParams({
            name: component.get('v.name')
        });
        evt.fire();
    }
})