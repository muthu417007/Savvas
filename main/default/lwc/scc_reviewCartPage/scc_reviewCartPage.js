/********************************************************************************************* 
* @Component Name  - Scc_reviewCartPage
* @description -  Component to review cart page and hold cart page
* @Created By  - CTS-Muthukumar
* @Created On - 2024-05-1 
* ********************************************************************************************/

import { LightningElement, api, track, wire } from 'lwc';
import {NavigationMixin} from 'lightning/navigation';
import { encodeDefaultFieldValues } from 'lightning/pageReferenceUtils';
import isGuestUser from '@salesforce/apex/scc_checkOutLWC_Controller.isGuestUser';
import deleteAllCartItems from '@salesforce/apex/scc_addItemsToCartController.deleteAllCartItems';
import getCartDetails from '@salesforce/apex/scc_addItemsToCartController.getCartDetails';
import deleteCartItem from '@salesforce/apex/scc_reviewCartPageController.deleteCartItem';
import createERPOrder from '@salesforce/apex/scc_checkOutLWC_Controller.createERPOrder';
import { APPLICATION_SCOPE, createMessageContext, MessageContext, publish, releaseMessageContext, subscribe, unsubscribe } from 'lightning/messageService';
import scc_MessageChannel from '@salesforce/messageChannel/scc_MessageChannel__c';
import getReviewCartItems from '@salesforce/apex/scc_reviewCartPageController.getActiveCartItems';
import getActiveCartInfo from '@salesforce/apex/scc_reviewCartPageController.getActiveCart';
import updateToHeldCart from '@salesforce/apex/scc_holdCartPageController.updateToHeldCart'
import { refreshApex } from '@salesforce/apex';
import { CartSummaryAdapter } from "commerce/cartApi";
import fetchCartData from '@salesforce/apex/scc_checkOutLWC_Controller.fetchCartData';
import fetchCartDetails from '@salesforce/apex/scc_checkOutLWC_Controller.fetchCartDetails';
import updateCartItemQuantity from '@salesforce/apex/scc_reviewCartPageController.updateCartItemQuantity';
import getPromoCode from '@salesforce/apex/scc_reviewCartPageController.getPromoCode';
import { updateItemInCart, deleteItemFromCart, refreshCartSummary } from 'commerce/cartApi';
import scc_reviewCartPage_SummaryHelpText from "@salesforce/label/c.scc_reviewCartPage_SummaryHelpText";
import scc_reviewCart_ShippingHelpText from "@salesforce/label/c.scc_reviewCart_ShippingHelpText";
import scc_reviewCart_TaxHelpText from "@salesforce/label/c.scc_reviewCart_TaxHelpText";
import scc_brand_logo_mobile from "@salesforce/resourceUrl/scc_brand_logo_mobile";
import scc_formatAsQuote_Button_HelpText from "@salesforce/label/c.scc_formatAsQuote_Button_HelpText";
import scc_deleteItem_WraningContent from "@salesforce/label/c.scc_deleteItem_WraningContent";
import scc_claerAll_Item_WarningContent1 from "@salesforce/label/c.scc_claerAll_Item_WarningContent1";
import scc_claerAll_Item_WarningContent2 from "@salesforce/label/c.scc_claerAll_Item_WarningContent2";
import scc_claerAll_Item_WarningContent3 from "@salesforce/label/c.scc_claerAll_Item_WarningContent3";
import scc_creditCheckErrorMsg from "@salesforce/label/c.scc_creditCheckErrorMsg";
import cartSimulation from '@salesforce/apex/ensxtx_CTRL_Cart.cartSimulation';
import sendEmailCart from '@salesforce/apex/scc_emailCart_Controller.sendEmailCart';
import generatePdf from '@salesforce/apex/scc_cartPdf_Controller.generatePdf';
import createSAPOrder from '@salesforce/apex/ensxtx_CTRL_Cart.createSalesDocument';
import createIntegrationLogsLWC1 from '@salesforce/apex/scc_IntegrationLogs_Helper.createIntegrationLogsLWC1';
import clearPromoCode from '@salesforce/apex/scc_changeCartAsSecondary.clearPromoCode';
import imageIcons from '@salesforce/resourceUrl/scc_Images';

