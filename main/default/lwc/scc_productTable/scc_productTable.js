import { LightningElement, api, track } from 'lwc';
import { filterDatarealtedProducts } from 'c/scc_filterResults';
import productSimulation from '@salesforce/apex/ensxtx_CTRL_Cart.productSimulation';
import getUserInformation from '@salesforce/apex/scc_headerLWC_Controller.getUserInformation';
import imageIcons from '@salesforce/resourceUrl/scc_Images';
import createIntegrationLogsLWC1 from '@salesforce/apex/scc_IntegrationLogs_Helper.createIntegrationLogsLWC1';
import getEnableConsoleLogsTrue from '@salesforce/apex/scc_headerLWC_Controller.getEnableConsoleLogsTrue';
import scc_stateFilterMessage from "@salesforce/label/c.scc_stateFilterMessage";
// Import Apex methods to retrieve alternate addresses
import getUserBillingAddress from '@salesforce/apex/scc_confirmAddress.getUserBillingAddress';
import getUserShippingAddress from '@salesforce/apex/scc_confirmAddress.getUserShippingAddress';

export default class scc_productTable extends LightningElement {
    @api columns;
    @track transformedChildTableData = [];
    @track rawChildTableData = [];
    @track filteredData = [];
    @track orginaldata = [];
    @track productInfoList1 = [];
    @track accountId;
    @track country;
    @track salesOrg;
    @track message;
    checkboxMessage = 'National AND my State(s)'
    filterSearchValue = '';
    filter = '';
    totalRecords = 0;
    totalFilteredRecords = 0;
    totalCount = 0;
    displayedRecords = 0;
    pageSizeOptions = [15, 25, 50, 75, 100];
    pageNumber = 1;
    numberOfRows = '5';
    totalPages;
    defaultSortDirection;
    sortDirection;
    sortedBy;
    priceLoaded = false;
    enableLogs = false;

    infoIconUrl = imageIcons + '/Images/info.png';
    crossIconUrl = imageIcons + '/Images/cross.png';

    @track logType = '';
    @track requestBody = '';
    @track responseBody = '';
    @track statusLog = '';
    @track internalStatus = '';

    @track showNationalAndStateFilter = true; // Default checked
    @track userStates = new Set();
    @api defaultNationalStateFilter; 
    labels = {
       scc_stateFilterMessage
    }

    get defaultNationalStateFilter() {
        return this._defaultNationalStateFilter === undefined ? true : this._defaultNationalStateFilter;
    }

    set defaultNationalStateFilter(value) {
        this._defaultNationalStateFilter = value;
    }

    connectedCallback() {
        getEnableConsoleLogsTrue().then(response => {
            this.enableLogs = response;
            if (this.enableLogs) console.log('getEnableConsoleLogsTrue response is', response);
        }).catch(error => {
            if (this.enableLogs) console.log('error is', error);
        });
        this.showNationalAndStateFilter = this.defaultNationalStateFilter;
        if (this.enableLogs) console.log('columns ', this.columns);
    }

    @api
    get rawParentTableData() {
        return this.currentTableData;
    }
    set rawParentTableData(value) {
        this.rawChildTableData = value;
        this.orginaldata = value;
        this.totalRecords = this.rawChildTableData.length;
        if (this.totalRecords === 0) {
            this.transformedChildTableData = [];
            this.updateTransformedDataLength();
        }
        this.pageSize = this.pageSizeOptions[0];
        // Retrieve user info and then addresses
        this.retrieveUserAndAddresses();
    }

