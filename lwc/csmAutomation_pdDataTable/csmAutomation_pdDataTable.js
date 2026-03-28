import { LightningElement, track, wire, api } from 'lwc';
import getDynamicFilterValues from '@salesforce/apex/CSMAutomation_PDDataTableController.getServiceAppointmentWORecords';
import getColumns from '@salesforce/apex/CSMAutomation_PDDataTableController.getMetadataColumns';
import getPicklistValues from '@salesforce/apex/CSMAutomation_PDDataTableController.getPicklistValues';
import getCSMRecord from '@salesforce/apex/CSMAutomation_StackedBarGraphController.getCSMRecord';
//Custom Labeles
import pageSize from '@salesforce/label/c.CSM_Automation_PageSize';
//
import { loadStyle } from 'lightning/platformResourceLoader';
import styles from '@salesforce/resourceUrl/RemoveDateFormatStyle';
export default class CsmAutomation_pdDataTable extends LightningElement {

    message = '';
    isLoading = false;
    hasData = false;
    data = [];
    mainData = [];
    columns = [];//= columns;
    allColumns = [];
    error;
    isDateField = false;
    searchTerm;
    picklistOptions = [];
    isPicklistField = '';
    selectedField = 'All';
    selectedPicklistValues = [];
    //Sorting
    sortBy;
    sortDirection = 'asc';
    //pagination
    items = [];
    pageSize = pageSize;
    totalRecordCount = 0;
    recordsList = [];
    itemsClone = [];
    accRefreshRecordList = [];
    firstLoadCopied = false;
    //
    @api recordId;
    accountId;
    accountName;
    csmAccountName;
    csmProjectName;
    selectedClass = 'slds-col slds-size_4-of-6 slds-align-bottom slds-text-align_right';


    @wire(getCSMRecord, { csmObjectId: '$recordId' })
    wiredAccountId({ error, data }) {
        if (data) {

            this.accountId = data.Account_Name_V2__c;
            this.accountName = '';
            this.csmProjectName = data.Project_Name__c;
            this.csmAccountName = data.Account_Name_V2__r.Name;
        }
        else if (error) {
            console.error(error);
        }
    }

    get fieldOptions() {
        return [
            { label: 'All', value: 'All' },
            ...this.columns
                .filter(col => col.fieldName !== 'parentAccountName' && col.fieldName !== 'extendedExpirationDate')
                .map(col => ({ label: col.label, value: col.fieldName }))
        ];
    }

    get hideSearchInput() {
        return this.isDateField || this.isPicklistField;
    }

    @wire(getColumns)
    wiredColumns({ error, data }) {
        if (data) {
            this.allColumns = data.map(col => {
                    return {
                        label: col.Label__c,
                        fieldName: col.Field_Name__c,
                        type: col.Type__c,
                        sortable: true
                    };

            })
            this.columns = data
            .filter(col => col.Field_Name__c!=='extendedExpirationDate')
            .map(col => {
                if (col.Field_Name__c === 'expirationDate') {
                    return {
                        label: col.Label__c,
                        fieldName: col.Field_Name__c,
                        type: col.Type__c,
                        sortable: true,
                        cellAttributes: {
                            style: { fieldName: 'expirationClass' }
                        }
                    };
                }
                else {
                    return {
                        label: col.Label__c,
                        fieldName: col.Field_Name__c,
                        type: col.Type__c,
                        sortable: true
                    };
                }
            });
        }
        else if (error) {
            this.error = error;
        }
    }

    @wire(getPicklistValues, { fieldName: '$isPicklistField' })
    wiredPicklistValues({ error, data }) {
        if (data) {
            this.picklistOptions = data.map(value => {
                return { label: value, value: value };
            })
        }
        else if (error) {
            console.error(error);
        }
    }

