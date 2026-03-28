/*
Lightning Web component: Scc_productTitlePage
Author: CTS (Sanika Sol)
Created Date: 03/04/2024
Reason: Backend logic for Scc_productTitlePage
Modified Date: 15/04/2024
*/


import { LightningElement, api, wire, track } from 'lwc';
import getRestrictionDescription from '@salesforce/apex/scc_productTitlePage_Controller.getRestrictionDescription';
//import getUserdetails from '@salesforce/apex/scc_productTitlePage_Controller.getUserdetails';
//import getPricebookEntry from '@salesforce/apex/scc_productTitlePage_Controller.getPricebookEntry';
import getProductDetails from '@salesforce/apex/scc_productTitlePage_Controller.getProductDetails';
import productSimulation from '@salesforce/apex/ensxtx_CTRL_Cart.productSimulation'; //added by Vaibhav for pricing connector
import Id from "@salesforce/user/Id";
import getUserInformation from '@salesforce/apex/scc_headerLWC_Controller.getUserInformation'; //added by Vaibhav for pricing connector
//import getRelatedproductsDetail from '@salesforce/apex/scc_relatedProductsLWC_Controller.getRelatedproductsDetail';


export default class Scc_productTitlePage extends LightningElement {
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
    @track DiscountType='';
    // internal user - sprint7 backup ticket 
    internalUserDivision = false;// added by sudha
    USDivision = false;//added bys sudha 
    @track conditionTypeMap={}
    // Variables
    Recordidval; // Record Id value
    displaypage = true; // Flag to display the page
    @track loadchild = false; // Flag to load child component



    // Getter to construct the URL dynamically
    get constructedUrl() {
        const baseUrl = 'https://opsweb1.lsk12.com/dev/titlefinder/_vISBN_info.cfm';
        //const isbn = this.currentSelectedProductRecord?.ISBN;
          const isbn ='9780132154116';
        
        // Ensure ISBN is valid
        if (!isbn) {
            return '#';
        }

        return `${baseUrl}?isbn=${isbn}`;
    }
    // Getter and Setter for parentSelectedProductRecord
    @api
    get parentSelectedProductRecord() {
        console.log('current record is', this.currentSelectedProductRecord.productId);
        this.Recordidval = this.currentSelectedProductRecord.productId;
        this.userIsInternal = this.currentSelectedProductRecord.isInternalUser// added by sudha sprint7 backup ticket 
        this.UserStatus = this.currentSelectedProductRecord.UserStatus// added by sudha  sprint7 backup ticket 
        console.log('recordid is', this.Recordidval);
        this.loadchild = true;
        return this.currentSelectedProductRecord;
    }
    set parentSelectedProductRecord(value) {
        console.log('value for the api variable', value);
        this.currentSelectedProductRecord = value;
        this.userIsInternal = value.isInternalUser;// added by sudha sprint7 backup ticket 
        console.log('value for the api variable', this.userIsInternal);
        this.UserStatus = value.UserStatus;// added by sudha sprint7 backup ticket 
        console.log('value for the api variable', this.UserStatus);
        if (this.UserStatus == 'International') {
            this.InternationalDivision = true;// internaltional// added bys sudha sprint7 backup ticket 
        }
        else {
            this.USDivision = true// US added by sudha 
        }

    }


    // Lifecycle Hook: Connected Callback
    connectedCallback() {
        this.parentSelectedProductRecord;

        this.showTabsets = this.parentSelectedProductRecord.showTabset; // Added by sudha
        this.getUserInfo()//added by Vaibhav for pricing connector
        // console.log('contact id: ' + this.userId);
        // getUserdetails({ userId: this.userId })
        //     .then(result => {
        //         console.log('account deetails' + JSON.stringify(result));
        //         if (result.Type == 'International School') {
        //             this.userIsInternational = true;
        //             this.externalUser = true;
        //         }
        //         else {
        //             this.userIsInternational = false;
        //             this.externalUser = true;
        //         }
        //         this.account = Json.stringify(result);
        //         //  this.error = undefined;
        //         this.accountType = result.Type;
        //         console('accountType :' + this.accountType);
        //         console.log('currentSelectedProductRecord.ISBN' + currentSelectedProductRecord.ISBN)
        //     })
        //     .catch(error => {
        //         this.error = error;
        //         this.account = undefined;
         //   });


    }
    // this for  related products 
    renderedCallback() {
        // getPricebookEntry({ productId: this.currentSelectedProductRecord.productId })
        //     .then(result => {
        //         console.log('pricebOOkEntry :' + JSON.stringify(result));
        //         this.netPrice = result.UnitPrice;
        //         let rawListPrice = 1.33 * this.netPrice;
        //         this.listPrice = rawListPrice.toFixed(2); // Ensure two decimal places 
        //         // Calculate and format discount 
        //         let rawDiscount = ((rawListPrice - this.formattedPrice) / rawListPrice) * 100;
        //         this.discount = rawDiscount.toFixed(2); // Ensure two decimal places
        //     })
        //     .catch(error => {
        //         this.error = error;
        //         this.account = undefined;
        //     });
    }


