import { LightningElement, api, track } from 'lwc';
import { filterData } from 'c/testfilterresults'; // Import the filter helper function
export default class testplaceorderidbntable extends LightningElement {
    @api columns;
    @track productQuantityData = [];
    @track rawChildTableData = [];
   _filter = '';
   @track filteredData = [];
       @track totalFilteredRecords = 0;
     
 @track orginaldata =[];
  
// @api searchTerm = ''; 

    totalRecords = 0;
    pageSizeOptions = [15, 25, 50, 75, 100]; //Page size options
    pageNumber = 1; //Page number 
    numberOfRows = '5';
    @track totalPages;
    defaultSortDirection;
    sortDirection;
    sortedBy;
    @api
    get rawParentTableData() {
        console.log('get', this.currentTableData);
        
        return this.currentTableData;
          
    }
    set rawParentTableData(value) {
        console.log('set', value);
        this.rawChildTableData = value;
       this.orginaldata = value;
         console.log('Total orginaldata Records:', this.orginaldata); 
        this.totalRecords = this.rawChildTableData.length;                 
        this.pageSize = this.pageSizeOptions[0]; 
        this.paginationHelper();
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
    // paginationHelper() {
    //     this.transformedChildTableData = [];
    //     // calculate total pages
    //     this.totalPages = Math.ceil(this.totalRecords / this.pageSize);
    //     // set page number 
    //     if (this.pageNumber <= 1) {
    //         this.pageNumber = 1;
    //     } else if (this.pageNumber >= this.totalPages) {
    //         this.pageNumber = this.totalPages;
    //     }
    //     // set records to display on current page 
    //     for (let i = (this.pageNumber - 1) * this.pageSize; i < this.pageNumber * this.pageSize; i++) {
    //         if (i === this.totalRecords) {
    //             break;
    //         }
    //         this.transformedChildTableData.push(this.rawChildTableData[i]);
    //     }
    // }

    paginationHelper() {
         console.log('Clicked paginationHelper: ');
    this.productQuantityData = [];
console.log('Clicked paginationHelper: ',this.productQuantityData);
    if (this.filteredData.length > 0) {
        console.log('Clicked filteredData: ',this.filteredData.length);
        // If filtered data is present, calculate total pages based on filtered data
        this.totalPages = Math.ceil(this.filteredData.length / this.pageSize);
         console.log('Clicked filtered: ',  this.totalPages);
    } else {
         console.log('Clicked filteredData: ');
        // If no filter is applied, calculate total pages based on total records
        this.totalPages = Math.ceil(this.totalRecords / this.pageSize);
    }

    // Ensure pageNumber is within valid range
    if (this.pageNumber <= 1) {
        this.pageNumber = 1;
    } else if (this.pageNumber > this.totalPages) {
        this.pageNumber = this.totalPages;
    }

  
  
        for (let i = (this.pageNumber - 1) * this.pageSize; i < this.pageNumber * this.pageSize; i++) {
            if (i === this.totalRecords) {
                break;
            }
            this.productQuantityData.push(this.rawChildTableData[i]);
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
            this.selectedProductRecord = row;
            
            const selectEvent = new CustomEvent('showproducttitlepage', {
                detail: {
                    parentSelectedProductRecord: this.selectedProductRecord,
                   

                }
            });
            this.dispatchEvent(selectEvent);
        }
    }
    get bDisableFirst() {
        return this.pageNumber == 1;
    }
    get bDisableLast() {
        return this.pageNumber == this.totalPages;
    }
    // Event handler for changing records per page
   handlePageChange(event) {
        this.pageNumber = event.target.value;
        // Update transformed data based on new page number
      
    }
 @api
    get filter() {
        return this._filter;
    }

    set filter(value) {
        this._filter = value;
        this.handleFilterChange();
    }

   handleFilterChange() {
        if (this._filter) {
            const lowerCaseFilter = this._filter.toLowerCase();
          
            this.filteredData = filterData(this.rawChildTableData, lowerCaseFilter);
            this.totalFilteredRecords = this.filteredData.length; // Update totalFilteredRecords property
            console.log('Total Filtered Records:', this.totalFilteredRecords); 
        this.rawChildTableData = this.filteredData;
        this.pageNumber = 1;
        this.totalPages = Math.ceil(this.totalFilteredRecords / this.pageSize)
        //  this.transformedChildTableData = this.filteredData;
           console.log('totalPages afterfilter:',  this.totalPages); 
             this.paginationHelper();
               console.log('Total rawChildTableData Records:',  this.rawChildTableData); 
                console.log('Total transformedChildTableData Records:',  this.transformedChildTableData); 
        } else {
           this.filteredData = [];
            this.totalFilteredRecords = 0;
            console.log('Total Filtered Records:', this.totalFilteredRecords); 
               this.rawChildTableData=this.orginaldata;
                this.pageNumber = 1; // Reset page number to 1 after removing filter
                this.totalPages = Math.ceil(this.totalRecords / this.pageSize);
                console.log('totalPages removed filter:',  this.totalPages);  // Update total pages based on original data
                console.log('after removing transformedChildTableData Records:',  this.transformedChildTableData); 
               this.paginationHelper();
        }
    }
      


     handleRecordsPerPage(event) {
        this.pageSize = event.target.value;
          console.log('Page size when clicking from options', this.pageSize);
        // Reset page number to 1 when changing page size
        this.pageNumber = 1;
         this.paginationHelper();
        // Update transformed data based on new page size
       
        
    }


}