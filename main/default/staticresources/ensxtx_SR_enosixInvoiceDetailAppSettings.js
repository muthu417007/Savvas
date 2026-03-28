{
    "$schema": "ensxtx_SR_enosixDocumentDetailAppSettings_schema.json",
    "DocumentType": "Invoice",
    "CurrencyPath": "SalesDocumentCurrency",
    "ItemDetailLinkText": "Invoice Item Details",
    "Header": {
        "Type": "Detail",
        "Title": "Invoice Detail",
        "Icon": "custom:custom41",
        "Fields": [
            {
                "Name": "Invoice Type",
                "Display": true,
                "Path": "BillingType",
                "Type": "string"
            },
            {
                "Name": "Invoice Number",
                "Display": true,
                "Path": "BillingDocument",
                "Type": "string"
            },
            {
                "Name": "Sold-To",
                "Display": true,
                "Path": "Payer",
                "Type": "string"
            },
            {
                "Name": "Name",
                "Display": true,
                "Path": "PayerName",
                "Type": "string"
            },
            {
                "Name": "Sales Order",
                "Display": true,
                "Path": "SalesOrderNumber",
                "Type": "string"
            },
            {
                "Name": "Ship Date",
                "Display": true,
                "Path": "ShipDate",
                "Type": "date"
            },
            {
                "Name": "Net Value",
                "Display": true,
                "Path": "NetOrderValue",
                "Type": "currency"
            },
            {
                "Name": "Create Date",
                "Display": true,
                "Path": "CreateDate",
                "Type": "date"
            },
            {
                "Name": "Ship-To",
                "Display": true,
                "Path": "ShipToParty",
                "Type": "string"
            },
            {
                "Name": "Ship-To Name",
                "Display": true,
                "Path": "ShipToName",
                "Type": "string"
            },
            {
                "Name": "Tracking",
                "Display": true,
                "Path": "TrackingNumber",
                "Type": "string"
            },
            {
                "Name": "Net Taxes",
                "Display": true,
                "Path": "TaxAmount",
                "Type": "currency"
            },
            {
                "Name": "Gross Amount",
                "Display": true,
                "Path": "GrossAmount",
                "Type": "currency"
            }
        ]
    },
    "Items": {
        "Type": "List",
        "Title": "Invoice Items",
        "Icon": "custom:custom41",
        "Root": "ITEMS.asList",
        "Fields": [
            {
                "Name": "",
                "Display": true,
                "Path": "ItemNumber",
                "Type": "itemDetailLink"
            },
            {
                "Name": "Billing Item",
                "Display": true,
                "Path": "ItemNumber",
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
                "Name": "Sales Unit",
                "Display": true,
                "Path": "SalesUnit",
                "Type": "string"
            },
            {
                "Name": "Quantity",
                "Display": true,
                "Join": {
                    "Fields": [
                        "ActualInvoicedQuantity",
                        "SalesUnit"
                    ],
                    "Separator": " "
                },
                "Type": "string"
            },
            {
                "Name": "Net Value",
                "Display": true,
                "Path": "NetOrderValue",
                "Type": "currency"
            },
            {
                "Name": "Net Taxes",
                "Display": true,
                "Path": "TaxAmount",
                "Type": "currency"
            },
            {
                "Name": "Shipping Warehouse",
                "Display": true,
                "Path": "Plant",
                "Type": "string"
            }
        ]
    },
    "ItemDetail": {
        "Type": "Detail",
        "Breakpoint": 4,
        "Title": "Invoice Item Details",
        "Icon": "custom:custom41",
        "Root": "ITEMS.asList",
        "FindBy": "ItemNumber",
        "Fields": [
            {
                "Name": "Billing Item",
                "Display": true,
                "Path": "ItemNumber",
                "Type": "string"
            },
            {
                "Name": "Material",
                "Display": true,
                "Path": "Material",
                "Type": "string"
            },
            {
                "Name": "Quantity",
                "Display": true,
                "Join": {
                    "Fields": [
                        "ActualInvoicedQuantity",
                        "SalesUnit"
                    ],
                    "Separator": " "
                },
                "Type": "string"
            },
            {
                "Name": "Net Value",
                "Display": true,
                "Path": "NetOrderValue",
                "Type": "currency"
            },
            {
                "Name": "Material Description",
                "Display": true,
                "Path": "ItemDescription",
                "Type": "string"
            },
            {
                "Name": "Sales Unit",
                "Display": true,
                "Path": "SalesUnit",
                "Type": "string"
            },
            {
                "Name": "Net Taxes",
                "Display": true,
                "Path": "TaxAmount",
                "Type": "currency"
            }
        ]
    },
    "ItemConditions": {
        "Type": "List",
        "Title": "Item Conditions",
        "Icon": "custom:custom41",
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
                "Path": "ConditionTypeName",
                "Type": "string"
            },
            {
                "Name": "Rate",
                "Display": true,
                "PriceOverUnit": {
                    "Amount": "Rate",
                    "Currency": "RateUnit",
                    "Quantity": "ConditionPricingUnit",
                    "Unit": "ConditionUnit"
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