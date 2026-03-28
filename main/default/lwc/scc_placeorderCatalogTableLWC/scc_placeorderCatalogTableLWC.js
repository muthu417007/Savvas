/*******************************************************************************************************
 * @Component Name: scc_placeorderCatalogTableLWC
 * @Description: Lightning web component for displaying Catalog.
 * @Created By: CTS
 * @Created On: 17/04/2024
 * *****************************************************************************************************
 * Modification Log:
 * -----------------------------------------------------------------------------------------------------
 * Developer        Date            Description
 * -----------------------------------------------------------------------------------------------------
 */
import { LightningElement, track, api, wire } from 'lwc';
import { RefreshEvent } from 'lightning/refresh';
import { placeorderFilterData } from 'c/scc_filterResults'; // Import the filter helper function
import { CartSummaryAdapter } from "commerce/cartApi";
import { refreshCartSummary } from 'commerce/cartApi';
import productSimulation from '@salesforce/apex/ensxtx_CTRL_Cart.productSimulation'; //added by Vaibhav for pricing connector
import getUserInformation from '@salesforce/apex/scc_headerLWC_Controller.getUserInformation'; //added by Vaibhav for pricing connector
import IsEusageOnly from '@salesforce/apex/scc_confirmAddress.IsEusageOnly';
import createIntegrationLogsLWC1 from '@salesforce/apex/scc_IntegrationLogs_Helper.createIntegrationLogsLWC1';
import getEnableConsoleLogsTrue from '@salesforce/apex/scc_headerLWC_Controller.getEnableConsoleLogsTrue';
// added by sudha W-016452
import scc_inactive from "@salesforce/label/c.scc_inactive";
import scc_BothRestrictions from "@salesforce/label/c.scc_BothRestrictions";
import scc_rightRestriction from "@salesforce/label/c.scc_rightRestriction";
import scc_salesRestriction from "@salesforce/label/c.scc_salesRestriction";
import scc_hfcRestriction from "@salesforce/label/c.scc_hfcRestriction";
import scc_unavailable from "@salesforce/label/c.scc_unavailable";
export default class Scc_placeorderCatalogTableLWC extends LightningElement {
    //added by sudha W-016452
labels={
    scc_inactive,
    scc_BothRestrictions,
    scc_rightRestriction,
    scc_salesRestriction,
    scc_hfcRestriction,
    scc_unavailable
}
@track transformedChildTableData = [];
@track transformedChildTableData3 = [];
@track rawChildTableData = [];
@track productDetails;
@track IsEusage = false;
_filter = '';
@track filteredData = [];
@track totalFilteredRecords = 0;
@track orginaldata = [];
@track applyRestrictions = false;
@track billingState='';
@track shippingCountry ='';
@track billingCountry ='';
totalRecords = 0;
showLoadNextButton = false;
pageNumber = 1; //Page number 
totalPages;
displayedRecords = 0;
@api userselection;
@track userInputs = [];
@track productInfoList1;
@track accountId;
@track country;
@track salesOrg;
@track priceLoaded = false;
@track activeCartId;
@track enableLogs = false;
@api
get checkActiveId() {
return this.activeCartId;
}
set checkActiveId(value) {
    this.activeCartId = value;
}
connectedCallback() {
    getEnableConsoleLogsTrue().then(response => {
        this.enableLogs = response;
        if(this.enableLogs) console.log('getEnableConsoleLogsTrue response is',response);
    }).catch(error => {
        if(this.enableLogs) console.log('error is', error);
    });
    if(this.enableLogs) console.log('the user selected input',this.userselection);
    this.userInputs=this.userselection;
    if (this.userInputs[0].guestCartId) {
        this.activeCartId = this.userInputs[0].guestCartId;
    }
    this.getUserInfo();
}
getUserInfo() {
    if (this.userInputs[0].guestAccountId) {
        this.accountId = this.userInputs[0].guestAccountId;
        this.country = this.userInputs[0].billCountry;
        if (this.country == 'United States') {
            this.salesOrg = '0002'
        }
        if (this.country == 'Canada') {
            this.salesOrg = '0006'
        }
        this.displayFirstPage();
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
            if(this.enableLogs) console.log('error is', error);
        }).finally(() => {
            this.displayFirstPage();
        })
    }
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
@track selectedProducts = new Map();
@track totalQuantity;
@track addToCartFunction = false;
@track itemsList = [];
@track callAddItemToCart = false;
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
totalPages;
defaultSortDirection;
sortDirection;
sortedBy;
@track currentPage = 1;
@track pageSize = 15;
@track showLoadNextButton = false
calculateTotalPages() {
    if (this._filter) {
        if (this.filteredData.length <= this.pageSize) {
            this.totalPages = 1;
            this.showLoadNextButton = false;
        } else {
            this.totalRecords = this.filteredData.length;
            this.totalPages = Math.ceil(this.totalRecords / this.pageSize);
            this.showLoadNextButton = true;
        }
    } else {
        if (this.totalRecords <= this.pageSize) {
            this.totalPages = 1;
            this.showLoadNextButton = false;
        } else {
            this.totalPages = Math.ceil(this.totalRecords / this.pageSize);
            this.showLoadNextButton = true;
        }
    }
}
handleLoadNext() {
    const startIndex = this.pageSize * this.currentPage;
    const endIndex = Math.min(startIndex + this.pageSize, this.totalRecords);
    const nextRecords = this.rawChildTableData.slice(startIndex, endIndex);
    this.transformedChildTableData = [...this.transformedChildTableData, ...nextRecords];
    this.currentPage++;
    this.pageSize = this.transformedChildTableData.length;
    this.showLoadNextButton = this.currentPage < this.totalPages;
    this.updateTransformedDataLength();
    if (this.transformedChildTableData.length > 0) {
        this.getProductDetails();
    }
}
displayFirstPage() {
    if (this.rawChildTableData) {
        const endIndex = Math.min(this.pageSize, this.totalRecords);
        this.transformedChildTableData = this.rawChildTableData.slice(0, endIndex);
        this.currentPage = 1;
        this.updateTransformedDataLength();
        this.notifysearchresultsavailable();
    }
    if (this.transformedChildTableData.length > 0) {
        this.getProductDetails();
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
    this.transformedChildTableData = JSON.parse(JSON.stringify(this.transformedChildTableData));
    
    if(this.enableLogs){
        console.log('this.transformedChildTableData',this.transformedChildTableData);
    }
    
    for (let i = 0; i < this.transformedChildTableData.length; i++) {
        if (!!this.transformedChildTableData[i]) {
            if (this.transformedChildTableData[i].productDetails.Price == undefined || this.transformedChildTableData[i].productDetails.Price == 'NA') {
                if (this.transformedChildTableData[i].productId != undefined && this.transformedChildTableData[i].productId != null) {
                    this.productInfoList1.push(JSON.stringify({ prodId: this.transformedChildTableData[i].productId, quantity: 1 }));
                }
            }
        }
    }
    let pdpInputParametersMap1 = {
        'Sales:SalesOrganization': this.salesOrg,
        'Header:ShippingConditions': 'DF'
    };
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
                    if(this.enableLogs) console.log('productSimulation', data);
                    data = JSON.parse(JSON.stringify(data));
                    this.responseBody = JSON.stringify(data.TransactLogs);
                    this.conditionTypeMap = {};
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

                    this.transformedChildTableData = this.transformedChildTableData.map(product => ({
                        ...product,
                        showLockIcon: this.shouldShowLockIcon(product),
                        showLock: this.evaluateRestrictions(product),
                        isInactive: !product.productDetails.IsActive,
                        makedisable: this.shouldShowLockIcon(product) || this.evaluateRestrictions(product) || !product.productDetails.IsActive || this.evaluatehfcRestriction(product,this.conditionTypeMap[product.productId] ? this.conditionTypeMap[product.productId].conditionType:product.productDetails.ConditionType),
                        restrictionMessage:this.restrictionMessage(this.shouldShowLockIcon(product),this.evaluateRestrictions(product),product.productDetails.IsActive,this.evaluatehfcRestriction(product,this.conditionTypeMap[product.productId] ? this.conditionTypeMap[product.productId].conditionType:product.productDetails.ConditionType))              
                    }));


                    for (let i = 0; i < data.ITEMS.length; i++) {
                        for (let j = 0; j < this.transformedChildTableData.length; j++) {
                            if (!!this.transformedChildTableData[j]) {
                                if (this.transformedChildTableData[j].productId == data.ITEMS[i].ProductId) {
                                    //this.transformedChildTableData[j].productDetails.Price = data.ITEMS[i].NetItemPrice;
                                    this.transformedChildTableData[j].productDetails.Price = this.formatPrice(data.ITEMS[i].SubTotal3);
                                    this.transformedChildTableData[j].productDetails.ConditionType = this.conditionTypeMap[data.ITEMS[i].ProductId].conditionType;
                                }
                            }
                        }
                    }
                    this.priceLoaded = true;
                    for (let i = 0; i < data.ITEMS.length; i++) {
                        for (let j = (this.pageNumber - 1) * this.pageSize; j < this.pageNumber * this.pageSize; j++) {
                            if (!!this.rawChildTableData[j]) {
                                if (this.rawChildTableData[j].productId == data.ITEMS[i].ProductId) {
                                    //this.rawChildTableData[j].productDetails.Price = data.ITEMS[i].NetItemPrice;
                                    this.rawChildTableData[j].productDetails.Price = this.formatPrice(data.ITEMS[i].SubTotal3);
                                    this.rawChildTableData[j].productDetails.ConditionType = this.conditionTypeMap[data.ITEMS[i].ProductId].conditionType;
                                }
                            }
                        }
                    }
                    this.logType = 'Enosix Product Price Simulation';
                    this.requestBody = JSON.stringify(this.productInfoList1);
                    this.statusLog = 'Success';
                    this.internalStatus = '';
                    this.createLogs(this.logType, this.requestBody, this.responseBody, this.statusLog, this.internalStatus, 'scc_placeorderCatalogTable/getProductDetails/productSimulation');
                }).catch(error => {
                    if(this.enableLogs) console.log('error is', error);
                    this.logType = 'Enosix Product Price Simulation';
                    this.requestBody = JSON.stringify(this.productInfoList1);
                    this.statusLog = 'Error';
                    this.internalStatus = JSON.stringify(error);
                    this.createLogs(this.logType, this.requestBody, this.responseBody, this.statusLog, this.internalStatus, 'scc_placeorderCatalogTable/getProductDetails/productSimulation');
                });
        }
    } else {
        this.priceLoaded = true;
    }
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


