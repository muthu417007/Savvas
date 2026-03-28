/*
Lightning Web component: scc_viewAllHeldCartsLWC
Author: CTS (Sameer Pujari)
Created Date: 23/05/2024
Reason: See all held cart in page, rename held cart name, delete held cart, navigate to review orde by clicking held cart name
Modified Date:
*/
import { LightningElement,api, track, wire } from 'lwc';
import {NavigationMixin} from 'lightning/navigation';
import { deleteRecord } from 'lightning/uiRecordApi';
import { refreshApex } from '@salesforce/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import scc_delete_Cart_Warning_Message from "@salesforce/label/c.scc_delete_Cart_Warning_Message";
import scc_claerAll_Item_WarningContent3 from "@salesforce/label/c.scc_claerAll_Item_WarningContent3";
import { updateItemInCart,deleteItemFromCart,refreshCartSummary} from 'commerce/cartApi';
import { getSessionContext } from 'commerce/contextApi';
import scc_delete_icon from "@salesforce/resourceUrl/scc_delete_icon";
import { RefreshEvent } from 'lightning/refresh';
import getEnableConsoleLogsTrue from '@salesforce/apex/scc_headerLWC_Controller.getEnableConsoleLogsTrue' ;

//Apex class
import updateToHeldCart from '@salesforce/apex/scc_holdCartPageController.updateToHeldCart';
import updateHeldCartName from '@salesforce/apex/scc_holdCartPageController.updateHeldCartName';
import changeIsSecondaryTrue from '@salesforce/apex/scc_changeCartAsSecondary.changeActiveCartAsSecondary';
import changeHeldToActiveCart from '@salesforce/apex/scc_changeCartAsSecondary.changeHeldToActiveCart';
import getAllHeldCartRecords  from '@salesforce/apex/scc_FetchHeldCart_Controller.getAllHeldCartRecords';
import getAllHeldCartRecordsByCartName  from '@salesforce/apex/scc_FetchHeldCart_Controller.getAllHeldCartRecordsByCartName';
import deleteCartItem  from '@salesforce/apex/scc_FetchHeldCart_Controller.deleteCartItem';

const actions = [
    { label: "Select", name: "selectHeldCart" },
    { label: "Delete", name: "deleteHeldCart" },
    { label: "Show Held Cart Page", name: "openReviewCartPage" }
];

