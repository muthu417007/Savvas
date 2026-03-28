import { LightningElement, api, track } from 'lwc';
import { filterDatarealtedProducts } from 'c/scc_filterResults'; // Import the filter helper function
import productSimulation from '@salesforce/apex/ensxtx_CTRL_Cart.productSimulation'; //added by Vaibhav for pricing connector
import imageIcons from '@salesforce/resourceUrl/scc_Images'; // added by Bala for loading Icon Images
import createIntegrationLogsLWC1 from '@salesforce/apex/scc_IntegrationLogs_Helper.createIntegrationLogsLWC1';
import getEnableConsoleLogsTrue from '@salesforce/apex/scc_headerLWC_Controller.getEnableConsoleLogsTrue' ;

export default class scc_internalProductTable extends LightningElement {
    @api columns;
    @track transformedChildTableData = [];
    @track rawChildTableData = [];
    filter = '';
    @track filteredData = [];// filter 
    @track totalFilteredRecords = 0;
    @track orginaldata = [];
    totalCount = 0;
    displayedRecords = 0;
    totalRecords = 0;
    pageSizeOptions = [15, 25, 50, 75, 100]; //Page size options
    pageNumber = 1; //Page number 
    numberOfRows = '5';
    totalPages;
    defaultSortDirection;
    sortDirection;
    sortedBy;
    //added by Vaibhav for pricing connector starts
    @track priceLoaded = false;
    @track DisplayPriceloaded = false;
   // @track showloader = false;
    @track showCAD = false;
    @track productInfoList1 = [];
    @track accountId;
    @track country;
    @track salesOrg;
    @track accId;
    @track isInternalUser = false;
    @track usertypecheck = false;
    @track filter = '';
    @track userStatus;
    @api accvalue;
    @track enosixprice = '';
    @track isEnosixprice = false
    //added by Vaibhav for pricing connector ends
    filterSearchValue = '';
    infoIconUrl = imageIcons + '/Images/info.png';
    crossIconUrl = imageIcons + '/Images/cross.png';
    @track logType = '';
    @track requestBody = '';
    @track responseBody = '';
    @track statusLog = '';
    @track internalStatus = '';
    @track countrycad = '';
    @track enableLogs = false;
    constructor() {
        super();
    }

