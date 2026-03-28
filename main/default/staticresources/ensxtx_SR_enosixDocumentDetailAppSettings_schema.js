{
    "$schema": "http://json-schema.org/draft-07/schema",
    "definitions": {
        "Fields": {
            "type": "array",
            "title": "Fields",
            "description": "List of fields",
            "items": {
                "type": "object",
                "properties": {
                    "Path": {
                        "type": "string",
                        "title": "Field Name",
                        "description": "The name of the field, same friendly field name as the RIO"
                    },
                    "Name": {
                        "type": "string",
                        "title": "Label",
                        "description": "The label of the field that will be shown in the UI"
                    },
                    "Display": {
                        "type": "boolean",
                        "title": "Display",
                        "description": "Enable this setting to display the field",
                        "default": true
                    },
                    "Type": {
                        "type": "string",
                        "title": "Field Type",
                        "description": "Specify the field type",
                        "enum": [
                            "string",
                            "date",
                            "currency",
                            "itemDetailLink"
                        ]
                    },
                    "Add": {
                        "type": "array",
                        "title": "Add",
                        "description": "Specify two fields use for addition",
                        "default": [],
                        "items": {
                            "type": "string",
                            "title": "Field Name"
                        }
                    },
                    "Join": {
                        "type": "object",
                        "title": "Join",
                        "description": "For joining multiple fields into one, delimined by the separator.",
                        "properties": {
                            "Fields": {
                                "type": "array",
                                "title": "Fields",
                                "description": "The list of fields.",
                                "items": {
                                    "type": "string"
                                }
                            },
                            "Separator": {
                                "type": "string",
                                "title": "Separator",
                                "description": "The character to separate the fields",
                                "enum": [
                                    " ",
                                    " - ",
                                    ",",
                                    ";",
                                    "/",
                                    ":"
                                ]
                            }
                        }
                    },
                    "Mapper": {
                        "type": "object",
                        "title": "Mapper",
                        "description": "Custom mapping",
                        "properties": {
                            "FieldName": {
                                "type": "string",
                                "title": "Field Name",
                                "description": "Field name of the mapping value"
                            },
                            "MappingValueAndFields": {
                                "type": "array",
                                "title": "Mapping Value and Fields",
                                "description": "List of mapping value and its fields",
                                "items": {
                                    "type": "object",
                                    "properties": {
                                        "Value": {
                                            "type": "string",
                                            "title": "Value",
                                            "description": "The value for the field name"
                                        },
                                        "FieldToMap": {
                                            "type": "string",
                                            "title": "Field to Map",
                                            "description": "The field to map if from when it finds the matching value"
                                        }
                                    }
                                }
                            }
                        }
                    },
                    "PriceOverUnit": {
                        "type": "object",
                        "title": "Price Over Unit",
                        "description": "Price per unit value with currency",
                        "properties": {
                            "Amount": {
                                "type": "string",
                                "title": "Amount Field",
                                "description": "Specify the amount field"
                            },
                            "Currency": {
                                "type": "string",
                                "title": "Currency Field",
                                "description": "Specify the currency field"
                            },
                            "Quantity": {
                                "type": "string",
                                "title": "Quantity Field",
                                "description": "Specify the quantity field"
                            },
                            "Unit": {
                                "type": "string",
                                "title": "Unit Field",
                                "description": "Specify the unit field"
                            }
                        }
                    }
                },
                "required": [
                    "Path",
                    "Name",
                    "Type"
                ]
            }
        },
        "Whitelist": {
            "type": "object",
            "title": "Whitelist",
            "description": "Specify the list of values to whitelist",
            "properties": {
                "Key": {
                    "type": "string",
                    "title": "Key",
                    "description": "Specify the target field name"
                },
                "Values": {
                    "type": "array",
                    "title": "Values",
                    "description": "List of value to whitelist",
                    "items": {
                        "type": "string"
                    }
                }
            },
            "required": [
                "Key",
                "Values"
            ]
        },
        "BaseComponent": {
            "type": "object",
            "properties": {
                "Type": {
                    "type": "string",
                    "title": "Component Type",
                    "description": "The type of the component. List is for a collection and will be shown as a table",
                    "enum": [
                        "Detail",
                        "List"
                    ]
                },
                "Title": {
                    "type": "string",
                    "title": "Title",
                    "description": "The title of the component."
                },
                "Icon": {
                    "type": "string",
                    "title": "Icon",
                    "description": "Specify the icon that will be shown next to the title."
                },
                "Breakpoint": {
                    "type": "integer",
                    "title": "Breakpoint",
                    "description": "The amount of line until it breaks to the next column"
                },
                "Root": {
                    "type": "string",
                    "title": "Root",
                    "description": "Root"
                },
                "FindBy": {
                    "type": "string",
                    "title": "Find By Field",
                    "description": "The key field to match by"
                },
                "FilterBy": {
                    "type": "string",
                    "title": "Filter By Field",
                    "description": "Filter the list by the field name"
                },
                "Whitelist": { "$ref": "#/definitions/Whitelist" },
                "Fields": { "$ref": "#/definitions/Fields" }
            },
            "required": [
                "Type",
                "Title",
                "Icon"
            ]
        }
    },
    "properties": {
        "DocumentType": {
            "type": "string",
            "title": "Document Type",
            "description": "Detail document type",
            "enum": [
                "Sales",
                "Delivery",
                "Invoice"
            ]
        },
        "CurrencyPath": {
            "type": "string",
            "title": "Header Title",
            "description": "The path to the currency field in the RIO class"
        },
        "ItemDetailLinkText": {
            "type": "string",
            "title": "Item Detail Link Label",
            "description": "The label for the item detail link."
        },
        "Header": {
            "title": "Header",
            "description": "Header section",
            "$ref": "#/definitions/BaseComponent"
        },
        "Status": {
            "title": "Status",
            "description": "Status section",
            "$ref": "#/definitions/BaseComponent"
        },
        "Partners": {
            "title": "Partners",
            "description": "Partners section",
            "$ref": "#/definitions/BaseComponent"
        },
        "Items": {
            "title": "Items",
            "description": "Items section",
            "$ref": "#/definitions/BaseComponent"
        },
        "Payment": {
            "title": "Payment",
            "description": "Payment section",
            "$ref": "#/definitions/BaseComponent"
        },
        "ItemDetail": {
            "title": "Item Detail",
            "description": "Item detail section",
            "$ref": "#/definitions/BaseComponent"
        },
        "ItemSchedule": {
            "title": "Item Schedule",
            "description": "Item schedule section",
            "$ref": "#/definitions/BaseComponent"
        },
        "ItemConditions": {
            "title": "Item Conditions",
            "description": "Item conditions section",
            "$ref": "#/definitions/BaseComponent"
        }
    }
}