    @api
    get parentname() {
        return this._parentName;
    }
    set parentname(value) {
        this._parentname = value;
        this.message = value
    }

retrieveUserAndAddresses() {
    Promise.all([
        getUserInformation(),
        getUserBillingAddress(),
        getUserShippingAddress()
    ]).then(([userInfoResp, billingAddresses, shippingAddresses]) => {
         if (this.enableLogs) {
            console.log('\n=== Address Data Debug Information ===');
            
            console.log('\nBilling Addresses:');
            console.log('Total billing addresses:', billingAddresses.length);
            billingAddresses.forEach((addr, index) => {
                console.log(`\nBilling Address ${index + 1}:`);
                console.log('Full address object:', addr);
                console.log('State:', addr.State);
                console.log('Available fields:', Object.keys(addr));
            });
            
            console.log('\nShipping Addresses:');
            console.log('Total shipping addresses:', shippingAddresses.length);
            shippingAddresses.forEach((addr, index) => {
                console.log(`\nShipping Address ${index + 1}:`);
                console.log('Full address object:', addr);
                console.log('Province:', addr.Provionce); 
                console.log('Available fields:', Object.keys(addr));
            });
        }
        let parsed = JSON.parse(userInfoResp);
        let data = parsed[0];
        if (this.enableLogs) {
            console.log('User account data:', data);
        }

        this.accountId = data.accountId;
        this.country = data.billing_County;

        // Determine salesOrg based on country
        if (this.country == 'United States') {
            this.salesOrg = '0002'
        }
        if (this.country == 'Canada') {
            this.salesOrg = '0006'
        }

        // Collect all states into a set 
        let userStatesSet = new Set();

        // Add the standard billing state if available
        if (data.billing_State) {
            userStatesSet.add(data.billing_State);
        }

        // Add the standard shipping state if available
        if (data.shipping_State) {
            userStatesSet.add(data.shipping_State);
        }

        // Add states from alternate billing addresses
        billingAddresses.forEach(addr => {
            if (addr.State) {
                userStatesSet.add(addr.State);
            }
        });

        // Add states from alternate shipping addresses
        shippingAddresses.forEach(addr => {
            if (addr.Provionce) {
                userStatesSet.add(addr.Provionce);
            }
        });

        this.userStates = userStatesSet;

        if (this.enableLogs) {
            console.log('\n=== Final State Collection Summary ===');
            console.log('All collected states:', Array.from(this.userStates));
            console.log('Total unique states:', this.userStates.size);
        }

        // After gathering all user states, apply filter if needed
        if (this.showNationalAndStateFilter) {
            this.applyNationalAndStateFilter();
        } else {
            // If not filtering by state/national, just run pagination
            this.paginationHelper();
        }

    }).catch(error => {
        if (this.enableLogs) console.error('Error retrieving user info or addresses:', error);
        this.paginationHelper(); 
    });
}


