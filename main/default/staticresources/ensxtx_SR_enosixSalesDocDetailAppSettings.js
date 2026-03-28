{
    "$schema": "ensxtx_SR_enosixDocumentDetailAppSettings_schema.json",
    "DocumentType": "Sales",
    "CurrencyPath": "SALES.SDDocumentCurrency",
    "ItemDetailLinkText": "Sales Document Item Details",
    "Header": {
        "Type": "Detail",
        "Title": "Sales Document Details",
        "Icon": "custom:custom18",
        "Breakpoint": 7,
        "Fields": [
            {
                "Path": "SalesDocument",
                "Name": "Document Number",
                "Display": true,
                "Type": "string"
            },
            {
                "Path": "SALES.RequestedDeliveryDate",
                "Name": "Requested Delivery Date",
                "Display": true,
                "Type": "date"
            },
            {
                "Join": {
                    "Fields": [
                        "SALES.BillingBlock",
                        "SALES.BillingBlockDescription"
                    ],
                    "Separator": " - "
                },
                "Name": "Billing Blocked",
                "Display": true,
                "Type": "string"
            },
            {
                "Join": {
                    "Fields": [
                        "SALES.DeliveryBlock",
                        "SALES.DeliveryBlockDescription"
                    ],
                    "Separator": " - "
                },
                "Name": "Delivery Blocked",
                "Display": true,
                "Type": "string"
            },
            {
                "Path": "NetValueInDocumentCurrency",
                "Name": "Net Order Value",
                "Display": true,
                "Type": "currency"
            },
            {
                "Path": "TaxAmountInDocumentCurrency",
                "Name": "Tax",
                "Display": true,
                "Type": "currency"
            },
            {
                "Add": [
                    "NetValueInDocumentCurrency",
                    "TaxAmountInDocumentCurrency"
                ],
                "Name": "Gross Price",
                "Display": true,
                "Type": "currency"
            },
            {
                "Path": "SALES.SalesDocumentTypeDescription",
                "Name": "Order Type",
                "Display": true,
                "Type": "string"
            },
            {
                "Path": "SALES.GoodsIssueDate",
                "Name": "Goods Issue Date",
                "Display": true,
                "Type": "date"
            },
            {
                "Path": "SALES.BillingBlockDescription",
                "Name": "Billing Blocked Description",
                "Display": true,
                "Type": "string"
            },
            {
                "Path": "SALES.DeliveryBlockDescription",
                "Name": "Delivery Blocked Description",
                "Display": true,
                "Type": "string"
            },
            {
                "Path": "CustomerPurchaseOrderNumber",
                "Name": "Customer PO Number",
                "Display": true,
                "Type": "string"
            },
            {
                "Path": "CustomerPurchaseOrderDate",
                "Name": "PO Date",
                "Display": true,
                "Type": "date"
            },
            {
                "Path": "SALES.CreateDate",
                "Name": "Create Date",
                "Display": true,
                "Type": "date"
            }
        ]
    },
    "Status": {
        "Type": "Detail",
        "Title": "Sales Document Status",
        "Icon": "custom:custom18",
        "Fields": [
            {
                "Path": "STATUS.OverallStatusDescription",
                "Name": "Overall Status",
                "Display": true,
                "Type": "string"
            },
            {
                "Path": "STATUS.RejectionStatusDescription",
                "Name": "Rejection Status",
                "Display": true,
                "Type": "string"
            },
            {
                "Path": "STATUS.CreditStatusDescription",
                "Name": "Credit Hold Status",
                "Display": true,
                "Type": "string"
            },
            {
                "Path": "STATUS.DataCompleteDescription",
                "Name": "Data Complete Status",
                "Display": true,
                "Type": "string"
            },
            {
                "Join": {
                    "Fields": [
                        "SHIPPING.ShippingConditions",
                        "SHIPPING.ShippingConditionsDescription"
                    ],
                    "Separator": " - "
                },
                "Name": "Shipping Condition",
                "Display": true,
                "Type": "string"
            }
        ]
    },
    "Partners": {
        "Type": "List",
        "Title": "Sales Document Partners",
        "Icon": "custom:custom18",
        "Root": "PARTNERS.asList",
        "Whitelist":{
            "Key":"PartnerFunction",
            "Values":["SP", "BP", "SH", "PY"]
        },
        "Fields": [
            {
                "Name": "Function",
                "Display": true,
                "Path": "PartnerFunctionName",
                "Type": "string"
            },
            {
                "Name": "Partner",
                "Display": true,
                "Mapper": {
                    "FieldName": "PartnerFunction",
                    "MappingValueAndFields": [
                        {
                            "Value": "SP",
                            "FieldToMap": "PartnerNumber"
                        },
                        {
                            "Value": "CP",
                            "FieldToMap": "PartnerNumber"
                        },
                        {
                            "Value": "BP",
                            "FieldToMap": "PartnerNumber"
                        },
                        {
                            "Value": "PY",
                            "FieldToMap": "PartnerNumber"
                        },
                        {
                            "Value": "FA",
                            "FieldToMap": "PartnerNumber"
                        },
                        {
                            "Value": "SH",
                            "FieldToMap": "PartnerNumber"
                        },
                        {
                            "Value": "Y1",
                            "FieldToMap": "PartnerNumber"
                        },
                        {
                            "Value": "SE",
                            "FieldToMap": "PartnerNumber"
                        }
                    ]
                },
                "Type": "string"
            },
            {
                "Name": "Name",
                "Display": true,
                "Join": {
                    "Fields": [
                        "PartnerName",
                        "PartnerName2"
                    ],
                    "Separator": " "
                },
                "Type": "string"
            },
            {
                "Name": "Street",
                "Display": true,
                "Path": "Street",
                "Type": "string"
            },
            {
                "Name": "City",
                "Display": true,
                "Path": "City",
                "Type": "string"
            },
            {
                "Name": "Region",
                "Display": true,
                "Path": "RegionDescription",
                "Type": "string"
            },
            {
                "Name": "Postal Code",
                "Display": true,
                "Path": "PostalCode",
                "Type": "string"
            },
            {
                "Name": "Country",
                "Display": true,
                "Path": "CountryName",
                "Type": "string"
            }
        ]
    },
    "Items": {
        "Type": "List",
        "Title": "Sales Document Items",
        "Icon": "custom:custom18",
        "Root": "ITEMS.asList",
        "Fields": [
            {
                "Name": "",
                "Display": true,
                "Path": "SalesItem",
                "Type": "itemDetailLink"
            },
            {
                "Name": "Number",
                "Display": true,
                "Path": "SalesItem",
                "Type": "string"
            },
            {
                "Name": "Material",
                "Display": true,
                "Path": "Material",
                "Type": "string"
            },
            {
                "Name": "Material Description",
                "Display": true,
                "Path": "ItemDescription",
                "Type": "string"
            },
            {
                "Name": "Quantity",
                "Display": true,
                "Join": {
                    "Fields": [
                        "OrderQuantity",
                        "SalesUnitDescription"
                    ],
                    "Separator": " "
                },
                "Type": "string"
            },
            {
                "Name": "Price per",
                "Display": true,
                "PriceOverUnit": {
                    "Amount": "NetItemPrice",
                    "Currency": "SDDocumentCurrency",
                    "Quantity": "ConditionPricingUnit",
                    "Unit": "SalesUnitDescription"
                },
                "Type": "string"
            },
            {
                "Name": "Total",
                "Display": true,
                "Path": "NetValueInDocumentCurrency",
                "Type": "currency"
            },
            {
                "Name": "Tax",
                "Display": true,
                "Path": "ItemTax",
                "Type": "currency"
            },
            {
                "Name": "Gross Price",
                "Display": true,
                "Add": [
                    "NetValueInDocumentCurrency",
                    "ItemTax"
                ],
                "Type": "currency"
            },
            {
                "Name": "Plant",
                "Display": true,
                "Path": "Plant",
                "Type": "string"
            },
            {
                "Name": "Requested Ship Date",
                "Display": true,
                "Path": "ScheduleLineDate",
                "Type": "date"
            },
            {
                "Name": "Category",
                "Display": true,
                "Path": "ItemCategoryDescription",
                "Type": "string"
            },
            {
                "Name": "Billing Block",
                "Display": true,
                "Path": "BillingBlockStatus",
                "Type": "string"
            },
            {
                "Name": "Delivery Block",
                "Display": true,
                "Path": "DeliveryBlockStatus",
                "Type": "string"
            }
        ]
    },
    "Payment": {
        "Type": "List",
        "Title": "Sales Document Payment Cards",
        "Icon": "custom:custom18",
        "Root": "CCARD.asList",
        "Fields": [
            {
                "Name": "Billing Plan",
                "Display": true,
                "Path": "BillingPlanNumber",
                "Type": "string"
            },
            {
                "Name": "Billing Plan Item",
                "Display": true,
                "Path": "ItemForBillingPlan",
                "Type": "string"
            },
            {
                "Name": "Card Type",
                "Display": true,
                "Path": "CardType",
                "Type": "string"
            },
            {
                "Name": "Card Number",
                "Display": true,
                "Path": "CardNumber",
                "Type": "string"
            },
            {
                "Name": "Suffix",
                "Display": true,
                "Path": "PaymentCardSuffix",
                "Type": "string"
            },
            {
                "Name": "Expiration Date",
                "Display": true,
                "Path": "ValidTo",
                "Type": "date"
            },
            {
                "Name": "Cardholder",
                "Display": true,
                "Path": "CardholderName",
                "Type": "string"
            },
            {
                "Name": "Bill Amount",
                "Display": true,
                "Path": "ValueToBeBilledOnTheDateSpecified",
                "Type": "currency"
            },
            {
                "Name": "Authorized Amount",
                "Display": true,
                "Path": "AuthorizedAmount",
                "Type": "currency"
            },
            {
                "Name": "Amount Changed",
                "Display": true,
                "Path": "AmountChanged",
                "Type": "yesno"
            },
            {
                "Name": "Authorization Type",
                "Display": true,
                "Path": "AuthorizationType",
                "Type": "string"
            },
            {
                "Name": "Billing Plan Authorization",
                "Display": true,
                "Path": "HigherLevelAuthorizationForBillingPlan",
                "Type": "string"
            },
            {
                "Name": "Result Code",
                "Display": true,
                "Path": "ResultOfCardCheck",
                "Type": "string"
            },
            {
                "Name": "Result Text",
                "Display": true,
                "Path": "ResultText",
                "Type": "string"
            }
        ]
    },
    "ItemDetail": {
        "Type": "Detail",
        "Title": "Sales Document Item Detail",
        "Icon": "custom:custom18",
        "Root": "ITEMS.asList",
        "FindBy": "SalesItem",
        "Fields": [
            {
                "Name": "Sales Document Item Number",
                "Display": true,
                "Path": "SalesItem",
                "Type": "string"
            },
            {
                "Name": "Material",
                "Display": true,
                "Path": "Material",
                "Type": "string"
            },
            {
                "Name": "Description",
                "Display": true,
                "Path": "ItemDescription",
                "Type": "string"
            },
            {
                "Name": "Quantity",
                "Display": true,
                "Join": {
                    "Fields": [
                        "OrderQuantity",
                        "SalesUnitDescription"
                    ],
                    "Separator": " "
                },
                "Type": "string"
            },
            {
                "Name": "Price Per",
                "Display": true,
                "PriceOverUnit": {
                    "Amount": "NetItemPrice",
                    "Currency": "SDDocumentCurrency",
                    "Quantity": "ConditionPricingUnit",
                    "Unit": "SalesUnitDescription"
                },
                "Type": "string"
            },
            {
                "Name": "Total",
                "Display": true,
                "Path": "NetValueInDocumentCurrency",
                "Type": "currency"
            },
            {
                "Name": "Tax",
                "Display": true,
                "Path": "ItemTax",
                "Type": "currency"
            },
            {
                "Name": "Plant",
                "Display": true,
                "Path": "Plant",
                "Type": "string"
            },
            {
                "Name": "Requested Ship Date",
                "Display": true,
                "Path": "ScheduleLineDate",
                "Type": "date"
            },
            {
                "Name": "Category",
                "Display": true,
                "Path": "ItemCategoryDescription",
                "Type": "string"
            },
            {
                "Name": "Billing Block",
                "Path": "BillingBlock",
                "Display": true,
                "Type": "string"
            },
            {
                "Name": "Delivery Block",
                "Display": true,
                "Path": "DeliveryBlock",
                "Type": "string"
            },
            {
                "Name": "Route",
                "Display": true,
                "Path": "Route",
                "Type": "string"
            }
        ]
    },
    "ItemSchedule": {
        "Type": "List",
        "Title": "Schedule Lines",
        "Icon": "custom:custom18",
        "Root": "ITEMS_SCHEDULE.asList",
        "FilterBy": "SalesItem",
        "Fields": [
            {
                "Name": "Number",
                "Display": true,
                "Path": "ScheduleLineNumber",
                "Type": "string"
            },
            {
                "Name": "Date",
                "Display": true,
                "Path": "ScheduleLineDate",
                "Type": "date"
            },
            {
                "Name": "Ordered Quantity",
                "Display": true,
                "Join": {
                    "Fields": [
                        "OrderQuantity",
                        "SalesUnit"
                    ],
                    "Separator": " "
                },
                "Type": "string"
            },
            {
                "Name": "Confirmed Quantity",
                "Display": true,
                "Join": {
                    "Fields": [
                        "ConfirmedQuantity",
                        "SalesUnit"
                    ],
                    "Separator": " "
                },
                "Type": "string"
            },
            {
                "Name": "Description",
                "Display": true,
                "Path": "ScheduleLineCategoryDescription",
                "Type": "string"
            }
        ]
    },
    "ItemConditions": {
        "Type": "List",
        "Title": "Item Conditions",
        "Icon": "custom:custom18",
        "Root": "CONDITIONS.asList",
        "FilterBy": "ConditionItemNumber",
        "Fields": [
            {
                "Name": "Condition",
                "Display": true,
                "Path": "ConditionType",
                "Type": "string"
            },
            {
                "Name": "Condition Description",
                "Display": true,
                "Path": "Name",
                "Type": "string"
            },
            {
                "Name": "Rate",
                "Display": true,
                "PriceOverUnit": {
                    "Amount": "Rate",
                    "Currency": "RateUnit",
                    "Quantity": "ConditionPricingUnit",
                    "Unit": "Conditionunit"
                },
                "Type": "string"
            },
            {
                "Name": "Condition Total",
                "Display": true,
                "Path": "ConditionValue",
                "Type": "currency"
            }
        ]
    }
}