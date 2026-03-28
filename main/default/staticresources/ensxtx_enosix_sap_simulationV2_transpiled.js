'use strict';
System.register('QCPlugin____UIDFiller____', [], function (_export, _context) {
  'use strict';
  /*
   * Authors: Abhilash Bollampally - Enosix, Frank Berni - Cognizant
   * Date Created: 5/7/2024
   * Last Modified: 9/20/2024
   * Description: QCP script to run enosix SAP price retrieval for quote lines, W-014572: Contract Pricing and W-014932: FWO Threshold logic
   */ /* begin standard exports */ function onBeforeCalculate(quoteModel, quoteLineModels, conn) {
    // W-014572 Calling enosix script and then running uncheckContractPricing to reset Enable Contract Pricing checkbox
    // W-014932 checking FWO Thresholds for Quote Lines under a given category
    return Promise.all([
      enosix_onBeforeCalculate(quoteModel, quoteLineModels, conn),
      uncheckContractPricing(quoteModel, quoteLineModels),
      checkCategoryFwoThresholds(quoteLineModels)
    ]);
  }
  _export('onBeforeCalculate', onBeforeCalculate);
  function isFieldEditableForObject(fieldName, quoteOrLine, conn, objectName) {
    if (objectName === 'QuoteLine__c') {
      if (fieldName === 'ensxtx_SAP_VC_Incomplete__c') {
        return false;
      }
    } // Lock only Approval Status and Start Date if Quote is in Draft
    if (
      objectName === 'Quote__c' &&
      quoteOrLine.ApprovalStatus__c == 'Draft' &&
      (fieldName === 'ApprovalStatus__c' || fieldName === 'SBQQ__StartDate__c')
    ) {
      return false;
    } // Lock all header fields on Quote if not in Draft
    if (objectName === 'Quote__c' && quoteOrLine.ApprovalStatus__c != 'Draft') {
      return false;
    } // NEW Lock 'SBQQ__CustomerDiscount__c' and 'Total_Credit__c' Quote Line fields on Quote if user is not System Administrator or ICOM Sales Ops
    if (
      objectName === 'Quote__c' &&
      quoteOrLine.Current_User_Profile__c != 'System Administrator' &&
      quoteOrLine.Current_User_Profile__c != 'ICOM Sales Ops' &&
      (fieldName === 'SBQQ__CustomerDiscount__c' || fieldName === 'Total_Credit__c')
    ) {
      return false;
    } // Lock all Quote Line fields on Quote if not in Draft
    if (objectName === 'QuoteLine__c' && quoteOrLine.SBQQ__Quote__r.ApprovalStatus__c != 'Draft') {
      return false;
    } // FIXME Lock 'SBQQ__AdditionalDiscountAmount__c' and 'SBQQ__Discount__c' Quote Line fields on Quote if user is not System Administrator or ICOM Sales Ops
    if (
      objectName === 'QuoteLine__c' &&
      quoteOrLine.SBQQ__Quote__r.Current_User_Profile__c != 'System Administrator' &&
      quoteOrLine.SBQQ__Quote__r.Current_User_Profile__c != 'ICOM Sales Ops' &&
      (fieldName === 'SBQQ__AdditionalDiscountAmount__c' || fieldName === 'SBQQ__Discount__c')
    ) {
      return false;
    } // Lock Additional discount Quote Line fields for non-Sales Op/Admin Users
    if (objectName === 'QuoteLine__c' && fieldName === 'SBQQ__Description__c') {
      return false;
    }
  }
  /* end standard exports */ /* begin enosix */ _export(
    'isFieldEditableForObject',
    isFieldEditableForObject
  );
  function enosix_onBeforeCalculate(quoteModel, quoteLineModels, conn) {
    // README - ALWAYS Leave this object empty when updating static resource from custom script
    // prettier-ignore
    var enosixConfig={/*ENOSIXCONFIG*/};
    debug('enosixConfig', enosixConfig);
    console.log('Enable_Contract_Pricing__c:', quoteModel.record.Enable_Contract_Pricing__c); // W-014572: check if quote's contract pricing is false, if so, stop all functionality
    if (!quoteModel.record.Enable_Contract_Pricing__c) {
      console.log('Enable Contract Pricing is unchecked. Ceasing enosix SAP call');
      return Promise.resolve();
    } else {
      quoteModel.record.ensxtx_SAP_Resimulate__c = true;
    }
    if (enosixConfig.instanceUrl) {
      conn.instanceUrl = enosixConfig.instanceUrl;
    } else {
      quoteModel.record.ensxtx_SAP_Simulation_Error__c =
        'Unable to call SAP Simulation service please run "ensxtx_UTIL_CPQ_SetupV2.installCustomScript();" in Dev Console as Anonymous Apex';
      return Promise.resolve();
    }
    console.log('Kicking off Enosix SAP call');
    return new Promise(function (resolve, reject) {
      var enableQuoteSimulation = quoteModel.record[enosixConfig.quoteSimulationEnabledField];
      if (quoteLineModels.length > 0 && enableQuoteSimulation) {
        var groupCnt;
        (function () {
          var cpqQuote = { Id: quoteModel.record.Id };
          var requestQuoteRecordFields = enosixConfig.requestQuoteRecordFields || [];
          requestQuoteRecordFields.forEach(function (fieldName) {
            cpqQuote[fieldName] = quoteModel.record[fieldName];
          });
          var usedNumbers = [];
          var maxUsedNumber = 0;
          var simFromConfiguratorFound = false;
          quoteLineModels.forEach(function (quoteLine) {
            if (quoteLine.record.ensxtx_SAP_QuoteLine_JSON__c) {
              var simulationResponseLine = JSON.parse(
                quoteLine.record.ensxtx_SAP_QuoteLine_JSON__c
              );
              simulationResponseLine.SBQQ__Number__c = quoteLine.record.SBQQ__Number__c;
              Object.assign(quoteLine.record, simulationResponseLine);
              if (enosixConfig.splitSimulationLevel.toUpperCase() == 'PERLINE') {
                quoteLine.record.ensxtx_SAP_Simulated_JSON__c =
                  JSON.stringify(simulationResponseLine);
              }
              quoteLine.record.ensxtx_SAP_QuoteLine_JSON__c = null;
              simFromConfiguratorFound = true;
            }
            if (quoteLine.record.ensxtx_SAP_Configuration__c) {
              var cpqItemConfig = JSON.parse(quoteLine.record.ensxtx_SAP_Configuration__c);
              quoteLine.record.ensxtx_SAP_VC_Incomplete__c =
                cpqItemConfig.isIncomplete != undefined && cpqItemConfig.isIncomplete;
            }
            if (usedNumbers.includes(quoteLine.record.SBQQ__Number__c)) {
              quoteLine.record.SBQQ__Number__c = 0;
            } else {
              usedNumbers.push(quoteLine.record.SBQQ__Number__c);
              if (quoteLine.record.SBQQ__Number__c > maxUsedNumber) {
                maxUsedNumber = quoteLine.record.SBQQ__Number__c;
              }
            }
            if (
              quoteLine.parentItem &&
              quoteLine.record.ensxtx_SAP_Item_Number__c &&
              quoteLine.parentItem.record.SBQQ__Quantity__c &&
              quoteLine.record.SBQQ__BundledQuantity__c
            ) {
              quoteLine.record.SBQQ__Quantity__c =
                quoteLine.parentItem.record.SBQQ__Quantity__c *
                quoteLine.record.SBQQ__BundledQuantity__c;
            }
          });
          if (!quoteModel.record.ensxtx_SAP_Simulated_JSON__c) {
            quoteModel.record.ensxtx_SAP_Simulated_JSON__c = JSON.stringify(quoteModel.record);
          }
          quoteLineModels.forEach(function (quoteLine) {
            if (quoteLine.record.SBQQ__Number__c == 0) {
              quoteLine.record.SBQQ__Number__c = ++maxUsedNumber;
            }
          });
          if (simFromConfiguratorFound) {
            resortBom(quoteModel, quoteLineModels);
            quoteLineModels.sort(function (a, b) {
              return (
                a.record.ensxtx_SAP_Sort_Field__ephemeral -
                b.record.ensxtx_SAP_Sort_Field__ephemeral
              );
            });
          } else {
            quoteLineModels.sort(function (a, b) {
              return parseInt(a.record.SBQQ__Number__c) - parseInt(b.record.SBQQ__Number__c);
            });
          }
          var groupQuoteLineModelsList = buildGroupQuoteLineModels(
            enosixConfig,
            quoteModel,
            quoteLineModels
          );
          quoteModel.record.ensxtx_SAP_Simulation_Error__c = null;
          var pendingRequests = [];
          var _loop = function _loop() {
            var groupQuoteLineModels = groupQuoteLineModelsList[groupCnt].QuoteLineModels;
            if (groupQuoteLineModels.length > 0) {
              pendingRequests.push(
                new Promise(function (resolve, reject) {
                  var cpqQuoteLineList = [];
                  groupQuoteLineModels.forEach(function (quoteLine) {
                    if (!quoteModel.record.ensxtx_SAP_Consistency_Check__c)
                      quoteLine.record.ensxtx_SAP_Simulation_Error__c = null;
                    var cpqQuoteLine = {
                      Id: quoteLine.record.Id,
                      SBQQ__Product__c: quoteLine.record.SBQQ__Product__c,
                      SBQQ__PricebookEntryId__c: quoteLine.record.SBQQ__PricebookEntryId__c,
                      SBQQ__DynamicOptionId__c: quoteLine.record.SBQQ__DynamicOptionId__c,
                      SBQQ__Number__c: quoteLine.record.SBQQ__Number__c,
                      SBQQ__Quantity__c: quoteLine.record.SBQQ__Quantity__c,
                      SBQQ__RequiredBy__c: quoteLine.record.SBQQ__RequiredBy__c,
                      ensxtx_SAP_Simulated__c: quoteLine.record.ensxtx_SAP_Simulated__c
                    };
                    var requestQuoteLineRecordFields =
                      enosixConfig.requestQuoteLineRecordFields || [];
                    requestQuoteLineRecordFields.forEach(function (fieldName) {
                      cpqQuoteLine[fieldName] = quoteLine.record[fieldName];
                    });
                    var cpqItemConfig = {};
                    if (quoteLine.record.ensxtx_SAP_Configuration__c) {
                      cpqItemConfig = JSON.parse(quoteLine.record.ensxtx_SAP_Configuration__c);
                    }
                    cpqItemConfig.ParentLineItem = quoteLine.parentItem
                      ? quoteLine.parentItem.record.SBQQ__Number__c
                      : null;
                    cpqQuoteLine.ensxtx_SAP_Configuration__c = JSON.stringify(cpqItemConfig);
                    cpqQuoteLineList.push(cpqQuoteLine);
                  });
                  debug('cpqQuote', cpqQuote);
                  debug('cpqQuoteLineList', cpqQuoteLineList);
                  var serializedCPQQuote = JSON.stringify(cpqQuote);
                  var serializedCPQQuoteLineList = JSON.stringify(cpqQuoteLineList);
                  conn.apex
                    .post(enosixConfig.enosixSapSimulationApexService, {
                      serializedCPQQuote: serializedCPQQuote,
                      serializedCPQQuoteLineList: serializedCPQQuoteLineList
                    })
                    .then(function (results) {
                      debug('Raw simulationResponse', results); //deserialize the object back into readable format
                      var simulationResponse = JSON.parse(results);
                      debug('simulationResponse', simulationResponse);
                      if (simulationResponse && simulationResponse.data) {
                        if (simulationResponse.data.Success) {
                          cpqQuoteLineList.forEach(function (simulationResponseLine) {
                            var matchedQuoteLine = groupQuoteLineModels.find(function (quoteLine) {
                              return (
                                quoteLine.record.SBQQ__Number__c ==
                                simulationResponseLine.SBQQ__Number__c
                              );
                            });
                            if (matchedQuoteLine) {
                              matchedQuoteLine.record.ensxtx_SAP_Simulated__c = true;
                            }
                          }); // update the quote from the simulation response
                          translateAndUpdateQuoteLines(
                            resolve,
                            reject,
                            quoteModel,
                            groupQuoteLineModels,
                            simulationResponse.data
                          );
                        } else {
                          returnSimulationError(
                            resolve,
                            null,
                            quoteModel,
                            groupQuoteLineModels,
                            simulationResponse.data.Message
                          );
                        }
                      }
                      if (
                        simulationResponse &&
                        simulationResponse.httpTraces &&
                        simulationResponse.httpTraces.length
                      ) {
                        simulationResponse.httpTraces.forEach(function (httpTrace) {
                          debug(
                            httpTrace.ensxapp__SBO_Name__c +
                              ':' +
                              httpTrace.ensxapp__Operation__c +
                              ':' +
                              httpTrace.ensxapp__Status_Code__c,
                            httpTrace
                          );
                        });
                      }
                    })
                    .catch(function (err) {
                      returnSimulationError(resolve, reject, quoteModel, groupQuoteLineModels, err);
                    });
                })
              );
            }
          };
          for (groupCnt = 0; groupCnt < groupQuoteLineModelsList.length; groupCnt++) {
            _loop();
          }
          if (pendingRequests.length > 0) {
            Promise.all(pendingRequests)
              .then(function (results) {
                if (enosixConfig.resortBom) resortBom(quoteModel, quoteLineModels);
                quoteModel.record.ensxtx_SAP_Resimulate__c = false;
                quoteModel.record.ensxtx_SAP_Consistency_Check__c = false;
                resolve();
              })
              .catch(function (err) {
                returnSimulationError(resolve, reject, quoteModel, null, err);
              });
          } else {
            if (enosixConfig.resortBom) resortBom(quoteModel, quoteLineModels);
            quoteModel.record.ensxtx_SAP_Resimulate__c = false;
            quoteModel.record.ensxtx_SAP_Consistency_Check__c = false;
            resolve();
          }
        })();
      } else {
        resolve();
      }
    });
    function buildGroupQuoteLineModels(enosixConfig, quoteModel, quoteLineModels) {
      var tempGroupQuoteLineModelsList = [];
      var enosixSimulateQuoteLineModels = quoteLineModels.filter(function (qlm) {
        var isValid = qlm.record[enosixConfig.quoteLineSimulationEnabledField];
        var cpqItemConfig = qlm.record.ensxtx_SAP_Configuration__c;
        var parentItem = qlm.parentItem;
        while (parentItem) {
          if (parentItem.record.ensxtx_SAP_Configuration__c) {
            cpqItemConfig = qlm.parentItem.record.ensxtx_SAP_Configuration__c;
          }
          parentItem = parentItem.parentItem;
        }
        if (cpqItemConfig) {
          cpqItemConfig = JSON.parse(cpqItemConfig);
          isValid =
            isValid &&
            (!cpqItemConfig.isIncomplete || quoteModel.record.ensxtx_SAP_Consistency_Check__c);
        }
        return isValid;
      });
      if (
        enosixConfig.splitSimulationLevel.toUpperCase() == 'PERLINE' ||
        quoteModel.record.ensxtx_SAP_Consistency_Check__c
      ) {
        enosixSimulateQuoteLineModels.forEach(function (quoteLine) {
          var chkQuoteLine = quoteLine;
          while (chkQuoteLine.parentItem) {
            chkQuoteLine = chkQuoteLine.parentItem;
          }
          var id = chkQuoteLine.record.SBQQ__Number__c;
          var groupQuoteLineModels = tempGroupQuoteLineModelsList.find(function (quoteLineModel) {
            return quoteLineModel.Id == id;
          });
          if (!groupQuoteLineModels) {
            groupQuoteLineModels = { Id: id, QuoteLineModels: [] };
            tempGroupQuoteLineModelsList.push(groupQuoteLineModels);
          }
          groupQuoteLineModels.QuoteLineModels.push(quoteLine);
        });
      } else if (enosixConfig.splitSimulationLevel.toUpperCase() == 'ALLLINES') {
        var _groupQuoteLineModels = { Id: 'All', QuoteLineModels: enosixSimulateQuoteLineModels };
        tempGroupQuoteLineModelsList.push(_groupQuoteLineModels);
      } else if (enosixConfig.splitSimulationLevel.toUpperCase() == 'PERCPQGROUP') {
        if (quoteModel.groups.length > 0) {
          var id = 0;
          quoteModel.groups.forEach(function (group) {
            var groupQuoteLineModels = {
              Id: id++,
              QuoteLineModels: group.lineItems.filter(function (qlm) {
                return qlm.record[enosixConfig.quoteLineSimulationEnabledField];
              })
            };
            tempGroupQuoteLineModelsList.push(groupQuoteLineModels);
          });
        } else {
          var _groupQuoteLineModels2 = {
            Id: 'All',
            QuoteLineModels: enosixSimulateQuoteLineModels
          };
          tempGroupQuoteLineModelsList.push(_groupQuoteLineModels2);
        }
      } else if (enosixConfig.splitSimulationLevel.toUpperCase() == 'GROUPBYFIELD') {
        enosixSimulateQuoteLineModels.forEach(function (quoteLine) {
          var chkQuoteLine = quoteLine;
          while (chkQuoteLine.parentItem) {
            chkQuoteLine = chkQuoteLine.parentItem;
          }
          var id = chkQuoteLine.record[enosixConfig.splitSimulationGroupByField];
          var groupQuoteLineModels = tempGroupQuoteLineModelsList.find(function (quoteLineModel) {
            return quoteLineModel.Id == id;
          });
          if (!groupQuoteLineModels) {
            groupQuoteLineModels = { Id: id, QuoteLineModels: [] };
            tempGroupQuoteLineModelsList.push(groupQuoteLineModels);
          }
          groupQuoteLineModels.QuoteLineModels.push(quoteLine);
        });
      } else {
        quoteModel.record.ensxtx_SAP_Simulation_Error__c =
          'Invalid splitSimulationLevel value ' +
          enosixConfig.splitSimulationLevel +
          '.  Valid options are AllLines, PerLine, PerCPQGroup, and GroupByField.';
      }
      var requestQuoteRecordFields = enosixConfig.requestQuoteRecordFields || [];
      var simQuote = {};
      if (quoteModel.record.ensxtx_SAP_Simulated_JSON__c)
        simQuote = JSON.parse(quoteModel.record.ensxtx_SAP_Simulated_JSON__c);
      var currQuote = {};
      var isQuoteChanged = false;
      requestQuoteRecordFields.forEach(function (fieldName) {
        if (
          simQuote[fieldName] != quoteModel.record[fieldName] &&
          fieldName != 'ensxtx_SAP_Consistency_Check__c'
        )
          isQuoteChanged = true;
        currQuote[fieldName] = quoteModel.record[fieldName];
      });
      quoteModel.record.ensxtx_SAP_Simulated_JSON__c = JSON.stringify(currQuote);
      var requestQuoteLineRecordFields = enosixConfig.requestQuoteLineRecordFields || [];
      tempGroupQuoteLineModelsList.forEach(function (groupQuoteLineModels) {
        groupQuoteLineModels.QuoteLineModels.forEach(function (quoteLine) {
          var simQuoteLine = {};
          if (quoteLine.record.ensxtx_SAP_Simulated_JSON__c)
            simQuoteLine = JSON.parse(quoteLine.record.ensxtx_SAP_Simulated_JSON__c);
          var currQuoteLine = {};
          var isQuoteLineChanged = false;
          requestQuoteLineRecordFields.forEach(function (fieldName) {
            if (simQuoteLine[fieldName] != quoteLine.record[fieldName]) isQuoteLineChanged = true;
            currQuoteLine[fieldName] = quoteLine.record[fieldName];
          });
          quoteLine.record.ensxtx_SAP_Simulated_JSON__c = JSON.stringify(currQuoteLine);
          quoteLine.isQuoteLineChanged = isQuoteLineChanged;
        });
      });
      var groupQuoteLineModelsList = [];
      tempGroupQuoteLineModelsList.forEach(function (groupQuoteLineModels) {
        var quoteLineList = groupQuoteLineModels.QuoteLineModels.find(function (quoteLine) {
          return !quoteLine.record.ensxtx_SAP_Simulated__c || quoteLine.isQuoteLineChanged;
        });
        if (
          quoteModel.record.ensxtx_SAP_Resimulate__c ||
          quoteModel.record.ensxtx_SAP_Consistency_Check__c ||
          isQuoteChanged ||
          quoteLineList != null
        ) {
          groupQuoteLineModels.QuoteLineModels.forEach(function (quoteLine) {
            if (
              quoteModel.record.ensxtx_SAP_Resimulate__c ||
              quoteModel.record.ensxtx_SAP_Consistency_Check__c ||
              isQuoteChanged ||
              quoteLine.isQuoteLineChanged
            ) {
              quoteLine.record.ensxtx_SAP_Simulated__c = false;
            }
          });
          groupQuoteLineModelsList.push(groupQuoteLineModels);
        }
      });
      return groupQuoteLineModelsList;
    }
    function translateAndUpdateQuoteLines(
      resolve,
      reject,
      quoteModel,
      quoteLineModels,
      simulationResponse
    ) {
      var tempQuoteLineModels = [];
      try {
        if (quoteModel.record.ensxtx_SAP_Consistency_Check__c) {
          quoteLineModels.forEach(function (quoteLine) {
            if (quoteLine.record.ensxtx_SAP_Configuration__c) {
              var cpqItemConfig = JSON.parse(quoteLine.record.ensxtx_SAP_Configuration__c);
              cpqItemConfig.isIncomplete = false;
              quoteLine.record.ensxtx_SAP_Configuration__c = JSON.stringify(cpqItemConfig);
              quoteLine.record.ensxtx_SAP_Simulation_Error__c = null;
            }
            quoteLine.record.ensxtx_SAP_VC_Incomplete__c = false;
          });
        } else {
          Object.assign(quoteModel.record, simulationResponse.cpqQuote);
          simulationResponse.cpqQuoteLineList.forEach(function (simulationResponseLine) {
            var matchedQuoteLine = quoteLineModels.find(function (quoteLine) {
              return quoteLine.record.SBQQ__Number__c == simulationResponseLine.SBQQ__Number__c;
            });
            debug(matchedQuoteLine);
            debug(simulationResponseLine);
            if (matchedQuoteLine) {
              tempQuoteLineModels.push(matchedQuoteLine);
              Object.assign(matchedQuoteLine.record, simulationResponseLine);
              matchedQuoteLine.ItemNumber = simulationResponseLine.ensxtx_SAP_Item_Number__c;
            }
            tempQuoteLineModels = [];
          });
          simulationResponse.cpqQuoteLineList.forEach(function (simulationResponseLine) {
            var matchedQuoteLine = quoteLineModels.find(function (quoteLine) {
              return quoteLine.record.SBQQ__Number__c == simulationResponseLine.SBQQ__Number__c;
            });
            var isSimulated = void 0;
            simulationResponse.cpqQuoteLineList.forEach(function (childQuoteLine) {
              var matchedChildQuoteLine = quoteLineModels.find(function (quoteLine) {
                return quoteLine.record.SBQQ__Number__c == childQuoteLine.SBQQ__Number__c;
              });
              if (
                matchedChildQuoteLine &&
                matchedChildQuoteLine.parentItem &&
                matchedChildQuoteLine.parentItem.record.SBQQ__Number__c ==
                  simulationResponseLine.SBQQ__Number__c
              ) {
                if (childQuoteLine.ensxtx_SAP_Simulated__c && isSimulated == undefined)
                  isSimulated = true;
                if (!childQuoteLine.ensxtx_SAP_Simulated__c) isSimulated = false;
              }
            });
            if (isSimulated) matchedQuoteLine.record.ensxtx_SAP_Simulated__c = true;
          });
        }
        resolve();
      } catch (err) {
        returnSimulationError(resolve, reject, quoteModel, tempQuoteLineModels, err);
      }
    }
    function resortBom(quoteModel, quoteLineModels) {
      var sortModelMap = {};
      quoteLineModels.forEach(function (quoteLine) {
        var sortModel = sortModelMap[quoteLine.record.SBQQ__Number__c] || { childList: [] };
        sortModelMap[quoteLine.record.SBQQ__Number__c] = sortModel;
        if (quoteLine.parentItem) {
          var parentSortModel = sortModelMap[quoteLine.parentItem.record.SBQQ__Number__c] || {
            childList: []
          };
          parentSortModel.childList.push(quoteLine);
          sortModelMap[quoteLine.parentItem.record.SBQQ__Number__c] = parentSortModel;
        }
      });
      Object.keys(sortModelMap).forEach(function (key) {
        var sortModel = sortModelMap[key];
        if (sortModel.childList.length > 0) {
          sortModel.childList.forEach(function (quoteLine) {
            var sortString = quoteLine.record.ensxtx_SAP_Item_Number__c || '9999999';
            sortString += '.' + quoteLine.record.SBQQ__Number__c.toString().padStart(4, '0');
            quoteLine.record.ensxtx_SAP_Sort_Field__ephemeral = parseFloat(sortString);
          });
          sortModel.childList.sort(function (a, b) {
            return (
              a.record.ensxtx_SAP_Sort_Field__ephemeral - b.record.ensxtx_SAP_Sort_Field__ephemeral
            );
          });
        }
      });
      var qlSortedList = [];
      resortChildren(quoteLineModels, sortModelMap, qlSortedList);
      quoteModel._innerModel.lineSortField = 'ensxtx_SAP_Sort_Field__ephemeral';
      quoteLineModels = qlSortedList;
    }
    function resortChildren(quoteLineModels, sortModelMap, qlSortedList) {
      quoteLineModels.forEach(function (quoteLine) {
        var isQuoteLineSorted = qlSortedList.find(function (quoteLineSorted) {
          return quoteLine.record.SBQQ__Number__c == quoteLineSorted.record.SBQQ__Number__c;
        });
        if (!isQuoteLineSorted) {
          quoteLine.record.ensxtx_SAP_Sort_Field__ephemeral = (qlSortedList.length + 1)
            .toString()
            .padStart(5, '0');
          qlSortedList.push(quoteLine);
          var sortModel = sortModelMap[quoteLine.record.SBQQ__Number__c];
          if (sortModel) {
            resortChildren(sortModel.childList, sortModelMap, qlSortedList);
          }
        }
      });
    }
    function returnSimulationError(resolve, reject, quoteModel, quoteLineModels, err) {
      console.error('enosix SAP Simulation Error', err);
      err = '' + err;
      if (quoteModel) {
        quoteModel.record.ensxtx_SAP_Simulation_Error__c = err;
      }
      if (quoteLineModels != null) {
        var errQuoteLine = void 0;
        if (err.substr(0, 15) == 'Internal error:') {
          var qlNumber = void 0;
          var errArray = err.split(' Item Number ');
          if (errArray.length > 1) qlNumber = errArray[1].split(' ')[0];
          var qlArray = quoteLineModels.filter(function (qlm) {
            return qlm.record.SBQQ__Number__c == qlNumber;
          });
          if (qlArray.length > 0) errQuoteLine = qlArray[0];
        }
        if (errQuoteLine) {
          errQuoteLine.record.ensxtx_SAP_Simulation_Error__c = err;
          if (err.includes('CFG_IS_INCONSISTENT_OR_INCOMPLETE')) {
            var cpqItemConfig = errQuoteLine.record.ensxtx_SAP_Configuration__c
              ? JSON.parse(errQuoteLine.record.ensxtx_SAP_Configuration__c)
              : {};
            cpqItemConfig.isIncomplete = true;
            errQuoteLine.record.ensxtx_SAP_Configuration__c = JSON.stringify(cpqItemConfig);
            errQuoteLine.record.ensxtx_SAP_VC_Incomplete__c = true;
          }
        } else {
          quoteLineModels.forEach(function (quoteLine) {
            quoteLine.record.ensxtx_SAP_Simulation_Error__c = err;
          });
        }
      }
      if (reject) {
        reject('Issue Simulating in SAP: ' + err);
      } else {
        resolve();
        return;
      }
    }
    /** Log to console if debug is enabled */ function debug() {
      if (enosixConfig.DEBUG) {
        var _console;
        (_console = console).log.apply(_console, arguments);
      }
    }
  } /* end enosix */ /* begin cognizant */ // W-014572 uncheckContractPricing: takes in quoteModel and unchecks Enable Contract Pricing - treats checkbox like a button
  function uncheckContractPricing(quoteModel, quoteLineModels) {
    return new Promise(function (resolve, reject) {
      console.log('uncheckContractPricing');
      if (quoteModel.record.Enable_Contract_Pricing__c) {
        console.log('Unchecking Enable Contract Pricing'); // uncheck the Enable Contract Pricing Button
        quoteModel.record.Enable_Contract_Pricing__c = false; // Loop through each Quote Line and mark that they've been run through Contract Pricing
        quoteLineModels.forEach(function (quoteLine) {
          if (!quoteLine.record.Contract_Price_Checked__c) {
            quoteLine.record.Contract_Price_Checked__c = true;
          }
        });
      }
      resolve();
    });
  } // checkCategoryFwoThresholds takes in quoteLineModels. Rolls up Quote line Quantity and FWO Quantity to check whether they exceed their FWO Threshold or Not
  function checkCategoryFwoThresholds(quoteLineModels) {
    return new Promise(function (resolve, reject) {
      console.log('checkCategoryFwoThresholds'); // Initialize our object of MasterProgramFamily category and its Total FWO Quantity, Total Paid Quantity, FWO Threshold
      var categoryTotals = {}; // loop through qls to construct our category groupings object
      quoteLineModels.forEach(function (quoteLine) {
        var category = quoteLine.record.ProductCategory_MasterProgramFamily__c; // If this quote line's category doesn't exist in the object yet, initialize its totalPaid, totalFwo and fwoThreshold
        if (!categoryTotals[category]) {
          categoryTotals[category] = {
            totalPaid: 0,
            totalFwo: 0,
            fwoThreshold: quoteLine.record.FWO_Threshold_Percentage__c
              ? quoteLine.record.FWO_Threshold_Percentage__c
              : 0
          };
        } // Start rolling up the summary of all quote line Quantity and FWO Quantity fields to its matching category
        categoryTotals[category].totalPaid += quoteLine.record.SBQQ__Quantity__c;
        categoryTotals[category].totalFwo += quoteLine.record.FWO_Quantity__c;
      });
      console.log('categoryTotals', categoryTotals); // loop through quote lines to check whether they are above the FWO Threshold
      quoteLineModels.forEach(function (quoteLine) {
        // Assigning our variables for the quoteLine's category
        var category = quoteLine.record.ProductCategory_MasterProgramFamily__c;
        console.log('category', category);
        var totalPaid = categoryTotals[category].totalPaid;
        var totalFwo = categoryTotals[category].totalFwo;
        var fwoThreshold = categoryTotals[category].fwoThreshold;
        console.log('FWO Threshold %', fwoThreshold); // Hotfix: to prevent divide by zero exception. Checking that totalPaid is not zero, otherwise leave fwoPaidQuote as 0
        var fwoPaidQuotient = 0;
        if (totalPaid != 0) {
          console.log('totalPaid is not zero:', totalPaid); // Dividing our total FWO by total Paid quantities, multiplied by 100 to match format for FWO Threshold %
          fwoPaidQuotient = (totalFwo / totalPaid) * 100;
        }
        console.log('FWO over Paid Quotient', fwoPaidQuotient); // compare the Category group's FWO / PAID result to the FWO Threshold, if greater FWO_Threshold_Exceeded__c and RequiresApproval__c gets marked as True for that QL, else mark them as False
        quoteLine.record.FWO_Threshold_Exceeded__c = fwoPaidQuotient > fwoThreshold;
        quoteLine.record.RequiresApproval__c = fwoPaidQuotient > fwoThreshold;
      });
      resolve();
    });
  } /* end cognizant */ //# sourceURL=ensxtx_enosix_sap_simulationV2
  return { setters: [], execute: function () {} };
});
