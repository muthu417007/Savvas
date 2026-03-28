import { LightningElement, api, wire, track } from 'lwc';
import getRestrictionDescription from '@salesforce/apex/scc_productTitlePage_Controller.getRestrictionDescription';
import getProductDetails from '@salesforce/apex/scc_productTitlePage_Controller.getProductDetails';
import { CartSummaryAdapter } from "commerce/cartApi";
import { updateItemInCart,deleteItemFromCart,refreshCartSummary} from 'commerce/cartApi';
import { CartItemsAdapter } from 'commerce/cartApi';

export default class Po_Title extends LightningElement {
    // Properties
    @track currentSelectedProductRecord = {}; // Currently selected product record
    @track restrictionValue = ''; // Restriction value for the product
    @track batchQuantity; // Batch quantity for the product
    @track gradeRange; // Grade range for the product
    @track stockAvailability; // Stock Availability
    @track loadchild = false; // Flag to load child component
    @track quantity = 0;
    @track disableAddToCart= true;
    @track productName;
    @track callAddItemToCart = false;
    @track showProductSearchTitlePage = true;
    @track  reviewCartPage = false;
    @track activeCartId;
    @track productsInCart = 0;
    @track clearCartBtnDisabled = true;
    @track reviewCartDisabled = true;
    @track reviewCartPage = false;
    @track clearCartItems = false;
    @track showAddToCartButton = true;
    @track cartIdToDelete;
    @track isTooltipVisible = false;
    // Variables
    @track Recordidval; // Record Id value
    displaypage = true; // Flag to display the page

   
     @wire(CartItemsAdapter)
    wireCartitemContext({ data, error }) {
        if (data) {
            this.cartItemList = data;
            console.log('the cartitemadaptor', data);
            console.log('cartItemList===' + JSON.stringify(this.cartItemList));
            let cartitems = this.cartItemList.cartItems;
           } else if (error) {
            console.log(`CartItemsAdapter::error = ${JSON.stringify(error, null, 2)}`);
        }
    }
     handleMouseOver() {
        if ( this.disableAddToCart) {
            this.isTooltipVisible = true;
        }
    }

    handleMouseOut() {
        this.isTooltipVisible = false;
    }
  
    removeTitleFoCart(){
         let currentRecordIdToRemove =event.target.getAttribute('data-row-id');
         let carId=event.target.getAttribute('data-attribute-cartid');
         console.log('the item going to be remove is',carId);
            this.cartItemRemoved(carId);
    }
    async cartItemRemoved(cartItemId) {
						try {
							const response = await deleteItemFromCart(cartItemId).then((result => { 
                                this.refreshSummary();
                                 this.showAddToCartButton = true ;
                                 this.callAddItemToCart = false;
                             }));
						} catch (error) {
							console.error(error);
						} finally {
						}
					}


         @wire(CartSummaryAdapter)
	setCartSummary({ data, error }) {
		if (data) {
			this.activeCartId = data.cartId;
            this.productsInCart=data.totalProductCount
            if(this.productsInCart > 0){
                this.clearCartBtnDisabled= false;
                this.reviewCartDisabled= false;
                this.clearCartItems= false;
            }else{
                this.clearCartBtnDisabled= true;
                this.reviewCartDisabled= true;
                 this.showAddToCartButton = true ;
                 this.callAddItemToCart = false;
            }
			console.log('the current active cartid id',this.activeCartId,'and the current data getting is',data);
          
            console.log('the active card product count is ',this.productsInCart);
                    
		} else if (error) {
			console.error(error);
		}
	}
       get clearCartButtonLabel(){
           return `Clear Cart (${this.productsInCart})`;
      }
      get reviewCartButtonLabel(){
            return `Review Cart (${this.productsInCart})`;
      }
    
    // Getter and Setter for parentSelectedProductRecord
    @api
    get parentSelectedProductRecord() {
        this.Recordidval = this.currentSelectedProductRecord.productId;
        this.ISBN =this.currentSelectedProductRecord.ISBN;
        this.loadchild = true;
        
        return this.currentSelectedProductRecord;
    }
    set parentSelectedProductRecord(value) {
        this.currentSelectedProductRecord = value;
    }

    // Lifecycle Hook: Connected Callback
    connectedCallback() {
        this.parentSelectedProductRecord;
        this.addEventListener('selectedproduct', this.handleSelectedProduct);
    }
    decrementQuantity(){
    if (this.quantity >0){
      this.quantity--;
         if (this.quantity <= 0){
        this.disableAddToCart = true;
    } 
    }}
incrementQuantity(){
    this.quantity++;
     if( this.quantity >0){
         this.disableAddToCart = false;
    }
    if( this.quantity < 1){
         this.disableAddToCart = true;
    }
}
changeQuantity(event){
    this.quantity= event.target.value;
    console.log('add title to cart quantity is',this.quantity);
    if( this.quantity >0){
         this.disableAddToCart = false;
    }
    if( this.quantity < 1){
         this.disableAddToCart = true;
    }

}
handlekeyPress(event){
  const charCode = event.which ? event.which : event.keyCode;
      const currentValue = event.target.value;
       const newValue = currentValue + String.fromCharCode(charCode);
  if(charCode >= 48 && charCode <= 57){
      if ((parseInt(newValue) >= 1 && parseInt)) {
        console.log('parseint true');
    return true;
  }
   event.preventDefault();
   return false;
}}

 