    //added by Vaibhav for pricing connector starts


    getPricing() {
        // // // console.log('his.parentSelectedProductRecord', this.parentSelectedProductRecord);
        this.parentSelectedProductRecord = JSON.parse(JSON.stringify(this.parentSelectedProductRecord));
        let pdpInputParametersMap1 = {
            'Sales:SalesOrganization': this.salesOrg,
            'Header:ShippingConditions': 'DF'
        }
        let sfObjectIdMap = {};
        sfObjectIdMap.Account = this.accountId;
        let productInfoList1 = [JSON.stringify({ prodId: this.parentSelectedProductRecord.productId, quantity: 1 })];
        productSimulation({ productInfoList: productInfoList1, sfObjectIdMap: sfObjectIdMap, pdpAppSettingsName: 'ensxtx_SR_enosixCartPDPAppSettings', appSettingsName: 'ensxtx_SR_enosixProductB2BAppSettings', pdpInputParametersMap: pdpInputParametersMap1 })
            .then(({ data, messages }) => {
                /* data = JSON.parse(JSON.stringify(data));
                  console.log('data.data.ITEMS[0].NetItemPrice', data);
                 // // // console.log('data.data.ITEMS[0].NetItemPrice', data.ITEMS[0].NetItemPrice);
                 this.currentSelectedProductRecord.Price = data.ITEMS[0].NetItemPrice;
 
             }).catch(error => {
                 // // // console.log('error is', error);
             })*/                      
       // Initialize condition type map
        this.conditionTypeMap = {};

        // Iterate through ITEMS
        data.ITEMS.forEach(item => {
            console.log('Processing item:', item);

            // Initialize product data in the map
            this.conditionTypeMap[item.ProductId] = {
                price: item.NetItemPrice,
                conditionType: 'None',
                discount: 'None'
            };

            
            for (let condition of item.SBOItemConditions) {
                if (condition.ConditionType === 'ZNET') {
                    this.conditionTypeMap[item.ProductId].conditionType = 'ZNET';
                    this.conditionTypeMap[item.ProductId].discount = 'Net';
                    console.log(`Product ${item.ProductId} has ZNET condition with value:`, condition.ConditionValue);
                    break; 
                } else if (condition.ConditionType === 'ZCON') {
                    this.conditionTypeMap[item.ProductId].conditionType = 'ZCON';
                    this.conditionTypeMap[item.ProductId].discount = 'Contract';
                    console.log(`Product ${item.ProductId} has ZCONTRACT condition with value:`, condition.ConditionValue);
                    break; 
                }
            }
        });

        // Set the price and discount type for the current selected product record for UI //
        if (data.ITEMS.length > 0) {
            let selectedItem = data.ITEMS[0];
            this.currentSelectedProductRecord.Price = selectedItem.NetItemPrice;
            console.log('firstdidplaying.....');
            this.DiscountType = this.conditionTypeMap[selectedItem.ProductId].discount;
            console.log('second..........');
            console.log('Current Selected Product Record Price:', this.currentSelectedProductRecord.Price);
            console.log('Current Selected Product Record Discount Type:', this.DiscountType);
        }
// need for back strore //
        console.log('Condition Type Map:', this.conditionTypeMap);        
        this.conditionTypeMap = this.conditionTypeMap;
        })
        .catch(error => {
            console.error('Error in product simulation:', error);
        });
    }
            


    getUserInfo() {
        getUserInformation().then(response => {
            // // // console.log('response is', response);
            let paser = JSON.parse(response);
            let data = paser[0];
            // // // console.log('account data', data);
            this.accountId = data.accountId;
            // // // console.log('this.accountId user info', this.accountId);
            this.country = data.billing_County;
            if (this.country == 'United States') {
                this.salesOrg = '0002'
            }
            if (this.country == 'Canada') {
                this.salesOrg = '0006'
            }
        }).catch(error => {
            // // // console.log('error is', error);


        }).finally(() => {
            // this.getPricing();//added by Vaibhav for pricing connector
            if (this.accountId) {
            this.getPricing(); //added by Vaibhav for pricing connector
        } else {
            console.warn('Account ID is missing, skipping pricing fetch');
            this.loadChild=true;
        }
        })
    }
    //added by Vaibhav for pricing connector ends