/*import static resources*/
import scc_cart_item_img from "@salesforce/resourceUrl/scc_cart_item_img";
import scc_delete_icon from "@salesforce/resourceUrl/scc_delete_icon";
import scc_checkout_cart from "@salesforce/resourceUrl/scc_checkout_cart";
import scc_checkout_cart_lightblue from "@salesforce/resourceUrl/scc_checkout_cart_lightblue";
import getEnableConsoleLogsTrue from '@salesforce/apex/scc_headerLWC_Controller.getEnableConsoleLogsTrue';

export default class Scc_reviewCartPage extends NavigationMixin(LightningElement) {
  @wire(MessageContext) messageContext;
  @track quantity;
  @track subTotalPriceData;
  @track productDetailsInCart;
  @track totalPrice;
  @track totalPriceValue;
  @track currentRecordIdToRemove;
  @track productsInCart = 0;
  @track isLoading1 = true;
  @track isLoading = false;
  @track reviewCart = true;
  @track holdCart = false;
  @track isModalOpen = false;
  @track clearCartItems = false;
  @track openDeleteModel = false;
  @track promocodeValue = '';
  @track appliedPromocodeValue = '';
  @track homePage = false;
  @track  cartPage = true;
  @track homePageAfterHeldCart = false;
  @track webcartName;
  @track webcartId;
  @track showCheckOutDetails = false;
  @track totalWithDiscount = 0.00;//added by suresh for discount
  @track totalWithDiscount1 = 0.00;
  @track discount = 0.00;//added by suresh for discount
  @track discount1 = 0.00;//added by suresh for discount
  @track isOpen = false;
  disabledApplyButton = true;
  @track promoCodeValid = true;
  @api childCartPage = false;
  @track showTooltip = false;
  @api recordId;
  @track errorMessage = '';
  @api promoCode;
  @track isReviewOrder = false;
  @api cartId;
  @track pricingCondition;
  @track isGuest = false;
  @track guestAccountId = '';
  @track guestCartId = '';
  @track isERPOrderSubmitted = false;
  @track continueShopping = false;
  @api currentabtitle;
  @api userselection = [];
  @track userInputs=[];
  orderId;
  @track logType = '';
  @track requestBody = '';
  @track responseBody = '';
  @track statusLog ='';
  @track internalStatus ='';
  @track validPromo ='';
  @track showErrorMSG = false;
  @track enableLogs = false;
  coverImage = imageIcons + '/Images/cover.png';
  labels = {
    scc_reviewCartPage_SummaryHelpText,
    scc_reviewCart_ShippingHelpText,
    scc_reviewCart_TaxHelpText,
    scc_formatAsQuote_Button_HelpText,
    scc_deleteItem_WraningContent,
    scc_claerAll_Item_WarningContent1,
    scc_claerAll_Item_WarningContent2,
    scc_claerAll_Item_WarningContent3,
    scc_cart_item_img,
    scc_delete_icon,
    scc_checkout_cart,
    scc_checkout_cart_lightblue,
    scc_brand_logo_mobile,
    scc_creditCheckErrorMsg
  }
    constructor(){
      super();
      window.scrollTo({
            top: 0,
            behavior: 'smooth'
      });
 
      isGuestUser().then(response => {            
          if(response){
            if (this.enableLogs)  console.log('isGuestUser response',response)
              this.isGuest = true;
              const urlParams = new URLSearchParams(window.location.search);
              this.guestCartId = urlParams.get('CartId');
              this.guestAccountId = urlParams.get('aid');
              this.fetchCurrentCart();
          }else{
            this.fetchCurrentCart();
          }
      }).catch(error => {
          console.log('error in checking if it is a guest user', error);
      })  
      getEnableConsoleLogsTrue().then(response => {
            this.enableLogs = response;
            if (this.enableLogs) console.log('getEnableConsoleLogsTrue response is', response);
        }).catch(error => {
            if (this.enableLogs) console.log('error is', error);
      });

    }
    formatPrice(price) {
    if(this.enableLogs){
        if (this.enableLogs)  console.log('Price input:', price, 'Type:', typeof price);
    }
    if (price === null || price === undefined || price === '') {
        return 'N/A';
    }
    try {
        let numericPrice = typeof price === 'string' ? parseFloat(price.replace(/[^0-9.-]+/g, '')) : price;
        if (isNaN(numericPrice)) {
            return 'N/A';
        }
        // Format to 2 decimal places and add commas
        let formattedPrice = numericPrice.toFixed(2);
        return  formattedPrice.replace(/\B(?=(\d{3})+(?!\d))/g, ',');
    } catch (error) {
        console.error('Error formatting price:', error, 'Price value:', price);
        return 'N/A';
    }
}

