/*******************************************************************************************************
 * @Component Name: Scc_placeOrderCriteriaSearproductDatachLWC
 * @Description: Lightning web component for searching products based on ISBN and title keyword criteria.
 * @Created By: Sanika Sol
 * @Created On: 17/04/2024
 * *****************************************************************************************************
 * Modification Log:
 * -----------------------------------------------------------------------------------------------------
 * Developer        Date            Description

 * -----------------------------------------------------------------------------------------------------
 */

import { LightningElement, wire, track, api } from 'lwc';
import searchProducts from '@salesforce/apex/scc_placeOrderISBNSearch_Controller.searchProducts';
import errormessage from '@salesforce/label/c.scc_productcriteriaerrormessage';
import LightningAlert from 'lightning/alert';
import { RefreshEvent } from 'lightning/refresh';

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
export default class Scc_placeOrderCriteriaSearchLWC extends LightningElement {

    @track selectedDiscipline = '';
    @track titlekeyword = '';
    @track isbnValue = '';
    @track activeProducts = true; // Checked by default
    @track searchDisabled = true; // Initially disabled
    @track showResults = false; // Initially hidden
    @track productData = []; // Data to display in the table
    @track disableNext = true; // Initially disabled
    @track currentPagetableData = [];
   
    @track productQuantityData = [];

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
        this.productQuantityData = [];
        searchProducts({ isbnValue: this.isbnValue, selectedDiscipline: this.selectedDiscipline, titlekeyword: this.titlekeyword, activeProducts: this.activeProducts })
            .then(result => {
                console.log('Search results:', result);
                this.productData = result;

                for (let index = 0; index < this.productData.length; index++) {
                    if (index == 15) {
                        break;
                    }
                    let obj = { productId: this.productData[index].productId, productDetails: this.productData[index] }
                    obj.quantity = '';
                    obj.checkboxValue = false;
                    obj.disableQuantity = true;
                    obj.hideCheckbox = false;
                    this.productQuantityData.push(obj);
                    console.log(productQuantityData,'productQuantityData');
                };
                this.records = result;
                this.totalRecords = result.length; // update total records count                 
                this.pageSize = this.pageSizeOptions[0]; //set pageSize with default value as first option
                this.paginationHelper(); // call helper menthod to update pagination logic 
                if (this.productData != undefined) {
                    this.showSearchResultErrorMessage = false;
                    if (this.productData.length < 1) {
                        this.showSearchResultErrorMessage = true;
                        this.showResults = true;
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
        // Reset productData and productQuantityData arrays to empty arrays
        this.productData = [];
        this.productQuantityData = [];
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
    handleShowProductTitlePage(event) {
        this.showTabset = false;
        this.showProductTitlePage = true;
        this.selectedProductRecord = event.detail.parentSelectedProductRecord;
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
                rowInfo.quantity = 1;
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
            rowInfo.quantity = rowValue;
            local_productQuantityData[rowIndex] = rowInfo;
        }
        if (fieldName == 'isbnId') {
            let rowIndex = local_productQuantityData.findIndex(element => element.productDetails.productId === rowId);
            let rowInfo = local_productQuantityData[rowIndex];
            this.handleRowAction(rowInfo.productDetails, 'viewRecords');
        }
        this.productQuantityData = Object.assign([], local_productQuantityData);
    }
    isAddToSelectedToCartBtnDisabled = false;
    productSearchBtnSectionConfig = {
        addSelectedToCartBtnLabel: 'Add Selected (number) To Cart',
        addSelectedToCartBtnDisabled:  true,
        clearCartBtnLabel: 'Clear Cart (number)',
        clearCartBtnDisabled: true,
        reviewCartLabel: 'Review Cart (number)',
        reviewCartDisabled: true,
        productAddedToCart: 0
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
    clearCartHandleClick(event) {

    }
    reviewCartHandleClick(event) {

    }
    taskTypeHelpTextClass = 'slds-popover slds-popover_tooltip slds-nubbin_bottom-right slds-fall-into-ground slds-hide';
    togglePasswordHint() {
        let hideCss = 'slds-popover slds-popover_tooltip slds-nubbin_bottom-right slds-fall-into-ground slds-hide';
        let showCss = 'slds-popover slds-popover_tooltip slds-nubbin_bottom-right slds-rise-from-ground';
        this.taskTypeHelpTextClass = this.taskTypeHelpTextClass == hideCss ? showCss : hideCss;

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
}