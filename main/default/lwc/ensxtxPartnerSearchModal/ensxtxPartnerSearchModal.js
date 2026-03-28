import LightningModal from 'lightning/modal';
import { api } from 'lwc';
import searchPartners from '@salesforce/apex/ensxtx_CTRL_PartnerSearch.searchPartners';
import ensxtx_Common_Loading from '@salesforce/label/c.ensxtx_Common_Loading';
import ensxtx_PartnerSearch_Button_Cancel from '@salesforce/label/c.ensxtx_PartnerSearch_Button_Cancel';
import ensxtx_PartnerSearch_Button_Debug from '@salesforce/label/c.ensxtx_PartnerSearch_Button_Debug';
import ensxtx_PartnerSearch_Button_Search from '@salesforce/label/c.ensxtx_PartnerSearch_Button_Search';
import ensxtx_PartnerSearch_Message_SearchNoRecords from '@salesforce/label/c.ensxtx_PartnerSearch_Message_SearchNoRecords';
import ensxtx_PartnerSearch_PlaceHolder_SearchPartners from '@salesforce/label/c.ensxtx_PartnerSearch_PlaceHolder_SearchPartners';
import ensxtx_PartnerSearch_Table_City from '@salesforce/label/c.ensxtx_PartnerSearch_Table_City';
import ensxtx_PartnerSearch_Table_ContactFirstName from '@salesforce/label/c.ensxtx_PartnerSearch_Table_ContactFirstName';
import ensxtx_PartnerSearch_Table_ContactLastName from '@salesforce/label/c.ensxtx_PartnerSearch_Table_ContactLastName';
import ensxtx_PartnerSearch_Table_ContactNumber from '@salesforce/label/c.ensxtx_PartnerSearch_Table_ContactNumber';
import ensxtx_PartnerSearch_Table_Country from '@salesforce/label/c.ensxtx_PartnerSearch_Table_Country';
import ensxtx_PartnerSearch_Table_HouseNumber from '@salesforce/label/c.ensxtx_PartnerSearch_Table_HouseNumber';
import ensxtx_PartnerSearch_Table_PartnerName from '@salesforce/label/c.ensxtx_PartnerSearch_Table_PartnerName';
import ensxtx_PartnerSearch_Table_PartnerNumber from '@salesforce/label/c.ensxtx_PartnerSearch_Table_PartnerNumber';
import ensxtx_PartnerSearch_Table_PersonnelFirstName from '@salesforce/label/c.ensxtx_PartnerSearch_Table_PersonnelFirstName';
import ensxtx_PartnerSearch_Table_PersonnelLastName from '@salesforce/label/c.ensxtx_PartnerSearch_Table_PersonnelLastName';
import ensxtx_PartnerSearch_Table_PersonnelNumber from '@salesforce/label/c.ensxtx_PartnerSearch_Table_PersonnelNumber';
import ensxtx_PartnerSearch_Table_PostalCode from '@salesforce/label/c.ensxtx_PartnerSearch_Table_PostalCode';
import ensxtx_PartnerSearch_Table_Region from '@salesforce/label/c.ensxtx_PartnerSearch_Table_Region';
import ensxtx_PartnerSearch_Table_Street from '@salesforce/label/c.ensxtx_PartnerSearch_Table_Street';
import ensxtx_PartnerSearch_Table_VendorName from '@salesforce/label/c.ensxtx_PartnerSearch_Table_VendorName';
import ensxtx_PartnerSearch_Table_VendorNumber from '@salesforce/label/c.ensxtx_PartnerSearch_Table_VendorNumber';
import ensxtx_PartnerSearch_Title_PartnerSearch from '@salesforce/label/c.ensxtx_PartnerSearch_Title_PartnerSearch';

export default class EnsxtxPartnerSearchModal extends LightningModal {
    @api partnerFunction;
    @api partnerFunctionInternal;
    @api partnerFunctionName;
    @api searchType;
    @api fieldSettings;
    @api searchParamFields;
    @api sfObjectIdMap;
    @api pageSize;
    @api isSortable;
    @api sortFields;

    isLoading = false;
    displayPagging = true;
    sortLocation;
    messages = [];
    httpTraces = [];
    
    columns = [];
    partners = [];
    displayedPartners = [];
    pagingOptions = {};
    title;
    defaultSortDirection = 'asc';
    sortDirection = 'asc';
    sortedBy;