    convertToInt(value){
        return parseInt(value,10);
    }

  connectedCallback() {
    if(!this.isGuest){
      this.refreshSummary();
    }
       this.template.addEventListener('keydown', this.handleKeydown.bind(this));
   }
   
   disconnectedCallback() {
        this.template.removeEventListener('keydown', this.handleKeydown);
    }

     handleKeydown(event) {
        if (event.key === 'Escape') {
            if(this.isModalOpen){
                this.closeModal();
            }
            else if(this.openDeleteModel){
                this.closeDeleteModal();
            }
            else if(this.isOpen){
              this.closeEmailModal();
            }            
        }
    }

   fetchuserinputs(){
        getCartDetails({activeCartId : this.activeCartId})
        .then(result => {
          if (this.enableLogs)  console.log('guestcartdetails', result);
            let userDatas=result;
            this.userInputs= userDatas.map(datas => ({
            ...datas,
            billCountry : datas.BillingCountry,
            billState : datas.BillingState,
            shipCountry : datas.Shipping_Country__c,
            shipState : datas.Shipping_State__c,
            schoolDistrict :datas.School_Or_District__c,
            oneTimeShip: datas.Specify_One_Time_Shipping__c
          }));
         })
         .catch(error => {
            console.log('userinputerror', error);
        })      
   }
  fetchCurrentCart(){
     getActiveCartInfo({guestCartId : this.guestCartId})
        .then(result => {
            this.activeCartId = result[0].Id;
            this.productsInCart = this.convertToInt(result[0].TotalProductCount);
            this.cartPage = true;
            publish(this.messageContext, scc_MessageChannel, { cartCount: this.productsInCart });
             this.cartSimulateCall();
            if(this.userselection.length == 0){
              this.fetchuserinputs();
            }else{
                this.userInputs=this.userselection;
            }
         })
         .catch(error => {
            console.log('fetchCurrentCart3', error);
        })
  }
  @wire(CartSummaryAdapter)
  setCartSummary({ data, error }) {
    if (data) { 
      this.productsInCart = this.convertToInt(data.totalProductCount);
        if (this.enableLogs) console.log('productsInCart',this.productsInCart);
      if(this.productsInCart == 0){
           this.clearPromo(); 
      }
      publish(this.messageContext, scc_MessageChannel, { cartCount: this.productsInCart });  
    }
    else if (error) {
      console.error(error);
    }
  }
 handleReviewCart() {
    getReviewCartItems({guestCartId:this.guestCartId})
        .then(result => {
          if (this.enableLogs)  console.log('getReviewCartItems',result);
            this.isLoading1 = false;
            this.productDetailsInCart = result.map(item => ({
                ...item,
                showContractPricing: item.PriceCondition === 'ZCON',
                totalPrice: this.formatPrice(item.totalPrice),
                price:this.formatPrice(item.price)
            }));
            if (result.length > 0) {
                this.webcartName = result[0].cartName;
                this.webcartId = result[0].webCartId;
            }
            this.pricingConditions = result.map(item => {
                return { Product2Id: item.Product2Id, PriceCondition: item.PriceCondition };
            });
            this.calculateTotalPrice(result);
            this.isLoading1 = false;
        })
        .catch(error => {
             if (this.enableLogs)  console.log('getReviewCartItems error', error);
            this.cases = undefined;
            this.isLoading1 = false;
            this.caseError = error;
        })
        .finally(() => {
          //this.handleFetchCartData();
        })
}


