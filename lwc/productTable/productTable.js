import { LightningElement, api, track } from 'lwc';
import { filterDatarealtedProducts } from 'c/filterResults'; // Import the filter helper function
import productSimulation from '@salesforce/apex/ensxtx_CTRL_Cart.productSimulation';
export default class ProductTable extends LightningElement {
    @api columns;
    @track transformedChildTableData = [];
    @track rawChildTableData = [];
    filter = '';
    @track filteredData = [];// filter 
    @track totalFilteredRecords = 0;
    @track orginaldata = [];
    @track productInfoList1=[];
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

    get columns1(){
        if(this.priceLoaded == true){
            return [
                {label: 'ISBN',fieldName: 'ISBN',type: 'button',typeAttributes: { label: { fieldName: 'ISBN', type: 'text' }, name: 'viewRecords', target: '_blank', class: 'custom-button', variant: 'base' },sortable: true},
                { label: 'Title Description', fieldName: 'Title_Description', sortable: true, type: 'text' },
                { label: 'Type', fieldName: 'Type', type: 'text', sortable: true, wrapText: true },
                { label: 'Grade Level', fieldName: 'Grade_Level', type: 'text', sortable: true },
                { label: 'Copyright', fieldName: 'Copyright', type: 'text', sortable: true },
                { label: 'Status', fieldName: 'Status', type: 'text', sortable: true },
                { label: 'Price', fieldName: 'Price', type: 'text', sortable: 'true' }
            ];
        }else{
            return this.columns;
        }
    }
    //added by Vaibhav for pricing connector ends

    @api
    get rawParentTableData() {
        console.log('get', this.currentTableData);
        return this.currentTableData;
    }
    set rawParentTableData(value) {
        console.log('set', value);
        this.rawChildTableData = value;
        this.orginaldata = value;
        this.totalRecords = this.rawChildTableData.length;
        this.pageSize = this.pageSizeOptions[0];
        this.paginationHelper();
    }
    //***********Filter cleanuptkt********

    @api
    get filter() {
        return this._filter;
    }

    /**
* @param {any} value
*/
    set filter(value) {
        this._filter = value;
        this.handleFilterChange();
    }
    @api 
    get parentname() {
       return this._parentName; 
    }

