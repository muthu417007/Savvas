({
    onInit: function(component, event, helper) {
        helper.getItemCategories(component, helper)
            .then($A.getCallback(function() {
                helper.getMaterialAvailability(component, helper);
            }))
            .then($A.getCallback(function() {
                component.set('v.isEditItemInitialized', true);
            }))
    },

    onSimulateClick: function(component, event, helper) {
        helper.prepareSimulate(component, helper);
    },

    onFieldSelectChange: function(component, event, helper) {
        let inputName = event.getParam('name');
        helper.onFieldChange(component, inputName, helper);
    },

    onInputDateChange: function(component, event, helper) {
        let inputName = event.getSource().get('v.name');
        helper.onFieldChange(component, inputName, helper);
        if(inputName == 'Plant') {
            helper.getMaterialAvailability(component, helper);
        }
    },

    onInputFocus: function(component, event, helper) {
        // This is to store the value when input is focus
        // For input type text and number
        let currentValue = event.getSource().get('v.value');
        component.set('v.onFocusInputValue', currentValue);
    },

    onInputBlur: function(component, event, helper) {
        let oldValue = component.get('v.onFocusInputValue');
        let newValue = event.getSource().get('v.value');

        if (oldValue != newValue) {
            let inputName = event.getSource().get('v.name');
            helper.onFieldChange(component, inputName, helper);
        }
        component.set('v.onFocusInputValue', null);
    },

    onChangeItem: function(component, event, helper) {
        helper.itemChanged(component);
    },

    onConditionValueChange: function(component, event, helper) {
        helper.itemChanged(component);
    },

    onPartnerChange: function(component, event, helper) {
        console.log('onPartnerChange');
        let item = component.get('v.item');
        item.PARTNERS = event.getParam("partners");
        component.set('v.item', item);

        let appSettings = component.get('v.appSettings');

        if (appSettings.autoSimulate.afterPartnerSelection) {
            helper.prepareSimulate(component, helper);
        }
    },

    onCancelClick: function(component, event) {
        component.find('overlayLibEdit').notifyClose();
    },

    onSaveClick: function(component, event, helper) {
        var evt = component.getEvent('editItemEvent');
        let item = component.get('v.item');

        let isValid = helper.validateItem(item);
        if (!isValid) return;

        component.set('v.enableItemSimulate', false);

        evt.setParams({
            'isItemEdited': true,
            'item': component.get('v.item')
        });
        evt.fire();
        component.find('overlayLibEdit').notifyClose();
    },

    onClickDebug: function(component, event, helper) {
        const debugProperties = [
            { label: 'item',  value: component.get('v.item')},
            { label: 'fieldSettings',     value: component.get('v.fieldSettings')},
            { label: 'ItemConfigurations',   value: component.get('v.item.ItemConfigurations')}
        ]

        $A.createComponent("c:ensxtx_CMP_DebugModal", {
            'debugProperties': debugProperties,
            'httpTraces': component.get('v.httpTraces')
        },
        function (content, status) {
            if (status === "SUCCESS") {
                component.find('overlayLibEdit')
                    .showCustomModal({
                        body: content,
                        showCloseButton: true,
                        cssClass: "slds-modal_large",
                        closeCallback: function () {

                        }
                    })
            }
        });
    },
})