import { LightningElement, track, api } from 'lwc';
import { RefreshEvent } from 'lightning/refresh';
import { placeorderFilterData } from 'c/scc_filterResults'; // Import the filter helper function
import productSimulation from '@salesforce/apex/ensxtx_CTRL_Cart.productSimulation'; //added by Vaibhav for pricing connector
import getUserInformation  from '@salesforce/apex/scc_headerLWC_Controller.getUserInformation'; //added by Vaibhav for pricing connector
export default class scc_customTable extends LightningElement {

    @track transformedChildTableData = [];
    @track transformedChildTableData2 = [];
    @track rawChildTableData = [];
    @track productDetails;
// filter 
     _filter = '';
    @track filteredData = [];
    @track totalFilteredRecords = 0;
    @track orginaldata =[];
//pagnation
    totalRecords = 0;
    pageSizeOptions = [15, 25, 50, 75, 100];
    pageNumber = 1; //Page number 
    numberOfRows = '15';
    totalPages;
    displayedRecords=0;

    @track selectedProducts = new Map();
    @track totalQuantity;
   
    @track addToCartFunction = false;
    @track itemsList = [];
    @track callAddItemToCart = false ;
    @track setQuantity = [];
    @track local_productQuantityData = [];

    //added by Vaibhav for pricing connector starts
    @track priceLoaded = false;
    @track productInfoList1=[];
    @track accountId;
    @track country;
    @track salesOrg;
    @api userselection=[];
    @track userInputs=[];
    @track applyRestrictions = true;
    // @track activeCartId;
    
    // @api 
    // get checkActiveId(){
    //     return this.activeCartId;
    // }
    // set checkActiveId(value){
    //     this.activeCartId = value;
    // }
    

    connectedCallback() {
        console.log('the user selected input',this.userselection);
        this.userInputs=this.userselection;
       // this.restrictionCheck=this.userselection[0].oneTimeShip;
         //console.log('the user selected input in custom tabel',this.userInputs);

    }

   

// getRowClass(product) {
//     console.log('rowlock');
//         console.log('res',this.applyRestrictions);
//         console.log('product.SalesRestriction',product.productDetails.SalesRestriction,'ccc',product);
//         return this.applyRestrictions && product.productDetails.SalesRestriction === '07' ? 'restricted-row' : '';
//     }

    shouldShowLockIcon(product) {
           console.log('rowlock2');
            console.log('product.SalesRestriction',product.productDetails.SalesRestriction);
        return this.applyRestrictions && product.productDetails.SalesRestriction === '07';
    }

    get transformedChildTableData1(){
        this.transformedChildTableData2 =this.transformedChildTableData.map(product => ({
                ...product,
                //rowClass: this.getRowClass(product),
                showLockIcon: this.shouldShowLockIcon(product)
            }));

        return this.transformedChildTableData2;
    }
    get isQuantityDisabled() {
        return !this.priceLoaded;
    }

    getUserInfo(){
        getUserInformation().then(response =>{
            console.log('response is',response);
            let paser = JSON.parse(response);
            let data = paser[0];
            console.log('account data',data);
            this.accountId = data.accountId;
            this.country = data.billing_County;
            if(this.country=='United States'){
                this.salesOrg = '0002'
            }
            if(this.country=='Canada'){
                this.salesOrg = '0006'
            }
            console.log('this.accountId user info',this.accountId);
        }).catch(error =>{
            console.log('error is',error);
            this.isLoading=false;
        }).finally(()=>{
            this.paginationHelper();
        })
    }
    //added by Vaibhav for pricing connector ends

    
    
    @api 
    get addSelectedToCart(){
        console.log('data for addselected to cart', this.currentaddSelectedToCart);
        return this.currentSelectData;
    }
   set addSelectedToCart(value){
       console.log('data for set addtocart', value);
        this.addToCartFunction = value;
        if (this.addToCartFunction ==true){
             console.log('the values in the new map is',this.selectedProducts);
                this.itemsList = [];
        this.clearCartItems = false;
        this.selectedProducts.forEach((value, key) => {
            this.itemsList.push({
                id: key,
                Product2Id: value.Product2Id,
                Quantity: value.Quantity,
                SalesPrice: value.SalesPrice,
                Name: value.Name
            });
        });
        console.log('items in the list is', this.itemsList); 
         this.callAddItemToCart = true;
       

        
   }}

