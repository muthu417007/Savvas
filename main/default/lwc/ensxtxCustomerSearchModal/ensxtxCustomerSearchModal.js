import LightningModal from 'lightning/modal';
import { api } from 'lwc';
import searchCustomers from '@salesforce/apex/ensxtx_CTRL_CustomerSearch.searchCustomers';
import searchVendors from '@salesforce/apex/ensxtx_CTRL_CustomerSearch.searchVendors';
import ensxtx_Common_Loading from '@salesforce/label/c.ensxtx_Common_Loading';
import ensxtx_CustomerSearch_Button_Cancel from '@salesforce/label/c.ensxtx_CustomerSearch_Button_Cancel';
import ensxtx_CustomerSearch_Button_Search from '@salesforce/label/c.ensxtx_CustomerSearch_Button_Search';
import ensxtx_CustomerSearch_Field_City from '@salesforce/label/c.ensxtx_CustomerSearch_Field_City';
import ensxtx_CustomerSearch_Field_Country from '@salesforce/label/c.ensxtx_CustomerSearch_Field_Country';
import ensxtx_CustomerSearch_Field_CustomerName from '@salesforce/label/c.ensxtx_CustomerSearch_Field_CustomerName';
import ensxtx_CustomerSearch_Field_CustomerNumber from '@salesforce/label/c.ensxtx_CustomerSearch_Field_CustomerNumber';
import ensxtx_CustomerSearch_Field_EmailAddress from '@salesforce/label/c.ensxtx_CustomerSearch_Field_EmailAddress';
import ensxtx_CustomerSearch_Field_FirstName from '@salesforce/label/c.ensxtx_CustomerSearch_Field_FirstName';
import ensxtx_CustomerSearch_Field_FromCustomerNumber from '@salesforce/label/c.ensxtx_CustomerSearch_Field_FromCustomerNumber';
import ensxtx_CustomerSearch_Field_FromPartnerNumber from '@salesforce/label/c.ensxtx_CustomerSearch_Field_FromPartnerNumber';
import ensxtx_CustomerSearch_Field_FromVendorNumber from '@salesforce/label/c.ensxtx_CustomerSearch_Field_FromVendorNumber';
import ensxtx_CustomerSearch_Field_LastName from '@salesforce/label/c.ensxtx_CustomerSearch_Field_LastName';
import ensxtx_CustomerSearch_Field_PostalCode from '@salesforce/label/c.ensxtx_CustomerSearch_Field_PostalCode';
import ensxtx_CustomerSearch_Field_Region from '@salesforce/label/c.ensxtx_CustomerSearch_Field_Region';
import ensxtx_CustomerSearch_Field_Telephone from '@salesforce/label/c.ensxtx_CustomerSearch_Field_Telephone';
import ensxtx_CustomerSearch_Field_ToCustomerNumber from '@salesforce/label/c.ensxtx_CustomerSearch_Field_ToCustomerNumber';
import ensxtx_CustomerSearch_Field_ToPartnerNumber from '@salesforce/label/c.ensxtx_CustomerSearch_Field_ToPartnerNumber';
import ensxtx_CustomerSearch_Field_ToVendorNumber from '@salesforce/label/c.ensxtx_CustomerSearch_Field_ToVendorNumber';
import ensxtx_CustomerSearch_Field_VendorName from '@salesforce/label/c.ensxtx_CustomerSearch_Field_VendorName';
import ensxtx_CustomerSearch_Table_City from '@salesforce/label/c.ensxtx_CustomerSearch_Table_City';
import ensxtx_CustomerSearch_Table_ContactNumber from '@salesforce/label/c.ensxtx_CustomerSearch_Table_ContactNumber';
import ensxtx_CustomerSearch_Table_Country from '@salesforce/label/c.ensxtx_CustomerSearch_Table_Country';
import ensxtx_CustomerSearch_Table_CustomerNumber from '@salesforce/label/c.ensxtx_CustomerSearch_Table_CustomerNumber';
import ensxtx_CustomerSearch_Table_FirstName from '@salesforce/label/c.ensxtx_CustomerSearch_Table_FirstName';
import ensxtx_CustomerSearch_Table_LastName from '@salesforce/label/c.ensxtx_CustomerSearch_Table_LastName';
import ensxtx_CustomerSearch_Table_PersonnelNumber from '@salesforce/label/c.ensxtx_CustomerSearch_Table_PersonnelNumber';
import ensxtx_CustomerSearch_Table_PostalCode from '@salesforce/label/c.ensxtx_CustomerSearch_Table_PostalCode';
import ensxtx_CustomerSearch_Table_Region from '@salesforce/label/c.ensxtx_CustomerSearch_Table_Region';
import ensxtx_CustomerSearch_Table_Street from '@salesforce/label/c.ensxtx_CustomerSearch_Table_Street';
import ensxtx_CustomerSearch_Table_VendorNumber from '@salesforce/label/c.ensxtx_CustomerSearch_Table_VendorNumber';
import ensxtx_CustomerSearch_Title_CustomerSearch from '@salesforce/label/c.ensxtx_CustomerSearch_Title_CustomerSearch';