    // Wire method to fetch product details
    @wire(getProductDetails, { productId: '$currentSelectedProductRecord.productId' })
    wiredProductDetails({ error, data }) {
        if (data) {
            this.batchQuantity = data.SBQQ__BatchQuantity__c || 'N/A';
            this.gradeRange = data.Grade_Range__c;
            this.stockAvailability = data.Availability__c;
            this.productName = data.Name;
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
        if (typeof price === 'number') {
            let formattedPrice = price.toFixed(2);
            formattedPrice = formattedPrice.replace(/\B(?=(\d{3})+(?!\d))/g, ',');
            return formattedPrice;
        } else {
            return price;
        }
    }

    // Computed property to get the formatted price
    get formattedPrice() {
        return this.formatPrice(this.currentSelectedProductRecord.Price);
    }

    // Method to close the page
    closePage() {
        this.displaypage = false;
    }

    // Method to handle return to product search button click
    returnProductSearchOnclick() {
        const sendCustomEventToCloseTitlePage = new CustomEvent("closetitlepage");
        this.dispatchEvent(sendCustomEventToCloseTitlePage);
    }

    // Event handler for selected product event
    handleSelectedProduct(event) {
        const selectedProductRecord = event.detail.selectedProductRecord;
        console.log('Selected Product Record:', selectedProductRecord);
    }

    // Cleanup when component is disconnected
    disconnectedCallback() {
        this.removeEventListener('selectedproduct', this.handleSelectedProduct);
    }

    // Additional methods for handling button clicks

    // Config for product search button section
    productSearchBtnSectionConfig = {
        addSelectedToCartBtnLabel: 'Add Selected (number) To Cart',
        addSelectedToCartBtnDisabled: true,
        clearCartBtnLabel: 'Clear Cart (number)',
        clearCartBtnDisabled: true,
        reviewCartLabel: 'Review Cart (number)',
        reviewCartDisabled: true,
        productAddedToCart: 0
    };

    // Computed property to format product search button section config
    get displayProductSearchBtnSectionConfig() {
        let local_ProductSearchBtnSectionConfig = { ...this.productSearchBtnSectionConfig };
        local_ProductSearchBtnSectionConfig.addSelectedToCartBtnLabel = local_ProductSearchBtnSectionConfig.addSelectedToCartBtnLabel.replace(/number/g, local_ProductSearchBtnSectionConfig.productAddedToCart);
        local_ProductSearchBtnSectionConfig.clearCartBtnLabel = local_ProductSearchBtnSectionConfig.clearCartBtnLabel.replace(/number/g, local_ProductSearchBtnSectionConfig.productAddedToCart);
        local_ProductSearchBtnSectionConfig.reviewCartLabel = local_ProductSearchBtnSectionConfig.reviewCartLabel.replace(/number/g, local_ProductSearchBtnSectionConfig.productAddedToCart);
        return local_ProductSearchBtnSectionConfig;
    }

    clearCartHandleClick() { 
           this.clearCartItems= true;
        console.log('the clear cart handle is called'); 
        }
    reviewCartHandleClick(event) {
        this.showProductSearchTitlePage = false;
        this.reviewCartPage = true;

    }
    addTitleToCart(event){
         let currentRecordId=event.target.getAttribute('data-row-id');
         let price = 100;
         let prodName = this.ISBN;
         let prodQuantity =this.quantity;
         console.log('the values for add to cart is '+ currentRecordId,'  ',price,'   ',prodName,'   ',prodQuantity);
          const selectedProduct ={
                Product2Id : currentRecordId,
                Quantity: prodQuantity,
                SalesPrice: price,
                Name : prodName
            };
          console.log('items in the selectedProduct is',selectedProduct);  
         this.itemsList= [];
         this.itemsList.push(selectedProduct);
         console.log('items in the list is',this.itemsList);
         this.callAddItemToCart= true;

    }
    handleReviewCartCount(event){
        let count= event.detail.reveiewCartCount;
        this.clearCartItems= false;
        this.callAddItemToCart= false;
        this.disableAddToCart = true;
        this.quantity= 0;
        this.refreshSummary();
        console.log('review cart count is', count);
    }
     handlerefreshevent(){
         this.refreshSummary();
          this.clearCartItems= false;
    }
     async refreshSummary(){
		const response = await refreshCartSummary()
		.then((result => {  
	      this.isLoading = false;   
		  this.isEmptyCart = true;   
		}));
	}
}