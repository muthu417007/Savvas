import { LightningElement, api, wire, track } from 'lwc';
import getRestrictionDescription from '@salesforce/apex/scc_productTitlePage_Controller.getRestrictionDescription';
import getProductDetails from '@salesforce/apex/scc_productTitlePage_Controller.getProductDetails';

export default class Comp_title extends LightningElement {
    // Properties
    @track currentSelectedProductRecord = {}; // Currently selected product record
    @track restrictionValue = ''; // Restriction value for the product
    @track batchQuantity; // Batch quantity for the product
    @track gradeRange; // Grade range for the product
    @track stockAvailability; // Stock Availability


    // Variables
    Recordidval; // Record Id value
    displaypage = true; // Flag to display the page
    @track loadchild = false; // Flag to load child component

    // Getter and Setter for parentSelectedProductRecord
    @api
    get parentSelectedProductRecord() {
        console.log('current record is', this.currentSelectedProductRecord.productId);
        this.Recordidval = this.currentSelectedProductRecord.productId;
        console.log('recordid is', this.Recordidval);
        this.loadchild = true;
        return this.currentSelectedProductRecord;
    }
    set parentSelectedProductRecord(value) {
        this.currentSelectedProductRecord = value;
    }

    // Lifecycle Hook: Connected Callback
    connectedCallback() {
        this.parentSelectedProductRecord;
        console.log(this.parentSelectedProductRecord);
        this.showTabsets = this.parentSelectedProductRecord.showTabset; // Added by sudha  
        this.addEventListener('selectedproduct', this.handleSelectedProduct);
    }
    // Wire method to fetch product details
    @wire(getProductDetails, { productId: '$currentSelectedProductRecord.productId' })
    wiredProductDetails({ error, data }) {
        if (data) {
            this.batchQuantity = data.SBQQ__BatchQuantity__c || 'N/A';
            this.gradeRange = data.Grade_Range__c;
            this.stockAvailability = data.Availability__c; // Stock availability
        } else if (error) {
            console.error('Error fetching product details:', error);
        }
    }

    // Wire method to fetch restriction description
    @wire(getRestrictionDescription, { productId: '$currentSelectedProductRecord.productId' })
    wiredRestriction({ error, data }) {
        if (data) {
            this.restrictionValue = data;
        } else if (error) {
            console.error('Error fetching restriction:', error);
        }
    }

    // Method to format the price
    formatPrice(price) {
        // Check if the price is a number
        if (typeof price === 'number') {
            // Convert the price to a string with two decimal places
            let formattedPrice = price.toFixed(2);
            // Add commas for thousands
            formattedPrice = formattedPrice.replace(/\B(?=(\d{3})+(?!\d))/g, ',');
            // Return the formatted price
            return formattedPrice;
        } else {
            // If the price is not a number, return it as is
            return price;
        }
    }

    // Computed property to get the formatted price
    get formattedPrice() {
        return this.formatPrice(this.currentSelectedProductRecord.Price);
    }

    // Method to close the page
    closePage(event) {
        this.displaypage = false;
    }

    // Method to open the page
    openpage(event) {
        this.displaypage = true;
    }

    // Method to handle return to product search button click
    returnProductSearchOnclick(event) {
        const sendCustomEventToCloseTitlePage = new CustomEvent("closetitlepage"

        );
        this.dispatchEvent(sendCustomEventToCloseTitlePage);

    }
    handleSelectedProduct(event) {
        // Extract the selected product record from the event
        const selectedProductRecord = event.detail.selectedProductRecord;
        console.log('Selected Product Record:', selectedProductRecord);
    }
    disconnectedCallback() {
        // Remove event listener when component is disconnected to avoid memory leaks
        this.removeEventListener('selectedproduct', this.handleSelectedProduct);
    }

    // Method to handle return to product search button click
    returnProductSearchOnclick(event) {
        const sendCustomEventToCloseTitlePage = new CustomEvent("closetitlepage", {
            detail: { tabClose: this.tabValue }
        });
        this.dispatchEvent(sendCustomEventToCloseTitlePage);

    }

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
}