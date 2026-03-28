/*
Lightning Web component: Scc_productTitlePage
Author: CTS (Sanika Sol)
Created Date: 03/04/2024
Reason: Backend logic for Scc_productTitlePage
Modified Date: 15/04/2024
*/
import { LightningElement, api, wire, track } from 'lwc';
import getRestrictionDescription from '@salesforce/apex/scc_productTitlePage_Controller.getRestrictionDescription';
import getUserdetails from '@salesforce/apex/scc_productTitlePage_Controller.getUserdetails';
import getPricebookEntry from '@salesforce/apex/scc_productTitlePage_Controller.getPricebookEntry';
import getProductDetails from '@salesforce/apex/scc_productTitlePage_Controller.getProductDetails';
import productSimulation from '@salesforce/apex/ensxtx_CTRL_Cart.productSimulation';
import Id from "@salesforce/user/Id";
import getUserInformation from '@salesforce/apex/scc_headerLWC_Controller.getUserInformation';
import imageIcons from '@salesforce/resourceUrl/scc_Images';
import getRelatedproductsDetail from '@salesforce/apex/scc_relatedProductsLWC_Controller.getRelatedproductsDetail';
import createIntegrationLogsLWC1 from '@salesforce/apex/scc_IntegrationLogs_Helper.createIntegrationLogsLWC1';
import getEnableConsoleLogsTrue from '@salesforce/apex/scc_headerLWC_Controller.getEnableConsoleLogsTrue';
import scc_unavailable from "@salesforce/label/c.scc_unavailable";

