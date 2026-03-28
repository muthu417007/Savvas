({
    doInit: function (component, event, helper) {

        component.set('v.searchParams.MaterialNumber',  component.get('v.defaultMaterial'));
        component.set('v.searchParams.MaterialDescription', component.get('v.defaultSearchDescription'));

        helper.buildColumns(component);

        var pagingOptions = {pageNumber: 1, pageSize: component.get('v.maxNumberOfRows')};

        component.set('v.displaySpinner', true);
        helper.getProductHierarchies(component)
            .then($A.getCallback(function() {
                return helper.getMaterialTypes(component);
            }))
            .then($A.getCallback(function() {
                if (component.get('v.fieldSettings.autoSearch.enable')) {
                    return helper.searchMaterials(component, pagingOptions);
                }
            }))
            .then($A.getCallback(function() {
                component.set('v.displaySpinner', false);
                component.set('v.initComplete', true);
            }))
    },

    onSearch: function (component, event, helper) {
        helper.search(component, event, helper); 
    },

    onSelectRow: function(component, event, helper) {
        var multiSelect = component.get('v.fieldSettings.multiSelect.enable');

        if(!multiSelect) {
            helper.saveToItems(component, event);
        }
    },

    onCellChange: function (component, event, helper) {
        var draftValues = event.getParam('draftValues');
        var draftValuesList = component.get('v.draftValuesList');
        let keyField = component.get('v.keyField');

        draftValues.forEach(function(thisDraftValue)
        {
            let keyValue = thisDraftValue[keyField];
            for (const fieldName in thisDraftValue) {
                if (fieldName !== keyField) {
                    let fieldValue = thisDraftValue[fieldName];

                    if (fieldValue) {
                        let qIndex = draftValuesList.findIndex(qValue => qValue[keyField] === keyValue && qValue[fieldName] != undefined);
                        if (qIndex > -1) {
                            draftValuesList.splice(qIndex, 1);
                        }
                    }
                }
            }

            draftValuesList.push(thisDraftValue);
        });

        component.set('v.draftValuesList', draftValuesList);
    },


    addMaterials: function(component, event, helper) {
        helper.saveToItems(component, event);
    },

    handleSelectedSearchValue: function(component, event, helper) {
        let value = event.getParam('selectedValue');
        component.set('v.searchParams.ProductHierarchy', value);
        helper.search(component, event, helper);
    },

    onKeyPressInputText: function(component, event, helper) {
        if (event.code == 'Enter'){
            helper.search(component, event, helper);
        }
    },

    onPagerChanged: function(component, event, helper) {
        component.set('v.displaySpinner', true);
        helper.searchMaterials(component, event.getParam('options'))
            .then($A.getCallback(function() {
                component.set('v.displaySpinner', false);
            }))
    },

    onClickCancel: function(component, event, helper) {
        component.find("overlayLibMatSearch").notifyClose();
    },

    onClickDebug: function(component, event, helper) {
        const parameters = {
            searchParams: component.get('v.searchParams'),
            defaultMaterialTypes: component.get('v.defaultMaterialTypes')
        }

        const debugProperties = [
            { label: 'fieldSettings', value: component.get('v.fieldSettings')},
            { label: 'parameters', value: parameters}
        ]

        $A.createComponent("c:ensxtx_CMP_DebugModal", {
            'debugProperties': debugProperties,
            'httpTraces': component.get('v.httpTraces')
        },
        function (content, status) {
            if (status === "SUCCESS") {
                component.find('overlayLibMatSearch')
                    .showCustomModal({
                        body: content,
                        showCloseButton: true,
                        cssClass: "slds-modal_large",
                        closeCallback: function () {

                        }
                    })
            }
        });
    }
})