export default class EnsxtxCustomerSearchModal extends LightningModal {
    @api partnerFunction;
    @api partnerFunctionInternal;
    @api partnerFunctionName;
    @api searchType;
    @api fieldSettings;
    @api searchParamFields;
    @api sfObjectIdMap;
    @api isAutoSearch;
    @api pageSize;
    @api searchParams;

    isLoading = false;
    get isContactOrPersonnel() {
        return this.searchType == 'Contact' || this.searchType == 'Personnel';
    };
    get isVendor() {
        return this.searchType == 'Vendor';
    };
    get isPartner() {
        return this.searchType == 'Partner';
    };

    get businessPartnerFrom() {
        return this.internalSearchParams.BusinessPartnerFrom;
    }
    set businessPartnerFrom(value) {
        this.internalSearchParams.BusinessPartnerFrom = value;
    }

    get businessPartnerTo() {
        return this.internalSearchParams.BusinessPartnerTo;
    }
    set businessPartnerTo(value) {
        this.internalSearchParams.BusinessPartnerTo = value;
    }
    
    get firstName() {
        return this.internalSearchParams.FirstName;
    }
    set firstName(value) {
        this.internalSearchParams.FirstName = value;
    }
    
    get lastName() {
        return this.internalSearchParams.LastName;
    }
    set lastName(value) {
        this.internalSearchParams.LastName = value;
    }
    
    get customerNumber() {
        return this.internalSearchParams.customerNumber;
    }
    set customerNumber(value) {
        this.internalSearchParams.customerNumber = value;
    }
    
    get customerNumberFrom() {
        return this.internalSearchParams.CustomerNumberFrom;
    }
    set customerNumberFrom(value) {
        this.internalSearchParams.CustomerNumberFrom = value;
    }
    
    get customerNumberTo() {
        return this.internalSearchParams.CustomerNumberTo;
    }
    set customerNumberTo(value) {
        this.internalSearchParams.CustomerNumberTo = value;
    }

    get customerName() {
        return this.internalSearchParams.CustomerName;
    }
    set customerName(value) {
        this.internalSearchParams.CustomerName = value;
    }
    
    get city() {
        return this.internalSearchParams.City;
    }
    set city(value) {
        this.internalSearchParams.City = value;
    }
    
    get region() {
        return this.internalSearchParams.Region;
    }
    set region(value) {
        this.internalSearchParams.Region = value;
    }
    
    get postalCode() {
        return this.internalSearchParams.PostalCode;
    }
    set postalCode(value) {
        this.internalSearchParams.PostalCode = value;
    }
    
    get country() {
        return this.internalSearchParams.Country;
    }
    set country(value) {
        this.internalSearchParams.Country = value;
    }
    
    get telephoneNumber() {
        return this.internalSearchParams.TelephoneNumber;
    }
    set telephoneNumber(value) {
        this.internalSearchParams.TelephoneNumber = value;
    }
    
    get eMailAddress() {
        return this.internalSearchParams.EMailAddress;
    }
    set eMailAddress(value) {
        this.internalSearchParams.EMailAddress = value;
    }
    
    internalSearchParams = {};
    displayPagging = true;
    messages = [];
    httpTraces = [];
    
    columns = [];
    partners = [];
    searchResult = [];
    pagingOptions = {};
    title;
    isContactSearch;

