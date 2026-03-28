import { LightningElement, wire, track, api } from 'lwc';
import searchProducts from '@salesforce/apex/scc_productCriteriaSearch.searchProducts';
import errormessage from '@salesforce/label/c.scc_productcriteriaerrormessage';

import { RefreshEvent } from 'lightning/refresh';

export default class Scc_productCriteriaSearchLWC extends LightningElement {
    @track selectedDiscipline = '';
    @track titlekeyword = '';
    @track isbnValue = '';
    @track activeProducts = true; // Checked by default
    @track searchDisabled = true; // Initially disabled
    @track showResults = false; // Initially hidden
    @track productData = []; // Data to display in the table
    @track disableNext = true; // Initially disabled
    @track disciplineOptions = [];
    @track filterCriteria;
    @api viewForCatalogSection = false;
    @track searchTerm='';
   
    records = []; //All records available in the data table
    columns = []; //columns information available in the data table
    recordsToDisplay = []; //Records to be displayed on the page
    searchResultErrorMessage = errormessage;
    manualSearchBtnDisabled = false;
    showProductTitlePage = false;
    showTabset = true;
    selectedProductRecord = {};
    showSearchResultErrorMessage = false;

    filter=false;

    // Pagination Variables
    @track currentPagetableData = [];
    selectedIdList = [];
    hideCheckbox = false;
    // Define columns for the lightning-datatable
    columns = [
        {
            label: 'ISBN',
            fieldName: 'ISBN',
            type: 'button',
            typeAttributes: { label: { fieldName: 'ISBN', type: 'text' }, name: 'viewRecords', target: '_blank', class: 'custom-button', variant: 'base' },
            sortable: true
           
},

        
        { label: 'Title Description', fieldName: 'Title_Description', sortable: true, type: 'text' },
        { label: 'Type', fieldName: 'Type', type: 'text', sortable: true, wrapText: true },
        { label: 'Grade Level', fieldName: 'Grade_Level', type: 'text', sortable: true },
        { label: 'Copyright', fieldName: 'Copyright', type: 'text', sortable: true },
        { label: 'Status', fieldName: 'Status', type: 'text', sortable: true },
        {
            label: 'Price',
            type: 'button-icon',
            initialWidth: 80,
            typeAttributes: {
                name: 'infoPrice',
                iconName: 'utility:hourglass',
                variant: 'border-filled',
                alternativeText: 'Info'
            }, sortable: true,
            hideDefaultActions: true
        }
    ];
    // handleDisciplineChange(event) {
    //     this.selectedDiscipline = event.target.value;
    //     this.checkSearchButtonState();
    // }
    async connectedCallback() {
        let sessionContext = await getSessionContext();
        // this.sfObjectIdMap.Account = sessionContext.effectiveAccountId;
        this.sfObjectIdMap.Account = '0015300000U1p4NAAR';
        console.log('check sfobject >::>;' + JSON.stringify(this.sfObjectIdMap));
    }
    // Event handler for text input change
    handleTextInputChange(event) {
        if (event.target.label == 'ISBN') {
            this.isbnValue = event.target.value;
        }
        else {
            this.titlekeyword = event.target.value;
        }
        this.checkSearchButtonState();
    }
    // Event handler for active products checkbox change
    handleActiveProductsChange(event) {
        this.activeProducts = event.target.checked;
        this.checkSearchButtonState();
    }
    // Check if search button should be enabled
    checkSearchButtonState() {
        this.searchDisabled = !this.selectedDiscipline && !this.titlekeyword;
    }
    // Handle search button click event
    handleSearch() {
        console.log('Search button Clicked');
        this.searchDisabled = true;
        searchProducts({ isbnValue: this.isbnValue, selectedDiscipline: this.selectedDiscipline, titlekeyword: this.titlekeyword, activeProducts: this.activeProducts })
            .then(result => {
                console.log('Search results:', result);
                var temp = [];
                this.columns.forEach(col => {
                    console.log('col:>' + JSON.stringify(col));
                    if (col.label == 'Price') {
                        temp.push({ "label": "Price", "fieldName": "Price", "type": "text", "sortable": "true" });
                    } else {
                        temp.push(col);
                    }
                });
                this.columns = [];
                this.columns = temp;
                console.log('check temp list:>:>' + JSON.stringify(temp));
                this.productData = result;
                this.records = result;

                console.log('All Data :: ', this.productData);

                if (this.productData != undefined) {
                    this.showSearchResultErrorMessage = false;
                    console.log('this.productData.length :: ', this.productData.length);
                    if (this.productData.length < 1) {
                        this.showSearchResultErrorMessage = true;
                        this.showResults = true;
                        console.log('this.showSearchResultErrorMessage :: ', this.showSearchResultErrorMessage, this.searchResultErrorMessage);
                    }
                    else if (this.productData.length >= 1) {
                        if (this.productData.length == 1) {
                            this.showTabset = false;
                            this.showResults = false;
                            this.showProductTitlePage = true;
                            this.selectedProductRecord = this.productData[0];
                        }
                    }
                }
                this.showResults = (this.productData.length) ? true : false;
                this.manualSearchBtnDisabled = true;
                this.error = undefined; // Reset error if any
                this.getProductDetails();
            })
            .catch(error => {
                console.log('Error fetching results:', error);
                this.error = error;
                this.productData = [];
                this.showResults = false;
            });
    }

   