    handleReviewCartCount(event) {
        console.log('Im in the handle review cart count scc_customTabel');
        const customEvent = new CustomEvent('reveiewcartcount');
          this.dispatchEvent(customEvent);
           this.transformedChildTableData = this.transformedChildTableData.map(product =>({ ...product, quantity:0}));
           this.local_productQuantityData = [];
           this.selectedProducts = new Map();
           this.dispatchEvent(new RefreshEvent());
    }

    @api
    get rawParentTableData() {
        console.log('get', this.currentTableData);
        return this.currentTableData;
    }
    set rawParentTableData(value) {
        console.log('set', value);
        this.rawChildTableData = value;
        console.log( this.rawChildTableData);
        this.orginaldata = value;// filter
        this.totalRecords = this.rawChildTableData.length;
        this.totalCount = this.rawChildTableData.length;
        if (this.totalRecords === 0) {
            this.transformedChildTableData = [];
            this.updateTransformedDataLength();
        }
        this.pageSize = this.pageSizeOptions[0];
       // this.paginationHelper();
       this.getUserInfo();
    }

    //get filter search value sprint 4 workitem 

     @api
    get filter() {
        return this._filter;
    }

    set filter(value) {
        this._filter = value;
        this.handleFilterChange();
    }

    onHandleSort(event) {
        console.log('onHandleSort :: ', event.detail);
        this.sortedBy = event.detail.fieldName;
        this.sortDirection = event.detail.sortDirection;
        this.sortData(this.sortedBy, this.sortDirection);
    }
    sortData(fieldname, direction) {
        console.log('sortData :: ', fieldname, direction);
        let parseData = JSON.parse(JSON.stringify(this.currentPagetableData));
        let keyValue = (element) => {
            return element[fieldname];
        };
        let isReverse = direction === 'asc' ? 1 : -1;
        parseData.sort((xElement, yElement) => {
            xElement = keyValue(xElement) ? keyValue(xElement) : '';
            yElement = keyValue(yElement) ? keyValue(yElement) : '';
            return isReverse * ((xElement > yElement) - (yElement > xElement));
        });
        this.currentPagetableData = parseData;
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
    get bDisableFirst() {
        return this.pageNumber == 1;
    }
    get bDisableLast() {
        return this.pageNumber == this.totalPages;
    }

    paginationHelper() {
    console.log('Clicked paginationHelper: ');
    try {
    this.transformedChildTableData = [];
    // Calculate total pages
    if (this.filteredData.length > 0) {
        this.totalPages = Math.ceil(this.filteredData.length / this.pageSize);
    } else {
        this.totalPages = Math.ceil(this.totalRecords / this.pageSize);
    }

    // Ensure pageNumber is within valid range
    if (this.pageNumber <= 1) {
        this.pageNumber = 1;
    } else if (this.pageNumber > this.totalPages) {
        this.pageNumber = this.totalPages;
    }

    // Determine start and end indices for the current page
    const startIndex = (this.pageNumber - 1) * this.pageSize;
    const endIndex = Math.min(startIndex + this.pageSize, this.rawChildTableData.length); // Adjust endIndex calculation

    // Populate transformedChildTableData for the current page
    for (let i = startIndex; i < endIndex; i++) {
        const item = this.rawChildTableData[i];
        console.log('the values in transformedChildTableData ', item);
        this.transformedChildTableData.push(item);
        this.displayedRecords = this.transformedChildTableData.length;
        // let currentRecordId =item.productDetails.productId;
        // let customName = item.productDetails.ISBN;
        // let customPrice = item.productDetails.Price;
        // let rowValue =item.quantity;
        // if(rowValue > 0){
        //  this.addProductsToCart(currentRecordId, rowValue, customPrice, customName);
        // }
    }

    //added by vaibhav for pricing connetcor starts
    console.log('this.this.transformedChildTableData',this.transformedChildTableData);
    if(this.transformedChildTableData.length >0){
        this.getProductDetails();
    }
    //added by vaibhav for pricing connetcor ends
    this.updateTransformedDataLength();
    }
    catch(err) {
        console.log('error is',err);
    }
}

        //added by vaibhav for pricing connetcor starts
    getProductDetails() {
        this.priceLoaded = false;
        this.productInfoList1 =[];
        //console.log('this.productData is Vaibhav',this.transformedChildTableData);
        this.transformedChildTableData = JSON.parse(JSON.stringify(this.transformedChildTableData));
        for(let i=0;i<this.transformedChildTableData.length;i++){
            if(!!this.transformedChildTableData[i]){
                // this.productInfoList1.push(JSON.stringify({prodId:this.transformedChildTableData[i].productId,quantity:1}))
                //this.transformedChildTableData = JSON.parse(JSON.stringify(this.transformedChildTableData));
                console.log('this.productData productID  Vaibhav',this.transformedChildTableData[i].productId);
                console.log('this.productData ID  Vaibhav',this.transformedChildTableData[i].Id);
                console.log('this.productData data  Vaibhav',this.transformedChildTableData[i]);
                if(this.transformedChildTableData[i].productDetails.Price ==undefined || this.transformedChildTableData[i].productDetails.Price == 'NA'){
                    if(this.transformedChildTableData[i].productId != undefined && this.transformedChildTableData[i].productId !=null){
                        // if(this.transformedChildTableData[i].IsActive==true){
                            this.productInfoList1.push(JSON.stringify({prodId:this.transformedChildTableData[i].productId,quantity:1}));
                        // }
                    }
                } 
            }  
        }
        console.log('this.productInfoList1 is Vaibhav',this.productInfoList1);

        // let pdpInputParametersMap1 = {
        //     'Sales:SalesOrganization': '0002',
        //     'Header:ShippingConditions': 'DF'
        // }
        let pdpInputParametersMap1 = {
            'Sales:SalesOrganization': this.salesOrg,
            'Header:ShippingConditions': 'DF'
        }
        let sfObjectIdMap = {};
        // sfObjectIdMap.Account = '0015300000U1p4NAAR';
        // this.accountId = '0015300000U1p4NAAR';
        // console.log('this.accountId',this.accountId);
        sfObjectIdMap.Account = this.accountId;
        // this.productInfoList1 = JSON.stringify(this.productInfoList1);
        // console.log('check prod>:>:' + JSON.stringify(productInfoList));        // this.productInfoList1 = [JSON.stringify({prodId: '01td0000003UFRoAAO', quantity: 1}),
        //                          JSON.stringify({prodId: '01td0000003UFSyAAO', quantity: 1}),
        //                          JSON.stringify({prodId: '01td0000003UHkiAAG', quantity: 1}),
        //                          JSON.stringify({prodId: '01td0000003VUhrAAG', quantity: 1})
        //                         ];
        if(this.productInfoList1.length>0){
        if(this.accountId !=undefined){
            productSimulation({ productInfoList: this.productInfoList1, sfObjectIdMap: sfObjectIdMap, pdpAppSettingsName: 'ensxtx_SR_enosixCartPDPAppSettings', appSettingsName: 'ensxtx_SR_enosixProductB2BAppSettings', pdpInputParametersMap: pdpInputParametersMap1 })
            .then(({ data, messages }) => {
                console.log('productSimulation', data);
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
                                    this.transformedChildTableData[j].productDetails.Price = data.ITEMS[i].NetItemPrice;
                                     let currentRecordId = this.transformedChildTableData[j].productDetails.productId;
                                let customName = this.transformedChildTableData[j].productDetails.ISBN;
                                let customPrice = this.transformedChildTableData[j].productDetails.Price;
                                let rowValue = this.transformedChildTableData[j].quantity;
                                console.log('currentRecordId:', currentRecordId);
                                console.log('customName:', customName);
                                console.log('customPrice:', customPrice);
                                console.log('rowValue:', rowValue);
                                if(rowValue > 0) {
                                    console.log('Adding product to cart:', { currentRecordId, rowValue, customPrice, customName });
                                    this.addProductsToCart(currentRecordId, rowValue, customPrice, customName);
                                }
                                }
                            }
                        }
                    }
                    this.priceLoaded = true;
                    this.rawChildTableData = JSON.parse(JSON.stringify(this.rawChildTableData));
                    for(let i=0;i<data.ITEMS.length;i++){
                        for(let j = (this.pageNumber - 1) * this.pageSize; j < this.pageNumber * this.pageSize; j++){
                            if(!!this.rawChildTableData[j]){
                                if(this.rawChildTableData[j].productId == data.ITEMS[i].ProductId){
                                    // console.log('data.ITEMS[i].ProductId',data.ITEMS[i].NetItemPrice);
                                    this.rawChildTableData[j].productDetails.Price = data.ITEMS[i].NetItemPrice;
                                }
                            }
                        }
                    }
                    console.log('raw child data is',this.rawChildTableData);
                    console.log('after running get prod logic',this.transformedChildTableData);
                
            }).catch(error => {
                console.log('error is', error);
            })
        }
        }else{
            this.priceLoaded = true;
        }   
    }
    //added by vaibhav for pricing connetcor ends

    get bDisableLast() {
        return this.pageNumber == this.totalPages;
    }
    // Event handler for changing records per page removed from wire frame in sprint
    // handleRecordsPerPage(event) {
    //     this.pageSize = event.target.value;
    //     this.paginationHelper();
    // }
    handleCheckboxChange(event) {
        const rowId = event.target.dataset.rowId;
        const checked = event.target.checked;
        // Find the corresponding item in transformedChildTableData and update checkboxValue
        const updatedTransformedChildTableData = this.transformedChildTableData.map(item => {
            if (item.productDetails.productId === rowId) {
                item.checkboxValue = checked;
            }
            return item;
        });
        this.transformedChildTableData = updatedTransformedChildTableData;
    }

    handleRowAction(event) {
        // Handle button click action here
        const row = event.detail.row;
        const action = event.detail.action.name;
        if (action === 'infoPrice') {
            LightningAlert.open({
                // message: row.ISBN + ' -- ' + row.Price,
                message: 'Title: ' + row.Title_Description + '      ' + '\nISBN: ' + row.ISBN + '\nPrice: ' + row.Price,
                label: 'View Price', // this is the header text
                theme: 'gray-ish blue',
            }).then((result) => {
            });
        }
        if (action === 'viewRecords') {
            this.selectedProductRecord = row;
            const selectEvent = new CustomEvent('showproducttitlepage', {
                detail: {
                    parentSelectedProductRecord: this.selectedProductRecord,
                }
            });
            this.dispatchEvent(selectEvent);
        }
    }
