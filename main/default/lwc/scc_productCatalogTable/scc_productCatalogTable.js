/*********************************************************
  Component Name       : scc_productCatalogTable
  Created Date         : 05/21/2024  
  Author               : Sudha Rani pathivada- Cognizant
  Description          : Nested component for scc_Catalog LWcsearch component  Holds the lightning-tree for all ProductCategories
  Modifications Log
  <Date>       <Author>            <Modification>
*********************************************************/
import { LightningElement, api, track } from 'lwc';
import { filterDatarealtedProducts } from 'c/scc_filterResults';
import getUserInformation from '@salesforce/apex/scc_headerLWC_Controller.getUserInformation';
import productSimulation from '@salesforce/apex/ensxtx_CTRL_Cart.productSimulation';
import createIntegrationLogsLWC1 from '@salesforce/apex/scc_IntegrationLogs_Helper.createIntegrationLogsLWC1';
import getEnableConsoleLogsTrue from '@salesforce/apex/scc_headerLWC_Controller.getEnableConsoleLogsTrue';
export default class scc_productCatalogTable extends LightningElement {
    @api columns;
    @track transformedChildTableData = [];
    @track rawChildTableData = [];
    filter = '';
    @track filteredData = [];
    @track totalFilteredRecords = 0;
    @track orginaldata = [];
    @track totalCount = 0;
    displayedRecords = 0;
    totalRecords = 0;
    pageSizeOptions = 15;
    @track transformedDataLength = 0;
    totalPages;
    defaultSortDirection;
    sortDirection;
    sortedBy;
    @track currentPage = 1;
    @track pageSize = 15;
    @track showLoadNextButton = false;
    @track priceLoaded = false;
    @track filter = '';
    filterSearchValue = '';
    @track isInternalUser = false;
    @track profileName = '';
    @track logType = '';
    @track requestBody = '';
    @track responseBody = '';
    @track statusLog = '';
    @track internalStatus = '';
    @track enableLogs = false;
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
        this.calculateTotalPages();
    }
    connectedCallback() {
        getEnableConsoleLogsTrue().then(response => {
            this.enableLogs = response;
            if (this.enableLogs) console.log('getEnableConsoleLogsTrue response is', response);
        }).catch(error => {
            if (this.enableLogs) console.log('error is', error);
        });
        this.getUserInfo();
    }
    getUserInfo() {
        getUserInformation().then(response => {
            let paser = JSON.parse(response);
            if (this.enableLogs) console.log('parsed response is', paser);
            let data = paser[0];
            this.profileName = data.profile;
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
            this.displayFirstPage();
        })
    }
    calculateTotalPages() {
        if (this.filter) {
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
    displayFirstPage() {
        if (this.rawChildTableData) {
            const endIndex = Math.min(this.pageSize, this.totalRecords);
            this.transformedChildTableData = this.rawChildTableData.slice(0, endIndex);
            this.currentPage = 1;
            this.updateTransformedDataLength();
            this.notifysearchresultsavailable();
            this.displayedRecords = this.transformedChildTableData.length;
            if (this.transformedChildTableData.length > 0) {
                if (this.transformedChildTableData.some(row => row.isInternalUser)) {
                    this.priceLoaded = false;
                    this.calculateDisplayPrice();
                } else if (this.profileName == 'Savvas External Users Base Profile') {
                    this.priceLoaded = false;
                    this.getProductDetails();
                }
            }
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
        for (let i = 0; i < this.transformedChildTableData.length; i++) {
            if (!!this.transformedChildTableData[i]) {
                if (this.transformedChildTableData[i].Price == undefined || this.transformedChildTableData[i].Price == 'NA') {
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
        if (this.enableLogs) console.log('this.accountId', this.accountId);
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
                        data = JSON.parse(JSON.stringify(data));
                        this.responseBody = JSON.stringify(data.TransactLogs);
                        for (let i = 0; i < data.ITEMS.length; i++) {
                            for (let j = 0; j < this.transformedChildTableData.length; j++) {
                                if (!!this.transformedChildTableData[j]) {
                                    if (this.transformedChildTableData[j].productId == data.ITEMS[i].ProductId) {
                                        this.transformedChildTableData[j].Price = this.formatPrice(data.ITEMS[i].SubTotal3);
                                    }
                                }
                            }
                        }
                        this.priceLoaded = true;
                        for (let i = 0; i < data.ITEMS.length; i++) {
                            for (let j = (this.pageNumber - 1) * this.pageSize; j < this.pageNumber * this.pageSize; j++) {
                                if (!!this.rawChildTableData[j]) {
                                    if (this.rawChildTableData[j].productId == data.ITEMS[i].ProductId) {
                                        this.rawChildTableData[j].Price = this.formatPrice(data.ITEMS[i].SubTotal3);
                                    }
                                }
                            }
                        }
                        this.logType = 'Enosix Product Price Simulation';
                        this.requestBody = JSON.stringify(this.productInfoList1);
                        this.statusLog = 'Success';
                        this.internalStatus = '';
                        this.createLogs(this.logType, this.requestBody, this.responseBody, this.statusLog, this.internalStatus, 'scc_productCatalogTable/getProductDetails/productSimulation');
                    }).catch(error => {
                        if (this.enableLogs) console.log('error is', error);
                        this.logType = 'Enosix Product Price Simulation';
                        this.requestBody = JSON.stringify(this.productInfoList1);
                        this.statusLog = 'Error';
                        this.internalStatus = JSON.stringify(error);
                        this.createLogs(this.logType, this.requestBody, this.responseBody, this.statusLog, this.internalStatus, 'scc_productCatalogTable/getProductDetails/productSimulation');
                    });
            }
        } else {
            this.priceLoaded = true;
        }
    }
    calculateDisplayPrice() {
        const startIndex = (this.currentPage - 1) * this.pageSize;
        const endIndex = this.currentPage * this.pageSize;
        let updatedData = [...this.transformedChildTableData];
        for (let i = startIndex; i < endIndex && i < updatedData.length; i++) {
            let row = { ...updatedData[i] };
            if (row.UserStatus === 'International') {
                if (row.ListPrice !== undefined && row.ListPrice !== null) {
                    row.Price = row.ListPrice;
                } else {
                    row.Price = 'N/A';
                }
            } else if (row.UserStatus === 'Internal US User') {
                if (row.NetPrice !== undefined && row.NetPrice !== null) {
                    row.Price = row.NetPrice;
                } else {
                    row.Price = 'N/A';
                }
            } else {
                row.Price = 'N/A';
            }
            updatedData[i] = row;
        }
        this.transformedChildTableData = updatedData;
        this.priceLoaded = true;
    }
    get transformedChildTableData() {
        return this.transformedChildTableData.slice(0, this.pageSize * this.currentPage);
    }
    handleLoadNextClick() {
        this.handleLoadNext();
    }
    onHandleSort(event) {
        this.sortedBy = event.detail.fieldName;
        this.sortDirection = event.detail.sortDirection;
        this.sortData(this.sortedBy, this.sortDirection);
    }
    sortData(fieldname, direction) {
        let parseData = JSON.parse(JSON.stringify(this.transformedChildTableData));
        let keyValue = (element) => {
            return element[fieldname];
        };
        let isReverse = direction === 'asc' ? 1 : -1;
        parseData.sort((xElement, yElement) => {
            xElement = keyValue(xElement) ? keyValue(xElement) : '';
            yElement = keyValue(yElement) ? keyValue(yElement) : '';
            return isReverse * ((xElement > yElement) - (yElement > xElement));
        });
        this.transformedChildTableData = parseData;
    }
    handleRowAction(event) {
        event.preventDefault();
        let rowId = event.target.dataset.rowId;
        this.local_productQuantityData = [...this.transformedChildTableData];
        if (this.enableLogs) console.log('local_productQuantityData:', JSON.stringify(this.local_productQuantityData));
        let rowIndex = this.local_productQuantityData.findIndex(element => element.productId === rowId);
        if (rowIndex !== -1) {
            let rowInfo = { ...this.local_productQuantityData[rowIndex] };
            if (this.enableLogs) console.log('Row Info before price adjustment:', JSON.stringify(rowInfo));
            if (!rowInfo.UserStatus) {
                if (this.enableLogs) console.error('UserStatus is missing in rowInfo:', JSON.stringify(rowInfo));
            }
            if (!rowInfo.NetPrice) {
                if (this.enableLogs) console.error('NetPrice is missing in rowInfo:', JSON.stringify(rowInfo));
            }
            if (rowInfo.isInternalUser) {
                if (rowInfo.UserStatus === 'International') {
                    rowInfo.Price = rowInfo.ListPrice;
                } else if (rowInfo.UserStatus === 'Internal US User') {
                    rowInfo.Price = rowInfo.NetPrice;
                } else {
                    rowInfo.Price = "NA";
                }
            } else {
                rowInfo.Price = rowInfo.Price;
            }
            const selectEvent = new CustomEvent('showproducttitlepage', {
                detail: {
                    parentSelectedProductRecord: rowInfo,
                    displayedRecords: this.displayedRecords
                }
            });
            this.dispatchEvent(selectEvent);

        } else {
            if (this.enableLogs) console.error('Row Index is invalid');
        }
    }
    handleLoadNext() {
        const startIndex = this.pageSize * this.currentPage;
        const endIndex = Math.min(startIndex + this.pageSize, this.totalRecords);
        const nextRecords = this.rawChildTableData.slice(startIndex, endIndex);
        this.transformedChildTableData = [...this.transformedChildTableData, ...nextRecords];
        this.currentPage++;
        this.displayedRecords = this.transformedChildTableData.length;
        this.showLoadNextButton = this.displayedRecords < this.totalRecords;
        this.updateTransformedDataLength();
        if (this.transformedChildTableData.length > 0) {
            if (this.transformedChildTableData.some(row => row.isInternalUser)) {
                this.priceLoaded = false;
                this.calculateDisplayPrice();
            } else if (this.profileName == 'Savvas External Users Base Profile') {
                this.priceLoaded = false;
                this.getProductDetails();
            }
        }
    }
    taskTypeHelpTextClass = 'slds-popover slds-popover_tooltip slds-nubbin_bottom-right slds-fall-into-ground slds-hide';
    togglePasswordHint() {
        let hideCss = 'slds-popover slds-popover_tooltip slds-nubbin_bottom-right slds-fall-into-ground slds-hide';
        let showCss = 'slds-popover slds-popover_tooltip slds-nubbin_bottom-right slds-rise-from-ground';
        this.taskTypeHelpTextClass = this.taskTypeHelpTextClass == hideCss ? showCss : hideCss;
    }
    updateTransformedDataLength() {
        this.transformedDataLength = this.transformedChildTableData.length;
        const event = new CustomEvent('transformeddatalength', {
            detail: {
                transformedDataLength: this.transformedDataLength,
                totalFilteredRecords: this.filter ? this.totalFilteredRecords : this.totalRecords,
                totalCount: this.totalCount,
                displayedRecords: this.displayedRecords
            }
        });
        this.dispatchEvent(event);
    }
    notifysearchresultsavailable() {
        const event = new CustomEvent('searchresultsavailable');
        this.dispatchEvent(event);
    }
    handleFilter(event) {
        const searchTerm = event.target.value.trim();
        this.filterSearchValue = event.target.value;
        this.filter = searchTerm;
        if (!searchTerm || searchTerm.length < 3 && !/^\d{3,}$/.test(searchTerm)) {
            this.filter = '';
            this.handleFilterChange();
        } else {
            const searchTerms = searchTerm.split(/\s+/).filter(term => term);
            if (searchTerms.length > 1) {
                this.filter = searchTerm;
            } else if (/^\d{10,13}$/.test(searchTerm)) {
                this.filter = searchTerm;
            } else if (/^\d{1,5}$/.test(searchTerm)) {
                this.filter = searchTerm;
            } else {
                this.filter = searchTerm;
            }
            this.handleFilterChange();
        }
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
            this.totalCount = this.orginaldata.length
            this.rawChildTableData = this.orginaldata;
            this.calculateTotalPages();
            this.displayFirstPage();
            this.updateTransformedDataLength();
        }
    }
    handleFilterChange() {
        if (this.filter != '') {
            const lowerCaseFilter = this.filter.toLowerCase();
            this.filteredData = filterDatarealtedProducts(this.orginaldata, lowerCaseFilter);
            this.totalCount = this.filteredData.length;
            this.rawChildTableData = this.filteredData;
            this.updateTransformedDataLength();
            this.calculateTotalPages();
            this.displayFirstPage();
        }
        else {
            this.filteredData = [];
            this.rawChildTableData = this.orginaldata;
            this.updateTransformedDataLength();
            this.totalCount = this.orginaldata.length
            this.calculateTotalPages();
            this.displayFirstPage();
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