/*
 * Authors: Abhilash Bollampally - Enosix, Frank Berni - Cognizant
 * Date Created: 5/7/2024
 * Last Modified: 12/04/2024
 * Description: QCP script to run enosix SAP price retrieval for quote lines, W-014572: Contract Pricing and W-014932: FWO Threshold logic
 */
/* begin standard exports */
export function onBeforeCalculate(quoteModel, quoteLineModels, conn) {
  // W-014572 Calling enosix script and then running uncheckContractPricing to reset Enable Contract Pricing checkbox
  // W-014932 checking FWO Thresholds for Quote Lines under a given category
  return Promise.all([
    enosix_onBeforeCalculate(quoteModel, quoteLineModels, conn),
    uncheckContractPricing(quoteModel, quoteLineModels),
    checkCategoryFwoThresholds(quoteLineModels)
  ]);
}

export function isFieldEditableForObject(fieldName, quoteOrLine, conn, objectName) {
  if (objectName === 'QuoteLine__c') {
      if (fieldName === 'ensxtx_SAP_VC_Incomplete__c') {
          return false;
      }
  }
  
  // Lock only Approval Status and Start Date if Quote is in Draft
  if (
    objectName === 'Quote__c' &&
    quoteOrLine.ApprovalStatus__c == 'Draft' &&
    (fieldName === 'ApprovalStatus__c' || fieldName === 'SBQQ__StartDate__c')
  ) {
      return false;
  }

  // Lock all header fields on Quote if not in Draft
  if (objectName === 'Quote__c' && quoteOrLine.ApprovalStatus__c != 'Draft') {
      return false;
  }

  // Lock 'SBQQ__CustomerDiscount__c' and 'Total_Credit__c' Quote Line fields on Quote if user is not System Administrator or ICOM Sales Ops
  if (
    objectName === 'Quote__c' &&
    quoteOrLine.Current_User_Profile__c != 'System Administrator' &&
    quoteOrLine.Current_User_Profile__c != 'ICOM Sales Ops' &&
    (fieldName === 'SBQQ__CustomerDiscount__c' || fieldName === 'Total_Credit__c')
  ) {
      return false;
  }

  // Lock all Quote Line fields on Quote if not in Draft
  if (objectName === 'QuoteLine__c' && quoteOrLine.SBQQ__Quote__r.ApprovalStatus__c != 'Draft') {
      return false;
  }

  // FIXME Lock 'SBQQ__AdditionalDiscountAmount__c' and 'SBQQ__Discount__c' Quote Line fields on Quote if user is not System Administrator or ICOM Sales Ops
  if (
    objectName === 'QuoteLine__c' &&
    quoteOrLine.SBQQ__Quote__r.Current_User_Profile__c != 'System Administrator' &&
    quoteOrLine.SBQQ__Quote__r.Current_User_Profile__c != 'ICOM Sales Ops' &&
    (fieldName === 'SBQQ__AdditionalDiscountAmount__c' || fieldName === 'SBQQ__Discount__c')
  ) {
      return false;
  }

  // Lock Additional discount Quote Line fields for non-Sales Op/Admin Users
  if (objectName === 'QuoteLine__c' && fieldName === 'SBQQ__Description__c') {
      return false;
  }

  // NEW Ticket W-016670: Lock all of the following QL fields if not System Administrator
  if (
    objectName === 'QuoteLine__c' &&
    quoteOrLine.SBQQ__Quote__r.Current_User_Profile__c != 'System Administrator' &&
    (
      fieldName === 'Pricebook_Price__c' || 
      fieldName === 'StandardCost__c' ||
      fieldName === 'SBQQ__ListPrice__c' || 
      fieldName === 'Applied_Promotion_Name__c' ||
      fieldName === 'Contract_Price_Checked__c' || 
      fieldName === 'Net_SH_Amount__c' 
    )
  ) {
    return false;
  }
}
/* end standard exports */