  //added by Vaibhav for cart simulate call starts
  cartSimulateCall() {
    const cartSimulateBefore = Date.now();
    cartSimulation({ cartId: this.activeCartId, appSettingsName: 'ensxtx_SR_enosixWebCartB2BAppSettings' })
      .then(({ data, messages }) => {
         if (this.enableLogs)   console.log('cartSimulation response',data, 'transactlog',messages);   
           messages.forEach(item => {
                let enosixMSg= item.message;    
                if (this.enableLogs)   console.log('TransactLogsensxtx_Message__c',enosixMSg);                
                const regex=/credit check/i;
                this.showErrorMSG=(regex.test(enosixMSg));
          });
        if (this.enableLogs) console.log('cartSimulation response',data, 'transactlog');
        const cartSimulateAfter = Date.now();
        if (this.enableLogs)  console.log('Cart Simulate load time in seconds is', (cartSimulateAfter - cartSimulateBefore) / 1000);
        this.responseBody = JSON.stringify(data.TransactLogs);
        if (this.enableLogs)  console.log('TransactLogs',this.responseBody);
        this.logType ='Enosix Cart Simulation';
        this.requestBody = this.activeCartId;
        this.statusLog= 'Success';
        this.internalStatus='';
        this.createLogs(this.logType,this.requestBody,this.responseBody,this.statusLog,this.internalStatus,'Scc_reviewCartPage/cartSimulateCall/cartSimulation');
      })
      .catch(error => {
        console.log('cart simulation error>>>>',error);
        this.logType ='Enosix Cart Simulation';
        this.requestBody =this.activeCartId;
        this.statusLog= 'Error';
        this.internalStatus=JSON.stringify(error);
        this.createLogs(this.logType,this.requestBody,this.responseBody,this.statusLog,this.internalStatus,'Scc_reviewCartPage/cartSimulateCall/cartSimulation');
      })
      .finally(() => {
        this.handleReviewCart();
        this.handleFetchCartData();
      })
  }

  // Added By Sagar for Email Cart
  openCart() {
    this.isOpen = true;
  }
  sendEmailHandler(event) {
    const eAddress = event.detail;
    sendEmailCart({ eAddrs: eAddress })
      .then(() => {
        this.isOpen = false;
      })
      .catch(error => { console.error('Error: ', error); });
  }

  cancelSend(event) {
    this.isOpen = event.detail;
    const button = this.template.querySelector(".emailCartbtn");
      if(button){
        setTimeout(() => {
          button.focus();
        }, 100);
      }
  }

  // Added by Sagar for PDF generation
  handleGeneratePDF(){
    generatePdf()
      .then((pdfUrl)=>{
        window.open(pdfUrl,'_blank');
      })
      .catch((error)=>{
        alert('Error Generating Cart PDF', error);
      });
  }

  calculateTotalPrice(result) {
    let total = 0;
    if (result) {
      result.forEach(record => {
        total += record.totalPrice || 0;
      });
    }
    this.totalPrice = total;
    this.discount = 0.00;//added by suresh for discount
    this.totalWithDiscount = this.totalPrice;//added by suresh for discount
  }

  get uniqueProductCount() {
    return this.productDetailsInCart.length;
  }
  get formattedTotalPrice() {
    return this.formatNumber(this.totalPrice);
  }
  get formattedTotalWithDiscount() {
    return this.formatNumber(this.totalWithDiscount);
  }

  formatNumber(number) {
    return new Intl.NumberFormat('en-US', {
      style: 'decimal',
      minimumFractionDigits: 2,
      maximumFractionDigits: 2
    }).format(number);
  }