    customLabel = {
        ensxtx_Common_Loading,
        ensxtx_PartnerSearch_Button_Cancel,
        ensxtx_PartnerSearch_Button_Debug,
        ensxtx_PartnerSearch_Button_Search,
        ensxtx_PartnerSearch_Message_SearchNoRecords,
        ensxtx_PartnerSearch_PlaceHolder_SearchPartners,
        ensxtx_PartnerSearch_Table_City,
        ensxtx_PartnerSearch_Table_ContactFirstName,
        ensxtx_PartnerSearch_Table_ContactLastName,
        ensxtx_PartnerSearch_Table_ContactNumber,
        ensxtx_PartnerSearch_Table_Country,
        ensxtx_PartnerSearch_Table_HouseNumber,
        ensxtx_PartnerSearch_Table_PartnerName,
        ensxtx_PartnerSearch_Table_PartnerNumber,
        ensxtx_PartnerSearch_Table_PersonnelFirstName,
        ensxtx_PartnerSearch_Table_PersonnelLastName,
        ensxtx_PartnerSearch_Table_PersonnelNumber,
        ensxtx_PartnerSearch_Table_PostalCode,
        ensxtx_PartnerSearch_Table_Region,
        ensxtx_PartnerSearch_Table_Street,
        ensxtx_PartnerSearch_Table_VendorName,
        ensxtx_PartnerSearch_Table_VendorNumber,
        ensxtx_PartnerSearch_Title_PartnerSearch
    };

    formatString(string, params) {
        return string.replace(/{(\d+)}/g, (match, index) => {
            return typeof params[index] !== 'undefined' ? params[index] : match;
        });
    }

    async connectedCallback() {
        this.title = this.formatString(this.customLabel.ensxtx_PartnerSearch_Title_PartnerSearch, 
            [this.partnerFunctionName]);
        this.buildColumns();
        this.pagingOptions.pageSize = this.pageSize || 1000;
        this.pagingOptions.pageNumber = 1;
        this.getPartners();
    }

