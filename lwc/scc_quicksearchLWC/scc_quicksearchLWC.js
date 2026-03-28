import { LightningElement ,track,wire,api} from 'lwc';
import getEnableConsoleLogsTrue from '@salesforce/apex/scc_headerLWC_Controller.getEnableConsoleLogsTrue' ;
export default class scc_quicksearchLWC extends LightningElement {
  
    @track totalCount = 0;
    @track numberOfRows = 15 ; 
    @track currentPage = 1;
    @track totalPages = 0;
   @track startIndex = 0;
    @track endIndex = 0;
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
    @track isquickSearch= true;
     @api currentproductid;
     @track selectedProductRecord;
        // @api showTabset;
      @track showTabset=true;
      @track enableLogs = false;

 columns = [
    //   { label: 'ISBN', fieldName: 'isbnToDisplay', type: 'button', sortable: true,typeAttributes: { label: { fieldName: 'productId',type:'text',class:'custom-button'},name:'viewRecords', target: '_blank',class:'custom-button',variant: 'base' } }, 
   { 
    label: 'ISBN', 
    fieldName: 'isbnToDisplay', 
    type: 'button', 
    sortable: true,
    typeAttributes: { 
        label: { 
            fieldName: 'isbnToDisplay', // Corrected field name
            type: 'text' 
        },
        name: 'viewRecords', 
        target: '_blank', 
        class: 'custom-button', 
        variant: 'base' 
    } 
},
    { label: 'Title Description', fieldName: 'Description', type: 'text', sortable: true },
  
    { label: 'Type', fieldName: 'Material_Type__c', type: 'text', sortable: true },
    { label: 'Grade Level', fieldName: 'Grade_Level__c', type: 'text', sortable: true},
    { label: 'Copyright', fieldName: 'Copyright_Year__c', type: 'text', sortable: true },
    { label: 'Status', fieldName: 'Product_Status__c', type: 'text', sortable: true },
      { label: 'Price', fieldName: 'price', type: 'decimal', sortable: true }
];

   
    toggleDropdown() {        
        this.dropdownVisible = !this.dropdownVisible;
    }
 get firstButtonClass() {
    return this.isFirstPage ? 'pagination-button-disabled' : 'pagination-button-enabled';
}

get previousButtonClass() {
    return this.isFirstPage ? 'pagination-button-disabled' : 'pagination-button-enabled';
}

get nextButtonClass() {
    return this.isLastPage ? 'pagination-button-disabled' : 'pagination-button-enabled';
}

get lastButtonClass() {
    return this.isLastPage ? 'pagination-button-disabled' : 'pagination-button-enabled';
}

    get dropdownClass() {
        return this.dropdownVisible ? 'dropdown-visible' : 'dropdown-hidden';
    }

 
  
    connectedCallback() {
        getEnableConsoleLogsTrue().then(response => {
            this.enableLogs = response;
            if(this.enableLogs){
                console.log('getEnableConsoleLogsTrue response is',response);
            }
        }).catch(error => {
            if(this.enableLogs){
                console.log('error is', error);
            }
        })
    }

handleInputChange(event) {
const rawInput = event.target.value;
const lines = rawInput.split('\n');
const cleanedLines = lines.map(line => line.trim().replace(/[^\d]/g, ''));
const nonEmptyLines = cleanedLines.filter(line => line.length > 0);
this.recordIds = nonEmptyLines;
this.isSearchDisabled = this.recordIds.length === 0;
   
}
   
handleSearch() {    

    if (this.recordIds.length > 0) {
        searchRecords({ recordIds: this.recordIds })
            .then(result => {
                if(this.enableLogs){
                console.log('Processed Search Results:', result); // Log the processed search results
                }
                const numberOfRecordsPerPage = this.numberOfRows; 
                const startIndex = (this.currentPage - 1) * numberOfRecordsPerPage;
                const endIndex = startIndex + numberOfRecordsPerPage;                
                this.searchResults = result.slice(startIndex, endIndex).map(record => { 
                    if(this.enableLogs){
                    console.log('Record:', record); // Log the current record being processed
                    }
                    return {
                        ...record.product, 
                        price: record.price ,
                        productid:record.productId,
                        isbnToDisplay: record.isbnToDisplay ? record.isbnToDisplay : this.getIsbnToDisplay(record.product),
                    };   
                });
                if(this.enableLogs){
                    console.log('Search Results:', this.searchResults); // Log the final search results
                }
                this.totalCount = result.length;              
                this.updatePagination();
            })
            .catch(error => {  
                console.error('Error occurred while fetching search results:', error); // Log any errors that occur during the search          
            });
    } else {
        if(this.enableLogs){
            console.log('No record IDs provided.'); // Log if no record IDs are provided
        }
    }
}

 getIsbnToDisplay(product) {
        return product.ISBN10__c ? product.ISBN10__c : product.ISBN13__c;
    }
  handleSort(event) {      
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



handleChangeRowsPerPage(event) {
    this.numberOfRows = parseInt(event.target.value, 10);
    this.currentPage = 1;
    this.handleSearch(); // Fetch updated results based on new number of rows per page
}


updatePagination() {
   
    const startIndex = (this.currentPage - 1) * this.numberOfRows;
    const endIndex = Math.min(startIndex + this.numberOfRows - 1, this.totalCount - 1);
    
    
    this.totalPages = Math.ceil(this.totalCount / this.numberOfRows);
    this.isFirstPage = this.currentPage === 1;
    this.isLastPage = this.currentPage === this.totalPages;
}

navigateToFirstPage() {    
    this.currentPage = 1;
    this.updatePagination();
}

navigateToPreviousPage() {    
    if (this.currentPage > 1) {
        this.currentPage--;
         this.handleSearch();
    }
}

navigateToNextPage() {   
    if (this.currentPage < this.totalPages) {
        this.currentPage++;
        this.handleSearch();
    }
}

navigateToLastPage() {    
    this.currentPage = this.totalPages;
   this.handleSearch();
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
   this.isquickSearch=false;
        

    if (action.name === 'viewRecords') {
        // Accessing the product ID directly from row.productId
        // Constructing the selected product record object
        this. selectedProductRecord = { 
                ISBN: row.isbnToDisplay,
                productId: row.Id,
                Description: row.Description, // Add additional fields as needed
                Grade_Level: row.Grade_Level__c,
                Copyright_Year: row.Copyright_Year__c

        };
   
        if(this.enableLogs){
            console.log('selectedProductRecord:', this.selectedProductRecord);
        }
        const selectEvent = new CustomEvent('showproducttitlepage', {
            detail: { parentSelectedProductRecord: this.selectedProductRecord ,
                      
}
        });
        this.dispatchEvent(selectEvent);
        if(this.enableLogs){
        console.log('Current Selected Product selectEvent:', selectEvent);
        }
    }
}
 closeChildTitlePage(event) {

        this.isselectedProductRecord = false;
        this.isquickSearch = true;
       this.searchResults=false;           
    }

}