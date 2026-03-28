import { LightningElement, track, wire, api } from 'lwc';
//import searchRecords from '@salesforce/apex/scc_quicksearchController.searchRecords';
import searchRecords from '@salesforce/apex/scc_productQuickSearch_Controller.searchRecords';
import { filterData } from 'c/testfilterresults'; // Import the filter helper function
export default class tespro extends LightningElement {

 
   

@ track filteredData=[];
    @track isFirstPage = true;
    @track isLastPage = true;
    @track selectedRecord;
    @track dropdownVisible = true;
    @track searchResults = [];
    @track recordIds = '';
    @track isSearchDisabled = true;
    @track sortBy;
    @track sortDirection;
    @track isselectedProductRecord = false;
    @track isquickSearch = true;
    @api currentproductid;
    @track selectedProductRecord;
    @track searchTerm;
    @track showTabset = true;
    @track interactedWithQuickSearch = false;
     @ track previousFilteredRecordCount = 0; 
     bDisableFirst=true;
     bDisableLast=true;
     bDisablePrevious =true;
     bDisableNext=true;



      // Initialize pagination settings
     @track pageSizeOptions = [15, 25, 50, 75, 100]; //Page size options
      @track pageSize  // Default page size
    records = []; //All records available in the data table
    columns = []; //columns information available in the data table
    totalRecords = 0; //Total no.of records
   // pageSize; //No.of records to be displayed per page
    totalPages; //Total no.of pages
    pageNumber = 1; //Page number    
    recordsToDisplay = []; //Records to be displayed on the page
 // Pagination Variables
    @track currentPagetableData = [];   
    selectedIdList = [];
    hideCheckbox = false;

    columns = [

       
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
                
            }
        },
       

        { label: 'Title Description', fieldName: 'Title_Description', type: 'text', sortable: true },

        { label: 'Type', fieldName: 'Type', type: 'text', sortable: true},
        { label: 'Grade', fieldName: 'Grade_Level', type: 'text', sortable: true },
        { label: 'Copyright', fieldName: 'Copyrightyear', type: 'text', sortable: true },
        { label: 'Status', fieldName: 'Status', type: 'text', sortable: true },
        { label: 'Price', fieldName: 'Price', type: 'decimal', sortable: true }
    ];

    
    

  handleInputChange(event) {
        const rawInput = event.target.value;
        const lines = rawInput.split('\n');
        const cleanedLines = lines.map(line => line.trim().replace(/[^\d]/g, ''));
        const nonEmptyLines = cleanedLines.filter(line => line.length > 0);
        this.recordIds = nonEmptyLines;
        this.isSearchDisabled = this.recordIds.length === 0;

    }
connectedCallback() {
console.log(this.pageSizeOptions)
}
  
    
    
    handleSearch() {
        console.log('Searching...');
        console.log('Record IDs:', this.recordIds); 

        if (this.recordIds.length > 0) {
            searchRecords({ recordIds: this.recordIds })
                .then(result => {
                    console.log('Processed Search Results:', result.length); 
                        this.records =result;
                        
                        this.productData=this.result;
                        this.totalRecords = result.length;
                        this.originalProductData = result; 
              this.pageSize = this.pageSizeOptions[0]; //set pageSize with default value as first option
                console.log('pageSize:', this.pageSize); // Add this logging statement
                console.log('pageSizeOptions[0]:', this.pageSizeOptions[0]); // Add this log
            this.paginationHelper(); 
                    this.searchResults = result.map(record => {
                      
                        return {
                            ...record.product,
                            price: record.price,
                            productid: record.productId,
                            ISBN: record.ISBN ? record.ISBN : this.getIsbnToDisplay(record.product),
                            Title_Description: record.Title_Description,
                            Grade_Level: record.Grade_Level,
                            Type: record.Type,
                            Status: record.Status,
                            Copyrightyear: record.Copyrightyear,
                            Price: record.Price
            
                            


                        };
                    });

                    console.log('Search Results:', this.searchResults); 
  
                  console.log('Search Results:',  this.pageSize); 
                    
                     this.originalSearchResults = [...this.searchResults];// Log the final search results
                  
                  
                     
                })
                .catch(error => {
                    console.error('Error occurred while fetching search results:', error); // Log any errors that occur during the search          
                });
        } else {
            console.log('No record IDs provided.'); // Log if no record IDs are provided
        }
    }

  
    handleSort(event) {
        console.log('allclear');
        const { fieldName, sortDirection } = event.detail;
        this.sortBy = fieldName;
        this.sortDirection = sortDirection;
        this.sortData(fieldName, sortDirection);
    }

    sortData(fieldName, direction) {
        let parsedData = JSON.parse(JSON.stringify(this.searchResults));
        let keyValue = (a) => {
            return a[fieldName] || '';
        };
        let isReverse = direction === 'asc' ? 1 : -1;
        parsedData.sort((x, y) => {
            let xValue = keyValue(x);
            let yValue = keyValue(y);
            return isReverse * ((xValue > yValue) - (yValue > xValue));
        });
        this.searchResults = parsedData;
    }


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
   // Inside paginationHelper function
