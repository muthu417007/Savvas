import { LightningElement, wire, track, api } from 'lwc';  
import getLicenseData from '@salesforce/apex/CSMAutomation_LicenseServiceController.getLicenseData';
import LICENSE_WRAPPER from '@salesforce/resourceUrl/SampleLicenseAEJSONResponse';
import pageSize from '@salesforce/label/c.CSM_Automation_PageSize';
import enddateValidation from '@salesforce/label/c.CSMAutomation_EndDateValidation';

const COLUMNS = [
    { label: 'Parent Account', fieldName: 'parentAccountName', sortable: true, type: 'text', cellAttributes: { alignment: 'left' }, initialWidth: 195},
    { label: 'Account', fieldName: 'accountName', sortable: true, type: 'text', cellAttributes: { alignment: 'left' }, initialWidth: 195 },
    { label: 'A&E Product Name', fieldName: 'productDisplayName', sortable: true, type: 'picklist', cellAttributes: { alignment: 'left' }, initialWidth: 300 ,wrapText:true},
    { label: 'Start Date', fieldName: 'startDate', sortable: true, type: 'date', cellAttributes: { alignment: 'left' }, initialWidth: 120 },
    { label: 'End Date', fieldName: 'endDate', sortable: true, type: 'date', cellAttributes: { alignment: 'left' }, initialWidth: 120 },
    { label: 'Customer PO', fieldName: 'customerPO', sortable: true, type: 'text', cellAttributes: { alignment: 'left' },initialWidth: 90 },
    { label: 'SAP Order Document', fieldName: 'sapOrderDocumentNumber', sortable: true, type: 'picklist', cellAttributes: { alignment: 'left' },initialWidth: 90},
    { label: 'License Provisioned', fieldName: 'quantity', type: 'number', sortable: true, cellAttributes: { alignment: 'left' },initialWidth: 20 },
    { label: 'ISBN Product', fieldName: 'orderedISBN', sortable: true, type: 'text', cellAttributes: { alignment: 'left' } ,initialWidth: 90},
    { label: 'Organization Name', fieldName: 'licensedOrganizationDisplayName', sortable: true, type: 'picklist', cellAttributes: { alignment: 'left' }, initialWidth: 90 },
    { label: 'Organization ID', fieldName: 'organizationId', sortable: true, type: 'picklist', cellAttributes: { alignment: 'left' } ,initialWidth: 90},
    { label: 'Org SAP ID', fieldName: 'orgSAPID', sortable: true, type: 'picklist',cellAttributes: { alignment: 'left'},initialWidth: 90 },
    { label: 'A&E Licensepool ID', fieldName: 'licenseId', sortable: true, type: 'picklist', cellAttributes: { alignment: 'left' },initialWidth: 90 },
    { label: 'SAP Order Type', fieldName: 'sapOrderType', sortable: true, type: 'picklist', cellAttributes: { alignment: 'left' } ,initialWidth: 90},
    { label: 'License Status', fieldName: 'licensePoolStatus', sortable: true, type: 'picklist', cellAttributes: { alignment: 'left' } ,initialWidth: 20},
];

export default class CsmAutomation_LicenseDataView extends LightningElement {
    @api recordId;
    @track licenseData = [];
    @track filteredLicenseData = [];
    @track selectedColumn = 'All';
    @track searchTerm = '';
    @track filterOptions = [];
    @track selectedFilter = [];
    @track selectedDate = '';
    @track isMultiSelect = false;
    @track isdatepicker = false;
    @track isTextType = false;
    @track showGoButton = true;
    @track startDate = '';
    @track expirationDate = '';
    @track responseData;
    @track isNumberType = false;
    @track isNoRecordsFound = false;
    @track apexMessage = '';
    @track includeExpiredLicenses = false;
    @track includeAddOnProducts = false;
  
    columns = COLUMNS;
    columnOptions = [{ label: 'All', value: 'All' }];
    
    defaultSortDirection = 'asc';
    sortedBy;
    sortedDirection = 'asc';
    isLoaded = false;
    errorMessage = '';
    expirationDateClass = '';
    isGoDisabled = false;

    //pagination
    items = [];
    data = [];
    pageSize = 5;
    totalRecordCount = 0;

    // Store the original data to reset the table when needed
    originalLicenseData = [];

    renderedCallback() {
        if(this.isLoaded) return;
        const STYLE = document.createElement("style");
        STYLE.innerText = `.uiModal--medium .modal-container{
            width: 100% !important;
            max-width: 95%;
            min-width: 480px;
            max-height: 100%;
            min-height: 480px;
        }`;
        this.template.querySelector('lightning-card').appendChild(STYLE);
        this.isLoaded = true;
    }

    connectedCallback() {
        // Set column options once on initial load
        this.columnOptions = [
            { label: 'All', value: 'All' },
            ...COLUMNS.map((col) => ({ label: col.label, value: col.fieldName }))
        ];

        const today = new Date();
        const lastYear = new Date(today);
        lastYear.setFullYear(today.getFullYear() - 4);

        this.startDate = this.formatDate(lastYear);
        // this.expirationDate = this.formatDate(today);

        fetch(LICENSE_WRAPPER)
            .then((response) => response.json())
            .then((data) => {
                this.responseData = data.data;
            })
            .catch((error) => {
                console.error('Error fetching license data:', error);
            });
    }

