import { LightningElement, track, api, wire } from 'lwc';
import { RefreshEvent } from 'lightning/refresh';
import { placeorderFilterData } from 'c/scc_filterResults'; // Import the filter helper function
import productSimulation from '@salesforce/apex/ensxtx_CTRL_Cart.productSimulation'; //added by Vaibhav for pricing connector
import getUserInformation  from '@salesforce/apex/scc_headerLWC_Controller.getUserInformation'; //added by Vaibhav for pricing connector
import IsEusageOnly from '@salesforce/apex/scc_confirmAddress.IsEusageOnly';
import createIntegrationLogsLWC1 from '@salesforce/apex/scc_IntegrationLogs_Helper.createIntegrationLogsLWC1';
import getEnableConsoleLogsTrue from '@salesforce/apex/scc_headerLWC_Controller.getEnableConsoleLogsTrue' ;
// added by sudha 
import scc_inactive from "@salesforce/label/c.scc_inactive";
import scc_BothRestrictions from "@salesforce/label/c.scc_BothRestrictions";
import scc_rightRestriction from "@salesforce/label/c.scc_rightRestriction";
import scc_salesRestriction from "@salesforce/label/c.scc_salesRestriction";
import scc_hfcRestriction from "@salesforce/label/c.scc_hfcRestriction";
import scc_unavailable from "@salesforce/label/c.scc_unavailable";
import getUserBillingAddress from '@salesforce/apex/scc_confirmAddress.getUserBillingAddress';
import getUserShippingAddress from '@salesforce/apex/scc_confirmAddress.getUserShippingAddress';

 //W-016452 Inactive Icon -->

export default class scc_customTable extends LightningElement {
    // added by sudha 
labels={
    scc_inactive,
    scc_BothRestrictions,
    scc_rightRestriction,
    scc_salesRestriction,
    scc_hfcRestriction,
    scc_unavailable
}
    @track transformedChildTableData = [];
    @track rawChildTableData = [];
    @track productDetails;
    @track IsEusage = false;
    @track shippingState;
// filter 
    @track _filter = '';
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
    @api userselection;
    @track userInputs=[];
    @track conditionTypeMap = {};
    @track applyRestrictions = false;
   
    @track activeCartId;
    @api currenttabselect;
    @track currenttabtable;
    @api userinputmulti;
    @track showWarningMessage = false;
    @track logType = '';
    @track requestBody = '';
    @track responseBody = '';
    @track statusLog ='';
    @track internalStatus ='';
    @track billingState='';
    @track shippingCountry ='';
    @track billingCountry ='';
    @track enableLogs = false;
    @api
    get checkActiveId(){
        return this.activeCartId;
    }
    set checkActiveId(value){
        this.activeCartId = value;
        if(this.enableLogs){
        console.log( 'this.activeCartId'+ this.activeCartId);
        }
    }
    

connectedCallback() {
    getEnableConsoleLogsTrue().then(response => {
        this.enableLogs = response;
    }).catch(error => {
        if(this.enableLogs){
            console.log('error is', error);
        }
    });
    
    this.userInputs = this.userselection;
    if(this.userInputs[0].guestCartId){
        this.activeCartId = this.userInputs[0].guestCartId;
    }
    this.showNationalAndStateFilter = this.defaultNationalStateFilter || false;
    if (!this.showNationalAndStateFilter) {
        this.rawChildTableData = [...this.orginaldata];
    }
    
    this.getUserInfo();       
    this.template.addEventListener('keydown', this.handleKeydown.bind(this));
}

    disconnectedCallback() {        
        this.template.removeEventListener('keydown', this.handleKeydown);
    }
     handleKeydown(event) {
        // Handle the keydown event
        if (event.key === 'Escape') {            
            if(this.showWarningMessage){
                this.closeCartModal();
            }
            
        }
    }



    shouldShowLockIcon(product) {
        if(this.userInputs[0].schoolDistrict == false){
            this.applyRestrictions = true;
        }
        if(this.userInputs[0].oneTimeShip == true){
            this.applyRestrictions = true;
        }           
        return this.applyRestrictions && product.productDetails.SalesRestriction === '07';
    }
    @wire(IsEusageOnly)
    EusageOnly({ error, data }) {
        if (data) { 
            if(this.enableLogs){
            console.log('data from IsEusageOnly ',data);
            }
            this.IsEusage= data;            
        } else if (error) {            
            this.error = error;

        }

    }


