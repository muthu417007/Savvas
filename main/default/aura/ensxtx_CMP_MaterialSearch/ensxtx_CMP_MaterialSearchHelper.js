({
    buildColumns: function(component) {
        let fieldSettings = component.get('v.fieldSettings');

        var columns = [];
        columns.push({label: $A.get('$Label.c.ensxtx_SalesDoc_Table_Material'), fieldName: 'Material', type: 'text'});
        if (fieldSettings.materialType.display) {
            columns.push({label: $A.get('$Label.c.ensxtx_SalesDoc_Table_MaterialType'), fieldName: 'MaterialType', type: 'text'});
        }
        if (fieldSettings.materialDescription.display) {
            columns.push({label: $A.get('$Label.c.ensxtx_SalesDoc_Table_ItemDescription'), fieldName: 'MaterialDescription', type: 'text'});
        }
        if (fieldSettings.productHierarchyField.display) {
            columns.push({label: $A.get('$Label.c.ensxtx_SalesDoc_Table_Category'), fieldName: 'ProductHierarchyField', type: 'text'});
        }
        if (fieldSettings.quantity.display) {
            columns.push({label: $A.get('$Label.c.ensxtx_SalesDoc_Table_Quantity'), fieldName: 'OrderQuantity', type: 'number', editable: true,
                typeAttributes: { maximumFractionDigits: '3' }});
        }
        if (fieldSettings.unitOfMeasure.display) {
            columns.push({label: $A.get('$Label.c.ensxtx_SalesDoc_Table_UnitOfMeasure'), fieldName: 'BaseUnitOfMeasure', type: 'text'});
        }
        if (fieldSettings.scheduleDate.display) {
            columns.push({label: $A.get('$Label.c.ensxtx_SalesDoc_Table_RequestedDate'), fieldName: 'ScheduleDate', type: 'date-local', editable: true});
        }

        component.set('v.columns', columns);
    },

    getMaterialTypes: function(component) {
        return new Promise(function(resolve, reject) {
            if (component.get('v.fieldSettings.materialTypeSearch.display')) {
                var action = component.get('c.loadMaterialTypes');
                action.setParams({
                    defaultMaterialTypes: component.get('v.defaultMaterialTypes')
                });        
                action.setCallback(this, function (data) {
                    if (data.getReturnValue()) {
                        var response = data.getReturnValue();
                        if (response.data.length > 0) {
                            var data = response.data;
                            component.set('v.materialTypeSelectOptions', data);
    
                            var materialTypeValues = [];
                            for (var dataCnt = 0; dataCnt < data.length; dataCnt++) {
                                materialTypeValues[dataCnt] = data[dataCnt].value;
                            }
                            component.set('v.searchParams.MaterialTypeValues', materialTypeValues);
                        }
                        else component.set('v.fieldSettings.materialTypeSearch.display', false);

                        if (response.httpTraces && response.httpTraces.length) {
                            let httpTraces = component.get('v.httpTraces')
                            response.httpTraces.forEach(trace => httpTraces.unshift(trace))
                        }
                    }
                    resolve(true);
                });
    
                $A.enqueueAction(action);
            }
            else resolve(true);
        });          
    },

    getProductHierarchies: function(component) {
        return new Promise(function(resolve, reject) {
            if (component.get('v.fieldSettings.productHierarchyField.display')) {    
                var action = component.get('c.loadProductHierarchies');       
                action.setCallback(this, function (data) {
                    if (data.getReturnValue()) {
                        var response = data.getReturnValue();
                        if (response.data.length > 0) {
                            var data = response.data;
                            component.set('v.productHierarchies', data);
                        }

                        if (response.httpTraces && response.httpTraces.length) {
                            let httpTraces = component.get('v.httpTraces')
                            response.httpTraces.forEach(trace => httpTraces.unshift(trace))
                        }
                    }
                    resolve(true);
                });
                $A.enqueueAction(action);
            }
            else resolve(true);
        });
    },

    searchMaterials: function(component, pagingOptions) {
        return new Promise(function(resolve, reject) {
            var action = component.get('c.searchMaterials');
            
            action.setParams({
                searchParams: component.get('v.searchParams'), 
                pagingOptions: pagingOptions
            });

            action.setCallback(this, function (data) {
                if (data.getReturnValue()) {
                    var response = data.getReturnValue();
                    let keyField = component.get('v.keyField');
                    
                    response.data.forEach((row, index) => {
                        if (keyField === 'Id') {
                            row.Id = 'row-' + index;
                        }

                        if (row.ProductHierarchy && row.ProductHierarchyDescription) {
                            row.ProductHierarchyField = row.ProductHierarchy + ' - ' + row.ProductHierarchyDescription;
                        }

                        row.OrderQuantity = 1;
                        row.ScheduleDate = null;
                        row.isSelected = false;
                    })
                    
                    component.set('v.searchResults', response.data);
                    let messages = response.messages;
                    component.set('v.pagingOptions', response.pagingOptions);

                    if (response.data.length == 0) {
                        var errorMessage = {
                            message: $A.get('$Label.c.ensxtx_SalesDoc_Message_SearchNoResult'), 
                            messageType: "INFO"
                        };
                        component.set('v.messages', messages.push(errorMessage));
                        component.set('v.displayResults', []);
                    }
                    else {
                        component.set('v.displayResults', response.data);
                    }

                    component.set('v.messages', messages);

                    if (response.httpTraces && response.httpTraces.length) {
                        let httpTraces = component.get('v.httpTraces')
                        response.httpTraces.forEach(trace => httpTraces.unshift(trace))
                    }
                }
                resolve(true);            
            });
            $A.enqueueAction(action);
        });
    },


    saveToItems: function(component, event)
    {
        let updatedSelectedRows = this.updateSelectedDraftValues(component, event);
        var isInFlow = component.get('v.fieldSettings.separateFlowComponent.enable');

        // Convert the selected items to an object that can be read by the line item
        let convertedItemsList = updatedSelectedRows.map(item => {
            return {
                Material: item.Material,
                ItemDescription: item.MaterialDescription,
                OrderQuantity: item.OrderQuantity,
                SalesUnit: item.BaseUnitOfMeasure,
                ScheduleLineDate: item.ScheduleDate,
                ConfigurableMaterial: item.ConfigurableMaterial
            }
        })

        //convert Map to JSON
        var itemJSONList = JSON.stringify(convertedItemsList);

        //if added directly to a flow, set as variable, navigate to next
        if(isInFlow)
        {
            component.set('v.selectedItemsJSON', itemJSONList);
            //TODO:navigate next
        }
        else //if called from a flow component: set event value, fire event, close    
        {
            var evt = component.getEvent('selectMaterialsEvent');
            evt.setParams({selectedItems:itemJSONList});
            evt.fire();
            component.find('overlayLibMatSearch').notifyClose();
        }
    },

    updateSelectedDraftValues: function(component, event) {

        let materialTable = component.find('materialTable');
        var selectedItems = materialTable.getSelectedRows();
        var draftValues = component.get('v.draftValuesList');
        let keyField = component.get('v.keyField');

        //roll through selected materials, and apply draftValues
        selectedItems.forEach(function(thisItem, i) {
            var keyValue = thisItem[keyField];
            var filteredDraft = draftValues.filter(mDraft => mDraft[keyField] == keyValue);

            if (filteredDraft.length > 0)
            {
                filteredDraft.forEach(function(draft)
                {
                    for (const draftField in draft) {
                        let draftValue = draft[draftField];
                        if (draftValue) {
                            thisItem[draftField] = draft[draftField];
                        }
                    }
                });
            }

        });

        return selectedItems;
    },

    search: function(component, event, helper) {
        var pagingOptions = {pageNumber: 1, pageSize: component.get('v.maxNumberOfRows')};
        component.set('v.displaySpinner', true);
        helper.searchMaterials(component, pagingOptions)
            .then($A.getCallback(function() {
                component.set('v.displaySpinner', false);
            }))
    },
})