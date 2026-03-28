{
    "$schema": "../../../schema/staticresources/ensxtx_SR_enosixDocumentSearchAppSettings_schema.json",
    "DocType": "Invoice",
    "HeaderTitle": "Advanced Invoice Search",
    "HeaderIcon": "custom:custom41",
    "DisplayHeader": true,
    "AutoSearch": false,
    "DisplaySearchButton": true,
    "SearchButtonLabel": "Search",
    "DocTypes": [],
    "SearchParams": {
        "Display": true,
        "Columns": 2,
        "SoldToFieldName": "SoldToParty",
        "Fields": [
            {
                "Name": "FromSalesDocumentNumber",
                "Label": "From Document Number",
                "Display": true,
                "InputType": "text"
            },
            {
                "Name": "ToSalesDocumentNumber",
                "Label": "To Document Number",
                "Display": true,
                "InputType": "text"
            },
            {
                "Name": "SalesOrganization",
                "Label": "Sales Organization",
                "Display": true,
                "InputType": "text"
            },
            {
                "Name": "SoldToParty",
                "Label": "Sold To",
                "Display": true,
                "InputType": "text"
            },
            {
                "Name": "Payer",
                "Label": "Payer",
                "Display": true,
                "InputType": "text"
            },
            {
                "Name": "CreatedBy",
                "Label": "Created By",
                "Display": true,
                "InputType": "text"
            },
            {
                "Name": "BillingDateFrom",
                "Label": "Billing Date From",
                "Display": true,
                "InputType": "date"
            },
            {
                "Name": "BillingDateTo",
                "Label": "Billing Date To",
                "Display": true,
                "InputType": "date"
            },
            {
                "Name": "FromCreateDate",
                "Label": "From Created Date",
                "Display": true,
                "InputType": "date"
            },
            {
                "Name": "ToCreateDate",
                "Label": "To Created Date",
                "Display": true,
                "InputType": "date"
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
    "SearchResultTitle": "SAP Invoice Results",
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