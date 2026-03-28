{
    "$schema": "../../sales-doc/staticresources/ensxtx_SR_SalesDocAppSettings_schema.json",
    "SalesDoc": {
        "DefaultOrder": {
            "itemNumberIncrement": 10,
            "bomItemNumberIncrement": 1,
            "sortOrderIncrement": 10,
            "lineItemsBatchForAsync": 0,
            "autoSimulate": {
                "afterPartnerSelection": false,
                "afterItemAdd": false,
                "afterItemEditSave": false,
                "afterItemDelete": false,
                "afterItemClone": false,
                "afterItemConfiguration": false,
                "afterFieldUpdate": false,
                "afterSortItems": false
            },
            "showHeaderIncompletionLogs": false,
            "showItemIncompletionLogs": false,
            "incompletionLogsAsErrors": false,
            "enableBoMCountCommand": false,
            "enableBoMItemEdit": false,
            "updateLineItems": true,
            "deleteLineItems": false,
            "mapUpdateFromSObject": false,
            "useConvertToObjectTrigger": false,
            "enableConfiguration": false,
            "SAPDocType": "Order",
            "SBODetailType": "SalesDocument",
            "DefaultDocType": "YORD",
            "DefaultDocTypeInternal": "YORD",
            "DefaultSalesOrganization": "0002",
            "DefaultDistributionChannel": "02",
            "DefaultDivision": "99",
            "sfInvokeFrom": "Commerce",
            "DocTypes": [],
            "salesAreasFromCustomer": true,
            "SalesAreas": [
            ],
            "optionValuesToInclude": {
                "Header": {
                    "Conditions": []
                },
                "Item": {
                    "Conditions":[]
                }
            },
            "Header": {
                "PartnerPickers": [
                    {
                        "PartnerFunction": "SP",
                        "PartnerFunctionInternal": "AG",
                        "PartnerFunctionName": "SoldTo",
                        "CustomLabel_PartnerFunctionName": "ensxtx_SalesDocPartners_Description_SoldTo",
                        "ComponentType": "CustomerSearch",
                        "SearchType": "Partner",
                        "autoSearch": false,
                        "allowSearch": false,
                        "allowAddressOverride": false,
                        "autoPopulateAddressOverrideFromCustomer": false
                    },
                    {
                        "PartnerFunction": "SH",
                        "PartnerFunctionInternal": "WE",
                        "PartnerFunctionName": "ShipTo",
                        "CustomLabel_PartnerFunctionName": "ensxtx_SalesDocPartners_Description_ShipTo",
                        "ComponentType": "PartnerSearch",
                        "SearchType": "Partner",
                        "autoSearch": false,
                        "allowSearch": false,
                        "allowAddressOverride": false,
                        "autoPopulateAddressOverrideFromCustomer": false
                    },
                    {
                        "PartnerFunction": "BP",
                        "PartnerFunctionInternal": "RE",
                        "PartnerFunctionName": "BillTo",
                        "CustomLabel_PartnerFunctionName": "ensxtx_SalesDocPartners_Description_BillTo",
                        "ComponentType": "PartnerSearch",
                        "SearchType": "Partner",
                        "autoSearch": false,
                        "allowSearch": false,
                        "allowAddressOverride": false,
                        "autoPopulateAddressOverrideFromCustomer": false
                    },
                    {
                        "PartnerFunction": "ZA",
                        "PartnerFunctionInternal": "ZA",
                        "PartnerFunctionName": "Carrier",
                        "CustomLabel_PartnerFunctionName": "ensxtx_SalesDocPartners_Description_Carrier",
                        "ComponentType": "PartnerSearch",
                        "SearchType": "Partner",
                        "autoSearch": false,
                        "allowSearch": false,
                        "allowAddressOverride": false,
                        "autoPopulateAddressOverrideFromCustomer": false
                    }
                ],
                "Texts":[
                    {
                        "Id": "0001",
                        "Description": "Attention (Shipping):",
                        "Required": false
                      },                     
                      {
                        "Id": "0003",
                        "Description": "Attention (Billing):",
                        "Required": false
                      },
                      {
                        "Id": "0005",
                        "Description": "Shipping Instructions:",
                        "Required": false
                      },
                      {
                        "Id": "0009",
                        "Description": "Customer Service Comments:",
                        "Required": false
                      },
                      {
                        "Id": "0015",
                        "Description": "Special EDI Instructions:",
                        "Required": false
                      },
                      {
                        "Id": "0020",
                        "Description": "Converted Instructions:",
                        "Required": false
                      },
                      {
                        "Id": "0007",
                        "Description": "Warehouse Text:",
                        "Required": false
                      }
                ]
            },
            "Item": {
                "PartnerPickers": [],
                "Texts":[]
            },
            "Default": {
                "autoInvoke": false,
                "displaySimulate": false,
                "displaySort": false,
                "displaySaveToSOject": false,
                "displaySaveToSAP": false,
                "AddMaterial": {"display": false, "edit": false },
                "Tabs": {
                    "Header": {},
                    "Item": {}
                },
                "Fields": {
                    "Header": {},
                    "ItemTable": {},
                    "ItemEdit": {}
                }
            },
            "InvokeMethodAppSettings": [
                {
                    "InvokeMethod": "Simulate",
                    "insertSalesDocLog": false,
                    "skipAddedLineValidation": true
                },
                {
                    "InvokeMethod": "Create",
                    "insertSalesDocLog": true,
                    "skipAddedLineValidation": true
                }
            ]
        }
    }
}