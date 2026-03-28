import { LightningElement, track, api, wire } from 'lwc';
import getRelatedProducts from '@salesforce/apex/scc_relatedProductsLWC_Controller.getAllRelatedproducts';
class ProductQuantityWrapper {
    constructor(productId, productDetails, quantity = '', checkboxValue = false, disableQuantity = true, hideCheckbox = false, disabledCheckbox = false) {
        this.productId = productId;
        this.productDetails = productDetails;
        this.quantity = quantity;
        this.checkboxValue = checkboxValue;
        this.disableQuantity = disableQuantity;
        this.hideCheckbox = hideCheckbox;
        this.disabledCheckbox = disabledCheckbox;
    }

    getInActiveQuantityField() {
        return (this.hideCheckbox || !this.activeQuantity);
    }
}

export default class Comp_related extends LightningElement {
    @track relatedproductinp;
    @api message;
    showRelatedTitlePage = false;
    showResults = true;

    // recordsid="01t0W000004Znk2QAC";
    connectedCallback() {
        console.log('message from', this.message);
    }

    //    ....24...
    @track productData = [];
    @track productQuantityData = []; // Initialize productQuantityData

    relatedProducts;
    pageSizeOptions = [15, 25, 50, 75, 100]; //Page size options
    records = []; //All records available in the data table
    columns = []; //columns information available in the data table
    totalRecords = 0; //Total no.of records
    pageSize; //No.of records to be displayed per page
    totalPages; //Total no.of pages
    pageNumber = 1; //Page number    
    recordsToDisplay = []; //Records to be displayed on the page



    @wire(getRelatedProducts, { productId: '$message' })
    wiredRelatedProducts({ error, data }) {
        if (data) {
            this.relatedProducts = data;
            console.log('relatedProducts:', this.relatedProducts);
            this.updateProductData();
        } else if (error) {
            console.error('Error fetching related products:', error);
        }
    }

    updateProductData() {
        this.productData = Object.assign([], this.relatedProducts)
        for (let index = 0; index < this.productData.length; index++) {
            if (index == 15) {
                break;
            }
            // let obj = { productId: this.productData[index].productId, productDetails: this.productData[index] }
            // obj.quantity = '';
            // obj.checkboxValue = false;
            // obj.disableQuantity = true;
            // obj.hideCheckbox = false;
            // obj.disabledCheckbox = false;
            let oneProductQuantity = new ProductQuantityWrapper( this.productData[index].Id,  this.productData[index], '', false, true, false, false);
            this.productQuantityData.push(oneProductQuantity);
        };

        // Log productQuantityData for checking
        console.log('productQuantityData:', this.productQuantityData);

        // Call any other methods or perform additional operations as needed
        this.paginationHelper();
    }



    // updateProductData() {
    //     this.productData = this.relatedProducts.map(product => {
    //         return new ProductQuantityWrapper(
    //             product.Id,
    //             product,
    //             '', // Set other default values as needed
    //             false,
    //             true,
    //             false,
    //             false
    //         );
    //     });
    //     // this.productQuantityData = [...this.productData];
    //     // this.paginationHelper();
    //     if (this.productData.length > 0) {
    //         this.productQuantityData = [...this.productData];
    //         console.log('productData:', this.productQuantityData);

    //     } else {
    //         this.productQuantityData = [];
    //     }

    //     this.paginationHelper();
    // }    

    handleRowAction(event) {
        const action = event.detail.action;
        const row = event.detail.row;

        //this.showTabset = false;
        console.log('Current Selected Product Record:', row);
        console.log('Current Selected Product Record:', action);
        this.selectedProductRecord = row.Id;
        this.selectedISBN = row.ISBN13__c;
        console.log('Current Selected Product Record:', this.selectedProductRecord);
        console.log('Current Selected Product Record:', this.selectedISBN);
        this.showRelatedTitlePage = true;
        this.showResults = false;
        const sendCustomEventToCloseTitlePage = new CustomEvent("closetitlepage");
        this.dispatchEvent(sendCustomEventToCloseTitlePage);
    }
    closeTitlePage(event) {
        this.showRelatedTitlePage = false;
        this.showResults = true;
        const sendCustomEventToopenTitlePage = new CustomEvent("opentitlepage");
        this.dispatchEvent(sendCustomEventToopenTitlePage);
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
    }
    // .................................................
    handleQuantityDecrease(event) {
        const productId = event.target.dataset.productid;
        // console.log('Product ID on Decrease:', productId);
        const productIndex = this.productData.findIndex(item => item.Id === productId);
        if (productIndex !== -1 && this.productData[productIndex].quantity > 0) {
            // Clone the product object before modification
            const updatedProduct = { ...this.productData[productIndex] };
            updatedProduct.quantity--;
            // Clone the productData array before modification
            const updatedProductData = [...this.productData];
            // Update the cloned array with the modified object
            updatedProductData[productIndex] = updatedProduct;
            // Update the original productData array with the cloned array
            this.productData = updatedProductData;
        }
    }
    handleQuantityIncrease(event) {
        const productId = event.target.dataset.productid;
        // console.log('Product ID on Increase:', productId);
        const productIndex = this.productData.findIndex(item => item.Id === productId);
        if (productIndex !== -1) {
            // Clone the product object before modification
            const updatedProduct = { ...this.productData[productIndex] };
            if (!updatedProduct.hasOwnProperty('quantity')) {
                updatedProduct.quantity = 0;
            }
            updatedProduct.quantity++;
            // Clone the productData array before modification
            const updatedProductData = [...this.productData];
            // Update the cloned array with the modified object
            updatedProductData[productIndex] = updatedProduct;
            // Update the original productData array with the cloned array
            this.productData = updatedProductData;
        }
    }

