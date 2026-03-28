({
    onInit: function(component, event, helper) {
        let lineItem = component.get('v.lineItem');
        let fieldSettings = component.get('v.fieldSettings');
        component.set('v.isIncomplete', lineItem.ConfigurableMaterial && !lineItem.isConfigurationFromVCComplete);
        let isAccepted = component.get('v.isAccepted');
        let enableConfiguration = component.get('v.enableConfiguration');
        let enableBoMItemEdit = component.get('v.enableBoMItemEdit');
        let isActionDisplayed = false;
        if (fieldSettings) {
            if (!lineItem.BillOfMaterial || lineItem.HigherLevelItemNumber == '000000') {
                if (fieldSettings.ItemActionsView && fieldSettings.ItemActionsView.display) isActionDisplayed = true;
                if (!isAccepted) {
                    if (fieldSettings.ItemActionsEdit && fieldSettings.ItemActionsEdit.display) isActionDisplayed = true;
                    if (fieldSettings.ItemActionsRemove && fieldSettings.ItemActionsRemove.display) isActionDisplayed = true;
                    if (fieldSettings.ItemActionsClone && fieldSettings.ItemActionsClone.display) isActionDisplayed = true;
                    if (lineItem.ConfigurableMaterial && enableConfiguration) isActionDisplayed = true;
                }
            } else {
                if (enableBoMItemEdit) isActionDisplayed = true;
            }
        }
        component.set('v.isActionDisplayed', isActionDisplayed);
    },

    onSelectRowAction: function(component, event, helper) {
        let rowActionEvent = component.getEvent('rowActionEvent');
        rowActionEvent.setParams({
            'item': component.get('v.lineItem'),
            'actionName': event.getParam("value")
        });
        rowActionEvent.fire();
    },

    onLineItemChange: function(component, event, helper) {
        component.set('v.lineItem.isChanged', true);
        if (!component.get('v.needToSimulate')) {
            let action = component.getEvent('lineItemChangeEvent');
            action.fire();
        }        
    }
})