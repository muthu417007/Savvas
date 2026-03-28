/*
Lightning Web component: Scc_productCriteriaSearchLWC
Author: CTS (Sanika Sol)
Created Date: 03/04/2024
Reason: Backend logic for Scc_productCriteriaSearchLWC.
Modified Date: 15/04/2024
*/
import { LightningElement, wire, track,api } from 'lwc';
import searchProducts from '@salesforce/apex/scc_productCriteriaSearch.searchProducts';
import errormessage from '@salesforce/label/c.scc_productcriteriaerrormessage';
import LightningAlert from 'lightning/alert';
import { RefreshEvent } from 'lightning/refresh';
import { filterData } from 'c/testfilterresults'; // Import the filter helper function

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
    @track searchTerm;
  

    // Initialize pagination settings
     pageSizeOptions = [15, 25, 50, 75, 100]; //Page size options
    records = []; //All records available in the data table
    columns = []; //columns information available in the data table
    totalRecords = 0; //Total no.of records
    pageSize; //No.of records to be displayed per page
    totalPages; //Total no.of pages
    pageNumber = 1; //Page number    
    recordsToDisplay = []; //Records to be displayed on the page

    searchResultErrorMessage = errormessage;
    manualSearchBtnDisabled = false;
    showProductTitlePage = false;
    showTabset = true;
    selectedProductRecord = {};
    showSearchResultErrorMessage = false;
    numberOfRows = '5';

    // Pagination Variables
    @track currentPagetableData = [];   
    selectedIdList = [];
    hideCheckbox = false;
    @track originalProductData=[];
        

    



    // Define columns for the lightning-datatable
    columns = [
        // {
        //     label: 'ISBN',
        //     fieldName: 'ISBN',
        //     type: 'button',
        //     typeAttributes: { label: { fieldName: 'ISBN', type: 'text' }, name: 'viewRecords', target: '_blank', class: 'custom-button', variant: 'base' },
        //     sortable: true
        // },
         {
             label: 'ISBN',
fieldName: 'ISBN',
type: 'Number',
sortable: true,
typeAttributes: {
    label: {
        fieldName: 'ISBN', 
        type: 'text'
    },
    name: 'viewRecords',
    min: 0, // Add the min attribute
    step: 1, // Add the step attribute
   // Add the onchange attribute
    'data-index': index // Add the data-index attribute
}
},
        { label: 'Title Description', fieldName: 'Title_Description', sortable: true, type: 'text'},
        { label: 'Type', fieldName: 'Type', type: 'text', sortable: true, wrapText: true },
        { label: 'Grade Level', fieldName: 'Grade_Level', type: 'text', sortable: true },
        { label: 'Copyright', fieldName: 'Copyright', type: 'text', sortable: true },
        { label: 'Status', fieldName: 'Status', type: 'text', sortable: true},
        {
            label: 'Price',
            type: 'button-icon',
            initialWidth: 80,
            typeAttributes: {
                name: 'infoPrice',
                iconName: 'utility:hourglass',
                variant: 'border-filled',
                alternativeText: 'Info'
            },sortable: true ,
            hideDefaultActions : true
        }
    ];
     
    // handleDisciplineChange(event) {
    //     this.selectedDiscipline = event.target.value;
    //     this.checkSearchButtonState();
    // }

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

    get bDisableFirst() {
        return this.pageNumber == 1;
    }

    get bDisableLast() {
        return this.pageNumber == this.totalPages;
    }
    // Handle search button click event
  
  

    // Event handler for closing product title page
    closeChildTitlePage(event) {
        this.showProductTitlePage = false;
        this.showTabset = true;
        this.showResults = false;
        this.getactiveTabValue = event.detail.tabClose;
        
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
    handleNext() {
        this.disableNext = true; // Disable next button for now (sample)
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
        console.log('this.pageSize',this.pageSize);

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

    // Event handler for showing product title page
    handleShowProductTitlePage(event) {
        this.showTabset = false;
        this.showProductTitlePage = true;
      
        this.selectedProductRecord = event.detail.parentSelectedProductRecord;
    }
     handleActive(event){ 
        this.getactiveTabValue = event.target.value;
        console.log('Active Tab Value from active:', this.getactiveTabValue);
    
            console.log('Active Tab Value from active:', this.getactiveTabValue);  
}

    handleSearchInputChange(event) {
    const searchTerm = event.target.value.trim();
    console.log('Original search term:', searchTerm);

    // Check if the search term is empty or null
    if (!searchTerm || searchTerm.length < 3 && !/^\d{3,}$/.test(searchTerm)) {
        console.log('Search term is too short or empty.');
        // Reset the filter and display the original data
        this.filteredData = null;
        // Set default values
        this.totalRecords = 0;
        this.pageSize = 15; // Set your default page size here
        this.updatePaginationAndDisplay(this.originalProductData);
        console.log('Original Product Data:', this.originalProductData);
        return;
    }

    // Split the search term by spaces to handle multiple ISBNs
    const searchTerms = searchTerm.split(/\s+/).filter(term => term); // Remove empty strings

    let filteredData;

    // Check if the search term contains multiple ISBNs
    if (searchTerms.length > 1) {
        console.log('Search term contains multiple ISBNs:', searchTerms);
        // Combine the filtered results for each ISBN
        filteredData = searchTerms.map(term => filterData(this.originalProductData, term))
                                    .reduce((acc, cur) => acc.concat(cur), []); // Flatten the array
    } else {
        // Check if the search term is an ISBN, price, or general text
        if (/^\d{10,13}$/.test(searchTerm)) {
            console.log('Search term identified as ISBN:', searchTerm);
            filteredData = filterData(this.originalProductData, searchTerm);
        } else if (/^\d{1,5}$/.test(searchTerm)) {
            console.log('Search term identified as price:', searchTerm);
            filteredData = filterData(this.originalProductData, searchTerm);
        } else {
            console.log('Search term identified as general text:', searchTerm);
            filteredData = filterData(this.originalProductData, searchTerm);
        }
    }

    console.log('Filtered data:', filteredData);

    // Update pagination and display the filtered data
    this.updatePaginationAndDisplay(filteredData);
}

updatePaginationAndDisplay(data) {
    console.log('Before Filtered Data:', data);
    console.log('Previous Product Data:', this.productData);
    console.log('Previous Records:', this.records);
    console.log('Previous Total Records:', this.totalRecords);
    console.log('Previous Page Size:', this.pageSize);

    this.productData = data || []; // Use the provided data or an empty array
    this.records = this.productData;
    this.totalRecords = this.records.length;

    // If the page size exceeds the total filtered records, adjust the page size
    if (this.pageSize > this.totalRecords) {
        this.pageSize = this.totalRecords;
    }

    // Reset page size to default if it exceeds the total records
 
    // Update pagination
    this.paginationHelper();

    console.log('After Filtered Data:', data);
    console.log('Updated Product Data:', this.productData);
    console.log('Updated Records:', this.records);
    console.log('Updated Total Records:', this.totalRecords);
    console.log('Updated Page Size:', this.pageSize);
}
handleSearch() {
        console.log('Search button Clicked');
        this.searchDisabled = true;
        searchProducts({ isbnValue: this.isbnValue, selectedDiscipline: this.selectedDiscipline, titlekeyword: this.titlekeyword, activeProducts: this.activeProducts })
            .then(result => {
                console.log('Search results:', result);
                 this.originalProductData = result; 
                this.productData = result;

            this.records = result;
            this.totalRecords = result.length; // update total records count                 
            this.pageSize = this.pageSizeOptions[0]; //set pageSize with default value as first option
            this.paginationHelper(); // call helper menthod to update pagination logic 
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
                this.showResults =( this.productData.length) ? true : false;
                this.manualSearchBtnDisabled = true;
                this.error = undefined; // Reset error if any

            })
            .catch(error => {
                console.log('Error fetching results:', error);
                this.error = error;
                this.productData = [];
                this.showResults = false;
            });
    }

}