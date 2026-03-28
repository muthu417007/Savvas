import { LightningElement, track, api } from 'lwc';
import { RefreshEvent } from 'lightning/refresh';
import { placeorderFilterData } from 'c/scc_filterResults'; // Import the filter helper function
export default class scc_customTable extends LightningElement {

    @track transformedChildTableData = [];
    @track rawChildTableData = [];
    @track productDetails;
// filter 
     _filter = '';
    @track filteredData = [];
    @track totalFilteredRecords = 0;
    @track orginaldata =[];
//pagnation
    totalRecords = 0;
    showLoadNextButton=false;
    pageNumber = 1; //Page number 
    // numberOfRows = '15';
    totalPages;
    displayedRecords=0;


    @track selectedProducts = new Map();
    @track totalQuantity;
   
    @track addToCartFunction = false;
    @track itemsList = [];
    @track callAddItemToCart = false ;
    @track setQuantity = [];
    @track local_productQuantityData = [];
    @track transformedChildTableData = [];
    @track rawChildTableData = [];
    filter = '';
    @track filteredData = [];// filter 
    @track totalFilteredRecords = 0;
    @track orginaldata = [];
    totalCount = 0;
    displayedRecords = 0;
    totalRecords = 0;
    pageSizeOptions = 15 //Page size options
    @track transformedDataLength = 0;
    // numberOfRows = '5';
    totalPages;
    defaultSortDirection;
    sortDirection;
    sortedBy;
    @track currentPage = 1;
    @track pageSize = 15;
    @track showLoadNextButton = false
    
    calculateTotalPages() {
    console.log("Entering calculateTotalPages()");
    if (this._filter) {
        if (this.filteredData.length <= this.pageSize) {
            console.log("filteredData.length <= pageSize");
            this.totalPages = 1;
            this.showLoadNextButton = false;
        } else {
            console.log("filteredData.length > pageSize");
            // Adjust totalRecords to the length of filteredData
            this.totalRecords = this.filteredData.length;
            this.totalPages = Math.ceil(this.totalRecords / this.pageSize);
            this.showLoadNextButton = true;
        }
    } else {
        if (this.totalRecords <= this.pageSize) {
            console.log("totalRecords <= pageSize");
            this.totalPages = 1;
            this.showLoadNextButton = false;
        } else {
            console.log("totalRecords > pageSize");
            this.totalPages = Math.ceil(this.totalRecords / this.pageSize);
            this.showLoadNextButton = true;
        }
    }
}

handleLoadNext() {
    console.log("Entering handleLoadNext()");
    const startIndex = this.pageSize * this.currentPage;
    const endIndex = Math.min(startIndex + this.pageSize, this.totalRecords);
    const nextRecords = this.rawChildTableData.slice(startIndex, endIndex);
    this.transformedChildTableData = [...this.transformedChildTableData, ...nextRecords];
    this.currentPage++;
    this.pageSize = this.transformedChildTableData.length;
    this.showLoadNextButton = this.currentPage < this.totalPages;
    this.updateTransformedDataLength();
}

displayFirstPage() {
    console.log("Entering displayFirstPage()");
    if (this.rawChildTableData) {
        const endIndex = Math.min(this.pageSize, this.totalRecords);
        this.transformedChildTableData = this.rawChildTableData.slice(0, endIndex);
        this.currentPage = 1;
        this.updateTransformedDataLength();
    }
}

get transformedChildTableData() {
    console.log("Entering transformedChildTableData()");
    return this.transformedChildTableData.slice(0, this.pageSize * this.currentPage);
}

    handleLoadNextClick() {
        this.handleLoadNext();
    }
    

   
 @api
    get rawParentTableData() {
        return this.currentTableData;
    }
    set rawParentTableData(value) {
        this.rawChildTableData = value;
        console.log('set',value)
        this.orginaldata = value;
        this.totalCount = this.rawChildTableData.length;
        this.totalRecords = this.rawChildTableData.length;
        this.pageSize = 15;
        //console.log(this.totalCount);
        if (this.totalRecords === 0) {
            this.transformedChildTableData = [];
          //  this.updateTransformedDataLength();
        }
        this.calculateTotalPages();
        this.displayFirstPage();
         console.log('called')
    }
    //get filter search value sprint 4 workitem 

