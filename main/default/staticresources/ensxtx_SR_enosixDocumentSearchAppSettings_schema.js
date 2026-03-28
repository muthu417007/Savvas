{
    "$schema": "http://json-schema.org/draft-07/schema",
    "properties": {
        "DocType": {
            "type": "string",
            "title": "Document Type",
            "description": "Search document type",
            "enum": [
                "SalesDoc",
                "Delivery",
                "Invoice"
            ]
        },
        "HeaderTitle": {
            "type": "string",
            "title": "Header Title",
            "description": "Label for the header"
        },
        "HeaderIcon": {
            "type": "string",
            "title": "Header Icon",
            "description": "The name of the icon shown right next to the header title."
        },
        "DisplayHeader": {
            "type": "boolean",
            "title": "Display Header",
            "description": "Enable this setting to display the header section.",
            "default": false
        },
        "AutoSearch": {
            "type": "boolean",
            "title": "Auto Search",
            "description": "Enable this setting to auto search on initial load.",
            "default": true
        },
        "DisplaySearchButton": {
            "type": "boolean",
            "title": "Display Search Button",
            "description": "Enable this setting to display the search button.",
            "default": false
        },
        "SearchButtonLabel": {
            "type": "string",
            "title": "Search Button Label",
            "description": "The label for the search button."
        },
        "DocTypes": {
            "type": "array",
            "title": "SAP Document Types",
            "description": "List of SAP Document types to filter.",
            "default": [],
            "items": {
                "type": "string",
                "title": "SAP Document Type"
            }
        },
        "SearchParams": {
            "type": "object",
            "title": "Search Parameters",
            "properties": {
                "Display": {
                    "type": "boolean",
                    "title": "Display",
                    "description": "Enable this setting to display the search parameter input fields",
                    "default": false
                },
                "Columns": {
                    "type": "integer",
                    "title": "Number of Columns",
                    "description": "Number of columns for the search parameter fields",
                    "default": 2
                },
                "SoldToFieldName": {
                    "type": "string",
                    "title": "SoldToFieldName",
                    "description": "The name of the sold-to field"
                },
                "Fields": {
                    "type": "array",
                    "title": "Search Parameter Fields",
                    "description": "List of search parameter fields that will map to the RIO",
                    "items": {
                        "type": "object",
                        "properties": {
                            "Name": {
                                "type": "string",
                                "title": "Name",
                                "description": "The name of the field, same friendly field name as the RIO"
                            },
                            "Label": {
                                "type": "string",
                                "title": "Label",
                                "description": "The label of the input field that will be shown in the UI"
                            },
                            "Display": {
                                "type": "boolean",
                                "title": "Display",
                                "description": "Enable this setting to display the input field",
                                "default": false
                            },
                            "InputType": {
                                "type": "string",
                                "title": "Input Type",
                                "description": "Specify the input type",
                                "enum": [
                                    "text",
                                    "date",
                                    "picklist",
                                    "checkbox"
                                ]
                            },
                            "DefaultValue": {
                                "type": "string",
                                "title": "Default Value",
                                "description": "The default value for this search parameter"
                            },
                            "AllowedValues": {
                                "type": "array",
                                "title": "Allowed Values",
                                "description": "List of allowed values, for input type picklist or checkbox",
                                "default": [],
                                "items": {
                                    "type": "object",
                                    "properties": {
                                        "Value": {
                                            "type": "string",
                                            "title": "Value",
                                            "description": "Value"
                                        },
                                        "Label": {
                                            "type": "string",
                                            "title": "Label",
                                            "description": "The label of the value"
                                        }
                                    },
                                    "required": [
                                        "Value",
                                        "Label"
                                    ]
                                }
                            }
                        },
                        "required": [
                            "Name",
                            "Label",
                            "InputType"
                        ]
                    }
                }
            },
            "required": [
                "Display",
                "Columns",
                "SoldToFieldName",
                "Fields"
            ]
        },
        "SortFields": {
            "type": "array",
            "title": "Sort by Fields",
            "description": "The list of fields to sort by. The field correspond to the search result fields",
            "items": {
                "type": "object",
                "properties": {
                    "precedence": {
                        "type": "integer",
                        "title": "Precedence",
                        "description": "Set the precedence for the sort field"
                    },
                    "sortField": {
                        "type": "string",
                        "title": "Sort Field Name",
                        "description": "The name of the SAP Search result field to sort by, in relation to the RIO"
                    },
                    "direction": {
                        "type": "string",
                        "title": "Direction",
                        "description": "Direction of the sorting",
                        "enum": [
                            "Descending",
                            "Ascending"
                        ]
                    }
                },
                "required": [
                    "precedence",
                    "sortField",
                    "direction"
                ]
            }
        },
        "SearchResultTitle": {
            "type": "string",
            "title": "Search Result Title",
            "description": "The title of the search result header."
        },
        "SearchResultIcon": {
            "type": "string",
            "title": "Search Result Icon",
            "description": "The name of the icon shown right next to the search result header title."
        },
        "DisplaySearchResultHeader": {
            "type": "boolean",
            "title": "Display Search Result Header",
            "description": "Enable this setting to display the search result header.",
            "default": true
        },
        "DetailFlowName": {
            "type": "string",
            "title": "Detail Flow Name",
            "description": "The name of the Salesforce flow to go to the detail view of the document."
        },
        "DisplayRefreshButton": {
            "type": "boolean",
            "title": "Display Refresh Button",
            "description": "Enable this setting to display refresh button",
            "default": true
        },
        "DetailLinkText": {
            "type": "string",
            "title": "Detail Link Label",
            "description": "The label of the document detail link"
        },
        "SearchResults": {
            "type": "object",
            "title": "Search Results",
            "properties": {
                "CurrencyPath": {
                    "type": "string",
                    "title": "Currency Field",
                    "description": "The friendly field name of the currency field, in relation to the RIO"
                },
                "Columns": {
                    "type": "array",
                    "title": "Search Result Columns",
                    "description": "The list of columns to show on the search result.",
                    "items": {
                        "type": "object",
                        "properties": {
                            "Display": {
                                "type": "boolean",
                                "title": "Display",
                                "description": "Enable this setting to display the column.",
                                "default": true
                            },
                            "Path": {
                                "type": "string",
                                "title": "Name",
                                "description": "The name of the search result field, same friendly field name as the RIO."
                            },
                            "Label": {
                                "type": "string",
                                "title": "Label",
                                "description": "The label of the search result field that will be shown in the UI"
                            },
                            "Type": {
                                "type": "string",
                                "title": "Field Type",
                                "description": "Specify the field type",
                                "enum": [
                                    "detailLink",
                                    "string",
                                    "date",
                                    "currency"
                                ]
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
                                            " - ",
                                            ",",
                                            ";",
                                            "/",
                                            ":"
                                        ]
                                    }
                                }
                            }
                        },
                        "required": [
                            "Display",
                            "Label",
                            "Type"
                        ]
                    }
                }
            }
        }
    }
}