     evaluateRestrictions(product) {
         if(this.userInputs[0]. billCountry !== undefined && this.userInputs[0]. billCountry !== ''){
              this.billingCountry = this.userInputs[0]. billCountry.toLowerCase(); 
         }else{
              this.billingCountry = '';
         }
         if(this.userInputs[0]. shipCountry !== undefined && this.userInputs[0]. shipCountry !== ''){
              this.shippingCountry = this.userInputs[0]. shipCountry.toLowerCase(); 
         }else{
              this.shippingCountry = '';
         }
           if(this.userInputs[0]. billState !== undefined && this.userInputs[0]. billState !== ''){
              this.billingState = this.userInputs[0]. billState.toUpperCase(); 
         }else{
              this.billingState = '';
         }
       
   
                   
            switch (product.productDetails.RightsRestriction) {
                
                case '01':
                    
                    if ( this.billingCountry !== 'canada') return true;
                    break;
              
                case '02':
                     
                    if ( this.billingCountry === 'united states') return true;
                    break;
                case '03':
                      
                    if ( this.billingCountry === 'canada') return true;
                    break;
                case '04':                     

                    if (this.billingCountry !== 'united states') return true;
                    break;
                case '05':
                      
                    if ( this.billingCountry !== 'united states') return true;
                    break;
                case '06':
                      
                    if ( this.billingCountry !== 'canada' && this.billingCountry !== 'united states' && !this.isUSTerritory(this.billingState)) return true;
                    break;
                case '08':
                    
                    if ( this.billingCountry !== 'united states' && !this.isUSTerritory(this.billingState)) return true;
                    break;
                case '09':
                    
                    return ! this.IsEusage;
                    
                default:
                  
                   return false;
            }
        

    }


    isUSTerritory(country) {
        const usTerritories = ['AS','GU','MP','PR','VI'];
        return usTerritories.includes(country);
    }



    get transformedChildTableData1(){
        this.transformedChildTableData2 =this.transformedChildTableData;
        return this.transformedChildTableData2;
    }
    get isQuantityDisabled() {
        return !this.priceLoaded;
    }

    restrictionMessage(salesRestriction,rightsRestriction,isProductActive,hfcRestriction) {
        if(this.enableLogs){
            console.log('salesRestriction',salesRestriction);
            console.log('rightsRestriction',rightsRestriction);
            console.log('hfcRestriction',hfcRestriction);
            console.log('isProductActive',isProductActive);
        }

        if (!isProductActive && salesRestriction && rightsRestriction && !hfcRestriction) {
            return scc_BothRestrictions;
        } else if (!isProductActive && salesRestriction && !hfcRestriction) {
            return scc_salesRestriction;
        } else if (!isProductActive && rightsRestriction && !hfcRestriction) {
            return scc_rightRestriction;
        } else if (salesRestriction && rightsRestriction && !hfcRestriction) {
            return scc_BothRestrictions;
        } else if (!isProductActive && !hfcRestriction) {
            return scc_inactive;
        } else if (salesRestriction && !hfcRestriction) {
            return scc_salesRestriction;
        } else if (rightsRestriction && !hfcRestriction) {
            return scc_rightRestriction;
        } else if(hfcRestriction){
            return this.labels.scc_hfcRestriction;
        }else {
            return ""; 
        }
    }