handleFocus(event) {
    // Clear the input field if the value is 0
    if (event.target.value === '0') {
        event.target.value = '';
    }
}
tableRowAction(event) {
   // commented by sudha to validate qunatity feild 
    // if (fieldName == 'quantityCount') {
    //     let rowValue = event.target.value || 0;
    //     let rowIndex = this.local_productQuantityData.findIndex(element => element.productDetails.productId === rowId);
    //     let rowInfo = this.local_productQuantityData[rowIndex];
    //     rowInfo.quantity = rowValue;
    //     this.local_productQuantityData[rowIndex] = rowInfo;
    //     let currentRecordId = event.target.getAttribute('data-row-id');
    // //     let customName = event.target.getAttribute('data-attribute-name');
    //     let customPrice = 100 ;
    //     if (customPrice == undefined || customPrice == '' || customPrice == 'NA'){
    //          let customPrice = 0;
    //           this.addProductsToCart(currentRecordId, rowValue, customPrice, customName);
    //     }
    //     else{
    //     this.addProductsToCart(currentRecordId, rowValue, customPrice, customName);
    //     console.log('rowValue', rowValue,'rowIndex',rowIndex, '',rowInfo);
    //     }
    // }
    let fieldName = event.target.dataset.fieldName;
    console.log('Field Name:', fieldName);
    let rowId = event.target.dataset.rowId;
    console.log('Row ID:', rowId);

    this.local_productQuantityData = this.transformedChildTableData;

    if (fieldName === 'quantityCount') {
        console.log('Entering quantityCount condition');
        let rowValue = event.target.value.trim()
        console.log('Trimmed rowValue:', rowValue);

        if (isNaN(rowValue) || rowValue === '') {
            // If the value is not numeric, show an error message and set the value to zero
            rowValue = '0';
            event.target.value = rowValue;
            console.log('Non-numeric input converted to zero:', rowValue);
           
        }
            // Convert multiple zeros to a single zero
            if (/^0+$/.test(rowValue)) {
                rowValue = '0';
                event.target.value = rowValue;
                console.log('Multiple zeros converted to single zero:', rowValue);
            }
            // Check if the input value is zero or greater
            let rowIndex = this.local_productQuantityData.findIndex(element => element.productDetails.productId === rowId);
            let rowInfo = this.local_productQuantityData[rowIndex];
            console.log('Row Info before update:', rowInfo);

            // Update the quantity in the local product data
            rowInfo.quantity = rowValue;
            this.local_productQuantityData[rowIndex] = rowInfo;
            console.log('Updated Row Info:', this.local_productQuantityData[rowIndex]);

            let currentRecordId = event.target.getAttribute('data-row-id');
            let customName = event.target.getAttribute('data-attribute-name');
              let customPrice = event.target.getAttribute('data-attribute-Price');
        //     let customPrice = 100 ;
        // if (customPrice == undefined || customPrice == '' || customPrice == 'NA'){
        //      let customPrice = 0;
              this.addProductsToCart(currentRecordId, rowValue, customPrice, customName);
        // }
        // else{
        this.addProductsToCart(currentRecordId, rowValue, customPrice, customName);
        console.log('rowValue', rowValue,'rowIndex',rowIndex, '',rowInfo);
       // }
    }  
        
    if (fieldName == 'isbnId') {
        let rowIndex = this.local_productQuantityData.findIndex(element => element.productDetails.productId === rowId);
        let rowInfo = this.local_productQuantityData[rowIndex];
        const selectEvent = new CustomEvent('showproducttitlepage', {
            detail: {
                parentSelectedProductRecord: rowInfo.productDetails,
                  displayedRecords: this.displayedRecords
            }
        });
        console.log(rowInfo.productDetails, 'rowInfo.productDetails');
        this.dispatchEvent(selectEvent);
         console.log(this.dispatchEvent(selectEvent), 'this.dispatchEvent(selectEvent);');
    }
  // this.transformedChildTableData = Object.assign([], this.local_productQuantityData);
     console.log( this.transformedChildTableData, ' this.transformedChildTableData');
  }

    addProductsToCart(currentRecordId, rowValue, customPrice, customName) {
        console.log('im in the addproductstocart');
        this.callAddItemToCart = false;
        if (this.selectedProducts.has(currentRecordId)) {
            console.log('im in the addproductstocartif');
            let existingItem = this.selectedProducts.get(currentRecordId);
            existingItem.Quantity = rowValue;
             existingItem.SalesPrice = customPrice;
            this.selectedProducts.set(currentRecordId, existingItem);
        } else {
            console.log('im in the addproductstocartelse');
            this.selectedProducts.set(currentRecordId, {

                Product2Id: currentRecordId,
                Quantity: rowValue,
                SalesPrice: customPrice,
                Name: customName
            });
        }
        this.updateTotalquantity();
        console.log('the values for add to cart', this.selectedProducts);
    }

    updateTotalquantity() {
        let sum = 0;
            this.selectedProducts.forEach((value, key) => {
            sum += parseInt(value.Quantity);
            console.log('the key and value is', value, 'and', key);
        });
        this.totalQuantity = sum;
         console.log('the total quanity', this.totalQuantity);
          const quantitychangeChangeEvent = new CustomEvent('quantitychange', {
            detail: this.totalQuantity            
        });        
        this.dispatchEvent(quantitychangeChangeEvent);
       
        console.log('the total quanity is', this.totalQuantity);

    }

  






// filter  sprint 4 Workitem 
        handleFilterChange() {               
        if (this._filter) {
            const lowerCaseFilter = this._filter.toLowerCase();
            this.filteredData = placeorderFilterData(this.orginaldata, lowerCaseFilter);
            this.totalFilteredRecords = this.filteredData.length; // Update totalFilteredRecords property   
            this.rawChildTableData = this.filteredData;
            this.pageNumber = 1;
            this.totalPages = Math.ceil(this.totalFilteredRecords / this.pageSize)                    
            this.paginationHelper();
            this.updateTransformedDataLength();           
        } else {
            this.filteredData = [];
            this.totalFilteredRecords = 0;      
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
updateTransformedDataLength() {
        this.transformedDataLength = this.transformedChildTableData.length;
        const event = new CustomEvent('transformeddatalength', {
            detail: {
                transformedDataLength: this.transformedDataLength,
                totalFilteredRecords: this.totalFilteredRecords,
                totalCount: this.totalCount
            }
        });
        this.dispatchEvent(event);
       // console.log('Event dispatched:', event);
    }
}