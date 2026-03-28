{
    "$schema": "../../../schema/staticresources/ensxtx_SR_enosixDocumentSearchAppSettings_schema.json",
    "DocType": "Invoice",
    "HeaderTitle": "SAP Invoices",
    "HeaderIcon": "custom:custom41",
    "DisplayHeader": false,
    "AutoSearch": true,
    "DisplaySearchButton": false,
    "SearchButtonLabel": "Search",
    "DocTypes": [],
    "SearchParams": {
        "Display": false,
        "Columns": 2,
        "SoldToFieldName": "SoldToParty",
        "Fields": [
            {
                "Name": "SoldToParty",
                "Label": "Sold To",
                "Display": false,
                "InputType": "text",
                "DefaultValue": ""
            }
        ]
    },
    "SortFields": [
        {
            "precedence": 1,
            "sortField": "ERDAT",
            "direction": "Descending"
        }
    ],
    "SearchResultTitle": "SAP Invoices",
    "SearchResultIcon": "custom:custom41",
    "DisplaySearchResultHeader": true,
    "DetailFlowName": "ensxtx_SAP_Sales_Document_Details_LWC",
    "DisplayRefreshButton": true,
    "DetailLinkText": "Invoice Details",
    "SearchResults": {
        "CurrencyPath": "SalesDocumentCurrency",
        "Columns": [
            {
                "Display": true,
                "Path": "BillingDocument",
                "Label": "",
                "Type": "detailLink"
            },
            {
                "Display": true,
                "Path": "BillingDocument",
                "Label": "Invoice Number",
                "Type": "string"
            },
            {
                "Display": true,
                "Join": {
                    "Fields": [
                        "BillingType",
                        "BillingTypeDescription"
                    ],
                    "Separator": " - "
                },
                "Label": "Billing Type",
                "Type": "string"
            },
            {
                "Display": true,
                "Path": "CompanyCodeName",
                "Label": "Company Code",
                "Type": "string"
            },
            {
                "Display": true,
                "Join": {
                    "Fields": [
                        "SalesOrganization",
                        "SalesOrgDescription"
                    ],
                    "Separator": " - "
                },
                "Label": "Sales Org",
                "Type": "string"
            },
            {
                "Display": true,
                "Path": "BillingDate",
                "Label": "Billing Date",
                "Type": "date"
            },
            {
                "Display": true,
                "Path": "ShipDate",
                "Label": "Ship Date",
                "Type": "date"
            },
            {
                "Display": true,
                "Path": "SalesOrderNumber",
                "Label": "Sales Order Number",
                "Type": "string"
            },
            {
                "Display": false,
                "Path": "Payer",
                "Label": "Payer",
                "Type": "string"
            },
            {
                "Display": true,
                "Path": "PayerName",
                "Label": "Payer Name",
                "Type": "string"
            },
            {
                "Display": false,
                "Path": "SoldToParty",
                "Label": "Sold-To",
                "Type": "string"
            },
            {
                "Display": true,
                "Path": "SoldToName",
                "Label": "Sold-To Name",
                "Type": "string"
            },
            {
                "Display": false,
                "Path": "ShipToParty",
                "Label": "Ship-To",
                "Type": "string"
            },
            {
                "Display": true,
                "Path": "ShipToName",
                "Label": "Ship-To Name",
                "Type": "string"
            },
            {
                "Display": true,
                "Path": "TrackingNumber",
                "Label": "Tracking Number",
                "Type": "string"
            },
            {
                "Display": true,
                "Path": "NetOrderValue",
                "Label": "Net Order Value",
                "Type": "currency"
            },
            {
                "Display": true,
                "Path": "TaxAmount",
                "Label": "Tax",
                "Type": "currency"
            },
            {
                "Display": true,
                "Path": "GrossAmount",
                "Label": "Gross Amount",
                "Type": "currency"
            },
            {
                "Display": true,
                "Path": "CreatedBy",
                "Label": "Created By",
                "Type": "string"
            },
            {
                "Display": true,
                "Path": "CreateDate",
                "Label": "Created Date",
                "Type": "date"
            },
            {
                "Display": true,
                "Path": "BillingStatusDescription",
                "Label": "Billing Status",
                "Type": "string"
            }
        ]
    }
}