import { LightningElement, track, wire, api } from 'lwc';
import { CartSummaryAdapter } from "commerce/cartApi";
import LightningAlert from 'lightning/alert';
import { RefreshEvent } from 'lightning/refresh';
import {  refreshCartSummary } from 'commerce/cartApi';
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

import populateSearchResults from '@salesforce/apex/scc_PlaceOrderMultiISBN_SearchController.populateSearchResults';
import { CustomLabels } from 'c/scc_customlablesLWC';
export default class scc_placeOrderMulti_ISBNSearch extends LightningElement {

    @track isSearchDisabled = true;
    @track recordIds = [];
    @track quantities = [];
    @track searchResults = [];
    @track searchResultsToShow = [];
    @track selectedItemCount = '';
    @track iscartDisabled = true;
    @track isReviewCart = true;
    @track productQuantityMap;
    @track newQuantity;
    @track showProductTitlePage = false;
    @track showsearchresult = false;
    @track selectedProductRecord
    @track selectedItems = [];
    @track productData = [];
    @track showResults = false;
    @track filterCriteria;// filter 
    @track productQuantityData = [];
     @track displayedRecords=0;
    showQuickSearch = true;

    @track selectedProducts = new Map();
    @track totalQuantity = 0;
    @track itemsInCart = [];
    @track itemsList = [];
    @track clearCartBtnDisabled = true;
    @track reviewCartDisabled = true;
    @track reviewCartPage = false;
    @track showProductSearchPage = true;
    @track addSelectedToCartBtnDisabled = true;
    @track addToCart = false;
    @track clearCartItems = false;
    @track productsInCart = 0;
    @track transformedDataLength = 0;
    @track totalCount = 0;
//lables
PlaceOrder_Multi_ISBN = CustomLabels.PlaceOrder_Multi_ISBN;
    @api userselection=[];
    @track userInputs=[];


    connectedCallback() {
        console.log('the user selected input',this.userselection);
        this.userInputs=this.userselection;
    }