  handleQuantityDecrease(event) {
    this.quantity = event.target.getAttribute('data-attribute-quantity');
    if (this.quantity > 1) {
      this.quantity--;
      let currentRecordId = event.target.getAttribute('data-row-id');
      let newQuantity = this.quantity;
      let newPrice = event.target.getAttribute('data-attribute-price');
      this.updateQuantityInBackend(currentRecordId, newQuantity, newPrice);
    }
  }
  handleQuantityIncrease(event) {
    this.quantity = event.target.getAttribute('data-attribute-quantity');
    this.quantity++;
    let currentRecordId = event.target.getAttribute('data-row-id');
    let newQuantity = this.quantity;
    let newPrice = event.target.getAttribute('data-attribute-price');
    this.updateQuantityInBackend(currentRecordId, newQuantity, newPrice);
  }
  handleQuantityChange(event) {
    this.quantity = event.target.value;
    let currentRecordId = event.target.getAttribute('data-row-id');
    let newQuantity = this.quantity;
    let newPrice = event.target.getAttribute('data-attribute-price');
    clearTimeout(this.delayTimeout);
    this.delayTimeout = setTimeout(() => {
      this.updateQuantityInBackend(currentRecordId, newQuantity, newPrice);
    }, 1000);
  }
  updateQuantityInBackend(currentRecordId, newQuantity, newPrice) {
      this.isLoading1 = true;  
      updateCartItemQuantity({ itemId: currentRecordId, Quantity: newQuantity, price: newPrice })
      .then(result => {
        if(this.isGuest){
          this.refreshCart();
        }else{
            this.refreshSummary();
        }
      })
      .catch(error => {
        console.log('error in update item', error);
        this.isLoading1 = false;
      })
       .finally(() => {
       this.cartSimulateCall();
      })
  }


  async refreshSummary() {
    const response = await refreshCartSummary()
      .then((result => {
        this.isLoading = false;
        this.isEmptyCart = true;
      }));
  }

  refreshCart(){
    getActiveCartInfo({guestCartId : this.guestCartId}).then(result => {
        if(response){         
            this.activeCartId = response.Id;
            this.productsInCart = this.convertToInt(response.TotalProductCount);
            publish(this.messageContext, scc_MessageChannel, { cartCount: this.productsInCart });
            this.isLoading = false;
            this.isEmptyCart = true;
        }
    }).catch(error => {
        console.log('error in fetching guestCartDetails', error);
    })
  } 
  handlekeyPress(event) {
    const charCode = event.which ? event.which : event.keyCode;
    const currentValue = event.target.value;
    const newValue = currentValue + String.fromCharCode(charCode);
    if (charCode >= 48 && charCode <= 57) {
      if ((parseInt(newValue) >= 1 && parseInt(newValue) < 100000000)) {
        return true;
      }
      event.preventDefault();
      return false;
    }
  }
  handlePromoCode(event) {
    this.promocodeValue = (event.target.value).toUpperCase();
    this.disabledApplyButton = false;
  if (!this.promoCodeValid) {
      this.promoCodeValid = true;
      this.errorMessage = '';
    }
  }
  handlePromoCodeApply() {
 if (!JSON.parse(this.template.querySelector('.promo-apply-button').getAttribute('aria-disabled'))) {
    this.handlePromoCodeApply1();
   }
  }
  handlePromoCodeApply1() {    
    this.disabledApplyButton = true;
    getPromoCode({ promocode: this.promocodeValue,activeCartId: this.webcartId })
      .then(result => {
        if (result == true) {
          this.cartSimulateCall();
        } else {
          this.appliedPromocodeValue = '';
          this.promoCodeValid = false;
          this.discount = 0.00;
          this.totalWithDiscount = this.total;
           this.errorMessage = 'Invalid Promo Code, please check your entry';
        }
      })
      .catch(error => {
        this.cases = undefined;
        this.caseError = error;
      });
  }
  get isPromoCodeValid() {
    return this.promoCodeValid;
  }
  get inputClass() {
    return this.promoCodeValid ? 'slds-input apply-promo-input' : 'slds-input apply-promo-input error';
  }