const VIEWALLHELDCARTS_COLS = [
    {
        label: "Select", type: "button", 
		typeAttributes: {
			name: "selectHeldCart",
            onclick: "handleRadioChange"
		}
    },
    {label: "Cart Name",   fieldName: "Name",  type: "button", 
        typeAttributes: {
            label: { fieldName: "Name" },
            name: "openReviewCartPage",
            variant:"base", 
            onclick: "openReviewCartPage"
        }
    },
    {label: "Ship To Name", fieldName: "Shipto_name__c", type: "text"},
    {label: "Creation Date", fieldName: "CreatedDate", type: "date",
        typeAttributes: {
            day: "2-digit",
            month: "2-digit",
            year: "2-digit"
        }
    },
    {label: "Last Modified Date", fieldName: "LastModifiedDate", type: "date",
        typeAttributes: {
            day: "2-digit",
            month: "2-digit",
            year: "2-digit"
        }
    },
    {label: "# of Items", fieldName: "TotalProductLineItemCount", type: "number" },
    {
        label: "",
		typeAttributes: {
			name: "deleteHeldCart",
            iconName: "utility:delete",
            onclick: "handleRowAction",
            variant: "brand"
		}
    },
];

    export default class Scc_viewAllHeldCartsLWC extends NavigationMixin(LightningElement) {

    viewAllHeldCartsCols = VIEWALLHELDCARTS_COLS;
    @track heldCartData = [];
    @track wiredHeldCartItems = [];
    @track reviewCartPage = false;
    @track showAllHeldCarts = true;
    @track openDeleteModel= false;
    @track isModalOpen = false;
    @track cartItemId = '';
    @api getHeldWebCartItems;
    @track cartPage = false;
    @api webCartId;
    @track showLoading = false;
    @track transformedDataLength = 0;
    @track totalCount = 0;
    @track filterCriteria;
    @track searchTerm = '';
    @track error;
    @track selectedItem ='';
    @track disableButton = true;
    @track showUpdateCartNameInput = false;
    @track webcartName;
    @track webcartId;
    @track homePageAfterHeldCart = false;
    @track isChecked = false;
    @track enableLogs = false;
    error;
    searchValue = '';
    parentValue = true;

    labels = {
        scc_delete_Cart_Warning_Message,
        scc_claerAll_Item_WarningContent3,
        scc_delete_icon
    }
  
    constructor() {
        super();
       
        getAllHeldCartRecords().then(result =>{            
            let paser = JSON.parse(JSON.stringify(result));
            this.heldCartData =  paser.map(order => {
                return {
                    ...order,
                    Shipto_name__c: order.Shipto_name__c,
                    CreatedDate: this.formatDate(order.CreatedDate),
                    LastModifiedDate: this.formatDate(order.LastModifiedDate)
                };
            });
            this.checked = false;
            this.transformedDataLength=result.length;
            this.totalCount=result.length;
        }).catch(error =>{
            console.log('error is',error);
            this.heldCartData=undefined;
            this.cartItems=undefined;
            this.error = error;
        })

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

    connectedCallback(){
        
        getAllHeldCartRecords().then(result =>{            
            let paser = JSON.parse(JSON.stringify(result));
            this.heldCartData =  paser.map(order => {
                return {
                    ...order,
                    Shipto_name__c: order.Shipto_name__c,
                    CreatedDate: this.formatDate(order.CreatedDate),
                    LastModifiedDate: this.formatDate(order.LastModifiedDate)
                };
            });
            this.transformedDataLength=result.length;
            this.totalCount=result.length;            
        }).catch(error =>{
            console.log('error is',error);
            this.heldCartData=undefined;
            this.cartItems=undefined;
            this.error = error;
        })
        refreshApex(this.getAllHeldCartRecords);
       this.template.addEventListener('keydown', this.handleKeydown.bind(this));
    }

    disconnectedCallback() {
        this.template.removeEventListener('keydown', this.handleKeydown);
    }
    
    handleKeydown(event) {
        if (event.key === 'Escape') {            
            if(this.openDeleteModel){
                this.closeModal();
            }            
        }
    }

    formatDate(dateString) {    //Added by Varshaa for W-015270
        if (!dateString) return '';
        
        const date = new Date(dateString);
        const month = String(date.getUTCMonth() + 1).padStart(2, '0'); 
        const day = String(date.getUTCDate()).padStart(2, '0');
        const year = date.getUTCFullYear();

        return `${month}/${day}/${year}`;
    }
    

    hideSpinner() {
        // Setting boolean variable to false, this will hide the Spinner
        this.showLoading = false;
    }
 
    closeModal() {        
        this.showModal = false;
        const button = this.template.querySelector(".deletebtn");
      if(button){
        setTimeout(() => {
          button.focus();
        }, 100);
      }
    }

    openReviewCartPage(event){
        
        this.cartItemId = event.target.dataset.rowId;        
        changeIsSecondaryTrue({ activeAccountId: this.currentaccountId })
            .then(result => {           
             this.showLoading = true;
            changeHeldToActiveCart({ cartId:  this.cartItemId }).then(response => {            
            this.showAllHeldCarts = false;
            this.reviewCartPage = true;
            this.showLoading = false;
                
            })
            .catch(error => {
                console.log('the error is',error);
            })
                
            })
            .catch(error => {
                this.cases = undefined;
                this.caseError = error;
                if(this.enableLogs){
                    console.log('the error is',this.caseError)
                }
            });

    }

    @wire(getAllHeldCartRecords,{
    wiredHeldCartItems(result, error){
        this.wiredHeldCartItems = result;
        if(result.data){
            this.heldCartData = result.data;
            this.cartItems = result.length;            
            this.error = undefined;            
        } else if(result.error){
            this.heldCartData = undefined;
            this.error = result.error;
            if(this.enableLogs){
                console.log('this.error',this.error);
            }
        }
    }})

    async connectedCallback() {
        let sessionContext = await getSessionContext();
        this.currentaccountId = sessionContext.effectiveAccountId;                
    }

     handleRowAction(event) {        
        this.cartItemId = event.target.dataset.rowId;        
       
        if(event.target.dataset.fieldName==='openReviewCartPage') {

             changeIsSecondaryTrue({ activeAccountId: this.currentaccountId })
            .then(result => {           
             this.showLoading = true;
            changeHeldToActiveCart({ cartId:  this.cartItemId }).then(response => {            
            this.showAllHeldCarts = false;
            this.reviewCartPage = true;
            this.showLoading = false;                
            })
            .catch(error => {
                if(this.enableLogs){
                    console.log('the error is',error);
                }
            })
                
            })
            .catch(error => {
                this.cases = undefined;
                this.caseError = error;
                if(this.enableLogs){
                    console.log('the error is',this.caseError)
                }
            });                                
        } else if (event.target.dataset.fieldName==='deleteHeldCart') {
            this.openDeleteModel = true;
        }

         setTimeout(() => {
                this.template.querySelector('.clearCartCloseBtn').focus();
              }, 100);

           this.focusCloseButton();
    }

 clearFilterInput(event){
        this.searchValue = '';

        getAllHeldCartRecords().then(result =>{            
            let paser = JSON.parse(JSON.stringify(result));
            this.heldCartData =  paser.map(order => {
                return {
                    ...order,
                    Shipto_name__c: order.Shipto_name__c,
                    CreatedDate: this.formatDate(order.CreatedDate),
                    LastModifiedDate: this.formatDate(order.LastModifiedDate)
                };
            });
            this.showUpdateCartNameInput = false;
            this.disableButton=true;
            this.transformedDataLength=result.length;
            this.totalCount=result.length;
            this.webcartName = "";
            this.isChecked = false;            
        }).catch(error =>{
            console.log('error is',error);
            this.heldCartData=undefined;
            this.cartItems=undefined;
            this.error = error;
        })

        this.error = undefined;              
    }


    handleFilter(event) {
         this.searchValue = event.target.value;
        this.searchTerm = event.target.value;        
        getAllHeldCartRecordsByCartName({ strCartName: this.searchTerm})
        .then(result => {                
                let paser = JSON.parse(JSON.stringify(result));
                this.heldCartData =  paser.map(order => {
                    return {
                        ...order,
                        Shipto_name__c: order.Shipto_name__c,
                        CreatedDate: this.formatDate(order.CreatedDate),
                        LastModifiedDate: this.formatDate(order.LastModifiedDate)
                    };
                });
                this.transformedDataLength=result.length;
                this.totalCount=result.length;                
		})
		.catch(error => {
			this.error = error;
			this.heldCartData = undefined;
            if(this.enableLogs){
                console.log('result.error>>>>',error);
            }
		})
        
    }

handleRadioChange(event){    
    this.cartItemId = event.target.dataset.rowId;
    this.webcartId = event.target.dataset.rowId;    
    this.template.querySelector(".radio-button-class");
    if (this.cartItemId){
        this.showUpdateCartNameInput = true;

        this.isChecked = true;
         this.disableButton = false;
    }
    this.disableButton ;    
}
    
    handleCartNameChange(event) {
        this.webcartName = event.target.value;       
    }

    updateCartName(){    

    updateHeldCartName({ activeCartId: this.webcartId, name: this.webcartName})
    .then(result => {
            getAllHeldCartRecords().then(result =>{                
                let paser = JSON.parse(JSON.stringify(result));
                this.heldCartData =  paser.map(order => {
                    return {
                        ...order,
                        Shipto_name__c: order.Shipto_name__c,
                        CreatedDate: this.formatDate(order.CreatedDate),
                        LastModifiedDate: this.formatDate(order.LastModifiedDate)
                    };
                });

                this.showUpdateCartNameInput = false;
                this.disableButton=true;
                this.transformedDataLength=result.length;
                this.totalCount=result.length;
                this.webcartName = "";
                this.isChecked = false;                
            }).catch(error =>{
                console.log('error is',error);
                this.heldCartData=undefined;
                this.cartItems=undefined;
                this.error = error;

            })
            this.error = undefined;                    
        }) .catch(error => {
            this.getAllHeldCartRecords = undefined;
            this.error = error;
            if(this.enableLogs){
                console.log('this.error',this.error);
            }
        });
    }    

    handleTransformedDataLength(event) {
        this.transformedDataLength = event.detail.transformedDataLength;
        if (event.detail.totalFilteredRecords) {
            this.totalFilteredRecords = event.detail.totalFilteredRecords;
            this.totalCount = this.totalFilteredRecords; // Update totalCount with totalFilteredRecords
        } else {
            this.totalCount = event.detail.totalCount; // Update totalCount with original totalRecords
        }
    }

    handleRemoveItem(){
                
        deleteCartItem({ cartItemId: this.cartItemId })
        .then(() => {
            this.showLoading = false;
            this.openDeleteModel = false;
            this.showUpdateCartNameInput = false;
            this.transformedDataLength= this.transformedDataLength - 1;
            this.totalCount=this.totalCount - 1;
            this.disableButton=true;
            getAllHeldCartRecordsByCartName({ strCartName: this.searchTerm})
            .then(result =>{                
                let paser = JSON.parse(JSON.stringify(result));            
                this.heldCartData =  paser.map(order => {
                    return {
                        ...order,
                        Shipto_name__c: order.Shipto_name__c,
                        CreatedDate: this.formatDate(order.CreatedDate),
                        LastModifiedDate: this.formatDate(order.LastModifiedDate)
                    };
                });                
                this.value = undefined;               
            }).catch(error =>{
                if(this.enableLogs){
                    console.log('error is',error);
                }
                this.heldCartData=undefined;
                this.cartItems=undefined;
                this.error = error;                
            })
        })
        .catch((e) => {
            this.showLoading = false;
            this.openDeleteModel = false;
            if(this.enableLogs){
                console.error('Error in deleting cart item - ',e);
            }
        });                
    }
    

    closeModal() {
        this.isModalOpen = false;
        this.openDeleteModel = false;
    }

    handleDeleteIconClick(event){
        this.cartItemId = event.detail.row.Id;
        this.openDeleteModel = true;                
    }

    handleCancelDelete(){
           this.openDeleteModel = false;
      const button = this.template.querySelector(".deletebtn");
      if(button){
        setTimeout(() => {
          button.focus();
        }, 100);
      }

    }

    handleCancel(){
        this.isModalOpen = false;
    }

    returnHome(){
        
    this[NavigationMixin.Navigate](
        {
          type: "comm__namedPage",
          attributes: {
            name: "Home",
          },
        },
        true, // Replaces the current page in your browser history with the URL
      );

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
}