shouldShowLockIcon(product) {
    if (this.userInputs[0].schoolDistrict == false) {
        this.applyRestrictions = true;
    }
    if (this.userInputs[0].oneTimeShip == true) {
        this.applyRestrictions = true;
    }
    return this.applyRestrictions && product.productDetails.SalesRestriction === '07';
}
@wire(IsEusageOnly)
EusageOnly({ error, data }) {
    if (data) {
        this.IsEusage = data;
    } else if (error) {
        if(this.enableLogs) console.log('error in IsEusageOnly ', error);
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
get transformedChildTableData2() {
    this.transformedChildTableData3 = this.transformedChildTableData;
    return this.transformedChildTableData3.slice(0, this.pageSize * this.currentPage);
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
    this.orginaldata = value;
    this.totalCount = this.rawChildTableData.length;
    this.totalRecords = this.rawChildTableData.length;
    this.pageSize = 15;
    if (this.totalRecords === 0) {
        this.transformedChildTableData = [];
    }
    this.calculateTotalPages();
}
@api
get filter() {
    return this._filter;
}
set filter(value) {
    this._filter = value;
    this.handleFilterChange();
}
onHandleSort(event) {
    this.sortedBy = event.detail.fieldName;
    this.sortDirection = event.detail.sortDirection;
    this.sortData(this.sortedBy, this.sortDirection);
}
sortData(fieldname, direction) {
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
    const row = event.detail.row;
    const action = event.detail.action.name;
    if (action === 'infoPrice') {
        LightningAlert.open({
            message: 'Title: ' + row.Title_Description + '      ' + '\nISBN: ' + row.ISBN + '\nPrice: ' + row.Price,
            label: 'View Price', 
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
handleFocus(event) {
    if (event.target.value === '0') {
        event.target.value = '';
    }
}
tableRowAction(event) {
    let fieldName = event.target.dataset.fieldName;
    let rowId = event.target.dataset.rowId;
    this.local_productQuantityData = this.transformedChildTableData;
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
        let rowIndex = this.local_productQuantityData.findIndex(element => element.productDetails.productId === rowId);
        let rowInfo = this.local_productQuantityData[rowIndex];
        rowInfo.quantity = rowValue;
        this.local_productQuantityData[rowIndex] = rowInfo;
        let currentRecordId = event.target.getAttribute('data-row-id');
        let customName = event.target.getAttribute('data-attribute-name');
        let customPrice = event.target.getAttribute('data-attribute-price');
        let conditionType = this.conditionTypeMap[currentRecordId] ? this.conditionTypeMap[currentRecordId].conditionType : 'None';
        this.addProductsToCart(currentRecordId, rowValue, customPrice, customName, conditionType);
    }
    if (fieldName == 'isbnId') {
        let rowIndex = this.local_productQuantityData.findIndex(element => element.productDetails.productId === rowId);
        let rowInfo = this.local_productQuantityData[rowIndex];
        const selectEvent = new CustomEvent('showproducttitlepage', {
            detail: {
                parentSelectedProductRecord: rowInfo.productDetails,
                displayedRecords: this.displayedRecords
            }
        });
        this.dispatchEvent(selectEvent);
    }
    this.transformedChildTableData = Object.assign([], this.local_productQuantityData);
}
addProductsToCart(currentRecordId, rowValue, customPrice, customName, conditionType) {
    customPrice = parseFloat(customPrice.replace(/,/g, ''));
    this.callAddItemToCart = false;
    if (this.selectedProducts.has(currentRecordId)) {
        let existingItem = this.selectedProducts.get(currentRecordId);
        existingItem.Quantity = rowValue;
        existingItem.PriceCondition = conditionType;
        this.selectedProducts.set(currentRecordId, existingItem);
    } else {
        this.selectedProducts.set(currentRecordId, {
            Product2Id: currentRecordId,
            Quantity: rowValue,
            SalesPrice: customPrice,
            Name: customName,
            PriceCondition: conditionType
        });
    }
    this.updateTotalquantity();
}
updateTotalquantity() {
    let sum = 0;
    this.selectedProducts.forEach((value, key) => {
        sum += parseInt(value.Quantity);
    });
    this.totalQuantity = sum;
    const quantitychangeChangeEvent = new CustomEvent('quantitychange', {
        detail: this.totalQuantity
    });
    this.dispatchEvent(quantitychangeChangeEvent);
}
handleFilterChange() {
    if (this._filter) {
        const lowerCaseFilter = this._filter.toLowerCase();
        this.filteredData = placeorderFilterData(this.rawChildTableData, lowerCaseFilter);
        this.totalFilteredRecords = this.filteredData.length; 
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
}
@api
get addSelectedToCart() {
    return this.currentSelectData;
}
set addSelectedToCart(value) {
    this.addToCartFunction = value;
    if (this.addToCartFunction == true) {
        this.itemsList = [];
        this.clearCartItems = false;
        this.selectedProducts.forEach((value, key) => {
            let conditionType = this.conditionTypeMap[key] ? this.conditionTypeMap[key].conditionType : 'None';
            this.itemsList.push({
                id: key,
                Product2Id: value.Product2Id,
                Quantity: value.Quantity,
                SalesPrice: value.SalesPrice,
                Name: value.Name,
                PriceCondition: conditionType 
            });
        });
        this.callAddItemToCart = true;
    }
}
handleReviewCartCount(event) {
    const customEvent = new CustomEvent('reveiewcartcount');
    this.dispatchEvent(customEvent);
    this.transformedChildTableData = this.transformedChildTableData.map(product => ({ ...product, quantity: 0 }));
    this.local_productQuantityData = [];
    this.selectedProducts = new Map();
    this.dispatchEvent(new RefreshEvent());
}
 handleresetaddtocart(event){
        const customEvent = new CustomEvent('resetaddtocart');
          this.dispatchEvent(customEvent);
    }
notifysearchresultsavailable() {
    const event = new CustomEvent('searchresultsavailable');
    this.dispatchEvent(event);
}
get isQuantityDisabled() {
    return !this.priceLoaded;
}
createLogs(logType, requestBody, responseBody, statusLog, internalStatus, entryPoint) {
    createIntegrationLogsLWC1({ logType: logType, requestBody: requestBody, responseBody: responseBody, status: statusLog, internalStatus: internalStatus, entryPoint: entryPoint })
        .then(result => {
            if (this.enableLogs) console.log('result is', result);
        })
        .catch(error => {
            if(this.enableLogs) console.log('error is', error);
        })
}
}