    @wire(getDynamicFilterValues, { accId: '$accountId', accountName: '$accountName' })
    wiredFilterValues({ error, data }) {
        if (data) {
            //Pagination
            this.items = data.map(item => {
                const expirationDate = item.expirationDate ? this.formatExpiryDate(item.expirationDate) : '';
                const extendedExpirationDate = item.extendedExpirationDate ? this.formatExpiryDate(item.extendedExpirationDate) : '';
                const accountLink = `/lightning/r/Account/${item.accountId}/view`; // Link to Account record page
                const appointmentNumberLink = `/lightning/r/ServiceAppointment/${item.serviceAppointmentId}/view`;
                const expirationClass = extendedExpirationDate ? 'background-color: aquamarine' : '';
                return { ...item, expirationDate, extendedExpirationDate, accountLink, appointmentNumberLink, expirationClass };
            });
            this.itemsClone = data.map(item => {
                const expirationDate = item.expirationDate ? this.formatExpiryDate(item.expirationDate) : '';
                const extendedExpirationDate = item.extendedExpirationDate ? this.formatExpiryDate(item.extendedExpirationDate) : '';
                const accountLink = `/lightning/r/Account/${item.accountId}/view`; // Link to Account record page
                const appointmentNumberLink = `/lightning/r/ServiceAppointment/${item.serviceAppointmentId}/view`;
                const expirationClass = extendedExpirationDate ? 'background-color: aquamarine' : '';
                return { ...item, expirationDate, extendedExpirationDate, accountLink, appointmentNumberLink, expirationClass };
            });
            this.totalRecordCount = data.length;
            this.data = this.items.slice(0, this.pageSize);

            if (!this.firstLoadCopied) {
                this.accRefreshRecordList = data.map(item => {
                    const expirationDate = item.expirationDate ? this.formatExpiryDate(item.expirationDate) : '';
                    const extendedExpirationDate = item.extendedExpirationDate ? this.formatExpiryDate(item.extendedExpirationDate) : '';
                    const accountLink = `/lightning/r/Account/${item.accountId}/view`; // Link to Account record page
                    const appointmentNumberLink = `/lightning/r/ServiceAppointment/${item.serviceAppointmentId}/view`;
                    const expirationClass = extendedExpirationDate ? 'background-color: aquamarine' : '';
                    return { ...item, expirationDate, extendedExpirationDate, accountLink, appointmentNumberLink, expirationClass };
                });
                this.firstLoadCopied = true;

            }
        }
        else if (error) {
            console.error(error);
        }
    }

    formatExpiryDate(dateString) {
        const date = new Date(dateString);
        const options = { year: 'numeric', month: 'short', day: '2-digit' };
        return date.toLocaleDateString('en-US', options);
    }

    handleChange(event) {
        this.message = '';
        this.hasData = false;
        this.isLoading = true;
        this.searchTerm = '';
        this.selectedPicklistValues = '';
        this.selectedField = event.detail.value;

        this.isDateField = this.selectedField === 'scheduleDate' || this.selectedField === 'expirationDate' || this.selectedField === 'extendedExpirationDate';

        if (this.isDateField) {

            this.selectedClass = 'slds-col slds-size_9-of-9 slds-align-bottom slds-text-align_right';
            this.isPicklistField = '';
            const dateInput = this.template.querySelector('[data-id="schedDate"]');
            if (dateInput) {
                dateInput.value = '';
            }
        }
        else if (this.selectedField === 'status' || this.selectedField === 'program' || this.selectedField === 'serviceType' || this.selectedField === 'deliveryMode') {
            this.selectedClass = 'slds-col slds-size_2-of-9 slds-text-align_right';
            if (this.selectedField === 'program') {
                this.isPicklistField = 'Sav_FSL_SA_Program__c';
            }
            else if (this.selectedField === 'serviceType') {
                this.isPicklistField = 'Sav_FSL_Service_Type__c';
            }
            else if (this.selectedField === 'deliveryMode') {
                this.isPicklistField = 'Sav_FSL_Delivery_Mode__c';
            }
            else {
                this.isPicklistField = this.selectedField;
            }
        }
        else {
            this.isPicklistField = '';
            if (this.selectedField != 'scheduleDate' && this.selectedField != 'expirationDate' && this.selectedField != 'extendedExpirationDate') {
                this.selectedClass = 'slds-col slds-size_4-of-6 slds-align-bottom slds-text-align_right';
            }

        }
        this.data = '';
        this.items = '';
        this.recordsList = '';//this.itemsClone;
        this.handlePagination();
        setTimeout(() => {
            this.recordsList = this.accRefreshRecordList; //this.itemsClone;
            this.handlePagination();
            this.isLoading = false;
        }, 2000);
    }

