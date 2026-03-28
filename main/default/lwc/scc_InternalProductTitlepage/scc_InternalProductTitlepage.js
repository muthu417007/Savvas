/*
Lightning Web component: Scc_InternalProductTitlePage
Author: CTS (Sudha)
Created Date: 03/04/2024
Reason: 
Modified Date: 15/04/2024
*/


import { LightningElement, api, wire, track } from 'lwc';
import getRestrictionDescription from '@salesforce/apex/scc_productTitlePage_Controller.getRestrictionDescription';
import getUserdetails from '@salesforce/apex/scc_productTitlePage_Controller.getUserdetails';
import getPricebookEntry from '@salesforce/apex/scc_productTitlePage_Controller.getPricebookEntry';
import getProductDetails from '@salesforce/apex/scc_productTitlePage_Controller.getProductDetails';
import productSimulation from '@salesforce/apex/ensxtx_CTRL_Cart.productSimulation'; //added by Vaibhav for pricing connector
import Id from "@salesforce/user/Id";
import { RefreshEvent } from 'lightning/refresh';
import imageIcons from '@salesforce/resourceUrl/scc_Images';
import createIntegrationLogsLWC1 from '@salesforce/apex/scc_IntegrationLogs_Helper.createIntegrationLogsLWC1';
import getEnableConsoleLogsTrue from '@salesforce/apex/scc_headerLWC_Controller.getEnableConsoleLogsTrue' ;
import scc_orderDetail_title_Finder_URL from "@salesforce/label/c.scc_orderDetail_title_Finder_URL";

export default class Scc_InternalProductTitlePage extends LightningElement {
    // Properties
    @track currentSelectedProductRecord = {}; // Currently selected product record
    @track restrictionValue = ''; // Restriction value for the product
    @track batchQuantity; // Batch quantity for the product
    @track gradeRange; // Grade range for the product
    @track stockAvailability; // Stock Availability
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
    @track hasAccountid = false
    // internal user - sprint7 backup ticket 
    internalUserDivision = false;// added by sudha
    USDivision = false;//added bys sudha 
    @track conditionTypeMap = {}
    // Variables
    Recordidval; // Record Id value
    displaypage = true; // Flag to display the page
    @track loadchild = true; // Flag to load child component    
    @track logType = '';
    @track requestBody = '';
    @track responseBody = '';
    @track statusLog = '';
    @track internalStatus = '';
    @track productInfoList1 = [];
    @track enableLogs = false;
labels = {
    scc_orderDetail_title_Finder_URL
}
    coverImage = imageIcons + '/Images/cover.png';

    get constructedUrl() {
       const url1 = this.labels.scc_orderDetail_title_Finder_URL;
        const baseUrl = `${url1}`;
        const isbn = this.currentSelectedProductRecord?.ISBN;        

        // Ensure ISBN is valid
        if (!isbn) {
            return '#';
        }

        return `${baseUrl}?isbn=${isbn}`;
    }

    // Getter and Setter for parentSelectedProductRecord
    @api
    get parentSelectedProductRecord() {
        // Assigning values from the current selected product record
        this.Recordidval = this.currentSelectedProductRecord.productId;
        this.accountId = this.currentSelectedProductRecord.accountId;
        this.countryCodeISO = this.currentSelectedProductRecord.countryCodeISO;

        // Setting hasAccountid based on whether accountId is present
        this.hasAccountid = !!this.accountId;

        // Determining salesOrg based on countryCodeISO
        if (this.countryCodeISO === 'USD' || this.countryCodeISO === '0002' || this.countryCodeISO === 'Only US Sales Org' || this.countryCodeISO === undefined || this.countryCodeISO === '') {
            this.salesOrg = '0002';
        } else {
            this.salesOrg = '0006';
        }

        // Updating userIsInternal and UserStatus based on the current selected product record
        this.userIsInternal = this.currentSelectedProductRecord.isInternalUser;
        this.UserStatus = this.currentSelectedProductRecord.UserStatus;
        // Triggering loadchild to true
        this.loadchild = true;

        // Returning the current selected product record
        return this.currentSelectedProductRecord;
    }