    tableRowAction(event) {

        let fieldName = event.target.dataset.fieldName;
        let rowId = event.target.dataset.rowId;
        console.log('tableRowAction ::  ', rowId, fieldName);
        let local_productQuantityData = this.productQuantityData;
        if (fieldName == 'checkbox') {
            let rowValue = event.target.checked;
            let rowIndex = local_productQuantityData.findIndex(element => element.productDetails.Id === rowId);
            let rowInfo = local_productQuantityData[rowIndex];
            rowInfo.checkboxValue = rowValue;
            rowInfo.disableQuantity = false;
            if (!rowInfo.checkboxValue) {
                rowInfo.quantity = '';
            }
            else {
                rowInfo.quantity = 1;
            }
            local_productQuantityData[rowIndex] = rowInfo;
            this.productSearchBtnSectionConfig.addSelectedToCartBtnDisabled = true;
            let selectedProductCount = 0;
            for (let productDetails of local_productQuantityData) {
                if (productDetails.checkboxValue) {
                    if (this.productSearchBtnSectionConfig.addSelectedToCartBtnDisabled) {
                        this.productSearchBtnSectionConfig.addSelectedToCartBtnDisabled = false;
                    }
                    selectedProductCount += 1;
                }
            }
            this.productSearchBtnSectionConfig.productAddedToCart = selectedProductCount;
        }
        if (fieldName == 'quantityCount') {
            let rowValue = event.target.value;
            let rowIndex = local_productQuantityData.findIndex(element => element.productDetails.Id === rowId);
            let rowInfo = local_productQuantityData[rowIndex];
            rowInfo.quantity = rowValue;
            local_productQuantityData[rowIndex] = rowInfo;
        }
        if (fieldName == 'isbnId') {
            let rowIndex = local_productQuantityData.findIndex(element => element.productDetails.Id === rowId);
            let rowInfo = local_productQuantityData[rowIndex];
            this.handleRowAction(rowInfo.productDetails, 'viewRecords');
        }
        this.productQuantityData = Object.assign([], local_productQuantityData);
        // console.log('this.productQuantityData :: ', this.productQuantityData);
    }
    isAddToSelectedToCartBtnDisabled = false;
    // ListOfObjects = [
    //     {value:1, value2: 2}
    //     {value:2, value2:4}]
    productSearchBtnSectionConfig = {
        addSelectedToCartBtnLabel: 'Add Selected (number) To Cart',
        addSelectedToCartBtnDisabled: true,
        clearCartBtnLabel: 'Clear Cart (number)',
        clearCartBtnDisabled: true,
        reviewCartLabel: 'Review Cart (number)',
        reviewCartDisabled: true,
        productAddedToCart: 0
    }
    get displayProductSearchBtnSectionConfig() {
        let local_ProductSearchBtnSectionConfig = Object.assign({}, this.productSearchBtnSectionConfig);
        // console.log('this.productSearchBtnSectionConfig :: ', local_ProductSearchBtnSectionConfig);
        local_ProductSearchBtnSectionConfig.addSelectedToCartBtnLabel = local_ProductSearchBtnSectionConfig.addSelectedToCartBtnLabel.replace(/number/g, local_ProductSearchBtnSectionConfig.productAddedToCart);
        local_ProductSearchBtnSectionConfig.clearCartBtnLabel = local_ProductSearchBtnSectionConfig.clearCartBtnLabel.replace(/number/g, local_ProductSearchBtnSectionConfig.productAddedToCart);
        local_ProductSearchBtnSectionConfig.reviewCartLabel = local_ProductSearchBtnSectionConfig.reviewCartLabel.replace(/number/g, local_ProductSearchBtnSectionConfig.productAddedToCart);
        // console.log('after local_ProductSearchBtnSectionConfig : ', local_ProductSearchBtnSectionConfig);
        return local_ProductSearchBtnSectionConfig;
    }
    addToSelectedToCartHandleClick(event) {
        this.productSearchBtnSectionConfig.addSelectedToCartBtnDisabled = true;
        this.productSearchBtnSectionConfig.clearCartBtnDisabled = false;
        this.productSearchBtnSectionConfig.reviewCartDisabled = false;

        let local_productQuantityData = this.productQuantityData;
        for (let productDetails of local_productQuantityData) {
            productDetails.disabledCheckbox = true;
            if (productDetails.checkboxValue) {
                productDetails.hideCheckbox = true;
                productDetails.disableQuantity = true;
            }
        }
        this.productQuantityData = Object.assign([], local_productQuantityData);
    }
    clearCartHandleClick(event) {

    }
    reviewCartHandleClick(event) {

    }

