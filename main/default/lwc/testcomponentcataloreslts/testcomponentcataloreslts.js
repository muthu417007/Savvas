import { LightningElement, api, track } from 'lwc';
import { filterDatarelatedProducts } from 'c/scc_filterSearchLwc'; // Import the filter helper function
import getUserInformation from '@salesforce/apex/scc_headerLWC_Controller.getUserInformation'; //added by Vaibhav for pricing connector
import productSimulation from '@salesforce/apex/ensxtx_CTRL_Cart.productSimulation'; //added by Vaibhav for pricing connector
import createIntegrationLogsLWC1 from '@salesforce/apex/scc_IntegrationLogs_Helper.createIntegrationLogsLWC1';

/*********************************************************
  Component Name       : scc_productCatalogTable
  Created Date         : 05/21/2024  
  Author               : Sudha Rani pathivada- Cognizant
  Description          : Nested component for scc_Catalog LWcsearch component  Holds the lightning-tree for all ProductCategories
  
  Modifications Log
  <Date>       <Author>            <Modification>
  
*********************************************************/

export default class scc_productCatalogTable extends LightningElement {
    @api columns;
    @track transformedChildTableData = [];
    @track rawChildTableData = [];
    filter = '';
    @track filteredData = [];// filter 
    @track totalFilteredRecords = 0;
    @track orginaldata = [];
    @track totalCount = 0;
    displayedRecords = 0;
    totalRecords = 0;
    pageSizeOptions = 15 //Page size options
    @track transformedDataLength = 0;
    // numberOfRows = '5';
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
    @track profileName='';
    @track logType = '';
    @track requestBody = '';
    @track responseBody = '';
    @track statusLog ='';
    @track internalStatus ='';

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
        //console.log(this.totalCount);
        // if (this.totalRecords === 0) {
        //     this.transformedChildTableData = [];
        //     this.updateTransformedDataLength();
        // }
        this.calculateTotalPages();
        //this.displayFirstPage();
    }

    connectedCallback() {
        this.getUserInfo();
    }


    //added by vaibhav for pricing connetcor starts
    getUserInfo() {
            getUserInformation().then(response => {
                console.log('response is', response);
                let paser = JSON.parse(response);
                console.log('parsed response is', paser);
                let data = paser[0];
                // console.log('account data', data);
                this.profileName = data.profile;
                this.accountId = data.accountId;
                this.country = data.billing_County;
                if (this.country == 'United States') {
                    this.salesOrg = '0002'
                }
                if (this.country == 'Canada') {
                    this.salesOrg = '0006'
                }
                // console.log('this.accountId user info', this.accountId);
            }).catch(error => {
                // console.log('error is', error);
            }).finally(() => {
                this.displayFirstPage();
            })
    }
    //added by vaibhav for pricing connetcor ends    

    calculateTotalPages() {
        if (this.filter) {
            if (this.filteredData.length <= this.pageSize) {
                this.totalPages = 1;
                this.showLoadNextButton = false;
            } else {
                // Adjust totalRecords to the length of filteredData
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
        
        // Update the displayed records count
        this.displayedRecords = this.transformedChildTableData.length;
            if (this.transformedChildTableData.length > 0 && this.transformedChildTableData.some(row => row.isInternalUser)) {
                console.log("-------Internal User Detected ------");
                this.priceLoaded = false;
                this.calculateDisplayPrice();
            }

            if (this.transformedChildTableData.length > 0 && this.profileName =='Savvas External Users Base Profile') {
                console.log("-------External User Detected ------");
                this.priceLoaded = false;
                this.getProductDetails();
            }
        }

    }

    //added by vaibhav for pricing connetcor starts
    getProductDetails() {
        this.priceLoaded = false;
        this.productInfoList1 = [];
        //console.log('this.productData is Vaibhav', this.transformedChildTableData);

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
        //console.log('this.productInfoList1 is Vaibhav', this.productInfoList1);

        let pdpInputParametersMap1 = {
            'Sales:SalesOrganization': this.salesOrg,
            'Header:ShippingConditions': 'DF'
        };
        let sfObjectIdMap = {};
        console.log('this.accountId', this.accountId);
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
                        console.log('productSimulation', data);
                        data = JSON.parse(JSON.stringify(data));
                        this.responseBody = JSON.stringify(data.TransactLogs);

                        // Initialize conditionTypeMap
                        // this.conditionTypeMap = {};

                        // // Iterate through ITEMS and populate conditionTypeMap
                        // data.ITEMS.forEach(item => {
                        //     this.conditionTypeMap[item.ProductId] = {
                        //         price: item.NetItemPrice,
                        //         conditionType: 'None',
                        //         discount: 'None'
                        //     };

                        //     for (let condition of item.SBOItemConditions) {
                        //         if (condition.ConditionType === 'ZNET') {
                        //             this.conditionTypeMap[item.ProductId].conditionType = 'ZNET';
                        //             this.conditionTypeMap[item.ProductId].discount = 'Net';
                        //             console.log(`Product ${item.ProductId} has ZNET condition with value:`, condition.ConditionValue);
                        //             break;
                        //         } else if (condition.ConditionType === 'ZCON') {
                        //             this.conditionTypeMap[item.ProductId].conditionType = 'ZCON';
                        //             this.conditionTypeMap[item.ProductId].discount = 'Contract';
                        //             console.log(`Product ${item.ProductId} has ZCON condition with value:`, condition.ConditionValue);
                        //             break;
                        //         }
                        //     }
                        // });

                        // Update transformedChildTableData with Price and ConditionType
                        for (let i = 0; i < data.ITEMS.length; i++) {
                            for (let j = 0; j < this.transformedChildTableData.length; j++) {
                                if (!!this.transformedChildTableData[j]) {
                                    if (this.transformedChildTableData[j].productId == data.ITEMS[i].ProductId) {
                                        //this.transformedChildTableData[j].Price = data.ITEMS[i].NetItemPrice;
                                        this.transformedChildTableData[j].Price = data.ITEMS[i].SubTotal3;
                                        //this.transformedChildTableData[j].ConditionType = this.conditionTypeMap[data.ITEMS[i].ProductId].conditionType;
                                    }
                                }
                            }
                        }

                        this.priceLoaded = true;

                        // Update rawChildTableData with Price and ConditionType
                        for (let i = 0; i < data.ITEMS.length; i++) {
                            for (let j = (this.pageNumber - 1) * this.pageSize; j < this.pageNumber * this.pageSize; j++) {
                                if (!!this.rawChildTableData[j]) {
                                    if (this.rawChildTableData[j].productId == data.ITEMS[i].ProductId) {
                                        //this.rawChildTableData[j].Price = data.ITEMS[i].NetItemPrice;
                                        this.rawChildTableData[j].Price = data.ITEMS[i].SubTotal3;
                                        //this.rawChildTableData[j].ConditionType = this.conditionTypeMap[data.ITEMS[i].ProductId].conditionType;
                                    }
                                }
                            }
                        }

                        console.log('raw child data is', this.rawChildTableData);
                        console.log('after running get prod logic', this.transformedChildTableData);
                        this.logType ='Enosix Product Price Simulation';
                        this.requestBody =JSON.stringify(this.productInfoList1);
                        this.statusLog= 'Success';
                        this.internalStatus='';
                        this.createLogs(this.logType, this.requestBody, this.responseBody, this.statusLog, this.internalStatus,'scc_productCatalogTable/getProductDetails/productSimulation');

                    }).catch(error => {
                        console.log('error is', error);
                        this.logType ='Enosix Product Price Simulation';
                        this.requestBody =JSON.stringify(this.productInfoList1);
                        this.statusLog= 'Error';
                        this.internalStatus=JSON.stringify(error);
                        this.createLogs(this.logType, this.requestBody, this.responseBody, this.statusLog, this.internalStatus,'scc_productCatalogTable/getProductDetails/productSimulation');
                    });
            }
        } else {
            this.priceLoaded = true;
        }
    }

    //added by vaibhav for pricing connetcor ends



    calculateDisplayPrice() {
        const updatedChildTableData = this.transformedChildTableData.map(row => {
            console.log('Initial DisplayPrice:', row.DisplayPrice);
            console.log('Initial ListPrice:', row.ListPrice);
            console.log('Initial NetPrice:', row.NetPrice);
            console.log('UserStatus:', row.UserStatus);

            let updatedRow = { ...row };

            if (row.UserStatus === 'International') {
                if (row.ListPrice !== undefined && row.ListPrice !== null) {
                    updatedRow.Price = row.ListPrice;
                    console.log('Set DisplayPrice for International:', updatedRow.DisplayPrice);
                } else {
                    console.error('ListPrice is undefined or null for International user.');
                }
            } else if (row.UserStatus === 'Internal US User') {
                if (row.NetPrice !== undefined && row.NetPrice !== null) {
                    updatedRow.Price = row.NetPrice;
                    console.log('Set DisplayPrice for K12/School:', updatedRow.DisplayPrice);
                } else {
                    console.error('NetPrice is undefined or null for K12/School user.');
                }
            } else {
                console.log('UserStatus not International or K12/School:', row.DisplayPrice);
            }

            return updatedRow;
        });
        this.transformedChildTableData = updatedChildTableData;
        console.log('Updated transformedChildTableData:', this.transformedChildTableData);
        this.priceLoaded = true; // Ensure this is set to true after updating prices
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
    // handleRowAction(event) {
    //     const row = event.detail.row;
    //     console.log(row);
    //     const action = event.detail.action.name;
    //     if (action === 'viewRecords') {
    //         this.selectedProductRecord = row;
    //         const selectEvent = new CustomEvent('showproducttitlepage', {
    //             detail: {
    //                 parentSelectedProductRecord: this.selectedProductRecord,
    //             }
    //         });
    //         this.dispatchEvent(selectEvent);
    //        // console.log('this.dispatchEvent: ', this.dispatchEvent);
    //     }
    //     if (action === 'infoPrice') {
    //         LightningAlert.open({
    //             // message: row.ISBN + ' -- ' + row.Price,
    //             message: 'Title: ' + row.Title_Description + '      ' + '\nISBN: ' + row.ISBN + '\nPrice: ' + row.Price,
    //             label: 'View Price', // this is the header text
    //             theme: 'gray-ish blue',
    //         }).then((result) => {
    //         });
    //     }
    // }

    //  handleRowAction(event) {
    //   event.preventDefault();  
    // let rowId = event.target.dataset.rowId;
    // // let EnosixPrice = event.target.dataset.Price;
    // //console.log('Row ID:', EnosixPrice);
    //  this.local_productQuantityData = this.transformedChildTableData;
    //   console.log('Row transformedChildTableData:', this.transformedChildTableData);
    //  let rowIndex = this.local_productQuantityData.findIndex(element => element.productId === rowId);
    //   console.log('Row transformedChildTableData:', this.transformedChildTableData);
    //   console.log('Row transformedChildTableData:', rowIndex);
    //     let rowInfo = this.local_productQuantityData[rowIndex];
    //   //  rowInfo.Price=EnosixPrice;
    //      console.log('Row transformedChildTableData:', rowInfo);
    //     const selectEvent = new CustomEvent('showproducttitlepage', {
    //         detail: {
    //             parentSelectedProductRecord: rowInfo,
    //               displayedRecords: this.displayedRecords
    //         }
    //     });
    //     console.log(rowInfo, 'rowInfo.productDetails');
    //     this.dispatchEvent(selectEvent);
    //      console.log(this.dispatchEvent(selectEvent), 'this.dispatchEvent(selectEvent);');
    // }



    handleRowAction(event) {
        event.preventDefault();
        let rowId = event.target.dataset.rowId;
        this.local_productQuantityData = [...this.transformedChildTableData];  // Make a shallow copy of the array
        console.log('local_productQuantityData:', JSON.stringify(this.local_productQuantityData));
        let rowIndex = this.local_productQuantityData.findIndex(element => element.productId === rowId);
        console.log('Row Index:', rowIndex);
        if (rowIndex !== -1) {
            // let rowInfo = this.local_productQuantityData[rowIndex];
              let rowInfo = { ...this.local_productQuantityData[rowIndex] };
            console.log('Row Info before price adjustment:', JSON.stringify(rowInfo));
            // Check for missing properties
            if (!rowInfo.UserStatus) {
                console.error('UserStatus is missing in rowInfo:', JSON.stringify(rowInfo));
            }

            if (!rowInfo.NetPrice) {
                console.error('NetPrice is missing in rowInfo:', JSON.stringify(rowInfo));
            }

            // Adjust Price based on Internal User 
            if (rowInfo.isInternalUser) {
                if (rowInfo.UserStatus === 'International') {
                    rowInfo.Price = rowInfo.ListPrice;
                } else if (rowInfo.UserStatus === 'Internal US User') {
                    rowInfo.Price = rowInfo.NetPrice;
                } else {
                    rowInfo.Price = "NA";
                }
            } else {
                // If the user is not internal, add logic here adjust logic for other usertype
                rowInfo.Price = rowInfo.Price ;
            }

            console.log('Row Info after price adjustment:', JSON.stringify(rowInfo));

            const selectEvent = new CustomEvent('showproducttitlepage', {
                detail: {
                    parentSelectedProductRecord: rowInfo,
                    displayedRecords: this.displayedRecords
                }
            });

            console.log('hi Dispatching', JSON.stringify(rowInfo));
            console.log('Dispatching Event with Data:', rowInfo);
            this.dispatchEvent(selectEvent);
            console.log('Event Dispatched:', selectEvent);
        } else {
            console.error('Row Index is invalid');
        }
    }




    handleLoadNext() {
    const startIndex = this.pageSize * this.currentPage;
    const endIndex = Math.min(startIndex + this.pageSize, this.totalRecords);
    const nextRecords = this.rawChildTableData.slice(startIndex, endIndex);
    this.transformedChildTableData = [...this.transformedChildTableData, ...nextRecords];
    this.currentPage++;
    this.displayedRecords = this.transformedChildTableData.length; // Update displayed records count
    this.showLoadNextButton = this.displayedRecords < this.totalRecords;
    this.updateTransformedDataLength();

    if (this.transformedChildTableData.length > 0 && this.profileName =='Savvas External Users Base Profile') {
        console.log("-------External User Detected ------");
        this.priceLoaded = false;
        this.getProductDetails();
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
            displayedRecords: this.displayedRecords // Add this line
        }
    });
    this.dispatchEvent(event);
}
    notifysearchresultsavailable() {
        // Dispatch the event to notify parent component
        const event = new CustomEvent('searchresultsavailable');
        this.dispatchEvent(event);
    }
    /*filter search functionality*/
    handleFilter(event) {
        console.log('enter oniput');
        const searchTerm = event.target.value.trim();
        this.filterSearchValue = event.target.value;
        this.filter = searchTerm;
        console.log('filtervalue', this.filter);
        console.log('siltersearch value', this.filterSearchValue);
        if (!searchTerm || searchTerm.length < 3 && !/^\d{3,}$/.test(searchTerm)) {
            this.filter = '';
            console.log('this.filter-handlefilter', this.filter);
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
            console.log('this.filter-handlefilter from else', this.filter);
            this.handleFilterChange();
        }
    }
    clearFilterInput(event) {
          if(this.filterSearchValue == '' || this.filterSearchValue == null){
        // console.log('filterSearchValue '+this.filterSearchValue)
        this.filterSearchValue = '';
        this.filter = '';
          }
          else{
             this.filterSearchValue = '';
        this.filter = '';
        
        this.filteredData = [];
        this.totalCount = this.orginaldata.length
        this.rawChildTableData = this.orginaldata;
        this.calculateTotalPages();
        this.displayFirstPage();
        //this.pageNumber = 1; // Reset page number to 1 after removing filter
        //this.totalPages = Math.ceil(this.totalRecords / this.pageSize);
        this.updateTransformedDataLength();
        // this.paginationHelper();
          }
    }
    handleFilterChange() {

        console.log('calling change handler', this.filter);
        if (this.filter != '') {
            const lowerCaseFilter = this.filter.toLowerCase();
            this.filteredData = filterDatarelatedProducts(this.orginaldata, lowerCaseFilter);
            console.log('original data,', this.rawChildTableData)
            this.totalCount = this.filteredData.length; // Update totalFilteredRecords property
            this.rawChildTableData = this.filteredData;
            this.updateTransformedDataLength();
            console.log('original data,', this.rawChildTableData)
            //this.pageNumber = 1;
            //this.totalPages = Math.ceil(this.totalFilteredRecords / this.pageSize)
            //this.paginationHelper();
            this.calculateTotalPages();
            this.displayFirstPage();
        }
        else {
            this.filteredData = [];
            this.rawChildTableData = this.orginaldata;
            //this.pageNumber = 1; // Reset page number to 1 after removing filter
            //this.totalPages = Math.ceil(this.totalRecords / this.pageSize);
            this.updateTransformedDataLength();
            this.totalCount = this.orginaldata.length
            //this.paginationHelper();
            this.calculateTotalPages();
            this.displayFirstPage();
        }
    }

    createLogs(logType, requestBody, responseBody, statusLog, internalStatus,entryPoint) {
        createIntegrationLogsLWC1({ logType: logType, requestBody: requestBody, responseBody: responseBody, status: statusLog, internalStatus: internalStatus,entryPoint:entryPoint})
        .then(result => {
            console.log('result is', result);
        })
        .catch(error => {
            console.log('error is', error);
        })
    } 
}