export default class Scc_productTitlePage extends LightningElement {
    @track currentSelectedProductRecord = {};
    @track restrictionValue = '';
    @track batchQuantity;
    @track gradeRange;
    @track stockAvailability;
    @track accountId;
    @track country;
    @track salesOrg;
    @track userIsInternal
    @track InternationalDivision = false
    userId = Id;
    accountType;
    account = [];
    priceBookEntryResult;
    netPrice;
    listPrice;
    discount;
    userIsInternational;
    @track UserStatus
    @api tabValue;
    @track DiscountType = '';
    internalUserDivision = false;
    USDivision = false;
    @track conditionTypeMap = {}
    Recordidval;
    displaypage = true;
    @track loadchild = false;
    @track logType = '';
    @track requestBody = '';
    @track responseBody = '';
    @track statusLog = '';
    @track internalStatus = '';
    @track productInfoList1 = [];
    @track enableLogs = false;
    @api activeTab;
    @api currentabtitle;
    @track hfcRestriction = false;
    @track hfcRestrictionCode = '';
    coverImage = imageIcons + '/Images/cover.png';
    get constructedUrl() {
        const baseUrl = 'https://opsweb1.lsk12.com/dev/titlefinder/_vISBN_info.cfm';
        const isbn = this.currentSelectedProductRecord?.ISBN;
        if (!isbn) {
            return '#';
        }
        return `${baseUrl}?isbn=${isbn}`;
    }
    @api
    get parentSelectedProductRecord() {
        this.Recordidval = this.currentSelectedProductRecord.productId;
        this.userIsInternal = this.currentSelectedProductRecord.isInternalUser;
        this.UserStatus = this.currentSelectedProductRecord.UserStatus;
        this.loadchild = true;
        return this.currentSelectedProductRecord;
    }
    set parentSelectedProductRecord(value) {
        this.currentSelectedProductRecord = value;
        this.userIsInternal = value.isInternalUser;
        this.UserStatus = value.UserStatus;
        if (this.UserStatus == 'International') {
            this.InternationalDivision = true;
        }
        else {
            this.USDivision = true;
        }
    }
    connectedCallback() {
        getEnableConsoleLogsTrue().then(response => {
            this.enableLogs = response;
            if (this.enableLogs) console.log('getEnableConsoleLogsTrue response is', response);
        }).catch(error => {
            if (this.enableLogs) console.log('error is', error);
        });
        this.parentSelectedProductRecord;
        this.showTabsets = this.parentSelectedProductRecord.showTabset;
        this.getUserInfo();
        getUserdetails({ userId: this.userId })
            .then(result => {
                if (result.Type == 'International School' || result.Type == 'International Distributor') {
                    this.userIsInternational = true;
                    this.externalUser = true;
                }
                else {
                    this.userIsInternational = false;
                    this.externalUser = true;
                }
                this.account = Json.stringify(result);
                this.accountType = result.Type;
            })
            .catch(error => {
                this.error = error;
                this.account = undefined;
            });
    }
    renderedCallback() {
        getPricebookEntry({ productId: this.currentSelectedProductRecord.productId })
            .then(result => {
                this.netPrice = result.UnitPrice;
                let rawListPrice = 1.333 * this.netPrice;
                rawListPrice = Number(rawListPrice.toFixed(2)); // First fix to 2 decimal places
                this.listPrice = this.formatPrice(rawListPrice); // Then apply formatting
                let rawDiscount = ((rawListPrice - this.formattedPrice) / rawListPrice) * 100;
                this.discount = rawDiscount.toFixed(2);
            })
            .catch(error => {
                this.error = error;
                this.account = undefined;
            });
    }
    @track isPriceLoading = true;
    getPricing() {
        this.isPriceLoading = true;
        this.productInfoList1 = [];
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
                    this.conditionTypeMap[item.ProductId] = {
                        price: item.SubTotal3,
                        conditionType: 'None',
                        discount: 'None'
                    };
                    for (let condition of item.SBOItemConditions) {
                        if (condition.ConditionType === 'ZNET') {
                            this.conditionTypeMap[item.ProductId].conditionType = 'ZNET';
                            this.conditionTypeMap[item.ProductId].discount = 'Net';
                            if(this.hfcRestriction){
                                this.evaluateHfcRestrictions(false);
                            }
                            break;
                        } else if (condition.ConditionType === 'ZCON') {
                            this.conditionTypeMap[item.ProductId].conditionType = 'ZCON';
                            this.conditionTypeMap[item.ProductId].discount = 'Contract';
                            if(this.hfcRestriction){
                                this.evaluateHfcRestrictions(true);
                            }                            
                            break;
                        }
                    }
                });
                if (data.ITEMS.length > 0) {
                    let selectedItem = data.ITEMS[0];
                    this.currentSelectedProductRecord.Price = selectedItem.SubTotal3;
                    this.DiscountType = this.conditionTypeMap[selectedItem.ProductId].discount;
                }
                this.conditionTypeMap = this.conditionTypeMap;
                this.logType = 'Enosix Product Price Simulation';
                this.requestBody = JSON.stringify(this.productInfoList1);
                this.statusLog = 'Success';
                this.internalStatus = '';
                this.createLogs(this.logType, this.requestBody, this.responseBody, this.statusLog, this.internalStatus, 'Scc_productTitlePage/getPricing/productSimulation');
            })
            .catch(error => {
                if (this.enableLogs) console.error('Error in product simulation:', error);
                this.isPriceLoading = false;
                this.logType = 'Enosix Product Price Simulation';
                this.requestBody = JSON.stringify(this.productInfoList1);
                this.statusLog = 'Error';
                this.internalStatus = JSON.stringify(error);
                this.createLogs(this.logType, this.requestBody, this.responseBody, this.statusLog, this.internalStatus, 'Scc_productTitlePage/getPricing/productSimulation');
            });
    }

    evaluateHfcRestrictions(isContractPrice){
        if(this.enableLogs){
            console.log('this.hfcRestrictionCode',this.hfcRestrictionCode);
            console.log('isContractPrice',isContractPrice);
        }
        if(this.hfcRestrictionCode =='HFC'){
            if(!(this.hfcRestrictionCode =='HFC' && isContractPrice)){
                 this.stockAvailability = scc_unavailable;
            }
        }
    }

    get stockAvailability(){
        return this.stockAvailability;
    }

    getUserInfo() {
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
            if (this.accountId) {
                this.getPricing();
            } else {
                this.loadChild = true;
            }
        })
    }
    @wire(getProductDetails, { productId: '$currentSelectedProductRecord.productId' })
    wiredProductDetails({ error, data }) {
        if (data) {
            this.batchQuantity = data.Carton_Quantity__c || 'N/A';
            this.gradeRange = data.Grade_Range__c;
            this.stockAvailability = data.Availability__c;
            this.hfcRestrictionCode = data.Product_Status_ID__c;
            if(this.hfcRestrictionCode == 'HFC'){
                this.hfcRestriction = true;
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
        return (this.formatPrice(this.currentSelectedProductRecord.Price));
    }
    closePage(event) {
        this.displaypage = false;
    }
    openpage(event) {
        this.displaypage = true;
    }
    returnProductSearchOnclick() {
        const sendCustomEventToCloseTitlePage = new CustomEvent("closetitlepage", {
            detail: {
                currentTab: this.currentabtitle,
                tabValue: this.tabValue
            }
        });
        this.dispatchEvent(sendCustomEventToCloseTitlePage);
    }
    onselected(event) {
        if (this.enableLogs) console.group();
        let returnedObj = event.detail;
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
        this.parentSelectedProductRecord = obj;
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
}