/* begin enosix */
function enosix_onBeforeCalculate(quoteModel, quoteLineModels, conn) {
  // README - ALWAYS Leave this object empty when updating static resource from custom script
  // prettier-ignore
  const enosixConfig = {/*ENOSIXCONFIG*/};
  debug('enosixConfig', enosixConfig);

  console.log('Enable_Contract_Pricing__c:', quoteModel.record.Enable_Contract_Pricing__c);

  // W-014572: check if quote's contract pricing is false, if so, stop all functionality
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
  return new Promise((resolve, reject) => {
    let enableQuoteSimulation = quoteModel.record[enosixConfig.quoteSimulationEnabledField];

    if (quoteLineModels.length > 0 && enableQuoteSimulation) {
      let cpqQuote = {
        Id: quoteModel.record.Id
      };
      let requestQuoteRecordFields = enosixConfig.requestQuoteRecordFields || [];

      requestQuoteRecordFields.forEach(fieldName => {
        cpqQuote[fieldName] = quoteModel.record[fieldName];
      });

      let usedNumbers = [];
      let maxUsedNumber = 0;
      let simFromConfiguratorFound = false;
      quoteLineModels.forEach(quoteLine => {
        if (quoteLine.record.ensxtx_SAP_QuoteLine_JSON__c) {
          let simulationResponseLine = JSON.parse(quoteLine.record.ensxtx_SAP_QuoteLine_JSON__c);
          simulationResponseLine.SBQQ__Number__c = quoteLine.record.SBQQ__Number__c;
          Object.assign(quoteLine.record, simulationResponseLine);
          if (enosixConfig.splitSimulationLevel.toUpperCase() == 'PERLINE') {
            quoteLine.record.ensxtx_SAP_Simulated_JSON__c = JSON.stringify(simulationResponseLine);
          }
          quoteLine.record.ensxtx_SAP_QuoteLine_JSON__c = null;
          simFromConfiguratorFound = true;
        }
        if (quoteLine.record.ensxtx_SAP_Configuration__c) {
          let cpqItemConfig = JSON.parse(quoteLine.record.ensxtx_SAP_Configuration__c);
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
      quoteLineModels.forEach(quoteLine => {
        if (quoteLine.record.SBQQ__Number__c == 0) {
          quoteLine.record.SBQQ__Number__c = ++maxUsedNumber;
        }
      });

      if (simFromConfiguratorFound) {
        resortBom(quoteModel, quoteLineModels);
        quoteLineModels.sort(function (a, b) {
          return (
            a.record.ensxtx_SAP_Sort_Field__ephemeral - b.record.ensxtx_SAP_Sort_Field__ephemeral
          );
        });
      } else {
        quoteLineModels.sort(function (a, b) {
          return parseInt(a.record.SBQQ__Number__c) - parseInt(b.record.SBQQ__Number__c);
        });
      }

      let groupQuoteLineModelsList = buildGroupQuoteLineModels(
        enosixConfig,
        quoteModel,
        quoteLineModels
      );
      quoteModel.record.ensxtx_SAP_Simulation_Error__c = null;
      let pendingRequests = [];
      for (var groupCnt = 0; groupCnt < groupQuoteLineModelsList.length; groupCnt++) {
        let groupQuoteLineModels = groupQuoteLineModelsList[groupCnt].QuoteLineModels;
        if (groupQuoteLineModels.length > 0) {
          pendingRequests.push(
            new Promise((resolve, reject) => {
              let cpqQuoteLineList = [];
              groupQuoteLineModels.forEach(quoteLine => {
                if (!quoteModel.record.ensxtx_SAP_Consistency_Check__c)
                  quoteLine.record.ensxtx_SAP_Simulation_Error__c = null;
                let cpqQuoteLine = {
                  Id: quoteLine.record.Id,
                  SBQQ__Product__c: quoteLine.record.SBQQ__Product__c,
                  SBQQ__PricebookEntryId__c: quoteLine.record.SBQQ__PricebookEntryId__c,
                  SBQQ__DynamicOptionId__c: quoteLine.record.SBQQ__DynamicOptionId__c,
                  SBQQ__Number__c: quoteLine.record.SBQQ__Number__c,
                  SBQQ__Quantity__c: quoteLine.record.SBQQ__Quantity__c,
                  SBQQ__RequiredBy__c: quoteLine.record.SBQQ__RequiredBy__c,
                  ensxtx_SAP_Simulated__c: quoteLine.record.ensxtx_SAP_Simulated__c
                };
                let requestQuoteLineRecordFields = enosixConfig.requestQuoteLineRecordFields || [];

                requestQuoteLineRecordFields.forEach(fieldName => {
                  cpqQuoteLine[fieldName] = quoteLine.record[fieldName];
                });

                let cpqItemConfig = {};
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
              let serializedCPQQuote = JSON.stringify(cpqQuote);
              let serializedCPQQuoteLineList = JSON.stringify(cpqQuoteLineList);

              conn.apex
                .post(enosixConfig.enosixSapSimulationApexService, {
                  serializedCPQQuote: serializedCPQQuote,
                  serializedCPQQuoteLineList: serializedCPQQuoteLineList
                })
                .then(results => {
                  debug('Raw simulationResponse', results);
                  //deserialize the object back into readable format
                  let simulationResponse = JSON.parse(results);
                  debug('simulationResponse', simulationResponse);
                  if (simulationResponse && simulationResponse.data) {
                    if (simulationResponse.data.Success) {
                      cpqQuoteLineList.forEach(simulationResponseLine => {
                        let matchedQuoteLine = groupQuoteLineModels.find(quoteLine => {
                          return (
                            quoteLine.record.SBQQ__Number__c ==
                            simulationResponseLine.SBQQ__Number__c
                          );
                        });
                        if (matchedQuoteLine) {
                          matchedQuoteLine.record.ensxtx_SAP_Simulated__c = true;
                        }
                      });

                      // update the quote from the simulation response
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
                    simulationResponse.httpTraces.forEach(httpTrace => {
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
                .catch(err => {
                  returnSimulationError(resolve, reject, quoteModel, groupQuoteLineModels, err);
                });
            })
          );
        }
      }
      if (pendingRequests.length > 0) {
        Promise.all(pendingRequests)
          .then(results => {
            if (enosixConfig.resortBom) resortBom(quoteModel, quoteLineModels);
            quoteModel.record.ensxtx_SAP_Resimulate__c = false;
            quoteModel.record.ensxtx_SAP_Consistency_Check__c = false;
            resolve();
          })
          .catch(err => {
            returnSimulationError(resolve, reject, quoteModel, null, err);
          });
      } else {
        if (enosixConfig.resortBom) resortBom(quoteModel, quoteLineModels);
        quoteModel.record.ensxtx_SAP_Resimulate__c = false;
        quoteModel.record.ensxtx_SAP_Consistency_Check__c = false;
        resolve();
      }
    } else {
      resolve();
    }
  });

  function buildGroupQuoteLineModels(enosixConfig, quoteModel, quoteLineModels) {
    let tempGroupQuoteLineModelsList = [];
    let enosixSimulateQuoteLineModels = quoteLineModels.filter(qlm => {
      let isValid = qlm.record[enosixConfig.quoteLineSimulationEnabledField];
      let cpqItemConfig = qlm.record.ensxtx_SAP_Configuration__c;
      let parentItem = qlm.parentItem;
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
      enosixSimulateQuoteLineModels.forEach(quoteLine => {
        let chkQuoteLine = quoteLine;
        while (chkQuoteLine.parentItem) {
          chkQuoteLine = chkQuoteLine.parentItem;
        }
        let id = chkQuoteLine.record.SBQQ__Number__c;
        let groupQuoteLineModels = tempGroupQuoteLineModelsList.find(quoteLineModel => {
          return quoteLineModel.Id == id;
        });
        if (!groupQuoteLineModels) {
          groupQuoteLineModels = {
            Id: id,
            QuoteLineModels: []
          };
          tempGroupQuoteLineModelsList.push(groupQuoteLineModels);
        }
        groupQuoteLineModels.QuoteLineModels.push(quoteLine);
      });
    } else if (enosixConfig.splitSimulationLevel.toUpperCase() == 'ALLLINES') {
      let groupQuoteLineModels = {
        Id: 'All',
        QuoteLineModels: enosixSimulateQuoteLineModels
      };
      tempGroupQuoteLineModelsList.push(groupQuoteLineModels);
    } else if (enosixConfig.splitSimulationLevel.toUpperCase() == 'PERCPQGROUP') {
      if (quoteModel.groups.length > 0) {
        let id = 0;
        quoteModel.groups.forEach(group => {
          let groupQuoteLineModels = {
            Id: id++,
            QuoteLineModels: group.lineItems.filter(
              qlm => qlm.record[enosixConfig.quoteLineSimulationEnabledField]
            )
          };
          tempGroupQuoteLineModelsList.push(groupQuoteLineModels);
        });
      } else {
        let groupQuoteLineModels = {
          Id: 'All',
          QuoteLineModels: enosixSimulateQuoteLineModels
        };
        tempGroupQuoteLineModelsList.push(groupQuoteLineModels);
      }
    } else if (enosixConfig.splitSimulationLevel.toUpperCase() == 'GROUPBYFIELD') {
      enosixSimulateQuoteLineModels.forEach(quoteLine => {
        let chkQuoteLine = quoteLine;
        while (chkQuoteLine.parentItem) {
          chkQuoteLine = chkQuoteLine.parentItem;
        }
        let id = chkQuoteLine.record[enosixConfig.splitSimulationGroupByField];
        let groupQuoteLineModels = tempGroupQuoteLineModelsList.find(quoteLineModel => {
          return quoteLineModel.Id == id;
        });
        if (!groupQuoteLineModels) {
          groupQuoteLineModels = {
            Id: id,
            QuoteLineModels: []
          };
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
    let requestQuoteRecordFields = enosixConfig.requestQuoteRecordFields || [];
    let simQuote = {};
    if (quoteModel.record.ensxtx_SAP_Simulated_JSON__c)
      simQuote = JSON.parse(quoteModel.record.ensxtx_SAP_Simulated_JSON__c);
    let currQuote = {};
    let isQuoteChanged = false;
    requestQuoteRecordFields.forEach(fieldName => {
      if (
        simQuote[fieldName] != quoteModel.record[fieldName] &&
        fieldName != 'ensxtx_SAP_Consistency_Check__c'
      )
        isQuoteChanged = true;
      currQuote[fieldName] = quoteModel.record[fieldName];
    });
    quoteModel.record.ensxtx_SAP_Simulated_JSON__c = JSON.stringify(currQuote);

    let requestQuoteLineRecordFields = enosixConfig.requestQuoteLineRecordFields || [];
    tempGroupQuoteLineModelsList.forEach(groupQuoteLineModels => {
      groupQuoteLineModels.QuoteLineModels.forEach(quoteLine => {
        let simQuoteLine = {};
        if (quoteLine.record.ensxtx_SAP_Simulated_JSON__c)
          simQuoteLine = JSON.parse(quoteLine.record.ensxtx_SAP_Simulated_JSON__c);
        let currQuoteLine = {};
        let isQuoteLineChanged = false;
        requestQuoteLineRecordFields.forEach(fieldName => {
          if (simQuoteLine[fieldName] != quoteLine.record[fieldName]) isQuoteLineChanged = true;
          currQuoteLine[fieldName] = quoteLine.record[fieldName];
        });
        quoteLine.record.ensxtx_SAP_Simulated_JSON__c = JSON.stringify(currQuoteLine);
        quoteLine.isQuoteLineChanged = isQuoteLineChanged;
      });
    });

    let groupQuoteLineModelsList = [];
    tempGroupQuoteLineModelsList.forEach(groupQuoteLineModels => {
      let quoteLineList = groupQuoteLineModels.QuoteLineModels.find(quoteLine => {
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
    let tempQuoteLineModels = [];
    try {
      if (quoteModel.record.ensxtx_SAP_Consistency_Check__c) {
        quoteLineModels.forEach(quoteLine => {
          if (quoteLine.record.ensxtx_SAP_Configuration__c) {
            let cpqItemConfig = JSON.parse(quoteLine.record.ensxtx_SAP_Configuration__c);
            cpqItemConfig.isIncomplete = false;
            quoteLine.record.ensxtx_SAP_Configuration__c = JSON.stringify(cpqItemConfig);
            quoteLine.record.ensxtx_SAP_Simulation_Error__c = null;
          }
          quoteLine.record.ensxtx_SAP_VC_Incomplete__c = false;
        });
      } else {
        Object.assign(quoteModel.record, simulationResponse.cpqQuote);
        simulationResponse.cpqQuoteLineList.forEach(simulationResponseLine => {
          let matchedQuoteLine = quoteLineModels.find(quoteLine => {
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
        simulationResponse.cpqQuoteLineList.forEach(simulationResponseLine => {
          let matchedQuoteLine = quoteLineModels.find(quoteLine => {
            return quoteLine.record.SBQQ__Number__c == simulationResponseLine.SBQQ__Number__c;
          });
          let isSimulated;
          simulationResponse.cpqQuoteLineList.forEach(childQuoteLine => {
            let matchedChildQuoteLine = quoteLineModels.find(quoteLine => {
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
    let sortModelMap = {};
    quoteLineModels.forEach(quoteLine => {
      let sortModel = sortModelMap[quoteLine.record.SBQQ__Number__c] || { childList: [] };
      sortModelMap[quoteLine.record.SBQQ__Number__c] = sortModel;
      if (quoteLine.parentItem) {
        let parentSortModel = sortModelMap[quoteLine.parentItem.record.SBQQ__Number__c] || {
          childList: []
        };
        parentSortModel.childList.push(quoteLine);
        sortModelMap[quoteLine.parentItem.record.SBQQ__Number__c] = parentSortModel;
      }
    });

    Object.keys(sortModelMap).forEach(key => {
      let sortModel = sortModelMap[key];
      if (sortModel.childList.length > 0) {
        sortModel.childList.forEach(quoteLine => {
          let sortString = quoteLine.record.ensxtx_SAP_Item_Number__c || '9999999';
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

    let qlSortedList = [];
    resortChildren(quoteLineModels, sortModelMap, qlSortedList);
    quoteModel._innerModel.lineSortField = 'ensxtx_SAP_Sort_Field__ephemeral';
    quoteLineModels = qlSortedList;
  }

  function resortChildren(quoteLineModels, sortModelMap, qlSortedList) {
    quoteLineModels.forEach(quoteLine => {
      let isQuoteLineSorted = qlSortedList.find(quoteLineSorted => {
        return quoteLine.record.SBQQ__Number__c == quoteLineSorted.record.SBQQ__Number__c;
      });
      if (!isQuoteLineSorted) {
        quoteLine.record.ensxtx_SAP_Sort_Field__ephemeral = (qlSortedList.length + 1)
          .toString()
          .padStart(5, '0');
        qlSortedList.push(quoteLine);
        let sortModel = sortModelMap[quoteLine.record.SBQQ__Number__c];
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
      let errQuoteLine;
      if (err.substr(0, 15) == 'Internal error:') {
        let qlNumber;
        const errArray = err.split(' Item Number ');
        if (errArray.length > 1) qlNumber = errArray[1].split(' ')[0];
        const qlArray = quoteLineModels.filter(qlm => qlm.record.SBQQ__Number__c == qlNumber);
        if (qlArray.length > 0) errQuoteLine = qlArray[0];
      }
      if (errQuoteLine) {
        errQuoteLine.record.ensxtx_SAP_Simulation_Error__c = err;
        if (err.includes('CFG_IS_INCONSISTENT_OR_INCOMPLETE')) {
          let cpqItemConfig = errQuoteLine.record.ensxtx_SAP_Configuration__c
            ? JSON.parse(errQuoteLine.record.ensxtx_SAP_Configuration__c)
            : {};
          cpqItemConfig.isIncomplete = true;
          errQuoteLine.record.ensxtx_SAP_Configuration__c = JSON.stringify(cpqItemConfig);
          errQuoteLine.record.ensxtx_SAP_VC_Incomplete__c = true;
        }
      } else {
        quoteLineModels.forEach(quoteLine => {
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

  /** Log to console if debug is enabled */
  function debug(...args) {
    if (enosixConfig.DEBUG) {
      console.log(...args);
    }
  }
}
/* end enosix */

/* begin cognizant */
// W-014572 uncheckContractPricing: takes in quoteModel and unchecks Enable Contract Pricing - treats checkbox like a button
function uncheckContractPricing(quoteModel, quoteLineModels) {
  return new Promise((resolve, reject) => {
    console.log('uncheckContractPricing');
    if (quoteModel.record.Enable_Contract_Pricing__c) {
      console.log('Unchecking Enable Contract Pricing');
      // uncheck the Enable Contract Pricing Button
      quoteModel.record.Enable_Contract_Pricing__c = false;

      // Loop through each Quote Line and mark that they've been run through Contract Pricing
      quoteLineModels.forEach(quoteLine => {
        if (!quoteLine.record.Contract_Price_Checked__c) {
          quoteLine.record.Contract_Price_Checked__c = true;
        }
      });
    }
    resolve();
  });
}

// checkCategoryFwoThresholds takes in quoteLineModels. Rolls up Quote line Quantity and FWO Quantity to check whether they exceed their FWO Threshold or Not
function checkCategoryFwoThresholds(quoteLineModels) {
  return new Promise((resolve, reject) => {
    console.log('checkCategoryFwoThresholds');

    // Initialize our object of MasterProgramFamily category and its Total FWO Quantity, Total Paid Quantity, FWO Threshold
    let categoryTotals = {};

    // loop through qls to construct our category groupings object
    quoteLineModels.forEach(quoteLine => {
      const category = quoteLine.record.ProductCategory_MasterProgramFamily__c;

      // If this quote line's category doesn't exist in the object yet, initialize its totalPaid, totalFwo and fwoThreshold
      if (!categoryTotals[category]) {
        categoryTotals[category] = {
          totalPaid: 0,
          totalFwo: 0,
          fwoThreshold: quoteLine.record.FWO_Threshold_Percentage__c
            ? quoteLine.record.FWO_Threshold_Percentage__c
            : 0
        };
      }

      // Start rolling up the summary of all quote line Quantity and FWO Quantity fields to its matching category
      categoryTotals[category].totalPaid += quoteLine.record.SBQQ__Quantity__c;
      categoryTotals[category].totalFwo += quoteLine.record.FWO_Quantity__c;
    });

    console.log('categoryTotals', categoryTotals);

    // loop through quote lines to check whether they are above the FWO Threshold
    quoteLineModels.forEach(quoteLine => {
      // Assigning our variables for the quoteLine's category
      const category = quoteLine.record.ProductCategory_MasterProgramFamily__c;
      console.log('category', category);
      const totalPaid = categoryTotals[category].totalPaid;
      const totalFwo = categoryTotals[category].totalFwo;
      const fwoThreshold = categoryTotals[category].fwoThreshold;
      console.log('FWO Threshold %', fwoThreshold);

      // Hotfix: to prevent divide by zero exception. Checking that totalPaid is not zero, otherwise leave fwoPaidQuote as 0
      let fwoPaidQuotient = 0;
      if (totalPaid != 0) {
        console.log('totalPaid is not zero:', totalPaid);
        // Dividing our total FWO by total Paid quantities, multiplied by 100 to match format for FWO Threshold %
        fwoPaidQuotient = (totalFwo / totalPaid) * 100;
      }

      console.log('FWO over Paid Quotient', fwoPaidQuotient);

      // compare the Category group's FWO / PAID result to the FWO Threshold, if greater FWO_Threshold_Exceeded__c and RequiresApproval__c gets marked as True for that QL, else mark them as False
      quoteLine.record.FWO_Threshold_Exceeded__c = fwoPaidQuotient > fwoThreshold;
      quoteLine.record.RequiresApproval__c = fwoPaidQuotient > fwoThreshold;
    });

    resolve();
  });
}
/* end cognizant */

//# sourceURL=ensxtx_enosix_sap_simulationV2
