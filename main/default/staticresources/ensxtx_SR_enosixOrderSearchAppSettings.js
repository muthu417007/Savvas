{
    "$schema": "../../../schema/staticresources/ensxtx_SR_enosixDocumentSearchAppSettings_schema.json",
    "DocType": "SalesDoc",
    "HeaderTitle": "SAP Orders",
    "HeaderIcon": "custom:custom18",
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
            },
            {
                "Name": "TransactionGroup",
                "Label": "Transaction Group",
                "Display": false,
                "InputType": "text",
                "DefaultValue": "0"
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
    "SearchResultTitle": "SAP Orders",
    "SearchResultIcon": "custom:custom18",
    "DisplaySearchResultHeader": true,
    "DetailFlowName": "ensxtx_SAP_Sales_Document_Details_LWC",
    "DisplayRefreshButton": true,
    "DetailLinkText": "Sales Document Details",
    "SearchResults": {
        "CurrencyPath": "SDDocumentCurrency",
        "Columns": [
            {
                "Display": true,
                "Path": "SalesDocument",
                "Label": "",
                "Type": "detailLink"
            },
            {
                "Display": true,
                "Path": "SalesDocument",
                "Label": "Sales Document",
                "Type": "string"
            },
            {
                "Display": true,
                "Path": "CustomerPONumber",
                "Label": "PO Number",
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
                "Join": {
                    "Fields": [
                        "SalesDocumentType",
                        "SalesDocumentTypeDescription"
                    ],
                    "Separator": " - "
                },
                "Label": "Document Type",
                "Type": "string"
            },
            {
                "Display": true,
                "Path": "SoldToName",
                "Label": "Sold-To Name",
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
                "Path": "NetValueInDocumentCurrency",
                "Label": "Net Value",
                "Type": "currency"
            },
            {
                "Display": true,
                "Path": "TaxAmountInDocumentCurrency",
                "Label": "Tax Amount",
                "Type": "currency"
            },
            {
                "Display": true,
                "Path": "OrderStatus",
                "Label": "Order Status",
                "Type": "string"
            }
        ]
    }
}