    get columns1() {
        if (this.priceLoaded == true) {
            return [
                { label: 'ISBN', fieldName: 'ISBN', type: 'button', typeAttributes: { label: { fieldName: 'ISBN', type: 'text' }, name: 'viewRecords', target: '_blank', class: 'custom-button', variant: 'base' }, sortable: true },
                { label: 'Title Description', fieldName: 'Title_Description', sortable: true, type: 'text' },
                { label: 'Type', fieldName: 'Type', type: 'text', sortable: true, wrapText: true },
                { label: 'Grade Level', fieldName: 'Grade_Level', type: 'text', sortable: true },
                { label: 'Copyright', fieldName: 'Copyright', type: 'text', sortable: true },
                { label: 'Status', fieldName: 'Status', type: 'text', sortable: true },
                { label: 'Price', fieldName: 'Price', type: 'text', sortable: 'true' }
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
        for (let i = (this.pageNumber - 1) * this.pageSize; i < this.pageNumber * this.pageSize; i++) {
            if (i === this.totalRecords) {
                break;
            }
            if (!!this.rawChildTableData[i]) {
                this.transformedChildTableData.push(this.rawChildTableData[i]);
            }
        }
        this.displayedRecords = this.transformedChildTableData.length;
        if (this.transformedChildTableData.length != 0) {
            this.getProductDetails();
        }
        this.updateTransformedDataLength();
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
        sfObjectIdMap.Account = this.accountId;
        if (this.productInfoList1.length > 0 && this.accountId != undefined) {
            productSimulation({
                productInfoList: this.productInfoList1,
                sfObjectIdMap: sfObjectIdMap,
                pdpAppSettingsName: 'ensxtx_SR_enosixCartPDPAppSettings',
                appSettingsName: 'ensxtx_SR_enosixProductB2BAppSettings',
                pdpInputParametersMap: pdpInputParametersMap1
            })
                .then(({ data, messages }) => {
                    if (this.enableLogs) console.log('productSimulation', data);
                    this.responseBody = JSON.stringify(data.TransactLogs);
                    data = JSON.parse(JSON.stringify(data));
                    this.transformedChildTableData = JSON.parse(JSON.stringify(this.transformedChildTableData));
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
                    this.rawChildTableData = JSON.parse(JSON.stringify(this.rawChildTableData));
                    for (let i = 0; i < data.ITEMS.length; i++) {
                        for (let j = (this.pageNumber - 1) * this.pageSize; j < this.pageNumber * this.pageSize; j++) {
                            if (!!this.rawChildTableData[j]) {
                                if (this.rawChildTableData[j].productId == data.ITEMS[i].ProductId) {
                                    this.transformedChildTableData[j].Price = this.formatPrice(data.ITEMS[i].SubTotal3);
                                }
                            }
                        }
                    }
                    this.logType = 'Enosix Product Price Simulation';
                    this.requestBody = JSON.stringify(this.productInfoList1);
                    this.statusLog = 'Success';
                    this.internalStatus = '';
                    this.createLogs(this.logType, this.requestBody, this.responseBody, this.statusLog, this.internalStatus, 'scc_productTable/getProductDetails/productSimulation');
                }).catch(error => {
                    if (this.enableLogs) console.log('error is', error);
                    this.logType = 'Enosix Product Price Simulation';
                    this.requestBody = JSON.stringify(this.productInfoList1);
                    this.statusLog = 'Error';
                    this.internalStatus = JSON.stringify(error);
                    this.createLogs(this.logType, this.requestBody, this.responseBody, this.statusLog, this.internalStatus, 'scc_productTable/getProductDetails/productSimulation');
                });
        } else {
            this.priceLoaded = true;
        }
    }

    handleRowAction(event) {
        event.preventDefault();
        let rowId = event.target.dataset.rowId;
        this.local_productQuantityData = this.transformedChildTableData;
        if (this.enableLogs) console.log('Row transformedChildTableData:', this.transformedChildTableData);
        let rowIndex = this.local_productQuantityData.findIndex(element => element.productId === rowId);
        let rowInfo = this.local_productQuantityData[rowIndex];
        const selectEvent = new CustomEvent('showproducttitlepage', {
            detail: {
                parentSelectedProductRecord: rowInfo,
                displayedRecords: this.displayedRecords
            }
        });
        this.dispatchEvent(selectEvent);
    }

    get bDisableFirst() {
        return this.pageNumber == 1;
    }
    get bDisableLast() {
        return this.pageNumber == this.totalPages;
    }

    handleRecordsPerPage(event) {
        this.pageSize = event.target.value;
        this.paginationHelper();
    }

    // handleFilter(event) {
    //     const searchTerm = event.target.value.trim();
    //     this.filterSearchValue = event.target.value;
    //     this.filter = '';
        
    //     if (!searchTerm || (searchTerm.length < 3 && !/^\d{3,}$/.test(searchTerm))) {
    //         this.handleFilterChange();
    //     } else {
    //         this.filter = searchTerm;
    //         this.handleFilterChange();
    //     }
    // }

    handleFilterChange() {
        if (this.filter != '') {
            const lowerCaseFilter = this.filter.toLowerCase();
            // Apply text filter
            this.filteredData = filterDatarealtedProducts(this.orginaldata, lowerCaseFilter);
            this.rawChildTableData = this.filteredData;
            this.totalRecords = this.filteredData.length;
            this.totalFilteredRecords = this.filteredData.length;

            // Apply national/state filter if enabled
            if (this.showNationalAndStateFilter && this.userStates.size > 0) {
                this.rawChildTableData = this.rawChildTableData.filter(record => {
                    return record.programSeries === 'NATL' || this.userStates.has(record.programSeries);
                });
                this.totalRecords = this.rawChildTableData.length;
                this.totalFilteredRecords = this.rawChildTableData.length;
            }

            this.pageNumber = 1;
            this.totalPages = Math.ceil(this.totalRecords / this.pageSize);
            this.paginationHelper();
        } else {
            this.filteredData = [];
            this.rawChildTableData = [...this.orginaldata];

            // Apply national/state filter if enabled
            if (this.showNationalAndStateFilter && this.userStates.size > 0) {
                this.rawChildTableData = this.rawChildTableData.filter(record => {
                    return record.programSeries === 'NATL' || this.userStates.has(record.programSeries);
                });
            }

            this.totalRecords = this.rawChildTableData.length;
            this.totalFilteredRecords = this.rawChildTableData.length;
            this.pageNumber = 1;
            this.totalPages = Math.ceil(this.totalRecords / this.pageSize);
            this.paginationHelper();
        }
        
        this.updateTransformedDataLength();
    }

    taskTypeHelpTextClass = 'slds-popover slds-popover_tooltip slds-nubbin_bottom-right slds-fall-into-ground slds-hide';
    togglePasswordHint() {
        let hideCss = 'slds-popover slds-popover_tooltip slds-nubbin_bottom-right slds-fall-into-ground slds-hide';
        let showCss = 'slds-popover slds-popover_tooltip slds-nubbin_bottom-right slds-rise-from-ground';
        this.taskTypeHelpTextClass = this.taskTypeHelpTextClass == hideCss ? showCss : hideCss;
    }

    taskTypeHelpTextClassfilter = 'slds-popover slds-popover_tooltip slds-nubbin_bottom slds-fall-into-ground filterInfo-poppup slds-hide';
    togglePasswordHintfilter() {
        let hideCss = 'slds-popover slds-popover_tooltip slds-nubbin_bottom slds-fall-into-ground filterInfo-poppup slds-hide';
        let showCss = 'slds-popover slds-popover_tooltip slds-nubbin_bottom slds-rise-from-ground filterInfo-poppup';
        this.taskTypeHelpTextClassfilter = this.taskTypeHelpTextClassfilter == hideCss ? showCss : hideCss;
    }

    taskTypeHelpTextClassCount = 'slds-popover slds-popover_tooltip slds-nubbin_bottom-right slds-fall-into-ground countInfo-poppup slds-hide';
    togglePasswordHintCount(event) {
        let hideCss = 'slds-popover slds-popover_tooltip slds-nubbin_bottom-right slds-fall-into-ground countInfo-poppup slds-hide';
        let showCss = 'slds-popover slds-popover_tooltip slds-nubbin_bottom-right slds-rise-from-ground countInfo-poppup';
        this.taskTypeHelpTextClassCount = this.taskTypeHelpTextClassCount == hideCss ? showCss : hideCss;
        if (this.enableLogs) console.log(event.type + ' ' + this.message + ' ' + this.taskTypeHelpTextClassCount);
    }

    // clearFilterInput(event) {
    //     if (!this.filterSearchValue) {
    //         this.filterSearchValue = '';
    //     } else {
    //         this.filteredData = [];
    //         this.filterSearchValue = '';
    //         this.filter = '';
    //         this.rawChildTableData = [...this.orginaldata];

    //         if (this.showNationalAndStateFilter && this.userStates.size > 0) {
    //             this.rawChildTableData = this.rawChildTableData.filter(record => {
    //                 return record.programSeries === 'NATL' || this.userStates.has(record.programSeries);
    //             });
    //         }

    //         this.totalRecords = this.rawChildTableData.length;
    //         this.totalFilteredRecords = this.rawChildTableData.length;
    //         this.pageNumber = 1;
    //         this.totalPages = Math.ceil(this.totalRecords / this.pageSize);
    //         this.paginationHelper();
    //         this.updateTransformedDataLength();
    //     }
    // }

    handleFilterKeydown(event) {
        if (event.key === 'Enter') {
            this.clearFilterInput();
        }
    }

    updateTransformedDataLength() {
        this.transformedDataLength = this.transformedChildTableData.length;
        this.totalCount = this.totalRecords;
        
        const event = new CustomEvent('transformeddatalength', {
            detail: {
                transformedDataLength: this.transformedDataLength,
                totalFilteredRecords: this.totalFilteredRecords,
                totalCount: this.totalCount
            }
        });
        this.dispatchEvent(event);
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

    applyNationalAndStateFilter() {
        if (this.enableLogs) {
            console.log('Applying national and state filter');
            console.log('Current userStates:', this.userStates);
            console.log('Filter enabled:', this.showNationalAndStateFilter);
        }

        if (!this.showNationalAndStateFilter) {
            // If filter is unchecked, show all records
            this.rawChildTableData = [...this.orginaldata];
        } else {
            // Filter for National AND any of the user's states
            this.rawChildTableData = this.orginaldata.filter(record => {
                return record.programSeries === 'NATL' ||
                       (this.userStates && this.userStates.has(record.programSeries));
            });
        }
        
        if (this.enableLogs) {
            console.log('Filtered records count:', this.rawChildTableData.length);
        }
        
        this.totalRecords = this.rawChildTableData.length;
        this.pageNumber = 1;
        this.totalPages = Math.ceil(this.totalRecords / this.pageSize);
        this.paginationHelper();
        this.updateTransformedDataLength();
    }

    handleNationalAndStateFilterChange(event) {
        this.showNationalAndStateFilter = event.target.checked;
        
        // Start with original data
        let filteredResults = [...this.orginaldata];
        
        // Apply text filter if it exists
        if (this.filter) {
            const lowerCaseFilter = this.filter.toLowerCase();
            filteredResults = filterDatarealtedProducts(filteredResults, lowerCaseFilter);
        }
        
        // Apply national/state filter if checked
        if (this.showNationalAndStateFilter && this.userStates.size > 0) {
            filteredResults = filteredResults.filter(record => {
                return record.programSeries === 'NATL' || this.userStates.has(record.programSeries);
            });
        }
        
        // Update the data
        this.rawChildTableData = filteredResults;
        this.totalRecords = filteredResults.length;
        this.totalFilteredRecords = filteredResults.length;
        this.pageNumber = 1;
        this.totalPages = Math.ceil(this.totalRecords / this.pageSize);
        this.paginationHelper();
        this.updateTransformedDataLength();
    }

    handleFilter(event) {
        const searchTerm = event.target.value.trim();
        this.filterSearchValue = event.target.value;
        this.filter = '';
        
        if (!searchTerm || (searchTerm.length < 3 && !/^\d{3,}$/.test(searchTerm))) {
            this.filter = '';
            this.applyAllFilters();
        } else {
            this.filter = searchTerm;
            this.applyAllFilters();
        }
    }

    applyAllFilters() {
        // Start with original data
        let filteredResults = [...this.orginaldata];
        
        // Apply text filter if it exists
        if (this.filter) {
            const lowerCaseFilter = this.filter.toLowerCase();
            filteredResults = filterDatarealtedProducts(filteredResults, lowerCaseFilter);
        }
        
        // Apply national/state filter if enabled
        if (this.showNationalAndStateFilter && this.userStates.size > 0) {
            filteredResults = filteredResults.filter(record => {
                return record.programSeries === 'NATL' || this.userStates.has(record.programSeries);
            });
        }
        
        // Update the component state
        this.filteredData = this.filter ? filteredResults : [];
        this.rawChildTableData = filteredResults;
        this.totalRecords = filteredResults.length;
        this.totalFilteredRecords = filteredResults.length;
        this.pageNumber = 1;
        this.totalPages = Math.ceil(this.totalRecords / this.pageSize);
        this.paginationHelper();
        this.updateTransformedDataLength();
    }

    clearFilterInput(event) {
        if (!this.filterSearchValue) return;
        
        this.filterSearchValue = '';
        this.filter = '';
        this.applyAllFilters();
    }
}