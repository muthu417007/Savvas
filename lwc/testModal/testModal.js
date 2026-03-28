import { LightningElement, wire, track, api } from 'lwc';
import getLicenseData from '@salesforce/apex/CSMAutomation_LicenseServiceController.getLicenseData';
import LICENSE_WRAPPER from '@salesforce/resourceUrl/SampleLicenseAEJSONResponse';
import pageSize from '@salesforce/label/c.CSM_Automation_PageSize';

const COLUMNS = [
    { label: 'Parent Account', fieldName: 'parentAccountName', sortable: true, type: 'text',cellAttributes: { alignment: 'left'} },
    { label: 'Account', fieldName: 'accountName', sortable: true, type: 'text',cellAttributes: { alignment: 'left'},},
    { label: 'A&E Product Name', fieldName: 'productDisplayName', sortable: true, type: 'picklist',cellAttributes: { alignment: 'left'},},
    { label: 'ISBN Product', fieldName: 'orderedISBN', sortable: true, type: 'text',cellAttributes: { alignment: 'left'},},
    { label: 'Customer PO', fieldName: 'customerPO', sortable: true, type: 'text',cellAttributes: { alignment: 'left'},},
    { label: 'SAP Order Document #', fieldName: 'sapOrderDocumentNumber', sortable: true, type: 'picklist',cellAttributes: { alignment: 'left'},},
    { label: 'SAP Order Type', fieldName: 'sapOrderType', sortable: true, type: 'picklist',cellAttributes: { alignment: 'left'}, },
    { label: 'A&E Licensepool ID', fieldName: 'licenseId', sortable: true, type: 'picklist' ,cellAttributes: { alignment: 'left'},},
    { label: 'License Start Date', fieldName: 'startDate', sortable: true, type: 'date',cellAttributes: { alignment: 'left'}, },
    { label: 'License Exp Date', fieldName: 'endDate', sortable: true, type: 'date',cellAttributes: { alignment: 'left'}, },
    { label: '#License Provisioned', fieldName: 'quantity', type: 'number', sortable: true,cellAttributes: { alignment: 'left'}, },
    { label: 'License Status', fieldName: 'licensePoolStatus', sortable: true, type: 'picklist',cellAttributes: { alignment: 'left'}, },
    { label: 'Organization Name', fieldName: 'licensedOrganizationDisplayName', sortable: true, type: 'picklist',cellAttributes: { alignment: 'left'}, },
    { label: 'Organization ID', fieldName: 'organizationId', sortable: true, type: 'picklist',cellAttributes: { alignment: 'left'}, },
    { label: 'Org SAP ID', fieldName: 'orgSAPID', sortable: true, type: 'picklist',cellAttributes: { alignment: 'left'}, }
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

    columns = COLUMNS;
    columnOptions = [{ label: 'All', value: 'All' }];

    defaultSortDirection = 'asc';
    sortedBy;
    sortedDirection = 'asc';
    isLoaded = false;

    //pagination
    items = [];
    data = [];
    pageSize = 5;
    totalRecordCount = 0;

    renderedCallback(){
        if(this.isLoaded) return;
        const STYLE = document.createElement("style");
        STYLE.innerText =`.uiModal--medium .modal-container{
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

        // Default startDate to current date - 1 year and expirationDate to current date
        const today = new Date();
        const lastYear = new Date(today);
        lastYear.setFullYear(today.getFullYear() - 1);

        this.startDate = this.formatDate(lastYear); // Current date - 1 year
        this.expirationDate = this.formatDate(today); // Current date

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
        console.log('recordId=>'+this.recordId);
        if (data) {
            this.licenseData = data; // Store the fetched data
            this.filteredLicenseData = [...this.licenseData]; // Initially show all data
            console.log('this.filteredLicenseData=>'+JSON.stringify(this.filteredLicenseData));
            console.log('data>'+JSON.stringify(data));
            this.totalRecordCount = data.length;
            this.data = this.licenseData.slice(0, this.pageSize);
        } else if (error) {
            this.error = error;     // Store error if any
            this.isLoading = false; // Set loading to false in case of error
        }
    }

    // Helper method to format date as YYYY-MM-DD
    formatDate(date) {
        const year = date.getFullYear();
        const month = String(date.getMonth() + 1).padStart(2, '0'); // Add leading zero
        const day = String(date.getDate()).padStart(2, '0'); // Add leading zero
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
    
        const column = COLUMNS.find((col) => col.fieldName === this.selectedColumn);
        if (column) {
            this.isMultiSelect = column.type === 'picklist';
            this.isdatepicker = column.type === 'date';
            this.isTextType = column.type === 'text';
            this.isNumberType = column.type === 'number';
            this.showGoButton = !this.isTextType;
    
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
        console.log('Selected Filter:', this.selectedFilter);
        console.log('Selected Column:', this.selectedColumn);
        // if (!this.selectedFilter || this.selectedFilter.length === 0) {
        //     console.log('if');
        //     console.log('before reset this.filteredLicenseData=>'+json.stringify(this.filteredLicenseData));
        //     console.log('before rest this.data=>'+json.stringify(this.data));
        //     // If no filter is selected, reset to unfiltered data
        //     this.filteredLicenseData = [...this.licenseData];
        //     this.data = this.filteredLicenseData.slice(0, this.pageSize);
        //     console.log('reset this.filteredLicenseData=>'+json.stringify(this.filteredLicenseData));
        //     console.log('rest this.data=>'+json.stringify(this.data));
        // } else {
        //     console.log('else');
            this.filterTable();
        // }
    }

    handleSearchChange(event) {
        this.searchTerm = event.target.value;
        if (this.isTextType) {
            this.filterTable();
        }
        if (this.isNumberType) {
            this.filterTable();
        }
    }

    handleMultiSelectChange(event) {
        this.selectedFilter = event.detail.value;
        // this.filterTable();
    }

    handleDateChange(event) {
        this.selectedDate = event.target.value;
        this.filterTable();
    }

    filterTable() {
        let filteredData = [...this.licenseData]; // Clone original data
    
        // Multi-select filtering
        if (this.isMultiSelect && this.selectedFilter.length > 0) {
            console.log('this.isMultiSelect =>', this.isMultiSelect);
            console.log('this.selectedFilter.length =>', this.selectedFilter.length);
            filteredData = filteredData.filter((row) =>
                this.selectedFilter.includes(row[this.selectedColumn])
            );
            console.log('filteredData isMultiSelect=>'+JSON.stringify(filteredData));
        }
    
        // Date filtering
        if (this.isdatepicker && this.selectedDate) {
            filteredData = filteredData.filter(
                (row) => row[this.selectedColumn] === this.selectedDate
            );
            console.log('filteredData isdatepicker=>'+JSON.stringify(filteredData));
        }
    
        // Text search filtering
        if (this.isTextType && this.searchTerm) {
            const term = this.searchTerm.toLowerCase();
            filteredData = filteredData.filter((row) =>
                row[this.selectedColumn] &&
                row[this.selectedColumn].toString().toLowerCase().includes(term)
            );
            console.log('filteredData TextType=>'+JSON.stringify(filteredData));
        }
    
        // Number search filtering
        if (this.isNumberType && this.searchTerm) {
            filteredData = filteredData.filter((row) =>
                row[this.selectedColumn] &&
                row[this.selectedColumn].toString().includes(this.searchTerm)
            );
            console.log('filteredData NumberType=>'+JSON.stringify(filteredData));
        }
    
        // Update filtered data
        this.filteredLicenseData = filteredData.length > 0 ? filteredData : [...this.licenseData];
    
        // Update the table data with pagination
        this.data = [...this.filteredLicenseData.slice(0, this.pageSize)];
    
        // Reset sorting if needed
        this.sortedBy = null;
        this.sortedDirection = null;
    
        // Debug the table data
        console.log('Filtered Data:', this.filteredLicenseData);
        console.log('Table Data After Pagination:', this.data);
    }
    
    handleStartDateChange(event) {
        this.startDate = event.target.value;
    }

    handleExpirationDateChange(event) {
        this.expirationDate = event.target.value;
    }
}