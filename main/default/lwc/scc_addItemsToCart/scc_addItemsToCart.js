/********************************************************************************************* 
* @Component Name  - Scc_addItemsToCart
* @description - Generalized Component to single and multiple products to cart
* @Created By  - CTS-Muthukumar
* @Created On - 2024-05-1 
* ********************************************************************************************/
import { LightningElement, api,track } from 'lwc';
import addItemToCart from '@salesforce/apex/scc_addItemsToCartController.addItemToCart';
import getActiveCartItems from '@salesforce/apex/scc_addItemsToCartController.getActiveCartItems';
import getSessionId from '@salesforce/apex/scc_addItemsToCartController.getSessionId';
import getEnableConsoleLogsTrue from '@salesforce/apex/scc_headerLWC_Controller.getEnableConsoleLogsTrue';
export default class Scc_addItemsToCart extends LightningElement {
    @api itemsList = [];
    @track currentCartItemList = [];
    @api userselection = [];
    @track activeCartId;
    isCartModalOpen = false;
    @track activeCartProductIdList = [];
    @track duplicateItemsList = [];
    @track activeCartList = []  ;  
    sessionId;
    activecheckbox = false; 
    dontShowAgain;
    @track enableLogs = false;

    constructor(){
     
        super();
        this.retrieveSessionId();       
        
        if(sessionStorage.getItem('dontShowPopup') === 'true'){
            this.dontShowAgain = sessionStorage.getItem('dontShowPopup');
         
        }else if(sessionStorage.getItem('dontShowPopup') === 'false'){
            this.dontShowAgain = sessionStorage.getItem('dontShowPopup');
            
        }else{
            this.dontShowAgain = sessionStorage.setItem('dontShowPopup','false');
            
        }
        
       if (this.dontShowAgain) {
           this.isCartModalOpen = false;            
       }
                
    }    

    connectedCallback() {
        this.template.addEventListener('keydown', this.handleKeydown.bind(this));
        getEnableConsoleLogsTrue().then(response => {
            this.enableLogs = response;
            if (this.enableLogs) console.log('getEnableConsoleLogsTrue response is', response);
        }).catch(error => {
            if (this.enableLogs) console.log('error is', error);
        });
        if (this.enableLogs) console.log('the user selected input', this.userselection);
        this.userInputs = this.userselection;
        this.template.addEventListener('keydown', this.handleKeydown.bind(this));
        window.addEventListener('placeOrdercatalogFilterFocus', this.focusfilterinput.bind(this));
    }

    retrieveSessionId() {
        getSessionId()
            .then(result => {
                this.sessionId = result;
                if (this.enableLogs){
                    console.log('Session ID: ', this.sessionId);
                }
            })
            .catch(error => {
                if (this.enableLogs){
                    console.error('Error retrieving session ID: ', error);
                }
            });
    }
   
    
    
