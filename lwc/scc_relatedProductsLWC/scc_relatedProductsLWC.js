/*
Lightning Web component:Scc_relatedProductsLWC
Author: CTS (MuthuKumar)
Created Date: 03/04/2024
Reason: Backend logic Scc_relatedProductsLWC.
Modified Date: 15/04/2024
*/
import { LightningElement, track, api, wire } from 'lwc';
import getRelatedProducts from '@salesforce/apex/scc_relatedProductsLWC_Controller.getAllRelatedproducts';
import productSimulation from '@salesforce/apex/ensxtx_CTRL_Cart.productSimulation';
import getUserInformation from '@salesforce/apex/scc_headerLWC_Controller.getUserInformation';
import createIntegrationLogsLWC1 from '@salesforce/apex/scc_IntegrationLogs_Helper.createIntegrationLogsLWC1';
import { filterData } from 'c/scc_filterResults';
import getEnableConsoleLogsTrue from '@salesforce/apex/scc_headerLWC_Controller.getEnableConsoleLogsTrue';
import scc_noResults from "@salesforce/resourceUrl/scc_noResults";
export default class Scc_relatedProductsLWC extends LightningElement {
    @track relatedproductinp;
    @api message;
    @track showRelatedTitlePage = false;
    @track showResults = true;
    @track productInfoList1;
    @track accountId;
    @track country;
    @track salesOrg;
    @track priceLoaded = false;
    @track relatedProducts = [];
    @track logType = '';
    @track requestBody = '';
    @track responseBody = '';
    @track statusLog = '';
    @track internalStatus = '';
    showrelatedproducts = false;
    @track isLoading = true;
    @track enableLogs = false;
    searchTerm = '';
    @track filteredData = [];
    connectedCallback() {
        getEnableConsoleLogsTrue().then(response => {
            this.enableLogs = response;
            if (this.enableLogs) console.log('getEnableConsoleLogsTrue response is', response);
        }).catch(error => {
            if (this.enableLogs) console.log('error is', error);
        });
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
        }).finally(() => {
            this.paginationHelper();
        })
    }
    @track relatedProducts;
    pageSizeOptions = [15, 25, 50, 75, 100];
    @track records = [];
    columns = [];
    totalRecords = 0;
    pageSize;
    totalPages;
    pageNumber = 1;
    @track recordsToDisplay = [];
    labels = { scc_noResults }
    columns = [
        { label: 'ISBN', fieldName: 'Id', initialWidth: 160, type: 'button', typeAttributes: { label: { fieldName: 'ISBN13' }, name: 'viewRecords', target: "_blank", variant: 'base' }, sortable: true },
        { label: 'Title Description', fieldName: 'Description', initialWidth: 550, type: 'text', sortable: true },
        { label: 'Type', fieldName: 'Product_Sub_Type', initialWidth: 180, type: 'text', sortable: true, wrapText: true },
        { label: 'Grade Level', fieldName: 'Grade_Level', initialWidth: 100, type: 'text', sortable: true },
        { label: 'Copyright', fieldName: 'Copyright_Year', initialWidth: 100, type: 'text', sortable: true },
        { label: 'Status', fieldName: 'Product_Status', initialWidth: 140, type: 'text', sortable: true },
        {
            label: 'Price',
            fieldName: 'Net_Price',
            initialWidth: 100,
            type: 'currency',
            sortable: true
        }
    ];
    get columns1() {
        if (this.priceLoaded == false) {
            return [
                { label: 'ISBN', fieldName: 'Id', initialWidth: 160, type: 'button', typeAttributes: { label: { fieldName: 'ISBN13' }, name: 'viewRecords', target: "_blank", variant: 'base' }, sortable: true },
                { label: 'Title Description', fieldName: 'Description', initialWidth: 550, type: 'text', sortable: true },
                { label: 'Type', fieldName: 'Product_Sub_Type', initialWidth: 180, type: 'text', sortable: true, wrapText: true },
                { label: 'Grade Level', fieldName: 'Grade_Level', initialWidth: 100, type: 'text', sortable: true },
                { label: 'Copyright', fieldName: 'Copyright_Year', initialWidth: 100, type: 'text', sortable: true },
                { label: 'Status', fieldName: 'Product_Status', initialWidth: 140, type: 'text', sortable: true },
                { label: 'Price', type: 'button-icon', initialWidth: 80, typeAttributes: { name: 'infoPrice', iconName: 'utility:hourglass', variant: 'border-filled', alternativeText: 'Info' }, sortable: true, hideDefaultActions: true }
            ];
        } else {
            return this.columns;
        }
    }
    onHandleSort(event) {
        this.sortedBy = event.detail.fieldName;
        this.sortDirection = event.detail.sortDirection;
        this.sortData(this.sortedBy, this.sortDirection);
    }
    sortData(fieldname, direction) {
        let parseData = JSON.parse(JSON.stringify(this.recordsToDisplay));
        let keyValue = (element) => {
            return element[fieldname];
        };
        let isReverse = direction === 'asc' ? 1 : -1;
        parseData.sort((xElement, yElement) => {
            xElement = keyValue(xElement) ? keyValue(xElement) : '';
            yElement = keyValue(yElement) ? keyValue(yElement) : '';
            return isReverse * ((xElement > yElement) - (yElement > xElement));
        });
        this.recordsToDisplay = parseData;
    }
    get DisableFirst() {
        return this.pageNumber == 1;
    }
    get DisableLast() {
        return this.pageNumber == this.totalPages;
    }
    @wire(getRelatedProducts, { productId: '$message' })
    wiredRelatedProducts({ error, data }) {
        if (data) {
            this.showrelatedproducts = true;
            this.relatedProducts = [];
            this.relatedProducts = [...data];
            this.orginaldata = [...data];
            this.originalProductData = [...data];
            if (this.enableLogs) console.log('this.relatedProducts', this.relatedProducts);
            this.records = this.relatedProducts;
            this.totalRecords = this.relatedProducts.length;
            this.pageSize = this.pageSizeOptions[0];
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
    tableRowAction(event) {
        let fieldName = event.target.dataset.fieldName;
        let rowId = event.target.dataset.rowId;
        let local_productQuantityData = this.recordsToDisplay;
        if (fieldName == 'isbnId') {
            window.scrollTo({
                top: 0,
                behavior: 'smooth'
            });
            let rowIndex = local_productQuantityData.findIndex(element => element.Id === rowId);
            let rowInfo = local_productQuantityData[rowIndex];
            const rowActionEvent = new CustomEvent('rowaction', {
                detail: {
                    action: 'viewRecords',
                    row: {
                        Id: rowInfo.Id,
                        ISBN13: rowInfo.ISBN13,
                        Description: rowInfo.Description,
                        Product_Sub_Type: rowInfo.Product_Sub_Type,
                        Grade_Level: rowInfo.Grade_Level,
                        Copyright_Year: rowInfo.Copyright_Year,
                        Product_Status: rowInfo.Product_Status,
                        Net_Price: rowInfo.Net_Price
                    }
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
    paginationHelper() {
        this.recordsToDisplay = [];
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
            this.recordsToDisplay.push(this.records[i]);
        }
        console.log('this.recordsToDisplay', this.recordsToDisplay);
        this.totaldisRecords = this.recordsToDisplay.length;
        if (this.recordsToDisplay.length > 0) {
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
                        if (this.enableLogs) console.log('productSimulation', data);
                        if (this.enableLogs) console.log('Check data:>:>' + JSON.stringify(data));
                        if (this.enableLogs) console.log('data.ITEMS[i].ProductId', data.ITEMS[0].NetItemPrice);
                        this.responseBody = JSON.stringify(data.TransactLogs);
                        data = JSON.parse(JSON.stringify(data));
                        this.recordsToDisplay = JSON.parse(JSON.stringify(this.recordsToDisplay));
                        for (let i = 0; i < data.ITEMS.length; i++) {
                            for (let j = 0; j < this.recordsToDisplay.length; j++) {
                                if (!!this.recordsToDisplay[j]) {
                                    if (this.recordsToDisplay[j].Id == data.ITEMS[i].ProductId) {
                                        this.recordsToDisplay[j].Net_Price = this.formatPrice(data.ITEMS[i].SubTotal3);
                                    }
                                }
                            }
                        }
                        this.priceLoaded = true;
                        this.relatedProducts = JSON.parse(JSON.stringify(this.relatedProducts));
                        for (let i = 0; i < data.ITEMS.length; i++) {
                            for (let j = (this.pageNumber - 1) * this.pageSize; j < this.pageNumber * this.pageSize; j++) {
                                if (!!this.relatedProducts[j]) {
                                    if (this.relatedProducts[j].Id == data.ITEMS[i].ProductId) {
                                        this.relatedProducts[j].Net_Price = this.formatPrice(data.ITEMS[i].SubTotal3);
                                    }
                                }
                            }
                        }
                        this.records = this.relatedProducts;
                        this.logType = 'Enosix Product Price Simulation';
                        this.requestBody = JSON.stringify(this.productInfoList1);
                        this.statusLog = 'Success';
                        this.internalStatus = '';
                        this.createLogs(this.logType, this.requestBody, this.responseBody, this.statusLog, this.internalStatus, 'Scc_relatedProductsLWC/getProductDetails/productSimulation');
                    }).catch(error => {
                        if (this.enableLogs) console.log('error is', error);
                        this.logType = 'Enosix Product Price Simulation';
                        this.requestBody = JSON.stringify(this.productInfoList1);
                        this.statusLog = 'Error';
                        this.internalStatus = JSON.stringify(error);
                        this.createLogs(this.logType, this.requestBody, this.responseBody, this.statusLog, this.internalStatus, 'Scc_relatedProductsLWC/getProductDetails/productSimulation');
                    })
            }
        } else {
            this.priceLoaded = true;
        }
    }
    @track filterCriteria = '';
    filterSearchValue = '';
    filter = '';
    @track totalCount = 0;
    @track orginaldata = [];
    @track originalProductData = [];
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
            this.pageNumber = 1;
            this.totalPages = Math.ceil(this.totalRecords / this.pageSize);
            this.paginationHelper();
        }
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