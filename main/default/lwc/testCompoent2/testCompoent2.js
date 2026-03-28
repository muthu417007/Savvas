import { LightningElement ,track,wire} from 'lwc';
import searchRecords from '@salesforce/apex/testController.searchRecords';

export default class testCompoent2 extends LightningElement {
  
    @track totalCount = 0;
    @track numberOfRows = 15 ; 
    @track currentPage = 1;
    @track totalPages = 0;
   @track startIndex = 0;
    @track endIndex = 0;
    @track isFirstPage = true;
    @track isLastPage = true;
   
    @track dropdownVisible = true;
    @track searchResults = [];
    @track recordIds = '';
    @track isSearchDisabled = true;
   // @track price






columns = [
    { label: 'ISBN', fieldName: 'ISBN13__c', type: 'url', sortable: true, typeAttributes: { label: { fieldName: 'ISBN13__c' }, target: '_blank' } },
    { label: 'Title Description', fieldName: 'Description', type: 'text', sortable: true },
  
    { label: 'Type', fieldName: 'Material_Type__c', type: 'text', sortable: true },
    { label: 'Grade Level', fieldName: 'Grade_Level__c', type: 'text', sortable: true},
    { label: 'Copyright', fieldName: 'Copyright_Year__c', type: 'text', sortable: true },
    { label: 'Status', fieldName: 'Product_Status__c', type: 'text', sortable: true },
      { label: 'Price', fieldName: 'price', type: 'decimal', sortable: true }
];

   
    toggleDropdown() {
        console.log('Dropdown visibility toggled');
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

  get searchButtonClass() {
        return this.isSearchDisabled ? 'search-button-disabled' : 'search-button-enabled';
    }

  
    connectedCallback() {
       // console.log('Component initialized');
        //this.searchRecords();
    }

   /* handleInputChange(event) {
        console.log('Input value changed.');

    this.recordIds = event.target.value.split('\n');
    console.log('Input value changed.');

    console.log('Input value changed. Record IDs:', this.recordIds);
    console.log('Input value changed. Record IDs:',this.recordIds.length);
      this.isSearchDisabled = this.recordIds.length === 0;
    console.log('Input value changed. Record IDs:',this.isSearchDisabled);
    console.log('Input value changed. Record IDs:',this.recordIds.length);
}*/
handleInputChange(event) {
    console.log('Input value changed.');

 
    const rawInput = event.target.value;

  
    const lines = rawInput.split('\n');

   
    const cleanedLines = lines.map(line => line.trim().replace(/[^\d]/g, ''));

    
    const nonEmptyLines = cleanedLines.filter(line => line.length > 0);

   
    this.recordIds = nonEmptyLines;

  
    console.log('Input value changed. Record IDs:', this.recordIds);
    console.log('Number of cleaned record IDs:', this.recordIds.length);
    this.isSearchDisabled = this.recordIds.length === 0;
    console.log('Is search disabled:', this.isSearchDisabled);
}

 
    /* handleSearch() {
        console.log('Search button clicked');
        if (this.recordIds.length > 0) {
            console.log('Search button clicked'+this.recordIds);
            searchRecords({ recordIds: this.recordIds })
                .then(result => {
                    console.log('Search results:', result);
                    this.searchResults = result;
                    this.totalCount = result.length
                    this.currentPage = 1;
                    this.updatePagination();
                })
                .catch(error => {
                    console.error('Error while fetching search results:', error);
                });
        }
    }*/
  /*handleSearch() {
    console.log('Search button clicked');
    if (this.recordIds.length > 0) {
        console.log('Search button clicked', this.recordIds);
        searchRecords({ recordIds: this.recordIds })
            .then(result => {
                console.log('Search results:', result);
                const numberOfRecordsPerPage = this.numberOfRows; // Get the number of rows per page
                 console.log('Search results:', result);
                const startIndex = (this.currentPage - 1) * numberOfRecordsPerPage;
                const endIndex = startIndex + numberOfRecordsPerPage;
                console.log('Start Index:', startIndex);
                console.log('End Index:', endIndex);
                this.searchResults = result.slice(startIndex, endIndex);
                console.log('Displayed Search Results:', this.searchResults);
                this.totalCount = result.length;
                 this.updatePrice(); 
                console.log('Total Count:', this.totalCount);
                this.updatePagination();
            })
            .catch(error => {
                console.error('Error while fetching search results:', error);
            });
    }
}
*/
/*handleSearch() {
    console.log('Search button clicked');
    if (this.recordIds.length > 0) {
        console.log('Search button clicked', this.recordIds);
        searchRecords({ recordIds: this.recordIds })
            .then(result => {
                console.log('Search results:', result);
                const numberOfRecordsPerPage = this.numberOfRows; // Get the number of rows per page
                console.log('Search results:', result);
                const startIndex = (this.currentPage - 1) * numberOfRecordsPerPage;
                const endIndex = startIndex + numberOfRecordsPerPage;
                console.log('Start Index:', startIndex);
                console.log('End Index:', endIndex);
                // Map the search results to dynamically handle price field
                this.searchResults = result.map(record => {
                    return {
                        ...record,
                        Price: this.getPriceField(record)
                    };
                }).slice(startIndex, endIndex);
                console.log('Displayed Search Results:', this.searchResults);
                this.totalCount = result.length;
                
                console.log('Total Count:', this.totalCount);
                this.updatePagination();
            })
            .catch(error => {
                console.error('Error while fetching search results:', error);
            });
    }
}*/
handleSearch() {
    console.log('Search button clicked');
    if (this.recordIds.length > 0) {
        console.log('Search button clicked', this.recordIds);
        searchRecords({ recordIds: this.recordIds })
            .then(result => {
                console.log('Search results:', result);
                const numberOfRecordsPerPage = this.numberOfRows; // Get the number of rows per page
                console.log('Search results:', result);
                const startIndex = (this.currentPage - 1) * numberOfRecordsPerPage;
                const endIndex = startIndex + numberOfRecordsPerPage;
                console.log('Start Index:', startIndex);
                console.log('End Index:', endIndex);
                // Map the search results to dynamically handle price field
               
              /*  this.searchResults = result.map(record => {
                    console.log('Processing record:', record);
                     const price = this.getPriceField(record);
                     console.log('this.price1:', this.getPriceField(record));
                    console.log('price:', price);
                    return {
                        ...record,
                        Net_Price__c : price
                    };
                }).slice(startIndex, endIndex);*/
                 this.searchResults = result.slice(startIndex, endIndex).map(record => {
                    console.log('Processing record:', record);
                      console.log('Price:', record.price); 
                       console.log('Net Price:', record.product.Net_Price__c);
                    return {
                        ...record.product, // Assuming `product` contains the relevant fields
                        price: record.price // Directly assigning the price
                        
                        
                    };
                   

                });
                console.log('Displayed Search Results:', this.searchResults);
                this.totalCount = result.length;
                
                console.log('Total Count:', this.totalCount);
                this.updatePagination();
            })
            .catch(error => {
                console.error('Error while fetching search results:', error);
            });
    }
}

getPriceField(record) {
    // Determine which price field to display based on the record data
    if (record.isInternational && record.listPrice) {
        console.log('clas1',record.listPrice);
        return record.listPrice;
        
    } else if (!record.isInternational && record.netPrice) {
        console.log('class2',record.netPrice);
        return record.netPrice;
    } else {
        console.log('class3',record.customerPrice);
        return record.customerPrice;
    }
}



handleChangeRowsPerPage(event) {
    this.numberOfRows = parseInt(event.target.value, 10);
    this.currentPage = 1;
    this.handleSearch(); // Fetch updated results based on new number of rows per page
}

updatePagination() {
    // Calculate startIndex and endIndex based on currentPage and numberOfRows
    const startIndex = (this.currentPage - 1) * this.numberOfRows;
    const endIndex = Math.min(startIndex + this.numberOfRows - 1, this.totalCount - 1);
    
    // Update searchResults with the subset of data based on pagination
    //this.searchResults = this.searchResults.slice(startIndex, endIndex + 1);

    // Update other pagination properties as before
    this.totalPages = Math.ceil(this.totalCount / this.numberOfRows);
    this.isFirstPage = this.currentPage === 1;
    this.isLastPage = this.currentPage === this.totalPages;
}

navigateToFirstPage() {
    console.log('Navigating to first page...');
    this.currentPage = 1;
    this.updatePagination();
}

navigateToPreviousPage() {
    console.log('Navigating to previous page...');
    if (this.currentPage > 1) {
        this.currentPage--;
         this.handleSearch();
    }
}

navigateToNextPage() {
    console.log('Navigating to next page...');
    if (this.currentPage < this.totalPages) {
        this.currentPage++;
        this.handleSearch();
    }
}

navigateToLastPage() {
    console.log('Navigating to last page...');
    this.currentPage = this.totalPages;
   this.handleSearch();
}

}