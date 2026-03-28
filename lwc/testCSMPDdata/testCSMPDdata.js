import { LightningElement, track, wire } from 'lwc';
import getDynamicFilterValues from '@salesforce/apex/CSM_PDDataApex.getServiceAppointmentWORecords';
import getColumns from '@salesforce/apex/CSM_PDDataApex.getMetadataColumns';
import getPicklistValues from '@salesforce/apex/CSM_PDDataApex.getPicklistValues';

const columns = [
    { label: 'Program', fieldName: 'Program' },
    { label: 'ISBN Product', fieldName: 'ISBNProduct' },
    { label: 'Appointment Number', fieldName: 'AppointmentNumber' },
    { label: 'Status', fieldName: 'Status' },
    { label: 'Scheduled Date', fieldName: 'ScheduleDate', type: 'date' },
    { label: 'Expiration Date', fieldName: 'ExpirationDate', type: 'date' },
    { label: 'Service Resource', fieldName: 'ServiceResource' },
    { label: 'Service Type', fieldName: 'ServiceType' },
    { label: 'Customer PO', fieldName: 'CustomerPO' }
]
export default class TestCSMPDdata extends LightningElement {
    @track data = [];
    @track mainData = [];
    @track columns = [];//= columns;
    @track error;
    @track isDateField = false;
    @track searchTerm;
    @track picklistOptions = [];
    @track isPicklistField = '';
    //data Filter
    @track selectedField = '';
    @track selectedPicklistValues = [];
    //Sorting
    @track sortBy;
    @track sortDirection = 'asc';
    //pagination
    @track page = 1;
    @track items = [];
    @track startingRecord = 1;
    @track endingRecord = 0;
    @track pageSize = 25;
    @track totalRecordCount = 0;
    @track totalPage = 0;
    @track recordsList = [];
    @track itemsClone = [];


