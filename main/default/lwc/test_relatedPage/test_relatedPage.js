import { LightningElement, track, api, wire } from 'lwc';
import getRelatedProducts from '@salesforce/apex/scc_relatedProductsLWC_Controller.getAllRelatedproducts';
import { filterData } from 'c/scc_filterResults';// filter 
//import { filterData } from 'c/filterResults'; // filter filterData
// Define a class to wrap product quantity data
class ProductQuantityWrapper {
  constructor(productId, productDetails, quantity = '0',  disableQuantity = false) {
    this.productId = productId;
    this.productDetails = productDetails;
    this.quantity = quantity;
    this.disableQuantity = disableQuantity;
   
    
  }

  getInActiveQuantityField() {
    return (this.hideCheckbox || !this.activeQuantity);
  }
}

export default class Test_relatedPage extends LightningElement {
  @track transformedChildTableData = [];
  @track rawChildTableData = [];
  @track productDetails;
  searchTerm ='';
  // filter 
  _filter = '';
  @track filteredData = [];
  @track totalFilteredRecords = 0;
  @track orginaldata =[];

  // Properties
  @track productData = [];
  @track productQuantityData = []; // Initialize productQuantityData

  @api message;
  showRelatedTitlePage = false;
  showResults = true;
  records = []; // All records available in the data table
  totalRecords = 0; // Total no.of records
  pageSize; // No.of records to be displayed per page
  totalPages=0;// Total no.of pages
  pageNumber = 1; // Page number
  recordsToDisplay = []; // Records to be displayed on the page

  //pagnation
  totalRecords = 0;
  pageSizeOptions = [15, 25, 50, 75, 100];
  pageNumber = 1; //Page number 
  numberOfRows = '15';
  
  displayedRecords=0;
     _parentname='';

  @api
  get rawParentTableData() {
      console.log('get', this.currentTableData);
      return this.currentTableData;
  }
  set rawParentTableData(value) {
      console.log('set', value);
      this.rawChildTableData = value;
      console.log('this.rawChildTableData',this.rawChildTableData);
      this.orginaldata = value;// filter
      console.log('orginaldata>>>>', value);
      this.totalRecords = this.rawChildTableData.length;
      console.log('this.totalRecords>>>', value);
      this.pageSize = this.pageSizeOptions[0];
      console.log('this.pageSize>>>', this.pageSize);
      this.paginationHelper();
  }

    //get filter search value sprint 4 workitem 

    @api
    get filter() {
        return this._filter;
    }

    set filter(value) {
        this._filter = value;
        this.handleFilter();
    }
    @api 
    get parentname() {
      return this._parentName; 
    }

    set parentname(value) {
        console.log('set', value);
        this._parentname  = value;
        this.message=value
        console.log(this._parentname,'valdmf' );
    }

  // Lifecycle hooks
  connectedCallback() {
    console.log('message from', this.message);
  }
  relatedProducts;
  
  // Wire service to fetch related products
  @wire(getRelatedProducts, { productId: '$message' })
  wiredRelatedProducts({ error, data }) {
    if (data) {
      this.relatedProducts = data;
      this.originalProductData=data;
      console.log('originalProductData:', this.originalProductData);
      console.log('relatedProducts:', this.relatedProducts);
      this.updateProductData();
    } else if (error) {
      console.error('Error fetching related products:', error);
    }
  }

  // Update product data
  updateProductData() {
    this.productData = Object.assign([], this.relatedProducts);
    for (let index = 0; index < this.productData.length; index++) {
      if (index == 15) {
        break;
      }
      let oneProductQuantity = new ProductQuantityWrapper(
        this.productData[index].Id,
        this.productData[index],
        '0',
        false
        
      );
      this.productQuantityData.push(oneProductQuantity);
      console.log(this.productQuantityData);
    };

    // Call any other methods or perform additional operations as needed
    this.paginationHelper();
  }

  