    customLabel = {
        ensxtx_Common_Loading,
        ensxtx_CustomerSearch_Button_Cancel,
        ensxtx_CustomerSearch_Button_Search,
        ensxtx_CustomerSearch_Field_City,
        ensxtx_CustomerSearch_Field_Country,
        ensxtx_CustomerSearch_Field_CustomerName,
        ensxtx_CustomerSearch_Field_CustomerNumber,
        ensxtx_CustomerSearch_Field_EmailAddress,
        ensxtx_CustomerSearch_Field_FirstName,
        ensxtx_CustomerSearch_Field_FromCustomerNumber,
        ensxtx_CustomerSearch_Field_FromPartnerNumber,
        ensxtx_CustomerSearch_Field_FromVendorNumber,
        ensxtx_CustomerSearch_Field_LastName,
        ensxtx_CustomerSearch_Field_PostalCode,
        ensxtx_CustomerSearch_Field_Region,
        ensxtx_CustomerSearch_Field_Telephone,
        ensxtx_CustomerSearch_Field_ToCustomerNumber,
        ensxtx_CustomerSearch_Field_ToPartnerNumber,
        ensxtx_CustomerSearch_Field_ToVendorNumber,
        ensxtx_CustomerSearch_Field_VendorName,
        ensxtx_CustomerSearch_Table_City,
        ensxtx_CustomerSearch_Table_ContactNumber,
        ensxtx_CustomerSearch_Table_Country,
        ensxtx_CustomerSearch_Table_CustomerNumber,
        ensxtx_CustomerSearch_Table_FirstName,
        ensxtx_CustomerSearch_Table_LastName,
        ensxtx_CustomerSearch_Table_PersonnelNumber,
        ensxtx_CustomerSearch_Table_PostalCode,
        ensxtx_CustomerSearch_Table_Region,
        ensxtx_CustomerSearch_Table_Street,
        ensxtx_CustomerSearch_Table_VendorNumber,
        ensxtx_CustomerSearch_Title_CustomerSearch
    };

    formatString(string, params) {
        return string.replace(/{(\d+)}/g, (match, index) => {
            return typeof params[index] !== 'undefined' ? params[index] : match;
        });
    }

    async connectedCallback() {
        this.internalSearchParams = {...this.searchParams};
        this.title = this.formatString(this.customLabel.ensxtx_CustomerSearch_Title_CustomerSearch, 
            [this.partnerFunctionName]);
        this.buildColumns();
        this.pagingOptions.pageSize = this.pageSize || 10;
        this.pagingOptions.pageNumber = 1;
        if (this.isAutoSearch) {
            this.search();
        }
    }

    buildColumns() {
        if (!this.searchParamFields) this.searchParamFields = [];
        this.isContactSearch = false;
        let customerNumberLabel = this.customLabel.ensxtx_CustomerSearch_Table_CustomerNumber;
        let tmpSearchParamFields = [];
        if (this.internalSearchParams != null) {
            this.searchParamFields.forEach(function(mapField) {
                let tmpMapField = {...mapField};
                tmpMapField.defaultValue = '';
                tmpSearchParamFields.push(tmpMapField);
            });
        } else {
            this.internalSearchParams = {};
            tmpSearchParamFields = [...this.searchParamFields];
        }

        if (this.searchType === 'Contact') {
            customerNumberLabel = this.customLabel.ensxtx_CustomerSearch_Table_ContactNumber;
            this.isContactSearch = true;
        }
        else if (this.searchType === 'Personnel') {
            customerNumberLabel = this.customLabel.ensxtx_CustomerSearch_Table_PersonnelNumber;
            this.isContactSearch = true;
        }
        else if (this.searchType === 'Vendor') {
            customerNumberLabel = this.customLabel.ensxtx_CustomerSearch_Table_VendorNumber;
        }

        this.searchParamFields = tmpSearchParamFields;

        if (!this.sfObjectIdMap || this.fieldSettings.CustomerNumber.display) {
            this.columns.push({label: customerNumberLabel, fieldName: 'CustomerNumber', type: 'text'});
        }
        if (!this.sfObjectIdMap || this.fieldSettings.Name.display) {
            this.columns.push({label: this.customLabel.ensxtx_CustomerSearch_Table_FirstName, fieldName: 'Name', type: 'text'});
        }
        if (!this.sfObjectIdMap || this.fieldSettings.Name2.display) {
            this.columns.push({label: this.customLabel.ensxtx_CustomerSearch_Table_LastName, fieldName: 'Name2', type: 'text'});
        }
        if (!this.isContactSearch) {
            if (this.fieldSettings.Street.display) {
                this.columns.push({label: this.customLabel.ensxtx_CustomerSearch_Table_Street, fieldName: 'Street', type: 'text'});
            }
            if (this.fieldSettings.City.display) {
                this.columns.push({label: this.customLabel.ensxtx_CustomerSearch_Table_City, fieldName: 'City', type: 'text'});
            }
            if (this.fieldSettings.Region.display) {
                this.columns.push({label: this.customLabel.ensxtx_CustomerSearch_Table_Region, fieldName: 'Region', type: 'text'});
            }
            if (this.fieldSettings.PostalCode.display) {
                this.columns.push({label: this.customLabel.ensxtx_CustomerSearch_Table_PostalCode, fieldName: 'PostalCode', type: 'text'});
            }
            if (this.fieldSettings.Country.display) {
                this.columns.push({label: this.customLabel.ensxtx_CustomerSearch_Table_Country, fieldName: 'Country', type: 'text'});
            }
        }
    }

