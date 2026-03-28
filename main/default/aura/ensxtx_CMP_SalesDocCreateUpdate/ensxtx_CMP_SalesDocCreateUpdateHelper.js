({
    loadAppSettings: function(component) {
        return new Promise(function(resolve, reject) {
            console.log('init app settings');

            let appSettingsName = component.get('v.appSettingsName');
            let appSettingsNamespace = component.get('v.appSettingsNamespace');
            let appSettingsKey = component.get('v.appSettingsKey');
            let appSettingsTypeName = component.get('v.appSettingsTypeName');

            let staticResourceName = appSettingsNamespace ? appSettingsNamespace + '__' + appSettingsName : appSettingsName

            let staticResource = $A.get('$Resource.' + staticResourceName); 
            let req = new XMLHttpRequest();

            req.open("GET", staticResource);
            req.addEventListener("load", $A.getCallback(function() {
                console.log('loaded app settings');
                let response = JSON.parse(req.response);
                let appSettings = response[appSettingsKey] ? response[appSettingsKey][appSettingsTypeName] : null;
                if (!appSettings) {
                    let messages = [{
                        messageType: 'ERROR', 
                        message: 'App Settings is not found on ' + staticResourceName + '. Please Configure the App Settings first.'
                    }];
                    component.set('v.messages', messages);
                }
                else {
                    component.set('v.appSettings', appSettings);
                }
                resolve();  
            }));
            req.send(null);
        })
    },

    initSFObject: function(component, recordId, helper) {
        return new Promise(function(resolve, reject) {
            console.log('init SalesDoc');
            let action = component.get('c.initSFObject');
            let sapDocNumber = component.get('v.sapDocNumber');

            action.setParams({
                recordId: recordId,
                sapDocType: component.get('v.appSettings.SAPDocType')
            })
            action.setCallback(this, function(res) {
                helper.handleResponse(component, action.getName(), res, resolve, reject,
                    function(data) {
                        if (data) {
                            if (!sapDocNumber && data.sapDocNumber) {
                                sapDocNumber = data.sapDocNumber;
                                component.set('v.sapDocNumber', sapDocNumber);
                            }

                            if (sapDocNumber && !component.get('v.isClone')) {
                                component.set('v.isUpdate', true);
                            }

                            component.set('v.sfObject', data);
                        }
                    }
                );
            })

            $A.enqueueAction(action);
        })
    },

    getCustomerDetail: function(component, helper) {
        return new Promise(function(resolve, reject) {
            console.log('getCustomer');
            let sfObject = component.get('v.sfObject');
            let action = component.get('c.getCustomerDetail');
            
            action.setParams({
                customerNumber: sfObject.customerNumber
            });

            action.setCallback(this, function(res) {
                console.log('return customer');
                helper.handleResponse(component, action.getName(), res, resolve, reject,
                    function(data) {
                        if (data) {         
                            let appSettings = component.get('v.appSettings');
                            let salesDatas = appSettings.salesAreasFromCustomer ? data.SALES_DATA.asList : appSettings.SalesAreas;
                            helper.setSalesData(component, salesDatas);
                            component.set('v.customerDetail', data);
                            component.set('v.salesDatas', salesDatas);
                        }
                    }
                );
            });

            $A.enqueueAction(action);
        })
    },

    setSalesData: function(component, salesDatas) {
        if (salesDatas.length) {
            let salesOrganizations = this.setSalesOrgs(component, salesDatas);
            let salesOrg = salesOrganizations.length > 0 ? salesOrganizations[0].SalesOrganization : '';

            let distributionChannels = this.setDistributionChannels(component, salesDatas, salesOrg);
            let distChan = distributionChannels.length > 0 ? distributionChannels[0].DistributionChannel : '';
            this.setDivisions(component, salesDatas, salesOrg, distChan);
        }              
    },

    setSalesOrgs: function(component, salesDatas) {
        let salesOrganizationsSet = new Set();
        let salesOrganizations = [];

        salesDatas.forEach(obj => {
            if (!salesOrganizationsSet.has(obj.SalesOrganization)) {
                salesOrganizationsSet.add(obj.SalesOrganization);
                let newObj = {};
                newObj.SalesOrganization = obj.SalesOrganization;
                newObj.SalesOrganizationName = obj.SalesOrganizationName;
                salesOrganizations.push(newObj);
            }            
        })
        component.set('v.salesOrganizations', salesOrganizations);
        
        return salesOrganizations;
    },

    setDistributionChannels: function(component, salesDatas, salesOrg) {
        let distributionChannelsSet = new Set();
        let distributionChannels = [];

        salesDatas.forEach(obj => {
            if (obj.SalesOrganization === salesOrg && !distributionChannelsSet.has(obj.DistributionChannel)) {
                distributionChannelsSet.add(obj.DistributionChannel);
                let newObj = {};
                newObj.DistributionChannel = obj.DistributionChannel;
                newObj.DistributionChannelName = obj.DistributionChannelName;
                distributionChannels.push(newObj);
            }            
        })
        component.set('v.distributionChannels', distributionChannels);

        return distributionChannels;
    },

    setDivisions: function(component, salesDatas, salesOrg, distChannel) {
        let divisions = [];

        salesDatas.forEach(obj => {
            if (obj.SalesOrganization === salesOrg && obj.DistributionChannel === distChannel) {
                let newObj = {};
                newObj.Division = obj.Division;
                newObj.DivisionName = obj.DivisionName;
                divisions.push(newObj);
            }            
        })
        component.set('v.divisions', divisions);

        return divisions;
    },

    getSalesDocDetail: function(component, sapDocNumber, helper) {
        return new Promise(function(resolve, reject) {
            console.log('get sales doc detail');

            let action = component.get('c.getSalesDocDetail');
            let appSettings = component.get('v.appSettings');
            action.setParams({
                salesDocNumber: sapDocNumber,
                appSettings: appSettings,
                sfObject: component.get('v.sfObject')
            })

            action.setCallback(this, function(res) {
                console.log('return get sales doc detail');
                helper.handleResponse(component, action.getName(), res, resolve, reject,
                    function(data) {
                        if (data) {
                            let salesDocDetailFromSF = Object.assign({}, data);
                            component.set('v.salesDocDetailFromSF', salesDocDetailFromSF);
                            let isNotAdded = data.ITEMS.find(item => !item.isAdded);
                            data.ITEMS = data.ITEMS.filter(item => parseInt(item.HigherLevelItemNumber) == 0);
                            if (isNotAdded && appSettings.purgeSAPMaterialsBeforeUpdate) {
                                component.set('v.displayPurgeSAPQuote', true);
                                component.set('v.displayChangeMessages', true);
                                component.set('v.changeMessageList', [{messageType: 'WARNING', message: $A.get("$Label.c.ensxtx_SalesDoc_Message_ExistingSAPMaterials")}]);
                                component.set('v.selectedTabId', 'sapStatus');                
                            }
                            component.set('v.salesDocDetail', data);
                            component.set('v.needToSimulate', false);
                        }
                    }
                );
            });

            $A.enqueueAction(action);
        })
    },

    finishSalesDocLoad: function(component, helper, isValid, isSuccessful) {
        let isSuccessFlag = isSuccessful;
        return helper.getBomItemsCount(component, helper)
            .then($A.getCallback(function(res) {
                let fieldSettings = component.get('v.fieldSettings');
                let appSettings = component.get('v.appSettings');
                let skipSimulate = fieldSettings.autoInvoke && !appSettings.incompletionLogsAsErrors;
                if (skipSimulate) {
                    // Skip simulate if autoInvoke to create/update and incompletion doesn't treat as errors
                    return Promise.resolve();
                }
                else {
                    component.set('v.needToSimulate', true);
                    return helper.simulateSalesDoc(component, helper);
                }
            }))
            .then($A.getCallback(function() {
                return helper.compareSAPSimulateVsSObject(component, helper);
            }))
            .then($A.getCallback(function() {
                return helper.mapChildBomFields(component, helper);
            }))
            .then($A.getCallback(function(res) {
                let appSettings = component.get('v.appSettings');
                if (appSettings.autoSimulate.afterItemEditSave) {
                    // Skip simulate if autoInvoke to create/update and incompletion doesn't treat as errors
                    return helper.simulateSalesDoc(component, helper);
                } else return Promise.resolve();
            }),function() {
                console.log('return from reject');
                component.set('v.displayPurgeSAPQuote', false);
                isSuccessFlag = false;
            })
            .then($A.getCallback(function(){
                console.log('all finish');
                component.set('v.displayPurgeSAPQuote', false);

                if (isValid && component.get('v.appSettings')) {
                    component.set('v.isSalesDocValid', true);
                    component.set('v.isSalesDocInitialized', true);

                    let fieldSettings = component.get('v.fieldSettings');
                    let status = component.get('v.status');

                    if (fieldSettings && fieldSettings.autoInvoke && isSuccessFlag && (status === 'Create' || status === 'Update')) {
                        return helper.create(component, helper);
                    }
                }

                return Promise.resolve();
            }))
            .then($A.getCallback(function() {
                console.log('final finishSalesDocLoad resolve');
                component.set('v.displaySpinner', false);
            }));
    },

    purgeForUpdate: function(component, helper) {
        return new Promise(function(resolve, reject) {
            component.set('v.displayChangeMessages', false);
            let salesDocDetail = component.get('v.salesDocDetail');
            let salesDocDetailFromSF = component.get('v.salesDocDetailFromSF');
            salesDocDetail.removedItems = [];
            salesDocDetailFromSF.ITEMS.forEach(item => {
                if (!item.isAdded) salesDocDetail.removedItems.push(item.ItemNumber);
            });
            salesDocDetail.ITEMS = [];
            let deleteLineItems = component.get('v.appSettings.deleteLineItems');
            component.set('v.appSettings.deleteLineItems', false);
            helper.createSAPDocument(component, helper)
                .then ($A.getCallback(function() {
                    component.set('v.appSettings.deleteLineItems', deleteLineItems);
                    component.set('v.salesDocDetail', salesDocDetail);
                    return helper.setSalesDocFromSobject(component, helper);
                }))
                .then($A.getCallback(function() {
                    component.set('v.selectedTabId', 'header');                
                    return helper.finishSalesDocLoad(component, helper, true, true);
                }))
                .then ($A.getCallback(function() {
                    console.log('final purgeForUpdate resolve');
                    component.set('v.displaySpinner', false);
                    resolve();
                }),function() {
                    component.set('v.appSettings.deleteLineItems', deleteLineItems);
                    console.log('return from reject purgeForUpdate');
                    component.set('v.displaySpinner', false);
                    reject();
                });
        });
    },

    compareSAPSimulateVsSObject: function(component, helper) {
        return new Promise(function(resolve, reject) {
            let appSettings = component.get('v.appSettings');
            if (appSettings.compareSAPSimulateVsSObject) {
                console.log('compareSAPSimulateVsSObject');
                let action = component.get('c.compareSAPSimulateVsSObject');
                action.setParams({
                    salesDocDetail: component.get('v.salesDocDetail'),
                    salesDocDetailFromSF: component.get('v.salesDocDetailFromSF'),
                    appSettings: appSettings
                });
                action.setCallback(this, function(res) {
                    console.log('return compareSAPSimulateVsSObject');
                    helper.handleResponse(component, action.getName(), res, resolve, reject,
                        function(data) {
                            if (data) {
                                if (data.changeMessageList && data.changeMessageList.length > 0) {
                                    component.set('v.displayChangeMessages', true);
                                    component.set('v.changeMessageList', data.changeMessageList);
                                    component.set('v.selectedTabId', 'sapStatus');
                                }
                            }
                        }, false
                    );
                });

                $A.enqueueAction(action);
            } else resolve();
        });
    },

    mapChildBomFields: function(component, helper) {
        return new Promise(function(resolve, reject) {
            let appSettings = component.get('v.appSettings');
            if (appSettings.mapChildBomFields) {
                console.log('mapChildBomFields');
                let action = component.get('c.mapChildBomFields');
                action.setParams({
                    salesDocDetail: component.get('v.salesDocDetail'),
                    salesDocDetailFromSF: component.get('v.salesDocDetailFromSF'),
                    appSettings: appSettings
                });
                action.setCallback(this, function(res) {
                    console.log('return mapChildBomFields');
                    helper.handleResponse(component, action.getName(), res, resolve, reject,
                        function(data) {
                            if (data) {
                                component.set('v.salesDocDetail', data);
                            }
                            if (data.NeedToSimulate) {
                                component.set('v.needToSimulate', true);
                            }
                    }, false
                    );
                });

                $A.enqueueAction(action);
            } else resolve();
        });
    },

    getReferenceDocument: function(component, sapDocNumber, helper) {
        return new Promise(function(resolve, reject) {
            console.log('get reference document for clone');

            let action = component.get('c.getReferenceDocument');
            let appSettings = component.get('v.appSettings');
            action.setParams({
                salesDocNumber: sapDocNumber,
                appSettings: appSettings
            })

            action.setCallback(this, function(res) {
                console.log('return get sales doc detail');
                helper.handleResponse(component, action.getName(), res, resolve, reject,
                    function(data) {
                        if (data) {
                            if (!data.SALES.SalesDocumentType) {
                                data.SALES.SalesDocumentType = appSettings.DefaultDocType;
                                data.SALES.SalesDocumentTypeInternal = appSettings.DefaultDocTypeInternal;
                            }
                            component.set('v.salesDocDetail', data);
                            component.set('v.needToSimulate', false);
                        }
                    }
                );
            });

            $A.enqueueAction(action);
        })
    },

    setInitSalesDocFromCustomer: function(component, helper) {
        console.log('init sales doc');
        let customerDetail = component.get('v.customerDetail');
        let appSettings = component.get('v.appSettings');
        let salesData = component.get('v.salesDatas')[0];

        let salesDocDetail = {
            SoldToParty : customerDetail.CustomerNumber,
            SoldToPartyText : customerDetail.Name,
            SalesDocumentCurrency : salesData ? salesData.CurrencyKey : '',
            ShippingConditions : salesData ? salesData.ShippingConditions : '',
            CustomerLanguage : customerDetail.Language,
            SALES : {
                SalesDocumentType : appSettings.DefaultDocType,
                SalesDocumentTypeInternal : appSettings.DefaultDocTypeInternal,
                SalesOrganization : salesData ? salesData.SalesOrganization : '',
                DistributionChannel : salesData ? salesData.DistributionChannel : '',
                Division : salesData ? salesData.Division : '',
                TermsofPaymentKey : salesData ? salesData.TermsofPaymentKey : '',
                IncotermsPart1 : salesData ? salesData.IncotermsPart1 : '',
                IncotermsPart2 : salesData ? salesData.IncotermsPart2 : '',
                SalesOffice :  salesData ? salesData.SalesOffice : '',
                SalesGroup :  salesData ? salesData.SalesGroup : ''
            },
            CONDITIONS : [],
            PARTNERS: appSettings.Header.PartnerPickers,
            TEXTS : helper.addDefaultTexts(appSettings.Header.Texts, customerDetail.Language),
            ITEMS : [],
        }

        console.log('finish init sales doc');
        component.set('v.needToSimulate', true);
        component.set('v.salesDocDetail', salesDocDetail);
    },

    setSalesDocFromSobject: function(component, helper) {
        return new Promise(function(resolve, reject) {
            console.log('set sales doc from Sobject');
            let sfObject = component.get('v.sfObject');

            if (!sfObject.initFromSObject) {
                return resolve();
            }
            let salesDocDetail = component.get('v.salesDocDetail');
            let appSettings = component.get('v.appSettings');
            let action = component.get('c.initSalesDocDetailFromSFObject');

            action.setParams({
                salesDocDetail: salesDocDetail,
                sfObject: sfObject,
                appSettings: appSettings
            })

            action.setCallback(this, function(res) {
                console.log('return set Sales doc from sobject');
                helper.handleResponse(component, action.getName(), res, resolve, reject,
                    function(data) {
                        data.ITEMS.sort((a,b) => (parseInt(a.ItemNumber) > parseInt(b.ItemNumber)) ? 1 : -1);
                        let salesDocDetailFromSF = Object.assign({}, data);
                        component.set('v.salesDocDetailFromSF', salesDocDetailFromSF);
                        data.ITEMS = data.ITEMS.filter(item => parseInt(item.HigherLevelItemNumber) == 0);
                        component.set('v.salesDocDetail', data);
                        component.set('v.needToSimulate', data.NeedToSimulate);
                    }
                );
            });

            $A.enqueueAction(action);
        })
    },

    validateSalesAreaAfterLoad: function(component, helper) {
        let status = component.get('v.status');
        if (status === 'Update') return;

        let salesDocDetail = component.get('v.salesDocDetail');
        let salesDatas = component.get('v.salesDatas');
        let fieldSettings = component.get('v.fieldSettings.Fields');

        if (!fieldSettings.Header.SalesOrganization.type || fieldSettings.Header.SalesOrganization.type != 'text') {
            let salesOrganizations = helper.setSalesOrgs(component, salesDatas);
            let valid = false;
            salesOrganizations.forEach(obj => {
                if (obj.SalesOrganization == salesDocDetail.SALES.SalesOrganization) valid = true;
            })

            if (!valid) {
                let salesOrg = salesOrganizations.length > 0 ? salesOrganizations[0].SalesOrganization : '';
                salesDocDetail.SALES.SalesOrganization = salesOrg;
            }
        }

        if (!fieldSettings.Header.DistributionChannel.type || fieldSettings.Header.DistributionChannel.type != 'text') {
            let distributionChannels = helper.setDistributionChannels(component, salesDatas, salesDocDetail.SALES.SalesOrganization);
            let valid = false;
            distributionChannels.forEach(obj => {
                if (obj.DistributionChannel == salesDocDetail.SALES.DistributionChannel) valid = true;
            })

            if (!valid) {
                let distChan = distributionChannels.length > 0 ? distributionChannels[0].DistributionChannel : '';
                salesDocDetail.SALES.DistributionChannel = distChan;
            }
        }

        if (!fieldSettings.Header.Division.type || fieldSettings.Header.Division.type != 'text') {
            let divisions = helper.setDivisions(component, salesDatas, salesDocDetail.SALES.SalesOrganization, salesDocDetail.SALES.DistributionChannel);
            let valid = false;
            divisions.forEach(obj => {
                if (obj.Division == salesDocDetail.SALES.Division) valid = true;
            })

            if (!valid) {
                let division = divisions.length > 0 ? divisions[0].Division : '';
                salesDocDetail.SALES.Division = division;
            }
        }

        component.set('v.salesDocDetail', salesDocDetail);
    },

    addDefaultTexts: function(defaultTexts, language) {
        let texts = [];

        if (defaultTexts) {
            defaultTexts.forEach(defText => {
                texts.push({
                    TextID: defText.Id,
                    TextIDDescription: defText.Description,
                    TextLanguage: language,
                    Required: defText.Required
                });
            })
        }

        return texts;
    },

    addMaterials: function(component, helper, materials, selectedSerial) {
        let salesDocDetail = component.get('v.salesDocDetail');
        let customerDetail = component.get('v.customerDetail');
        let sfObject = component.get('v.sfObject');
        let increment = component.get('v.appSettings.itemNumberIncrement');

        // Get the current highest item number
        let itemNumber = helper.getNextItemNumber(salesDocDetail, increment, component.get('v.isUpdate'));

        let materialNumbers = materials.map(item => item.Material);
        component.set('v.messages', []);      
        component.set('v.displaySpinner', true);        

        helper.validateProducts(component, materialNumbers, sfObject)
            .then($A.getCallback(function(result) {
                let messages = result.messages;
                let data = result.data;
                component.set('v.messages', messages);
                if (data && data.length) {
                    let validDataSets = new Set(data)
                    materials = materials.filter(mat => validDataSets.has(mat.Material));
                    return helper.getMaterialsDetail(component, data, helper)
                }
                else {
                    component.set('v.displaySpinner', false);                 
                    return Promise.reject('invalid Products');
                }
            }))
            .then($A.getCallback(function(result) {
                console.log('return from materials detail');
                
                let currentMaterialsDetail = component.get('v.materialsDetail');
                let appSettings = component.get('v.appSettings');

                // Add the valid Materials
                materials.forEach(item => {
                    let matDetail = currentMaterialsDetail[item.Material];

                    //let defaultPlant = helper.getDefaultPlant(component, matDetail.Plants)
                    let configurableMaterial = matDetail ? matDetail.ConfigurableMaterial : '';
                    let newItem = Object.assign({}, item);
                    newItem.ItemDescription=null;

                    if (!newItem.ScheduleLineDate) {
                        // Default Delivery date from header
                        newItem.ScheduleLineDate = salesDocDetail.SALES.RequestedDeliveryDate;
                    }

                    newItem.ItemNumber = itemNumber.toString().padStart(6, '0');
                    newItem.AlternativeItem = '000000';
                    newItem.HigherLevelItemNumber = '000000';
                    newItem.MaterialEntered = item.materialentered;
                    newItem.ConfigurableMaterial = configurableMaterial;
                    newItem.isNeedConfigure = configurableMaterial ? true : false;
                    newItem.isAdded = true;
                    newItem.ItemTexts = helper.addDefaultTexts(appSettings.Item.Texts, customerDetail.Language);
                    newItem.PARTNERS = appSettings.Item.PartnerPickers;
                    // newItem.BillingPlan = {
                    //     BillingPlanStartDate: salesDocDetail.StartDate,
                    //     BillingPlanEndDate: salesDocDetail.EndDate
                    // }
                    newItem.ItemConditions = [];
                    newItem.SBOItemConditions = [];

                    // Added the item texts if there are any from import csv
                    if (item.ItemTexts && item.ItemTexts.length) {
                        for (let textIndex in item.ItemTexts) {
                            let importedItemText = item.ItemTexts[textIndex];
                            for (let index in newItem.ItemTexts) {
                                let currentItemText = newItem.ItemTexts[index];
                                if (currentItemText.TextID === importedItemText.TextID) {
                                    currentItemText.Text = importedItemText.Text;
                                    break;
                                }
                            }
                        }
                    }

                    itemNumber += increment;
                    salesDocDetail.ITEMS.push(newItem);
                });

                component.set('v.salesDocDetail', salesDocDetail);

                if (appSettings.autoSimulate.afterItemAdd) {
                    return helper.simulateSalesDoc(component, helper);
                }
                else return Promise.resolve();
            }))
            .then($A.getCallback(function() {
                console.log('resolve simulate');
                component.set('v.displaySpinner', false);
            }), function(res) {
                console.log('reject simulate');
                component.set('v.displaySpinner', false);
            })
    },

    addMaterialsForBulkImport: function(component, helper, materials, selectedSerial) {
        let salesDocDetail = component.get('v.salesDocDetail');
        let customerDetail = component.get('v.customerDetail');
        let sfObject = component.get('v.sfObject');
        let increment = component.get('v.appSettings.itemNumberIncrement');

        // Get the current highest item number
        let itemNumber = helper.getNextItemNumber(salesDocDetail, increment, component.get('v.isUpdate'));

        let materialNumbers = materials.map(item => item.Material);
        component.set('v.messages', []);      
        component.set('v.displaySpinner', true);        

        helper.validateProducts(component, materialNumbers, sfObject)
            .then($A.getCallback(function(result) {
                console.log('return from materials detail');
                
                //let currentMaterialsDetail = component.get('v.materialsDetail');
                let appSettings = component.get('v.appSettings');

                // Add the valid Materials
                materials.forEach(item => {
                    let newItem = Object.assign({}, item);
                    newItem.ItemDescription=null;

                    if (!newItem.ScheduleLineDate) {
                        // Default Delivery date from header
                        newItem.ScheduleLineDate = salesDocDetail.SALES.RequestedDeliveryDate;
                    }

                    newItem.ItemNumber = itemNumber.toString().padStart(6, '0');
                    newItem.AlternativeItem = '000000';
                    newItem.HigherLevelItemNumber = '000000';
                    newItem.MaterialEntered = item.materialentered;
                    newItem.isAdded = true;
                    newItem.ItemTexts = helper.addDefaultTexts(appSettings.Item.Texts, customerDetail.Language);
                    newItem.PARTNERS = appSettings.Item.PartnerPickers;
                    // newItem.BillingPlan = {
                    //     BillingPlanStartDate: salesDocDetail.StartDate,
                    //     BillingPlanEndDate: salesDocDetail.EndDate
                    // }
                    newItem.ItemConditions = [];
                    newItem.SBOItemConditions = [];

                    // Added the item texts if there are any from import csv
                    if (item.ItemTexts && item.ItemTexts.length) {
                        for (let textIndex in item.ItemTexts) {
                            let importedItemText = item.ItemTexts[textIndex];
                            for (let index in newItem.ItemTexts) {
                                let currentItemText = newItem.ItemTexts[index];
                                if (currentItemText.TextID === importedItemText.TextID) {
                                    currentItemText.Text = importedItemText.Text;
                                    break;
                                }
                            }
                        }
                    }

                    itemNumber += increment;
                    salesDocDetail.ITEMS.push(newItem);
                });

                component.set('v.salesDocDetail', salesDocDetail);

                if (appSettings.autoSimulate.afterItemAdd) {
                    return helper.simulateSalesDoc(component, helper);
                }
                else return Promise.resolve();
            }))
            .then($A.getCallback(function() {
                console.log('resolve simulate');
                component.set('v.displaySpinner', false);
            }), function(res) {
                console.log('reject simulate');
                component.set('v.displaySpinner', false);
            })
    },

    getDefaultPlant: function(component, plants) {
        let salesOrganization = component.get('v.salesDocDetail.SALES.SalesOrganization');
        let distributionChannel = component.get('v.salesDocDetail.SALES.DistributionChannel');
        let plant = plants.find(item => 
            item.SalesOrganization === salesOrganization && 
            item.DistributionChannel === distributionChannel 
        )
        return plant;
    },

    validateProducts: function(component, materials, sfObject) {
        return new Promise(function(resolve, reject) {
            let pricebookId = sfObject.pricebookId;
            let updateLineItems = component.get('v.appSettings.updateLineItems');
            let salesDocDetail = component.get('v.salesDocDetail');

            if (!pricebookId || !updateLineItems) {
                return resolve({data: materials});
            }

            let action = component.get('c.validateProductsInSalesforce')
            action.setParams({
                materials: materials,
                pricebookId: pricebookId,
                salesDocumentCurrency: salesDocDetail.SalesDocumentCurrency
            })
            action.setCallback(this, function(res) {
                let response = res.getReturnValue();
                if (response) resolve(response);
            })
            $A.enqueueAction(action);
        })
    },

    getMaterialsDetail: function(component, materials, helper) {
        return new Promise(function(resolve, reject) {
            console.log('get materials detail');
            
            let currentMaterialsDetail = component.get('v.materialsDetail');
            let materialsNeedDetail = materials.filter(material => !currentMaterialsDetail[material]);

            if (!materialsNeedDetail.length) {
                resolve(null);
                return;
            }

            let action = component.get('c.getMaterialsDetail');            
            
            action.setParams({
                materials: materialsNeedDetail,
                salesOrg: component.get('v.salesDocDetail.SALES.SalesOrganization'),
                distChannel: component.get('v.salesDocDetail.SALES.DistributionChannel')
            })
            action.setCallback(this, function(res) {
                console.log('return materials detail');
                helper.handleResponse(component, action.getName(), res, resolve, reject,
                    function(data) {
                        if (data) {
                            for (let material in data) {
                                let materialDetail = data[material];
                                currentMaterialsDetail[material] = materialDetail;
                            }
                            component.set('v.materialsDetail', currentMaterialsDetail);
                        }
                    }
                , false)
            })
            $A.enqueueAction(action);
        })
    },

    getMaterialUOM: function(component, material, helper) {
        return new Promise(function(resolve, reject) {
            console.log('get material UOM');

            let currentMaterialsUOM = component.get('v.materialsUOM');
            let materialUOM = currentMaterialsUOM[material];

            if (materialUOM) {
                return resolve(null);
            }

            let action = component.get('c.getMaterialUOM');

            action.setParams({
                material: material
            })
            action.setCallback(this, function(res) {
                console.log('return material UOM');
                helper.handleResponse(component, action.getName(), res, resolve, reject,
                    function(data) {
                        if (data) {
                            let uomList = data.ET_OUTPUT_List.filter(item => item.MEINH);
                            currentMaterialsUOM[material] = uomList;
                        }
                        component.set('v.materialsUOM', currentMaterialsUOM);
                    }
                )
            })
            $A.enqueueAction(action);
        })
    },

    getBomItemsCount: function(component, helper) {
        return new Promise(function(resolve, reject) {
            console.log('get Bom Items Count');
            let status = component.get('v.status');
            let appSettings = component.get('v.appSettings');
            let salesDocDetail = component.get('v.salesDocDetail');
            let isAdded = salesDocDetail.ITEMS.find(item => item.isAdded);
            if ((status !== 'Update' || isAdded) && appSettings.enableBoMCountCommand) {
                let action = component.get('c.getBomItemsCount');
                action.setParams({
                    salesDocDetail: salesDocDetail,
                    appSettings: appSettings
                });

                action.setCallback(this, function(res) {
                    console.log('return get Bom Items Count');

                    helper.handleResponse(component, action.getName(), res, resolve, reject,
                        function(data) {
                            if (data) {
                                helper.setItemNumberBasedOnBOMCount(data, appSettings);
                                component.set('v.salesDocDetail', data);
                            }
                        }, false
                    );
                });

                $A.enqueueAction(action);
            } else return resolve(null);
        });
    },

    setItemNumberBasedOnBOMCount: function(salesDocDetail, appSettings){
        const itemNumberIncrement = appSettings.itemNumberIncrement;
        const bomItemNumberIncrement = appSettings.bomItemNumberIncrement;
        let nextItemNumber = appSettings.itemNumberIncrement;

        salesDocDetail.ITEMS.forEach(item => {
            item.ItemNumber = nextItemNumber.toString().padStart(6, '0');

            let bomCount;
            if (item.BOMCount) {
                bomCount = parseInt(item.BOMCount);
            }

            if (bomCount && bomCount != 0) {
                // Calculate the next item number when there is a BOM Count
                let bomItemNumber = (bomItemNumberIncrement * bomCount);
                nextItemNumber += itemNumberIncrement + (Math.floor(bomItemNumber / itemNumberIncrement) * itemNumberIncrement);
            }
            else {
                nextItemNumber += itemNumberIncrement;
            }
        })
    },
    
    simulateSalesDoc: function(component, helper) {
        return new Promise(function(resolve, reject) {
            console.log('simulate sales doc');
            let salesDocDetail = component.get('v.salesDocDetail');
            if (!component.get('v.needToSimulate')) {
                console.log('skip simulate');
                resolve(true);
                return;
            }
            let appSettings = component.get('v.appSettings');
            appSettings.InvokeMethod = 'Simulate';

            let action = component.get('c.simulateSalesDoc');
            action.setParams({
                salesDocDetail: salesDocDetail,
                appSettings: appSettings
            })
            action.setCallback(this, function(res) {
                console.log('return simulate sales doc');
                helper.handleResponse(component, action.getName(), res, resolve, reject,
                    function(data) {
                        if (data) {
                            data.ITEMS.sort((a,b) => (parseInt(a.ItemNumber) > parseInt(b.ItemNumber)) ? 1 : -1);
                            component.set('v.salesDocDetail', data);
                            if (data.SALES && data.SALES.PricingProcedureInPricing) {
                                let allHeaderConditions = component.get('v.optionValues.allHeaderConditions');
                                let allItemConditions = component.get('v.optionValues.allItemConditions');

                                if (!allHeaderConditions || !allHeaderConditions.length) {
                                    helper.getConditions(component, true, helper);
                                }
                                if (!allItemConditions || !allItemConditions.length) {
                                    helper.getConditions(component, false, helper);
                                }
                            }
                            helper.filterSalesOffice(component, helper, data);
                            component.set('v.needToSimulate', false);
                            let messages = component.get('v.messages');

                            let isError = false;
                            for (let index in messages) {
                                if (messages[index].messageType === 'ERROR') {
                                    isError = true;
                                }
                            }
                            if (isError) {
                                component.set('v.needToSimulate', true);
                                component.set('v.salesDocDetail', salesDocDetail);
                                return reject(false);
                            }
                        }
                    }, false
                );
            });

            $A.enqueueAction(action);
        });
    },

    sortSalesDoc: function(component, helper, items) {
        let salesDocDetail = component.get('v.salesDocDetail');
        salesDocDetail.ITEMS = items;
        salesDocDetail.ITEMS.sort((a,b) => (a.SortOrder> b.SortOrder) ? 1 : -1);
        let sortOrder = 10000;
        salesDocDetail.ITEMS.forEach(item => {
            if (parseInt(item.HigherLevelItemNumber) == 0) {
                item.SortOrder = sortOrder;
                sortOrder += 10000;
                let childSortOrder= 1;
                salesDocDetail.ITEMS.forEach(item2 => {
                    if (item2.HigherLevelItemNumber == item.ItemNumber) {
                        item2.SortOrder = sortOrder + childSortOrder++;
                    }
                });
            }
        });
        salesDocDetail.ITEMS.sort((a,b) => (a.SortOrder> b.SortOrder) ? 1 : -1);
        let increment = component.get('v.appSettings.itemNumberIncrement');
        let itemNumber = increment;
        let childItemNumber = 0;
        salesDocDetail.ITEMS.forEach(item => {
            if (parseInt(item.HigherLevelItemNumber) == 0) {
                item.ItemNumber = itemNumber.toString().padStart(6, '0');
                itemNumber += increment;
                childItemNumber = 0;
            } 
            else {
                childItemNumber++;
                item.ItemNumber = (itemNumber+childItemNumber).toString().padStart(6, '0');
            }
            item.SortOrder = 0;
        });
        component.set('v.salesDocDetail', salesDocDetail);
    },

    setEditableItemCondition: function(allItemConditions, salesDocItem, conditionType, newValue) {
        let itemConditions = salesDocItem.ItemConditions;
        let itemConditionFound = false;
        itemConditions.forEach(cond => {
            if (cond.ConditionType === conditionType) {
                cond.Rate = newValue;
                itemConditionFound = true;
            }
        });
        if (!itemConditionFound) {
            let condition = allItemConditions.find(cond => cond.ConditionType === conditionType);
            if (condition) {
                let newPriceCondition = {
                    ConditionType: condition.ConditionType,
                    ConditionTypeName: condition.KSCHL_TEXT,
                    Rate: newValue,
                    CalculationType: condition.KRECH
                }
                salesDocItem.ItemConditions.push(newPriceCondition);
            }                    
        }
    },

    saveToSObject: function(component, helper) {
        return new Promise(function(resolve, reject) {
            console.log('save To SObject');
            let action = component.get('c.saveToSObject');

            action.setParams({
                sfObject: component.get('v.sfObject'),
                salesDocDetail: component.get('v.salesDocDetail'),
                appSettings: component.get('v.appSettings')
            })

            action.setCallback(this, function(res) {
                console.log('finish save to sobject');
                helper.handleResponse(component, action.getName(), res, resolve, reject,
                    function(data) {
                        if (data) return resolve();
                        else return reject();
                    }
                )
            })

            $A.enqueueAction(action);
        });
    },

    onCreate: function(component, helper) {
        component.set('v.messages', []);
        component.set('v.displaySpinner', true);

        let isValid = helper.validateRequiredFields(component);
        if (isValid) {
            let isIncomplete = component.get('v.salesDocDetail.isIncomplete');
            let appSettings = component.get('v.appSettings');

            // Additional check if the incompletion log is treated as error.
            // If it's incomplete from the previous simulation
            // then simulation needs to run before creating document.
            // Set the needToSimulate to true so it will run the simulation.
            if ((appSettings.showHeaderIncompletionLogs || appSettings.showItemIncompletionLogs) &&
                appSettings.incompletionLogsAsErrors && isIncomplete !== false)
            {
                component.set('v.needToSimulate', true);
                helper.simulateSalesDoc(component, helper)
                    .then($A.getCallback(function() {
                        console.log('simulate click resolve');
                        return helper.create(component, helper);
                    }), function() {
                        console.log('simulate click reject');
                        component.set('v.displaySpinner', false);
                    })
            }
            else helper.create(component, helper);
        }
        else {
            component.set('v.displaySpinner', false);
        }
    },

    create: function(component, helper) {
        return new Promise(function(resolve, reject) {
            component.set('v.messages', []);
            let isValid = helper.validateRequiredFields(component); 

            if (isValid) {
                component.set('v.displaySpinner', true);
                let created = component.get('v.isUpdate') ? 'Updated' : 'Created';

                helper.createSAPDocument(component, helper)
                    .then(function(res) {
                        console.log('create success');
                        helper.showToast(
                            $A.get("$Label.c.ensxtx_SalesDoc_Message_SuccessTitle"),
                            'SAP ' + component.get('v.appSettings.SAPDocType') + ' Successfully ' + created + ': ' + res, 'success');
                        helper.navigateToDetail(component);
                    })
                    .catch(function() {
                        console.log('fail create here');
                        component.set('v.displaySpinner', false);
                    })
            }
            else return resolve();
        });
    },

    createSAPDocument: function(component, helper) {
        return new Promise(function(resolve, reject) {
            console.log('create SAP Document');
            let sfObject = component.get('v.sfObject');
            let salesDocDetail = component.get('v.salesDocDetail');
            let action = component.get('c.createSAPDocument');

            if (salesDocDetail.SalesDocument) action = component.get('c.updateSAPDocument');

            action.setParams({
                sfObject: sfObject,
                salesDocDetail: salesDocDetail,
                appSettings: component.get('v.appSettings')
            })

            action.setCallback(this, function(res) {
                console.log('finish create SAP Document');
                helper.handleResponse(component, action.getName(), res, resolve, reject,
                    function(data) {
                        if (data) {
                            let salesDocDetail = data;
                            let messages = component.get('v.messages');
                            let isError = false;
                            for (let index in messages) {
                                if (messages[index].messageType === 'ERROR') {
                                    isError = true;
                                    break;
                                }
                            }
                            if (isError) {
                                return reject(false);
                            }
                            else if (salesDocDetail.IsSuccess) {
                                component.set('v.sapDocNumber', salesDocDetail.SalesDocument);
                                return resolve(salesDocDetail.SalesDocument);
                            }
                        }
                    }, false
                )
            })

            $A.enqueueAction(action);
        })
    },

    groupItems: function(component) {
        let salesDocDetail = component.get('v.salesDocDetail');
        let items = salesDocDetail.ITEMS;
        let itemsWithAlternative = items.filter(
            item => item.AlternativeItem && !isNaN(parseInt(item.AlternativeItem)) && (parseInt(item.AlternativeItem) != 0));

        if (itemsWithAlternative.length) {
            // Create a Map of Alternative Item Number => Items
            let alternativeItemsMap = new Map();
            itemsWithAlternative.forEach(item => {
                let alternativeItemNum = parseInt(item.AlternativeItem);
                let values = alternativeItemsMap.get(alternativeItemNum);
                if (!values) {
                    alternativeItemsMap.set(alternativeItemNum, [item]);
                } else {
                    values.push(item);
                    alternativeItemsMap.set(alternativeItemNum, values);
                }
            });

            let newItemsList = [];

            items.forEach(item => {
                if (!item.AlternativeItem || parseInt(item.AlternativeItem) == 0) {
                    newItemsList.push(item);
                    if (alternativeItemsMap.has(parseInt(item.ItemNumber))) {
                        let arrayValues = alternativeItemsMap.get(parseInt(item.ItemNumber));
                        newItemsList.push.apply(newItemsList, arrayValues);
                    }
                }
            });

            component.set('v.salesDocDetail.ITEMS', newItemsList);
        }
    },

    removeItems: function(component, row) {
        let removedItems = component.get('v.salesDocDetail.removedItems');
        let items = component.get('v.salesDocDetail.ITEMS');
        let newItems = [];
        let previousItemNumber;
        let isUpdate = component.get('v.isUpdate');
        let itemNumberIncrement = component.get('v.appSettings.itemNumberIncrement');
        let previousParentItemNumber = '';
        
        if (!removedItems) removedItems = [];
        removedItems.push(row.ItemNumber);

        if (isUpdate) {
            newItems = items.filter(item =>
                item.ItemNumber !== row.ItemNumber && item.HigherLevelItemNumber !== row.ItemNumber);
        }
        else {
            // Order the Item in sequence
            items.forEach(function(item) {
                if (item.ItemNumber < row.ItemNumber) {
                    if (parseInt(item.HigherLevelItemNumber) == 0) previousParentItemNumber = item.ItemNumber;
                    newItems.push(item);
                } 
                else {
                    if (item.ItemNumber === row.ItemNumber) {
                        previousItemNumber = parseInt(item.ItemNumber);
                    } 
                    else if (item.ItemNumber !== row.ItemNumber && item.HigherLevelItemNumber !== row.ItemNumber) {
                        item.ItemNumber = previousItemNumber.toString().padStart(6, '0');

                        // Update the higher level item number
                        if (parseInt(item.HigherLevelItemNumber) == 0) previousParentItemNumber = item.ItemNumber;
                        else if (parseInt(item.HigherLevelItemNumber) != 0) item.HigherLevelItemNumber = previousParentItemNumber;

                        previousItemNumber += itemNumberIncrement;
                        newItems.push(item);
                    }
                }
            });
        }

        component.set('v.salesDocDetail.ITEMS', newItems);
        component.set('v.salesDocDetail.removedItems', removedItems);
    },

    editItem: function(component, row, helper, isReadOnly) {
        component.set('v.displaySpinner', true);
        let salesDocDetail = component.get('v.salesDocDetail');
        let salesOrganization = salesDocDetail.SALES.SalesOrganization;
        let distributionChannel = salesDocDetail.SALES.DistributionChannel;

        // If the detail of Material is not found, need to do a callout
        // This is primarily when user have save line items to CPQ LineItems
        // And get back to Sales Doc Create it doesn't have the material detail from SAP yet
        helper.getMaterialsDetail(component, [row.Material], helper)
            .then($A.getCallback(function() {
                return helper.getMaterialUOM(component, row.Material, helper)
            }))
            .then($A.getCallback(function(result) {
                console.log('return from materials detail');

                let currentMaterialsDetail = component.get('v.materialsDetail');
                let currentMaterialsUOM = component.get('v.materialsUOM');

                let materialDetail = currentMaterialsDetail[row.Material];
                let materialUOM = currentMaterialsUOM[row.Material]
                let plants = materialDetail && materialDetail.Plants ? materialDetail.Plants.filter(plant =>
                    plant.SalesOrganization === salesOrganization &&
                    plant.DistributionChannel === distributionChannel    
                ) : []

                helper.openEditItemComponent(component, salesDocDetail, row, plants, isReadOnly, materialUOM);
            }))
    },

    openEditItemComponent: function(component, salesDocDetail, row, plants, isReadOnly, materialUOM) {
        $A.createComponent('c:ensxtx_CMP_SalesDocEditItem', {
            'salesDocDetail': salesDocDetail,
            'item': row,
            'plants': plants,
            'rejectionReasons': component.get('v.optionValues.rejectionReasons'),
            'allItemConditions': component.get('v.optionValues.allItemConditions'),
            'priceLists': component.get('v.optionValues.priceLists'),
            'isReadOnly': isReadOnly,
            'billingPlans': component.get('v.optionValues.billingPlans'),
            'appSettings': component.get('v.appSettings'),
            'fieldSettings': component.get('v.fieldSettings.Fields.ItemEdit'),
            'tabSettings': component.get('v.fieldSettings.Tabs.Item'),
            'materialUOM': materialUOM,
            'allowDebug': component.get('v.sfObject.allowDebug')
        },
        function (content, status, errorMessage) {
            if (status === 'SUCCESS') {
                content.addEventHandler('editItemEvent', 
                    component.getReference('c.updateItem'));
                component.set('v.displaySpinner', false);
                component.find('overlayLib1')
                    .showCustomModal({
                        header: isReadOnly ? $A.get('$Label.c.ensxtx_SalesDoc_Title_ViewItem') : $A.get('$Label.c.ensxtx_SalesDoc_Title_EditItem'),
                        body: content,
                        showCloseButton: true,
                        closeCallback: function () {}
                    })
            }
        })
    },

    configureItem: function(component, row) {
        component.set('v.displaySpinner', true);
        let salesDocDetail = component.get('v.salesDocDetail');
        let shipToParty = null;
        for (let key in salesDocDetail.PARTNERS) {
            let partner = salesDocDetail.PARTNERS[key];
            if (partner.PartnerFunctionInternal === 'WE') {
                shipToParty = partner.CustomerNumber
                break;
            }
        }

        let headerJson = {
            salesDocType: salesDocDetail.SALES.SalesDocumentType,
            salesOrg: salesDocDetail.SALES.SalesOrganization,
            salesDistChannel: salesDocDetail.SALES.DistributionChannel,
            salesDivision: salesDocDetail.SALES.Division,
            soldToParty: salesDocDetail.SoldToParty,            
            shipToParty: shipToParty
        }

        let itemJson = {
            plant: row.Plant,
            OrderQuantity: row.OrderQuantity,
            SalesDocumentCurrency: row.SalesDocumentCurrency,
            selectedCharacteristics: row.ItemConfigurations
        };

        $A.createComponent('c:ensxtx_CMP_VCVisual', {
            'isLightningFlow': false,
            'itemNumber': row.ItemNumber,
            'materialId': row.Material,
            'isDisplayRequiredOnly': true,
            'headerJSON': JSON.stringify(headerJson),
            'itemJSON': JSON.stringify(itemJson),
            'isReferenceFromSalesOrder': row.isReferenceFromSalesOrder,
            'allowDebug': component.get('v.sfObject.allowDebug')
        },
        function(content, status, errorMessage) {
            if (status === "SUCCESS") {
                content.addEventHandler('confirmfinalized',
                    component.getReference('c.onFinalizeConfiguration'));
                component.set('v.displaySpinner', false);
                component.find('overlayLib1')
                    .showCustomModal({
                        body: content,
                        showCloseButton: true,
                        closeCallback: function () {
                            if (component.get('v.vcSessionData')) {
                                // Close Vc session
                                let action = component.get('c.closeSession')
                                action.setParams({
                                    sessionData: component.get('v.vcSessionData')
                                });
                                $A.enqueueAction(action);
                            }
                        }
                    })
            }
            else if (status === 'ERROR' && !content) {
                component.set('v.displaySpinner', false);
                let messages = [{
                    messageType: 'ERROR',
                    message: $A.get('$Label.c.ensxtx_SalesDoc_Message_VCUnavailable')
                }]
                component.set('v.messages', messages);
            }
        })
    },

    getShipInfo: function(component, helper) {
        return new Promise(function(resolve, reject) {
            let fieldSettings = component.get('v.fieldSettings.Fields');
            if (fieldSettings.Header.TermsofPaymentKey.display ||
                fieldSettings.Header.IncotermsPart1.display ||
                fieldSettings.Header.ShippingConditions.display)
            {
                console.log('getShipInfo');
                let action = component.get('c.getShipInfo');
                action.setCallback(this, function(res) {
                    console.log('return shipInfo');
                    helper.handleResponse(component, action.getName(), res, resolve, reject,
                        function(data) {
                            if (data) {
                                let TermsofPaymentKey = data.ET_PAY_TERMS_List.filter(item => item.ZTERM);
                                let IncotermsPart1 = data.ET_FREIGHT_TERMS_List.filter(item => item.INCO1);
                                let shippingConditions = data.ET_SHIP_COND_List.filter(item => item.ShippingConditions);
                                component.set('v.optionValues.TermsofPaymentKey', TermsofPaymentKey);
                                component.set('v.optionValues.IncotermsPart1', IncotermsPart1);
                                component.set('v.optionValues.shippingConditions', shippingConditions);
                            }
                        }
                    );
                })

                $A.enqueueAction(action);
            }
            else resolve(true);
        })
    },

    getPricingStat: function(component, helper) {
        return new Promise(function(resolve, reject) {
            let fieldSettings = component.get('v.fieldSettings.Fields');
            if (fieldSettings.ItemEdit.EditItemFields.PriceListType.display) {
                console.log('getPricingStat');
                let action = component.get('c.getPricingStat');
                action.setCallback(this, function(res) {
                    console.log('return pricing stat');
                    helper.handleResponse(component, action.getName(), res, resolve, reject,
                        function(data) {
                            if (data) {
                                let priceGroups = data.ET_CUST_PRICE_GRP_List.filter(item => item.KONDA);
                                let priceLists = data.ET_CUST_PRICE_LIST_List.filter(item => item.PLTYP);
                                component.set('v.optionValues.priceGroups', priceGroups);
                                component.set('v.optionValues.priceLists', priceLists);
                            }
                        }
                    )
                })

                $A.enqueueAction(action);
            }
            else resolve(true);
        })
    },

    getGroupOffice: function(component, helper) {
        return new Promise(function(resolve, reject) {
            let fieldSettings = component.get('v.fieldSettings.Fields');
            if (fieldSettings.Header.SalesOffice.display ||
                fieldSettings.Header.SalesGroup.display ||
                fieldSettings.Header.SalesDistrict.display)
            {
                console.log('get group office');
                let action = component.get('c.getGroupOffice');
                action.setCallback(this, function(res) {
                    console.log('return group office');
                    helper.handleResponse(component, action.getName(), res, resolve, reject,
                        function(data) {
                            if (data) {
                                let salesDocDetail = component.get('v.salesDocDetail');
                                let salesDistricts = data.ET_SALES_DISTRICT_List.filter(item => item.BZIRK);
                                let salesOffices = data.ET_SALES_OFFICE_List.filter(item => item.VKBUR);
                                let salesGroups = data.ET_SALES_GROUP_List.filter(item => item.SalesGroup);
                                component.set('v.optionValues.salesDistricts', salesDistricts);
                                component.set('v.optionValues.salesOffices', salesOffices);
                                component.set('v.optionValues.salesGroups', salesGroups);
                                helper.filterSalesOffice(component, helper, salesDocDetail);
                                component.set('v.salesDocDetail', salesDocDetail);
                            }
                        }
                    )
                })

                $A.enqueueAction(action);
            }
            else resolve(true);
        })
    },

    getConditions: function(component, isHeader, helper) {
        return new Promise(function(resolve, reject) {
            let tabSettings = component.get('v.fieldSettings.Tabs');
            if ((isHeader && tabSettings.Header.Conditions.display) ||
                (!isHeader && tabSettings.Item.Conditions.display))
            {
                console.log('get conditions');
                let action = component.get('c.getConditionTypes');
                let salesDocDetail = component.get('v.salesDocDetail');

                // return if salesDocDetail is null
                if (!salesDocDetail) resolve(false);
                
                action.setParams({
                    isHeader: isHeader,
                    pricingProcedure: salesDocDetail.SALES.PricingProcedureInPricing
                });
                action.setCallback(this, function(res) {
                    console.log('return conditions');
                    helper.handleResponse(component, action.getName(), res, resolve, reject,
                        function(data) {
                            if (data) {
                                if (isHeader) {
                                    console.log('header condition');                                
                                    component.set('v.optionValues.allHeaderConditions', data.ET_CONDITIONS_List);
                                }
                                else {
                                    console.log('item condition');
                                    component.set('v.optionValues.allItemConditions', data.ET_CONDITIONS_List);
                                }
                            }
                        }
                    )
                })

                $A.enqueueAction(action);
            }
            else resolve(true);
        })
    },

    getRejectionReasons: function(component, helper) {
        return new Promise(function(resolve, reject) {
            let fieldSettings = component.get('v.fieldSettings.Fields');
            if (fieldSettings.ItemEdit.EditItemFields.RejectionReason.display) {
                console.log('get rejection reason');
                let action = component.get('c.getRejectionReasons');
                action.setCallback(this, function(res) {
                    console.log('return rejection reason');
                    helper.handleResponse(component, action.getName(), res, resolve, reject,
                        function(data) {
                            if (data) {
                                let rejectionReasons = data.ET_VALUES_List.filter(item => item.VALUE);
                                component.set('v.optionValues.rejectionReasons', rejectionReasons);
                            }
                        }
                    )
                })

                $A.enqueueAction(action);
            }
            else resolve(true);
        })
    },

    getBillingPlans: function(component, helper) {
        return new Promise(function(resolve, reject) {
            let tabSettings = component.get('v.fieldSettings.Tabs');
            if (tabSettings.Item.BillingPlans.display) {
                console.log('get billing plans');
                let action = component.get('c.getBillingPlans');
                action.setCallback(this, function(res) {
                    console.log('return billing plans');
                    helper.handleResponse(component, action.getName(), res, resolve, reject,
                        function(data) {
                            if (data) {
                                let billingPlans = data.OUTPUT_List.filter(item => item.PERIO);
                                component.set('v.optionValues.billingPlans', billingPlans);
                            }
                        }
                    )
                })

                $A.enqueueAction(action);
            }
            else resolve(true);
        })
    },

    expandSection: function(component, expandId, iconId) {
        let isExpand = component.get(expandId);
        if (isExpand) {
            component.set(expandId, false);
            component.set(iconId, 'utility:chevronright'); 
        }
        else {
            component.set(expandId, true);
            component.set(iconId, 'utility:chevrondown');    
        }
    },

    showToast: function(title, message, type) {
        let toastEvent = $A.get("e.force:showToast");
        
        toastEvent.setParams({
            title: title,
            message: message,
            type: type,
            mode: "dismissible"
        });
        toastEvent.fire();
    },

    navigateToDetail: function(component) {
        let availableActions = component.get('v.availableActions');
        let navigate = component.get("v.navigateFlow");
        if (availableActions.includes("NEXT")) {
            navigate("NEXT");
        } else if (availableActions.includes("FINISH")) {
            navigate("FINISH");
        }
    },

    isNumeric: function(num) {
        return !isNaN(num);
    },

    checkSalesDocDetailChanged: function(component) {
        if(component.get('v.isSalesDocInitialized')) {
            console.log('sales doc detail changed.');
            component.set('v.isConfigurationChanged', true);
            component.set('v.needToSimulate', true);
        }
    },

    addByMaterialNumber: function(component, event, helper) {
        let inputMaterial = component.get('v.inputMaterial');
        let quantity = component.get('v.inputMaterialQuantity');
        if (inputMaterial) {
            let splitMaterials = inputMaterial.split(',');
            let materials = [];
            splitMaterials.forEach(material => {
                let materialInput = material.trim().toUpperCase();
                materials.push({
                    Material: materialInput,
                    OrderQuantity: quantity
                });
            })

            helper.addMaterials(component, helper, materials, null);
            component.set('v.inputMaterial', '');
            component.set('v.inputMaterialQuantity', 1);
        }
    },

    onRowAction: function(component, helper, row, actionName) {
        let needToSimulate = false;
        let appSettings = component.get('v.appSettings');

        switch(actionName) {
            case 'edit_item':
                helper.editItem(component, row, helper, false);
                break;
            case 'view_item':
                helper.editItem(component, row, helper, true);
                break;
            case 'delete_item':
                helper.removeItems(component, row);
                if (appSettings.autoSimulate.afterItemDelete) {
                    needToSimulate = true;
                }
                break;
            case 'configure_item':
                // explicitely set to false
                row.isReferenceFromSalesOrder = false;
                helper.configureItem(component, row);
                break;
            case 'clone_line':
                helper.cloneLineItem(component, helper, row);
                if (appSettings.autoSimulate.afterItemClone) {
                    needToSimulate = true;
                }
                break;
        }
        
        if (needToSimulate) {   
            component.set('v.displaySpinner', true);
            component.set('v.messages', []);     
            helper.simulateSalesDoc(component, helper)
                .then($A.getCallback(function() {
                    console.log('simulate resolve');
                    component.set('v.displaySpinner', false);
                }), function() {
                    console.log('simulate reject');
                    component.set('v.displaySpinner', false);
                })
        }
    },

    getNextItemNumber: function(salesDocDetail, increment, isUpdate) {
        let itemNumber;
        let removedItems = salesDocDetail.removedItems ? [...salesDocDetail.removedItems] : [];

        if (salesDocDetail.ITEMS.length < 1) {
            if (isUpdate && removedItems.length) {
                removedItems.sort((a,b) => a - b);
                itemNumber = parseInt(removedItems[removedItems.length - 1]) + increment;
            }
            else {
                itemNumber = increment;
            }
        }
        else {
            let itemSize = salesDocDetail.ITEMS.length;
            let lastItem = salesDocDetail.ITEMS[itemSize - 1];
            let lastItemNumber = parseInt(lastItem.ItemNumber);
            lastItemNumber = (lastItemNumber % increment) === 0 ? lastItemNumber : (lastItemNumber - (lastItemNumber % increment));

            if (isUpdate && removedItems.length) {
                removedItems.push(lastItemNumber.toString().padStart(6, '0'));
                removedItems.sort((a,b) => a - b);
                itemNumber = parseInt(removedItems[removedItems.length - 1]) + increment;
            }
            else {
                itemNumber = lastItemNumber + increment;
            }
        }

        return itemNumber;
    },

    cloneLineItem: function(component, helper, row) {
        let salesDocDetail = component.get('v.salesDocDetail');
        let increment = component.get('v.appSettings.itemNumberIncrement');

        // Get the current highest item number
        let itemNumber = helper.getNextItemNumber(salesDocDetail, increment, component.get('v.isUpdate'));

        let cloneItem = Object.assign({}, row);
        cloneItem.ItemNumber = itemNumber.toString().padStart(6, '0');
        cloneItem.AlternativeItem = '000000';
        cloneItem.isAdded = true;
        cloneItem.SFId = null;
        salesDocDetail.ITEMS.push(cloneItem);

        component.set('v.salesDocDetail', salesDocDetail);
    },

    validateRequiredFields: function(component) {
        let salesDocDetail = component.get('v.salesDocDetail');
        let fieldSettings = component.get('v.fieldSettings.Fields');
        let appSettings = component.get('v.appSettings');
        let headerFieldSettings = fieldSettings.Header;
        let itemFieldSettings = fieldSettings.ItemEdit.EditItemFields;
        let isValid = true;
        let messages = [];

        for (const fieldSettingKey in headerFieldSettings) {
            let fieldSetting = headerFieldSettings[fieldSettingKey];
            if (fieldSettingKey != 'Texts' && typeof fieldSetting === 'object' && fieldSetting['required'] && fieldSetting['edit']) {
                if (fieldSetting['collection']) {
                    if (!salesDocDetail[fieldSetting['collection']][fieldSettingKey]) {
                        let labelKey = '$' + 'Label.c.ensxtx_SalesDoc_Field_' + fieldSettingKey;
                        messages.push(this.requiredMessage(null, $A.get(labelKey)));
                        isValid = false;
                    }
                }
                else {
                    if (!salesDocDetail[fieldSettingKey]) {
                        let labelKey = '$' + 'Label.c.ensxtx_SalesDoc_Field_' + fieldSettingKey;
                        messages.push(this.requiredMessage(null, $A.get(labelKey)));
                        isValid = false;
                    }
                }
            }
        }

        if (headerFieldSettings.Texts.edit) {
            for (let index in salesDocDetail.TEXTS) {
                let text = salesDocDetail.TEXTS[index];
                if (!text.Text && text.Required) {
                    messages.push(this.requiredMessage(null, text.TextIDDescription));
                    isValid = false;
                }
            }
        }

        if (salesDocDetail.ITEMS.length > 0) {
            for (let index in salesDocDetail.ITEMS) {
                let item = salesDocDetail.ITEMS[index];
                for (const fieldSettingKey in itemFieldSettings) {
                    let fieldSetting = itemFieldSettings[fieldSettingKey];
                    if (fieldSettingKey != 'Texts' && typeof fieldSetting === 'object' && fieldSetting['required'] && fieldSetting['edit']) {
                        if (!item[fieldSettingKey]) {
                            let labelKey = '$' + 'Label.c.ensxtx_SalesDoc_Field_' + fieldSettingKey;
                            messages.push(this.requiredMessage(item.ItemNumber, $A.get(labelKey)));
                            isValid = false;
                        }
                    }
                }
        
                if (itemFieldSettings.Texts.edit) {
                    for (let index in item.ItemTexts) {
                        let text = item.ItemTexts[index];
                        if (!text.Text && text.Required) {
                            messages.push(this.requiredMessage(item.ItemNumber, text.TextIDDescription));
                            isValid = false;
                        }
                    }
                }
            }
        }
        else {
            messages.push({messageType: 'ERROR', message: 'There are no line items on the ' + appSettings.SAPDocType});
            isValid = false;
        }


        component.set('v.messages', messages);
        return isValid;
    },

    requiredMessage: function(itemNumber, fieldLabel) {
        let prefixLabel = itemNumber ? ('Item ' + itemNumber + ', ' + fieldLabel) : fieldLabel;
        let message = {
            messageType: 'ERROR',
            message: prefixLabel + ' is Required'
        }

        return message;
    },

    getFieldSettings: function(component) {
        console.log('get field settings');
        let appSettings = component.get('v.appSettings');
        let status = component.get('v.status');

        let fieldSettings = appSettings.Default;
        if (!fieldSettings) {
            // Old app settings structure doesn't have default. Need to be converted if it's the old one
            fieldSettings = this.convertOldFieldSettings(appSettings[status], status);
        }
        else {
            let overrideSettings = appSettings[status];
            if (overrideSettings) {
                this.traverseSettings(overrideSettings, fieldSettings, []);
            }
        }
        if (component.get('v.isUpdate')) fieldSettings.displaySort = false;

        component.set('v.fieldSettings', fieldSettings);
    },

    convertOldFieldSettings: function(oldFieldSettings, status) {
        let newFieldSettings = {
            autoInvoke: oldFieldSettings.autoInvoke,
            displaySimulate: true,
            displaySaveToSOject: status == 'Simulate',
            displaySaveToSAP: status == 'Create' || status == 'Update',
            AddMaterial: oldFieldSettings.AddMaterial,
            Tabs: {
                Header: {
                    Conditions: oldFieldSettings.Header.ConditionsTab,
                    Partners: oldFieldSettings.Header.PartnersTab,
                    BillingPlans: oldFieldSettings.Header.BillingPlanTab,
                },
                Item: {
                    Conditions: oldFieldSettings.ItemEdit.ConditionsTab,
                    Partners: oldFieldSettings.ItemEdit.PartnersTab,
                    BillingPlans: oldFieldSettings.ItemEdit.BillingPlanTab,
                    Schedules: oldFieldSettings.ItemEdit.ScheduleTab
                }
            },
            Fields: {
                Header: oldFieldSettings.Header,
                ItemTable: oldFieldSettings.ItemTable,
                ItemEdit: oldFieldSettings.ItemEdit
            }
        };

        return newFieldSettings;
    },

    traverseSettings: function(obj, fieldSettings, propList) {
        for (const prop in obj) {
            let value = obj[prop];
            propList.push(prop);
            if (typeof value === 'object') {
                this.traverseSettings(value, fieldSettings, propList);
            }
            else {
                this.setPropValue(fieldSettings, [...propList], value);
            }
            propList.pop();
        }
    },

    setPropValue: function(obj, propList, value) {
        if (propList.length === 1) {
            obj[propList[0]] = value;
        }
        else {
            for (const prop in obj) {
                if (prop === propList[0]) {
                    propList.shift();
                    this.setPropValue(obj[prop], propList, value);
                }
            }
        }
    },

    onSalesAreaChange: function(component, event, helper) {
        // change on Sales Area
        let salesDocDetail = component.get('v.salesDocDetail');
        let salesDatas = component.get('v.salesDatas');
        let appSettings = component.get('v.appSettings');
        let fieldSettings = component.get('v.fieldSettings.Fields');

        let inputName = event.getSource().get('v.name');
        if (inputName === 'salesOrg' && (!fieldSettings.Header.DistributionChannel.type ||
            fieldSettings.Header.DistributionChannel.type != 'text')) {
            let distributionChannels = helper.setDistributionChannels(component, salesDatas, salesDocDetail.SALES.SalesOrganization);
            let distChan = distributionChannels.length > 0 ? distributionChannels[0].DistributionChannel : '';
            salesDocDetail.SALES.DistributionChannel = distChan;
        }

        if ((inputName === 'salesOrg' || inputName === 'distChannel') && (!fieldSettings.Header.Division.type || fieldSettings.Header.Division.type != 'text')) {
            let divisions = helper.setDivisions(component, salesDatas, salesDocDetail.SALES.SalesOrganization, salesDocDetail.SALES.DistributionChannel);
            let division = divisions.length > 0 ? divisions[0].Division : '';
            salesDocDetail.SALES.Division = division;
        }

        let salesData = salesDatas.find(sd =>
            sd.SalesOrganization === salesDocDetail.SALES.SalesOrganization &&
            sd.DistributionChannel === salesDocDetail.SALES.DistributionChannel &&
            sd.Division === salesDocDetail.SALES.Division);

        if (salesData) {
            // Redetermined some Sales fields
            salesDocDetail.SALES.TermsofPaymentKey = salesData.TermsofPaymentKey;
            salesDocDetail.SALES.IncotermsPart1 = salesData.IncotermsPart1;
            salesDocDetail.SALES.IncotermsPart2 = salesData.IncotermsPart2;
            salesDocDetail.SALES.SalesOffice = salesData.SalesOffice;
            salesDocDetail.SALES.SalesGroup = salesData.SalesGroup;
            salesDocDetail.SALES.PriceListType = salesData.PriceListType;
            salesDocDetail.ShippingConditions = salesData.ShippingConditions;
            salesDocDetail.SalesDocumentCurrency = salesData.CurrencyKey;
        }

        helper.filterSalesOffice(component, helper, salesDocDetail);

        component.set('v.salesDocDetail', salesDocDetail);

        if (appSettings.autoSimulate.afterFieldUpdate && 
            (fieldSettings.Header.SalesOrganization.simulate ||
            fieldSettings.Header.DistributionChannel.simulate ||
            fieldSettings.Header.Division.simulate)) 
        {
            component.set('v.displaySpinner', true);
            component.set('v.messages', []);

            helper.simulateSalesDoc(component, helper)
                .then($A.getCallback(function() {
                    console.log('success simulate');
                    component.set('v.displaySpinner', false);
                }), function() {
                    console.log('reject simulate');
                    component.set('v.displaySpinner', false);
                });
        }
    },

    filterSalesOffice: function(component, helper, salesDocDetail) {
        let salesOffices = component.get('v.optionValues.salesOffices');
        let filteredSalesOffices = [];
        if (salesOffices && salesOffices.length > 0) {
            filteredSalesOffices = salesOffices.filter(item => 
                item.SalesOrganization === salesDocDetail.SALES.SalesOrganization &&
                item.DistributionChannel === salesDocDetail.SALES.DistributionChannel &&
                item.Division === salesDocDetail.SALES.Division);
            let currentSalesOffice = filteredSalesOffices.find(item => item.VKBUR === salesDocDetail.SALES.SalesOffice );
            if (!currentSalesOffice) salesDocDetail.SALES.SalesOffice = '';
            helper.onSalesOfficeChange(component, helper, salesDocDetail);
        }
        component.set('v.filteredSalesOffices', filteredSalesOffices);
    },

    onSalesOfficeChange: function(component, helper, salesDocDetail) {
        // change on Sales Office
        let salesGroups = component.get('v.optionValues.salesGroups');
        let filteredSalesGroups = [];
        if (salesGroups && salesGroups.length > 0) {
            filteredSalesGroups = salesGroups.filter(item => 
                item.VKBUR == salesDocDetail.SALES.SalesOffice);
            let currentSalesGroup = filteredSalesGroups.find(item => item.SalesGroup === salesDocDetail.SALES.SalesGroup );
            if (!currentSalesGroup) salesDocDetail.SALES.SalesGroup = '';
        }
        component.set('v.filteredSalesGroups', filteredSalesGroups);
    },

    onFieldChange: function(component, inputName, helper) {
        if (inputName == 'SalesOffice') helper.filterSalesOffice(component, helper, component.get('v.salesDocDetail'));
        let appSettings = component.get('v.appSettings');
        let fieldSettings = component.get('v.fieldSettings.Fields');
        let field = fieldSettings.Header[inputName];

        if (appSettings.autoSimulate.afterFieldUpdate && (field && field.simulate)) {
            console.log('field changed, do simulate');
            component.set('v.displaySpinner', true);
            component.set('v.messages', []);

            helper.simulateSalesDoc(component, helper)
                .then($A.getCallback(function() {
                    console.log('success simulate');
                    component.set('v.displaySpinner', false);
                }), function() {
                    console.log('reject simulate');
                    component.set('v.displaySpinner', false);
                });
        }
    },

    handleResponse: function (component, method, response, resolve, reject, dataFunction, rejectForErrorInResponse)
    {
        let state = response.getState();
        if (state === "SUCCESS") {
            let returnValue = response.getReturnValue();
            if (returnValue) {
                let messages = returnValue.messages;
                if (messages && messages.length > 0) {
                    let vMessages = component.get('v.messages');
                    if (!vMessages) vMessages = [];
                    vMessages.push(...messages);
                    component.set('v.messages', vMessages);
                    if (false !== rejectForErrorInResponse) {
                        for (let index in messages) {
                            if (messages[index].messageType === 'ERROR') {
                                if (reject) reject(false);
                            }
                        }
                    }
                }
                if (dataFunction) dataFunction(returnValue.data);
                if (returnValue.httpTraces && returnValue.httpTraces.length) {
                    let httpTraces = component.get('v.httpTraces')
                    returnValue.httpTraces.forEach(trace => httpTraces.unshift(trace))
                }
            }
            if (resolve) resolve(true);
        } 
        else {
            let messages = [];
            messages.push({message: 'There was an error in ensxtx_CTRL_SalesDocCreateUpdate.' + method, messageType: "ERROR"});

            let errors = response.getError();
            if (errors) {
                for (let errCnt in errors) {
                    let fieldErrors = errors[errCnt].fieldErrors;
                    if (fieldErrors) {
                        messages.push({message: fieldErrors, messageType: "ERROR"});
                    }
                    let pageErrors = errors[errCnt].pageErrors;
                    if (pageErrors) {
                        for (let pageCnt in pageErrors) {
                            messages.push({message: pageErrors[pageCnt].message, messageType: "ERROR"});
                        }
                    }
                    let message = errors[errCnt].message;
                    if (message) {
                        messages.push({message: message, messageType: "ERROR"});
                    }
                }
            }
            let vMessages = component.get('v.messages');
            if (!vMessages) vMessages = [];
            vMessages.push(...messages);
            component.set('v.messages', vMessages);
            if (reject) reject('There was an error in ensxtx_CTRL_SalesDocCreateUpdate.' + method);
        }
    }
})