paginationHelper() {
    console.log('Inside paginationHelper');
    this.currentPagetableData = [];
    // calculate total pages
    this.totalPages = Math.ceil(this.totalRecords / this.pageSize);
    console.log('totalPages:', this.totalPages);
    console.log('totalPages:', this.totalRecords);
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
        console.log('Pushed record:', this.records[i]); // Log the pushed record
    }
 this.updatePaginationStatus();
    console.log('currentPagetableData:', this.currentPagetableData); // Log currentPagetableData
}

    handleClear() {
        this.recordIds = '';
        this.searchResults = [];
        this.isSearchDisabled = true;


        const textAreaInput = this.template.querySelector('.text-area-inputchange textarea');
        if (textAreaInput) {
            textAreaInput.value = '';
        }
    }


    handleRowAction(event) {
        const action = event.detail.action;
        const row = event.detail.row;
        this.isquickSearch = false;
const activeTab = 'Quick Search'; 
 this.activeTabValue = event.detail.activeTabValue;
        //this.showTabset = false;
        console.log('Current Selected Product Record:', row);
        console.log('Current Selected Product Record:', action);

        if (action.name === 'viewRecords') {
          this.interactedWithQuickSearch = true; 
            this.selectedProductRecord = {
                ISBN: row.isbnToDisplay,
                productId: row.Id,
                Title_Description: row.Description,
                Grade_Level: row.Grade_Level__c,
                Copyright: row.Copyright_Year__c,
                 Status:row.Product_Status__c,
                 Type:row.Product_Sub_Type__c

            };


            console.log('selectedProductRecord:', this.selectedProductRecord);

            const selectEvent = new CustomEvent('showproducttitlepage', {
                detail: {
                    parentSelectedProductRecord: this.selectedProductRecord,
                   searchResults:this.searchResults

                }
            });
            this.dispatchEvent(selectEvent);
            console.log('Current Selected Product selectEvent:', selectEvent);
        }
    }
   
// handleSearchInputChange(event) {
//         this.searchTerm = event.target.value.trim();
//         console.log('Search term:', this.searchTerm);

//         if (this.searchTerm && this.searchTerm.length >= 3) {
//             // Filter the data
//             this.filteredData = filterData(this.originalProductData, this.searchTerm);
//             console.log('Filtered data:', this.filteredData);

//             // Update pagination and display the filtered data
//             this.updatePaginationAndDisplay(this.filteredData);
//         } else {
 
//             this.updatePaginationAndDisplay(this.originalProductData);
//             console.log('elsethis.originalProductData',this.originalProductData);
//         }
//     }

// updatePaginationAndDisplay(data) {
//     console.log('Before Filtered Data:', data);
//     console.log('Previous Product Data:', this.productData);
//     console.log('Previous Records:', this.records);
//     console.log('Previous Total Records:', this.totalRecords);
//     console.log('Previous Page Size:', this.pageSize);

//     this.productData = data || []; // Use the provided data or an empty array
//     this.records = this.productData;
//     this.totalRecords = this.records.length;

//     // If the page size exceeds the total filtered records, adjust the page size
//    this.totalPages = Math.ceil(this.totalRecords / this.pageSize);
// this.updatePaginationStatus();
//     // Reset page size to default if it exceeds the total records
 
