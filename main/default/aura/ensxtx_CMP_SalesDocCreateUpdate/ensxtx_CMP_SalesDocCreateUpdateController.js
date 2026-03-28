({
    onInit: function(component, event, helper) {

        let recordId = component.get('v.recordId');
        if (!recordId) {
            component.set('v.messages', {messageType: 'ERROR', message: $A.get('$Label.c.ensxtx_SalesDoc_Message_RecordIdNotFound')});
            component.set('v.displaySpinner', false);
            return;
        }

        let isValid = true;

        // Additional flag to check if everything successful before document create for autoInvoke
        let isSuccessful = true;

        helper.loadAppSettings(component)
            .then($A.getCallback(function(res) {
                return helper.initSFObject(component, recordId, helper);
            }))
            .then(
                $A.getCallback(
                    function() {
                        console.log('resolve initSFObject');
                        return helper.getCustomerDetail(component, helper);
                    }
                ),function() {
                    console.log('reject initSFObject');
                    isValid = false;
                    return Promise.reject();
                }
            )
            .then($A.getCallback(function() {
                let sapDocNumber = component.get('v.sapDocNumber');
                let isUpdate = component.get('v.isUpdate');
                let isClone = component.get('v.isClone');

                if (sapDocNumber) {
                    if (isUpdate) {
                        return helper.getSalesDocDetail(component, sapDocNumber, helper);
                    }
                    else if (isClone) {
                        return helper.getReferenceDocument(component, sapDocNumber, helper);
                    }
                }
                else {
                    helper.setInitSalesDocFromCustomer(component, helper);
                    return helper.setSalesDocFromSobject(component, helper);
                }
            }))
            .then($A.getCallback(function() {
                let status = component.get('v.status') ? component.get('v.status') : component.get('v.sfObject.status');
                if (component.get('v.salesDocDetail.SalesDocument')) {
                    status = 'Update';
                }
                component.set('v.sfObject.status', status);
                component.set('v.status', status);

                helper.getFieldSettings(component);
                helper.validateSalesAreaAfterLoad(component, helper)
            }))
            .then($A.getCallback(function(res) {
                // Call to RFCs here
                return Promise.all([
                    helper.getShipInfo(component, helper),
                    helper.getPricingStat(component, helper),
                    helper.getBillingPlans(component, helper),
                    helper.getGroupOffice(component, helper),
                    helper.getRejectionReasons(component, helper),
                ])
            }))
            .then($A.getCallback(function() {
                console.log('return from resolve');
                let fieldSettings = component.get('v.fieldSettings');
                let appSettings = component.get('v.appSettings');
                let skipConditions = fieldSettings.autoInvoke && !appSettings.incompletionLogsAsErrors;
                if (skipConditions) {
                    return Promise.all([
                        helper.getConditions(component, true, helper),
                        helper.getConditions(component, false, helper),
                    ]);
                }
            }),function() {
                console.log('return from reject');
                isSuccessful = false;
            })
            .then($A.getCallback(function() {
                if (component.get('v.displayPurgeSAPQuote')) {
                    if (isValid && component.get('v.appSettings')) {
                        let fieldSettings = component.get('v.fieldSettings');
                        let status = component.get('v.status');

                        if (fieldSettings && fieldSettings.autoInvoke && isSuccessful && (status === 'Create' || status === 'Update')) {
                            return helper.purgeForUpdate(component, helper);
                        }
                    }
                    console.log('final resolve');
                    component.set('v.displaySpinner', false);
                    return Promise.resolve();
                } else return helper.finishSalesDocLoad(component, helper, isValid, isSuccessful);
            }));
    },

    // Adding material from the input textbox
    addMaterial: function(component, event, helper) {
        helper.addByMaterialNumber(component, event, helper);
    },

    addMaterials: function(component, event, helper) {
        let searchParams = {
            SalesOrganization: component.get('v.salesDocDetail.SALES.SalesOrganization'),
            DistributionChannel: component.get('v.salesDocDetail.SALES.DistributionChannel'),
        }
        $A.createComponent("c:ensxtx_CMP_MaterialSearch", {
                searchParams: searchParams,
                fieldSettings: component.get('v.fieldSettings.Fields.MaterialSearchTable'),
                allowDebug: component.get('v.sfObject.allowDebug')
            },
            function (content, status) {
                content.addEventHandler('selectMaterialsEvent',
                    component.getReference('c.onReceiveMaterials'));
                if (status === "SUCCESS") {
                    component.find('overlayLib1')
                        .showCustomModal({
                            header: $A.get('$Label.c.ensxtx_SalesDoc_Title_MaterialSearch'),
                            body: content,
                            showCloseButton: true,
                            cssClass: "slds-modal_large",
                            closeCallback: function () {

                            }
                        })
                }
            });
    },

    importMaterials: function(component, event, helper) {
        $A.createComponent("c:ensxtx_CMP_ImportMaterialsCSV", {},
            function (content, status) {
                content.addEventHandler('selectMaterialsEvent',
                    component.getReference('c.onReceiveMaterials'));
                if (status === "SUCCESS") {
                    component.find('overlayLib1')
                        .showCustomModal({
                            header: $A.get('$Label.c.ensxtx_ImportMaterial_Label_ImportMaterialsFromCSV'),
                            body: content,
                            showCloseButton: true,
                            cssClass: "slds-modal_large",
                            closeCallback: function () {

                            }
                        })
                }
            });
    },

    onReceiveMaterials: function(component, event, helper) {
        let selectedItems = event.getParam('selectedItems');
        let itemsJSON = JSON.parse(selectedItems);
        helper.addMaterialsForBulkImport(component, helper, itemsJSON, null);
    },

    onFinalizeConfiguration: function(component, event, helper) {
        console.log('finalize configuration');
        let characteristics = event.getParam('finalizedConfig');
        let vcSummaryJSON = event.getParam('vcSummaryJSON');
        let itemNumber = event.getParam('itemNumber');
        let isComplete = event.getParam('isComplete');
        let isInputChanged = event.getParam('isInputChanged');
        let printedCharacteristics = event.getParam('printedCharacteristics');
        let orderQuantity = event.getParam('orderQuantity');
        let items = component.get('v.salesDocDetail.ITEMS');
        for (let key in items) {
            if (items[key].ItemNumber === itemNumber) {
                items[key].vcSummaryJSON = vcSummaryJSON;
                items[key].ItemConfigurations = characteristics;
                items[key].isConfigurationFromVCComplete = isComplete;
                items[key].OrderQuantity = orderQuantity;
                items[key].isNeedConfigure = false;
                items[key].isChanged = isInputChanged;
                if (printedCharacteristics && printedCharacteristics.length) {
                    items[key].PrintedCharacteristics = printedCharacteristics;
                }
                break;
            }
        }
        component.set('v.salesDocDetail.ITEMS', items);
        component.set('v.messages', []);
        let appSettings = component.get('v.appSettings');

        if (appSettings.autoSimulate.afterItemConfiguration) {
            component.set('v.displaySpinner', true);
            helper.simulateSalesDoc(component, helper)
                .then($A.getCallback(function() {
                    component.set('v.displaySpinner', false);
                }), function() {
                    component.set('v.displaySpinner', false);
                })
        }
    },

    onPurgeClick: function(component, event, helper) {
        component.set('v.displaySpinner', true);
        helper.purgeForUpdate(component, helper);
    },
    
    onCancelClick: function(component, event, helper) {
        if(component.get('v.isConfigurationChanged')){
            component.set('v.exitWithoutSavingAlertModalWindowIsActive', true);
        } else {
            helper.navigateToDetail(component);
        }
    },

    updateItem: function(component, event, helper) {
        let isItemEdited = event.getParam('isItemEdited');
        let item = event.getParam('item');
        if (isItemEdited) {
            let lineItems = component.get('v.salesDocDetail.ITEMS');
            for (let key in lineItems) {
                let lineItem = lineItems[key];
                if (lineItem.ItemNumber === item.ItemNumber) {
                    lineItems[key] = item;
                    break;
                }
            }
            component.set('v.salesDocDetail.ITEMS', lineItems);
            component.set('v.messages', []);

            let appSettings = component.get('v.appSettings');

            if (appSettings.autoSimulate.afterItemEditSave) {
                component.set('v.displaySpinner', true);
                helper.simulateSalesDoc(component, helper)
                    .then($A.getCallback(function() {
                        console.log('simulate click resolve');
                        component.set('v.displaySpinner', false);
                    }), function() {
                        console.log('simulate click reject');
                        component.set('v.displaySpinner', false);
                    })
            }
        }
    },

    onSimulateClick: function(component, event, helper) {
        component.set('v.displaySpinner', true);
        component.set('v.messages', []);

        helper.simulateSalesDoc(component, helper)
            .then($A.getCallback(function() {
                console.log('simulate click resolve');
                component.set('v.displaySpinner', false);
            }), function() {
                console.log('simulate click reject');
                component.set('v.displaySpinner', false);
            })
    },

    onClickEnosixLogo: function(component, event, helper) {
        let allowDebug = !component.get('v.sfObject.allowDebug');
        let message = 'Debug mode is ' + (allowDebug ? 'on' : 'off');
        component.set('v.sfObject.allowDebug', allowDebug);
        helper.showToast('Debug', message, 'INFO');
    },

    onClickDebug: function(component, event, helper) {
        const debugProperties = [
            { label: 'salesDocDetail',  value: component.get('v.salesDocDetail')},
            { label: 'appSettings',     value: component.get('v.appSettings')},
            { label: 'fieldSettings',   value: component.get('v.fieldSettings')},
            { label: 'sfObject',        value: component.get('v.sfObject')},
            { label: 'customerDetail',  value: component.get('v.customerDetail')},
            { label: 'materialsDetail', value: component.get('v.materialsDetail')},
            { label: 'materialsUOM',    value: component.get('v.materialsUOM')}
        ]

        $A.createComponent("c:ensxtx_CMP_DebugModal", {
            'debugProperties': debugProperties,
            'httpTraces': component.get('v.httpTraces')
        },
        function (content, status) {
            if (status === "SUCCESS") {
                component.find('overlayLib1')
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

    onSortClick: function(component, event, helper) {
        let sortIncrement = component.get('v.appSettings.sortOrderIncrement');
        if (sortIncrement == null || sortIncrement <=0) sortIncrement = 10;
        let sortOrder = sortIncrement;
        let items = component.get('v.salesDocDetail.ITEMS');
        let childSortOrder = 999999999999;
        items.forEach(item => {
            if (item.HigherLevelItemNumber == '000000') {
                item.SortOrder = sortOrder;
                sortOrder += sortIncrement;
            }
            else item.SortOrder = childSortOrder++;
        });
        $A.createComponent("c:ensxtx_CMP_SalesDocLineItemsTable", {
            'isSortMode': true,
            'items': items,
            'fieldSettings': component.get('v.fieldSettings.Fields.ItemSortTable')
        },
        function (content, status) {
            content.addEventHandler('sortItemsEvent',
                component.getReference('c.onSortItems'));
            if (status === "SUCCESS") {
                component.find('overlayLib1')
                    .showCustomModal({
                        header: $A.get('$Label.c.ensxtx_SalesDoc_Title_ItemsSort'),
                        body: content,
                        showCloseButton: true,
                        cssClass: "slds-modal_large",
                        closeCallback: function () {
                            let items = component.get('v.salesDocDetail.ITEMS');
                            items.forEach(item => {
                                item.SortOrder = 0;
                            });
                        }
                    })
            }
        });

    },

    onSortItems: function(component, event, helper) {
        let itemsJson = event.getParam('itemsJson');
        let items = JSON.parse(itemsJson);

        helper.sortSalesDoc(component, helper, items);

        component.set('v.displaySpinner', true);
        component.set('v.messages', []);

        let appSettings = component.get('v.appSettings');
        if (appSettings.autoSimulate.afterSortItems) {
            helper.simulateSalesDoc(component, helper)
            .then($A.getCallback(function() {
                console.log('simulate click resolve');
                component.set('v.displaySpinner', false);
            }), function() {
                console.log('simulate click reject');
                component.set('v.displaySpinner', false);
            })
        }
        else {
            component.set('v.displaySpinner', false);
        }
    },

    onSalesAreaChange: function(component, event, helper) {
        helper.onSalesAreaChange(component, event, helper);
    },

    onSalesOfficeChange: function(component, event, helper) {
        let salesDocDetail = component.get('v.salesDocDetail');
        helper.onSalesOfficeChange(component, helper, salesDocDetail);
        component.set('v.salesDocDetail', salesDocDetail);
    },

    onFieldSelectChange: function(component, event, helper) {
        let inputName = event.getSource().get('v.name');
        helper.onFieldChange(component, inputName, helper);
    },

    onInputDateChange: function(component, event, helper) {
        let inputName = event.getSource().get('v.name');
        helper.onFieldChange(component, inputName, helper);
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
            if ((inputName === 'salesOrg' || inputName === 'distChannel' || inputName === 'divison')) {
                helper.onSalesAreaChange(component, event, helper);
            }
            else {
                helper.onFieldChange(component, inputName, helper);
            }
        }
        component.set('v.onFocusInputValue', null);
    },

    onSelectedSerial: function(component, event, helper) {
        let selectedSerial = event.getParam('selectedSerial');
        if (selectedSerial && selectedSerial.material) {

            let materials = [{
                material: selectedSerial.material,
                quantity: 1
            }];

            helper.addMaterials(component, helper, materials, selectedSerial);
        }
    },

    onCreate: function(component, event, helper) {
        helper.onCreate(component, helper);
    },

    onSave: function(component, event, helper) {
        component.set('v.displaySpinner', true);
        component.set('v.messages', []);

        helper.simulateSalesDoc(component, helper)
            .then($A.getCallback(function() {
                return helper.saveToSObject(component, helper);
            }))
            .then($A.getCallback(function() {
                console.log('success save');
                helper.navigateToDetail(component);
            }), function() {
                console.log('reject save');
                component.set('v.displaySpinner', false);
            });
    },

    onPartnerChange: function(component, event, helper) {
        console.log('onPartnerChange');
        let salesDocDetail = component.get('v.salesDocDetail');
        salesDocDetail.PARTNERS = event.getParam("partners");
        component.set('v.salesDocDetail', salesDocDetail);

        let appSettings = component.get('v.appSettings');
        component.set('v.messages', []);

        if (appSettings.autoSimulate.afterPartnerSelection) {
            component.set('v.displaySpinner', true);
            helper.simulateSalesDoc(component, helper)
                .then($A.getCallback(function() {
                    console.log('simulate resolve');
                    component.set('v.displaySpinner', false);
                }), function() {
                    console.log('simulate reject');
                    component.set('v.displaySpinner', false);
                });
        }
    },
    
    onLineItemChange: function(component, event, helper) {
        helper.checkSalesDocDetailChanged(component);
    },

    onConditionValueChange: function(component, event, helper) {
        helper.checkSalesDocDetailChanged(component);
    },

    onChangeSalesDocDetail: function(component, event, helper) {
        helper.checkSalesDocDetailChanged(component);
    },

    onChangeHeaderCondition: function(component, event, helper) {
        helper.checkSalesDocDetailChanged(component);
    },

    onChangeHeaderText: function(component, event, helper) {
        helper.checkSalesDocDetailChanged(component);
    },

    onClickNoExitWithoutSavingAlertModalWindow: function(component, event, helper) {
        component.set('v.exitWithoutSavingAlertModalWindowIsActive', false);
    },

    onClickYesExitWithoutSavingAlertModalWindow: function(component, event, helper) {
        helper.navigateToDetail(component);
    },

    onKeyPressMaterialNumber: function(component, event, helper) {
        if (event.code == 'Enter' && component.get('v.isSalesDocValid')) {
            helper.addByMaterialNumber(component, event, helper);
        }
    },

    handleRowActionEvent: function(component, event, helper) {
        let item = event.getParam("item");
        let actionName = event.getParam("actionName");
        helper.onRowAction(component, helper, item, actionName);
    },

    handleVcSessionData: function(component, event, helper) {
        if (event && event.getParam('sessionData')) {
            component.set('v.vcSessionData', event.getParam('sessionData'));
        }
    }
})