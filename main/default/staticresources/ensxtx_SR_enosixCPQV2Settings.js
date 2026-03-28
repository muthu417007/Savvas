{
  "SBODetailType": "Pricing",
  "DefaultQuoteLineIncrement": 100,
  "DefaultSalesDocType": "YORD",
  "DefaultSalesOrg": "",
  "DefaultDistributionChannel": "02",
  "DefaultDivision": "99",
  "DefaultCustomerNumber": "",
  "DefaultMaterialgroup1": "",
  "DefaultMaterialgroup2": "",
  "SalesOrgList": [],
  "DistributionChannelList": [],
  "DivisionList": [],
  "AddVCBoM": true,
  "AddNonVCBoM": true,
  "SkipMissingBoM": true,
  "isIncompleteAllowed": false,
  "VCFlow": "ensxtx_sapVCFlow",
  "Pricing": {
    "Request": {
      "Quote": {
        "RecordMapping": [
          {
            "collection": "sales",
            "field": "SalesDocumentType",
            "defaultValue": "YORD",
            "sObjectField": "ensxtx_Document_Type__c"
          },
          {
            "collection": "sales",
            "field": "SalesOrganization",
            "defaultValue": "",
            "sObjectField": "ensxtx_Sales_Organization__c"
          },
          {
            "collection": "sales",
            "field": "DistributionChannel",
            "defaultValue": "02",
            "sObjectField": "ensxtx_Distribution_Channel__c"
          },
          {
            "collection": "sales",
            "field": "Division",
            "defaultValue": "99",
            "sObjectField": "ensxtx_Division__c"
          },
          {
            "collection": "sales",
            "field": "DateforPricingExchangeRate",
            "defaultValue": "",
            "sObjectField": "CPQ_Future_Pricing_Date__c"
          },
          {
            "collection": "header",
            "field": "SoldToParty",
            "defaultValue": "",
            "sObjectField": "Sold_To_Customer__c"
          },
          {
            "collection": "partners",
            "field": "CustomerNumber",
            "partnerFunction": "SP",
            "defaultValue": "",
            "sObjectField": "Sold_To_Customer__c"
          },
          {
            "collection": "header",
            "field": "SalesDocumentCurrency",
            "defaultValue": "",
            "sObjectField": "CurrencyIsoCode"
          }
        ]
      },
      "QuoteLine": {
        "RecordMapping": [
          {
            "collection": "items",
            "field": "OrderQuantity",
            "defaultValue": "",
            "sObjectField": "SBQQ__Quantity__c"
          },
          {
            "collection": "items",
            "field": "Material",
            "defaultValue": "",
            "sObjectField": "SBQQ__ProductCode__c"
          }
        ]
      }
    },
    "Response": {
      "Quote": {
        "RecordMapping": []
      },
      "QuoteLine": {
        "RecordMapping": [
          {
            "collection": "items",
            "field": "NetItemPrice",
            "sObjectField": "SBQQ__NetPrice__c"
          },
          {
            "collection": "items",
            "field": "NetItemPrice",
            "sObjectField": "SBQQ__ListPrice__c"
          },
          {
            "collection": "conditions",
            "field": "PR00",
            "transform": "conditionRate",
            "sObjectField": "SBQQ__OriginalPrice__c"
          },
          {
            "collection": "items",
            "field": "ItemNumber",
            "sObjectField": "ensxtx_SAP_Item_Number__c",
            "showInTrace": false
          },
          {
            "collection": "items",
            "field": "ShippingHandlingRate",
            "sObjectField": "Calculated_SH_Rate__c",
            "showInTrace": false
          }
        ]
      }
    }
  },
  "UTIL_CPQ_SetupV2": {
    "customScriptName": "ensxtx_enosix_sap_simulationV2",
    "staticresourceCodeName": "ensxtx_enosix_sap_simulationV2",
    "staticresourceTranspiledCodeName": "ensxtx_enosix_sap_simulationV2_transpiled",
    "quoteFields": ["Enable_Contract_Pricing__c", "ApprovalStatus__c"],
    "quoteLineFields": [
      "Contract_Price_Checked__c",
      "FWO_Threshold_Percentage__c",
      "FWO_Threshold_Exceeded__c",
      "FWO_Quantity__c",
      "ProductCategory_MasterProgramFamily__c",
      "RequiresApproval__c"
    ],
    "config": {
      "DEBUG": false,
      "resortBom": true,
      "splitSimulationLevel": "AllLines",
      "splitSimulationGroupByField": "",
      "quoteSimulationEnabledField": "ensxtx_enablePricingSimulation__c",
      "quoteLineSimulationEnabledField": "ensxtx_enablePricingSimulation__c",
      "enosixSapSimulationApexService": "/ensxtx_ENSX_CPQ_QuoteCalculationServV2",
      "requestQuoteRecordFields": [],
      "requestQuoteLineRecordFields": []
    }
  },
  "DrawerColumns": [
    {
      "fieldName": "Material",
      "display": true
    },
    {
      "fieldName": "ItemDescription",
      "display": true
    },
    {
      "fieldName": "OrderQuantity",
      "display": true
    },
    {
      "fieldName": "NetItemPrice",
      "display": false
    },
    {
      "fieldName": "SalesUnit",
      "display": true
    },
    {
      "fieldName": "Plant",
      "display": true
    },
    {
      "fieldName": "ScheduleLineDate",
      "display": true
    },
    {
      "fieldName": "ItemCategory",
      "display": true
    },
    {
      "fieldName": "BillingBlockStatus",
      "display": false
    },
    {
      "fieldName": "DeliveryBlockStatus",
      "display": false
    },
    {
      "fieldName": "ConditionPricingUnit",
      "display": false
    },
    {
      "fieldName": "NetOrderValue",
      "display": false
    },
    {
      "fieldName": "SalesDocumentCurrency",
      "display": false
    },
    {
      "fieldName": "NetWeight",
      "display": false
    },
    {
      "fieldName": "WeightUnit",
      "display": false
    },
    {
      "fieldName": "GrossWeight",
      "display": false
    },
    {
      "fieldName": "BaseUnitOfMeasure",
      "display": false
    },
    {
      "fieldName": "AlternativeItem",
      "display": false
    },
    {
      "fieldName": "PriceListType",
      "display": false
    },
    {
      "fieldName": "Materialgroup1",
      "display": false
    },
    {
      "fieldName": "Materialgroup2",
      "display": false
    },
    {
      "fieldName": "CostInDocCurrency",
      "display": false
    }
  ]
}