  // Close title page
  closeTitlePage(event) {
    this.showRelatedTitlePage = false;
    this.showResults = true;
    const sendCustomEventToopenTitlePage = new CustomEvent("opentitlepage");
    this.dispatchEvent(sendCustomEventToopenTitlePage);
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
    get bDisableFirst() {
        return this.pageNumber == 1;
    }
    get bDisableLast() {
        return this.pageNumber == this.totalPages;
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
    get bDisableFirst() {
        return this.pageNumber == 1;
    }
    get bDisableLast() {
        return this.pageNumber == this.totalPages;
    }

    paginationHelper() {
    console.log('Clicked paginationHelper: ');
    try {
    this.transformedChildTableData = [];
    // Calculate total pages
    if (this.filteredData.length > 0) {
        this.totalPages = Math.ceil(this.filteredData.length / this.pageSize);
    } else {
        this.totalPages = Math.ceil(this.totalRecords / this.pageSize);
    }

    // Ensure pageNumber is within valid range
    if (this.pageNumber <= 1) {
        this.pageNumber = 1;
    } else if (this.pageNumber > this.totalPages) {
        this.pageNumber = this.totalPages;
    }

    // Determine start and end indices for the current page
    const startIndex = (this.pageNumber - 1) * this.pageSize;
    const endIndex = Math.min(startIndex + this.pageSize, this.rawChildTableData.length); // Adjust endIndex calculation

    // Populate transformedChildTableData for the current page
    for (let i = startIndex; i < endIndex; i++) {
        const item = this.rawChildTableData[i];
        console.log('the values in transformedChildTableData ', item);
        this.transformedChildTableData.push(item);
        this.displayedRecords = this.transformedChildTableData.length;
        let currentRecordId =item.productDetails.productId;
        let customName = item.productDetails.ISBN;
        let customPrice = '100';
        let rowValue =item.quantity;
        if(rowValue > 0){
         this.addProductsToCart(currentRecordId, rowValue, customPrice, customName);
        }
    }

    //added by vaibhav for pricing connetcor starts
    console.log('this.this.transformedChildTableData',this.transformedChildTableData);
    if(this.transformedChildTableData.length >0){
        this.getProductDetails();
    }
    //added by vaibhav for pricing connetcor ends
    this.updateTransformedDataLength();
    }
    catch(err) {
        console.log('error is',err);
    }
}
    
  
  tableRowAction(event) {
    let fieldName = event.target.dataset.fieldName;
    let rowId = event.target.dataset.rowId;
    console.log('tableRowAction ::  ', rowId, fieldName);
    let local_productQuantityData = this.productQuantityData;
   
    if (fieldName == 'quantityCount') {
      let rowValue = event.target.value;
      let rowIndex = local_productQuantityData.findIndex(element => element.productDetails.Id === rowId);
      let rowInfo = local_productQuantityData[rowIndex];
      rowInfo.quantity = rowValue;
      local_productQuantityData[rowIndex] = rowInfo;
    }
    if (fieldName == 'isbnId') {
        let rowIndex = local_productQuantityData.findIndex(element => element.productDetails.Id === rowId);
        let rowInfo = local_productQuantityData[rowIndex];
        // Create a custom event with the action and row details
        const rowActionEvent = new CustomEvent('rowaction', {
            detail: {
                action: 'viewRecords',
                row: rowInfo.productDetails
            }
        });
        this.handleRowAction(rowActionEvent);
    }
    this.productQuantityData = Object.assign([], local_productQuantityData);
}
  //   if (fieldName == 'isbnId') {
  //     let rowIndex = local_productQuantityData.findIndex(element => element.productDetails.Id === rowId);
  //     let rowInfo = local_productQuantityData[rowIndex];
  //     this.handleRowAction(rowInfo.productDetails, 'viewRecords');
  //   }
  //   this.productQuantityData = Object.assign([], local_productQuantityData);
  // }
  handleRowAction(event) {
    const action = event.detail.action;
    const row = event.detail.row;

    // Handle the row action
    this.selectedProductRecord = row.Id;
    this.selectedISBN = row.ISBN13__c;
    this.showRelatedTitlePage = true;

    // Create and dispatch the custom event
    const selectedEvent = new CustomEvent("selectedproduct", { detail: row });
    this.dispatchEvent(selectedEvent);
}
  // Handle row action
  // handleRowAction(event) {
  //   const rowId = event.target.dataset.rowId;
  //   const rowIndex = this.productQuantityData.findIndex(product => product.productDetails.Id === rowId);
  //   const row = this.productQuantityData[rowIndex];
  //   console.log('Selected row:', row);

  //   // Custom event to notify parent component about the selected product
  //   const selectedEvent = new CustomEvent("selectedproduct", { detail: row.productDetails });
  //   this.dispatchEvent(selectedEvent);

  //   // Show title page
  //   //this.showRelatedTitlePage = true;
  //   //this.showResults = false;
  // }

  // Product search button section config
  isAddToSelectedToCartBtnDisabled = false;
  productSearchBtnSectionConfig = {
    addSelectedToCartBtnLabel: 'Add Selected (number) To Cart',
    addSelectedToCartBtnDisabled: true,
    clearCartBtnLabel: 'Clear Cart (number)',
    clearCartBtnDisabled: true,
    reviewCartLabel: 'Review Cart (number)',
    reviewCartDisabled: true,
    productAddedToCart: 0
  }

  // Get display product search button section config
  get displayProductSearchBtnSectionConfig() {
    let local_ProductSearchBtnSectionConfig = Object.assign({}, this.productSearchBtnSectionConfig);
    local_ProductSearchBtnSectionConfig.addSelectedToCartBtnLabel = local_ProductSearchBtnSectionConfig.addSelectedToCartBtnLabel.replace(/number/g, local_ProductSearchBtnSectionConfig.productAddedToCart);
    local_ProductSearchBtnSectionConfig.clearCartBtnLabel = local_ProductSearchBtnSectionConfig.clearCartBtnLabel.replace(/number/g, local_ProductSearchBtnSectionConfig.productAddedToCart);
    local_ProductSearchBtnSectionConfig.reviewCartLabel = local_ProductSearchBtnSectionConfig.reviewCartLabel.replace(/number/g, local_ProductSearchBtnSectionConfig.productAddedToCart);
    return local_ProductSearchBtnSectionConfig;
  }

  // Add to selected to cart handle click
  addToSelectedToCartHandleClick(event) {
    this.productSearchBtnSectionConfig.addSelectedToCartBtnDisabled = true;
    this.productSearchBtnSectionConfig.clearCartBtnDisabled = false;
    this.productSearchBtnSectionConfig.reviewCartDisabled = false;

    let local_productQuantityData = this.productQuantityData;
    for (let productDetails of local_productQuantityData) {
      productDetails.disabledCheckbox = true;
      if (productDetails.checkboxValue) {
        productDetails.hideCheckbox = true;
        productDetails.disableQuantity = true;
      }
    }
    this.productQuantityData = Object.assign([], local_productQuantityData);
  }

  // Clear cart handle click
  clearCartHandleClick(event) {

  }

  // Review cart handle click
  reviewCartHandleClick(event) {

  }

  // Task type help text class
  taskTypeHelpTextClass = 'slds-popover slds-popover_tooltip slds-nubbin_bottom-right slds-fall-into-ground slds-hide';

  // Toggle password hint
  togglePasswordHint() {
    let hideCss = 'slds-popover slds-popover_tooltip slds-nubbin_bottom-right slds-fall-into-ground slds-hide';
    let showCss = 'slds-popover slds-popover_tooltip slds-nubbin_bottom-right slds-rise-from-ground';
    this.taskTypeHelpTextClass = this.taskTypeHelpTextClass == hideCss ? showCss : hideCss;
  }

  // Get show load next button
  get showLoadNextButton() {
    return (this.productQuantityData.length < this.productData.length) ? true : false;
  }

  // Get total count
  get totalCount() {
    return (this.productData != undefined) ? this.productData.length : 0;
  }

  // Get page record count
  get pageRecordCount() {
    return (this.productQuantityData != undefined) ? this.productQuantityData.length : 0;
  }

  // Handle load next
  handleLoadNext() {
    if (this.productQuantityData.length < this.productData.length) {
      let actualResultLength = this.productData.length;
      let uiResultLength = this.productQuantityData.length;
      if ((actualResultLength - uiResultLength) <= 15) {
        let difference = (actualResultLength - uiResultLength);
        for (let index = uiResultLength; index < (uiResultLength + difference); index++) {
          let obj = { productId: this.productData[index].productId, productDetails: this.productData[index] }
          obj.quantity = '';
          obj.checkboxValue = false;
          obj.disableQuantity = true;
          obj.hideCheckbox = false;
          obj.disabledCheckbox = false;
          this.productQuantityData.push(obj);
        }
      } else {
        for (let index = uiResultLength; index < (uiResultLength + 15); index++) {
          let obj = { productId: this.productData[index].productId, productDetails: this.productData[index] }
          obj.quantity = '';
          obj.checkboxValue = false;
          obj.disableQuantity = true;
          obj.hideCheckbox = false;
          obj.disabledCheckbox = false;
          this.productQuantityData.push(obj);
        }
      }
    }
  }

  //filter  sprint 4 Workitem 
  handleFilter(event) {     
    //console.log('this._filter>>>',this._filter);
    this.searchTerm = event.target.value.trim();
    console.log('Original search term:', this.searchTerm);        
    if (this.searchTerm) {
        const lowerCaseFilter = this.searchTerm.toLowerCase();
        console.log('this.originalProductData>>>', this.originalProductData); 
        this.filteredData = filterData(this.originalProductData, lowerCaseFilter);
        this.totalFilteredRecords = this.filteredData.length; // Update totalFilteredRecords property   
        this.rawChildTableData = this.filteredData;
        // this.pageNumber = 1;
        // this.totalPages = Math.ceil(this.totalFilteredRecords / this.pageSize);
        console.log('this.filteredData>>>', this.filteredData);
        console.log('this.totalFilteredRecords>>>', this.totalFilteredRecords);
        console.log('this.rawChildTableData>>>', this.rawChildTableData);
        console.log('this.totalPages>>>', this.totalPages);
        // this.paginationHelper();           
    } else {
        this.filteredData = [];
        this.totalFilteredRecords = 0;      
        this.rawChildTableData = this.originalProductData;
        // this.pageNumber = 1; // Reset page number to 1 after removing filter
        // this.totalPages = Math.ceil(this.totalRecords / this.pageSize);                     
        // this.paginationHelper();
    }
  }

  /*handleFilter(event) {
    const searchTerm = event.target.value.trim();
    console.log('Original search term:', searchTerm);

    // Check if the search term meets the minimum length requirement
    if (searchTerm.length < 3 && !/^\d{3,}$/.test(searchTerm)) {
        console.log('Search term is too short.');
        // Reset the filter and display the original data
        this.filteredData = null;
        
        this.paginationHelper();
        console.log('Original Product Data:', this.relatedProducts);
        return;
    }

    // Split the search term by spaces to handle multiple ISBNs
    const searchTerms = searchTerm.split(/\s+/).filter(term => term); // Remove empty strings

    let filteredData;

    // Check if the search term contains multiple ISBNs
    if (searchTerms.length > 1) {
        console.log('Search term contains multiple ISBNs:', searchTerms);
        // Combine the filtered results for each ISBN
        filteredData = searchTerms.map(term => placeorderFilterData(this.originalProductData, term))
        .reduce((acc, cur) => acc.concat(cur), []); // Flatten the array
    } else {
        // Check if the search term is an ISBN, price, or general text
        if (/^\d{10,13}$/.test(searchTerm)) {
            console.log('Search term identified as ISBN:', searchTerm);
            filteredData = placeorderFilterData(this.originalProductData, searchTerm);
        } else if (/^\d{1,5}$/.test(searchTerm)) {
            console.log('Search term identified as price:', searchTerm);
            filteredData = placeorderFilterData(this.originalProductData, searchTerm);
        } else {
            console.log('Search term identified as general text:', searchTerm);
            filteredData = filterData(this.originalProductData, searchTerm);
            this.paginationHelper();
        }
    }

    console.log('Filtered data:', filteredData);

    // Update pagination and display the filtered data
    //this.updatePaginationAndDisplay(filteredData);
}*/

}