    evaluatehfcRestriction(product,conditionType){ 
        if(product.productDetails.Product_Status_ID =='HFC'){
            if(product.productDetails.Product_Status_ID =='HFC' && conditionType =='ZCON'){
                return false;
            }else{
                return true;
            }
        }else{
                return false;
        }
    }

getUserInfo() {
    if (this.userInputs[0].guestAccountId) {
        this.accountId = this.userInputs[0].guestAccountId;            
        this.country = this.userInputs[0].billCountry;

        if (this.country === 'United States') {
            this.salesOrg = '0002';
        }
        if (this.country === 'Canada') {
            this.salesOrg = '0006';
        }

        this.paginationHelper();

       
        if (this.orginaldata && this.orginaldata.length > 0) {
            this.applyNationalAndStateFilter();
        }
    } else {
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
            if (this.enableLogs){
                console.log('response is', userInfoResp);
            }
               
            this.accountId = data.accountId;
            this.country = data.billing_County;
            // Initialize a Set to collect all unique states
            let userStatesSet = new Set();

            // Add standard billing and shipping states
            if (data.billing_State) userStatesSet.add(data.billing_State.toUpperCase());
            if (data.shipping_State) userStatesSet.add(data.shipping_State.toUpperCase());

            // Add alternate billing states
            billingAddresses.forEach(addr => {
                if (addr.State) userStatesSet.add(addr.State.toUpperCase());
            });

            // Add alternate shipping states
            shippingAddresses.forEach(addr => {
                if (addr.Provionce) userStatesSet.add(addr.Provionce.toUpperCase());
            });

            // Set the user states
            this.userState = userStatesSet;

             if (this.enableLogs) {
            console.log('\n=== Final State Collection Summary ===');
            console.log('All collected states:', Array.from(this.userState));
            console.log('Total unique states:', this.userState.size);
        }

            // Determine sales organization
            if (this.country === 'United States') {
                this.salesOrg = '0002';
            } else if (this.country === 'Canada') {
                this.salesOrg = '0006';
            }
        }).catch(error => {
             if (this.enableLogs) console.error('Error fetching user information or addresses:', error);
        }).finally(() => {
            this.paginationHelper();
            if (this.orginaldata.length > 0) {
                this.applyNationalAndStateFilter();
            }
        });
    }
}


    //added by Vaibhav for pricing connector ends

    
    
    @api 
    get addSelectedToCart(){
        if(this.enableLogs){
        console.log('data for addselected to cart', this.currentaddSelectedToCart);
        }
        return this.currentSelectData;
    }
set addSelectedToCart(value) {
    if (this.enableLogs) {
        console.log('data for set addtocart', value);
    }

    if (value === true && this.selectedProducts.size > 0) {
        if (this.checkForOutOfStateProducts()) {
            this.showConfirmationModal = true;
            this.addToCartFunction = false;  
        } else {
            this.initiateAddToCartProcess();
        }
    } else {
        this.addToCartFunction = false;
    }
}

initiateAddToCartProcess() {
    this.addToCartFunction = true;
    this.itemsList = [];
    this.clearCartItems = false;
    this.selectedProducts.forEach((value, key) => {
        let conditionType = this.conditionTypeMap[key] ? this.conditionTypeMap[key].conditionType : 'None';
        this.itemsList.push({
            id: key,
            Product2Id: value.Product2Id,
            Quantity: value.Quantity,
            SalesPrice: value.SalesPrice,
            Name: value.Name,
            PriceCondition: conditionType
        });
    });        
    this.callAddItemToCart = true;
    this.addToCartFunction = false;
}

    handleReviewCartCount(event) {
        
          this.callAddItemToCart = false;
        const customEvent = new CustomEvent('reveiewcartcount');
          this.dispatchEvent(customEvent);
           this.transformedChildTableData = this.transformedChildTableData.map(product =>({ ...product, quantity:0}));
           this.local_productQuantityData = [];
           this.selectedProducts = new Map();
           this.dispatchEvent(new RefreshEvent());
    }
    handleresetaddtocart(event){
         this.callAddItemToCart = false;
        const customEvent = new CustomEvent('resetaddtocart');
          this.dispatchEvent(customEvent);
    }


    @api
    get rawParentTableData() {        
        return this.currentTableData;
    }
