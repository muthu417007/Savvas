/*
Lightning Web component:scc_internalRelatedProducts
Author: CTS (Sudha)
Created Date: 03/04/2024
Reason: Backend logic scc_internalRelatedProducts.
Modified Date: 15/04/2024
*/
import { LightningElement, track, api, wire } from 'lwc';
import getRelatedProducts from '@salesforce/apex/scc_internalUser_Realtedproducts.getRelatedProducts';
import productSimulation from '@salesforce/apex/ensxtx_CTRL_Cart.productSimulation'; //added by Vaibhav for pricing connector
import getUserInformation from '@salesforce/apex/scc_headerLWC_Controller.getUserInformation'; //added by Vaibhav for pricing connector
import createIntegrationLogsLWC1 from '@salesforce/apex/scc_IntegrationLogs_Helper.createIntegrationLogsLWC1';
import getEnableConsoleLogsTrue from '@salesforce/apex/scc_headerLWC_Controller.getEnableConsoleLogsTrue' ;
import { filterData } from 'c/scc_filterResults';// filter 
export default class scc_internalRelatedProducts extends LightningElement {
    @track relatedproductinp;
    @track showRelatedTitlePage = false;
    @track showResults = true;
    @track productInfoList1;//added by vaibhav for pricing connetcor 
    @track accountId;//added by vaibhav for pricing connetcor 
    @track country;//added by vaibhav for pricing connetcor 
    @track salesOrg;//added by vaibhav for pricing connetcor 
    @track priceLoaded = false;//added by vaibhav for pricing connetcor 
    @track relatedProducts = [];
    @track UserStatus = '';
    @track getMsg = '';
    @track productId;
    //added by vaibhav for pricing connetcor ends
    @track relatedProducts;
    pageSizeOptions = [15, 25, 50, 75, 100]; //Page size options
    @track records = []; //All records available in the data table
    columns = []; //columns information available in the data table
    totalRecords = 0; //Total no.of records
    pageSize; //No.of records to be displayed per page
    totalPages; //Total no.of pages
    pageNumber = 1; //Page number    
    @track recordsToDisplay = []; //Records to be displayed on the page
    @track logType = '';
    @track requestBody = '';
    @track responseBody = '';
    @track statusLog = '';
    @track internalStatus = '';
    @track filterCriteria = '';
    filterSearchValue = '';
    filter = '';
    @track totalCount = 0;
    @track orginaldata = [];
    @track originalProductData = [];
    @track countryCodeISO = '';
    @track enableLogs = false;

    @api
    get message() {
        return this.getMsg;
    }

    set message(value) {
        this.productId = value;
    }
    
    @api
    get countrycodeiso() {
        return this.getsales;
    }

    set countrycodeiso(value) {
        this.countryCodeISO = value;

        if (this.countryCodeISO == 'USD' || this.countryCodeISO == '0002' || this.countryCodeISO === 'Only US Sales Org' || this.countryCodeISO == '' || this.countryCodeISO == 'undefined') {
            this.salesOrg = '0002'
        }
        else {
            this.salesOrg = '0006'
        }

    }

    @api
    get sapaccountid() {
        return this.getaccount;
    }

    set sapaccountid(value) {
        this.accountId = value;
    }