    set parentname(value) {
         console.log('set', value);
        this._parentname  = value;
        this.message=value
        console.log(this._parentname,'valdmf' );
    }
    //******** //
    onHandleSort(event) {
        this.sortedBy = event.detail.fieldName;
        this.sortDirection = event.detail.sortDirection;
        this.sortData(this.sortedBy, this.sortDirection);
    }
    sortData(fieldname, direction) {
        console.log('sortData :: ', fieldname, direction);
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
    paginationHelper() {
        this.transformedChildTableData = [];
        if (this.filteredData.length > 0) {
            this.totalPages = Math.ceil(this.filteredData.length / this.pageSize);
            console.log('Clicked filtered: ', this.totalPages);
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
            console.log('this.rawChildTableData[i]',this.rawChildTableData[i]);
            if(!!this.rawChildTableData[i]){
                this.transformedChildTableData.push(this.rawChildTableData[i]);
            }
        }
        this.displayedRecords = this.transformedChildTableData.length;  
        //added by vaibhav for pricing connetcor
        if(this.transformedChildTableData.length !=0){
            this.getProductDetails();
        }
        //added by vaibhav for pricing connetcor
    }
    
    getProductDetails() {
        this.priceLoaded = false;
        //console.log('this.productData is Vaibhav',this.transformedChildTableData);
        this.transformedChildTableData = JSON.parse(JSON.stringify(this.transformedChildTableData));
        for(let i=0;i<this.transformedChildTableData.length;i++){
            if(!!this.transformedChildTableData[i]){
                // this.productInfoList1.push(JSON.stringify({prodId:this.transformedChildTableData[i].productId,quantity:1}))
                //this.transformedChildTableData = JSON.parse(JSON.stringify(this.transformedChildTableData));
                console.log('this.productData productID  Vaibhav',this.transformedChildTableData[i].productId);
                console.log('this.productData ID  Vaibhav',this.transformedChildTableData[i].Id);
                console.log('this.productData data  Vaibhav',this.transformedChildTableData[i]);
                if(this.transformedChildTableData[i].productId != undefined || this.transformedChildTableData[i].productId !=null){
                    this.productInfoList1.push(JSON.stringify({prodId:this.transformedChildTableData[i].productId,quantity:1}));
                }
                
            }  
        }
        console.log('this.productInfoList1 is Vaibhav',this.productInfoList1);

        let pdpInputParametersMap1 = {
            'Sales:SalesOrganization': '0002',
            'Header:ShippingConditions': 'DF'
        }
        let sfObjectIdMap = {};
        sfObjectIdMap.Account = '0015300000U1p4NAAR';
        // this.productInfoList1 = JSON.stringify(this.productInfoList1);
        // console.log('check prod>:>:' + JSON.stringify(productInfoList));
        productSimulation({ productInfoList: this.productInfoList1, sfObjectIdMap: sfObjectIdMap, pdpAppSettingsName: 'ensxtx_SR_enosixCartPDPAppSettings', appSettingsName: 'ensxtx_SR_enosixProductB2BAppSettings', pdpInputParametersMap: pdpInputParametersMap1 })
            .then(({ data, messages }) => {
                //console.log('productSimulation', data);
                //console.log('Check data:>:>' + JSON.stringify(data));
                // console.log('data.ITEMS[i].ProductId',data.ITEMS[0].NetItemPrice);
                // if (data) {
                   data = JSON.parse(JSON.stringify(data));
                   this.transformedChildTableData = JSON.parse(JSON.stringify(this.transformedChildTableData));
                    for(let i=0;i<data.ITEMS.length;i++){
                        // console.log('data.ITEMS[i].ProductId',data.ITEMS[i].NetItemPrice);
                        for(let j=0;j<this.transformedChildTableData.length;j++){
                            // console.log('data.ITEMS[i].ProductId',data.ITEMS[i].NetItemPrice);
                            // console.log('this.transformedChildTableData[j].productId',this.transformedChildTableData[j].productId);
                            if(!!this.transformedChildTableData[j]){
                                if(this.transformedChildTableData[j].productId == data.ITEMS[i].ProductId){
                                    // console.log('data.ITEMS[i].ProductId',data.ITEMS[i].NetItemPrice);
                                    this.transformedChildTableData[j].Price = data.ITEMS[i].NetItemPrice;
                                }
                            }
                        }
                    }
                    this.priceLoaded = true;
                    console.log('after running get prod logic',this.transformedChildTableData);
                // } else {
                //     console.log('pricing simulation Error Occured>::>', messages);
                // }
            }).catch(error => {
                console.log('error is', error);
            })
            
    }

    handleRowAction(event) {
        const row = event.detail.row;
        const action = event.detail.action.name;
        console.log('Clicked row: ', row, action);

        if (action === 'viewRecords') {
            this.selectedProductRecord = row;

            const selectEvent = new CustomEvent('showproducttitlepage', {
                detail: {
                    parentSelectedProductRecord: this.selectedProductRecord,
                }
            });
            this.dispatchEvent(selectEvent);
            console.log('this.dispatchEvent: ', this.dispatchEvent);
        }
        if (action === 'infoPrice') {
            LightningAlert.open({
                // message: row.ISBN + ' -- ' + row.Price,
                message: 'Title: ' + row.Title_Description + '      ' + '\nISBN: ' + row.ISBN + '\nPrice: ' + row.Price,
                label: 'View Price', // this is the header text
                theme: 'gray-ish blue',
            }).then((result) => {
            });
        }
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

//************* filter cleanuptkts  */
    handleFilterChange() {
        if (this._filter) {
            const lowerCaseFilter = this._filter.toLowerCase();
            this.filteredData = filterDatarealtedProducts(this.orginaldata, lowerCaseFilter);
            console.log('original data,',this.rawChildTableData)
            this.totalFilteredRecords = this.filteredData.length; // Update totalFilteredRecords property
            this.rawChildTableData = this.filteredData;
            console.log('original data,',this.rawChildTableData)
            this.pageNumber = 1;
            this.totalPages = Math.ceil(this.totalFilteredRecords / this.pageSize)
            this.paginationHelper();
        } else {
            this.filteredData = [];
            this.totalFilteredRecords = 0;
            this.rawChildTableData = this.orginaldata;
            this.pageNumber = 1; // Reset page number to 1 after removing filter
            this.totalPages = Math.ceil(this.totalRecords / this.pageSize);
            this.paginationHelper();
        }
    }
    taskTypeHelpTextClass = 'slds-popover slds-popover_tooltip slds-nubbin_bottom-right slds-fall-into-ground slds-hide';
    togglePasswordHint() {
        let hideCss = 'slds-popover slds-popover_tooltip slds-nubbin_bottom-right slds-fall-into-ground slds-hide';
        let showCss = 'slds-popover slds-popover_tooltip slds-nubbin_bottom-right slds-rise-from-ground';
        this.taskTypeHelpTextClass = this.taskTypeHelpTextClass == hideCss ? showCss : hideCss;
    }
}