    @wire(getLicenseData, { recordId: '$recordId' })
    wiredLicenseData({ error, data }) {

        if (data) {
            this.licenseData = data;
            this.originalLicenseData = [...this.licenseData];
            this.filteredLicenseData = [...this.licenseData];
            this.totalRecordCount = data.length;
            this.data = this.licenseData.slice(0, this.pageSize);
            this.isNoRecordsFound = this.filteredLicenseData.length === 0;

            if(data.length > 0 && data[0].apiMessage){
                this.apexMessage = data[0].apiMessage;
            }
        } else if (error) {
            this.error = error;
        }
    }

    formatDate(date) {
        const year = date.getFullYear();
        const month = String(date.getMonth() + 1).padStart(2, '0');
        const day = String(date.getDate()).padStart(2, '0');
        return `${year}-${month}-${day}`;
    }
    
    handleSort(event) {
        const { fieldName: sortedBy, sortDirection } = event.detail;
        this.sortedBy = sortedBy;
        this.sortedDirection = sortDirection;

        const cloneData = [...this.data];
        cloneData.sort((a, b) => {
            let aValue = a[sortedBy] || '';
            let bValue = b[sortedBy] || '';
            if (typeof aValue === 'string') aValue = aValue.toLowerCase();
            if (typeof bValue === 'string') bValue = bValue.toLowerCase();

            return sortDirection === 'asc' ? (aValue > bValue ? 1 : -1) : (aValue < bValue ? 1 : -1);
        });

        this.data = cloneData;
    }

    handlePaginationPage(event) {
        const start = (event.detail - 1) * this.pageSize;
        const end = this.pageSize * event.detail;
        this.data = this.filteredLicenseData.slice(start, end);
    }

    handleColumnChange(event) {
        this.selectedColumn = event.detail.value;
        // Reset Filter parameters
        this.searchTerm = '';
        this.selectedFilter = [];
        this.selectedDate = '';
        // Reset the table to its original data
        this.filteredLicenseData = [...this.originalLicenseData];
        this.data = this.filteredLicenseData.slice(0, this.pageSize);
        this.totalRecordCount = this.filteredLicenseData.length;
        this.isNoRecordsFound = this.filteredLicenseData.length === 0;
        // Reset the filters and input types
        const column = COLUMNS.find((col) => col.fieldName === this.selectedColumn);
        if (column) {
            this.isMultiSelect = column.type === 'picklist';
            this.isdatepicker = column.type === 'date';
            this.isTextType = column.type === 'text';
            this.isNumberType = column.type === 'number';
            this.showGoButton = !this.isTextType;
        
            // Generate picklist options if the selected column is a picklist
            if (this.isMultiSelect) {
                this.filterOptions = this.generatePicklistOptions(this.selectedColumn);
            }
            } else {
                this.isMultiSelect = false;
                this.isdatepicker = false;
                this.isTextType = false;
                this.isNumberType = false;
                this.showGoButton = true;
            }
    }

    generatePicklistOptions(fieldName) {
        const uniqueValues = [...new Set(this.licenseData.map((item) => item[fieldName]))];
        return uniqueValues.filter(value => value).map(value => ({ label: value, value }));
    }

    handleGoClick() {
        this.filterTable();
    }

    handleSearchChange(event) {
        this.searchTerm = event.target.value;
        if (this.isTextType || this.isNumberType) {
            this.filterTable();
        }
    }

    handleMultiSelectChange(event) {
        this.selectedFilter = event.detail.value;
    }

    handleDateChange(event) {
        this.selectedDate = event.target.value;
        this.filterTable();
    }

    handleStartDateChange(event) {
        this.startDate = event.target.value;
        const dateInput = this.template.querySelector('[data-id="startDate"]');
            if (dateInput) {
                dateInput.value = '';
            }
        this.validateDates();
    }
    handleExpirationDateChange(event) {
        this.expirationDate = event.target.value;
        if (!this.expirationDate) {
             this.errorMessage = '';
             this.expirationDateClass = '';
             this.isGoDisabled = false;
             return;
        }
        this.validateDates();
    }

    validateDates() {
        const currentDate = new Date();
        const startDate = new Date(this.startDate);
        const expirationDate = new Date(this.expirationDate);

        if (expirationDate < startDate) {
            this.errorMessage = enddateValidation;
            this.isGoDisabled = true;
            this.expirationDateClass = 'error-input';
        } else {
            this.errorMessage = '';
            this.expirationDateClass = '';
            this.isGoDisabled = false;
        }
    }

    handleIncludeExpiredLicensesChange(event) {
        this.includeExpiredLicenses = event.target.checked;
    }

    handleIncludeAddOnProductsChange(event) {
        this.includeAddOnProducts = event.target.checked;
    }

    filterTable() {
        let filteredData = [...this.originalLicenseData];

        if (this.selectedColumn && this.selectedColumn !== 'All' && this.searchTerm) {
            filteredData = filteredData.filter(item =>
                item[this.selectedColumn] && item[this.selectedColumn].toLowerCase().includes(this.searchTerm.toLowerCase())
            );
        }

        if (this.isMultiSelect && this.selectedFilter.length) {
            filteredData = filteredData.filter(item => this.selectedFilter.includes(item[this.selectedColumn]));
        }

        if (this.isdatepicker && this.selectedDate) {
            const selectedDate = new Date(this.selectedDate);
            filteredData = filteredData.filter(item => {
                const itemDate = new Date(item[this.selectedColumn]);
                return itemDate >= selectedDate;
            });
        }

        this.filteredLicenseData = filteredData;
        this.totalRecordCount = filteredData.length;
        this.data = filteredData.slice(0, this.pageSize);
        this.isNoRecordsFound = this.filteredLicenseData.length === 0;
    }
}