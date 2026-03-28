/*********************************************************
  Component Name       : sfccHeldCarts
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
import {APPLICATION_SCOPE,createMessageContext,MessageContext,publish,releaseMessageContext,subscribe,unsubscribe} from 'lightning/messageService';
import scc_MessageChannel from '@salesforce/messageChannel/scc_MessageChannel__c'; 
import Id from "@salesforce/user/Id";

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
     @wire(MessageContext) messageContext;
     @api tabselection = false;
     @track showHeldCartMsg = false;
     showheldcart=0;
     @track receivedMessage;
     @track heldCartId = '';

    labels ={
        scc_home_Held_Carts,
        scc_home_Cart_Name,
        scc_home_Date,
        scc_home_Items,
        scc_home_ViewAll

    };

  constructor() {
        super();
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

     console.log('home page tabeselextion value is',this.tabselection);
         if(this.tabselection == true){
          this.showHeldCartMsg = true;
          console.log('this.showHeldCartMsg',this.showHeldCartMsg);
        
         }else{
           this.showHeldCartMsg = false ;
         }
        this.isLoading = true;
        this.homeClass = 'active';
        getUserInformation().then(response =>{
            console.log('response is',response);
            let paser = JSON.parse(response);
            let data = paser[0];
            console.log(data);
            this.userName = data.userName;
            this.currentaccountId=data.accountId;
        }).catch(error =>{
            console.log('error is',error);
            this.isLoading=false;
        })
        this.isLoading=false;



getHeldCartRecords().then(response =>{
            console.log('heldCartData response is',response);
            let paser = JSON.parse(JSON.stringify(response));
            console.log('getHeldCartRecords',paser);
            this.heldCartData = paser.map(order => {
                return {
                    ...order,
                    CreatedDate: this.formatDate(order.CreatedDate)
                };
            });

            this.cartItems = this.heldCartData.length;
        }).catch(error =>{
            console.log('error is',error);
            // this.isLoading1=false;
        })
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



//View All action using lms
handleViewAllHeldCarts(){

    const encodedValues = encodeDefaultFieldValues({
       //  Source : 'showHeldCarts'
          
    });

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
    //     const message={
    //         lmsData:{
    //             value:'viewAllHeldCarts'
    //         }
    //     }

    //     let detail ={
    //         viewHeldCarts:{
    //             value:{
    //                 userId:this.userId
    //             } 
    //         }
    //     }

    //     let eve = new CustomEvent('displayViewAllHeldCartsPage',{detail});
    //     this.dispatchEvent(eve);

    //     publish(this.messageContext,scc_MessageChannel,message);
     }


 openReviewHeldCarts(event){
        console.log('event.currentTarget.dataset.id>>>',event.currentTarget.dataset.id);
        this.heldCartId = event.currentTarget.dataset.id;
        console.log('this.currentaccountId>>>',this.currentaccountId);
        console.log('this.heldCartId>>>',this.heldCartId);
        
        changeActiveCartAsSecondary({ activeAccountId: this.currentaccountId })
            .then(result => {
            console.log('changeActiveCartAsSecondary result>>>>',result);
                changeHeldToActiveCart({ cartId:  this.heldCartId }).then(response => {
                    console.log('this.heldCartId>>>> ',this.heldCartId);
                    
                    console.log('changeHeldToActiveCart response',response);
                        
 const encodedValues = encodeDefaultFieldValues({
       //  Source : 'showHeldCarts'
          
    });
    this[NavigationMixin.Navigate] ({
        type: 'comm__namedPage',
        attributes: {
                name : 'Place_Order__c'  //Api name
          },
        state: {
        defaultFieldValues: encodedValues,
            Source : 'reviewHeldCart',
            //HeldCart1 :this.heldCartId
            
        }
        })
                        // const message={
                        //     lmsData:{
                        //         value:'openReviewHeldCarts'
                        //     }
                        // }
                
                        // let detail ={
                        //     reviewHeldCarts:{
                        //         value:{
                        //             //cartId:this.heldCartId
                                    
                        //         } 
                        //     }
                        // }
                        //console.log('cartId>>>> ',cartId);
                        // let eve = new CustomEvent('displayReViewAllHeldCartsPage',{detail});
                        // this.dispatchEvent(eve);

                        // publish(this.messageContext,scc_MessageChannel,message);

                    })
                    .catch(error => {

                        console.log('the error is',error);
                    })
                    
            })
            .catch(error => {
                console.log('the error is',error)
            });       
    }


    // openReviewHeldCarts(event){
    //     console.log('event.currentTarget.dataset.id>>>',event.currentTarget.dataset.id);
    //     this.heldCartId = event.currentTarget.dataset.id;
    //     console.log('this.currentaccountId>>>',this.currentaccountId);
    //     console.log('this.heldCartId>>>',this.heldCartId);
    //     changeActiveCartAsSecondary({ activeAccountId: this.currentaccountId })
    //         .then(result => {
    //         console.log('held cart success result',result);
    //        console.log('held cart success');
                
    //         })
    //         .catch(error => {
    //             console.log('the error is',error)
    //         });

    //     changeHeldToActiveCart({ cartId:  this.heldCartId }).then(response => {
    //         console.log('held cart success result',response);
    //         console.log('active cart success');
                
    //         })
    //         .catch(error => {

    //             console.log('the error is',error);
    //     })

    //     const message={
    //         lmsData:{
    //             value:'openReviewHeldCarts'
    //         }
    //     }

    //     let detail ={
    //         reviewHeldCarts:{
    //             value:{
    //                 cartId:this.heldCartId
    //             } 
    //         }
    //     }

    //     let eve = new CustomEvent('displayReViewAllHeldCartsPage',{detail});
    //     this.dispatchEvent(eve);

    //     publish(this.messageContext,scc_MessageChannel,message);
    //  }

    openHeldCart(event){
        console.log('event.currentTarget.dataset.id>>>',event.currentTarget.dataset.id);
        this.heldCartId = event.currentTarget.dataset.id;
        console.log(JSON.stringify(event.detail));
        //console.log('event.detail.action.name>>>',event.detail.action.name);
        //console.log('event.detail.row.Id>>>',event.detail.row.Id);
        
        //Added for W-014938- Varshaa
        changeIsSecondaryTrue({ activeAccountId: this.currentaccountId })
            .then(result => {
           console.log('held cart success');
                
            })
            .catch(error => {
                this.cases = undefined;
                this.caseError = error;
                console.log('the error is',this.caseError)
            });
        

            changeHeldToActiveCart({ cartId:  this.heldCartId }).then(response => {
            console.log(response);
            console.log('active cart success');
                
            })
            .catch(error => {

                console.log('the error is',error);
            })
            //End  W-014938
            this.showHeldCartMsg = false;
            this.reviewCartPage = true;
            console.log('this.showHeldCartMsg>>>',this.showHeldCartMsg);
            console.log('this.reviewCartPage>>>',this.reviewCartPage);
            console.log('after event.detail>>>',event.detail);
            
        
    }

      handleChange(event){
        this.richtext=event.target.value;
    }


  }