     @api
    get filter() {
        return this._filter;
    }

    /**
* @param {string} value
*/
    set filter(value) {
        this._filter = value;
        console.log(this._filter);
        this.handleFilterChange();
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
   

    handleRowAction(event) {
        // Handle button click action here
        const row = event.detail.row;
        const action = event.detail.action.name;
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
tableRowAction(event) {
    // let fieldName = event.target.dataset.fieldName;
    // let rowId = event.target.dataset.rowId;
    // // Define local_productQuantityData as a local variable here
    // let local_productQuantityData = this.transformedChildTableData;
    // if (fieldName == 'checkbox') {
    //     let rowValue = event.target.checked;
    //     let rowIndex = local_productQuantityData.findIndex(element => element.productDetails.productId === rowId);
    //     let rowInfo = local_productQuantityData[rowIndex];
    //     rowInfo.checkboxValue = rowValue;
    //     const checkboxChangeEvent = new CustomEvent('checkboxchange', {
    //         detail: {
    //             rowId: rowId,
    //             checkboxValue: rowValue
    //         }
    //     });
    //     this.dispatchEvent(checkboxChangeEvent);
    //     console.log('dispatchEvent ::  ', this.dispatchEvent);
    // }
    let fieldName = event.target.dataset.fieldName;
    console.log(fieldName)
    let rowId = event.target.dataset.rowId;

    let local_productQuantityData = this.transformedChildTableData;
if (fieldName == 'quantityCount') {
    console.log('Entering quantityCount condition');
    let rowValue = event.target.value.trim();
    console.log('Trimmed rowValue:', rowValue);

    // Check if the input value is empty or contains non-numeric characters
    if (!rowValue) {
        event.target.setCustomValidity("Please enter only numeric characters");
        event.target.reportValidity();
        console.log("Invalid input: Please enter only numeric characters");
    } else if (isNaN(rowValue)) {
        event.target.setCustomValidity("Please enter a valid numeric value");
        event.target.reportValidity();
        console.log("Invalid input: Please enter a valid numeric value");
    } else {
        // Reset any previous custom validity messages
        event.target.setCustomValidity('');
        console.log('rowValue is numeric');

        // Check if the input value is not just zeros
        if (!/^0+$/.test(rowValue)) {
            let rowId = event.target.getAttribute('data-row-id');
            let rowIndex = this.local_productQuantityData.findIndex(element => element.productDetails.productId === rowId);
            let rowInfo = this.local_productQuantityData[rowIndex];
            console.log('Row Info before update:', rowInfo);

            // Update the quantity in the local product data
            rowInfo.quantity = rowValue;
            this.local_productQuantityData[rowIndex] = rowInfo;
            console.log('Updated Row Info:', this.local_productQuantityData[rowIndex]);

            let customName = event.target.getAttribute('data-attribute-name');
            let customPrice = event.target.getAttribute('data-attribute-price');
            this.addProductsToCart(rowId, rowValue, customPrice, customName);
            console.log('Added product to cart with rowValue:', rowValue, 'rowIndex:', rowIndex, 'rowInfo:', rowInfo);
        } else {
            console.log("Invalid input: Quantity cannot be zero");
        }
    }
}

//    if( fieldName == 'quantityCount'){
//           console.log('ebter');
//         // let rowValue = event.target.value;
//          let rowValue = event.target.value.trim()
//          console.log('ebter',rowValue);
//             if (!rowValue) {
               
//           event.target.setCustomValidity("Please enter only numeric characters");
//             event.target.reportValidity();
//             console.log("Invalid input: Please enter only numeric characters");
//             // Optionally, you can revert the input value back to its previous valid value
//             // event.target.value = ''; // Empty the input value
//         } else if (!isNaN(rowValue)) {
//         event.target.setCustomValidity('');
//                 if (!/^0+$/.test(rowValue)) {
//         let rowIndex = this.local_productQuantityData.findIndex(element => element.productDetails.productId === rowId);
//         let rowInfo = this.local_productQuantityData[rowIndex];
//         console.log('ebter4',rowInfo);
//         console.log('ebter5',rowInfo);
//         rowInfo.quantity = rowValue;
//         this.local_productQuantityData[rowIndex] = rowInfo;
//         console.log('ebter6',this.local_productQuantityData[rowIndex]);
//         let currentRecordId = event.target.getAttribute('data-row-id');
//         let customName = event.target.getAttribute('data-attribute-name');
//         let customPrice = event.target.getAttribute('data-attribute-price');
//         this.addProductsToCart(currentRecordId, rowValue, customPrice, customName);
//         console.log('rowValue', rowValue,'rowIndex',rowIndex, '',rowInfo);
                
//         // let rowIndex = local_productQuantityData.findIndex(element => element.productDetails.productId === rowId);
//         // let rowInfo = local_productQuantityData[rowIndex];
//         // rowInfo.quantity = rowValue;
//         // local_productQuantityData[rowIndex] = rowInfo;
//         // console.log(local_productQuantityData);
//     }
//         }
//     else{
// console.log("Invalid input: Please enter a valid numeric value");
//     }
//    }
    if (fieldName == 'isbnId') {
        let rowIndex = local_productQuantityData.findIndex(element => element.productDetails.productId === rowId);
        let rowInfo = local_productQuantityData[rowIndex];
        const selectEvent = new CustomEvent('showproducttitlepage', {
            detail: {
                parentSelectedProductRecord: rowInfo.productDetails,
                  displayedRecords: this.displayedRecords
            }
        });
        console.log(rowInfo.productDetails, 'rowInfo.productDetails');
        this.dispatchEvent(selectEvent);
    }
    // Update transformedChildTableData with the modified local_productQuantityData
    this.transformedChildTableData = Object.assign([], local_productQuantityData);
}

addProductsToCart(currentRecordId, rowValue, customPrice, customName) {
        console.log('im in the addproductstocart');
        this.callAddItemToCart = false;
        if (this.selectedProducts.has(currentRecordId)) {
            console.log('im in the addproductstocartif');
            let existingItem = this.selectedProducts.get(currentRecordId);
            existingItem.Quantity = rowValue;
            this.selectedProducts.set(currentRecordId, existingItem);
        } else {
            console.log('im in the addproductstocartelse');
            this.selectedProducts.set(currentRecordId, {

                Product2Id: currentRecordId,
                Quantity: rowValue,
                SalesPrice: customPrice,
                Name: customName
            });
        }
        this.updateTotalquantity();
        console.log('the values for add to cart', this.selectedProducts);
    }

    updateTotalquantity() {
        let sum = 0;
            this.selectedProducts.forEach((value, key) => {
            sum += parseInt(value.Quantity);
            console.log('the key and value is', value, 'and', key);
        });
        this.totalQuantity = sum;
         console.log('the total quanity', this.totalQuantity);
          const quantitychangeChangeEvent = new CustomEvent('quantitychange', {
            detail: this.totalQuantity            
        });        
        this.dispatchEvent(quantitychangeChangeEvent);
       
        console.log('the total quanity is', this.totalQuantity);

    }

// filter  sprint 4 Workitem 
    //   handleFilterChange() {
    //     if (this._filter) {

    //         const lowerCaseFilter = this._filter.toLowerCase();
    //         // Add logging to track filter data before filtering      
    //         this.filteredData = placeorderFilterData(this.rawChildTableData, lowerCaseFilter);
    //         this.totalFilteredRecords = this.filteredData.length; // Update totalFilteredRecords property               
    //         this.rawChildTableData = this.filteredData;
    //         this.updateTransformedDataLength();
    //         this.calculateTotalPages();
    //         this.displayFirstPage();

    //     } else {
    //         this.filteredData = [];
    //         this.totalFilteredRecords = 0;
    //         this.rawChildTableData = this.orginaldata;
    //         this.updateTransformedDataLength();
    //         this.calculateTotalPages();
    //         this.displayFirstPage();
    //     }
    // }

    handleFilterChange() {
    if (this._filter) {
        const lowerCaseFilter = this._filter.toLowerCase();
        // Add logging to track filter data before filtering
        console.log('Filter before filtering:', lowerCaseFilter);
        this.filteredData = placeorderFilterData(this.rawChildTableData, lowerCaseFilter);
        this.totalFilteredRecords = this.filteredData.length; // Update totalFilteredRecords property
        console.log('Filtered data:', this.filteredData);
        this.rawChildTableData = this.filteredData;
        this.updateTransformedDataLength();
        this.calculateTotalPages();
        this.displayFirstPage();
    } else {
        this.filteredData = [];
        this.totalFilteredRecords = 0;
        this.rawChildTableData = this.orginaldata;
        this.updateTransformedDataLength();
        this.calculateTotalPages();
        this.displayFirstPage();
    }
}

    taskTypeHelpTextClass = 'slds-popover slds-popover_tooltip slds-nubbin_bottom-right slds-fall-into-ground slds-hide';
    togglePasswordHint() {
    let hideCss = 'slds-popover slds-popover_tooltip slds-nubbin_bottom-right slds-fall-into-ground slds-hide';
    let showCss = 'slds-popover slds-popover_tooltip slds-nubbin_bottom-right slds-rise-from-ground';
    this.taskTypeHelpTextClass = this.taskTypeHelpTextClass == hideCss ? showCss : hideCss;
}
 updateTransformedDataLength() {
        this.transformedDataLength = this.transformedChildTableData.length;
        const event = new CustomEvent('transformeddatalength', {
            detail: {
                transformedDataLength: this.transformedDataLength,
                totalFilteredRecords: this.totalFilteredRecords,
                totalCount: this.totalCount
            }
        });
        this.dispatchEvent(event);
       // console.log('Event dispatched:', event);
    }
     @api 
    get addSelectedToCart(){
        console.log('data for addselected to cart', this.currentaddSelectedToCart);
        return this.currentSelectData;
    }
   set addSelectedToCart(value){
       console.log('data for set addtocart', value);
        this.addToCartFunction = value;
        if (this.addToCartFunction ==true){
             console.log('the values in the new map is',this.selectedProducts);
                this.itemsList = [];
        this.clearCartItems = false;
        this.selectedProducts.forEach((value, key) => {
            this.itemsList.push({
                id: key,
                Product2Id: value.Product2Id,
                Quantity: value.Quantity,
                SalesPrice: value.SalesPrice,
                Name: value.Name
            });
        });
        console.log('items in the list is', this.itemsList); 
         this.callAddItemToCart = true;
       

        
   }}

    handleReviewCartCount(event) {
        console.log('Im in the handle review cart count scc_customTabel');
        const customEvent = new CustomEvent('reveiewcartcount');
          this.dispatchEvent(customEvent);
           this.transformedChildTableData = this.transformedChildTableData.map(product =>({ ...product, quantity:0}));
           this.local_productQuantityData = [];
           this.selectedProducts = new Map();
           this.dispatchEvent(new RefreshEvent());
    }
    // handleTransformedDataLength(event) {
    //     this.transformedDataLength = event.detail.transformedDataLength;
    //     if (event.detail.totalFilteredRecords) {
    //         this.totalFilteredRecords = event.detail.totalFilteredRecords;
    //         this.totalCount = this.totalFilteredRecords; // Update totalCount with totalFilteredRecords
    //     } else {
    //         this.totalCount = event.detail.totalCount; // Update totalCount with original totalRecords
    //     }
    //     // Update parent component's data or UI based on the length of the transformed data received from the child component
    // }
}