    // Event handler for closing product title page
    closeChildTitlePage(event) {
        this.showProductTitlePage = false;
        this.showTabset = true;
        this.showResults = false;
        this.getactiveTabValue = event.detail.tabClose;
    }
    openChildTitlePage(event) {
        this.showProductTitlePage = true;
        this.showTabset = false;
        this.showResults = false;
        this.selectedProductRecord = event.detail.parentSelectedProductRecord;
    }
    // Handle clear button click event
    handleClear() {
        console.log('Clear button Clicked');
        this.isbnValue = '';
        this.selectedDiscipline = '';
        this.titlekeyword = '';
        this.activeProducts = true;
        this.searchDisabled = true;
        this.showResults = false;
        this.disableNext = true;
        this.productData = [];
        this.manualSearchBtnDisabled = false;
        this.showSearchResultErrorMessage = false;
        //Reload the window after clearing the search
        //window.location.reload();
        // location.reload();
        this.dispatchEvent(new RefreshEvent()); // Refresh the page
        console.log('reloaded');
    }
    get checkInputValues() {
        let boolVal = false;
        if (this.manualSearchBtnDisabled) {
            boolVal = true;
        }
        else if (this.selectedDiscipline == '' && this.isbnValue == '' && this.titlekeyword == '') {
            boolVal = true;
        }
        return boolVal;
    }
    // Event handler for showing product title page
    handleShowProductTitlePage(event) {
        this.showTabset = false;
        this.showProductTitlePage = true;
        this.selectedProductRecord = event.detail.parentSelectedProductRecord;
    }
    handleActive(event) {
        this.getactiveTabValue = event.target.value;
        if (this.getactiveTabValue === 'catalogSearch') {
            this.viewForCatalogSection = true;
        } else {
            this.viewForCatalogSection = false;
        }
    }
    // Table Related
    get bDisableFirst() {
        return this.pageNumber == 1;
    }
    get bDisableLast() {
        return this.pageNumber == this.totalPages;
    }
    onHandleSort(event) {
        console.log('onHandleSort :: ', event.detail);
        this.sortedBy = event.detail.fieldName;
        this.sortDirection = event.detail.sortDirection;
        this.sortData(this.sortedBy, this.sortDirection);
    }
    sortData(fieldname, direction) {
        console.log('sortData :: ', fieldname, direction);
        let parseData = JSON.parse(JSON.stringify(this.currentPagetableData));
        let keyValue = (element) => {
            return element[fieldname];
        };
        let isReverse = direction === 'asc' ? 1 : -1;
        parseData.sort((xElement, yElement) => {
            xElement = keyValue(xElement) ? keyValue(xElement) : '';
            yElement = keyValue(yElement) ? keyValue(yElement) : '';
            return isReverse * ((xElement > yElement) - (yElement > xElement));
        });
        this.currentPagetableData = parseData;
    }
    // Event handler for changing records per page
    handleRecordsPerPage(event) {
        this.pageSize = event.target.value;
        this.paginationHelper();
    }
    // Event handler for navigating to previous page
    previousPage() {
        this.pageNumber = this.pageNumber - 1;
        this.paginationHelper();
    }
    // Event handler for navigating to new page
    nextPage() {
        this.pageNumber = this.pageNumber + 1;
        this.paginationHelper();
    }
    firstPage() {
        this.pageNumber = 1;
        this.paginationHelper();
    }
    lastPage() {
        this.pageNumber = this.totalPages;
        this.paginationHelper();
    }
    // Handle pagination logic 
    paginationHelper() {
        this.currentPagetableData = [];
        // calculate total pages
        this.totalPages = Math.ceil(this.totalRecords / this.pageSize);
        // set page number 
        if (this.pageNumber <= 1) {
            this.pageNumber = 1;
        } else if (this.pageNumber >= this.totalPages) {
            this.pageNumber = this.totalPages;
        }
        // set records to display on current page 
        for (let i = (this.pageNumber - 1) * this.pageSize; i < this.pageNumber * this.pageSize; i++) {
            if (i === this.totalRecords) {
                break;
            }
            this.currentPagetableData.push(this.records[i]);
        }
    }
    handleRowAction(event) {
        // Handle button click action here
        const row = event.detail.row;
        const action = event.detail.action.name;
        console.log('Clicked row: ', row, action);
        if (action === 'infoPrice') {
            LightningAlert.open({
                // message: row.ISBN + ' -- ' + row.Price,
                message: 'Title: ' + row.Title_Description + '      ' + '\nISBN: ' + row.ISBN + '\nPrice: ' + row.Price,
                label: 'View Price', // this is the header text
                theme: 'gray-ish blue',
            }).then((result) => {
            });
        }
        if (action === 'viewRecords') {
            this.showProductTitlePage = true;
            this.selectedProductRecord = row;
            this.showTabset = false;
        }
    }
    // handleNext() {
    //     this.disableNext = true; 
    // }
    // Initialize pagination settings
    pageSizeOptions = [15, 25, 50, 75, 100]; //Page size options
    totalRecords = 0; //Total no.of records
    pageSize; //No.of records to be displayed per page
    totalPages; //Total no.of pages
    pageNumber = 1; //Page number  
    numberOfRows = '5';
handleFilter(event) {
     const searchTerm = event.target.value.trim();
    console.log('Filter Criteria Updated:', searchTerm);

    if (!searchTerm || searchTerm.length < 3 && !/^\d{3,}$/.test(searchTerm)) {
        console.log('Search term is too short or empty.');
        this.filterCriteria = ''; 
        // No need to send search term to B component, so no action needed here
    } else {
        // Split the search term by spaces to handle multiple terms
        const searchTerms = searchTerm.split(/\s+/).filter(term => term);

        // Set filter criteria based on different conditions
        if (searchTerms.length > 1) {
            // If search term contains multiple terms
            this.filterCriteria = searchTerm;
            console.log('Search term contains multiple terms:', searchTerm);
        } else if (/^\d{10,13}$/.test(searchTerm)) {
            // If search term is a valid 10 or 13 digit value
            this.filterCriteria = searchTerm;
            console.log('Search term identified as ISBN:', searchTerm);
        } else if (/^\d{1,5}$/.test(searchTerm)) {
            // If search term is a valid 1 to 5 digit value
            this.filterCriteria = searchTerm;
            console.log('Search term identified as price:', searchTerm);
        } else {
            // If search term is a general text
            this.filterCriteria = searchTerm;
            console.log('Search term identified as general text:', searchTerm);
        }
       
    }
     
}

}