/*******************************************************************************************************
 * @Component Name: Scc_placeOrderRelatedProductsLWC
 * @Description: Lightning web component for displaying related products in Place Order Tab.
 * @Created By: Sanika Sol
 * @Created On: 17/04/2024
 * *****************************************************************************************************
 * Modification Log:
 * -----------------------------------------------------------------------------------------------------
 * Developer        Date            Description
* ------------------------------------------------------------------------------------------------------
*/
import { LightningElement, track, api, wire } from 'lwc';
import getRelatedProducts from '@salesforce/apex/scc_relatedProductsLWC_Controller.getAllRelatedproducts';
import IsEusageOnly from '@salesforce/apex/scc_confirmAddress.IsEusageOnly';
import deleteAllCartItems from '@salesforce/apex/scc_addItemsToCartController.deleteAllCartItems';
import productSimulation from '@salesforce/apex/ensxtx_CTRL_Cart.productSimulation';
import getUserInformation from '@salesforce/apex/scc_headerLWC_Controller.getUserInformation';
import createIntegrationLogsLWC1 from '@salesforce/apex/scc_IntegrationLogs_Helper.createIntegrationLogsLWC1';
import { filterData } from 'c/scc_filterResults';
import { CartSummaryAdapter } from "commerce/cartApi";
import guestCartDetails from '@salesforce/apex/scc_confirmAddress.guestCartDetails';
import { updateItemInCart, deleteItemFromCart, refreshCartSummary } from 'commerce/cartApi';
import { CartItemsAdapter } from 'commerce/cartApi';
import scc_checkout_cart from "@salesforce/resourceUrl/scc_checkout_cart";
import scc_checkout_cart_white from "@salesforce/resourceUrl/scc_checkout_cart_white";
import getEnableConsoleLogsTrue from '@salesforce/apex/scc_headerLWC_Controller.getEnableConsoleLogsTrue';
//W-016452 Inactive Icon --
import scc_inactive from "@salesforce/label/c.scc_inactive";
import scc_BothRestrictions from "@salesforce/label/c.scc_BothRestrictions";
import scc_rightRestriction from "@salesforce/label/c.scc_rightRestriction";
import scc_salesRestriction from "@salesforce/label/c.scc_salesRestriction";
import scc_hfcRestriction from "@salesforce/label/c.scc_hfcRestriction";
import scc_unavailable from "@salesforce/label/c.scc_unavailable";

class ProductQuantityWrapper {
    constructor(productId, productDetails, quantity = '0', disableQuantity = false) {
        this.productId = productId;
        this.productDetails = productDetails;
        this.quantity = quantity;
    }
    getInActiveQuantityField() {
        return (this.hideCheckbox || !this.activeQuantity);
    }
}
export default class Scc_placeOrderRelatedProductsLWC extends LightningElement {

