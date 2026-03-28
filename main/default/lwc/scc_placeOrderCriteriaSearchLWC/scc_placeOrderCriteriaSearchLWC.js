/*******************************************************************************************************
 * @Component Name: Scc_placeOrderCriteriaSearchLWC
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
import isGuestUser from '@salesforce/apex/scc_checkOutLWC_Controller.isGuestUser';
import searchProducts from '@salesforce/apex/scc_placeOrderISBNSearch_Controller.searchProducts';
import errormessage from '@salesforce/label/c.scc_productcriteriaerrormessage';
import guestCartDetails from '@salesforce/apex/scc_confirmAddress.guestCartDetails';
import deleteAllCartItems from '@salesforce/apex/scc_addItemsToCartController.deleteAllCartItems';
import { CartSummaryAdapter } from "commerce/cartApi";
import LightningAlert from 'lightning/alert';
import { RefreshEvent } from 'lightning/refresh';
import { refreshCartSummary } from 'commerce/cartApi';
import scc_checkout_cart from "@salesforce/resourceUrl/scc_checkout_cart";
import scc_checkout_cart_white from "@salesforce/resourceUrl/scc_checkout_cart_white";
import scc_stateFilterMessage from "@salesforce/label/c.scc_stateFilterMessage";
import MESSAGE_CHANNEL from '@salesforce/messageChannel/scc_MessageChannel__c';
import { publish, MessageContext } from 'lightning/messageService';
import getEnableConsoleLogsTrue from '@salesforce/apex/scc_headerLWC_Controller.getEnableConsoleLogsTrue';
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
    @track selectedDiscipline = '';
    @track titlekeyword = '';
    @track isbnValue = '';
    @track activeProducts = true;
    @track searchDisabled = true;
    @track showResults = false;
    @track clearCartItems = false;
    @track productData = [];
    @track disableNext = true;
    @track currentPagetableData = [];
    @track productData = [];
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
    @api userselection;
    @track userInputs = [];
    @track activeCartId;
    @track currentTab = 'tab-default-1__item';
    @track disableClearButton = true;
    @track isGuest = false;
    @track isModalOpen = false;
    @track userInputOfMultiISBN = '';
    @track multiReturnPages;
    filterSearchValue = '';
    @track enableLogs = false;
    labels = {
        scc_checkout_cart,
        scc_checkout_cart_white,
        scc_stateFilterMessage
    }
    constructor() {
        super();
        window.scrollTo({
            top: 0,
            behavior: 'smooth'
        });
        isGuestUser().then(response => {
            if (response) {
                this.isGuest = true;
                if (this.enableLogs) console.log('isGuest', this.isGuest);
                const urlParams = new URLSearchParams(window.location.search);
                this.activeCartId = urlParams.get('CartId');
                if (this.enableLogs) console.log('accountId', this.guestAccountId);
                this.fetchcartDetails();
            }
        }).catch(error => {
            if (this.enableLogs) console.log('error in checking if it is a guest user', error);
        })
    }
    @wire(MessageContext)
    messageContext;
    connectedCallback() {
        getEnableConsoleLogsTrue().then(response => {
            this.enableLogs = response;
            if (this.enableLogs) console.log('getEnableConsoleLogsTrue response is', response);
        }).catch(error => {
            if (this.enableLogs) console.log('error is', error);
        });
        if (this.enableLogs) console.log('the user selected input', this.userselection);
        this.userInputs = this.userselection;
        if (this.enableLogs) console.log('connected-----------');
        this.template.addEventListener('keydown', this.handleKeydown.bind(this));
    }
    disconnectedCallback() {
        if (this.enableLogs) console.log('disconnected-----------');
        this.template.removeEventListener('keydown', this.handleKeydown);
    }
    handleKeydown(event) {
        if (event.key === 'Escape') {
            if (this.enableLogs) console.log('Escape key pressed');
            if (this.isModalOpen) {
                this.closeModal();
            }
        }
    }
    records = [];
    totalRecords = 0;
    pageSize;
    totalPages;
    pageNumber = 1;
    pageSizeOptions = [15, 25, 50, 75, 100];
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
    @track multiReturnPage = false;
    get addToCartButtonLabel() {
        if (this.enableLogs) console.log('add to cart count---------', this.productsInCart);
        return `Add to Cart (${this.totalQuantity})`;
    }
    get clearCartButtonLabel() {
        if (this.enableLogs) console.log('clear cart count---------', this.productsInCart);
        return `Clear Cart (${this.productsInCart})`;
    }
    get reviewCartButtonLabel() {
        if (this.enableLogs) console.log('review cart count---------', this.productsInCart);
        return `Review Cart (${this.productsInCart})`;
    }
    setProductCount() {
        this.productsInCart = "0";
        this.clearCartBtnDisabled = true;
        this.reviewCartDisabled = true;
        publish(this.messageContext, MESSAGE_CHANNEL, { cartCount: this.productsInCart });
    }
    convertToInt(value) {
        return parseInt(value, 10);
    }
    fetchcartDetails() {
        guestCartDetails({ guestCartId: this.activeCartId }).then(response => {
            if (this.enableLogs) console.log('guestCartDetails response', response);
            if (response) {
                this.activeCartId = response.Id;
                this.productsInCart = this.convertToInt(response.TotalProductCount);
                if (this.enableLogs) console.log('guestCartDetails productsInCart', this.productsInCart);
                if (this.productsInCart > 0) {
                    this.clearCartBtnDisabled = false;
                    this.reviewCartDisabled = false;
                    this.clearCartItems = false;
                    if (this.firstLoad == true) {
                        this.firstLoad = false;
                        this.refreshCart();
                    }
                } else {
                    this.clearCartBtnDisabled = true;
                    this.reviewCartDisabled = true;
                }
                publish(this.messageContext, MESSAGE_CHANNEL, { cartCount: this.productsInCart });
                if (this.enableLogs) console.log('the current active cartid id', this.activeCartId, 'and the current data getting is', response);
                if (this.enableLogs) console.log('the active card product count is ', this.productsInCart);
            }
        }).catch(error => {
            if (this.enableLogs) console.log('error in fetching guestCartDetails', error);
            this.productsInCart = 0;
            this.setProductCount();
        })
    }
    @wire(CartSummaryAdapter)
    setCartSummary({ data, error }) {
        if (data) {
            this.activeCartId = data.cartId;
            this.productsInCart = this.convertToInt(data.totalProductCount);
            if (this.productsInCart > 0) {
                this.clearCartBtnDisabled = false;
                this.reviewCartDisabled = false;
                this.clearCartItems = false;
                if (this.firstLoad == true) {
                    this.firstLoad = false;
                    this.refreshSummary();
                }
            } else {
                this.clearCartBtnDisabled = true;
                this.reviewCartDisabled = true;
            }
            publish(this.messageContext, MESSAGE_CHANNEL, { cartCount: this.productsInCart });
            if (this.enableLogs) console.log('the current active cartid id', this.activeCartId, 'and the current data getting is', data);
            if (this.enableLogs) console.log('the active card product count is ', this.productsInCart);
        } else if (error && !this.isGuest) {
            this.productsInCart = 0;
            this.activeCartId = '';
            this.setProductCount();
            if (this.enableLogs) console.log('error in wire', error, '====', this.productsInCart);
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
        }
    }
    handleTextInputChange(event) {
        if (event.target.dataset.id == 'isbn') {
            this.isbnValue = event.target.value;
        } else {
            this.titlekeyword = event.target.value;
        }
        this.checkSearchButtonState();
        if (this.enableLogs) console.log('Current search values after input change:', {
            isbnValue: this.isbnValue,
            titlekeyword: this.titlekeyword
        });
    }
    handleActiveProductsChange(event) {
        this.activeProducts = event.target.checked;
        this.checkSearchButtonState();
    }
    checkSearchButtonState() {
        this.searchDisabled = !(this.selectedDiscipline || this.titlekeyword || this.isbnValue);
        this.disableClearButton = !(this.selectedDiscipline || this.titlekeyword || this.isbnValue);
        if (this.enableLogs) console.log('Search button disabled:', this.searchDisabled);
    }
handleSearch(event) {
    if (!JSON.parse(this.template.querySelector('.search-button').getAttribute('aria-disabled'))) {
        if (this.searchDisabled) {
            return;
        }

        if (this.enableLogs) {
            console.log('Search button Clicked', this.titlekeyword);
        }

        const startTime = performance.now();
        const searchStartDateTime = new Date();
        if (this.enableLogs) {
            console.log(`Search initiated on: ${searchStartDateTime.toLocaleString()}`);
        }

        this.isLoading = true;
        this.productData = [];
        this.productQuantityData = [];
        this.showResults = false;
        this.showSearchResultErrorMessage = false;

        if (this.enableLogs) {
            console.log(`Time to initialize: ${(performance.now() - startTime).toFixed(3)}ms`);
        }

        const searchStartTime = performance.now();

        searchProducts({
            isbnValue: this.isbnValue,
            selectedDiscipline: this.selectedDiscipline,
            titlekeyword: this.titlekeyword,
            activeProducts: this.activeProducts
        })
        .then(result => {
            const searchEndTime = performance.now();
            const searchDurationSeconds = (searchEndTime - searchStartTime) / 1000;
            const searchEndDateTime = new Date();

            if (this.enableLogs) {
                console.log(`Search completed on: ${searchEndDateTime.toLocaleString()}`);
                console.log(`Time to get search results from Salesforce: ${searchDurationSeconds.toFixed(3)} seconds`);
                console.log('Search results:', result);
            }

            this.productData = result;
            this.productQuantityData = [];

            for (let oneProduct of this.productData) {
                let oneProductQuantity = new productQuantityWrapper(
                    oneProduct.productId, 
                    oneProduct, 
                    '0', 
                    false, 
                    true, 
                    false, 
                    false
                );
                this.productQuantityData.push(oneProductQuantity);
            }

            this.records = result;
            this.totalRecords = result.length;
            this.pageSize = this.pageSizeOptions[0];
            this.paginationHelper();

            const processingTime = performance.now();
            if (this.enableLogs) {
                console.log(`Time to process results: ${(processingTime - searchEndTime).toFixed(3)}ms`);
            }

            if (this.productData && this.productData.length > 0) {
                this.showSearchResultErrorMessage = false;
                this.showResults = true;

                // Apply National/State filter since it's true by default
                const customTable = this.template.querySelector('c-scc_custom-table');
                if (customTable) {
                    customTable.handleNationalStateFilter(true);
                }

                if (this.productData.length === 1) {
                    this.showTabset = false;
                    this.showProductTitlePage = true;
                    this.selectedProductRecord = this.productData[0];
                } else {
                    this.showTabset = true;
                    this.showProductTitlePage = false;
                }
            } else {
                this.showSearchResultErrorMessage = true;
                this.showResults = false;
                this.showProductTitlePage = false;
            }

            this.error = undefined;
        })
        .catch(error => {
            const searchEndTime = performance.now();
            const searchDurationSeconds = (searchEndTime - searchStartTime) / 1000;
            const searchEndDateTime = new Date();

            if (this.enableLogs) {
                console.log(`Error occurred on: ${searchEndDateTime.toLocaleString()}`);
                console.log(`Time taken before error occurred: ${searchDurationSeconds.toFixed(3)} seconds`);
                console.error('Error fetching results:', error);
            }

            this.error = error;
            this.productData = [];
            this.showResults = false;
            this.showProductTitlePage = false;
            this.showTabset = true;
            this.showSearchResultErrorMessage = true;
        })
        .finally(() => {
            this.isLoading = false;
            this.productQuantityData = [...this.productQuantityData];

            const endTime = performance.now();
            const totalDurationSeconds = (endTime - startTime) / 1000;

            if (this.enableLogs) {
                console.log(`Total search process completed on: ${new Date().toLocaleString()}`);
                console.log(`Total time for search process: ${totalDurationSeconds.toFixed(3)} seconds`);
            }
        });
    }
}
    closeChildTitlePage(event) {
        setTimeout(() => {
            let eve = { target: { dataset: { id: event.detail.currentTab } } };
            this.handleActive(eve);
        }, 50);
        this.addSelectedToCartBtnDisabled = true;
        if (event.detail.currentTab == 'tab-default-2__item') {
            this.multiReturnPage = true;
            this.multiReturnPages = event.detail.multiinputs;
            this.showResults = false;
        }
        else if (event.detail.currentTab == 'tab-default-3__item') {
            this.showResults = false;
        }
        else {
            this.showProductTitlePage = false;
            this.addSelectedToCartBtnDisabled = true;
            this.totalQuantity = 0;
            this.showTabset = true;
            this.showResults = true;
        }
        this.showProductTitlePage = false;
        this.addSelectedToCartBtnDisabled = true;
        this.totalQuantity = 0;
        this.showTabset = true;
    }
    continueshopping(event) {
        if (this.enableLogs) console.log('event.detail.currenttab', event.detail.currentTab);
        setTimeout(() => {
            let eve = { target: { dataset: { id: event.detail.currentTab } } };
            this.handleActive(eve);
        }, 50);
        this.titlekeyword = '';
        this.isbnValue = '';
        this.addSelectedToCartBtnDisabled = true;
        this.showProductTitlePage = false;
        this.totalQuantity = 0;
        this.showTabset = true;
        this.showResults = false;
        this.showProductSearchPage = true;
        this.productQuantityData = [];
        this.transformedDataLength = 0;
        this.totalCount = 0;
    }
    handleClear() {
        if (!JSON.parse(event.target.getAttribute('aria-disabled'))) {
            this.disableClearButton = true;
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
            this.productQuantityData = [];
            this.addSelectedToCartBtnDisabled = true;
            this.totalQuantity = 0;
            this.transformedDataLength = 0;
            this.totalCount = 0;
            this.dispatchEvent(new RefreshEvent());
        }
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
    handleshowproducttitlepage(event) {
        this.showTabset = false;
        this.showProductTitlePage = true;
        this.selectedProductRecord = event.detail.parentSelectedProductRecord;
        this.userInputOfMultiISBN = event.detail.userinputofmulti;
    }
    handleRowAction(row, action) {
        if (action === 'infoPrice') {
            LightningAlert.open({
                message: 'Title: ' + row.Title_Description + '      ' + '\nISBN: ' + row.ISBN + '\nPrice: ' + row.Price,
                label: 'View Price',
                theme: 'gray-ish blue',
            }).then((result) => {
            });
        }
        if (action === 'viewRecords') {
            this.showProductTitlePage = true;
            this.selectedProductRecord = row;
            this.showTabset = false;
        }
    }
    tableRowAction(event) {
        let fieldName = event.target.dataset.fieldName;
        let rowId = event.target.dataset.rowId;
        if (this.enableLogs) console.log('tableRowAction ::  ', rowId, fieldName);
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
            rowInfo.quantity = rowValue;
            local_productQuantityData[rowIndex] = rowInfo;
            if (this.enableLogs) console.log('tableRowAction quantity count ::  ', rowValue, rowInfo, 'id value is', currentRecordId, 'and name is', customName, 'and price is', customPrice);
            this.addProductsToCart(currentRecordId, rowValue, customPrice, customName);
            if (this.enableLogs) console.log('the values in productss is', this.selectedProducts);
        }
        if (fieldName == 'isbnId') {
            let rowIndex = local_productQuantityData.findIndex(element => element.productDetails.productId === rowId);
            let rowInfo = local_productQuantityData[rowIndex];
            this.handleRowAction(rowInfo.productDetails, 'viewRecords');
        }
        this.productQuantityData = Object.assign([], local_productQuantityData);
    }
    addProductsToCart(currentRecordId, rowValue, customPrice, customName) {
        this.callAddItemToCart = false;
        if (this.selectedProducts.has(currentRecordId)) {
            let existingItem = this.selectedProducts.get(currentRecordId);
            existingItem.Quantity = rowValue;
            this.selectedProducts.set(currentRecordId, existingItem);
        } else {
            this.selectedProducts.set(currentRecordId, {
                Product2Id: currentRecordId,
                Quantity: rowValue,
                SalesPrice: customPrice,
                Name: customName
            });
        }
        this.updateTotalquantity();
        if (this.enableLogs) console.log('the values for add to cart', this.selectedProducts);
    }
    updateTotalquantity() {
        let sum = 0;
        this.selectedProducts.forEach((value, key) => {
            sum += parseInt(value.Quantity);
            if (this.enableLogs) console.log('the key and value is', value, 'and', key);
        });
        this.totalQuantity = sum;
        if (this.totalQuantity > 0) {
            this.addSelectedToCartBtnDisabled = false;
        }
        else {
            this.addSelectedToCartBtnDisabled = true;
        }
        if (this.enableLogs) console.log('the total quanity is', this.totalQuantity);
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
        local_ProductSearchBtnSectionConfig.addSelectedToCartBtnLabel = local_ProductSearchBtnSectionConfig.addSelectedToCartBtnLabel.replace(/number/g, local_ProductSearchBtnSectionConfig.productAddedToCart);
        local_ProductSearchBtnSectionConfig.clearCartBtnLabel = local_ProductSearchBtnSectionConfig.clearCartBtnLabel.replace(/number/g, local_ProductSearchBtnSectionConfig.productAddedToCart);
        local_ProductSearchBtnSectionConfig.reviewCartLabel = local_ProductSearchBtnSectionConfig.reviewCartLabel.replace(/number/g, local_ProductSearchBtnSectionConfig.productAddedToCart);
        return local_ProductSearchBtnSectionConfig;
    }
    addSelectedToCartHandleClick(event) {
        if (!JSON.parse(event.target.getAttribute('aria-disabled'))) {
            this.addToCart = true;
        }
    }
    handleReviewCartCount() {
        if (this.enableLogs) console.log('review cart count is');
        this.selectedProducts = new Map();
        this.addSelectedToCartBtnDisabled = true;
        this.clearCartItems = false;
        this.addToCart = false;
        this.totalQuantity = 0;
        if (this.userInputs[0].guestCartId != '' && this.userInputs[0].guestCartId !== undefined) {
            if (this.enableLogs) console.log('this.userInputs[0].guestCartId', this.userInputs[0].guestCartId);
            this.refreshCart();
        } else {
            this.refreshSummary();
        }
        this.dispatchEvent(new RefreshEvent());
        if (this.enableLogs) console.log('review cart count is');
    }
    handlerefreshevent() {
        if (this.userInputs[0].guestCartId != '' && this.userInputs[0].guestCartId !== undefined) {
            this.refreshCart();
        } else {
            this.refreshSummary();
        }
    }
    handleresetaddtocart() {
        this.addToCart = false
        this.clearCartItems = false;
        this.dispatchEvent(new RefreshEvent());
    }
    refreshCart() {
        let cartId = this.userInputs[0].guestCartId != '' ? this.userInputs[0].guestCartId : '';
        guestCartDetails({ guestCartId: cartId }).then(response => {
            if (this.enableLogs) console.log('guestCartDetails response', response);
            if (response) {
                this.activeCartId = response.Id;
                this.productsInCart = this.convertToInt(response.TotalProductCount);
                if (this.enableLogs) console.log('guestCartDetails productsInCart', this.productsInCart);
                if (this.productsInCart > 0) {
                    this.clearCartBtnDisabled = false;
                    this.reviewCartDisabled = false;
                    this.clearCartItems = false;
                    if (this.firstLoad == true) {
                        this.firstLoad = false;
                        this.refreshCart();
                    }
                } else {
                    this.clearCartBtnDisabled = true;
                    this.reviewCartDisabled = true;
                }
                publish(this.messageContext, MESSAGE_CHANNEL, { cartCount: this.productsInCart });
                this.isLoading = false;
                this.isLoading = false;
                this.isEmptyCart = true;
            }
        }).catch(error => {
            if (this.enableLogs) console.log('error in fetching guestCartDetails', error);
        })
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
        if (!JSON.parse(event.target.getAttribute('aria-disabled'))) {
            this.isModalOpen = true;
            setTimeout(() => {
                this.template.querySelector('.clearCartCloseBtn').focus();
            }, 100);
            this.focusCloseButton();
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
    closeModal() {
        this.isModalOpen = false;
        const button = this.template.querySelector(".clear-cart");
        if (button) {
            setTimeout(() => {
                button.focus();
            }, 100);
        }
    }
    handleCancel() {
        this.isModalOpen = false;
        const button = this.template.querySelector(".clear-cart");
        if (button) {
            setTimeout(() => {
                button.focus();
            }, 100);
        }
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
                if (this.enableLogs) console.error('lwc delete all cart items error - ', e);
            });
    }
    reviewCartHandleClick(event) {
        if (!JSON.parse(event.target.getAttribute('aria-disabled'))) {
            this.showProductSearchPage = false;
            this.reviewCartPage = true;
        }
    }
    handlehideparenttab() {
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
    paginationHelper() {
        this.currentPagetableData = [];
        this.totalPages = Math.ceil(this.totalRecords / this.pageSize);
        if (this.pageNumber <= 1) {
            this.pageNumber = 1;
        } else if (this.pageNumber >= this.totalPages) {
            this.pageNumber = this.totalPages;
        }
        for (let i = (this.pageNumber - 1) * this.pageSize; i < this.pageNumber * this.pageSize; i++) {
            if (i === this.totalRecords) {
                break;
            }
            this.currentPagetableData.push(this.records[i]);
        }
    }
handleFilter(event) {
    this.filterSearchValue = event.target.value;
    const searchTerm = event.target.value.trim();
    if (!searchTerm || (searchTerm.length < 3 && !/^\d{3,}$/.test(searchTerm))) {
        this.filterCriteria = '';
    } else {
        const searchTerms = searchTerm.split(/\s+/).filter(term => term);
        if (searchTerms.length > 1) {
            this.filterCriteria = searchTerm;
        } else if (/^\d{10,13}$/.test(searchTerm)) {
            this.filterCriteria = searchTerm;
        } else if (/^\d{1,5}$/.test(searchTerm)) {
            this.filterCriteria = searchTerm;
        } else {
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
        this.showProductTitlePage = true;
        this.showTabset = false;
        this.showResults = false;
        this.selectedProductRecord = event.detail.parentSelectedProductRecord;
        this.userInputOfMultiISBN = event.detail.userinputmulti;
    }
    handleQuantityChange(event) {
        this.totalQuantity = event.detail;
        if (this.totalQuantity > 0) {
            this.addSelectedToCartBtnDisabled = false;
        }
        else {
            this.addSelectedToCartBtnDisabled = true;
        }
        if (this.enableLogs) console.log('the total quanity is', this.totalQuantity);
    }
    handleTransformedDataLength(event) {
        this.transformedDataLength = event.detail.transformedDataLength;
        if (event.detail.totalFilteredRecords) {
            this.totalFilteredRecords = event.detail.totalFilteredRecords;
            this.totalCount = this.totalFilteredRecords;
        } else {
            this.totalCount = event.detail.totalCount;
        }
    }
    handleActive(event) {
        this.currentTab = event.target.dataset.id;
        if (this.enableLogs) console.log('this.currentTab', this.currentTab);
        this.template.querySelectorAll('.slds-tabs_default__item').forEach((ele) => {
            const link = ele.querySelector('a');
            if (ele.classList.contains('slds-is-active')) {
                ele.classList.remove('slds-is-active');
                ele.setAttribute('aria-selected', 'false');
                link.setAttribute('aria-selected', 'false');
                ele.tabindex = -1;
            }
            if (event.target.dataset.id == ele.dataset.id) {
                ele.classList.add('slds-is-active');
                ele.setAttribute('aria-selected', 'true');
                link.setAttribute('aria-selected', 'true');
                ele.tabindex = "0";
            }
        })
        this.template.querySelectorAll("[data-name=tabpanel]").forEach((ele) => {
            if (event.target.dataset.id == ele.dataset.id) {
                if (!ele.classList.contains("slds-show")) {
                    ele.classList.remove("slds-hide");
                    ele.classList.add("slds-show");
                }
            }
            else if (ele.classList.contains("slds-show")) {
                ele.classList.remove("slds-show");
                ele.classList.add("slds-hide");
            }
        })
        if (event.target.dataset.id == 'tab-default-1__item') {
            setTimeout(() => {
                this.template.querySelector('.isbnInputField').focus();
            }, 100);
        } else if (event.target.dataset.id == 'tab-default-2__item') {
            window.dispatchEvent(new CustomEvent('placeOrdermultiISBNtextAreaFocus'));
        } else if (event.target.dataset.id == 'tab-default-3__item') {
            window.dispatchEvent(new CustomEvent('placeOrdercatalogFilterFocus'));
        }
    }
 clearFilterInput(event) {
    this.filterSearchValue = '';
    this.filterCriteria = '';
}
    focusCloseButton() {
        const closeButton = this.template.querySelector('[data-id="closeButton"]');
        if (closeButton) {
            closeButton.focus();
        } else {
            if (this.enableLogs) console.error('Close button not found');
        }
    }
    focusOutClose(event) {
        var related = event.relatedTarget;
        if (related != undefined) {
            if (related.getAttribute('data-index') != 0) {
                this.template.querySelector('.cancel-modal-button').focus();
            }
        }
    }
    focusOutButton(event) {
        var related = event.relatedTarget;
        if (related != undefined) {
            if (related.getAttribute('data-index') != 0) {
                this.template.querySelector('.closebtnOnFocus').focus();
            }
        }
    }
     get shipState() {
        return this.userInputs && this.userInputs.length > 0 ? this.userInputs[0].shipState : '';
    }

    get billState() {
        return this.userInputs && this.userInputs.length > 0 ? this.userInputs[0].billState : '';
    }
   @track nationalStateFilter = true;  // Default to checked
   @track filterSearchValue = '';

handleNationalStateFilterChange(event) {
    this.nationalStateFilter = event.target.checked;
    
    // Pass the filter state to the custom table component
    const customTable = this.template.querySelector('c-scc_custom-table');
    if(customTable) {
        customTable.handleNationalStateFilter(this.nationalStateFilter);
    }
}


}