    buildColumns() {
        switch (this.searchType) {
            case 'Partner':
                if (!this.sfObjectIdMap || this.fieldSettings.PartnerNumber.display) {
                    this.columns.push({label: this.customLabel.ensxtx_PartnerSearch_Table_PartnerNumber, fieldName: 'PartnerNumber', 
                        type: 'text', sortable: this.isSortable && this.fieldSettings.PartnerNumber.sortable});
                }
                if (!this.sfObjectIdMap || this.fieldSettings.PartnerName.display) {
                    this.columns.push({label: this.customLabel.ensxtx_PartnerSearch_Table_PartnerName, fieldName: 'PartnerName', 
                        type: 'text', sortable: this.isSortable && this.fieldSettings.PartnerName.sortable});
                }
                break;
            case 'Vendor':
                if (!this.sfObjectIdMap || this.fieldSettings.VendorNumber.display) {
                    this.columns.push({label: this.customLabel.ensxtx_PartnerSearch_Table_VendorNumber, fieldName: 'VendorNumber', 
                        type: 'text', sortable: this.isSortable && this.fieldSettings.VendorNumber.sortable});
                }
                if (!this.sfObjectIdMap || this.fieldSettings.VendorName.display) {
                    this.columns.push({label: this.customLabel.ensxtx_PartnerSearch_Table_VendorName, fieldName: 'VendorName', 
                        type: 'text', sortable: this.isSortable && this.fieldSettings.VendorName.sortable});
                }
                break;
            case 'Contact':
                if (!this.sfObjectIdMap || this.fieldSettings.ContactNumber.display) {
                    this.columns.push({label: this.customLabel.ensxtx_PartnerSearch_Table_ContactNumber, fieldName: 'ContactNumber', 
                        type: 'text', sortable: this.isSortable && this.fieldSettings.ContactNumber.sortable});
                }
                if (!this.sfObjectIdMap || this.fieldSettings.ContactFirstName.display) {
                    this.columns.push({label: this.customLabel.ensxtx_PartnerSearch_Table_ContactFirstName, fieldName: 'ContactFirstName', 
                        type: 'text', sortable: this.isSortable && this.fieldSettings.ContactFirstName.sortable});
                }
                if (!this.sfObjectIdMap || this.fieldSettings.ContactLastName.display) {
                    this.columns.push({label: this.customLabel.ensxtx_PartnerSearch_Table_ContactLastName, fieldName: 'ContactLastName', 
                        type: 'text', sortable: this.isSortable && this.fieldSettings.ContactLastName.sortable});
                }
                break;
            case 'Personnel':
                if (!this.sfObjectIdMap || this.fieldSettings.PersonnelNumber.display) {
                    this.columns.push({label: this.customLabel.ensxtx_PartnerSearch_Table_PersonnelNumber, fieldName: 'PersonnelNumber', 
                        type: 'text', sortable: this.isSortable && this.fieldSettings.PersonnelNumber.sortable});
                }
                if (!this.sfObjectIdMap || this.fieldSettings.PersonnelFirstName.display) {
                    this.columns.push({label: this.customLabel.ensxtx_PartnerSearch_Table_PersonnelFirstName, fieldName: 'PersonnelFirstName', 
                        type: 'text', sortable: this.isSortable && this.fieldSettings.PersonnelFirstName.sortable});
                }
                if (!this.sfObjectIdMap || this.fieldSettings.PersonnelLastName.display) {
                    this.columns.push({label: this.customLabel.ensxtx_PartnerSearch_Table_PersonnelLastName, fieldName: 'PersonnelLastName', 
                        type: 'text', sortable: this.isSortable && this.fieldSettings.PersonnelLastName.sortable});
                }
                break;
            default:
                break;
        }
        if (!this.sfObjectIdMap || this.fieldSettings.HouseNumber.display) {
            this.columns.push({label: this.customLabel.ensxtx_PartnerSearch_Table_HouseNumber, 
                fieldName: 'HouseNumber', type: 'text', sortable: this.isSortable && this.fieldSettings.HouseNumber.sortable});
        }
        if (!this.sfObjectIdMap || this.fieldSettings.Street.display) {
            this.columns.push({label: this.customLabel.ensxtx_PartnerSearch_Table_Street, 
                fieldName: 'Street', type: 'text', sortable: this.isSortable && this.fieldSettings.Street.sortable});
        }
        if (!this.sfObjectIdMap || this.fieldSettings.City.display) {
            this.columns.push({label: this.customLabel.ensxtx_PartnerSearch_Table_City, 
                fieldName: 'City', type: 'text', sortable: this.isSortable && this.fieldSettings.City.sortable});
        }
        if (!this.sfObjectIdMap || this.fieldSettings.Region.display) {
            this.columns.push({label: this.customLabel.ensxtx_PartnerSearch_Table_Region, 
                fieldName: 'Region', type: 'text', sortable: this.isSortable && this.fieldSettings.Region.sortable});
        }
        if (!this.sfObjectIdMap || this.fieldSettings.PostalCode.display) {
            this.columns.push({label: this.customLabel.ensxtx_PartnerSearch_Table_PostalCode, 
                fieldName: 'PostalCode', type: 'text', sortable: this.isSortable && this.fieldSettings.PostalCode.sortable});
        }
        if (!this.sfObjectIdMap || this.fieldSettings.Country.display) {
            this.columns.push({label: this.customLabel.ensxtx_PartnerSearch_Table_Country, 
                fieldName: 'Country', type: 'text', sortable: this.isSortable && this.fieldSettings.Country.sortable});
        }
    }

    getPartners() {
        this.isLoading = true;
        return searchPartners({ 
            partnerFunction: this.partnerFunction, 
            partnerFunctionInternal: this.partnerFunctionInternal, 
            pagingOptions: this.pagingOptions,
            sortFields: this.sortFields || [],
            mapFieldsList: this.searchParamFields, 
            sfObjectIdMap: this.sfObjectIdMap 
        })
        .then((result) => {
            console.log('searchPartners response', result);
            if (result) {
                this.pagingOptions = result.pagingOptions;
                this.messages = result.messages.map((message, index) => ({...message, key: index}));
                if (result.data) {
                    if (result.data.partners) this.partners = result.data.partners;
                    this.partners.forEach(function (partner) {
                        partner.Key = partner.SalesOrganization + '/' + partner.DistributionChannel + '/' + partner.Division + '/' + partner.PartnerNumber;
                    });
                    this.displayedPartners = this.partners;
                }

                if (result.httpTraces && result.httpTraces.length) {
                    result.httpTraces.forEach(trace => this.httpTraces.unshift(trace));
                }

                this.sortLocation = 'Salesforce';
                this.displayPagging = false;
                if(this.pagingOptions.totalRecords > this.pagingOptions.pageSize){
                    this.displayPagging = true;
                    this.sortLocation = 'SAP';
                }
            }
            this.isLoading = false;
        })
        .catch((err) => {
            console.log('searchPartners error', err);
            this.messages = [];
            let message = err?.body?.message ? err.body.message : JSON.stringify(err);
            this.messages.push({messageType: 'ERROR', message: message, key: this.messages.length});
            this.isLoading = false;
        });
    }