  handleContinueShopping(event) {
   this.continueShopping = true;
     const sendCustomEventTocontinueshop = new CustomEvent("continueinputs",{
            detail:{
                currentUserInputs:this.userInputs
            }
        });
        this.dispatchEvent(sendCustomEventTocontinueshop);    
    this.cartPage = false;
  }
  handleHoldCartClick() {
    this.reviewCart = false;
    this.holdCart = true;
  }
  handleHeldCartClick() {
    this.heldCartUpdate(this.webcartName, this.webcartId);
  }
  heldCartUpdate(cartName, webcartId) {
    updateToHeldCart({ activeCartId: webcartId, name: cartName })
      .then(result => {
        this.productsInCart = 0;
        publish(this.messageContext, scc_MessageChannel, { cartCount: this.productsInCart });
        this.homePageAfterHeldCart = true;
        this.cartPage = false;
         const encodedValues = encodeDefaultFieldValues({          
    });
        this[NavigationMixin.Navigate](
        {
          type: "comm__namedPage",
          attributes: {
            name: "Home",
          },
          state: {
        defaultFieldValues: encodedValues,
            Source : 'showHeldCartMssg'
        }
        },
        true, 
      );        
      })
      .catch(error => {
        this.cases = undefined;
        this.caseError = error;
      });
  }
  handleCartNameChange(event) {
    this.webcartName = event.target.value;
  }
  get reviewCartButtonLabel() {
    return `Review Cart (${this.productsInCart})`;
  }
  get clearCartButtonLabel() {
    return `Clear Cart (${this.productsInCart})`;
  }
  handleReviewCartClick() {
    this.reviewCart = true;
    this.holdCart = false;
  }
  handleClearCartClick() {
    this.isModalOpen = true;
     setTimeout(() => {
                this.template.querySelector('.clearCartCloseBtn').focus();
              }, 100);

           this.focusCloseButton();
  }
  handleCancel() {
    this.isModalOpen = false;
    const button = this.template.querySelector(".clear-link");
      if(button){
        setTimeout(() => {
          button.focus();
        }, 100);
      }
  }
  handleClearCart() {
     this.setProductCount();
    if(this.isGuest){
      this.handleClearAllItems();
    }else{
        this.clearCartItems = true;
    }
    this.clearPromo();    
    this.homePage = true;
    this.isModalOpen = false;
    this.cartPage = false;

//Redirect to Multi home page
      this[NavigationMixin.Navigate](
        {
          type: "comm__namedPage",
          attributes: {
            name: "Home",
          },
        },
        true,
      );
  }
  clearPromo(){
    if(this.validPromo !== undefined && this.validPromo !== ''){
      clearPromoCode({ activeCartId: this.activeCartId})
    .then(() => {
      if (this.enableLogs)  console.log('updated');
    })
    .catch((e) => {
        console.error('clear promocode error ',e);
    });   
    } 
  }

  handleClearAllItems(){
    this.isLoading = true;
    deleteAllCartItems({ activeCartId: this.activeCartId })
    .then(() => {
        const customEvent = new CustomEvent('refreshevent');
        this.dispatchEvent(customEvent);
        this.refreshCart();
        this.setProductCount();   
    })
    .catch((e) => {
        console.error('lwc delete all cart items error - ',e);
    });
  }

   setProductCount(){
        this.productsInCart = 0; 
        publish(this.messageContext, scc_MessageChannel, { cartCount: this.productsInCart });
    }

  closeDeleteModal(){
    this.openDeleteModel = false;
    const button = this.template.querySelector(".delete-icon");
      if(button){
        setTimeout(() => {
          button.focus();
        }, 100);
      }
  }
  closeModal() {
    this.isModalOpen = false;
    const button = this.template.querySelector(".clear-link");
      if(button){
        setTimeout(() => {
          button.focus();
        }, 100);
      }
  }
  handleDeleteIconClick(event) {
    this.currentRecordIdToRemove = event.target.getAttribute('data-row-id');
    this.openDeleteModel = true;
     setTimeout(() => {
                this.template.querySelector('.removeCartCloseBtn').focus();
              }, 100);
           this.focusCloseButton();
  }

  handleKeyDown(event) {
        if (event.key === 'Enter') {
            this.handleDeleteIconClick(event);
        }
  }

  handleCancelDelete() {
    this.openDeleteModel = false;
    const button = this.template.querySelector(".delete-icon");
      if(button){
        setTimeout(() => {
          button.focus();
        }, 100);
      }
  }
  handleRemoveItem() {
    if(this.isGuest){
      this.handleDeleteCartItem(this.currentRecordIdToRemove);
    }else{
      this.cartItemRemoved(this.currentRecordIdToRemove);
    }
    this.isLoading = true;
  }

