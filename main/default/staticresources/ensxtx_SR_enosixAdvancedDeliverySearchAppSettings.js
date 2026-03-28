{
    "$schema": "../../../schema/staticresources/ensxtx_SR_enosixDocumentSearchAppSettings_schema.json",
    "DocType": "Delivery",
    "HeaderTitle": "Advanced Delivery Search",
    "HeaderIcon": "custom:custom98",
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
                "Name": "Route",
                "Label": "Route",
                "Display": true,
                "InputType": "text"
            },
            {
                "Name": "MeansOfTransportID",
                "Label": "Means of Transport",
                "Display": true,
                "InputType": "text"
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
            },
            {
                "Name": "DeliveryDateFrom",
                "Label": "Delivery Date From",
                "Display": true,
                "InputType": "date"
            },
            {
                "Name": "DeliveryDateTo",
                "Label": "Delivery Date To",
                "Display": true,
                "InputType": "date"
            },
            {
                "Name": "DeliveryFrom",
                "Label": "Delivery From",
                "Display": true,
                "InputType": "text"
            },
            {
                "Name": "DeliveryTo",
                "Label": "Delivery To",
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
                "Name": "ShippingPoint",
                "Label": "Shipping Point",
                "Display": true,
                "InputType": "text"
            },
            {
                "Name": "ShippingConditions",
                "Label": "Shipping Conditions",
                "Display": true,
                "InputType": "text"
            },
            {
                "Name": "DeliveryPriority",
                "Label": "Delivery Priority",
                "Display": true,
                "InputType": "text"
            },
            {
                "Name": "BillofLading",
                "Label": "Bill of Lading",
                "Display": true,
                "InputType": "text"
            },
            {
                "Name": "PGIDateFrom",
                "Label": "PGI Date From",
                "Display": true,
                "InputType": "date"
            },
            {
                "Name": "PGIDateTo",
                "Label": "PGI Date To",
                "Display": true,
                "InputType": "date"
            },
            {
                "Name": "DeliveryStatus",
                "Label": "Delivery Status",
                "Display": true,
                "InputType": "checkbox",
                "AllowedValues": [
                    {
                        "Value": "X_Open",
                        "Label": "Open"
                    },
                    {
                        "Value": "X_Picked",
                        "Label": "Picked"
                    },
                    {
                        "Value": "X_Packed",
                        "Label": "Packed"
                    },
                    {
                        "Value": "X_PGIed",
                        "Label": "PGIed"
                    }
                ]
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
    "SearchResultTitle": "SAP Delivery Results",
    "SearchResultIcon": "custom:custom98",
    "DisplaySearchResultHeader": true,
    "DetailFlowName": "ensxtx_SAP_Sales_Document_Details_LWC",
    "DisplayRefreshButton": true,
    "DetailLinkText": "Delivery Details",
    "SearchResults": {
        "CurrencyPath": "SalesDocumentCurrency",
        "Columns": [
            {
                "Display": true,
                "Path": "Delivery",
                "Label": "",
                "Type": "detailLink"
            },
            {
                "Display": true,
                "Path": "Delivery",
                "Label": "Delivery Number",
                "Type": "string"
            },
            {
                "Display": true,
                "Path": "Route",
                "Label": "Route",
                "Type": "string"
            },
            {
                "Display": false,
                "Path": "MeansOfTransportID",
                "Label": "Means of Transport",
                "Type": "string"
            },
            {
                "Display": false,
                "Path": "BillofLading",
                "Label": "Bill of Lading",
                "Type": "string"
            },
            {
                "Display": false,
                "Path": "CreateDate",
                "Label": "Created Date",
                "Type": "date"
            },
            {
                "Display": true,
                "Path": "DeliveryDate",
                "Label": "Delivery Date",
                "Type": "date"
            },
            {
                "Display": false,
                "Path": "PGIDate",
                "Label": "PGI Date",
                "Type": "date"
            },
            {
                "Display": true,
                "Join": {
                    "Fields": [
                        "DeliveryType",
                        "DeliveryTypeText"
                    ],
                    "Separator": " - "
                },
                "Label": "Delivery Type",
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
                "Path": "SoldToCity",
                "Label": "Sold-To City",
                "Type": "string"
            },
            {
                "Display": false,
                "Path": "SoldToRegionDescription",
                "Label": "Sold-To Region",
                "Type": "string"
            },
            {
                "Display": false,
                "Path": "SoldToCountryDescription",
                "Label": "Sold-To Country",
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
                "Display": false,
                "Path": "ShipToCity",
                "Label": "Ship-To City",
                "Type": "string"
            },
            {
                "Display": false,
                "Path": "ShipToRegionDescription",
                "Label": "Ship-To Region",
                "Type": "string"
            },
            {
                "Display": false,
                "Path": "ShipToCountryDescription",
                "Label": "Ship-To Country",
                "Type": "string"
            },
            {
                "Display": false,
                "Path": "ShippingPoint",
                "Label": "Shipping Point",
                "Type": "string"
            },
            {
                "Display": false,
                "Path": "ShippingConditions",
                "Label": "Shipping Conditions",
                "Type": "string"
            },
            {
                "Display": false,
                "Path": "DeliveryPriority",
                "Label": "Shipping Conditions",
                "Type": "string"
            },
            {
                "Display": false,
                "Path": "NetOrderValue",
                "Label": "Net Value",
                "Type": "currency"
            },
            {
                "Display": true,
                "Path": "DeliveryStatus",
                "Label": "Delivery Status",
                "Type": "string"
            }
        ]
    }
}