    @track productDetails;
    searchTerm = '';
    @track filteredData = [];
    @track IsEusage = false;
    @track totalFilteredRecords = 0;
    @track originalProductData = [];
    @track productData = [];
    @track productQuantityData = [];
    @track productQuantityData2 = [];
    @track rawChildTableData = [];
    @api message;
    showRelatedTitlePage = false;
    showResults = true;
    records = [];
    @track totalRecords = 0;
    @track pageSize = 15;
    @track totalPages = 0;
    @track pageNumber = 1;
    recordsToDisplay = [];
    @track totalCount = 0;
    @track isLoading = true;
    @track isGuest = false;
    showrelatedproducts = false
    displayedRecords = 0;
    filterSearchValue = '';
    @track activeCartId;
    @track selectedProducts = new Map();
    @track totalQuantity = 0;
    @track productsInCart = 0;
    @track disableAddToCart = true;
    @track disableClearCart = true;
    @track disableReviewCart = true;
    @track callAddItemToCart = false;
    @track productInfoList1;
    @track accountId;
    @track country;
    @track salesOrg;
    @track priceLoaded = false;
    @track quantity = 0;
    @api userselection = [];
    @track userInputs = [];
    @track itemsList = [];
    @track clearCartItems = false;
    @track reviewCartPage = false;
    @track applyRestrictions = false;
    @track logType = '';
    @track requestBody = '';
    @track responseBody = '';
    @track statusLog = '';
    @track internalStatus = '';
    @track enableLogs = false;
    @track billingState='';
    @track shippingCountry ='';
    @track billingCountry ='';
    user1;
    labels = {
        scc_checkout_cart,
        scc_checkout_cart_white,
        //added by sudha 
         scc_inactive,
        scc_BothRestrictions,
        scc_rightRestriction,
        scc_salesRestriction,
        scc_hfcRestriction,
        scc_unavailable
    }
    connectedCallback() {
        if (this.enableLogs) console.log('message from', this.message);
        getEnableConsoleLogsTrue().then(response => {
            this.enableLogs = response;
            if (this.enableLogs) console.log('getEnableConsoleLogsTrue response is', response);
        }).catch(error => {
            if (this.enableLogs) console.log('error is', error);
        });
        if (this.enableLogs) console.log('the user selected input', this.userselection);
        this.userInputs = this.userselection;
        if (this.userInputs[0].guestCartId) {
            this.activeCartId = this.userInputs[0].guestCartId;
            this.isGuest = true;
            if (this.enableLogs) console.log('isGuest activeCartId', this.activeCartId);
            this.fetchcartDetails();
        }
    }
    shouldShowLockIcon(product) {
        if (this.userInputs[0].schoolDistrict == false) {
            this.applyRestrictions = true;
        }
        if (this.userInputs[0].oneTimeShip == true) {
            this.applyRestrictions = true;
        }
        if (this.enableLogs) console.log('rowlock2');
        if (this.enableLogs) console.log('ISBN', product.productDetails.ISBN, 'SalesRestrictionCode', product.productDetails.SalesRestriction);
        return this.applyRestrictions && product.productDetails.SalesRestriction === '07';
    }
    @wire(IsEusageOnly)
    EusageOnly({ error, data }) {
        if (data) {
            if (this.enableLogs) console.log('data from IsEusageOnly ', data);
            this.IsEusage = data;
            if (this.enableLogs) console.log('IsEusageOnly ', this.IsEusage);
        } else if (error) {
            if (this.enableLogs) console.log('error in IsEusageOnly ', error);
            this.error = error;
        }
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
        if (this.enableLogs) console.log('ISBN', product.productDetails.ISBN13, 'RightsRestriction', product.productDetails.RightsRestriction);
        switch (product.productDetails.RightsRestriction) {
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
    get productQuantityData1() {
        this.productQuantityData2 = this.productQuantityData;
        return this.productQuantityData2;
    }

    restrictionMessage(salesRestriction,rightsRestriction,isProductActive,hfcRestriction) {
        if (!isProductActive && salesRestriction && rightsRestriction && !hfcRestriction) {
            return scc_BothRestrictions;
        } else if (!isProductActive && salesRestriction && !hfcRestriction) {
            return scc_salesRestriction;
        } else if (!isProductActive && rightsRestriction && !hfcRestriction) {
            return scc_rightRestriction;
        } else if (salesRestriction && rightsRestriction && !hfcRestriction) {
            return scc_BothRestrictions;
        } else if (!isProductActive && !hfcRestriction) {
            return scc_inactive;
        } else if (salesRestriction && !hfcRestriction) {
            return scc_salesRestriction;
        } else if (rightsRestriction && !hfcRestriction) {
            return scc_rightRestriction;
        } else if(hfcRestriction){
            return this.labels.scc_hfcRestriction;
        }else {
            return ""; 
        }
    }  
    
    evaluatehfcRestriction(product,conditionType){
        if(product.productDetails.Product_Status_ID =='HFC'){
            if(product.productDetails.Product_Status_ID =='HFC' && conditionType =='ZCON'){
                return false;
            }else{
                return true;
            }
        }else{
            return false;
        }
    }    

    getUserInfo() {
        if (this.userInputs[0].guestAccountId) {
            this.accountId = this.userInputs[0].guestAccountId;
            if (this.enableLogs) console.log('accountId in custom table', this.accountId);
            this.country = this.userInputs[0].billCountry;
            if (this.country == 'United States') {
                this.salesOrg = '0002'
            }
            if (this.country == 'Canada') {
                this.salesOrg = '0006'
            }
            this.getPricing();
        } else {
            getUserInformation().then(response => {
                let paser = JSON.parse(response);
                let data = paser[0];
                this.accountId = data.accountId;
                this.country = data.billing_County;
                if (this.country == 'United States') {
                    this.salesOrg = '0002'
                }
                if (this.country == 'Canada') {
                    this.salesOrg = '0006'
                }
            }).catch(error => {
                if (this.enableLogs) console.log('error is', error);
            }).finally(() => {
                this.paginationHelper();
            })
        }
    }
    relatedProducts;
    @wire(getRelatedProducts, { productId: '$message' })
    wiredRelatedProducts({ error, data }) {
        if (data) {
            if (this.enableLogs) console.log('wiredRelatedProducts ', data);
            this.relatedProducts = data;
            this.showrelatedproducts = true
            this.originalProductData = data;
            this.rawChildTableData = data;
            this.totalRecords = data.length;
            if (this.enableLogs) console.log('relatedProducts:', this.relatedProducts);
            this.getUserInfo();
            this.loadData();
        } else if (error) {
            if (this.enableLogs) console.error('Error fetching related products:', error);
        }
    }
    loadData() {
        setTimeout(() => {
            this.isLoading = false;
        }, 500);
    }
    closeTitlePage(event) {
        this.showRelatedTitlePage = false;
        this.showResults = true;
        const sendCustomEventToopenTitlePage = new CustomEvent("opentitlepage");
        this.dispatchEvent(sendCustomEventToopenTitlePage);
    }
    previousPage() {
        this.pageNumber = this.pageNumber - 1;
        this.paginationHelper();
    }
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
        try {
            this.productQuantityData = [];
            this.transformedChildTableData = [];
            if (this.filteredData.length > 0) {
                this.totalPages = Math.ceil(this.filteredData.length / this.pageSize);
            } else {
                this.totalPages = Math.ceil(this.totalRecords / this.pageSize);
            }
            if (this.pageNumber <= 1) {
                this.pageNumber = 1;
            } else if (this.pageNumber > this.totalPages) {
                this.pageNumber = this.totalPages;
            }
            const startIndex = (this.pageNumber - 1) * this.pageSize;
            const endIndex = Math.min(startIndex + this.pageSize, this.rawChildTableData.length);
            for (let i = startIndex; i < endIndex; i++) {
                const item = this.rawChildTableData[i];
                let oneProductQuantity = new ProductQuantityWrapper(
                    item.Id,
                    item,
                    '0'
                );
                this.productQuantityData.push(oneProductQuantity);
            }
            if (this.enableLogs) console.log('this.productQuantityData', this.productQuantityData);
            if (this.productQuantityData.length > 0) {
                this.getProductDetails();
            }
        }
        catch (err) {
            if (this.enableLogs) console.log('error is', err);
        }
    }
    formatPrice(price) {
        if (price === undefined || price === null || price === 'NA') {
            return 'NA';
        }
        
        const numPrice = typeof price === 'string' ? parseFloat(price) : price;
        
        if (isNaN(numPrice)) {
            return 'NA';
        }

        return numPrice.toLocaleString('en-US', {
            minimumFractionDigits: 2,
            maximumFractionDigits: 2
        });
    }
    getProductDetails() {
        this.priceLoaded = false;
        this.productInfoList1 = [];
        this.productQuantityData = JSON.parse(JSON.stringify(this.productQuantityData));
        for (let i = 0; i < this.productQuantityData.length; i++) {
            if (!!this.productQuantityData[i]) {
                if (this.productQuantityData[i].productDetails.Net_Price == undefined || this.productQuantityData[i].productDetails.Net_Price == 'NA') {
                    if (this.productQuantityData[i].productId != undefined && this.productQuantityData[i].productId != null) {
                        this.productInfoList1.push(JSON.stringify({ prodId: this.productQuantityData[i].productId, quantity: 1 }));
                    }
                }
            }
        }
        let pdpInputParametersMap1 = {
            'Sales:SalesOrganization': this.salesOrg,
            'Header:ShippingConditions': 'DF'
        }
        let sfObjectIdMap = {};
        sfObjectIdMap.Account = this.accountId;
        if (this.productInfoList1.length > 0) {
            if (this.accountId != undefined) {
                productSimulation({
                    productInfoList: this.productInfoList1,
                    sfObjectIdMap: sfObjectIdMap,
                    pdpAppSettingsName: 'ensxtx_SR_enosixCartPDPAppSettings',
                    appSettingsName: 'ensxtx_SR_enosixProductB2BAppSettings',
                    pdpInputParametersMap: pdpInputParametersMap1
                })
                    .then(({ data, messages }) => {
                        if (this.enableLogs) console.log('productSimulation', data);
                        this.conditionTypeMap = {};
                        this.responseBody = JSON.stringify(data.TransactLogs);
                        data.ITEMS.forEach(item => {
                            this.conditionTypeMap[item.ProductId] = {
                                price: this.formatPrice(item.SubTotal3),
                                conditionType: 'None',
                                discount: 'None'
                            };
                            for (let condition of item.SBOItemConditions) {
                                if (condition.ConditionType === 'ZNET') {
                                    this.conditionTypeMap[item.ProductId].conditionType = 'ZNET';
                                    this.conditionTypeMap[item.ProductId].discount = 'Net';
                                    break;
                                } else if (condition.ConditionType === 'ZCON') {
                                    this.conditionTypeMap[item.ProductId].conditionType = 'ZCON';
                                    this.conditionTypeMap[item.ProductId].discount = 'Contract';
                                    break;
                                }
                            }
                        });
                        data = JSON.parse(JSON.stringify(data));
                        this.productQuantityData = JSON.parse(JSON.stringify(this.productQuantityData));

                        this.productQuantityData = this.productQuantityData.map(product => ({
                            ...product,
                            showLockIcon: this.shouldShowLockIcon(product),
                            showLock: this.evaluateRestrictions(product),
                            isInactive: !product.productDetails.IsActive ,//W-016452 Inactive Icon
                            makedisable: this.shouldShowLockIcon(product) || this.evaluateRestrictions(product) || !product.productDetails.IsActive || this.evaluatehfcRestriction(product,this.conditionTypeMap[product.productId].conditionType),
                            restrictionMessage:this.restrictionMessage(this.shouldShowLockIcon(product),this.evaluateRestrictions(product),product.productDetails.IsActive,this.evaluatehfcRestriction(product,this.conditionTypeMap[product.productId].conditionType))              
                        }));

                        for (let i = 0; i < data.ITEMS.length; i++) {
                            for (let j = 0; j < this.productQuantityData.length; j++) {
                                if (!!this.productQuantityData[j]) {
                                    if (this.productQuantityData[j].productId == data.ITEMS[i].ProductId) {
                                        this.productQuantityData[j].productDetails.Net_Price = this.formatPrice(data.ITEMS[i].SubTotal3);
                                        this.productQuantityData[j].productDetails.ConditionType = this.conditionTypeMap[data.ITEMS[i].ProductId].conditionType;
                                    }
                                }
                            }
                        }
                        this.priceLoaded = true;
                        this.rawChildTableData = JSON.parse(JSON.stringify(this.rawChildTableData));
                        for (let i = 0; i < data.ITEMS.length; i++) {
                            for (let j = (this.pageNumber - 1) * this.pageSize; j < this.pageNumber * this.pageSize; j++) {
                                if (!!this.rawChildTableData[j]) {
                                    if (this.rawChildTableData[j].Id == data.ITEMS[i].ProductId) {
                                        this.rawChildTableData[j].Net_Price =this.formatPrice(data.ITEMS[i].SubTotal3);
                                        this.rawChildTableData[j].ConditionType = this.conditionTypeMap[data.ITEMS[i].ProductId].conditionType;
                                    }
                                }
                            }
                        }
                        this.records = this.rawChildTableData;
                        this.logType = 'Enosix Product Price Simulation';
                        this.requestBody = JSON.stringify(this.productInfoList1);
                        this.statusLog = 'Success';
                        this.internalStatus = '';
                        this.createLogs(this.logType, this.requestBody, this.responseBody, this.statusLog, this.internalStatus, 'Scc_placeOrderRelatedProductsLWC/getProductDetails/productSimulation');
                    }).catch(error => {
                        if (this.enableLogs) console.log('error is', error);
                        this.logType = 'Enosix Product Price Simulation';
                        this.requestBody = JSON.stringify(this.productInfoList1);
                        this.statusLog = 'Error';
                        this.internalStatus = JSON.stringify(error);
                        this.createLogs(this.logType, this.requestBody, this.responseBody, this.statusLog, this.internalStatus, 'Scc_placeOrderRelatedProductsLWC/getProductDetails/productSimulation');
                    });
            }
        } else {
            this.productQuantityData = this.productQuantityData.map(product => ({
                ...product,
                showLockIcon: this.shouldShowLockIcon(product),
                showLock: this.evaluateRestrictions(product),
                isInactive: !product.productDetails.IsActive ,//W-016452 Inactive Icon
                makedisable: this.shouldShowLockIcon(product) || this.evaluateRestrictions(product) || !product.productDetails.IsActive || this.evaluatehfcRestriction(product,product.productDetails.conditionType),
                restrictionMessage:this.restrictionMessage(this.shouldShowLockIcon(product),this.evaluateRestrictions(product),product.productDetails.IsActive,this.evaluatehfcRestriction(product,product.productDetails.conditionType))              
            }));
            this.priceLoaded = true;
        }
    }
    tableRowAction(event) {
        let fieldName = event.target.dataset.fieldName;
        let rowId = event.target.dataset.rowId;
        let local_productQuantityData = this.productQuantityData;
        if (fieldName == 'isbnId') {
            window.scrollTo({
                top: 0,
                behavior: 'smooth'
            });
            let rowIndex = local_productQuantityData.findIndex(element => element.productDetails.Id === rowId);
            let rowInfo = local_productQuantityData[rowIndex];
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
    handleRowAction(event) {
        const action = event.detail.action;
        const row = event.detail.row;
        this.selectedProductRecord = row.Id;
        this.selectedISBN = row.ISBN13__c;
        this.showRelatedTitlePage = true;
        const selectedEvent = new CustomEvent("selectedproduct", { detail: row });
        this.dispatchEvent(selectedEvent);
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
    get pageRecordCount() {
        return (this.productQuantityData != undefined) ? this.productQuantityData.length : 0;
    }
    @track filterCriteria = '';
    clearFilterInput(event) {
        if (this.filterSearchValue == '' || this.filterSearchValue == null) {
            this.filterSearchValue = '';
            this.filter = '';
        }
        else {
            this.filterSearchValue = '';
            this.filter = '';
            this.filteredData = [];
            this.totalRecords = this.originalProductData.length
            this.rawChildTableData = this.originalProductData;
            this.pageSize = 15
            this.pageNumber = 1;
            this.totalPages = Math.ceil(this.totalRecords / this.pageSize);
            this.paginationHelper();
        }
    }
    handleFilter(event) {
        const searchTerm = event.target.value.trim();
        this.filterSearchValue = event.target.value;
        this.filterCriteria = searchTerm;
        if (!searchTerm || (searchTerm.length < 3 && !/^\d{3,}$/.test(searchTerm))) {
            this.filterCriteria = '';
            this.handleFilterChange();
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
            this.handleFilterChange();
        }
    }
    handleFilterChange() {
        if (this.filterCriteria) {
            const lowerCaseFilter = this.filterCriteria.toLowerCase();
            this.filteredData = filterData(this.originalProductData, lowerCaseFilter);
            this.totalFilteredRecords = this.filteredData.length;
            this.totalRecords = this.filteredData.length;
            this.rawChildTableData = this.filteredData;
            this.pageNumber = 1;
            this.totalPages = Math.ceil(this.totalFilteredRecords / this.pageSize);
            this.paginationHelper();
        } else {
            this.filteredData = [];
            this.totalFilteredRecords = 0;
            this.rawChildTableData = this.originalProductData;
            this.totalRecords = this.originalProductData.length;
            this.pageNumber = 1;
            this.totalPages = Math.ceil(this.totalRecords / this.pageSize);
            this.paginationHelper();
        }
    }
    get isQuantityDisabled() {
        return !this.priceLoaded;
    }
    handleFocus(event) {
        if (event.target.value === '0') {
            event.target.value = '';
        }
    }
    QuantityChange(event) {
        let fieldName = event.target.dataset.fieldName;
        let rowId = event.target.dataset.rowId;
        this.local_productQuantityData = this.productQuantityData;
        if (fieldName === 'quantityCount') {
            let rowValue = event.target.value;
            if (isNaN(rowValue) || rowValue === '') {
                rowValue = '0';
                event.target.value = rowValue;
            }
            if (/^0+$/.test(rowValue)) {
                rowValue = '0';
                event.target.value = rowValue;
            }
            let rowIndex = this.local_productQuantityData.findIndex(element => element.productDetails.Id === rowId);
            let rowInfo = this.local_productQuantityData[rowIndex];
            rowInfo.quantity = rowValue;
            this.local_productQuantityData[rowIndex] = rowInfo;
            let customName = event.target.getAttribute('data-attribute-name');
            let customPrice = event.target.getAttribute('data-attribute-price');
            let conditionType = this.conditionTypeMap[rowId] ? this.conditionTypeMap[rowId].conditionType : 'None';
            this.addProductsToCart(rowId, rowValue, customPrice, customName, conditionType);
            if (this.enableLogs) console.log('Added product to cart with rowValue:', rowValue, 'rowIndex:', rowIndex, 'rowInfo:', rowInfo);
        }
    }
    addProductsToCart(rowId, rowValue, customPrice, customName, conditionType) {
        customPrice = parseFloat(customPrice.replace(/,/g, ''));
        if (this.selectedProducts.has(rowId)) {
            let existingItem = this.selectedProducts.get(rowId);
            existingItem.Quantity = rowValue;
            existingItem.ConditionType = conditionType;
            this.selectedProducts.set(rowId, existingItem);
        } else {
            this.selectedProducts.set(rowId, {
                Product2Id: rowId,
                Quantity: rowValue,
                SalesPrice: customPrice,
                Name: customName,
                PriceCondition: conditionType
            });
        }
        this.updateTotalQuantity();
    }
    updateTotalQuantity() {
        let sum = 0;
        this.selectedProducts.forEach((value) => {
            sum += parseInt(value.Quantity);
        });
        this.totalQuantity = sum;
        this.disableAddToCart = this.totalQuantity === 0;
    }
    get addToCartButtonLabel() {
        if (this.totalQuantity > 0) {
            this.disableAddToCart = false;
        } else {
            this.disableAddToCart = true;
        }
        return `Add to Cart (${this.totalQuantity})`;
    }
    get clearCartButtonLabel() {
        return `Clear Cart (${this.productsInCart})`;
    }
    get reviewCartButtonLabel() {
        return `Review Cart (${this.productsInCart})`;
    }
    addToSelectedToCartHandleClick(event) {
        if (!JSON.parse(this.template.querySelector('.add-title-to-cart').getAttribute('aria-disabled'))) {
            this.itemsList = [];
            this.selectedProducts.forEach((value, key) => {
                this.itemsList.push(value);
            });
            this.callAddItemToCart = true;
            if (this.enableLogs) console.log('items in the selectedProduct is', this.itemsList);
        }
    }
    resetQuantities() {
        this.productQuantityData = this.productQuantityData.map(product => {
            return { ...product, quantity: '0' };
        });
    }
    clearCartHandleClick() {
        if (!JSON.parse(this.template.querySelector('.clear-cart').getAttribute('aria-disabled'))) {
            if (this.isGuest) {
                this.handleClearAllItems();
            } else {
                this.clearCartItems = true;
            }
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
    reviewCartHandleClick() {
        if (!JSON.parse(this.template.querySelector('.review-cart').getAttribute('aria-disabled'))) {
            this.showrelatedproducts = false;
            const customEvent = new CustomEvent('hideparenttab');
            this.dispatchEvent(customEvent);
            this.reviewCartPage = true;
        }
    }
    handleReviewCartCount(event) {
        let count = event.detail.reveiewCartCount;
        this.clearCartItems = false;
        this.callAddItemToCart = false;
        this.disableAddToCart = true;
        this.totalQuantity = 0;
        this.selectedProducts = new Map();
        this.resetQuantities();
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
    convertToInt(value) {
        return parseInt(value, 10);
    }
    @wire(CartSummaryAdapter)
    setCartSummary({ data, error }) {
        if (data) {
            this.activeCartId = data.cartId;
            if (this.enableLogs) console.log('review activeCartId', this.activeCartId);
            this.productsInCart = this.convertToInt(data.totalProductCount);
            if (this.enableLogs) console.log('review this.productsInCart', this.productsInCart);
            if (this.productsInCart > 0) {
                this.disableClearCart = false;
                this.disableReviewCart = false;
                this.clearCartItems = false;
            } else {
                this.disableClearCart = true;
                this.disableReviewCart = true;
                this.callAddItemToCart = false;
            }
            if (this.enableLogs) console.log('the current active cartid id', this.activeCartId, 'and the current data getting is', data);
            if (this.enableLogs) console.log('the active card product count is ', this.productsInCart);
        } else if (error) {
            if (this.enableLogs) console.error(error);
            this.activeCartId = '';
        }
    }
    fetchcartDetails() {
        guestCartDetails({ guestCartId: this.userInputs[0].guestCartId }).then(response => {
            if (this.enableLogs) console.log('guestCartDetails response', response);
            if (response) {
                this.activeCartId = response.Id;
                this.productsInCart = this.convertToInt(response.TotalProductCount);
                if (this.productsInCart > 0) {
                    this.disableClearCart = false;
                    this.disableReviewCart = false;
                    this.clearCartItems = false;
                } else {
                    this.disableClearCart = true;
                    this.disableReviewCart = true;
                    this.callAddItemToCart = false;
                }
                if (this.enableLogs) console.log('the current active cartid id', this.activeCartId, 'and the current data getting is', response);
                if (this.enableLogs) console.log('the active card product count is ', this.productsInCart);
            }
        }).catch(error => {
            if (this.enableLogs) console.log('error in fetching guestCartDetails', error);
        })
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
}