import { LightningElement, wire, track, api } from 'lwc';
import searchProducts from '@salesforce/apex/scc_placeOrderISBNSearch_Controller.searchProducts';
import errormessage from '@salesforce/label/c.scc_productcriteriaerrormessage';
import { CartSummaryAdapter } from "commerce/cartApi";
import LightningAlert from 'lightning/alert';
import { RefreshEvent } from 'lightning/refresh';
import { refreshCartSummary } from 'commerce/cartApi';

class productQuantityWrapper {
    productId; productDetails; quantity; checkboxValue; disableQuantity; hideCheckbox; disabledCheckbox;
    constructor(productId, productDetails, quantity = '', checkboxValue = false, disableQuantity = true, hideCheckbox = false, disabledCheckbox = false) {
        this.productId = productId;
        this.productDetails = productDetails;
        this.quantity = quantity;
        this.checkboxValue = checkboxValue;
        this.disableQuantity = disableQuantity;
        this.hideCheckbox = hideCheckbox;
        this.disabledCheckbox = disabledCheckbox;
    }
    getInActiveQuantityField() {
        return (this.hideCheckbox || !this.activeQuantity);
    }
}
export default class TestPACriteria extends LightningElement {

    @track selectedDiscipline = '';
    @track titlekeyword = '';
    @track isbnValue = '';
    @track activeProducts = true; // Checked by default
    @track searchDisabled = true; // Initially disabled
    @track showResults = false; // Initially hidden
    @track clearCartItems = false;
    @track productData = []; // Data to display in the table
    @track disableNext = true; // Initially disabled
    @track currentPagetableData = [];
    @track productData = []; // Declare productData as a tracked property
    @track productQuantityData = [];
    @track currentRecordId;
    @track selectedProducts = new Map();
    @track totalQuantity = 0;
    @track itemsInCart = [];
    @track itemsList = [];
    @track filterCriteria;
    @track clearCartBtnDisabled = true;
    @track reviewCartDisabled = true;
    @track reviewCartPage = false;
    @track showProductSearchPage = true;
    @track addSelectedToCartBtnDisabled = true;
    @track addToCart = false;
    @track transformedDataLength = 0;
    @track totalCount = 0;
    @track isLoading = false;
    @track firstLoad = true;

    records = []; //All records available in the data table
    totalRecords = 0; //Total no.of records
    pageSize; //No.of records to be displayed per page
    totalPages; //Total no.of pages
    pageNumber = 1; //Page number    
    pageSizeOptions = [15, 25, 50, 75, 100]; //Page size options
    searchResultErrorMessage = errormessage;
    manualSearchBtnDisabled = false;
    showProductTitlePage = false;
    showTabset = true;
    selectedProductRecord = {};
    showSearchResultErrorMessage = false;
    numberOfRows = '5';
    selectedIdList = [];
    hideCheckbox = false;
    @track productsInCart = 0;

    get addToCartButtonLabel() {
        return `Add to Cart (${this.totalQuantity})`;
    }
    get clearCartButtonLabel() {
        return `Clear Cart (${this.productsInCart})`;
    }
    get reviewCartButtonLabel() {
        return `Review Cart (${this.productsInCart})`;
    }
    setProductCount(){
        this.productsInCart = 0; 
        this.clearCartBtnDisabled = true;
        this.reviewCartDisabled = true;
    }
  /*  constructor() {
        super()
        console.log('im in constructor1');
            this.productsInCart = 0;
            console.log('im in constructor2');
            this.refreshSummary();
            this.productsInCart = 0;
            console.log('im in constructor3');
    } */
    @wire(CartSummaryAdapter)
    setCartSummary({ data, error }) {
        if (data) {
            this.activeCartId = data.cartId;
            this.productsInCart = data.totalProductCount;
            if (this.productsInCart > 0) {
                this.clearCartBtnDisabled = false;
                this.reviewCartDisabled = false;
                this.clearCartItems = false;
                if(this.firstLoad == true){
                   this.firstLoad = false; 
                   this.refreshSummary();
                } 
            }else{
                this.clearCartBtnDisabled = true;
                this.reviewCartDisabled = true;
            }
            console.log('the current active cartid id', this.activeCartId, 'and the current data getting is', data);
            console.log('the active card product count is ', this.productsInCart);
        } else if (error) {
            console.error(error);
              this.productsInCart = 0;
              this.setProductCount();
              console.log('error in wire',error,'====',this.productsInCart);
        }
    }