    handleSearchChange(event) {
        this.hasData = false;
        this.data = '';
        this.recordsList = '';
        this.searchTerm = event.target.value;

        if (this.searchTerm.length === 0) {

            this.recordsList = this.accRefreshRecordList;//this.itemsClone;
            this.handlePagination();
        }
        this.items = this.itemsClone;
        if (this.searchTerm.length >= 3) {
            if (this.selectedField === 'All') {
                this.recordsList = this.items.filter(row => {
                    return Object.values(row).some((fieldValue, index) => {
                        const fieldName = Object.keys(row)[index];
                        if (fieldName === 'parentAccountName') {
                            return false;
                        }
                        return fieldValue && ((fieldValue.toLowerCase().includes(this.searchTerm.toLowerCase())) || fieldValue.includes(this.searchTerm));
                    });

                });
            }
            else {

                this.recordsList = this.items.filter(row => {
                    const fieldValue = row[this.selectedField] ? row[this.selectedField].toLowerCase() : '';
                    return fieldValue && ((fieldValue.includes(this.searchTerm.toLowerCase())) || fieldValue.includes(this.searchTerm));
                });
            }

            //Pagination
            this.handlePagination();
        }
        else {
            this.handlePagination();
        }
        if (this.recordsList.length > 0) {
            this.hasData = false;
        }
        else {
            this.hasData = true;
        }
    }

    handleDateChange(event) {
        this.hasData = false;
        this.searchTerm = event.target.value;
        if (this.searchTerm == null || this.searchTerm == '') {
            this.recordsList = this.itemsClone;
            this.handlePagination();
        }
    }

    handlePicklistChange(event) {
        this.hasData = false;
        this.selectedPicklistValues = event.detail.value;//event.detail;//
        if (this.selectedPicklistValues == null || this.selectedPicklistValues == '') {
            this.recordsList = this.itemsClone;
            this.handlePagination();
        }
    }

    formatDate(dateString) {
        const date = new Date(dateString);
        const options = {
            year: 'numeric',
            month: 'short',
            day: '2-digit'
        }
        return date.toLocaleDateString('en-US', options);

    }

    handleSearch() {
        this.message = '';
        this.hasData = false;
        this.items = this.itemsClone;
        this.data = '';


        this.recordsList = '';
        if (this.isDateField && this.searchTerm) {
            if (this.selectedField === 'expirationDate' || this.selectedField === 'extendedExpirationDate') {
                const searchDate = this.searchTerm;
                const formattedDate = this.formatDate(searchDate);
                this.recordsList = this.items.filter(row => {
                    const fieldValue = row[this.selectedField] ? row[this.selectedField] : '';
                    return fieldValue == formattedDate;
                });
            }
            else if (this.selectedField === 'scheduleDate') {
                const searchDate = new Date(this.searchTerm);
                const searchDateString = searchDate.toISOString().split('T')[0];
                this.recordsList = this.items.filter(row => {
                    const fieldValue = row[this.selectedField] ? row[this.selectedField] : '';
                    const fieldValueString = fieldValue.split('T')[0];
                    return fieldValueString === searchDateString;
                });

            }

        }
        else if (this.isPicklistField && this.selectedPicklistValues.length > 0) {
            this.recordsList = this.items.filter(row => {
                const fieldValue = row[this.selectedField] ? row[this.selectedField] : '';
                return this.selectedPicklistValues.includes(fieldValue);
            })
        }
        if ((this.searchTerm == null || this.searchTerm == '') && this.isDateField) {
            this.message = 'Please select a date and search';
        }
        if (this.selectedPicklistValues.length === 0 && this.isPicklistField) {
            this.message = 'Please select at least one value from the list before searching.';
        }
        this.handlePagination();
        if (this.recordsList.length > 0) {
            this.hasData = false;
        }
        else {
            this.hasData = true;
        }
    }

