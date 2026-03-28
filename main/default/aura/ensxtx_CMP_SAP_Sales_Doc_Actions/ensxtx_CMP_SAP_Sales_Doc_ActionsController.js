({
    doInit: function (component, event, helper) {
        component.set("v.displaySpinner", true);
        helper.getDetail(component, helper)
            .then($A.getCallback(function() {
                return helper.getButtons(component, helper);
            }))
            .then($A.getCallback(function() {
                component.set('v.displaySpinner', false);
            }))
    },

    handleClickForButton: function(component, event, helper) {
        let value = event.getSource().get("v.name");
        let selectedButton = component.get('v.buttonList').find(button => button.Value == value);
        let flowInputParams = [];
        let DocTypeSap = component.get('v.SAPDocType');
        if (selectedButton.SAPDocType) {
            // Go To SalesDoc flow
            let flowName = '';

            switch(selectedButton.SAPDocType) {
                case 'Order':
                    flowName = 'ensxtx_enosiX_Sales_Document_Create_Order';
                    break;
                case 'Quote':
                    flowName = 'ensxtx_enosiX_Sales_Document_Create_Quote';
                    break;
                case 'Contract':
                    flowName = 'ensxtx_enosiX_Sales_Document_Create_Contract';
                    break;
                case 'Inquiry':
                    flowName = 'ensxtx_enosix_Sales_Document_Create_Inquiry';
                    break;
                case 'Credit Memo':
                    flowName = 'ensxtx_enosix_Sales_Document_Create_CreditMemo';
                    break;
                case 'Debit Memo':
                    flowName = 'ensxtx_enosix_Sales_Document_Create_DebitMemo';
                    break;
                case 'Return Order':
                    flowName = 'ensxtx_enosix_Sales_Document_Create_ReturnOrder';
                    break;
                case 'Add Attachment':
                    flowName = 'ensxtx_enosix_GOS_Attachment';
                    break;
                default:
                    break;
            }

            flowInputParams = [
                {name: 'recordId', type: 'String', value: component.get('v.SFRecordId')},
                {name: 'sapDocNumber', type: 'String', value: component.get('v.SAPDocNum')}
            ];

            if (selectedButton.Value === 'Clone') {
                flowInputParams.push({name: 'isClone', type: 'Boolean', value: true});
            }
            else if (selectedButton.Value === 'Update') {
                flowInputParams.push({name: 'isUpdate', type: 'Boolean', value: true});
            }
            else if(selectedButton.Value === 'Add Attachment'){
                flowInputParams.push({name: 'sapDocType', type: 'String', value: DocTypeSap});
            }

            component.find('overlayLibActions').notifyClose();

            setTimeout(function() {
                $A.createComponent("lightning:overlayLibrary", {},
                    function(component1, status1, errorMessage1) {
                        if (status1 === 'SUCCESS') {
                            $A.createComponent("lightning:flow", {},
                                function(component2, status2, errorMessage2) {
                                    if (status2 === 'SUCCESS') {
                                        component1.showCustomModal({
                                            showCloseButton: true,
                                            body: component2
                                        }).then(overlay => {
                                            component2.startFlow(flowName, flowInputParams);
                                        })
                                    }
                                })

                        }
                    })
            }, 100)
        }
        else {
            // Go To Record Page
            var navEvt = $A.get("e.force:navigateToSObject");
            var pageReference = JSON.parse(selectedButton.PageReference);
            navEvt.setParams({
                "recordId": pageReference.attributes.recordId,
                "slideDevName": "detail"
            });
            navEvt.fire();
		}
    }
})