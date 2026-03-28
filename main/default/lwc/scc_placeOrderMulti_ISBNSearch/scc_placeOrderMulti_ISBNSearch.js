import { LightningElement, track, wire, api } from 'lwc';
import { CartSummaryAdapter } from "commerce/cartApi";
import guestCartDetails from '@salesforce/apex/scc_confirmAddress.guestCartDetails';
import isGuestUser from '@salesforce/apex/scc_checkOutLWC_Controller.isGuestUser';
import deleteAllCartItems from '@salesforce/apex/scc_addItemsToCartController.deleteAllCartItems';
import LightningAlert from 'lightning/alert';
import { RefreshEvent } from 'lightning/refresh';
import { refreshCartSummary } from 'commerce/cartApi';
import scc_checkout_cart from "@salesforce/resourceUrl/scc_checkout_cart";
import scc_checkout_cart_white from "@salesforce/resourceUrl/scc_checkout_cart_white";
import MESSAGE_CHANNEL from '@salesforce/messageChannel/scc_MessageChannel__c';
import { publish, MessageContext } from 'lightning/messageService';
import getEnableConsoleLogsTrue from '@salesforce/apex/scc_headerLWC_Controller.getEnableConsoleLogsTrue' ;
import scc_stateFilterMessage from "@salesforce/label/c.scc_stateFilterMessage";

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
    @track quantities = new Map()
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
    @track displayedRecords = 0;
    showQuickSearch = true;
    showWarningMessage = false;
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
    @track activeCartId = '';
    @track isGuest = false;
    @track userInputMultiISBN = '';
    @track isModalOpen = false;
    @api multireturn;
    @api multiuserinput;
    @track returnsearch = false;
    filterSearchValue = '';
    @track input = '';
    @track activeProducts = true; // Checked by default
    //lables
    PlaceOrder_Multi_ISBN = CustomLabels.PlaceOrder_Multi_ISBN;
    @api userselection = [];
    @track userInputs = [];
    @track enableLogs = false;
    @track defaultNationalStateValue = false;

    labels = {
        scc_checkout_cart,
        scc_checkout_cart_white,
        scc_stateFilterMessage
    }

    constructor() {
        super();
        isGuestUser().then(response => {
            if (response) {
                this.isGuest = true;                
                const urlParams = new URLSearchParams(window.location.search);
                this.activeCartId = urlParams.get('CartId');                
                this.fetchcartDetails();
            }
        }).catch(error => {
            if(this.enableLogs){
            console.log('error in checking if it is a guest user', error);
            }
        })
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
        
        this.userInputs = this.userselection; 
         // Set initial value of National/State filter to false
        const customTable = this.template.querySelector('c-scc_custom-table');
        if(customTable) {
            customTable.handleNationalStateFilter(false);
        }       
        setTimeout(()=>{
            let eve = {target:{value:this.multireturn}};
            this.handleInputChange(eve);
        }, 50);
        if(this.multireturn)
        {            
            
            setTimeout(()=>{
           this.handleSearch();
        }, 1000);
            this.showResults = true;
            this.showProductTitlePage = false;
            
        }
                    
        window.addEventListener('placeOrdermultiISBNtextAreaFocus', this.focustextArea.bind(this));
    }

   focustextArea(){
        setTimeout(() => {
            if(this.template.querySelector(".placeOrdermultiIsbntextarea") != undefined){
                this.template.querySelector(".placeOrdermultiIsbntextarea").focus();
                 window.scrollTo({ top: 100, behavior: 'smooth' });
            }
        }, 100);
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
    convertToInt(value) {
        return parseInt(value, 10);
    }

    @wire(MessageContext)
    messageContext;

    @wire(CartSummaryAdapter)
    setCartSummary({ data, error }) {
        if (data) {
            this.activeCartId = data.cartId;
            this.productsInCart = this.convertToInt(data.totalProductCount);
            if (this.productsInCart > 0) {
                this.clearCartBtnDisabled = false;
                this.reviewCartDisabled = false;
                this.clearCartItems = false;
            } else {
                this.clearCartBtnDisabled = true;
                this.reviewCartDisabled = true;
            }
            publish(this.messageContext, MESSAGE_CHANNEL, { cartCount: this.productsInCart });            
        } else if (error && !this.isGuest) {
              this.productsInCart = 0;
               this.activeCartId='';
              this.setProductCount();
              console.error(error);
        }
    }

    fetchcartDetails() {
        guestCartDetails({ guestCartId: this.activeCartId }).then(response => {
            if(this.enableLogs){
            console.log('guestCartDetails response', response);
            }
            if (response) {
                this.activeCartId = response.Id;
                this.productsInCart = this.convertToInt(response.TotalProductCount);
                if (this.productsInCart > 0) {
                    this.clearCartBtnDisabled = false;
                    this.reviewCartDisabled = false;
                    this.clearCartItems = false;
                } else {
                    this.clearCartBtnDisabled = true;
                    this.reviewCartDisabled = true;
                }
                publish(this.messageContext, MESSAGE_CHANNEL, { cartCount: this.productsInCart });                
            }
        }).catch(error => {
            if(this.enableLogs){
            console.log('error in fetching guestCartDetails', error);
            }
            this.productsInCart = 0;
            this.setProductCount();
        })
    }

    addSelectedToCartHandleClick(event) {
      if (!JSON.parse(this.template.querySelector('.add-to-cart').getAttribute('aria-disabled'))) {  
        this.addToCart = true;
      }
    }
    handleReviewCartCount() {        
        this.selectedProducts = new Map();
        this.addSelectedToCartBtnDisabled = true;
        this.clearCartItems = false;
        this.addToCart = false;
        this.totalQuantity = 0;
        if (this.userInputs[0].guestCartId != '' && this.userInputs[0].guestCartId !== undefined ) {
            this.refreshCart();
        } else {
            this.refreshSummary();
        }
        this.dispatchEvent(new RefreshEvent());        
    }
     
    handleresetaddtocart()
        {
        this.addToCart = false
        //this.addSelectedToCartBtnDisabled = true;
        this.clearCartItems = false;
        this.dispatchEvent(new RefreshEvent());
        }

    handlerefreshevent() {
        this.clearCartItems = false;
        if (this.userInputs[0].guestCartId != '' && this.userInputs[0].guestCartId !== undefined ) {
            this.refreshCart();
        } else {
            this.refreshSummary();
        }
    }


    async refreshSummary() {
        const response = await refreshCartSummary()
            .then((result => {
                this.isLoading = false;
                this.isEmptyCart = true;
            }));
    }

    refreshCart() {
        let cartId = this.userInputs[0].guestCartId != '' ? this.userInputs[0].guestCartId : '';
        guestCartDetails({ guestCartId: cartId }).then(response => {
            if(this.enableLogs){
                console.log('guestCartDetails response', response);
            }
            if (response) {
                this.activeCartId = response.Id;
                this.productsInCart = this.convertToInt(response.TotalProductCount);
                this.isLoading = false;
                this.isEmptyCart = true;
                publish(this.messageContext, MESSAGE_CHANNEL, { cartCount: this.productsInCart });
            }
        }).catch(error => {
            if(this.enableLogs){
            console.log('error in fetching guestCartDetails', error);
            }
        })
    }

    clearCartHandleClick(event) {
      if (!JSON.parse(this.template.querySelector('.clear-cart').getAttribute('aria-disabled'))) { 
        this.isModalOpen = true;        
      }
    }

    handleClearCart() {
        if (this.isGuest) {
            this.handleClearAllItems();
        } else {
            this.clearCartItems = true;
        }        
        this.isModalOpen = false;

    }

    handleClearAllItems() {
        this.isLoading = true;
        deleteAllCartItems({ activeCartId: this.activeCartId })
            .then(() => {
                const customEvent = new CustomEvent('refreshevent');
                this.dispatchEvent(customEvent);
                this.refreshCart();
                this.setProductCount();
            })
            .catch((e) => {
                console.error('lwc delete all cart items error - ', e);
            });
    }

    setProductCount() {
        this.productsInCart = "0";
        this.clearCartBtnDisabled = true;
        this.reviewCartDisabled = true;
        publish(this.messageContext, MESSAGE_CHANNEL, { cartCount: this.productsInCart });
    }

    closeModal() {
        this.isModalOpen = false;
    }
    handleCancel() {
        this.isModalOpen = false;
    }

    reviewCartHandleClick(event) {
      if (!JSON.parse(this.template.querySelector('.review-cart').getAttribute('aria-disabled'))) {        
        this.showProductSearchPage = false;
        const customEvent = new CustomEvent('hideparenttab');
        this.dispatchEvent(customEvent);
      }
    }
    handleQuantityChange(event) {
        this.totalQuantity = event.detail;
        if (this.totalQuantity > 0) {
            this.addSelectedToCartBtnDisabled = false;
        }
        else {
            this.addSelectedToCartBtnDisabled = true;
        }
        if(this.enableLogs){
        console.log('the total quanity is', this.totalQuantity);
        }
    }

    
handleInputChange(event) {
    this.input = event.target.value.trim();
    if(this.multireturn)
    {
         event.target.value= this.input;//Added for return to search
    }       
    this.userInputMultiISBN = this.input;
    // Split input by new lines
    const lines = this.input.split('\n');
    this.recordIds = [];   // Store ISBNs
    this.quantities = new Map();  // Store Quantities

    // Iterate over each line to process ISBN and quantity
    lines.forEach(line => {
        const parts = line.trim().split(/\s+/);  // Split by whitespace
        if (parts.length >= 2) {
            const isbn = parts[0].trim();
            const quantity = parseInt(parts[1], 10);

            if (!isNaN(quantity)) {  // Make sure quantity is a number
                this.recordIds.push(isbn);
                this.quantities.set(isbn,quantity);
                 this.isSearchDisabled = !(this.recordIds.length > 0 && this.recordIds.length === this.quantities.size);
            } else {
                if(this.enableLogs){
                console.log('Invalid quantity for ISBN:', isbn);
                }
            }
        }
    });
    if(this.multireturn)
    {        
         this.handleSearch();//Added for return to search
    }

    if(this.enableLogs){
    console.log('Record IDs:', this.recordIds);
    console.log('Quantities:', this.quantities);
    console.log('userInputMultiISBN:', this.userInputMultiISBN);
    }

}
    get selectedItemsToCart() {
        let rowIndex = local_productQuantityData.filter(element => element.quantity === rowId);
        return 0;
    }

    handleClear(event) {
        if (!JSON.parse(this.template.querySelector('.clear-button').getAttribute('aria-disabled'))) {
        const textAreaInput = this.template.querySelector('.arvicon-input');
        if (textAreaInput) {
            textAreaInput.value = '';
        }
        this.recordIds = [];
        this.quantities = [];
        this.totalQuantity = 0;
        this.searchResults = [];
        this.productQuantityData = [];
        this.isSearchDisabled = true;
        this.productData = [];
        this.showResults = false;
        this.addSelectedToCartBtnDisabled = true;
        this.filterSearchValue = '';
        this.filterCriteria = '';
        this.userInputMultiISBN = '';
        this.showWarningMessage = false;
        this.dispatchEvent(new RefreshEvent()); // Refresh the page
        this.activeProducts = true;
        this.transformedDataLength = 0;
        this.totalCount = 0;
       }
    }

    //quantity warning pop-up
    handleQuantity() {
        this.showWarningMessage = false;
        this.showResults = true;
    }
    closeCartModal() {
        this.showWarningMessage = false;
    }
    handleCancelBtn() {
        this.showWarningMessage = false;
        this.showResults = false;

    }
      // Event handler for active products checkbox change
    handleActiveProductsChange(event) {
        this.activeProducts = event.target.checked;
    }

    handleSearch() {
      if (!JSON.parse(this.template.querySelector('.search-button').getAttribute('aria-disabled'))) {             
    if (this.recordIds.length > 0) {
        this.isLoading = true;
        
        // Clear previous results
        this.productData = [];
        this.productQuantityData = [];
        this.showResults = false;
        
        populateSearchResults({ recordIds: this.recordIds,
         activeProducts: this.activeProducts})
            .then(result => {
                this.productData = result;
                if(this.enableLogs){
                console.log('Search results:', this.productData);
                }
                if (this.productData.length === 1) {
                    const selectedISBN = this.productData[0].ISBN;
                    this.dispatchShowProductTitlePageEvent(selectedISBN);
                } else {
                    this.productQuantityData = this.productData.map((oneProduct) => {
                         const quantity = this.quantities.get(oneProduct.ISBN)||0;
                        return new productQuantityWrapper(
                            oneProduct.productId,
                            oneProduct,
                            quantity,
                            false,
                            false,
                            false,
                            false
                        );
                    });
                }
                
                this.showResults = true;
                this.showWarningMessage = this.quantities.some(q => q > 1000);
                
                // Force UI update
                this.productQuantityData = [...this.productQuantityData];
            })
            .catch(error => {
                console.error('Error occurred while fetching search results:', error);
                // Handle error (e.g., show error message to user)
            })
            .finally(() => {
                this.isLoading = false;
            });
    } else {
        if(this.enableLogs){
        console.log('No record IDs provided.');
        }
        // Optionally show a message to the user
    }
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
        this.dispatchShowProductTitlePageEvent(selectedISBN);
        this.showProductTitlePage = true;
    }
    dispatchShowProductTitlePageEvent(selectedISBN) {        
        const selectedItem = this.productData.find(item => item.ISBN === selectedISBN);        
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

            const selectEvent = new CustomEvent('showproducttitlepage', {
                detail: {
                    parentSelectedProductRecord: this.selectedProductRecord,

                }
            });
            this.dispatchEvent(selectEvent);            
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
        local_ProductSearchBtnSectionConfig.addSelectedToCartBtnLabel = local_ProductSearchBtnSectionConfig.addSelectedToCartBtnLabel.replace(/number/g, local_ProductSearchBtnSectionConfig.productAddedToCart);
        local_ProductSearchBtnSectionConfig.clearCartBtnLabel = local_ProductSearchBtnSectionConfig.clearCartBtnLabel.replace(/number/g, local_ProductSearchBtnSectionConfig.productAddedToCart);
        local_ProductSearchBtnSectionConfig.reviewCartLabel = local_ProductSearchBtnSectionConfig.reviewCartLabel.replace(/number/g, local_ProductSearchBtnSectionConfig.productAddedToCart);        
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
        this.filterSearchValue = event.target.value;
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
    clearFilterInput(event) {
        this.filterSearchValue = '';
        this.filterCriteria = '';

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
        const userinputofmulti = event.detail.userinputmulti;       

        const displayedRecords = event.detail.displayedRecords;
        // Dispatch an event to notify Component A to display Component D
        const displayDEvent = new CustomEvent('showproducttitlepage', {
            detail: {
                //selectedProductRecord: selectedProductRecord
                parentSelectedProductRecord: selectedProductRecord,
                userinputofmulti: userinputofmulti

            }
        });
        this.dispatchEvent(displayDEvent);
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
handleTransformedDataLength(event) {
    this.transformedDataLength = event.detail.transformedDataLength;
    this.totalFilteredRecords = event.detail.totalFilteredRecords;
    //this.totalCount = event.detail.totalCount;
    // this.displayedRecords = this.totalFilteredRecords;
    // this.totalItems = this.totalCount;
    if (event.detail.totalFilteredRecords) {
            this.totalFilteredRecords = event.detail.totalFilteredRecords;
            this.totalCount = this.totalFilteredRecords;
        } else {
            this.totalCount = event.detail.totalCount;
        }
}

     @track nationalStateFilter = false; 
      handleNationalStateFilterChange(event) {
        this.nationalStateFilter = event.target.checked;
        const customTable = this.template.querySelector('c-scc_custom-table');
        if(customTable) {
            customTable.handleNationalStateFilter(this.nationalStateFilter);
        }
    }

}