    handlePagination() {
        this.items = this.recordsList;
        this.totalRecordCount = this.items.length;
        this.data = this.items.slice(0, this.pageSize);
    }

    handlePaginationPage(event) {
        const start = (event.detail - 1) * this.pageSize;
        const end = this.pageSize * event.detail;
        this.data = this.items.slice(start, end);
    }

    handleSort(event) {
        const { fieldName, sortDirection } = event.detail;
        this.sortBy = fieldName;
        this.sortDirection = sortDirection;
        this.sortData(this.sortBy, this.sortDirection);
    }

    sortData(fieldName, sortDirection) {
        let parseData = JSON.parse(JSON.stringify(this.data));
        let keyValue = (a) => {
            return a[fieldName];
        };
        let isReverse = sortDirection === 'asc' ? 1 : -1;
        parseData.sort((x, y) => {
            x = keyValue(x) ? keyValue(x) : '';
            y = keyValue(y) ? keyValue(y) : '';
            return isReverse * ((x > y) - (y > x));
        });
        this.data = parseData;
    }

    formatDateForFileName() {
        const now = new Date();
        const options = { day: '2-digit', month: '2-digit', year: 'numeric', hour: '2-digit', minute: '2-digit', second: '2-digit' };
        return now.toLocaleDateString('en-GB', options).replace(/\//g, '-').replace(',', '').replace(/:/g, '-');
    }
    // Function to export data to CSV format

    exportToCSV() {
        const now = new Date();
        const options = {
            day: '2-digit', month: 'short', year: 'numeric', hour: '2-digit', minute: '2-digit', second: '2-digit'
        };
        const formattedDateTime = now.toLocaleTimeString('en-GB', options);
        const csvData = this.generateCSV();
        let downloadElement = document.createElement('a');
        downloadElement.href = 'data:text/csv;charset=utf-8,' + encodeURI(csvData);
        downloadElement.target = '_self';
        downloadElement.download = `${this.csmAccountName}_${formattedDateTime}.csv`;
        document.body.appendChild(downloadElement);
        downloadElement.click();
    }
    // Method to generate CSV content from table data
    generateCSV() {
        let csvString = '';
        const columnHeader = [];

        // Get column headers
        this.allColumns.forEach(column => {
            columnHeader.push(column.label);
        });
        csvString += columnHeader.join(',') + '\n'; // Create header row

        // Iterate over data rows
        this.formattedData.forEach(record => {
            let row = [];
            this.allColumns.forEach(column => {
                const value = record[column.fieldName] !== undefined ? record[column.fieldName] : ''; // Handle undefined values
                row.push('"' + value + '"'); // Add double quotes for safety
            });
            csvString += row.join(',') + '\n'; // Add row to CSV string
        });

        return csvString; // Return the complete CSV content
    }
    get formattedData() {
        return this.accRefreshRecordList.map(record => ({
            ...record,
            expirationDate: record.actualExpirationDate ? this.formatExpiryDate(record.actualExpirationDate) : '',
            scheduleDate: this.scheFormatDate(record.scheduleDate)
        }))
    }
    scheFormatDate(dateString) {
        if (!dateString) {
            return '';
        }
        const date = new Date(dateString);
        const options = { day: '2-digit', month: 'short', year: '2-digit' };
        return date.toLocaleDateString('en-GB', options);
    }
    renderedCallback() {
        Promise.all([
            loadStyle(this, styles) //specified filename
        ]).then(() => {
            window.console.log('Files loaded.');
        }).catch(error => {
            window.console.log("Error " + error.body.message);
        });
    }
}