    search() {
        this.isLoading = true;
        let searchMethod = this.searchType === 'Vendor' ? searchVendors : searchCustomers;
        let mapFieldsList = [...this.searchParamFields];
        if (this.searchType === 'Contact') {
            mapFieldsList.push({
                sapField: 'contactPersonFlag',
                defaultValue: 'X'
            });
        }
        else if (this.searchType === 'Personnel') {
            mapFieldsList.push({
                sapField: 'salesEmployeeFlag',
                defaultValue: 'X'
            });
        }

        let vendorSearchParams = ['fromVendor', 'toVendor', 'customerName'];
        let contactSearchParams = ['customerNumber', 'businessPartnerFrom', 'businessPartnerTo', 'firstName', 'lastName'];
        let nonContactSearchParams = ['customerNumberFrom', 'customerNumberTo', 'customerName', 'postalCode', 'city', 'region', 'country', 'telephoneNumber', 'eMailAddress'];
        let isCustomerNumberSet = false;
        this.template.querySelectorAll('lightning-input').forEach(currentItem => {
            if ((this.searchType == 'Vendor' && vendorSearchParams.includes(currentItem.name)) ||
                (this.searchType != 'Vendor' && (this.isContactSearch && contactSearchParams.includes(currentItem.name)) ||
                (!this.isContactSearch && nonContactSearchParams.includes(currentItem.name)))) 
            {
                if (currentItem.name == 'customerNumber') isCustomerNumberSet = true;
                mapFieldsList.push({
                    sapField: currentItem.name,
                    defaultValue: currentItem.value
                });
            }
        });
        if (!isCustomerNumberSet) {
            mapFieldsList.push({
                sapField: 'customerNumber',
                defaultValue: this.customerNumber
            });
        }

        return searchMethod({ 
            isContactSearch: this.isContactSearch,
            pagingOptions: this.pagingOptions,
            mapFieldsList: mapFieldsList,
            sfObjectIdMap: this.sfObjectIdMap
        })
        .then((result) => {
            console.log('search response', result);
            if (result) {
                this.pagingOptions = result.pagingOptions;
                this.messages = result.messages.map((message, index) => ({...message, key: index}));
                if (result.data) {
                    this.searchResult = result.data.searchResult || [];
                    if (this.isContactSearch) this.internalSearchParams.customerNumber = result.data.customerNumber;
                }

                if (result.httpTraces && result.httpTraces.length) {
                    result.httpTraces.forEach(trace => this.httpTraces.unshift(trace));
                }

                this.displayPagging = false;
                if(this.pagingOptions.totalRecords > this.pagingOptions.pageSize){
                    this.displayPagging = true;
                }
            }
            this.searchParamFields = [];
            this.sfObjectIdMap = [];
            this.isLoading = false;
        })
        .catch((err) => {
            console.log('search error', err);
            this.messages = [];
            let message = err?.body?.message ? err.body.message : JSON.stringify(err);
            this.messages.push({messageType: 'ERROR', message: message, key: this.messages.length});
            this.isLoading = false;
        });
    }

    onSearch(event) {
        this.search();
    }

    onRowSelect(event) {
        let selectedRow = event.detail.selectedRows[0];

        let selectedCustomer = {
            PartnerName: selectedRow.Name + (selectedRow.Name2 ? ' ' + selectedRow.Name2 : ''),
            PartnerFunction: this.partnerFunction,
            PartnerFunctionInternal: this.partnerFunctionInternal,
            PartnerFunctionName: this.partnerFunctionName,
            Street: selectedRow.Street,
            City: selectedRow.City,
            PostalCode: selectedRow.PostalCode,
            Region: selectedRow.Region,
            Country: selectedRow.Country,
            TelephoneNumber: selectedRow.TelephoneNumber,
            EmailAddress: selectedRow.EmailAddress,
            isChanged: true
        };

        switch (this.searchType) {
            case 'Contact':
                selectedCustomer.ContactPersonNumber = selectedRow.CustomerNumber;
                break;
            case 'Personnel':
                selectedCustomer.PersonnelNumber = selectedRow.CustomerNumber;
                break;
            case 'Vendor':
                selectedCustomer.Vendor = selectedRow.CustomerNumber;
                break;
            default:
                selectedCustomer.CustomerNumber = selectedRow.CustomerNumber;
                break;
        }

        this.close({action: 'Select', partner: selectedCustomer});
    }
    
    onPagingOptionsChange(event) {
        this.pagingOptions = event.detail.pagingOptions;
        this.search();
    }

    onCancel() {
        this.close({action: 'Cancel'});
    }
}