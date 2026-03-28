/*********************************************************
  Component Name       : scc_heldCarts
  Created Date         : 06/10/2024  
  Author               : Cognizant (@⁠Ponraj,Jaba Raj )
  Description          : This component used in Home page and functionality related to 
                         display Held Carts.
  
  Modifications Log
  06/10/2024     Zubiya           Initial Version
*********************************************************/


import { LightningElement,track,wire,api } from 'lwc';
import {NavigationMixin} from 'lightning/navigation';
import { encodeDefaultFieldValues } from 'lightning/pageReferenceUtils';

import No_Recent_Order from '@salesforce/resourceUrl/NoRecentOrder'   //importing static resource
import getHeldCartRecords  from '@salesforce/apex/scc_FetchHeldCart_Controller.getHeldCartRecords'; //import Apex class
import changeActiveCartAsSecondary from '@salesforce/apex/scc_changeCartAsSecondary.changeActiveCartAsSecondary';
import changeHeldToActiveCart from '@salesforce/apex/scc_changeCartAsSecondary.changeHeldToActiveCart';
import getUserInformation  from '@salesforce/apex/scc_headerLWC_Controller.getUserInformation';
import Id from "@salesforce/user/Id";
import { RefreshEvent } from 'lightning/refresh';
import getEnableConsoleLogsTrue from '@salesforce/apex/scc_headerLWC_Controller.getEnableConsoleLogsTrue' ;
//import static resource
import scc_home_Held_Carts from "@salesforce/label/c.scc_home_Held_Carts"; 
import scc_home_Cart_Name from "@salesforce/label/c.scc_home_Cart_Name";
import scc_home_Date from "@salesforce/label/c.scc_home_Date";
import scc_home_Items from "@salesforce/label/c.scc_home_Items";
import scc_home_ViewAll from "@salesforce/label/c.scc_home_ViewAll";

export default class DataTable extends NavigationMixin(LightningElement) {
    
    heldCartData = []; // Initialize orders as an empty array
     noRecentHeldCartsImage = No_Recent_Order;
     cartItems;
     userId = Id;
     @api tabselection = false;
     @track showHeldCartMsg = false;
     showheldcart=0;
     @track heldCartId = '';
     @track enableLogs = false;

    labels ={
        scc_home_Held_Carts,
        scc_home_Cart_Name,
        scc_home_Date,
        scc_home_Items,
        scc_home_ViewAll

    };

  constructor() {
        super();

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
formatDate(dateString) {
        if (!dateString) return '';        
        const date = new Date(dateString);
        const month = String(date.getUTCMonth() + 1).padStart(2, '0'); // Months are zero-based
        const day = String(date.getUTCDate()).padStart(2, '0');
        const year = date.getUTCFullYear();
        return `${month}/${day}/${year}`;
    }

//Initializes component and handles data loading
   connectedCallback() {        
         if(this.tabselection == true){
          this.showHeldCartMsg = true;                  
         }else{
           this.showHeldCartMsg = false ;
         }
        this.isLoading = true;
        this.homeClass = 'active';
        getUserInformation().then(response =>{
            if(this.enableLogs){
                console.log('response is',response);
            }
            let paser = JSON.parse(response);
            let data = paser[0];
            if(this.enableLogs){
            console.log(data);
            }
            this.userName = data.userName;
            this.currentaccountId=data.accountId;
        }).catch(error =>{
            if(this.enableLogs){
                console.log('error is',error);
            }
            this.isLoading=false;
        })
        this.isLoading=false;
        
getHeldCartRecords().then(response =>{
            let paser = JSON.parse(JSON.stringify(response));
            if(this.enableLogs){
                console.log('heldCartData response is',response);
                console.log('getHeldCartRecords',paser);
            }
            this.heldCartData = paser.map(order => {
                return {
                    ...order,
                    LastModifiedDate: this.formatDate(order.LastModifiedDate)
                };
            });

            this.cartItems = this.heldCartData.length;
        }).catch(error =>{
            if(this.enableLogs){
                console.log('error is',error);
            }
            // this.isLoading1=false;
        })

        refreshApex(this.getHeldCartRecords);
   }

//Checks if there are held carts  
get hasRecentheldCarts()
   {
    return this.heldCartData.length > 0;
   }
//Returns count of held carts  
get getRecentHeldCartsCount()
   {
    return this.heldCartData.length;
   }

//redirect to place order page
handleViewAllHeldCarts(){

    const encodedValues = encodeDefaultFieldValues({
       //  Source : 'showHeldCarts'
          
    });
    this.dispatchEvent(new RefreshEvent());
   this[NavigationMixin.Navigate] ({
        type: 'comm__namedPage',
        attributes: {
                name : 'Place_Order__c'  //Api name
          },
        state: {
        defaultFieldValues: encodedValues,
            Source : 'showHeldCarts'
        }
        })
     }

 openReviewHeldCarts(event){        
        this.heldCartId = event.currentTarget.dataset.id;
        if(this.enableLogs){
            console.log('event.currentTarget.dataset.id>>>',event.currentTarget.dataset.id);
            console.log('this.currentaccountId>>>',this.currentaccountId);
            console.log('this.heldCartId>>>',this.heldCartId);
        }
        changeActiveCartAsSecondary({ activeAccountId: this.currentaccountId })
            .then(result => {            
                changeHeldToActiveCart({ cartId:  this.heldCartId }).then(response => {
                    if(this.enableLogs){
                    console.log('this.heldCartId>>>> ',this.heldCartId);                
                    console.log('changeHeldToActiveCart response',response);
                    }
            //redirect to place order page                      
    const encodedValues = encodeDefaultFieldValues({
          
    });
    this[NavigationMixin.Navigate] ({
        type: 'comm__namedPage',
        attributes: {
                name : 'Place_Order__c'  //Api name
          },
        state: {
        defaultFieldValues: encodedValues,
            Source : 'reviewHeldCart',
            
        }
        })
                    })
                    .catch(error => {
                        if(this.enableLogs){
                        console.log('the error is',error);
                        }
                    })                    
            })
            .catch(error => {
                if(this.enableLogs){
                console.log('the error is',error)
                }
            });       
    }

    openHeldCart(event){        
        this.heldCartId = event.currentTarget.dataset.id;        
        
        //Added for W-014938- Varshaa
        changeIsSecondaryTrue({ activeAccountId: this.currentaccountId })
            .then(result => {
                if(this.enableLogs){
                    console.log('held cart success');
                }
            })
            .catch(error => {
                this.cases = undefined;
                this.caseError = error;
                if(this.enableLogs){
                    console.log('the error is',this.caseError)
                }
            });
        
            changeHeldToActiveCart({ cartId:  this.heldCartId }).then(response => {
                if(this.enableLogs){
                    console.log(response);
                    console.log('active cart success');
                }
            })
            .catch(error => {
                if(this.enableLogs){
                    console.log('the error is',error);
                }
            })
            //End  W-014938
            this.showHeldCartMsg = false;
            this.reviewCartPage = true;
    }
    toggleResultFields(event){
        let parentDiv = event.target.closest(".dropdown-container-mobile");
        let arrayEle = parentDiv.querySelectorAll('.full-width-in-mobile');        
        for (let i = 0; i < arrayEle.length; i++ ) {
            arrayEle[i].classList.toggle('slds-show');
        }
        event.target.classList.toggle("chevron-up");
    }

  }