    // Wire method to fetch product details
    @wire(getProductDetails, { productId: '$currentSelectedProductRecord.productId' })
    wiredProductDetails({ error, data }) {
        if (data) {
            this.batchQuantity = data.SBQQ__BatchQuantity__c || 'N/A';
            this.gradeRange = data.Grade_Range__c;
            this.stockAvailability = data.Availability__c; // Stock availability
        } else if (error) {
            // // // console.error('Error fetching product details:', error);
        }
    }


    // Wire method to fetch restriction description
    @wire(getRestrictionDescription, { productId: '$currentSelectedProductRecord.productId' })
    wiredRestriction({ error, data }) {
        if (data) {
            this.restrictionValue = data;
        } else if (error) {
            // // // console.error('Error fetching restriction:', error);
        }
    }
    // Method to format the price
    formatPrice(price) {
        // Check if the price is a number
        if (typeof price === 'number') {
            // Convert the price to a string with two decimal places
            let formattedPrice = price.toFixed(2);
            // Add commas for thousands
            formattedPrice = formattedPrice.replace(/\B(?=(\d{3})+(?!\d))/g, ',');
            // Return the formatted price
            return formattedPrice;
        } else {
            // If the price is not a number, return it as is
            return price;
        }
    }


    // Computed property to get the formatted price
    get formattedPrice() {
        return (this.formatPrice(this.currentSelectedProductRecord.Price));
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


    onselected(event) {
        console.group();
        console.log('check event.detail:>:>' + event.detail);
        // this.currentSelectedProductRecord = event.detail;
        // //Object.assign(this.currentSelectedProductRecord, event.detail);
        // //this.currentSelectedProductRecord = { ...event.detail };
        // // // // console.log('json value received>:>>' + this.currentSelectedProductRecord);
        // // // // console.log('json message:>:>' + JSON.stringify(this.currentSelectedProductRecord));
        let returnedObj = event.detail;

        console.log('check json>::' + JSON.stringify(event.detail));
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
           "isInternalUser": returnedObj.isInternalUser,
            "UserStatus": returnedObj.UserStatus,
            "ListPriceFormatted": returnedObj.ListPriceFormatted,
            "NetPriceFormatted": returnedObj.NetPriceFormatted,
            "DiscountFormatted": returnedObj.DiscountFormatted,
            "ListPrice": returnedObj.ListPrice,
            "NetPrice":returnedObj.NetPrice,
            "Discount":returnedObj.Discount
        };

        console.log(obj);

        // this.currentSelectedProductRecord = obj;
        this.parentSelectedProductRecord = obj;
        console.log('After assigning new value to the api variable', JSON.stringify(this.parentSelectedProductRecord));
        console.log('Checking if the currentSelectedProduct got updated', this.currentSelectedProductRecord);
        console.log('Checking the recordIdVal', this.Recordidval);
        // // // console.groupEnd();
        this.loadchild = false;
        this.getPricing();//added by Vaibhav for pricing connector
        setTimeout(() => {
            this.loadchild = true;
        }, 500)
        // debugger;
        // getRelatedproductsDetail({
        //     proddetailid: this.currentSelectedProductRecord.Id,
        //     ISBN: this.currentSelectedProductRecord.ISBN13
        // })
        //     .then((result) => {
        //         // // // console.log('check result value::>' + JSON.stringify(result));
        //         //this.currentSelectedProductRecord =  result[0];
        //         for(var i =0; i<=result.length; i++){
        //             // // // console.log('for loop::>');
        //             this.currentSelectedProductRecord.Title_Description = result.Description;
        //             this.currentSelectedProductRecord.ISBN = result.ISBN13__c;
        //             this.currentSelectedProductRecord.Type = result.Product_Sub_Type__c;
        //             this.currentSelectedProductRecord.Status = result.Product_Status__c;
        //             this.currentSelectedProductRecord.Copyright = result.Copyright_Year__c;
        //             this.currentSelectedProductRecord.Grade_Level = result.Grade_Level__c;
        //             break;
        //         }
        //         //this.currentSelectedProductRecord = result[0];
        //         //this.dispatchEvent(new CustomEvent('change'));
        //         // // // console.log('success:>:');
        //         // // // console.log('this current ::>:>'+JSON.stringify(this.currentSelectedProductRecord));
        //     }).catch((err) => {
        //         // // // console.log('error value:>:' + err);
        //         // // // console.log('check apex error:>:>' + JSON.stringify(err));
        //     });
    }
}