/*******************************************************************************************************
 * @Component Name: Scc_placeOrderTitlePageLWC
 * @Description: Lightning web component for displaying product details on a title page.
 * @Created By: Sanika Sol
 * @Created On: 17/04/2024
 * *****************************************************************************************************
 * Modification Log:
 * -----------------------------------------------------------------------------------------------------
 * Developer        Date            Description
 * -----------------------------------------------------------------------------------------------------
 */
import { LightningElement, api, wire, track } from 'lwc';
import getRestrictionDescription from '@salesforce/apex/scc_productTitlePage_Controller.getRestrictionDescription';
import deleteAllCartItems from '@salesforce/apex/scc_addItemsToCartController.deleteAllCartItems';
import getProductDetails from '@salesforce/apex/scc_productTitlePage_Controller.getProductDetails';
import productSimulation from '@salesforce/apex/ensxtx_CTRL_Cart.productSimulation';
import getUserInformation from '@salesforce/apex/scc_headerLWC_Controller.getUserInformation';
import { CartSummaryAdapter } from "commerce/cartApi";
import guestCartDetails from '@salesforce/apex/scc_confirmAddress.guestCartDetails';
import { updateItemInCart, deleteItemFromCart, refreshCartSummary } from 'commerce/cartApi';
import { CartItemsAdapter } from 'commerce/cartApi';
import getUserdetails from '@salesforce/apex/scc_productTitlePage_Controller.getUserdetails';
import getPricebookEntry from '@salesforce/apex/scc_productTitlePage_Controller.getPricebookEntry';
import Id from "@salesforce/user/Id";
import createIntegrationLogsLWC1 from '@salesforce/apex/scc_IntegrationLogs_Helper.createIntegrationLogsLWC1';
import imageIcons from '@salesforce/resourceUrl/scc_Images';
import scc_cart_item_img from "@salesforce/resourceUrl/scc_cart_item_img";
import scc_checkout_cart from "@salesforce/resourceUrl/scc_checkout_cart";
import scc_checkout_cart_white from "@salesforce/resourceUrl/scc_checkout_cart_white";
import getEnableConsoleLogsTrue from '@salesforce/apex/scc_headerLWC_Controller.getEnableConsoleLogsTrue';
import getUserBillingAddress from '@salesforce/apex/scc_confirmAddress.getUserBillingAddress';
import getUserShippingAddress from '@salesforce/apex/scc_confirmAddress.getUserShippingAddress';
// Added by sudha W-016452
import scc_inactive from "@salesforce/label/c.scc_inactive";
import scc_BothRestrictions from "@salesforce/label/c.scc_BothRestrictions";
import scc_rightRestriction from "@salesforce/label/c.scc_rightRestriction";
import scc_salesRestriction from "@salesforce/label/c.scc_salesRestriction";
import scc_hfcRestriction from "@salesforce/label/c.scc_hfcRestriction";
import scc_unavailable from "@salesforce/label/c.scc_unavailable";
export default class Scc_placeOrderTitlePageLWC extends LightningElement {
    @track currentSelectedProductRecord = {};
    @track restrictionValue = '';
    @track batchQuantity;
    @track gradeRange;
    @track stockAvailability;
    @track loadchild = false;
    @track quantity = 0;
    @track disableAddToCart = true;
    @track productName;
    @track callAddItemToCart = false;
    @track showProductSearchTitlePage = true;
    @track reviewCartPage = false;
    @track activeCartId;
    @track productsInCart = 0;
    @track clearCartBtnDisabled = true;
    @track reviewCartDisabled = true;
    @track reviewCartPage = false;
    @track clearCartItems = false;
    @track showAddToCartButton = true;
    @track cartIdToDelete;
    @track isTooltipVisible = false;
    @track Recordidval;
    displaypage = true;
    @track DiscountType = '';
    @track isGuest = false;
    @track accountId;
    @track country;
    @track salesOrg;
    @api userselection;
    @track userInputs = [];
    @track isProductActive = true;
    @track salesRestriction = true;
    @track rightsRestriction = true;
    @track hfcRestriction = true;
    @track hfcRestrictionCode;
    @api currentabtitle;
    userId = Id;
    priceBookEntryResult;
    netPrice;
    listPrice;
    discount;
    userIsInternational;
    @track logType = '';
    @track requestBody = '';
    @track responseBody = '';
    @track statusLog = '';
    @track internalStatus = '';
    @track productInfoList1 = [];
    @api multiinputs;
    @track enableLogs = false;
    @track billingState='';
    @track shippingCountry ='';
    @track billingCountry ='';
    labels = {
        scc_cart_item_img,
        scc_checkout_cart,
        scc_checkout_cart_white,
        // Added by sudha W-016452
         scc_inactive,
        scc_BothRestrictions,
        scc_rightRestriction,
        scc_salesRestriction,
        scc_unavailable,
        scc_hfcRestriction
    }

   
    coverImage = imageIcons + '/Images/cover.png';
    @wire(CartItemsAdapter)
    wireCartitemContext({ data, error }) {
        if (data) {
            this.cartItemList = data;
            if (this.enableLogs) console.log('the cartitemadaptor', data);
            if (this.enableLogs) console.log('cartItemList===' + JSON.stringify(this.cartItemList));
            let cartitems = this.cartItemList.cartItems;
        } else if (error) {
            if (this.enableLogs) console.log(`CartItemsAdapter::error = ${JSON.stringify(error, null, 2)}`);
        }
    }
    getUserInfo() {
    if (this.userInputs[0].guestAccountId) {
        this.accountId = this.userInputs[0].guestAccountId;
        this.country = this.userInputs[0].billCountry;
        if (this.country == 'United States') {
            this.salesOrg = '0002';
        }
        if (this.country == 'Canada') {
            this.salesOrg = '0006';
        }
        this.getPricing();
    } else {
        Promise.all([
            getUserInformation(),
            getUserBillingAddress(),
            getUserShippingAddress()
        ]).then(([userInfoResp, billingAddresses, shippingAddresses]) => {
            let parsed = JSON.parse(userInfoResp);
            let data = parsed[0];
            
            // Initialize state Set
            this.userState = new Set();

            // Add billing state
            if (data.billing_State) {
                this.userState.add(data.billing_State.toUpperCase());
            }

            // Add shipping state
            if (data.shipping_State) {
                this.userState.add(data.shipping_State.toUpperCase());
            }

            // Add states from alternate billing addresses
            billingAddresses.forEach(addr => {
                if (addr.State) {
                    this.userState.add(addr.State.toUpperCase());
                }
            });

            // Add states from alternate shipping addresses 
            shippingAddresses.forEach(addr => {
                if (addr.Province) {
                    this.userState.add(addr.Province.toUpperCase());
                }
            });

            // Set other user info
            this.accountId = data.accountId;
            this.country = data.billing_County;
            this.salesOrg = this.country === 'United States' ? '0002' : 
                           this.country === 'Canada' ? '0006' : '';
        }).catch(error => {
            if (this.enableLogs) console.error('Error fetching user information:', error);
        }).finally(() => {
            this.getPricing();
        });
    }
}
    @track isPriceLoading = true;
    getPricing() {
        this.isPriceLoading = true;
        this.productInfoList1 = [];
        if (this.enableLogs) console.log('his.parentSelectedProductRecord', this.parentSelectedProductRecord);
        this.parentSelectedProductRecord = JSON.parse(JSON.stringify(this.parentSelectedProductRecord));
        let pdpInputParametersMap1 = {
            'Sales:SalesOrganization': this.salesOrg,
            'Header:ShippingConditions': 'DF'
        }
        let sfObjectIdMap = {};
        sfObjectIdMap.Account = this.accountId;
        this.productInfoList1 = [JSON.stringify({ prodId: this.parentSelectedProductRecord.productId, quantity: 1 })];
        productSimulation({ productInfoList: this.productInfoList1, sfObjectIdMap: sfObjectIdMap, pdpAppSettingsName: 'ensxtx_SR_enosixCartPDPAppSettings', appSettingsName: 'ensxtx_SR_enosixProductB2BAppSettings', pdpInputParametersMap: pdpInputParametersMap1 })
            .then(({ data, messages }) => {
                this.isPriceLoading = false;
                this.responseBody = JSON.stringify(data.TransactLogs);
                this.conditionTypeMap = {};
                data.ITEMS.forEach(item => {
                    if (this.enableLogs) console.log('Processing item:', item);
                    this.conditionTypeMap[item.ProductId] = {
                        price: item.SubTotal3,
                        conditionType: 'None',
                        discount: 'None'
                    };
                    for (let condition of item.SBOItemConditions) {

                        
                        if (condition.ConditionType === 'ZNET') {
                            if(this.hfcRestriction){
                                this.evaluateHfcRestrictions(false);
                            }
                            this.conditionTypeMap[item.ProductId].conditionType = 'ZNET';
                            this.conditionTypeMap[item.ProductId].discount = 'Net';
                            if (this.enableLogs) console.log(`Product ${item.ProductId} has ZNET condition with value:`, condition.ConditionValue);
                            break;
                        } else if (condition.ConditionType === 'ZCON') {
                            if(this.hfcRestriction){
                                this.evaluateHfcRestrictions(true);
                            }
                            this.conditionTypeMap[item.ProductId].conditionType = 'ZCON';
                            this.conditionTypeMap[item.ProductId].discount = 'Contract';
                            if (this.enableLogs) console.log(`Product ${item.ProductId} has ZCONTRACT condition with value:`, condition.ConditionValue);
                            break;
                        }

                    }
                });
                if (data.ITEMS.length > 0) {
                    let selectedItem = data.ITEMS[0];
                    this.currentSelectedProductRecord.Price = selectedItem.SubTotal3;
                    if (this.enableLogs) console.log('firstdidplaying.....');
                    this.DiscountType = this.conditionTypeMap[selectedItem.ProductId].discount;
                    this.conditionValue = this.conditionTypeMap[selectedItem.ProductId].conditionType;
                    if (this.enableLogs) console.log('second..........');
                    if (this.enableLogs) console.log('Current Selected Product Record Price:', this.currentSelectedProductRecord.Price);
                    if (this.enableLogs) console.log('Current Selected Product Record Discount Type:', this.DiscountType);
                }
                if (this.enableLogs) console.log('Condition Type Map:', this.conditionTypeMap);
                this.conditionTypeMap = this.conditionTypeMap;
                this.logType = 'Enosix Product Price Simulation';
                this.requestBody = this.parentSelectedProductRecord.productId;
                this.statusLog = 'Success';
                this.internalStatus = '';
                this.createLogs(this.logType, this.requestBody, this.responseBody, this.statusLog, this.internalStatus, 'Scc_placeOrderTitlePageLWC/getPricing/productSimulation');
            })
            .catch(error => {
                if (this.enableLogs) console.error('Error in product simulation:', error);
                this.isPriceLoading = false;
                this.logType = 'Enosix Product Price Simulation';
                this.requestBody = this.parentSelectedProductRecord.productId;
                this.statusLog = 'Error';
                this.internalStatus = JSON.stringify(error);
                this.createLogs(this.logType, this.requestBody, this.responseBody, this.statusLog, this.internalStatus, 'Scc_placeOrderTitlePageLWC/getPricing/productSimulation');
            });
    }

