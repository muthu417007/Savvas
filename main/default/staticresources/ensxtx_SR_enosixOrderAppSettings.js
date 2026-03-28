{
  "$schema": "../../staticresources/ensxtx_SR_SalesDocAppSettings_schema.json",
  "SalesDoc": {
    "DefaultOrder": {
      "itemNumberIncrement": 10,
      "sortOrderIncrement": 10,
      "bomItemNumberIncrement": 1,
      "lineItemsBatchForAsync": 0,
      "autoSimulate": {
        "afterPartnerSelection": true,
        "afterItemAdd": true,
        "afterItemEditSave": true,
        "afterItemDelete": true,
        "afterItemClone": true,
        "afterItemConfiguration": true,
        "afterFieldUpdate": true,
        "afterSortItems": true
      },
      "showHeaderIncompletionLogs": true,
      "showItemIncompletionLogs": true,
      "incompletionLogsAsErrors": false,
      "enableBoMCountCommand": false,
      "enableBoMItemEdit": false,
      "purgeSAPMaterialsBeforeUpdate": false,
      "compareSAPSimulateVsSObject": false,
      "mapChildBomFields": false,
      "updateLineItems": true,
      "deleteLineItems": false,
      "mapUpdateFromSObject": true,
      "useConvertToObjectTrigger": false,
      "enableConfiguration": true,
      "SAPDocType": "Order",
      "SBODetailType": "SalesDocument",
      "DefaultDocType": "YORD",
      "DefaultDocTypeInternal": "YORD",
      "sfInvokeFrom": "StandardUI",
      "DocTypes": [
        {
          "id": "YORD",
          "internalId": "YORD",
          "label": "Standard Order"
        }
      ],
      "salesAreasFromCustomer": true,
      "SalesAreas": [
        {
          "SalesOrganization": "SalesOrganization",
          "SalesOrganizationName": "SalesOrganizationName",
          "DistributionChannel": "DistributionChannel",
          "DistributionChannelName": "DistributionChannelName",
          "Division": "Division",
          "DivisionName": "DivisionName"
        }
      ],
      "optionValuesToInclude": {
        "Header": {
          "Conditions": [],
          "FieldName": [
            "VALUE1",
            "VALUE2"
          ]
        },
        "Item": {
          "Conditions": []
        }
      },
      "Header": {
        "PartnerPickers": [
          {
            "PartnerFunction": "SH",
            "PartnerFunctionInternal": "WE",
            "PartnerFunctionName": "ShipTo",
            "CustomLabel_PartnerFunctionName": "ensxtx_SalesDocPartners_Description_ShipTo",
            "ComponentType": "PartnerSearch",
            "SearchType": "Partner",
            "autoSearch": true,
            "allowSearch": true,
            "allowAddressOverride": false,
            "autoPopulateAddressOverrideFromCustomer": false
          },
          {
            "PartnerFunction": "CP",
            "PartnerFunctionInternal": "AP",
            "PartnerFunctionName": "Contact",
            "CustomLabel_PartnerFunctionName": "ensxtx_SalesDocPartners_Description_Contact",
            "ComponentType": "CustomerSearch",
            "SearchType": "Contact",
            "autoSearch": true,
            "allowSearch": true,
            "allowAddressOverride": false,
            "autoPopulateAddressOverrideFromCustomer": false
          }
        ],
        "Texts": [
          {
            "Id": "0001",
            "Description": "Form Header:",
            "Required": false
          },
          {
            "Id": "0002",
            "Description": "Header Note 1:",
            "Required": false
          },
          {
            "Id": "0003",
            "Description": "Header Note 2:",
            "Required": false
          }
        ]
      },
      "Item": {
        "PartnerPickers": [
          {
            "PartnerFunction": "SH",
            "PartnerFunctionInternal": "WE",
            "PartnerFunctionName": "ShipTo",
            "CustomLabel_PartnerFunctionName": "ensxtx_SalesDocPartners_Description_ShipTo",
            "ComponentType": "PartnerSearch",
            "SearchType": "Partner",
            "autoSearch": true,
            "allowSearch": true,
            "allowAddressOverride": false,
            "autoPopulateAddressOverrideFromCustomer": false
          }
        ],
        "Texts": [
          {
            "Id": "0001",
            "Description": "Sales Text:",
            "Required": false
          },
          {
            "Id": "0002",
            "Description": "Item Note:",
            "Required": false
          }
        ]
      },
      "Default": {
        "autoInvoke": false,
        "displaySimulate": true,
        "displaySort": false,
        "displaySaveToSOject": false,
        "displaySaveToSAP": false,
        "AddMaterial": {
          "display": true,
          "edit": true
        },
        "Tabs": {
          "Header": {
            "Conditions": {
              "display": true,
              "edit": true
            },
            "Partners": {
              "display": true,
              "edit": true
            }
          },
          "Item": {
            "Conditions": {
              "display": true,
              "edit": true
            },
            "Partners": {
              "display": true,
              "edit": true
            },
            "BillingPlans": {
              "display": false,
              "edit": false
            },
            "Schedules": {
              "display": false,
              "edit": false
            },
            "MaterialInventory": {
              "display": false,
              "edit": false
            }
          }
        },
        "Fields": {
          "Header": {
            "DocumentNumber": {
              "display": false
            },
            "CreateDate": {
              "display": false
            },
            "SoldToParty": {
              "display": true,
              "edit": false,
              "required": false,
              "simulate": false
            },
            "SalesDocumentType": {
              "collection": "SALES",
              "display": true,
              "edit": false,
              "required": false,
              "simulate": false
            },
            "SalesOrganization": {
              "collection": "SALES",
              "display": true,
              "edit": false,
              "required": true,
              "simulate": true
            },
            "DistributionChannel": {
              "collection": "SALES",
              "display": true,
              "edit": false,
              "required": true,
              "simulate": true
            },
            "Division": {
              "collection": "SALES",
              "display": true,
              "edit": false,
              "required": true,
              "simulate": true
            },
            "CustomerPurchaseOrderDate": {
              "display": true,
              "edit": true,
              "required": false,
              "simulate": false
            },
            "ValidFrom": {
              "collection": "SALES",
              "display": false,
              "edit": false,
              "required": false,
              "simulate": false
            },
            "ValidTo": {
              "collection": "SALES",
              "display": false,
              "edit": false,
              "required": false,
              "simulate": false
            },
            "StartDate": {
              "display": false,
              "edit": false,
              "required": false,
              "simulate": false
            },
            "EndDate": {
              "display": false,
              "edit": false,
              "required": false,
              "simulate": false
            },
            "RequestedDeliveryDate": {
              "collection": "SALES",
              "display": true,
              "edit": true,
              "required": true,
              "simulate": false
            },
            "CustomerPurchaseOrderNumber": {
              "display": true,
              "edit": true,
              "required": true,
              "simulate": false
            },
            "TermsofPaymentKey": {
              "collection": "SALES",
              "display": true,
              "edit": true,
              "required": false,
              "simulate": false
            },
            "IncotermsPart1": {
              "collection": "SALES",
              "display": true,
              "edit": true,
              "required": false,
              "simulate": false
            },
            "SalesOffice": {
              "collection": "SALES",
              "display": false,
              "edit": false,
              "required": false,
              "simulate": false
            },
            "SalesGroup": {
              "collection": "SALES",
              "display": false,
              "edit": false,
              "required": false,
              "simulate": false
            },
            "SalesDistrict": {
              "collection": "SALES",
              "display": false,
              "edit": false,
              "required": false,
              "simulate": false
            },
            "IncotermsPart2": {
              "collection": "SALES",
              "display": true,
              "edit": true,
              "required": false,
              "simulate": false
            },
            "ShippingConditions": {
              "display": true,
              "edit": true,
              "required": false,
              "simulate": false
            },
            "DateforPricingExchangeRate": {
              "collection": "SALES",
              "display": true,
              "edit": true,
              "required": false,
              "simulate": false
            },
            "BillingBlock": {
              "collection": "SALES",
              "display": false,
              "edit": false,
              "required": false,
              "simulate": false
            },
            "DeliveryBlock": {
              "collection": "SALES",
              "display": false,
              "edit": false,
              "required": false,
              "simulate": false
            },
            "SalesDocumentCurrency": {
              "display": true,
              "edit": false,
              "required": false,
              "simulate": false
            },
            "NetOrderValue": {
              "display": true
            },
            "Texts": {
              "display": true,
              "edit": true,
              "required": false,
              "simulate": false
            }
          },
          "PartnerTable": {
            "PartnerName": {
              "display": true
            },
            "CustomerNumber": {
              "display": true
            },
            "Vendor": {
              "display": true
            },
            "PersonnelNumber": {
              "display": true
            },
            "ContactPersonNumber": {
              "display": true
            }
          },
          "PartnerSearchTable": {
            "PartnerNumber": {
              "display": true
            },
            "PartnerName": {
              "display": true
            },
            "VendorNumber": {
              "display": true
            },
            "VendorName": {
              "display": true
            },
            "ContactNumber": {
              "display": true
            },
            "ContactFirstName": {
              "display": true
            },
            "ContactLastName": {
              "display": true
            },
            "PersonnelNumber": {
              "display": true
            },
            "PersonnelFirstName": {
              "display": true
            },
            "PersonnelLastName": {
              "display": true
            },
            "HouseNumber": {
              "display": true
            },
            "Street": {
              "display": true
            },
            "City": {
              "display": true
            },
            "Region": {
              "display": true
            },
            "PostalCode": {
              "display": true
            },
            "Country": {
              "display": true
            }
          },
          "CustomerSearchTable": {
            "FromNumberSearch": {
              "display": true
            },
            "ToNumberSearch": {
              "display": true
            },
            "NameSearch": {
              "display": true
            },
            "Name2Search": {
              "display": true
            },
            "CustomerNumberSearch": {
              "display": true
            },
            "CitySearch": {
              "display": true
            },
            "RegionSearch": {
              "display": true
            },
            "PostalCodeSearch": {
              "display": true
            },
            "CountrySearch": {
              "display": true
            },
            "TelephoneSearch": {
              "display": true
            },
            "EmailSearch": {
              "display": true
            },
            "CustomerNumber": {
              "display": true
            },
            "Name": {
              "display": true
            },
            "Name2": {
              "display": true
            },
            "Street": {
              "display": true
            },
            "City": {
              "display": true
            },
            "Region": {
              "display": true
            },
            "PostalCode": {
              "display": true
            },
            "Country": {
              "display": true
            }
          },
          "ConditionTable": {
            "ConditionType": {
              "display": true
            },
            "ConditionTypeName": {
              "display": true
            },
            "Rate": {
              "display": true
            },
            "RateUnit": {
              "display": true
            },
            "ConditionPricingUnit": {
              "display": true
            },
            "ConditionUnit": {
              "display": true
            },
            "ConditionValue": {
              "display": true
            },
            "CurrencyKey": {
              "display": true
            }
          },
          "ItemTable": {
            "ItemActions": {
              "display": true,
              "edit": true
            },
            "ItemActionsView": {
              "display": true,
              "edit": true
            },
            "ItemActionsEdit": {
              "display": true,
              "edit": true
            },
            "ItemActionsRemove": {
              "display": true,
              "edit": true
            },
            "ItemActionsClone": {
              "display": false,
              "edit": true
            },
            "Material": {
              "display": true,
              "edit": false
            },
            "MaterialEntered": {
              "display": true,
              "edit": false
            },
            "ItemDescription": {
              "display": true,
              "edit": true
            },
            "Quantity": {
              "display": true,
              "edit": true
            },
            "SalesUnit": {
              "display": true
            },
            "BaseUnitOfMeasure": {
              "display": false
            },
            "RequestedDate": {
              "display": true,
              "edit": true
            },
            "NetItemPrice": {
              "display": true
            },
            "NetOrderValue": {
              "display": true
            },
            "Plant": {
              "display": true,
              "edit": false
            },
            "ItemCategory": {
              "display": true
            },
            "BillingBlockStatus": {
              "display": false,
              "edit": false
            },
            "DeliveryBlockStatus": {
              "display": false,
              "edit": false
            }
          },
          "ItemSortTable": {
            "Material": {
              "display": true
            },
            "ItemDescription": {
              "display": true
            },
            "Quantity": {
              "display": true
            },
            "SalesUnit": {
              "display": true
            },
            "BaseUnitOfMeasure": {
              "display": true
            },
            "RequestedDate": {
              "display": true
            },
            "NetItemPrice": {
              "display": true
            },
            "NetOrderValue": {
              "display": true
            },
            "Plant": {
              "display": true
            },
            "ItemCategory": {
              "display": true
            },
            "BillingBlockStatus": {
              "display": false
            },
            "DeliveryBlockStatus": {
              "display": false
            }
          },
          "MaterialSearchTable": {
            "multiSelect": {
              "enable": true
            },
            "autoSearch": {
              "enable": false
            },
            "separateFlowComponent": {
              "enable": false
            },
            "materialSearch": {
              "display": true
            },
            "descriptionSearch": {
              "display": true
            },
            "materialTypeSearch": {
              "display": false
            },
            "materialType": {
              "display": true
            },
            "materialDescription": {
              "display": true
            },
            "productHierarchyField": {
              "display": false
            },
            "quantity": {
              "display": true
            },
            "unitOfMeasure": {
              "display": true
            },
            "scheduleDate": {
              "display": false
            }
          },
          "ItemEdit": {
            "EditItemFields": {
              "AlternativeItem": {
                "display": false,
                "edit": true,
                "required": false,
                "simulate": false
              },
              "Material": {
                "display": true,
                "edit": false,
                "required": false,
                "simulate": false
              },
              "MaterialEntered": {
                "display": true,
                "edit": false,
                "required": false,
                "simulate": false
              },
              "ItemDescription": {
                "display": true,
                "edit": true,
                "required": false,
                "simulate": false
              },
              "OrderQuantity": {
                "display": true,
                "edit": true,
                "required": false,
                "simulate": false
              },
              "SalesUnitInternal": {
                "display": true,
                "edit": false,
                "required": false,
                "simulate": false
              },
              "ScheduleLineDate": {
                "display": true,
                "edit": true,
                "required": false,
                "simulate": false
              },
              "Plant": {
                "display": true,
                "edit": true,
                "required": false,
                "simulate": false
              },
              "RejectionReason": {
                "display": false,
                "edit": true,
                "required": false,
                "simulate": false
              },
              "PriceListType": {
                "display": true,
                "edit": false,
                "required": false,
                "simulate": false
              },
              "NetWeight": {
                "display": true
              },
              "NetItemPrice": {
                "display": true
              },
              "NetOrderValue": {
                "display": true
              },
              "ItemCategory": {
                "display": true,
                "edit": false,
                "required": false,
                "simulate": false
              },
              "Texts": {
                "display": true,
                "edit": true,
                "required": false,
                "simulate": false
              }
            },
            "PartnerTable": {
              "PartnerName": {
                "display": true
              },
              "CustomerNumber": {
                "display": true
              },
              "Vendor": {
                "display": true
              },
              "PersonnelNumber": {
                "display": true
              },
              "ContactPersonNumber": {
                "display": true
              }
            },
            "PartnerSearchTable": {
              "PartnerNumber": {
                "display": true
              },
              "PartnerName": {
                "display": true
              },
              "VendorNumber": {
                "display": true
              },
              "VendorName": {
                "display": true
              },
              "ContactNumber": {
                "display": true
              },
              "ContactFirstName": {
                "display": true
              },
              "ContactLastName": {
                "display": true
              },
              "PersonnelNumber": {
                "display": true
              },
              "PersonnelFirstName": {
                "display": true
              },
              "PersonnelLastName": {
                "display": true
              },
              "HouseNumber": {
                "display": true
              },
              "Street": {
                "display": true
              },
              "City": {
                "display": true
              },
              "Region": {
                "display": true
              },
              "PostalCode": {
                "display": true
              },
              "Country": {
                "display": true
              }
            },
            "CustomerSearchTable": {
              "FromNumberSearch": {
                "display": true
              },
              "ToNumberSearch": {
                "display": true
              },
              "NameSearch": {
                "display": true
              },
              "Name2Search": {
                "display": true
              },
              "CustomerNumberSearch": {
                "display": true
              },
              "CitySearch": {
                "display": true
              },
              "RegionSearch": {
                "display": true
              },
              "PostalCodeSearch": {
                "display": true
              },
              "CountrySearch": {
                "display": true
              },
              "TelephoneSearch": {
                "display": true
              },
              "EmailSearch": {
                "display": true
              },
              "CustomerNumber": {
                "display": true
              },
              "Name": {
                "display": true
              },
              "Name2": {
                "display": true
              },
              "Street": {
                "display": true
              },
              "City": {
                "display": true
              },
              "Region": {
                "display": true
              },
              "PostalCode": {
                "display": true
              },
              "Country": {
                "display": true
              }
            },
            "ConditionTable": {
              "ConditionType": {
                "display": true
              },
              "ConditionTypeName": {
                "display": true
              },
              "Rate": {
                "display": true
              },
              "RateUnit": {
                "display": true
              },
              "ConditionPricingUnit": {
                "display": true
              },
              "ConditionUnit": {
                "display": true
              },
              "ConditionValue": {
                "display": true
              },
              "CurrencyKey": {
                "display": true
              }
            },
            "BillingPlanTable": {
              "DeadlineSettlementDate": {
                "display": true
              },
              "Usage": {
                "display": true
              },
              "PercentageOfValueToBeInvoiced": {
                "display": true
              },
              "ValueToBeBilled": {
                "display": true
              },
              "BillingBlockForBillingPlan": {
                "display": true
              },
              "RuleInBillingPlan": {
                "display": true
              },
              "BillingStatusForBillingPlan": {
                "display": true
              },
              "DateCategory": {
                "display": true
              },
              "ProposedBillingType": {
                "display": true
              }
            },
            "ScheduleTable": {
              "ScheduleLineNumber": {
                "display": true
              },
              "ScheduleLineDate": {
                "display": true
              },
              "OrderQuantity": {
                "display": true
              },
              "RoundedQuantity": {
                "display": false
              },
              "ConfirmedQuantity": {
                "display": true
              },
              "SalesUnit": {
                "display": true
              },
              "DeliveryBlock": {
                "display": false
              },
              "DeliveryBlockDescription": {
                "display": false
              },
              "DeliveredQuantity": {
                "display": false
              },
              "ScheduleLineCategory": {
                "display": false
              },
              "ScheduleLineCategoryDescription": {
                "display": false
              },
              "PurchaseRequisitionNumber": {
                "display": false
              },
              "PurchaseRequisitionItemNumber": {
                "display": false
              }
            },
            "MaterialInventoryTable": {
              "Plant": {
                "display": true
              },
              "CommittedDate": {
                "display": true
              },
              "CommittedQuantity": {
                "display": true
              }
            }
          }
        }
      },
      "Simulate": {
        "displaySaveToSOject": true
      },
      "Create": {
        "displaySaveToSAP": true
      },
      "Update": {
        "displaySaveToSAP": true,
        "Fields": {
          "Header": {
            "CreateDate": {
              "display": true
            },
              "DocumentNumber": {
              "display": true
            }
          }
        }
      },
      "InvokeMethodAppSettings": [
        {
            "InvokeMethod": "Simulate",
            "insertSalesDocLog": false,
            "skipAddedLineValidation": false
        },
        {
            "InvokeMethod": "Create",
            "insertSalesDocLog": true,
            "skipAddedLineValidation": false
        },
        {
          "InvokeMethod": "Update",
          "insertSalesDocLog": true,
          "skipAddedLineValidation": false
        }
      ]
    }
  }
}