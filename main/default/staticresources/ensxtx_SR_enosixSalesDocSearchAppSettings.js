{
    "$schema": "../../../schema/staticresources/ensxtx_SR_enosixDocumentSearchAppSettings_schema.json",
    "DocType": "SalesDoc",
    "HeaderTitle": "Advanced Sales Document Search",
    "HeaderIcon": "custom:custom18",
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
                "Name": "SoldToParty",
                "Label": "Sold To",
                "Display": true,
                "InputType": "text"
            },
            {
                "Name": "ShipToParty",
                "Label": "Ship To",
                "Display": true,
                "InputType": "text"
            },
            {
                "Name": "CustomerPONumber",
                "Label": "PO Number",
                "Display": true,
                "InputType": "text"
            },
            {
                "Name": "Material",
                "Label": "Material Number",
                "Display": true,
                "InputType": "text"
            },
            {
                "Name": "TransactionGroup",
                "Label": "Transaction Group",
                "Display": true,
                "InputType": "picklist",
                "AllowedValues": [
                    {
                        "Value": "",
                        "Label": "---"
                    },
                    {
                        "Value": "0",
                        "Label": "Sales Order"
                    },
                    {
                        "Value": "1",
                        "Label": "Inquiry"
                    },
                    {
                        "Value": "2",
                        "Label": "Quotation"
                    },
                    {
                        "Value": "3",
                        "Label": "Scheduling Agreement"
                    },
                    {
                        "Value": "4",
                        "Label": "Contract"
                    },
                    {
                        "Value": "5",
                        "Label": "Item Proposal"
                    },
                    {
                        "Value": "B",
                        "Label": "Customer Independent Requirements"
                    }
                ]
            },
            {
                "Name": "DocumentStatus",
                "Label": "Document Status",
                "Display": true,
                "InputType": "checkbox",
                "AllowedValues": [
                    {
                        "Value": "OpenOnly",
                        "Label": "Open"
                    },
                    {
                        "Value": "CompletedOnly",
                        "Label": "Completed"
                    },
                    {
                        "Value": "X_DeliveryBlock",
                        "Label": "Delivery Block"
                    },
                    {
                        "Value": "X_BillingBlock",
                        "Label": "Billing Block"
                    },
                    {
                        "Value": "X_CreditBlock",
                        "Label": "Credit Block"
                    }
                ]
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
    "SearchResultTitle": "SAP Sales Document Results",
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