//     // Update pagination
//     this.paginationHelper();

//     console.log('After Filtered Data:', data);
//     console.log('Updated Product Data:', this.productData);
//     console.log('Updated Records:', this.records);
//     console.log('Updated Total Records:', this.totalRecords);
//     console.log('Updated Page Size:', this.pageSize);
// }
// handleSearchInputChange(event) {
//     this.searchTerm = event.target.value.trim();
//     console.log('Search term:', this.searchTerm);

//     if (this.searchTerm && this.searchTerm.length >= 3) {
//         // Filter the entire dataset
//         this.filteredData = filterData(this.originalProductData, this.searchTerm);
//         console.log('Filtered data:', this.filteredData);

//         // Update pagination and display the filtered data
//         this.updatePaginationAndDisplay(this.filteredData);
//     } else {
//         // Reset the filter and display the original data
//         this.filteredData = null;
//         this.updatePaginationAndDisplay(this.originalProductData);
//         console.log('Original Product Data:', this.originalProductData);
//     }
// }

// handleSearchInputChange(event) {
//     const searchTerm = event.target.value.trim();
//     console.log('Original search term:', searchTerm);

//     let processedSearchTerm = searchTerm.trim();

//     // Check if the search term is an ISBN-13 or ISBN-10
//     if (/^\d{10,13}$/.test(processedSearchTerm)) {
//         console.log('Search term identified as ISBN:', processedSearchTerm);
//         processedSearchTerm = processedSearchTerm.replace(/\s+/g, ','); // Add commas for multiple ISBNs
//         console.log('Processed search term for ISBN:', processedSearchTerm);
//         this.filteredData = filterData(this.originalProductData, processedSearchTerm);
//         console.log('Filtered data for ISBN:', this.filteredData);
//     } else if (/^\d{1,5}$/.test(processedSearchTerm)) { // Check if the search term is a price
//         console.log('Search term identified as price:', processedSearchTerm);
//         this.filteredData = filterData(this.originalProductData, processedSearchTerm);
//         console.log('Filtered data for price:', this.filteredData);
//     } else { // General text search
//         console.log('Search term identified as general text:', processedSearchTerm);
//         this.filteredData = filterData(this.originalProductData, processedSearchTerm);
//         console.log('Filtered data for general text:', this.filteredData);
//     }

//     // Update pagination and display the filtered data
//     this.updatePaginationAndDisplay(this.filteredData);
// }

// Handle search input change event
// Handle search input change event
handleSearchInputChange(event) {
    const searchTerm = event.target.value.trim();
    console.log('Original search term:', searchTerm);

    // Check if the search term meets the minimum length requirement
    if (searchTerm.length < 3 && !/^\d{3,}$/.test(searchTerm)) {
        console.log('Search term is too short.');
        // Reset the filter and display the original data
        this.filteredData = null;
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

    // Apply the filter to the provided data or use the original data
    this.productData = data || [];
    this.records = this.productData;
    this.totalRecords = this.records.length;

    // Update the total pages based on the new total records
    this.totalPages = Math.ceil(this.totalRecords / this.pageSize);

    // Reset pagination to first page if necessary
    if (this.pageNumber > this.totalPages) {
        this.pageNumber = 1;
    }

    // Update pagination and display
    this.paginationHelper();

    console.log('After Filtered Data:', data);
    console.log('Updated Product Data:', this.productData);
    console.log('Updated Records:', this.records);
    console.log('Updated Total Records:', this.totalRecords);
    console.log('Updated Page Size:', this.pageSize);
}

get bDisableFirst() {
    return this.pageNumber == 1;
}

get bDisableLast() {
    return this.pageNumber == this.totalPages;
}

get bDisablePrevious () {
    return this.pageNumber == 1;
}

get bDisableNext() {
    return this.pageNumber == this.totalPages;
}
updatePaginationStatus() {
    this.bDisableFirst = this.pageNumber === 1 || this.totalPages <= 1;
    this.bDisableLast = this.pageNumber === this.totalPages || this.totalPages <= 1;
    this.bDisablePrevious = this.pageNumber === 1 || this.totalPages <= 1;
    this.bDisableNext = this.pageNumber === this.totalPages || this.totalPages <= 1;
}

}