    @api
    get message() {
        return this.currentCartItemList

    }
    set message(value) {
        if (value) {
            this.currentCartItemList = value
            if (this.enableLogs){
            console.log( 'this.currentCartItemList', this.currentCartItemList);
            }
        }
    }
    @api
    get checkActiveCartId() {
        return this.activeCartId;
    }
    set checkActiveCartId(value) {
     
        if (value) {
            this.activeCartId = value;
            if (this.enableLogs){
            console.log('activeCartId ' + this.activeCartId)
            }

            getActiveCartItems({ activeCartId: this.activeCartId }).then(result => {
                if (result) {
                    this.activeCartList = result;
                    if (this.enableLogs){
                    console.log('activeCartItems -->' + JSON.stringify(result));
                    }
                    this.activeCartProductIdList = result.map(item=>{
                        return item.Product2Id;
                    })
                    if (this.enableLogs){
                    console.log('cartIdList -->' + this.activeCartProductIdList)
                    }
                }
            }).then(() => {
                if (this.enableLogs){
                 console.log('this.message',this.message);
                }
                 this.message = this.message.filter(cartItem => cartItem.Quantity > 0);
                this.message.forEach(cartItem => {                    
                    if (this.activeCartProductIdList.includes(cartItem.Product2Id)){
                        let index = this.activeCartList.findIndex(key=>key.Product2Id == cartItem.Product2Id)
                        if (this.enableLogs){
                        console.log('index',index);
                        }
                        if(index !==-1){
                        let duplicateItem = {'Name':cartItem.Name, 'TitleDescription':this.activeCartList[index].Product2.Description}
                        this.duplicateItemsList.push(duplicateItem);
                    }
                    }
                });
                
                let popshownalready = sessionStorage.getItem('dontShowPopup') ==='true'
                
                if(!popshownalready && this.duplicateItemsList.length > 0){
                    this.isCartModalOpen = true;
                    this.activecheckbox = false;
                  
                }             
                else {
                    if (this.enableLogs){
                    console.log('popup not come');
                    }
                    this.callApexMethod();
                    this.isCartModalOpen = false;
                    
                }

            })
        }
        else{
            this.callApexMethod();
            if (this.enableLogs){
             console.log('activeCartId23 ');
            }
  
        }
    }

    

 // call apex method to add products to cart   
    callApexMethod() {

        addItemToCart({ selectedProducts: this.message, userInputs: this.userselection })
            .then(result => {
                const customEvent = new CustomEvent('reveiewcartcount', {
                    detail: {}
                });
                this.dispatchEvent(customEvent);
            })
            .catch(
                error => {
                    if (this.enableLogs){
                    console.log('Error:', error);
                    }
                }
            );
    }

  //  To close the box
    closeCartModal() {
         
        this.isCartModalOpen = false;

        if( this.activecheckbox === true){
            sessionStorage.setItem('dontShowPopup', 'true');
            
         }
         else{
            
             sessionStorage.removeItem('dontShowPopup'); 
         }
          this.duplicateItemsList = []
    const customEvent = new CustomEvent('resetaddtocart', {
                    detail: {}
                });
                this.dispatchEvent(customEvent);
    

    }
    //Cancel button action
    handleCancelBtn() {
        // this.callApexMethod();
        
        this.isCartModalOpen = false;
        if( this.activecheckbox === true){
            sessionStorage.setItem('dontShowPopup', 'true');
            
         }
         else {
           
            sessionStorage.removeItem('dontShowPopup');
        }
         this.duplicateItemsList = []
          const customEvent = new CustomEvent('resetaddtocart', {
                    detail: {}
                });
                this.dispatchEvent(customEvent);
       
    
     
    }

  //Checkbox action 
    handleActiveProductsChange(event) {
       
        if (event.target.checked) {
            
            this.activecheckbox = true;
            sessionStorage.setItem('dontShowPopup', 'true');
            
               
        } else {
            this.activecheckbox = false;
            sessionStorage.removeItem('dontShowPopup');
        }
    }
    //Add Anyway button action
    handleAddAnyway() {
     this.callApexMethod();
     this.isCartModalOpen = false;

     if( this.activecheckbox === true){

        sessionStorage.setItem('dontShowPopup', 'true');
        
     }
else {
     
     sessionStorage.removeItem('dontShowPopup');
     
    }
    }
   

    

 disconnectedCallback() {
    
        // Remove the keydown event listener when the component is removed from the DOM
        this.template.removeEventListener('keydown', this.handleKeydown);
    }



     handleKeydown(event) {
        // Handle the keydown event
        if (event.key === 'Escape') {
            if(this.isCartModalOpen){
                this.closeCartModal();
            }
            
        }
    }

    renderedCallback(){
        this.focusCloseButton();
    }

    focusCloseButton() {
        // Find the close button using data-id attribute
        const closeButton = this.template.querySelector('[data-id="closeButton"]');
        if (closeButton) {
            // Focus on the close button
            closeButton.focus();
        } else {
            if (this.enableLogs){
            console.error('Close button not found');
            }
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


}