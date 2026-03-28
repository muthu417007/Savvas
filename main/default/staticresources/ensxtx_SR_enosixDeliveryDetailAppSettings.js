{
    "$schema": "ensxtx_SR_enosixDocumentDetailAppSettings_schema.json",
    "DocumentType": "Delivery",
    "CurrencyPath": "SalesDocumentCurrency",
    "ItemDetailLinkText": "Delivery Item Details",
    "Header": {
        "Type": "Detail",
        "Title": "Delivery Detail",
        "Icon": "custom:custom98",
        "Fields": [
            {
                "Name": "Delivery Number",
                "Display": true,
                "Path": "Delivery",
                "Type": "string"
            },
            {
                "Name": "Shipping Point",
                "Display": true,
                "Path": "ShippingPoint",
                "Type": "string"
            },
            {
                "Name": "Shipping Conditions",
                "Display": true,
                "Join": {
                    "Fields": [
                        "ShippingConditions",
                        "ShipConditionText"
                    ],
                    "Separator": " - "
                },
                "Type": "string"
            },
            {
                "Name": "Delivery Block",
                "Display": true,
                "Path": "DeliveryBlock",
                "Type": "string"
            },
            {
                "Name": "Create Date",
                "Display": true,
                "Path": "CreateDate",
                "Type": "date"
            },
            {
                "Name": "Sold-To",
                "Display": true,
                "Path": "SoldToParty",
                "Type": "string"
            },
            {
                "Name": "Sold-To Name",
                "Display": true,
                "Path": "SoldToPartyText",
                "Type": "string"
            },
            {
                "Name": "Tracking Number",
                "Display": true,
                "Path": "TrackingNumber",
                "Type": "string"
            },
            {
                "Name": "Route",
                "Display": true,
                "Path": "Route",
                "Type": "string"
            },
            {
                "Name": "Delivery Priority",
                "Display": true,
                "Path": "DeliveryPriority",
                "Type": "string"
            },
            {
                "Name": "Delivery Status",
                "Display": true,
                "Path": "DeliveryStatus",
                "Type": "string"
            },
            {
                "Name": "Delivery Date",
                "Display": true,
                "Path": "DeliveryDate",
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
                "Path": "ShipToPartyText",
                "Type": "string"
            },
            {
                "Name": "PGI Date",
                "Display": true,
                "Path": "PGIDate",
                "Type": "date"
            }
        ]
    },
    "Items": {
        "Type": "List",
        "Title": "Delivery Items",
        "Root": "ITEMS.asList",
        "Icon": "custom:custom98",
        "Fields": [
            {
                "Name": "",
                "Display": true,
                "Path": "DeliveryItem",
                "Type": "itemDetailLink"
            },
            {
                "Name": "Delivery Item",
                "Display": true,
                "Path": "DeliveryItem",
                "Type": "string"
            },
            {
                "Name": "Material",
                "Display": true,
                "Path": "Material",
                "Type": "string"
            },
            {
                "Name": "Material Desc",
                "Display": true,
                "Path": "ItemDescription",
                "Type": "string"
            },
            {
                "Name": "Delivery Qty",
                "Display": true,
                "Path": "DeliveryQuantity",
                "Type": "string"
            },
            {
                "Name": "Quantity UOM",
                "Display": true,
                "Path": "SalesUnit",
                "Type": "string"
            },
            {
                "Name": "Plant",
                "Display": true,
                "Path": "Plant",
                "Type": "string"
            },
            {
                "Name": "Price Per",
                "Display": true,
                "Path": "ConditionPricingUnit",
                "Type": "currency"
            },
            {
                "Name": "Total",
                "Display": true,
                "Path": "NetItemPrice",
                "Type": "currency"
            },
            {
                "Name": "Sales Order",
                "Display": true,
                "Path": "SalesOrder",
                "Type": "string"
            },
            {
                "Name": "Item Cat",
                "Display": true,
                "Join": {
                    "Fields": [
                        "ItemCategory",
                        "ItemCategoryDescription"
                    ],
                    "Separator": " - "
                },
                "Type": "string"
            }
        ]
    },
    "ItemDetail": {
        "Title": "Delivery Item Details",
        "Type": "Detail",
        "Breakpoint": 5,
        "Icon": "custom:custom98",
        "Root": "ITEMS.asList",
        "FindBy": "DeliveryNumber",
        "Fields": [
            {
                "Name": "Delivery Item",
                "Display": true,
                "Path": "DeliveryItem",
                "Type": "string"
            },
            {
                "Name": "Customer PO",
                "Display": true,
                "Path": "CustomerPurchaseOrderNumber",
                "Type": "string"
            },
            {
                "Name": "Net Weight",
                "Display": true,
                "Join": {
                    "Fields": [
                        "Netweight",
                        "WeightUnit"
                    ],
                    "Separator": " "
                },
                "Type": "string"
            },
            {
                "Name": "Loading Group",
                "Display": true,
                "Path": "LoadingGroup",
                "Type": "string"
            },
            {
                "Name": "Distribution Channel",
                "Display": true,
                "Join": {
                    "Fields": [
                        "DistributionChannel",
                        "DistributionChannelName"
                    ],
                    "Separator": " - "
                },
                "Type": "string"
            },
            {
                "Name": "Plant Name",
                "Display": true,
                "Path": "PlantName",
                "Type": "string"
            },
            {
                "Name": "Gross Weight",
                "Display": true,
                "Join": {
                    "Fields": [
                        "GrossWeight",
                        "WeightUnit"
                    ],
                    "Separator": " "
                },
                "Type": "string"
            },
            {
                "Name": "Transportation Group",
                "Display": true,
                "Path": "TransportationGroup",
                "Type": "string"
            },
            {
                "Name": "Picking Status",
                "Display": true,
                "Path": "PickingStatus",
                "Type": "string"
            }
        ]
    }
}