    get selectedItemsToCart() {
        let rowIndex = local_productQuantityData.filter(element => element.quantity === rowId);
        return 0;
    }
    @wire(searchProducts)
    wiredProductData({ data, error }) {
        if (data) {
            this.productData = data;

        } else if (error) {
            // Handle error
        }
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
        // console.log('Search button Clicked');
        this.searchDisabled = true;
        searchProducts({ isbnValue: this.isbnValue, selectedDiscipline: this.selectedDiscipline, titlekeyword: this.titlekeyword, activeProducts: this.activeProducts })
            .then(result => {
                // console.log('Search results:', result);
                this.productData = result;
                for (let oneProduct of this.productData) {
                    let oneProductQuantity = new productQuantityWrapper(oneProduct.productId, oneProduct, '0', false, true, false, false);
                    this.productQuantityData.push(oneProductQuantity);
                    console.log(this.productQuantityData);
                }
                this.records = result;
                this.totalRecords = result.length; // update total records count                 
                this.pageSize = this.pageSizeOptions[0]; //set pageSize with default value as first option
                this.paginationHelper(); // call helper menthod to update pagination logic 
                // console.log('All Data :: ', this.productData);
                if (this.productData != undefined) {
                    this.showSearchResultErrorMessage = false;
                    // console.log('this.productData.length :: ', this.productData.length);
                    if (this.productData.length < 1) {
                        this.showSearchResultErrorMessage = true;
                        this.showResults = true;
                        // console.log('this.showSearchResultErrorMessage :: ', this.showSearchResultErrorMessage, this.searchResultErrorMessage);
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
            })
            .catch(error => {
                // console.log('Error fetching results:', error);
                this.error = error;
                this.productData = [];
                this.showResults = false;
            });
    }
    // Event handler for closing product title page
    closeChildTitlePage(event) {
        this.showProductTitlePage = false;
        this.addSelectedToCartBtnDisabled = true;
        this.totalQuantity = 0;
        this.showTabset = true;
        this.showResults = false;
        // Reset productData and productQuantityData arrays to empty arrays
        this.productData = [];
        this.addSelectedToCartBtnDisabled = true;
        this.totalQuantity = 0;
        this.productQuantityData = [];
        this.transformedDataLength = 0;
        this.totalCount = 0;
    }
    // Handle clear button click event
    handleClear() {
        // console.log('Clear button Clicked');
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
        this.productSearchBtnSectionConfig = {
            addSelectedToCartBtnLabel: 'Add Selected (number) To Cart',
            addSelectedToCartBtnDisabled: true,
            clearCartBtnLabel: 'Clear Cart (number)',
            clearCartBtnDisabled: true,
            reviewCartLabel: 'Review Cart (number)',
            reviewCartDisabled: true,
            productAddedToCart: 0
        }
        // Reset page record count and total count
        this.productQuantityData = [];
        this.addSelectedToCartBtnDisabled = true;
        this.totalQuantity = 0;
        this.transformedDataLength = 0;
        this.totalCount = 0;
        this.dispatchEvent(new RefreshEvent()); // Refresh the page
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
    // handleshowProductTitlePage(event) {

    //     this.showTabset = false;
    //     this.showProductTitlePage = true;
    //     this.selectedProductRecord = event.detail.parentSelectedProductRecord;
    // }
    handleshowproducttitlepage(event) {
console.log('yes opend')
        this.showTabset = false;
        this.showProductTitlePage = true;
        this.selectedProductRecord = event.detail.parentSelectedProductRecord;
        console.log('yes opend1',this.selectedProductRecord);
    }
    handleRowAction(row, action) {
        // Handle button click action here
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
            console.log('row variable:', row);
            this.selectedProductRecord = row;
            this.showTabset = false;
        }
    }
    tableRowAction(event) {
        let fieldName = event.target.dataset.fieldName;
        let rowId = event.target.dataset.rowId;
        console.log('tableRowAction ::  ', rowId, fieldName);
        let local_productQuantityData = this.productQuantityData;
        if (fieldName == 'checkbox') {
            let rowValue = event.target.checked;
            let rowIndex = local_productQuantityData.findIndex(element => element.productDetails.productId === rowId);
            let rowInfo = local_productQuantityData[rowIndex];
            rowInfo.checkboxValue = rowValue;
            rowInfo.disableQuantity = false;
            if (!rowInfo.checkboxValue) {
                rowInfo.quantity = '';
            }
            else {
                rowInfo.quantity = 0;
            }
            local_productQuantityData[rowIndex] = rowInfo;
            this.productSearchBtnSectionConfig.addSelectedToCartBtnDisabled = true;
            let selectedProductCount = 0;
            for (let productDetails of local_productQuantityData) {
                if (productDetails.checkboxValue) {
                    if (this.productSearchBtnSectionConfig.addSelectedToCartBtnDisabled) {
                        this.productSearchBtnSectionConfig.addSelectedToCartBtnDisabled = false;
                    }
                    selectedProductCount += 1;
                }
            }
            this.productSearchBtnSectionConfig.productAddedToCart = selectedProductCount;
        }
        if (fieldName == 'quantityCount') {
            let rowValue = event.target.value;
            let rowIndex = local_productQuantityData.findIndex(element => element.productDetails.productId === rowId);
            let rowInfo = local_productQuantityData[rowIndex];
            let currentRecordId = event.target.getAttribute('data-row-id');
            let customName = event.target.getAttribute('data-attribute-name');
            let customPrice = event.target.getAttribute('data-attribute-price');
            // let id=element.productDetails.productId;
            rowInfo.quantity = rowValue;
            local_productQuantityData[rowIndex] = rowInfo;
            console.log('tableRowAction quantity count ::  ', rowValue, rowInfo, 'id value is', currentRecordId, 'and name is', customName, 'and price is', customPrice);
            this.addProductsToCart(currentRecordId, rowValue, customPrice, customName);

            console.log('the values in productss is', this.selectedProducts);
        }
        if (fieldName == 'isbnId') {
            let rowIndex = local_productQuantityData.findIndex(element => element.productDetails.productId === rowId);
            let rowInfo = local_productQuantityData[rowIndex];
            this.handleRowAction(rowInfo.productDetails, 'viewRecords');
        }
        this.productQuantityData = Object.assign([], local_productQuantityData);
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
        if (this.totalQuantity > 0) {
            this.addSelectedToCartBtnDisabled = false;
        }
        else {
            this.addSelectedToCartBtnDisabled = true;
        }
        console.log('the total quanity is', this.totalQuantity);
    }

    isAddToSelectedToCartBtnDisabled = false;
    productSearchBtnSectionConfig = {
        addSelectedToCartBtnLabel: 'Add Selected (number) To Cart',
        addSelectedToCartBtnDisabled: true,
        clearCartBtnLabel: 'Clear Cart (number)',
        clearCartBtnDisabled: true,
        reviewCartLabel: 'Review Cart (number)',
        reviewCartDisabled: true,
        productAddedToCart: 0,

    }
    get displayProductSearchBtnSectionConfig() {
        let local_ProductSearchBtnSectionConfig = Object.assign({}, this.productSearchBtnSectionConfig);
        // console.log('this.productSearchBtnSectionConfig :: ', local_ProductSearchBtnSectionConfig);
        local_ProductSearchBtnSectionConfig.addSelectedToCartBtnLabel = local_ProductSearchBtnSectionConfig.addSelectedToCartBtnLabel.replace(/number/g, local_ProductSearchBtnSectionConfig.productAddedToCart);
        local_ProductSearchBtnSectionConfig.clearCartBtnLabel = local_ProductSearchBtnSectionConfig.clearCartBtnLabel.replace(/number/g, local_ProductSearchBtnSectionConfig.productAddedToCart);
        local_ProductSearchBtnSectionConfig.reviewCartLabel = local_ProductSearchBtnSectionConfig.reviewCartLabel.replace(/number/g, local_ProductSearchBtnSectionConfig.productAddedToCart);
        // console.log('after local_ProductSearchBtnSectionConfig : ', local_ProductSearchBtnSectionConfig);
        return local_ProductSearchBtnSectionConfig;
    }
    addSelectedToCartHandleClick(event) {
        this.addToCart = true;
    }
     /*   this.itemsList = [];
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
        // this.itemsInCart= this.itemsList;
        // console.log('itemsInCart in the list is',itemsInCart);
        this.callAddItemToCart = true;
         const customEventToAddProductsToCart = new CustomEvent('addtocart',{
             detail: { itemsList : itemsList }
         });
         this.dispatchEvent(customEventToAddProductsToCart); 
      /*  this.productSearchBtnSectionConfig.addSelectedToCartBtnDisabled = true;
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
    }*/
    handleReviewCartCount() {
      
        console.log('review cart count is');
        this.selectedProducts = new Map();
        this.addSelectedToCartBtnDisabled = true;
        this.clearCartItems = false;
        this.addToCart = false;
        this.totalQuantity = 0;
        this.refreshSummary();
        this.dispatchEvent(new RefreshEvent());
        console.log('review cart count is');
    }
    handlerefreshevent() {
        this.refreshSummary();
    }


    async refreshSummary() {
        const response = await refreshCartSummary()
            .then((result => {
                  this.isLoading = false;
                this.isLoading = false;
                this.isEmptyCart = true;
            }));
    }

    clearCartHandleClick(event) {
        this.clearCartItems = true;
          // this.isLoading = true;
        console.log('the clear cart handle is called');

    }
    reviewCartHandleClick(event) {
        this.showProductSearchPage = false;
        this.reviewCartPage = true;

    }
    handlehideparenttab(){
          this.showTabset = false;
        this.showResults = false;
          this.showProductSearchPage = false;
        this.reviewCartPage = true;
    }
    taskTypeHelpTextClass = 'slds-popover slds-popover_tooltip slds-nubbin_bottom-right slds-fall-into-ground slds-hide';
    togglePasswordHint() {
        let hideCss = 'slds-popover slds-popover_tooltip slds-nubbin_bottom-right slds-fall-into-ground slds-hide';
        let showCss = 'slds-popover slds-popover_tooltip slds-nubbin_bottom-right slds-rise-from-ground';
        this.taskTypeHelpTextClass = this.taskTypeHelpTextClass == hideCss ? showCss : hideCss;

    }
    taskTypeHelpTextClassfilter = 'slds-popover slds-popover_tooltip slds-nubbin_bottom-right slds-fall-into-ground slds-hide';
    togglePasswordHintfilter() {
        let hideCss = 'slds-popover slds-popover_tooltip slds-nubbin_bottom-right slds-fall-into-ground slds-hide';
        let showCss = 'slds-popover slds-popover_tooltip slds-nubbin_bottom-right slds-rise-from-ground';
        this.taskTypeHelpTextClassfilter = this.taskTypeHelpTextClassfilter == hideCss ? showCss : hideCss;

    }
    get showLoadNextButton() {
        return (this.productQuantityData.length < this.productData.length) ? true : false;
    }
    get totalCount() {
        return (this.productData != undefined) ? this.productData.length : 0;
    }
    get pageRecordCount() {
        return (this.productQuantityData != undefined) ? this.productQuantityData.length : 0;
    }
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
            }
            else {
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
    handleFilter(event) {
        const searchTerm = event.target.value.trim();
        if (!searchTerm || searchTerm.length < 3 && !/^\d{3,}$/.test(searchTerm)) {
            this.filterCriteria = '';
            // No need to send search term to B component, so no action needed here
        } else {
            // Split the search term by spaces to handle multiple terms
            const searchTerms = searchTerm.split(/\s+/).filter(term => term);
            // Set filter criteria based on different conditions
            if (searchTerms.length > 1) {
                // If search term contains multiple terms
                this.filterCriteria = searchTerm;
            } else if (/^\d{10,13}$/.test(searchTerm)) {
                // If search term is a valid 10 or 13 digit value
                this.filterCriteria = searchTerm;
            } else if (/^\d{1,5}$/.test(searchTerm)) {
                // If search term is a valid 1 to 5 digit value
                this.filterCriteria = searchTerm;
            } else {
                // If search term is a general text
                this.filterCriteria = searchTerm;
            }
        }
    }
    handleCheckboxChange(event) {
        const rowId = event.detail.rowId;
        const checkboxValue = event.detail.checkboxValue;
        let local_productQuantityData = this.productQuantityData;
        let rowIndex = local_productQuantityData.findIndex(element => element.productDetails.productId === rowId);
        let rowInfo = local_productQuantityData[rowIndex];
        rowInfo.checkboxValue = checkboxValue;
        rowInfo.disableQuantity = false;
        if (!rowInfo.checkboxValue) {
            rowInfo.quantity = '';
        } else {
            rowInfo.quantity = 1;
        }
        local_productQuantityData[rowIndex] = rowInfo;
        this.productQuantityData = Object.assign([], local_productQuantityData);

        this.productSearchBtnSectionConfig.addSelectedToCartBtnDisabled = true;
        let selectedProductCount = 0;
        for (let productDetails of local_productQuantityData) {
            if (productDetails.checkboxValue) {
                if (this.productSearchBtnSectionConfig.addSelectedToCartBtnDisabled) {
                    this.productSearchBtnSectionConfig.addSelectedToCartBtnDisabled = false;
                }
                selectedProductCount += 1;
            }
        }
        this.productSearchBtnSectionConfig.productAddedToCart = selectedProductCount;
    }
    openChildTitlePage(event) {
        console.log('yes entered ');
        this.showProductTitlePage = true;
        this.showTabset = false;
        this.showResults = false;
        this.selectedProductRecord = event.detail.parentSelectedProductRecord;
 console.log('yes entered 2',this.selectedProductRecord );
    }

      handleQuantityChange(event){
        this.totalQuantity = event.detail;
         if (this.totalQuantity > 0) {
            this.addSelectedToCartBtnDisabled = false;
        }
        else {
            this.addSelectedToCartBtnDisabled = true;
        }
        console.log('the total quanity is', this.totalQuantity);
    }
    handleTransformedDataLength(event) {
        this.transformedDataLength = event.detail.transformedDataLength;
        if (event.detail.totalFilteredRecords) {
            this.totalFilteredRecords = event.detail.totalFilteredRecords;
            this.totalCount = this.totalFilteredRecords; // Update totalCount with totalFilteredRecords
        } else {
            this.totalCount = event.detail.totalCount; // Update totalCount with original totalRecords
        }
        // Update parent component's data or UI based on the length of the transformed data received from the child component
    }
    
}