    get addToCartButtonLabel() {
        return `Add to Cart (${this.totalQuantity})`;
    }
    get clearCartButtonLabel() {
        return `Clear Cart (${this.productsInCart})`;
    }
    get reviewCartButtonLabel() {
        return `Review Cart (${this.productsInCart})`;
    }
    @wire(CartSummaryAdapter)
    setCartSummary({ data, error }) {
        if (data) {
            this.activeCartId = data.cartId;
            this.productsInCart = data.totalProductCount
            if (this.productsInCart > 0) {
                this.clearCartBtnDisabled = false;
                this.reviewCartDisabled = false;
                this.clearCartItems = false;
            }else{
                this.clearCartBtnDisabled = true;
                this.reviewCartDisabled = true;
            }
            console.log('the current active cartid id', this.activeCartId, 'and the current data getting is', data);
            console.log('the active card product count is ', this.productsInCart);
        } else if (error) {
            console.error(error);
        }
    }
    addSelectedToCartHandleClick(event) {
        this.addToCart = true;
    }
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
          this.clearCartItems = false;
        this.refreshSummary();
    }


    async refreshSummary() {
        const response = await refreshCartSummary()
            .then((result => {
                this.isLoading = false;
                this.isEmptyCart = true;
            }));
    }

    clearCartHandleClick(event) {
        this.clearCartItems = true;
        console.log('the clear cart handle is called');

    }
    reviewCartHandleClick(event) {
      
       // this.reviewCartPage = true;
        this.showProductSearchPage = false;
        const customEvent = new CustomEvent('hideparenttab');
          this.dispatchEvent(customEvent);

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

    handleInputChange(event) {
        const input = String(event.target.value).trim();
         console.log('Input:', input);
        const lines = input.split('\n');
         console.log('Lines:', lines);
        this.recordIds = [];
        this.quantities = [];
        lines.forEach(line => {
            const parts = line.trim().split(/\s+/);
            if (parts.length === 2) {

                this.recordIds.push(parts[0]);
                this.quantities.push(parseInt(parts[1], 10));
            }
        });
           console.log('Record IDs:', this.recordIds);
          console.log('Quantities:', this.quantities);       
        this.isSearchDisabled = !(this.recordIds.length > 0 && this.recordIds.length === this.quantities.length);
    }


    get selectedItemsToCart() {
        let rowIndex = local_productQuantityData.filter(element => element.quantity === rowId);
        return 0;
    }

    handleClear() {
        const textAreaInput = this.template.querySelector('.arvicon-input');
        if (textAreaInput) {
            textAreaInput.value = '';
        }
        this.recordIds = '';
        this.searchResults = '';
        this.productQuantityData = [];
        this.isSearchDisabled = true;
        this.productData = [];
        this.showResults = false;
        this.productQuantityData = [];
        this.addSelectedToCartBtnDisabled = true;
        this.dispatchEvent(new RefreshEvent()); // Refresh the page       
    } 

    handleSearch() {
        if (this.recordIds.length > 0) {
            populateSearchResults({ recordIds: this.recordIds })
                .then(result => {
                    this.productData = result;  
                    console.log(this.productData);             
                    if (this.productData.length === 1) {
                        const selectedISBN = this.productData[0].ISBN;                                 
                        this.dispatchShowProductTitlePageEvent(selectedISBN);
                       // console.log('Selected Item:', this.productData);
                    } else {
                        for (let oneProduct of this.productData) {
                            // Find the index of the current product's ISBN in this.recordIds
                            const index = this.recordIds.indexOf(oneProduct.ISBN);
                            // If the ISBN exists in this.recordIds, use its corresponding quantity
                            if (index !== -1) {
                                // Create an instance of productQuantityWrapper using product details and quantity
                                let oneProductQuantity = new productQuantityWrapper(
                                    oneProduct.productId,  // Assuming ISBN is used as the productId
                                    oneProduct,
                                    this.quantities[index], // Access corresponding quantity using the index
                                    false, // checkboxValue
                                    false, // disableQuantity
                                    false, // hideCheckbox
                                    false // disabledCheckbox
                                );
                                // Push the created instance to the productQuantityData array
                                this.productQuantityData.push(oneProductQuantity);
                                console.log(this.productQuantityData);
                            }
                        }
                    }
                    this.showResults = true;
                })
                .catch(error => {
                    console.error('Error occurred while fetching search results:', error);
                });
        } else {
            console.log('No record IDs provided.');
        }
    }

    handleChange(event) {
        const index = event.target.dataset.index;
        const productId = this.searchResultsToShow[index].productid; // Get the product ID
        const newQuantity = parseInt(event.target.value, 10);
        if (this.searchResultsToShow[index]) {
            this.searchResultsToShow[index].quantity = newQuantity;
            this.productQuantityMap[productId] = newQuantity;
            const selectedItem = this.selectedItems.find(item => item.productid === productId);
            if (selectedItem) {
                selectedItem.quantity = newQuantity;
            }
        }
    }
    handleIconClick() {
    }

    handleISBNClick(event) {
        event.preventDefault();
        const selectedISBN = event.target.dataset.isbn;
        //console.log('Selected ISBN:', selectedISBN);
        this.dispatchShowProductTitlePageEvent(selectedISBN);
        this.showProductTitlePage = true;
    }
    dispatchShowProductTitlePageEvent(selectedISBN) {
       // console.log('Selected Item:', this.productData);
        const selectedItem = this.productData.find(item => item.ISBN === selectedISBN);
       // console.log('Selected Item:', selectedItem);
        if (selectedItem) {
            this.selectedProductRecord = {
                productId: selectedItem.productId,
                Title_Description: selectedItem.Title_Description,
                Grade_Level: selectedItem.Grade_Level,
                Copyright: selectedItem.Copyright,
                Status: selectedItem.Status,
                Type: selectedItem.ProductSubType,
                Price: selectedItem.Price,
                ISBN: selectedItem.ISBN
            };
          //  console.log('selectedProductRecord:', this.selectedProductRecord);

            const selectEvent = new CustomEvent('showproducttitlepage', {
                detail: {
                    parentSelectedProductRecord: this.selectedProductRecord
                }
            });
            this.dispatchEvent(selectEvent);
            //console.log('Current Selected Product selectEvent:', selectEvent);
        }
    }
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
        // console.log('this.productSearchBtnSectionConfig :: ', local_ProductSearchBtnSectionConfig);
        local_ProductSearchBtnSectionConfig.addSelectedToCartBtnLabel = local_ProductSearchBtnSectionConfig.addSelectedToCartBtnLabel.replace(/number/g, local_ProductSearchBtnSectionConfig.productAddedToCart);
        local_ProductSearchBtnSectionConfig.clearCartBtnLabel = local_ProductSearchBtnSectionConfig.clearCartBtnLabel.replace(/number/g, local_ProductSearchBtnSectionConfig.productAddedToCart);
        local_ProductSearchBtnSectionConfig.reviewCartLabel = local_ProductSearchBtnSectionConfig.reviewCartLabel.replace(/number/g, local_ProductSearchBtnSectionConfig.productAddedToCart);
        //   console.log('after local_ProductSearchBtnSectionConfig : ', local_ProductSearchBtnSectionConfig);
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

    updateAddToCartButtonState() {

        this.iscartDisabled = this.selectedItemCount === 0;
    }

    handleMouseOver() {
        this.displayText = true;
    }

    handleMouseLeave() {
        this.displayText = false;
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
            this.productSearchBtnSectionConfig.productAddedToCart = selectedProductCount;
        }
        this.productQuantityData = Object.assign([], local_productQuantityData);


    }

    openChildTitlePage(event) {
        // Retrieve the selected product record from the event
        const selectedProductRecord = event.detail.parentSelectedProductRecord;

       const displayedRecords = event.detail.displayedRecords;
        // Dispatch an event to notify Component A to display Component D
        const displayDEvent = new CustomEvent('showproducttitlepage', {
            detail: {
                //selectedProductRecord: selectedProductRecord
                parentSelectedProductRecord: selectedProductRecord,
            }
        });
        this.dispatchEvent(displayDEvent);
    }
   

    // Handle custom event from child
    // handleUpdatedChildTableData(event) {
    //     this.displayedRecords = event.detail.displayedRecords;
    //     console.log( this.displayedRecords);
    //     console.log('lightway');
    // }

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