set rawParentTableData(value) {
    this.rawChildTableData = [...value];
    this.orginaldata = [...value]; 
    this.totalRecords = this.orginaldata.length;
    this.totalCount = this.orginaldata.length;
    this.pageSize = this.pageSizeOptions[0];

    if (this.showNationalAndStateFilter) {
        this.applyNationalAndStateFilter();
    } else {
        this.rawChildTableData = [...this.orginaldata];
        this.totalRecords = this.orginaldata.length;
        this.pageNumber = 1;
        this.totalPages = Math.ceil(this.totalRecords / this.pageSize);
        this.paginationHelper();
        this.updateTransformedDataLength();
    }
}

    onHandleSort(event) {
        if(this.enableLogs){
        console.log('onHandleSort :: ', event.detail);
        }
        this.sortedBy = event.detail.fieldName;
        this.sortDirection = event.detail.sortDirection;
        this.sortData(this.sortedBy, this.sortDirection);
    }
    sortData(fieldname, direction) {
        if(this.enableLogs){
        console.log('sortData :: ', fieldname, direction);
        }
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

    @track isDataLoaded = false;

paginationHelper() {
    if (this.enableLogs) {
        console.log('Clicked paginationHelper: ');
        console.log('rawChildTableData:', this.rawChildTableData);
    }
    try {
        this.transformedChildTableData = [];
        this.isDataLoaded = false; // Hide pagination during load

        // Calculate total pages based on the filtered data length
        this.totalPages = Math.ceil(this.rawChildTableData.length / this.pageSize);

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
            this.transformedChildTableData.push(item);
            this.displayedRecords = this.transformedChildTableData.length;
        }

        //added by vaibhav for pricing connetcor starts
        if (this.enableLogs) {
            console.log('this.this.transformedChildTableData', this.transformedChildTableData);
        }
        if (this.transformedChildTableData.length > 0) {
            this.getProductDetails();
        }
        //added by vaibhav for pricing connetcor ends
        this.isDataLoaded = true; // Mark data as fully loaded
        this.updateTransformedDataLength();
    } catch (err) {
         if (this.enableLogs) console.log('error is', err);
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

        //added by vaibhav for pricing connetcor starts
getProductDetails() {
    //const startTime = performance.now(); // Start tracking time    

    this.priceLoaded = false;
    this.productInfoList1 = [];
    this.transformedChildTableData = JSON.parse(JSON.stringify(this.transformedChildTableData));
    if(this.enableLogs){
    console.log('custom table transformedChildTableData', this.transformedChildTableData);
    }

    for (let i = 0; i < this.transformedChildTableData.length; i++) {
        if (!!this.transformedChildTableData[i]) {
            if (this.transformedChildTableData[i].productDetails.Price == undefined || this.transformedChildTableData[i].productDetails.Price == 'NA') {
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

    if (this.productInfoList1.length > 0) {
    if (this.accountId != undefined) {        
        
        const simulationStartTime = performance.now();
        const simulationStartDateTime = new Date();
        if(this.enableLogs){
        console.log(`Product simulation started on: ${simulationStartDateTime.toLocaleString()}`);
        }

        productSimulation({ 
            productInfoList: this.productInfoList1, 
            sfObjectIdMap: sfObjectIdMap, 
            pdpAppSettingsName: 'ensxtx_SR_enosixCartPDPAppSettings', 
            appSettingsName: 'ensxtx_SR_enosixProductB2BAppSettings', 
            pdpInputParametersMap: pdpInputParametersMap1 
        })
        .then(({ data, messages }) => {
            const simulationEndTime = performance.now();
            const simulationEndDateTime = new Date();
            const simulationDurationSeconds = (simulationEndTime - simulationStartTime) / 1000;
            if(this.enableLogs){
            console.log(`Product simulation completed on: ${simulationEndDateTime.toLocaleString()}`);
            console.log(`Time taken for product simulation: ${simulationDurationSeconds.toFixed(3)} seconds`);
            }
            this.conditionTypeMap = {};
            this.responseBody = JSON.stringify(data.TransactLogs);                
            data.ITEMS.forEach(item => {
                this.conditionTypeMap[item.ProductId] = {                    
                    price: this.formatPrice(item.SubTotal3),
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

                data = JSON.parse(JSON.stringify(data));
                this.transformedChildTableData = JSON.parse(JSON.stringify(this.transformedChildTableData));
                this.transformedChildTableData = this.transformedChildTableData.map(product => ({
                    ...product,
                    showLockIcon: this.shouldShowLockIcon(product),
                    showLock: this.evaluateRestrictions(product),
                    isInactive: !product.productDetails.IsActive ,//W-016452 Inactive Icon
                    makedisable: this.shouldShowLockIcon(product) || this.evaluateRestrictions(product) || !product.productDetails.IsActive || this.evaluatehfcRestriction(product,this.conditionTypeMap[product.productId].conditionType),
                    restrictionMessage:this.restrictionMessage(this.shouldShowLockIcon(product),this.evaluateRestrictions(product),product.productDetails.IsActive,this.evaluatehfcRestriction(product,this.conditionTypeMap[product.productId].conditionType))              
                }));

                for (let i = 0; i < data.ITEMS.length; i++) {
                    for (let j = 0; j < this.transformedChildTableData.length; j++) {
                        if (!!this.transformedChildTableData[j]) {
                            if (this.transformedChildTableData[j].productId == data.ITEMS[i].ProductId) {                                
                                this.transformedChildTableData[j].productDetails.Price = this.formatPrice(data.ITEMS[i].SubTotal3);
                                let currentRecordId = this.transformedChildTableData[j].productDetails.productId;
                                let customName = this.transformedChildTableData[j].productDetails.ISBN;
                                let customPrice = this.transformedChildTableData[j].productDetails.Price;
                                let rowValue = this.transformedChildTableData[j].quantity;
                                let conditionType = this.conditionTypeMap[currentRecordId].conditionType;
                                let disableQuantity = this.transformedChildTableData[j].makedisable;
                                

                                if(disableQuantity !== true && rowValue > 0){
                                    this.addProductsToCart(currentRecordId, rowValue, customPrice, customName, conditionType);
                                }
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
                                //this.rawChildTableData[j].productDetails.Price = data.ITEMS[i].NetItemPrice;
                                this.rawChildTableData[j].productDetails.Price = this.formatPrice(data.ITEMS[i].SubTotal3);

                            }
                        }
                    }
                }

                const renderTime = performance.now(); // Track time after rendering prices
                if(this.enableLogs){
                console.log(`Time to process and render price data: ${renderTime - dataReceivedTime}ms`);
                console.log(`Total time from start to price display: ${renderTime - startTime}ms`);
                }
                this.createLogs(this.logType, this.requestBody, this.responseBody, this.statusLog, this.internalStatus, 'scc_customTable/getProductDetails/productSimulation');
            })
            .catch(error => {
                console.log('error is', error);
                this.createLogs(this.logType, this.requestBody, this.responseBody, this.statusLog, this.internalStatus, 'scc_customTable/getProductDetails/productSimulation');
            });
        }
    } else {
        this.transformedChildTableData = this.transformedChildTableData.map(product => ({
            ...product,
            showLockIcon: this.shouldShowLockIcon(product),
            showLock: this.evaluateRestrictions(product),
            isInactive: !product.productDetails.IsActive ,//W-016452 Inactive Icon
            makedisable: this.shouldShowLockIcon(product) || this.evaluateRestrictions(product) || !product.productDetails.IsActive || this.evaluatehfcRestriction(product,product.productDetails.conditionType),
            restrictionMessage:this.restrictionMessage(this.shouldShowLockIcon(product),this.evaluateRestrictions(product),!product.productDetails.IsActive,this.evaluatehfcRestriction(product,product.productDetails.conditionType))              
        }));
        this.priceLoaded = true;
    }   
}


    //added by vaibhav for pricing connetcor ends


    get bDisableLast() {
        return this.pageNumber == this.totalPages;
    }
    
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
   
    if  ( event.target.value === '0') {
        event.target.value = '';
    }
    
}
//  To close the box
    closeCartModal() {
        this.showWarningMessage = false;
        const button = this.template.querySelectorAll(".quantity-field:not([disabled])")[0];
      if(button){
        setTimeout(() => {
          button.focus();
        }, 100);
      }
    }
//Cancel button action
    handleCancelBtn() {
        this.showWarningMessage = false;
         const button = this.template.querySelectorAll(".quantity-field:not([disabled])")[0];
      if(button){
        setTimeout(() => {
          button.focus();
        }, 100);
      }
    }
handleQuantity(){
    this.showWarningMessage = false;
}



tableRowAction(event) {
    let fieldName = event.target.dataset.fieldName;
    
    let rowId = event.target.dataset.rowId;    

    this.local_productQuantityData = this.transformedChildTableData;
    this.currenttabtable = this.currenttabselect;

    if (fieldName === 'quantityCount' ) {
       
     if(event.target.value > 1000){
        if(this.enableLogs){
        console.log('Warning',event.target.value);
        }
        this.showWarningMessage = true;
       }
      else{
          this.showWarningMessage = false;
      }
        
        let rowValue = event.target.value.trim() ;

        if (isNaN(rowValue) || rowValue === '') {
            // If the value is not numeric, show an error message and set the value to zero
            rowValue = '0';
            event.target.value = rowValue;            
        }
        // Convert multiple zeros to a single zero
        if (/^0+$/.test(rowValue)) {
            rowValue = '0';
           
            event.target.value = rowValue;            
        }
        else{
             rowValue = parseInt(rowValue, 10);
        }
        
       
        // Check if the input value is zero or greater
        let rowIndex = this.local_productQuantityData.findIndex(element => element.productDetails.productId === rowId);
        let rowInfo = this.local_productQuantityData[rowIndex];        

        // Update the quantity in the local product data
        rowInfo.quantity = rowValue;
        this.local_productQuantityData[rowIndex] = rowInfo;        

        let currentRecordId = event.target.getAttribute('data-row-id');
        let customName = event.target.getAttribute('data-attribute-name');
        let customPrice = event.target.getAttribute('data-attribute-Price');

        // Get the conditionType from the conditionTypeMap
        let conditionType = this.conditionTypeMap[currentRecordId] ? this.conditionTypeMap[currentRecordId].conditionType : 'None';        
        
        this.addProductsToCart(currentRecordId, rowValue, customPrice, customName, conditionType);        
    }

    if (fieldName == 'isbnId') {
        let rowIndex = this.local_productQuantityData.findIndex(element => element.productDetails.productId === rowId);
        let rowInfo = this.local_productQuantityData[rowIndex];
        const selectEvent = new CustomEvent('showproducttitlepage', {
            detail: {
                parentSelectedProductRecord: rowInfo.productDetails,
                displayedRecords: this.displayedRecords,
                currenttabtable:this.currenttabtable,
                userinputmulti:this.userinputmulti

            }
        });
        if(this.enableLogs){
        console.log(rowInfo.productDetails, 'rowInfo.productDetails');
        }
        this.dispatchEvent(selectEvent);
        if(this.enableLogs){
        console.log(this.dispatchEvent(selectEvent), 'this.dispatchEvent(selectEvent);');
        }
    }
    if(this.enableLogs){
    console.log(this.transformedChildTableData, 'this.transformedChildTableData');
    }
}

    addProductsToCart(currentRecordId, rowValue, customPrice, customName, conditionType) {
        customPrice = parseFloat(customPrice.replace(/,/g, ''));
        this.callAddItemToCart = false;
        if (this.selectedProducts.has(currentRecordId)) {            
            let existingItem = this.selectedProducts.get(currentRecordId);
            existingItem.Quantity = rowValue;
            existingItem.SalesPrice = customPrice;
            existingItem.PriceCondition = conditionType;
            this.selectedProducts.set(currentRecordId, existingItem);
        } else {            
            this.selectedProducts.set(currentRecordId, {

                Product2Id: currentRecordId,
                Quantity: rowValue,
                SalesPrice: customPrice,
                Name: customName,
                PriceCondition:conditionType
            });
        }
        this.updateTotalquantity();
        if(this.enableLogs){
        console.log('the values for add to cart', this.selectedProducts);
        }
    }

    updateTotalquantity() {
        let sum = 0;
            this.selectedProducts.forEach((value, key) => {
            sum += parseInt(value.Quantity);
            
        });
        this.totalQuantity = sum;
         
          const quantitychangeChangeEvent = new CustomEvent('quantitychange', {
            detail: this.totalQuantity            
        });        
        this.dispatchEvent(quantitychangeChangeEvent);
               

    }

  







// filter  sprint 4 Workitem 


@api
get filter() {
    return this._filter;
}

set filter(value) {
    this._filter = value;
    this.applyAllFilters(); 
}

handleFilterChange() {
    if (this._filter) {
        const lowerCaseFilter = this._filter.toLowerCase();
        this.filteredData = placeorderFilterData(this.orginaldata, lowerCaseFilter);
        
        if (this.showNationalAndStateFilter) {
            this.rawChildTableData = this.filteredData.filter(record => {
                return record.productDetails.ProgramSeries === 'NATL' ||
                       record.productDetails.ProgramSeries === this.userState;
            });
        } else {
            this.rawChildTableData = [...this.filteredData];
        }

        this.totalFilteredRecords = this.rawChildTableData.length;
        this.pageNumber = 1;
        this.totalPages = Math.ceil(this.totalFilteredRecords / this.pageSize);
        this.paginationHelper();
        this.updateTransformedDataLength();
    } else {
        this.filteredData = [];
        this.totalFilteredRecords = 0;

        if (this.showNationalAndStateFilter) {
            this.rawChildTableData = this.orginaldata.filter(record => {
                return record.productDetails.ProgramSeries === 'NATL' ||
                       record.productDetails.ProgramSeries === this.userState;
            });
        } else {
            this.rawChildTableData = [...this.orginaldata];
        }

        this.totalFilteredRecords = this.rawChildTableData.length;  // Ensure this is updated
        this.pageNumber = 1;
        this.totalRecords = this.rawChildTableData.length;
        this.totalPages = Math.ceil(this.totalRecords / this.pageSize);
        this.paginationHelper();
        this.updateTransformedDataLength();
    }
}

updateTransformedDataLength() {
    // Get the actual number of items currently displayed
    let displayCount = this.transformedChildTableData.length;
    
    // When using state filter, total count should match filtered count
    let totalItems = this.showNationalAndStateFilter ? 
        this.rawChildTableData.length : // Use filtered count when state filter is active
        this.orginaldata.length;        // Use total count when no state filter
    
    this.transformedDataLength = displayCount;
    
    // Create the event with the corrected counts
    const event = new CustomEvent('transformeddatalength', {
        detail: {
            transformedDataLength: displayCount,
            totalFilteredRecords: this.rawChildTableData.length,
            totalCount: totalItems
        }
    });
    this.dispatchEvent(event);
}


 applyAllFilters() {
        // Start with original data
        let filteredResults = [...this.orginaldata];

        // Apply text search filter if exists
        if (this._filter) {
            filteredResults = placeorderFilterData(filteredResults, this._filter.toLowerCase());
        }

        // Apply state filter if active
        if (this.showNationalAndStateFilter) {
            filteredResults = filteredResults.filter(record => {
                return record.productDetails.ProgramSeries === 'NATL' ||
                       Array.from(this.userState).includes(record.productDetails.ProgramSeries);
            });
        }

        // Update the working dataset
        this.rawChildTableData = filteredResults;
        
        // Update counts
        this.totalFilteredRecords = filteredResults.length;
        this.totalRecords = filteredResults.length;
        // Total count should match filtered count when using state filter
        this.totalCount = this.showNationalAndStateFilter ? 
            filteredResults.length : 
            this.orginaldata.length;

        // Reset pagination
        this.pageNumber = 1;
        this.totalPages = Math.ceil(this.totalFilteredRecords / this.pageSize);

        // Update display
        this.paginationHelper();
        this.updateTransformedDataLength();
    }


  focusCloseButton() {
        // Find the close button using data-id attribute
        const closeButton = this.template.querySelector('[data-id="closeButton"]');
        if (closeButton) {
            // Focus on the close button
            closeButton.focus();
        } else {
            console.error('Close button not found');
        }
    }
 
 //Trap focus inside modal
    focusOutClose(event) {
      var related = event.relatedTarget;
      if(related != undefined){
        if(related.getAttribute('data-index') != 0) { 
          this.template.querySelector('.cancel-modal-button').focus();
        }
      }
    }
  focusOutButton(event){
      var related = event.relatedTarget;
      if(related != undefined){
        if(related.getAttribute('data-index') != 0) { 
          this.template.querySelector('.closebtnOnFocus').focus();
        }
      }
    }

    createLogs(logType, requestBody, responseBody, statusLog, internalStatus,entryPoint) {
        createIntegrationLogsLWC1({ logType: logType, requestBody: requestBody, responseBody: responseBody, status: statusLog, internalStatus: internalStatus,entryPoint:entryPoint})
        .then(result => {
            if(this.enableLogs){
            console.log('result is', result);
            }
        })
        .catch(error => {
            console.log('error is', error);
        })
    }

@track showNationalAndStateFilter; 
@track userState = '';
@api defaultNationalStateFilter; 

get defaultNationalStateFilter() {
    return this._defaultNationalStateFilter === undefined ? true : this._defaultNationalStateFilter;
}


set defaultNationalStateFilter(value) {
    this._defaultNationalStateFilter = value;
}


applyNationalAndStateFilter() {
        if (!this.orginaldata || this.orginaldata.length === 0) {
            return;
        }

        if (this.showNationalAndStateFilter) {
            // Filter for national or matching state products
            this.rawChildTableData = this.orginaldata.filter(record => {
                const programSeries = record.productDetails.ProgramSeries;
                const userStates = Array.from(this.userState);
                return (
                    programSeries === 'NATL' ||
                    userStates.includes(programSeries)
                );
            });
            
            
            this.totalFilteredRecords = this.rawChildTableData.length;
            this.totalRecords = this.rawChildTableData.length;
            
            this.totalCount = this.rawChildTableData.length;
        } else {
            this.rawChildTableData = [...this.orginaldata];
             if (this.enableLogs) console.log('spread operator', ...this.orginaldata);
             if (this.enableLogs) console.log('without spread operator', this.orginaldata);
            
            this.totalFilteredRecords = this.orginaldata.length;
            this.totalRecords = this.orginaldata.length;
            this.totalCount = this.orginaldata.length;
        }
        
        this.pageNumber = 1;
        this.totalPages = Math.ceil(this.totalRecords / this.pageSize);

        this.paginationHelper();
        this.updateTransformedDataLength();
    }




handleNationalAndStateFilterChange(event) {
    this.showNationalAndStateFilter = event.target.checked;

    this.filterSearchValue = '';
    this._filter = '';
    this.filteredData = [];

    this.applyNationalAndStateFilter();
}

@track showConfirmationModal = false;

checkForOutOfStateProducts() {
    const selectedProducts = Array.from(this.selectedProducts.values());
    
    // Only check products with quantity greater than 0
    const activeProducts = selectedProducts.filter(product => product.Quantity > 0);
    
    return activeProducts.some(selectedProduct => {
        let product = this.transformedChildTableData.find(p => 
            p.productDetails.productId === selectedProduct.Product2Id
        );
        
        if (!product) {
            product = this.orginaldata.find(p => 
                p.productDetails.productId === selectedProduct.Product2Id
            );
        }
        
        if (!product) return false;
        
        const programSeries = product.productDetails.ProgramSeries;
        if (!programSeries || programSeries === 'NATL') {
            return false;
        }
        
        const userStates = Array.from(this.userState);
        return !userStates.includes(programSeries);
    });
}

handleConfirmAddToCart() {
   
    this.showConfirmationModal = false;
    this.initiateAddToCartProcess();
}

handleCancelAddToCart() {
    this.showConfirmationModal = false;
    this.addToCartFunction = false;  // Reset the add to cart state
    // Dispatch an event to reset the parent's state
    const resetEvent = new CustomEvent('resetaddtocart', {
        detail: {
            reset: true
        }
    });
    this.dispatchEvent(resetEvent);
}

@api 
resetCartState() {
    this.addToCartFunction = false;
    this.showConfirmationModal = false;
    this.callAddItemToCart = false;
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
@api 
handleFilterChange(filterValue) {
    this.showNationalAndStateFilter = filterValue;
    this.applyNationalAndStateFilter();
}
@api
handleNationalStateFilter(filterValue) {
    this.showNationalAndStateFilter = filterValue;
    this.applyAllFilters(); 
}
}