    taskTypeHelpTextClass = 'slds-popover slds-popover_tooltip slds-nubbin_bottom-right slds-fall-into-ground slds-hide';
    togglePasswordHint() {
        // console.log('it worked')
        // return ;
        let hideCss = 'slds-popover slds-popover_tooltip slds-nubbin_bottom-right slds-fall-into-ground slds-hide';
        let showCss = 'slds-popover slds-popover_tooltip slds-nubbin_bottom-right slds-rise-from-ground';
        this.taskTypeHelpTextClass = this.taskTypeHelpTextClass == hideCss ? showCss : hideCss;

    }
    get showLoadNextButton() {
        return (this.productQuantityData.length < this.productData.length) ? true : false;
    }
    get totalCount() {
        return (this.productData != undefined) ? this.productData.length : 0;
    }
    get pageRecordCount() {
        return (this.productQuantityData != undefined) ? this.productQuantityData.length : 0;
    }

    handleLoadNext() {
        if (this.productQuantityData.length < this.productData.length) {
            let actualResultLength = this.productData.length;
            let uiResultLength = this.productQuantityData.length;
            if ((actualResultLength - uiResultLength) <= 15) {
                let difference = (actualResultLength - uiResultLength);
                for (let index = uiResultLength; index < (uiResultLength + difference); index++) {
                    let obj = { productId: this.productData[index].productId, productDetails: this.productData[index] }
                    obj.quantity = '';
                    obj.checkboxValue = false;
                    obj.disableQuantity = true;
                    obj.hideCheckbox = false;
                    obj.disabledCheckbox = false;
                    this.productQuantityData.push(obj);
                }
            }
            else {
                for (let index = uiResultLength; index < (uiResultLength + 15); index++) {
                    let obj = { productId: this.productData[index].productId, productDetails: this.productData[index] }
                    obj.quantity = '';
                    obj.checkboxValue = false;
                    obj.disableQuantity = true;
                    obj.hideCheckbox = false;
                    obj.disabledCheckbox = false;
                    this.productQuantityData.push(obj);
                }
            }
        }
    }

    // ............................................................
    // Define columns for the lightning-datatable
    columns = [
        { label: 'ISBN', fieldName: 'Id', initialWidth: 160, type: 'button', typeAttributes: { label: { fieldName: 'ISBN13__c' }, name: 'viewRecords', target: "_blank", variant: 'base' }, sortable: true },
        { label: 'Title Description', fieldName: 'Description', initialWidth: 550, type: 'text', sortable: true },
        { label: 'Type', fieldName: 'Product_Sub_Type__c', initialWidth: 180, type: 'text', sortable: true, wrapText: true },
        { label: 'Grade Level', fieldName: 'Grade_Level__c', initialWidth: 100, type: 'text', sortable: true },
        { label: 'Copyright', fieldName: 'Copyright_Year__c', initialWidth: 100, type: 'text', sortable: true },
        { label: 'Status', fieldName: 'Product_Status__c', initialWidth: 140, type: 'text', sortable: true },
        {
            label: 'Price',
            fieldName: 'Net_Price__c',
            initialWidth: 100,
            type: 'currency',
            sortable: true
        }

    ];
    // To handle sort items ASC/DESC
    onHandleSort(event) {
        console.log('onHandleSort :: ', event.detail);
        this.sortedBy = event.detail.fieldName;
        this.sortDirection = event.detail.sortDirection;
        this.sortData(this.sortedBy, this.sortDirection);
    }
    sortData(fieldname, direction) {
        console.log('sortData :: ', fieldname, direction);
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


}