    get fieldOptions() {
        return [
            { label: 'All', value: 'All' },
            ...this.columns.map(col => ({ label: col.label, value: col.fieldName }))
        ];
    }
    get hideSearchInput() {
        return this.isDateField || this.isPicklistField;
    }
    @wire(getColumns)
    wiredColumns({ error, data }) {
        if (data) {
            this.columns = data.map(col => {
                return {
                    label: col.Label__c,
                    fieldName: col.Field_Name__c,
                    type: col.Type__c,
                    sortable: true
                };
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
    @wire(getDynamicFilterValues)
    wiredFilterValues({ error, data }) {
        if (data) {
            //Pagination
            this.items = data;
            this.itemsClone = data;
            this.totalRecordCount = data.length;
            this.totalPage = Math.ceil(this.totalRecordCount / this.pageSize);
            this.data = this.items.slice(0, this.pageSize);
            this.endingRecord = this.pageSize;
            this.page = 1;
            this.displayRecordPerPage(this.page);
        }
        else if (error) {
            console.error(error);
        }
    }
    handleChange(event) {
        this.selectedField = event.detail.value;
        this.isDateField = this.selectedField === 'ScheduleDate' || this.selectedField === 'ExpirationDate';
        if (this.selectedField === 'Status' || this.selectedField === 'Program' || this.selectedField === 'ServiceType') {
            if (this.selectedField === 'Program') {
                this.isPicklistField = 'Sav_FSL_SA_Program__c';
            }
            else if (this.selectedField === 'ServiceType') {
                this.isPicklistField = 'Sav_FSL_Service_Type__c';
            }
            else {
                this.isPicklistField = this.selectedField;
            }
        }
        else {
            this.isPicklistField = '';
        }
        console.log('this.selectedField', this.selectedField);
        console.log('this.isDateField', this.isDateField);
        console.log('isPicklistField ', this.isPicklistField);
    }
    handleSearchChange(event) {
        this.data = '';
        this.recordsList = '';
        this.searchTerm = event.target.value;
        this.items = this.itemsClone;
        if (this.searchTerm.length >= 3) {
            if (this.selectedField === 'All') {
                this.recordsList = this.items.filter(row => {
                    return Object.values(row).some(fieldValue => {
                        return fieldValue && ((fieldValue.toLowerCase().includes(this.searchTerm.toLowerCase())) || fieldValue.includes(this.searchTerm));
                    });

                });
            }
            /*   else if (this.isDateField) {
               const searchDate = new Date(this.searchTerm);
               const searchDateString = searchDate.toISOString().split('T')[0];
               this.data = this.items.filter(row => {
                   const fieldValue = row[this.selectedField] ? row[this.selectedField] : '';
                   const fieldValueString = fieldValue.split('T')[0];
                   return fieldValueString === searchDateString;
               });
           }*/
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
    }
    handleDateChange(event) {
        this.searchTerm = event.target.value;
        console.log('this.searchTerm', this.searchTerm);
    }
    handlePicklistChange(event) {
        this.selectedPicklistValues = event.detail.value;//event.detail;//
    }
    handleSearch() {
        console.log('this.searchTerm*****', this.searchTerm);
        console.log('this.selectedField<>' + this.selectedField);
        console.log('this.selectedPicklistValues.length<> ' + this.selectedPicklistValues.length);
        console.log('this.isPicklistField ' + this.isPicklistField);
        console.log('this.isDateField<>', this.isDateField);

        this.items = this.itemsClone;
        this.data = '';
        this.recordsList = '';
        if (this.isDateField) {
            const searchDate = new Date(this.searchTerm);
            const searchDateString = searchDate.toISOString().split('T')[0];
            this.recordsList = this.items.filter(row => {
                const fieldValue = row[this.selectedField] ? row[this.selectedField] : '';
                const fieldValueString = fieldValue.split('T')[0];
                console.log('fieldValueString*****', fieldValue);
                return fieldValueString === searchDateString;
            });
        }
        else if (this.isPicklistField && this.selectedPicklistValues.length > 0) {
            console.log('this.selectedPicklistValues ' + this.selectedPicklistValues);
            this.recordsList = this.items.filter(row => {
                const fieldValue = row[this.selectedField] ? row[this.selectedField] : '';
                return this.selectedPicklistValues.includes(fieldValue);
            })
            console.log('this.data.length', this.data.length);
        }
        else {
            this.data = this.items.filter(row => {
                const fieldValue = row[this.selectedField] ? row[this.selectedField].toLowerCase() : '';
                console.log('fieldValue*****', fieldValue);
                return fieldValue && ((fieldValue.includes(this.searchTerm.toLowerCase())) || fieldValue.includes(this.searchTerm));
            });
            /* const searchDate = new Date(this.searchTerm);
             const searchDateString =searchDate.toISOString().split('T')[0]; 
             this.data = this.items.filter(row => {
                 const fieldValue = row[this.selectedField] ? row[this.selectedField] : '';
                 const fieldValueString = fieldValue.split('T')[0];
                 console.log('fieldValueString*****',fieldValue);
                 return fieldValueString === searchDateString;
             });*/
        }
        /*  if (this.selectedField === 'All') {
              this.data = this.items.filter(row => {
                  return Object.values(row).some(fieldValue => {
                      return fieldValue && ((fieldValue.toLowerCase().includes(this.searchTerm.toLowerCase())) || fieldValue.includes(this.searchTerm));
                  });
              });
          }*/
        //Pagination
        this.handlePagination();
    }
    handlePagination() {
        this.items = this.recordsList;
        this.totalRecordCount = this.items.length;
        this.totalPage = Math.ceil(this.totalRecordCount / this.pageSize);
        this.data = this.items.slice(0, this.pageSize);
        this.endingRecord = this.pageSize;
        this.page = 1;
        this.displayRecordPerPage(this.page);
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
    get disablePrevious() {
        return this.page <= 1
    }
    get disableNext() {
        return this.page >= this.totalPage
    }
    previousHandler() {
        if (this.page > 1) {
            this.page = this.page - 1;
            this.displayRecordPerPage(this.page);
        }
    }
    nextHandler() {
        if ((this.page < this.totalPage) && this.page !== this.totalPage) {
            this.page = this.page + 1;
            this.displayRecordPerPage(this.page);
        }
    }
    displayRecordPerPage(page) {
        this.startingRecord = ((page - 1) * this.pageSize);
        this.endingRecord = (this.pageSize * page);
        this.endingRecord = (this.endingRecord > this.totalRecordCount) ? this.totalRecordCount : this.endingRecord;
        this.data = this.items.slice(this.startingRecord, this.endingRecord);
        this.startingRecord = this.startingRecord + 1;
    }
    FirstPageHandler() {
        this.page = 1;
        this.displayRecordPerPage(this.page);
    }
    LastPageHandler() {
        this.page = this.totalPage;
        this.displayRecordPerPage(this.page);
    }
}