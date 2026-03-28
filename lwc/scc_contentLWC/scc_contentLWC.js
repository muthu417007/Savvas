import { LightningElement, track,wire,api } from 'lwc';
import {APPLICATION_SCOPE,createMessageContext,MessageContext,publish,releaseMessageContext,subscribe,unsubscribe} from 'lightning/messageService';
import scc_MessageChannel from '@salesforce/messageChannel/scc_MessageChannel__c'; 
import getEnableConsoleLogsTrue from '@salesforce/apex/scc_headerLWC_Controller.getEnableConsoleLogsTrue' ;

export default class Scc_contentLWC extends LightningElement {
    @track homePage=true;
    @track OrderStatusPage=false;
    @track CheckPriceAvailabilityPage=false;
    @track PlaceOrderPage
    @track FileClaimPage
    @track GenerateRequestsPage
    @track RequestDocumentsPage
    @track CheckAccessCodePage
    @track receivedMessage;
    @track openReviewHeldCarts;
    @track enableLogs = false;
    tabselection;
   
    // @track sendDataToOrderStatus; //changes for W-014196 US-163 
    @wire(MessageContext) messageContext;

    connectedCallback(){
        this.subscribeMessage();

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

    disconnectedCallback(){

    }

    //changes for W-014196 US-163 starts
    handleData(event){
        this.sendDataToOrderStatus = event.detail.orderStatusData.value;
        // if(event.detail.orderStatusData.value.OrderSearchHome == true){
            this.homePage=false;
            this.OrderStatusPage=true;
        // }
        if(this.enableLogs){
        console.log('dataToOrderStatus',this.sendDataToOrderStatus);
        }
    }
    //changes for W-014196 US-163 ends

    subscribeMessage(){
        subscribe(this.messageContext,scc_MessageChannel,(message)=>{this.handleMessage(message)},{scope:{APPLICATION_SCOPE}})
    }
   

    handleMessage(message){
        this.receivedMessage=message.lmsData.value;
        if(this.enableLogs){
        console.log('data Received is',this.receivedMessage);
        }

        if('showHeldCartMsg' in message){            
            this.tabselection = true;
        }else{
              this.tabselection = false;              
        }

       if(this.receivedMessage=='home'){
        this.homePage=true;
       }else{
        this.homePage=false;
       }

       if(this.receivedMessage=='OrderStatus'){
        this.OrderStatusPage=true;
       }else{
        this.OrderStatusPage=false;
       }
       
       if(this.receivedMessage=='viewAllHeldCarts'){
        this.viewAllHeldCartsPage=true;        
       }else{
        this.viewAllHeldCartsPage=false;        
       }

       if(this.receivedMessage=='openReviewHeldCarts'){
        this.openReviewHeldCarts=true;        
       }else{
        this.openReviewHeldCarts=false;        
       }

       if(this.receivedMessage=='CheckPriceAvailability'){
            this.CheckPriceAvailabilityPage=true;
       }else{
            this.CheckPriceAvailabilityPage=false;
       }

       if(this.receivedMessage=='PlaceOrder'){
            this.PlaceOrderPage=true;
        }else{
            this.PlaceOrderPage=false;
        }

        if(this.receivedMessage=='FileClaim'){
            this.FileClaimPage=true;
        }else{
            this.FileClaimPage=false;
        }

        if(this.receivedMessage=='GenerateRequests'){
            this.GenerateRequestsPage=true;
        }else{
            this.GenerateRequestsPage=false;
        }

        if(this.receivedMessage=='RequestDocuments'){
            this.RequestDocumentsPage=true;
        }else{
            this.RequestDocumentsPage=false;
        }

        if(this.receivedMessage=='CheckAccessCode'){
            this.CheckAccessCodePage=true;
        }else{
            this.CheckAccessCodePage=false;
        }
       
    }
}