    evaluateHfcRestrictions(isContractPrice){
        if(this.enableLogs){
            console.log('this.hfcRestrictionCode',this.hfcRestrictionCode);
            console.log('isContractPrice',isContractPrice);
        }
        if(this.hfcRestrictionCode =='HFC'){
            if(this.hfcRestrictionCode =='HFC' && isContractPrice){
                this.hfcRestriction = false;
            }else{
                this.hfcRestriction = true;
                this.stockAvailability = this.labels.scc_unavailable;
            }
        }else{
            this.hfcRestriction = false;
        }
    }

    get stockAvailability(){
        return this.stockAvailability;
    }
    handleMouseOver() {
        if (this.disableAddToCart) {
            this.isTooltipVisible = true;
        }
    }
    handleMouseOut() {
        this.isTooltipVisible = false;
    }
    removeTitleFoCart(event) {
        let currentRecordIdToRemove = event.target.getAttribute('data-row-id');
        let carId = event.target.getAttribute('data-attribute-cartid');
        if (this.enableLogs) console.log('the item going to be remove is', carId);
        this.cartItemRemoved(carId);
    }
    async cartItemRemoved(cartItemId) {
        try {
            const response = await deleteItemFromCart(cartItemId).then((result => {
                this.refreshSummary();
                this.showAddToCartButton = true;
                this.callAddItemToCart = false;
            }));
        } catch (error) {
            if (this.enableLogs) console.error(error);
        } finally {
        }
    }
    convertToInt(value) {
        return parseInt(value, 10);
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
            } else {
                this.clearCartBtnDisabled = true;
                this.reviewCartDisabled = true;
                this.showAddToCartButton = true;
                this.callAddItemToCart = false;
            }
            if (this.enableLogs) console.log('the current active cartid id', this.activeCartId, 'and the current data getting is', data);
            if (this.enableLogs) console.log('the active card product count is ', this.productsInCart);
        } else if (error) {
            if (this.enableLogs) console.log('CartSummaryAdapter', error);
            this.activeCartId = '';
        }
    }
    get clearCartButtonLabel() {
        return `Clear Cart (${this.productsInCart})`;
    }
    get reviewCartButtonLabel() {
        return `Review Cart (${this.productsInCart})`;
    }
    @api
    get parentSelectedProductRecord() {
        this.Recordidval = this.currentSelectedProductRecord.productId;
        this.ISBN = this.currentSelectedProductRecord.ISBN;
        this.loadchild = true;
        if (this.enableLogs) console.log('this.currentSelectedProductRecord', this.currentSelectedProductRecord);
        return this.currentSelectedProductRecord;
    }
    set parentSelectedProductRecord(value) {
        this.currentSelectedProductRecord = value;
    }
    connectedCallback() {
        if (this.enableLogs) console.log('the user selected input', this.userselection);
        this.userInputs = this.userselection;
        getEnableConsoleLogsTrue()
            .then(response => {
                this.enableLogs = response;
                if (this.enableLogs) console.log('getEnableConsoleLogsTrue response is', response);
            })
            .catch(error => {
                if (this.enableLogs) console.log('error is', error);
            });
        if (this.userInputs[0].guestCartId) {
            this.isGuest = true;
            this.activeCartId = this.userInputs[0].guestCartId;
            if (this.enableLogs) console.log('isGuest activeCartId', this.activeCartId);
            this.fetchcartDetails();
        }
        this.parentSelectedProductRecord;
        this.addEventListener('selectedproduct', this.handleSelectedProduct);
        this.getUserInfo();
        getUserdetails({ userId: this.userId })
            .then(result => {
                if (this.enableLogs) console.log('account deetails' + JSON.stringify(result));
                if (result.Type == 'International School' || result.Type == 'International Distributor') {
                    this.userIsInternational = true;
                }
                else {
                    this.userIsInternational = false;
                }
                this.account = Json.stringify(result);
                this.accountType = result.Type;
                if (this.enableLogs) console('accountType :' + this.accountType);
                if (this.enableLogs) console.log('currentSelectedProductRecord.ISBN' + currentSelectedProductRecord.ISBN)
            })
            .catch(error => {
                this.error = error;
                this.account = undefined;
            });
    }
    renderedCallback() {
        getPricebookEntry({ productId: this.currentSelectedProductRecord.productId })
            .then(result => {
                if (this.enableLogs) console.log('pricebOOkEntry :' + JSON.stringify(result));
                this.netPrice = result.UnitPrice;
                let rawListPrice = 1.333 * this.netPrice;
                rawListPrice = Number(rawListPrice.toFixed(2)); 
                this.listPrice = this.formatPrice(rawListPrice);
                let rawDiscount = ((rawListPrice - this.formattedPrice) / rawListPrice) * 100;
                this.discount = rawDiscount.toFixed(2);
            })
            .catch(error => {
                this.error = error;
                this.account = undefined;
            });
    }
    fetchcartDetails() {
        guestCartDetails({ guestCartId: this.userInputs[0].guestCartId }).then(response => {
            if (this.enableLogs) console.log('guestCartDetails response', response);
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
                    this.showAddToCartButton = true;
                    this.callAddItemToCart = false;
                }
            }
        }).catch(error => {
            if (this.enableLogs) console.log('error in fetching guestCartDetails', error);
        })
    }
    get isQuantityDisabled() {
        return !this.isProductActive || this.salesRestriction || this.rightsRestriction || this.hfcRestriction;
    }
    // Added by sudha W-016452
    get restrictionMessage() {
        if (!this.isProductActive && this.salesRestriction && this.rightsRestriction && !this.hfcRestriction) {
            return scc_BothRestrictions;
        } else if (!this.isProductActive && this.salesRestriction && !this.hfcRestriction) {
            return scc_salesRestriction;
        } else if (!this.isProductActive && this.rightsRestriction && !this.hfcRestriction) {
            return scc_rightRestriction;
        } else if (this.salesRestriction && this.rightsRestriction && !this.hfcRestriction) {
            return scc_BothRestrictions;
        } else if (!this.isProductActive && !this.hfcRestriction) {
            return scc_inactive;
        } else if (this.salesRestriction && !this.hfcRestriction) {
            return scc_salesRestriction;
        } else if (this.rightsRestriction && !this.hfcRestriction) {
            return scc_rightRestriction;
        } else if(this.hfcRestriction){
            return this.labels.scc_hfcRestriction;
        }else {
            return ""; 
        }
    }
    taskTypeHelpTextClass = 'slds-popover slds-popover_tooltip slds-nubbin_bottom-right slds-fall-into-ground slds-hide';
    togglePasswordHint() {
    let hideCss = 'slds-popover slds-popover_tooltip slds-nubbin_bottom-right slds-fall-into-ground slds-hide';
    let showCss = 'slds-popover slds-popover_tooltip slds-nubbin_bottom-right slds-rise-from-ground';
    this.taskTypeHelpTextClass = this.taskTypeHelpTextClass == hideCss ? showCss : hideCss;
    }
    shouldShowLockIcon(product) {
        if (this.userInputs[0].schoolDistrict == false) {
            this.applyRestrictions = true;
        }
        if (this.userInputs[0].oneTimeShip == true) {
            this.applyRestrictions = true;
        }
        return this.applyRestrictions && product === '07';
    }
    evaluateRestrictions(product) {
        if (this.userInputs[0].billCountry !== undefined && this.userInputs[0].billCountry !== '') {
            this.billingCountry = this.userInputs[0].billCountry.toLowerCase();
        } else {
            this.billingCountry = '';
        }
        if (this.userInputs[0].shipCountry !== undefined && this.userInputs[0].shipCountry !== '') {
            this.shippingCountry = this.userInputs[0].shipCountry.toLowerCase();
        } else {
            this.shippingCountry = '';
        }
        if (this.userInputs[0].billState !== undefined && this.userInputs[0].billState !== '') {
            this.billingState = this.userInputs[0].billState.toUpperCase();
        } else {
            this.billingState = '';
        }
        switch (product) {
            case '01':
                if (this.billingCountry !== 'canada') return true;
                break;
            case '02':
                if (this.billingCountry === 'united states') return true;
                break;
            case '03':
                if (this.billingCountry === 'canada') return true;
                break;
            case '04':
                if (this.billingCountry !== 'united states') return true;
                break;
            case '05':
                if (this.billingCountry !== 'united states') return true;
                break;
            case '06':
                if (this.billingCountry !== 'canada' && this.billingCountry !== 'united states' && !this.isUSTerritory(this.billingState)) return true;
                break;
            case '08':
                if (this.billingCountry !== 'united states' && !this.isUSTerritory(this.billingState)) return true;
                break;
            case '09':
                return !this.IsEusage;
            default:
                return false;
        }
    }
    isUSTerritory(country) {
        const usTerritories = ['AS', 'GU', 'MP', 'PR', 'VI'];
        return usTerritories.includes(country);
    }
    decrementQuantity() {
        if (this.quantity > 0) {
            this.quantity--;
            if (this.quantity <= 0) {
                this.disableAddToCart = true;
            }
        }
    }
    incrementQuantity() {
        this.quantity++;
        if (this.quantity > 0) {
            this.disableAddToCart = false;
        }
        if (this.quantity < 1) {
            this.disableAddToCart = true;
        }
    }
    changeQuantity(event) {
        if (!this.isProductActive) return;
        this.quantity = event.target.value;
        if (this.enableLogs) console.log('add title to cart quantity is', this.quantity);
        if (this.quantity === '') {
            this.quantity = 0;
        }
        else {
            this.quantity = parseInt(this.quantity, 10);
        }
        if (this.quantity > 0) {
            this.disableAddToCart = false;
        }
        if (this.quantity < 1) {
            this.disableAddToCart = true;
        }
    }
    handlekeyPress(event) {
        if (!this.isProductActive) return;
        const charCode = event.which ? event.which : event.keyCode;
        const currentValue = event.target.value;
        const newValue = currentValue + String.fromCharCode(charCode);
        if (charCode >= 48 && charCode <= 57) {
            if ((parseInt(newValue) >= 1)) {
                if (this.enableLogs) console.log('parseint true');
                return true;
            }
            event.preventDefault();
            return false;
        }
    }
    @wire(getProductDetails, { productId: '$currentSelectedProductRecord.productId' })
    wiredProductDetails({ error, data }) {
        if (data) {
            if (this.enableLogs) console.log('getProductDetails data', data);
            if (this.enableLogs)console.log('Program Series:', data.Program_Series__c);
            this.batchQuantity = data.Carton_Quantity__c || 'N/A';
            this.gradeRange = data.Grade_Range__c;
            this.stockAvailability = data.Availability__c;
            this.productName = data.Name;
            this.isProductActive = data.SAP_C__c;
            this.salesRestriction = this.shouldShowLockIcon(data.Sales_Restriction_Code__c);
            this.rightsRestriction = this.evaluateRestrictions(data.Rights_Restriction_Code__c);
            this.hfcRestrictionCode = data.Product_Status_ID__c ? data.Product_Status_ID__c:'';
            this.currentSelectedProductRecord.Program_Series__c = data.Program_Series__c;
            if(this.hfcRestrictionCode && this.hfcRestrictionCode =='HFC'){
                this.hfcRestriction = true;
            }else{
                this.hfcRestriction = false;
            }
        } else if (error) {
            if (this.enableLogs) console.error('Error fetching product details:', error);
        }
    }
    @wire(getRestrictionDescription, { productId: '$currentSelectedProductRecord.productId' })
    wiredRestriction({ error, data }) {
        if (data) {
            this.restrictionValue = data;
        } else if (error) {
            if (this.enableLogs) console.error('Error fetching restriction:', error);
        }
    }
    formatPrice(price) {
        if (typeof price === 'number') {
            let formattedPrice = price.toFixed(2);
            formattedPrice = formattedPrice.replace(/\B(?=(\d{3})+(?!\d))/g, ',');
            return formattedPrice;
        } else {
            return price;
        }
    }
    get formattedPrice() {
        return this.formatPrice(this.currentSelectedProductRecord.Price);
    }
    closePage() {
        this.displaypage = false;
    }
    handlehideparenttab() {
        this.displaypage = false;
        this.showProductSearchTitlePage = false
        this.reviewCartPage = true;
    }
    returnProductSearchOnclick() {
        if (this.enableLogs) console.log('tabID', this.currentabtitle);
        const sendCustomEventToCloseTitlePage = new CustomEvent("closetitlepage", {
            detail: {
                currentTab: this.currentabtitle,
                multiinputs: this.multiinputs
            }
        });
        this.dispatchEvent(sendCustomEventToCloseTitlePage);
    }
    handleSelectedProduct(event) {
        const selectedProductRecord = event.detail.selectedProductRecord;
        if (this.enableLogs) console.log('Selected Product Record:', selectedProductRecord);
    }
    disconnectedCallback() {
        this.removeEventListener('selectedproduct', this.handleSelectedProduct);
    }
    productSearchBtnSectionConfig = {
        addSelectedToCartBtnLabel: 'Add Selected (number) To Cart',
        addSelectedToCartBtnDisabled: true,
        clearCartBtnLabel: 'Clear Cart (number)',
        clearCartBtnDisabled: true,
        reviewCartLabel: 'Review Cart (number)',
        reviewCartDisabled: true,
        productAddedToCart: 0
    };
    get displayProductSearchBtnSectionConfig() {
        let local_ProductSearchBtnSectionConfig = { ...this.productSearchBtnSectionConfig };
        local_ProductSearchBtnSectionConfig.addSelectedToCartBtnLabel = local_ProductSearchBtnSectionConfig.addSelectedToCartBtnLabel.replace(/number/g, local_ProductSearchBtnSectionConfig.productAddedToCart);
        local_ProductSearchBtnSectionConfig.clearCartBtnLabel = local_ProductSearchBtnSectionConfig.clearCartBtnLabel.replace(/number/g, local_ProductSearchBtnSectionConfig.productAddedToCart);
        local_ProductSearchBtnSectionConfig.reviewCartLabel = local_ProductSearchBtnSectionConfig.reviewCartLabel.replace(/number/g, local_ProductSearchBtnSectionConfig.productAddedToCart);
        return local_ProductSearchBtnSectionConfig;
    }
    clearCartHandleClick() {
        if (!JSON.parse(this.template.querySelector('.clear-cart').getAttribute('aria-disabled'))) {
            if (this.isGuest) {
                this.handleClearAllItems();
            } else {
                this.clearCartItems = true;
            }
            if (this.enableLogs) console.log('the clear cart handle is called');
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
    setProductCount() {
        this.productsInCart = "0";
        this.clearCartBtnDisabled = true;
        this.reviewCartDisabled = true;
    }
    reviewCartHandleClick(event) {
        if (!JSON.parse(this.template.querySelector('.review-cart').getAttribute('aria-disabled'))) {
            this.showProductSearchTitlePage = false;
            this.reviewCartPage = true;
        }
    }
addTitleToCart(event) {
        if (!JSON.parse(this.template.querySelector('.add-title-to-cart').getAttribute('aria-disabled'))) {
            let currentRecordId = event.target.getAttribute('data-row-id');
            let price = event.target.getAttribute('data-attribute-price');
            price = parseFloat(price.replace(/,/g, ''));

        if (this.enableLogs) console.log('Current selected product:', this.currentSelectedProductRecord);
        if (this.enableLogs) console.log('Program series:', this.currentSelectedProductRecord.Program_Series__c);

            let conditionValue = this.conditionValue;
            let prodName = this.ISBN;
            let prodQuantity = this.quantity;

            const selectedProduct = {
                Product2Id: currentRecordId,
                Quantity: prodQuantity,
                SalesPrice: price,
                Name: prodName,
                PriceCondition: conditionValue,
                Program_Series__c: this.currentSelectedProductRecord.Program_Series__c 
            };

        const outOfState = this.isProductOutOfState(this.currentSelectedProductRecord);
        if (this.enableLogs) console.log('Is product out of state:', outOfState);

        if (outOfState) {
            if (this.enableLogs) console.log('Showing state warning modal');
            this.outOfStateProductToAdd = selectedProduct;
            this.showStateWarningModal = true;
        } else {
            this.itemsList = [];
            this.itemsList.push(selectedProduct);
            this.callAddItemToCart = true;
        }
    }
}
    

    handleConfirmOutOfState() {
        if (this.outOfStateProductToAdd) {
            this.itemsList = [];
            this.itemsList.push(this.outOfStateProductToAdd);
            this.callAddItemToCart = true;
        }
        this.showStateWarningModal = false;
        this.outOfStateProductToAdd = null;
    }

    handleCancelOutOfState() {
        this.showStateWarningModal = false;
        this.outOfStateProductToAdd = null;
    }

    handleReviewCartCount(event) {
        let count = event.detail.reveiewCartCount;
        this.clearCartItems = false;
        this.callAddItemToCart = false;
        this.disableAddToCart = true;
        this.quantity = 0;
        if (this.userInputs[0].guestCartId != '' && this.userInputs[0].guestCartId !== undefined) {
            this.refreshCart();
        } else {
            this.refreshSummary();
        }
        if (this.enableLogs) console.log('review cart count is', count);
    }
    handleresetaddtocart() {
        this.callAddItemToCart = false
        this.disableAddToCart = true;
        this.clearCartItems = false;
        this.dispatchEvent(new RefreshEvent());
    }
    handlerefreshevent() {
        if (this.userInputs[0].guestCartId != '' && this.userInputs[0].guestCartId !== undefined) {
            this.refreshCart();
        } else {
            this.refreshSummary();
        }
        this.clearCartItems = false;
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
            if (this.enableLogs) console.log('guestCartDetails response', response);
            if (response) {
                this.activeCartId = response.Id;
                this.productsInCart = this.convertToInt(response.TotalProductCount);
                this.isLoading = false;
                this.isEmptyCart = true;
            }
        }).catch(error => {
            if (this.enableLogs) console.log('error in fetching guestCartDetails', error);
        })
    }
    onselected(event) {
        if (this.enableLogs) console.group();
        if (this.enableLogs) console.log('check event.detail:>:>' + event.detail);
        let returnedObj = event.detail;
        if (this.enableLogs) console.log('check json>::' + JSON.stringify(event.detail));
        let obj = {
            "Copyright": returnedObj?.Copyright_Year,
            "Grade_Level": returnedObj?.Grade_Level,
            "IsActive": returnedObj?.IsActive,
            "ISBN": (returnedObj?.ISBN13) ? returnedObj?.ISBN13 : returnedObj?.ISBN10,
            "Price": returnedObj?.Net_Price,
            "productId": returnedObj?.Id,
            "showISBN13Field": (returnedObj?.ISBN13) ? true : false,
            "Status": returnedObj?.Product_Status,
            "Title_Description": returnedObj?.Description,
            "Type": returnedObj?.Product_Sub_Type
        };
        if (this.enableLogs) console.log(obj);
        this.parentSelectedProductRecord = obj;
        if (this.enableLogs) console.log('After assigning new value to the api variable', this.parentSelectedProductRecord);
        if (this.enableLogs) console.log('Checking if the currentSelectedProduct got updated', this.currentSelectedProductRecord);
        if (this.enableLogs) console.log('Checking the recordIdVal', this.Recordidval);
        this.loadchild = false;
        this.getPricing();
        setTimeout(() => {
            this.loadchild = true;
        }, 500)
    }
    createLogs(logType, requestBody, responseBody, statusLog, internalStatus, entryPoint) {
        createIntegrationLogsLWC1({ logType: logType, requestBody: requestBody, responseBody: responseBody, status: statusLog, internalStatus: internalStatus, entryPoint: entryPoint })
            .then(result => {
                if (this.enableLogs) console.log('result is', result);
            })
            .catch(error => {
                if (this.enableLogs) console.log('error is', error);
            })
    }
    @track userState = new Set();  
    @track showStateWarningModal = false; 
    @track outOfStateProductToAdd = null; 

    isProductOutOfState(productRecord) {
    if (this.enableLogs) console.log('Checking product:', productRecord);
    if (this.enableLogs) console.log('User states:', Array.from(this.userState));
    
    if (!productRecord?.Program_Series__c) {
        if (this.enableLogs) console.log('No program series - allowing');
        return false;
    }

    const programSeries = productRecord.Program_Series__c.toUpperCase();
    
    if (programSeries === 'NATL') {
        if (this.enableLogs) console.log('National product - allowing');
        return false;
    }

    const isOutOfState = !Array.from(this.userState).some(state => 
        state.toUpperCase() === programSeries
    );
    
    if (this.enableLogs) console.log('Program series:', programSeries);
    if (this.enableLogs) console.log('Is out of state:', isOutOfState);
    return isOutOfState;
}
}