    set parentSelectedProductRecord(value) {
        this.currentSelectedProductRecord = value;
        this.userIsInternal = value.isInternalUser; // added by sudha sprint7 backup ticket 
        this.UserStatus = value.UserStatus; // added by sudha sprint7 backup ticket 
        this.accountId = value.accountId
        if (this.UserStatus === 'International' && !this.accountId) {
            this.InternationalDivision = true;
        } else if (this.UserStatus === 'Internal US User' && !this.accountId) {
            this.USDivision = true;
        } else if (this.accountId) {
            this.hasAccountid = true;
            this.isPriceLoading = true;
        }
    }

    // Lifecycle Hook: Connected Callback
    connectedCallback() {
        this.parentSelectedProductRecord;

        if (this.accountId) {
            this.getPricing();
        }

        getUserdetails({ userId: this.userId })
            .then(result => {

                if (result.Type == 'International School') {
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
    }

    renderedCallback() {
        
        getPricebookEntry({ productId: this.currentSelectedProductRecord.productId })
            .then(result => {

                this.netPrice = result.UnitPrice;
                let rawListPrice = 1.333 * this.netPrice;
                this.listPrice = rawListPrice.toFixed(2); // Ensure two decimal places 
                // Calculate and format discount 
                let rawDiscount = ((rawListPrice - this.formattedPrice) / rawListPrice) * 100;
                this.discount = rawDiscount.toFixed(2); // Ensure two decimal places
            })
            .catch(error => {
                this.error = error;
                this.account = undefined;
            });
        // }
    }


    //added by Vaibhav for pricing connector starts
    @track isPriceLoading = false;
    @track enosixPrice = '';
    getPricing() {
        this.productInfoList1 = [];
        this.parentSelectedProductRecord = JSON.parse(JSON.stringify(this.parentSelectedProductRecord));
        let pdpInputParametersMap1 = {
            'Sales:SalesOrganization': this.salesOrg,
            'Header:ShippingConditions': 'DF'
        }
        let sfObjectIdMap = {};
        if (this.accountId && !this.setaccountId) {
            sfObjectIdMap.Account = this.accountId;
            this.hasAccountid = true;
        }
        else if (this.setaccountId && !this.accountId) {
            sfObjectIdMap.Account = this.setaccountId;
            this.hasAccountid = true;
        }
        else {
            sfObjectIdMap.Account = this.accountId;
        }
        this.isPriceLoading = true;

        sfObjectIdMap.Account = this.accountId

        this.productInfoList1 = [JSON.stringify({ prodId: this.parentSelectedProductRecord.productId, quantity: 1 })];
        productSimulation({ productInfoList: this.productInfoList1, sfObjectIdMap: sfObjectIdMap, pdpAppSettingsName: 'ensxtx_SR_enosixCartPDPAppSettings', appSettingsName: 'ensxtx_SR_enosixProductB2BAppSettings', pdpInputParametersMap: pdpInputParametersMap1 })
            .then(({ data, messages }) => {
                this.responseBody = JSON.stringify(data.TransactLogs);

                // Initialize condition type map
                this.conditionTypeMap = {};

                // Iterate through ITEMS
                data.ITEMS.forEach(item => {

                    // Initialize product data in the map
                    this.conditionTypeMap[item.ProductId] = {                        
                        price: item.SubTotal3,
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

                // Set the price and discount type for the current selected product record for UI //
                if (data.ITEMS.length > 0) {
                    this.selectedItem = data.ITEMS[0];                    
                    this.currentSelectedProductRecord.Price = this.selectedItem.SubTotal3;
                    this.DiscountType = this.conditionTypeMap[this.selectedItem.ProductId].discount;
                    this.enosixPrice = this.selectedItem.SubTotal3;
                    ;
                }
                // need for back strore //

                this.conditionTypeMap = this.conditionTypeMap;                
                this.isPriceLoading = false;
                this.logType = 'Enosix Product Price Simulation';
                this.requestBody = JSON.stringify(this.productInfoList1);
                this.statusLog = 'Success';
                this.internalStatus = '';
                this.createLogs(this.logType, this.requestBody, this.responseBody, this.statusLog, this.internalStatus, 'scc_IntenalProductTitlepage/getPricing/productSimulation');
            })
            .catch(error => {

                this.isPriceLoading = false;
                this.logType = 'Enosix Product Price Simulation';
                this.requestBody = JSON.stringify(this.productInfoList1);
                this.statusLog = 'Error';
                this.internalStatus = JSON.stringify(error);
                this.createLogs(this.logType, this.requestBody, this.responseBody, this.statusLog, this.internalStatus, 'scc_IntenalProductTitlepage/getPricing/productSimulation');
            });
    }

    // Wire method to fetch product details
    @wire(getProductDetails, { productId: '$currentSelectedProductRecord.productId' })
    wiredProductDetails({ error, data }) {
        if (data) {
            this.batchQuantity = data.Carton_Quantity__c || 'N/A';
            this.gradeRange = data.Grade_Range__c;
            this.stockAvailability = data.Availability__c; // Stock availability
        } else if (error) {

        }
    }

    // Wire method to fetch restriction description
    @wire(getRestrictionDescription, { productId: '$currentSelectedProductRecord.productId' })
    wiredRestriction({ error, data }) {
        if (data) {
            this.restrictionValue = data;
        } else if (error) {

        }
    }
    // Method to format the price
   formatPrice(price) {
    if(this.enableLogs){
        console.log('Price input:', price, 'Type:', typeof price);
    }
    if (price === null || price === undefined || price === '') {
        return 'N/A';
    }

    try {
        // Convert string to number if it's a string
        let numericPrice = typeof price === 'string' ? 
            parseFloat(price.replace(/[^0-9.-]+/g, '')) : // Remove any non-numeric characters except decimal point
            price;

        if (isNaN(numericPrice)) {
            return 'N/A';
        }

        // Format to 2 decimal places and add commas
        let formattedPrice = numericPrice.toFixed(2);
        return formattedPrice.replace(/\B(?=(\d{3})+(?!\d))/g, ',');
    } catch (error) {
        console.error('Error formatting price:', error, 'Price value:', price);
        return 'N/A';
    }
}

    // Computed property to get the formatted price
    get formattedPrice() {
        return (this.formatPrice(this.currentSelectedProductRecord.Price));
    }

    get formattedEnosixPrice() {
    return this.formatPrice(this.enosixPrice);  
    }

    // Update the getters to use this improved formatPrice method
    get formattedListPrice() {
    return this.formatPrice(this.currentSelectedProductRecord.ListPrice);
    }

    get formattedNetPrice() {
    return this.formatPrice(this.currentSelectedProductRecord.NetPrice);
    }

    // Method to close the page
    closePage(event) {
        this.displaypage = false;
    }


    // Method to open the page
    openpage(event) {
        this.displaypage = true;
    }


    // Method to handle return to product search button click
    returnProductSearchOnclick(event) {
        const sendCustomEventToCloseTitlePage = new CustomEvent("closetitlepage", {
            detail: { tabClose: this.tabValue }
        });
        this.dispatchEvent(sendCustomEventToCloseTitlePage);
    }


    // For Reloading Title detail and Related Products starts here
    onselected(event) {     
        console.group();              
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
            "Type": returnedObj?.Product_Sub_Type,
            "accountId":returnedObj?.accountId,
            "countryCodeISO":returnedObj?.country,
            "ListPrice":returnedObj?.ListPrice,
            "NetPrice":returnedObj?.NetPrice
        };                              
        this.accountId=returnedObj.accountId              
           if (returnedObj.country == 'USD' || returnedObj.country =='0002'||returnedObj.country == 'Only US Sales Org') {
                this.salesOrg = '0002'
            }
            else {
                this.salesOrg = '0006'
            }    
     this.parentSelectedProductRecord = obj;      
      if(this.accountId){
   this.getPricing();
      }
      this.refreshChildComponent(); 
    }

   refreshChildComponent() {
    this.loadchild = false; 
    setTimeout(() => {
        this.loadchild = true;         
    }, 100);
    }
    refreshChildComponent() {
        this.loadchild = false;
        setTimeout(() => {
            this.loadchild = true;

        }, 100);
    }

    createLogs(logType, requestBody, responseBody, statusLog, internalStatus, entryPoint) {
        createIntegrationLogsLWC1({ logType: logType, requestBody: requestBody, responseBody: responseBody, status: statusLog, internalStatus: internalStatus, entryPoint: entryPoint })
            .then(result => {

            })
            .catch(error => {
                if(this.enableLogs){
                    console.log('error is', error);
                }
            })
    }

}