    connectedCallback() {
        this.handleFetchRelatedProducts();

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
            this.records = this.originalProductData;

            this.pageNumber = 1; // Reset page number to 1 after removing filter
            this.totalPages = Math.ceil(this.totalRecords / this.pageSize);            
            this.paginationHelper();

        }
    }
    //filter  sprint 4 Workitem 
    handleFilter(event) {
        //const searchTerm = event.target.value.trim();
        const searchTerm = event.target.value.trim();
        this.filterSearchValue = event.target.value;
        this.filterCriteria = searchTerm;

        if (!searchTerm || (searchTerm.length < 3 && !/^\d{3,}$/.test(searchTerm))) {

            this.filterCriteria = '';
            this.handleFilterChange();
            // No need to send search term to B component, so no action needed here
        } else {
            // Split the search term by spaces to handle multiple terms
            const searchTerms = searchTerm.split(/\s+/).filter(term => term);


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
            this.handleFilterChange();
        }
    }

    handleFilterChange() {

        if (this.filterCriteria) {
            const lowerCaseFilter = this.filterCriteria.toLowerCase();

            this.filteredData = filterData(this.originalProductData, lowerCaseFilter);
            // Apply the filter logic to originalData to get filteredData

            this.totalFilteredRecords = this.filteredData.length;
            this.totalRecords = this.filteredData.length; // Update totalFilteredRecords property


            this.records = this.filteredData;

            this.pageNumber = 1;
            this.totalPages = Math.ceil(this.totalFilteredRecords / this.pageSize);


            this.paginationHelper();
        } else {

            this.filteredData = [];
            this.totalFilteredRecords = 0;
            this.records = this.originalProductData;

            this.totalRecords = this.originalProductData.length;
            this.pageSize = this.pageSizeOptions[0]
            this.pageNumber = 1; // Reset page number to 1 after removing filter
            this.totalPages = Math.ceil(this.totalRecords / this.pageSize);


            this.paginationHelper();
        }
    }

    get DisableFirst() {
        return this.pageNumber == 1;
    }


    get DisableLast() {
        return this.pageNumber == this.totalPages;
    }

    handleFetchRelatedProducts() {
    getRelatedProducts({ productId: this.productId, sapAccountid: this.accountId, country: this.countryCodeISO })
        .then(data => {
            this.showResults = false;
            this.relatedProducts = [];
            
            // Format the prices for each product before assigning
            const formattedData = data.map(product => ({
                ...product,
                ListPriceFormatted: this.formatPrice(product.ListPrice),
                NetPriceFormatted: this.formatPrice(product.NetPrice)
            }));

            this.relatedProducts = [...formattedData];
            this.records = this.relatedProducts;
            this.orginaldata = [...formattedData];
            this.originalProductData = [...formattedData];

            if (this.relatedProducts.length > 0) {
                this.isInternalUser = this.relatedProducts[0].isInternalUser;
                this.UserStatus = this.relatedProducts[0].UserStatus;

                if (this.relatedProducts[0].accountId) {
                    this.hasaccountId = true;
                } else {
                    this.hasaccountId = false;
                }

                if (this.isInternalUser) {
                    if (this.UserStatus === 'International' && !this.relatedProducts[0].accountId) {
                        this.IsinternalInternationalStatus = true;
                    } else if (this.UserStatus === 'Internal US User' && !this.relatedProducts[0].accountId) {
                        this.InternalUSUser = true;
                    } else if (this.relatedProducts[0].accountId) {
                        this.AccountNumberprovied = true;
                        this.isPriceLoading = true;
                    }
                }

                this.totalRecords = this.relatedProducts.length; // update total records count                 
                this.pageSize = this.pageSizeOptions[0]; // set pageSize with default value as first option
                this.paginationHelper(); // call helper method to update pagination logic 
                
                setTimeout(() => {
                    this.showResults = true;
                }, 100);
            }
        })
        .catch(error => {
            console.error('Error fetching related products: ', error);
            this.error = error;            
        });
}

    tableRowAction(event) {
        event.preventDefault();
        let rowId = event.target.dataset.rowId;
        this.local_productQuantityData = [...this.recordsToDisplay]
        let rowIndex = this.local_productQuantityData.findIndex(element => element.Id === rowId);
        let rowInfo = { ...this.local_productQuantityData[rowIndex] };
        this.selectedProductRecord = rowId;
        this.selectedISBN = rowInfo.ISBN13__c;
        this.showRelatedTitlePage = true;
        const selectedEvent = new CustomEvent("selectedproduct", { detail: rowInfo });
        window.scrollTo({
            top: 0,
            behavior: 'smooth'
        });

        this.dispatchEvent(selectedEvent);
    
    }

    closeTitlePage(event) {
        this.showRelatedTitlePage = false;
        this.showResults = true;
        const sendCustomEventToopenTitlePage = new CustomEvent("opentitlepage");
        this.dispatchEvent(sendCustomEventToopenTitlePage);
    }
    handleRecordsPerPage(event) {
        this.pageSize = event.target.value;
        this.paginationHelper();
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

    // JS function to handel pagination logic 
    paginationHelper() {
        this.recordsToDisplay = [];
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
            this.recordsToDisplay.push(this.records[i]);
        }

        this.totaldisRecords = this.recordsToDisplay.length;

        //added by vaibhav for pricing connetcor starts
        if (this.recordsToDisplay.length > 0) {
         
            this.getProductDetails();
        }
        //added by vaibhav for pricing connetcor ends
    }
    @track hasaccountId = false;

    //added by vaibhav for pricing connetcor starts
    getProductDetails() {

        this.priceLoaded = true;
        this.hasaccountId = true;
        this.productInfoList1 = [];

        this.recordsToDisplay = JSON.parse(JSON.stringify(this.recordsToDisplay));
       
        for (let i = 0; i < this.recordsToDisplay.length; i++) {
            if (!!this.recordsToDisplay[i]) {                
             
                if (this.recordsToDisplay[i].Net_Price == undefined || this.recordsToDisplay[i].Net_Price == 'NA') {
                    if (this.recordsToDisplay[i].Id != undefined && this.recordsToDisplay[i].Id != null) {
                        this.productInfoList1.push(JSON.stringify({ prodId: this.recordsToDisplay[i].Id, quantity: 1 }));                        
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
                productSimulation({ productInfoList: this.productInfoList1, sfObjectIdMap: sfObjectIdMap, pdpAppSettingsName: 'ensxtx_SR_enosixCartPDPAppSettings', appSettingsName: 'ensxtx_SR_enosixProductB2BAppSettings', pdpInputParametersMap: pdpInputParametersMap1 })
        .then(({ data, messages }) => {
            this.responseBody = JSON.stringify(data.TransactLogs);
            data = JSON.parse(JSON.stringify(data));
            this.recordsToDisplay = JSON.parse(JSON.stringify(this.recordsToDisplay));
            
            for (let i = 0; i < data.ITEMS.length; i++) {
                for (let j = 0; j < this.recordsToDisplay.length; j++) {
                    if (!!this.recordsToDisplay[j]) {
                        if (this.recordsToDisplay[j].Id == data.ITEMS[i].ProductId) {
                            let rawPrice = data.ITEMS[i].SubTotal3;
                            this.recordsToDisplay[j].Net_Price = this.formatPrice(rawPrice);
                        }
                    }
                }
            }

            this.relatedProducts = JSON.parse(JSON.stringify(this.relatedProducts));
            for (let i = 0; i < data.ITEMS.length; i++) {
                for (let j = (this.pageNumber - 1) * this.pageSize; j < this.pageNumber * this.pageSize; j++) {
                    if (!!this.relatedProducts[j]) {
                        if (this.relatedProducts[j].Id == data.ITEMS[i].ProductId) {
                            let rawPrice = data.ITEMS[i].SubTotal3;
                            this.relatedProducts[j].Net_Price = this.formatPrice(rawPrice);
                            this.enosixPrice = this.formatPrice(rawPrice);
                            this.isPriceLoading = false;
                        }
                    }
                }
            }
                        this.records = this.relatedProducts;

                        this.logType = 'Enosix Product Price Simulation';
                        this.requestBody = JSON.stringify(this.productInfoList1);
                        this.statusLog = 'Success';
                        this.internalStatus = '';
                        this.createLogs(this.logType, this.requestBody, this.responseBody, this.statusLog, this.internalStatus, 'scc_internalRelatedProducts/getProductDetails/productSimulation');

                    }).catch(error => {

                        this.logType = 'Enosix Product Price Simulation';
                        this.requestBody = JSON.stringify(this.productInfoList1);
                        this.statusLog = 'Error';
                        this.internalStatus = JSON.stringify(error);
                        this.createLogs(this.logType, this.requestBody, this.responseBody, this.statusLog, this.internalStatus, 'scc_internalRelatedProducts/getProductDetails/productSimulation');
                    })
            }
        } else {
            this.priceLoaded = true;
        }
    }

    formatPrice(price) {
    if (typeof price === 'number' || typeof price === 'string') {
        // Convert to number if it's a string
        let numPrice = typeof price === 'string' ? parseFloat(price) : price;
        
        // Check if it's a valid number
        if (!isNaN(numPrice)) {
            // Fix to 2 decimal places and add thousand separators
            let formattedPrice = numPrice.toFixed(2);
            formattedPrice = formattedPrice.replace(/\B(?=(\d{3})+(?!\d))/g, ',');
            return formattedPrice;
        }
    }
    return price;
}
    //added by vaibhav for pricing connetcor ends

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