    onKeyPressPartnerNumber(event) {
        if (event.code == 'Enter') this.partnerMatch();
    }

    onSearch(event) {
        this.partnerMatch();
    }

    partnerMatch() {
        let partnerSearchField;
        this.template.querySelectorAll('lightning-input').forEach(currentItem => {
            if (currentItem.name == "partnerSearchField") partnerSearchField = currentItem.value;
        });
        let fieldValueConversion = partnerSearchField ? partnerSearchField.replace(/\s/g, '').trim().toUpperCase() : null;

        if (fieldValueConversion){
            this.displayedPartners = [];
            this.partners.forEach(item => {
                let isFound = false;
                switch (this.searchType) {
                    case 'Partner':
                        isFound = isFound || (this.fieldSettings.PartnerNumber.display && item.PartnerNumber?.replace(/\s/g, '').trim().toUpperCase().match(fieldValueConversion));
                        isFound = isFound || (this.fieldSettings.PartnerName.display && item.PartnerName?.replace(/\s/g, '').toUpperCase().match(fieldValueConversion));
                        break;

                    case 'Vendor':
                        isFound = isFound || (this.fieldSettings.VendorNumber.display && item.VendorNumber?.replace(/\s/g, '').trim().toUpperCase().match(fieldValueConversion));
                        isFound = isFound || (this.fieldSettings.VendorName.display && item.VendorName?.replace(/\s/g, '').trim().replace(/\s/g, '').toUpperCase().match(fieldValueConversion));
                        break;

                    case 'Contact':
                        isFound = isFound || (this.fieldSettings.ContactNumber.display && item.ContactNumber?.toUpperCase().match(fieldValueConversion));
                        isFound = isFound || (this.fieldSettings.ContactFirstName.display && item.ContactFirstName?.replace(/\s/g, '').trim().toUpperCase().match(fieldValueConversion));
                        isFound = isFound || (this.fieldSettings.ContactLastName.display && item.ContactLastName?.replace(/\s/g, '').trim().toUpperCase().match(fieldValueConversion));
                        break;

                    case 'Personnel':
                        isFound = isFound || (this.fieldSettings.PersonnelNumber.display && item.PersonnelNumber?.replace(/\s/g, '').trim().replace(/\s/g, '').toUpperCase().match(fieldValueConversion));
                        isFound = isFound || (this.fieldSettings.PersonnelFirstName.display && item.PersonnelFirstName?.replace(/\s/g, '').trim().toUpperCase().match(fieldValueConversion));
                        isFound = isFound || (this.fieldSettings.PersonnelLastName.display && item.PersonnelLastName?.replace(/\s/g, '').trim().toUpperCase().match(fieldValueConversion));
                        break; 

                    default:
                        break; 
                }

                isFound = isFound || (this.fieldSettings.HouseNumber.display && item.HouseNumber?.replace(/\s/g, '').trim().toUpperCase().match(fieldValueConversion));
                isFound = isFound || (this.fieldSettings.Street.display && item.Street?.replace(/\s/g, '').trim().toUpperCase().match(fieldValueConversion));
                isFound = isFound || (this.fieldSettings.City.display && item.City?.replace(/\s/g, '').trim().trim().toUpperCase().match(fieldValueConversion));
                isFound = isFound || (this.fieldSettings.Region.display && item.Region?.replace(/\s/g, '').toUpperCase().match(fieldValueConversion));
                isFound = isFound || (this.fieldSettings.PostalCode.display && item.PostalCode?.replace(/\s/g, '').trim().toUpperCase().match(fieldValueConversion));
                isFound = isFound || (this.fieldSettings.Country.display && item.Country?.replace(/\s/g, '').trim().toUpperCase().match(fieldValueConversion));
                if (isFound) this.displayedPartners.push(item);
            });
            this.messages = [];
            if (this.displayedPartners.length == 0) {
                this.messages.push({messageType: 'INFO', message: this.customLabel.ensxtx_PartnerSearch_Message_SearchNoRecords, key: '1'});
                this.displayedPartners = this.partners;
            }
        }
        else this.displayedPartners = this.partners;
    }

