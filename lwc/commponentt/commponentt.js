import { LightningElement, wire, track, api } from 'lwc';
import searchProducts from '@salesforce/apex/CommponenttCntllr.searchProducts';
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
export default class Commponentt extends LightningElement {
    // @api productQuantityData = [];
    @track selectedDiscipline = '';
    @track titlekeyword = '';
    @track isbnValue = '';
    @track activeProducts = true; // Checked by default
    @track searchDisabled = true; // Initially disabled
    @track showResults = false; // Initially hidden
    @track productData = []; // Data to display in the table
    @track disableNext = true; // Initially disabled
    @api viewForCatalogSection = false;
    @track filterCriteria;// filter 

    records = []; //All records available in the data table
    totalRecords = 0; //Total no.of records

    pageSize; //No.of records to be displayed per page
    totalPages; //Total no.of pages
    pageNumber = 1; //Page number    

    searchResultErrorMessage = errormessage;
    manualSearchBtnDisabled = false;
    showProductTitlePage = false;
    showTabset = true;
    selectedProductRecord = {};
    showSearchResultErrorMessage = false;
    numberOfRows = '15';
    // Pagination Variables
    @track currentPagetableData = [];
    selectedIdList = [];
    hideCheckbox = false;

    // For quantity selector
    @track productData = []; // Declare productData as a tracked property
    @track productQuantityData = [];

    get selectedItemsToCart() {
        let rowIndex = local_productQuantityData.filter(element => element.quantity === rowId);
        return 0;
    }
    // get cartLabel() {
    //     return '\uD83D\uDED2 ' + this.displayProductSearchBtnSectionConfig.reviewCartLabel;
    // }
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
                    let oneProductQuantity = new productQuantityWrapper(oneProduct.productId, oneProduct, '', false, true, false, false);
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
        //Reload the window after clearing the search
        //window.location.reload();
        // location.reload();

        // Reset page record count and total count
        this.productQuantityData = [];
        // this.pageRecordCount = 0;
        // this.totalCount = 0;

        this.dispatchEvent(new RefreshEvent()); // Refresh the page
        // Reset page record count and total count
        // this.productQuantityData = [];
        // this.pageRecordCount = 0;
        // this.totalCount = 0;
        // console.log('reloaded');
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
        console.log('yes came');
        this.showTabset = false;
        this.showProductTitlePage = true;
        console.log('yes showProductTitlePage',this.showProductTitlePage);
        this.selectedProductRecord = event.detail.parentSelectedProductRecord;
         console.log('yes selectedProductRecord',this.selectedProductRecord);
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

    openChildTitlePage(event) {
        this.showProductTitlePage = true;
        this.showTabset = false;
        this.showResults = false;
        this.selectedProductRecord = event.detail.parentSelectedProductRecord;
         console.log('yes opend',this.selectedProductRecord);
    }

    //-----------------------------------------------------------------------------------------------------------------------------------------------------------
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
        // console.log('this.productQuantityData :: ', this.productQuantityData);
    }
    isAddToSelectedToCartBtnDisabled = false;
    // ListOfObjects = [
    //     {value:1, value2: 2}
    //     {value:2, value2:4}]
    productSearchBtnSectionConfig = {
        addSelectedToCartBtnLabel: 'Add Selected (number) To Cart',
        addSelectedToCartBtnDisabled: true,
        clearCartBtnLabel: 'Clear Cart (number)',
        clearCartBtnDisabled: true,
        reviewCartLabel: 'Review Cart (number)',
        reviewCartDisabled: true,
        productAddedToCart: 0
    }
    get displayProductSearchBtnSectionConfig() {
        let local_ProductSearchBtnSectionConfig = Object.assign({}, this.productSearchBtnSectionConfig);
         console.log('this.productSearchBtnSectionConfig :: ', local_ProductSearchBtnSectionConfig);
        local_ProductSearchBtnSectionConfig.addSelectedToCartBtnLabel = local_ProductSearchBtnSectionConfig.addSelectedToCartBtnLabel.replace(/number/g, local_ProductSearchBtnSectionConfig.productAddedToCart);
        local_ProductSearchBtnSectionConfig.clearCartBtnLabel = local_ProductSearchBtnSectionConfig.clearCartBtnLabel.replace(/number/g, local_ProductSearchBtnSectionConfig.productAddedToCart);
        local_ProductSearchBtnSectionConfig.reviewCartLabel = local_ProductSearchBtnSectionConfig.reviewCartLabel.replace(/number/g, local_ProductSearchBtnSectionConfig.productAddedToCart);
         console.log('after local_ProductSearchBtnSectionConfig : ', local_ProductSearchBtnSectionConfig);
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
        console.log('this.productQuantityData after addToSelectedToCartHandleClick:', this.productQuantityData);
    }
    
    clearCartHandleClick(event) {

    }
    reviewCartHandleClick(event) {

    }
    // pageRecordCount = 0;
    // totalCount = 0;
    taskTypeHelpTextClass = 'slds-popover slds-popover_tooltip slds-nubbin_bottom-right slds-fall-into-ground slds-hide';
    togglePasswordHint() {
        // console.log('it worked')
        // return ;
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

    handleCheckboxChange(event) {
    const rowId = event.detail.rowId;
    const checkboxValue = event.detail.checkboxValue;
    let local_productQuantityData = this.productQuantityData;
    let rowIndex = local_productQuantityData.findIndex(element => element.productDetails.productId === rowId);
    console.log("Row index:", rowIndex);
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
    handleActive(event) {
        this.getactiveTabValue = event.target.value;
        if (this.getactiveTabValue === 'catalogSearch') {
            this.viewForCatalogSection = true;
        } else {
            this.viewForCatalogSection = false;
        }
    }



    // @track disciplineOptions = [];
    // Initialize pagination settings
    pageSizeOptions = [15, 25, 50, 75, 100]; //Page size options
    columns = []; //columns information available in the data table

    recordsToDisplay = []; //Records to be displayed on the page


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

    get bDisableFirst() {
        return this.pageNumber == 1;
    }
    get bDisableLast() {
        return this.pageNumber == this.totalPages;
    }
    onHandleSort(event) {
        // console.log('onHandleSort :: ', event.detail);
        this.sortedBy = event.detail.fieldName;
        this.sortDirection = event.detail.sortDirection;
        this.sortData(this.sortedBy, this.sortDirection);
    }
    sortData(fieldname, direction) {
        // console.log('sortData :: ', fieldname, direction);
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

    handleNext() {
        this.disableNext = true; // Disable next button for now (sample)
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
// connectedCallback() {
//     // Add event listener to listen for ISBN link clicks from Component B
//     this.addEventListener('isbnlinkclick', this.openChildTitlePage);
// }

// disconnectedCallback() {
//     // Remove event listener when the component is removed from the DOM
//     this.removeEventListener('isbnlinkclick', this.openChildTitlePage);
// }
}