    connectedCallback(){
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

    getRowStyle(row) {
        return row.countryCodeISO === 'CAD' ? 'color: #82755b;' : '';
    }
    getUserInfo() {
        this.accountId = this.accvalue;
        this.country = this.country;
        if (this.country === 'Only US Sales Org') {
            this.salesOrg = '0002';
        } else if (this.country === 'Only Canadian Sales Org') {
            this.salesOrg = '0006';
        } else {
            this.salesOrg = ''; // Handle other countries if necessary
        }        
        this.paginationHelper();
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
        this.getUserInfo();//added by Vaibhav for pricing connector
    }
    @api
    get countrystatus() {
        return this.countrystatus;
    }
    set countrystatus(value) {
        this.country = value;
    }
    @api
    get accountvalue() {
        return this.accountstatus;
    }
    set accountvalue(value) {
        this.accountId = value;
    }
    // Event handler for navigating to previous page
    previousPage() {
        this.pageNumber = this.pageNumber - 1;
        this.paginationHelper();
    }
    // Event handler for navigating to new page
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
    async paginationHelper() {
         
      
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
            if(this.enableLogs){
            console.log('this.rawChildTableData[i]', this.rawChildTableData[i]);
            }
            if (!!this.rawChildTableData[i]) {
                this.transformedChildTableData.push(this.rawChildTableData[i]);
            }
        }
        this.displayedRecords = this.transformedChildTableData.length;
        //added by vaibhav for pricing connetcor starts
        // if(this.transformedChildTableData.length !=0){
        if (this.transformedChildTableData.length !== 0 && this.accountId) {
            if (this.country == 'Both') {
                this.salesOrg = '0002';
                await this.getProductDetails();
                this.salesOrg = '0006';
                await this.getProductDetails();
            }
            else {
                this.getProductDetails();
            }
        }
        if (this.transformedChildTableData.length !== 0 && this.accountId == '') {
            //this.showloader = true;
            this.calculateDisplayPrice();            
            this.DisplayPriceloaded = true;
            this.isEnosixprice=false;
        }
        this.updateTransformedDataLength();
        //added by vaibhav for pricing connetcor ends
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
        
        this.isPriceLoading = true;
        this.isEnosixprice = true;
        this.productInfoList1 = [];
        this.transformedChildTableData = JSON.parse(JSON.stringify(this.transformedChildTableData));
        for (let i = 0; i < this.transformedChildTableData.length; i++) {
            if (!!this.transformedChildTableData[i]) {
                this.accId = this.transformedChildTableData[i].accountId;
                if (this.transformedChildTableData[i].countryCodeISO == 'CAD') {
                    this.showCAD = true;
                }
                if (this.transformedChildTableData[i].Price == undefined || this.transformedChildTableData[i].Price == 'NA') {
                    if (this.transformedChildTableData[i].productId != undefined && this.transformedChildTableData[i].productId != null) {
                        // if (this.transformedChildTableData[i].IsActive == true) {
                            this.productInfoList1.push(JSON.stringify({ prodId: this.transformedChildTableData[i].productId, quantity: 1 }));
                        // }
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
                        this.rawChildTableData = JSON.parse(JSON.stringify(this.rawChildTableData));
                        for (let i = 0; i < data.ITEMS.length; i++) {
                            for (let j = (this.pageNumber - 1) * this.pageSize; j < this.pageNumber * this.pageSize; j++) {
                                if (!!this.rawChildTableData[j]) {
                                    if (this.rawChildTableData[j].productId == data.ITEMS[i].ProductId) {
                                        this.rawChildTableData[j].Price = this.formatPrice(data.ITEMS[i].SubTotal3);
                                        console.log( 'this.rawChildTableData[j].Price'+ this.rawChildTableData[j].Price);
                                    }
                                }
                            }
                        }
                        this.isPriceLoading = false;
                        this.logType = 'Enosix Product Price Simulation';
                        this.requestBody = JSON.stringify(this.productInfoList1);
                        this.statusLog = 'Success';
                        this.internalStatus = '';
                        this.createLogs(this.logType, this.requestBody, this.responseBody, this.statusLog, this.internalStatus, 'scc_internalProductTable/getProductDetails/productSimulation');
                    }).catch(error => {
                        if(this.enableLogs){
                        console.log('error is', error);
                        }
                        this.logType = 'Enosix Product Price Simulation';
                        this.requestBody = JSON.stringify(this.productInfoList1);
                        this.statusLog = 'Error';
                        this.internalStatus = JSON.stringify(error);
                        this.createLogs(this.logType, this.requestBody, this.responseBody, this.statusLog, this.internalStatus, 'scc_internalProductTable/getProductDetails/productSimulation');
                    })
            }
        } else {
            //this.priceLoaded = true;
            this.showloader = false;
        }
        return null;
    }
    handleRowAction(event) {
        event.preventDefault();
        // Extract the rowId from the event target's dataset
        let rowId = event.target.dataset.rowId;
        // Create a shallow copy of the transformedChildTableData
        this.local_productQuantityData = [...this.transformedChildTableData];
        // Find the index of the row with the matching productId
        let rowIndex = this.local_productQuantityData.findIndex(element => element.productId === rowId);
        let rowInfo = this.local_productQuantityData[rowIndex];
        if (rowInfo.UserStatus === 'International') {
            rowInfo.Price = rowInfo.ListPrice;            
        } else {
            rowInfo.Price = rowInfo.NetPrice;         
        }       
        rowInfo.Price = parseFloat(rowInfo.Discount).toFixed(2);
        // Create the custom event with the necessary details
        const selectEvent = new CustomEvent('showproducttitlepage', {
            detail: {
                parentSelectedProductRecord: rowInfo,
                displayedRecords: this.displayedRecords,
                usertypecheck: rowInfo.isInternalUser
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
    // Event handler for changing records per page
    handleRecordsPerPage(event) {
        this.pageSize = event.target.value;
        this.paginationHelper();
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
    handleFilterChange() {
        if (this.filter != '') {
            const lowerCaseFilter = this.filter.toLowerCase();
            this.filteredData = filterDatarealtedProducts(this.orginaldata, lowerCaseFilter);
            this.totalCount = this.filteredData.length; // Update totalFilteredRecords property
            this.rawChildTableData = this.filteredData;
            this.totalRecords = this.filteredData.length
            this.pageNumber = 1;
            this.totalPages = Math.ceil(this.totalCount / this.pageSize)
            this.paginationHelper();
            this.updateTransformedDataLength();
        }
        else {
            this.filteredData = [];
            this.totalCount = 0;
            this.totalRecords = this.orginaldata.length;
            this.rawChildTableData = this.orginaldata;
            this.pageNumber = 1; // Reset page number to 1 after removing filter
            this.totalPages = Math.ceil(this.totalRecords / this.pageSize);
            this.paginationHelper();
            this.updateTransformedDataLength();
        }
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

    }
    clearFilterInput(event) {
        if (this.filterSearchValue == '' || this.filterSearchValue == null) {            
            this.filterSearchValue = '';            
            this.filteredData = [];
        }
        else {
            this.filterSearchValue = '';            
            this.filteredData = [];
            this.totalCount = 0;
            this.rawChildTableData = this.orginaldata;
            this.totalRecords = this.orginaldata.length;
            this.pageNumber = 1; // Reset page number to 1 after removing filter
            this.totalPages = Math.ceil(this.totalRecords / this.pageSize);
            this.paginationHelper();
            this.updateTransformedDataLength();
        }
    }
    updateTransformedDataLength() {
        this.transformedDataLength = this.transformedChildTableData.length;
        this.totalCount = this.totalRecords;
        const event = new CustomEvent('transformeddatalength', {
            detail: {
                transformedDataLength: this.transformedDataLength,
                totalFilteredRecords: this.totalFilteredRecords,
                totalCount: this.totalRecords
            }
        });
        this.dispatchEvent(event);
        
    }
    calculateDisplayPrice() {
    const updatedChildTableData = this.transformedChildTableData.map(row => {
        let updatedRow = { ...row };
        if (row.UserStatus === 'International') {
            if (row.NetPrice) {
                
                let netPrice = parseFloat(row.NetPrice.replace(/[$,]/g, ''));
                let listPrice = Math.floor(netPrice * 1.333 * 100) / 100;
                
                updatedRow.DisplayPrice = `$${this.formatPrice(listPrice)}`;
            } else {
                if(this.enableLogs) {
                    console.error('NetPrice is undefined or null for International user.');
                }
                updatedRow.DisplayPrice = 'N/A';
            }
        } else if (row.UserStatus === 'Internal US User' || row.UserStatus === 'K12/School') {
            if (row.NetPrice) {
               
                let netPrice = parseFloat(row.NetPrice.replace(/[$,]/g, ''));
                updatedRow.DisplayPrice = `$${this.formatPrice(netPrice)}`;
            } else {
                if(this.enableLogs) {
                    console.error('NetPrice is undefined or null for K12/School user.');
                }
                updatedRow.DisplayPrice = 'N/A';
            }
        } else {
            updatedRow.DisplayPrice = 'Price Not Available';
        }
        return updatedRow;
    });
    this.transformedChildTableData = updatedChildTableData;
}
    createLogs(logType, requestBody, responseBody, statusLog, internalStatus, entryPoint) {
        createIntegrationLogsLWC1({ logType: logType, requestBody: requestBody, responseBody: responseBody, status: statusLog, internalStatus: internalStatus, entryPoint: entryPoint })
            .then(result => {
                if(this.enableLogs){
                    console.log('result is', result);
                }
            })
            .catch(error => {
                if(this.enableLogs){
                    console.log('error is', error);
                }
            })
    }
}