    onRowSelect(event) {
        let selectedRow = event.detail.selectedRows[0];

        let selectedPartner = {
            PartnerFunction: this.partnerFunction,
            PartnerFunctionInternal: this.partnerFunctionInternal,
            PartnerFunctionName: this.partnerFunctionName,
            HouseNumber: selectedRow.HouseNumber,
            Street: selectedRow.Street,
            City: selectedRow.City,
            PostalCode: selectedRow.PostalCode,
            Region: selectedRow.Region,
            Country: selectedRow.Country,
            isChanged: true
        };

        switch (this.searchType) {
            case 'Partner':
                selectedPartner.CustomerNumber = selectedRow.PartnerNumber;
                selectedPartner.PartnerName = selectedRow.PartnerName;
                break;
            case 'Vendor':
                selectedPartner.Vendor = selectedRow.VendorNumber;
                if (selectedRow.VendorName) selectedPartner.PartnerName = selectedRow.VendorName;
                break;
            case 'Contact':
                selectedPartner.ContactPersonNumber = selectedRow.ContactNumber;
                if (selectedRow.ContactFirstName) selectedPartner.PartnerName = selectedRow.ContactFirstName + ' ';
                if (selectedRow.ContactLastName) selectedPartner.PartnerName += selectedRow.ContactLastName;
                break;
            case 'Personnel':
                selectedPartner.PersonnelNumber = selectedRow.PersonnelNumber;
                if (selectedRow.PersonnelFirstName) selectedPartner.PartnerName = selectedRow.PersonnelFirstName + ' ';
                if (selectedRow.PersonnelLastName) selectedPartner.PartnerName += selectedRow.PersonnelLastName;
                break;
            default:
                break;
        }

        this.close({action: 'Select', partner: selectedPartner});
    }

    onSort(event) {
        const { fieldName: sortedBy, sortDirection } = event.detail;
        if (this.sortLocation == 'Salesforce') {
            const clonePartners = [...this.partners];
            clonePartners.sort(this.sortBy(sortedBy, sortDirection === 'asc' ? 1 : -1));
            this.partners = clonePartners;
            this.displayedPartners = this.partners;
        } else if (this.sortLocation == 'SAP') {
            let fieldMap = [
                { fieldName: 'PartnerNumber', sapFieldName: 'PARTNER_NUM'},
                { fieldName: 'PartnerName', sapFieldName: 'PARTNER_NAME'},
                { fieldName: 'HouseNumber', sapFieldName: 'HOUSE_NUM1'},
                { fieldName: 'Street', sapFieldName: 'STREET'},
                { fieldName: 'City', sapFieldName: 'CITY1'},
                { fieldName: 'PostalCode', sapFieldName: 'POST_CODE1'},
                { fieldName: 'Region', sapFieldName: 'REGION'},
                { fieldName: 'Country', sapFieldName: 'COUNTRY'}
            ];
            this.sortFields[0].direction = sortDirection;
            this.sortFields[0].sortField = fieldMap.filter(field=> field.fieldName==sortedBy)[0]?.sapFieldName;
            this.pagingOptions.pageNumber = 1;
            this.getPartners();
        }
        this.sortDirection = sortDirection;
        this.sortedBy = sortedBy;
    }
    
    sortBy(field, reverse, primer) {
        const key = primer ? function (x) {return primer(x[field]);} : function (x) {return x[field];};
        return function (a, b) {
            a = key(a) ? key(a) : '';
            b = key(b) ? key(b) : '';
            return reverse * ((a > b) - (b > a));
        };
    }
    
    onPagingOptionsChange(event) {
        this.pagingOptions = event.detail.pagingOptions;
        this.getPartners();
    }

    onCancel() {
        this.close({action: 'Cancel'});
    }
}