  handleDeleteCartItem(cartItemId){
    deleteCartItem({ cartItemId: cartItemId })
    .then(() => {
        this.refreshCart();  
        this.cartSimulateCall(); 
        this.isLoading = false;
        this.openDeleteModel = false;       
    })
    .catch((e) => {
        console.error('Error in deleting cart item - ',e);
    });
  }

  handleCheckout() {
    this.cartPage = false;
    this.showCheckOutDetails = true;
  }

  handleERPSubmit(){
    this.isERPOrderSubmitted = true;
    this.holdCart = true;
    createERPOrder({
      cartId: this.guestCartId, accountId: this.guestAccountId
    }).then(response => {
      if (this.enableLogs)  console.log('createerporder',response)
      this.orderId = response;
    }).catch(error => {
      console.log('createERPOrder error>>>>',error);
    });
  }

  callOrderSimulate(){
    createSAPOrder({ recordId: this.orderId, appSettingsName: 'ensxtx_SR_enosixOrderB2BAppSettings' })
    .then(({ data, messages }) => {
        if(data.IsSuccess){
         if (this.enableLogs)   console.log('createSAPOrder IsSuccess>>>',data);  
        }
        this.responseBody = JSON.stringify(data.TransactLogs);
        this.logType ='Enosix Order Simulation';
        this.requestBody = this.orderId;
        this.statusLog= 'Success';
        this.internalStatus='';
        this.createLogs(this.logType,this.requestBody,this.responseBody,this.statusLog,this.internalStatus,'Scc_reviewCartPage/callOrderSimulate/createSAPOrder');

    }).catch(error => {
      console.log('createSAPOrder error>>>>',error);
      this.logType ='Enosix Order Simulation';
      this.requestBody =this.orderId;
      this.statusLog= 'Error';
      this.internalStatus=JSON.stringify(error);
      this.createLogs(this.logType,this.requestBody,this.responseBody,this.statusLog,this.internalStatus,'Scc_reviewCartPage/callOrderSimulate/createSAPOrder');

    });
  }
  
  closeCheckOutDetails() {
    this.cartPage = true;
    this.showCheckOutDetails = false;
    this.handleFetchCartData();
  }
  async cartItemRemoved(cartItemId) {
    try {
      const response = await deleteItemFromCart(cartItemId).then((result => {
      this.refreshSummary();
      this.handleFetchCartData(); 
      this.fetchCurrentCart();
      this.handleReviewCart();
      this.openDeleteModel = false;
        }));
    } catch (error) {
      console.error(error);
    } finally {
    }
  }

  @track discountValue=0.00;
  @track discountValueData;
  @track finalPrice;
  @track showDiscount = false;

      handleFetchCartData() {
        fetchCartDetails({cartId: this.activeCartId})
        .then( response => {
            let TotalPriceData = response.SubTotal && response.SubTotal !=0 ? '$ '+response.SubTotal : '$ 0.00';
            this.subTotalPriceData = this.formatPrice(TotalPriceData);
            this.validPromo = response.Coupon ? response.Coupon : '';
            if (response.CouponDiscount == 0 || response.CouponDiscount == null || response.CouponDiscount == undefined ){
              this.showDiscount = false;
            } else{
              this.showDiscount = true;
            }
            this.discountValueData = response.CouponDiscount && response.CouponDiscount !=0 ? '-$ '+(response.CouponDiscount).replace('-','') :  '-';
            let totalPriceValueData =  response.subTotalReviewCart && response.subTotalReviewCart !=0 ? '$ '+response.subTotalReviewCart : '$ 0.00';
             this.totalPriceValue = this.formatPrice(totalPriceValueData);
        })
        .catch(error => {
            console.log('Fetch Cart checkout error>>>>',error);
        })
    }
  focusCloseButton() {
        const closeButton = this.template.querySelector('[data-id="closeButton"]');
        if (closeButton) {
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
      })
      .catch(error => {
          console.log('error is', error);
      })
  } 

  closeEmailModal(){
    this.isOpen= false;
    const button = this.template.querySelector(".emailCartbtn");
      if(button){
        setTimeout(() => {
          button.focus();
        }, 100);
      }
  }
}