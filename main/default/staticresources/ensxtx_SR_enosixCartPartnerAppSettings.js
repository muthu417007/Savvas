{
  "$schema": "ensxtx_SR_enosixCartPartnerAppSettings_schema.json",
  "CartPartner": {
    "PartnerSearchTable": {
      "PartnerNumber": {
        "display": true,
        "sortable": true
      },
      "PartnerName": {
        "display": true,
        "sortable": true
      },
      "VendorNumber": {
        "display": true,
        "sortable": true
      },
      "VendorName": {
        "display": true,
        "sortable": true
      },
      "ContactNumber": {
        "display": true,
        "sortable": true
      },
      "ContactFirstName": {
        "display": true,
        "sortable": true
      },
      "ContactLastName": {
        "display": true,
        "sortable": true
      },
      "PersonnelNumber": {
        "display": true,
        "sortable": true
      },
      "PersonnelFirstName": {
        "display": true,
        "sortable": true
      },
      "PersonnelLastName": {
        "display": true,
        "sortable": true
      },
      "HouseNumber": {
        "display": true,
        "sortable": true
      },
      "Street": {
        "display": true,
        "sortable": true
      },
      "City": {
        "display": true,
        "sortable": true
      },
      "Region": {
        "display": true,
        "sortable": true
      },
      "PostalCode": {
        "display": true,
        "sortable": true
      },
      "Country": {
        "display": true,
        "sortable": true
      }
    },
    "CustomerSearchTable": {
      "FromNumberSearch": {
        "display": true
      },
      "ToNumberSearch": {
        "display": true
      },
      "NameSearch": {
        "display": true
      },
      "Name2Search": {
        "display": true
      },
      "CustomerNumberSearch": {
        "display": true
      },
      "CitySearch": {
        "display": true
      },
      "RegionSearch": {
        "display": true
      },
      "PostalCodeSearch": {
        "display": true
      },
      "CountrySearch": {
        "display": true
      },
      "TelephoneSearch": {
        "display": true
      },
      "EmailSearch": {
        "display": true
      },
      "CustomerNumber": {
        "display": true
      },
      "Name": {
        "display": true
      },
      "Name2": {
        "display": true
      },
      "Street": {
        "display": true
      },
      "City": {
        "display": true
      },
      "Region": {
        "display": true
      },
      "PostalCode": {
        "display": true
      },
      "Country": {
        "display": true
      }
    },
    "AllowAddressOverride": [
      {
        "PartnerFunction": "SH",
        "allowAddressOverride": true
      },
      {
        "PartnerFunction": "BP",
        "allowAddressOverride": true
      }
    ],
    "PageSize": 1000,
    "SearchParamFields": [
      {
        "sapField": "SalesOrganization",
        "defaultValue": "",
        "sfObjectType": "WebCart",
        "sfField": "ensxtx_SAP_Sales_Organization__c"
      },
      {
        "sapField": "DistributionChannel",
        "defaultValue": "",
        "sfObjectType": "WebCart",
        "sfField": "ensxtx_SAP_Distribution_Channel__c"
      },
      {
        "sapField": "Division",
        "defaultValue": "",
        "sfObjectType": "WebCart",
        "sfField": "ensxtx_SAP_Division__c"
      }
    ],
    "AllowSort": true,
    "SortFields": [
      {
          "precedence": 1,
          "sortField": "PARTNER_NAME",
          "direction": "ASC"
      }
    ],
    "optionValuesToInclude": {
      "Country": ["US", "CA", "MX"]
    }
  }
}