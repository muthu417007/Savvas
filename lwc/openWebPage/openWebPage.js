/**
 * @description       : LWC for navigating to a record or a webpage, depending on input criteria
 * @author            : Ryan Schmitt
 * @group             : 
 * @last modified on  : 03-13-2023
 * @last modified by  : Ryan Schmitt
 * Modifications Log
 * Ver   Date         Author         Modification
 * 2.0   03-13-2023   Ryan Schmitt   Initial Version
**/
import { LightningElement, api} from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import customAction from '@salesforce/apex/openWebPageController.getCustomAction';
import {FlowNavigationFinishEvent,FlowNavigationNextEvent} from 'lightning/flowSupport';

const QUOTE_API_NAME = 'SBQQ__Quote__c';

export default class OpenWebPage extends NavigationMixin (LightningElement) {
    @api objectName;
    @api newRecordId;
    @api productScreen;
    @api destinationURL;
    @api openNewWindow;
    @api NavigateToNextScreen;
    @api FinishFlow;
    sfdcBaseURL;
    @api availableActions = []; //Used to check which navigation actions the current Flow Screen has.
    
    
    //connected callback will get base URL from Saleforce and append newRecordId from Flow. 
    async connectedCallback() {
        //SBQQ__Quote__c is the objectName, productScreen set to true, and openNewWindow is set to true
        if((this.objectName == QUOTE_API_NAME) && (this.productScreen)){  
            // Get Product Custom Action from Database  
            let actionId = await customAction();
            this.sfdcBaseURL = '/apex/sbqq__sb?id=' + this.newRecordId +'#/product/lookup?qId=' + this.newRecordId + '&aId=' + actionId;
            if(this.openNewWindow){
                this.navigateToURLNewWindow();
            } else {
                this.navigateToURL();
            }
            
        //SBQQ__Quote__c is the objectName and productScreen is false, and the openNewWindow is true
        } else if(this.objectName == QUOTE_API_NAME){        
            this.sfdcBaseURL = '/apex/sbqq__sb?id=' + this.newRecordId;
            if(this.openNewWindow){
                this.navigateToURLNewWindow();
            } else {
                this.navigateToURL();
            }
               
        //this will open up the entered URL in same Window
        } else if(this.destinationURL!= null){
            this.sfdcBaseURL = this.destinationURL;
            this.navigateToURL();
                
        //If objectName is not Quote, then it will open the record inserted in the objectName in same window
        } else {
            if(this.openNewWindow){
                this.navigateToRecordPageNewWindow();               
            } else {
                this.navigateToRecordPage();
            }
        }

        if(this.NavigateToNextScreen == true){
            this.handleNext();
        }

        if(this.FinishFlow == true){
            this.handleFinish();
        }
        
    }

    //function for Navigating to a record page
    navigateToRecordPage() {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                objectApiName: this.objectName,
                recordId : this.newRecordId,
                actionName : 'view'
            }
        });
    }

    //function for Navigating to a record page
    navigateToRecordPageNewWindow() {
        this[NavigationMixin.GenerateUrl]({
            type: 'standard__recordPage',
            attributes: {
                objectApiName: this.objectName,
                recordId : this.newRecordId,
                actionName : 'view'
            }
        }).then(url=> {
            window.open(url,'_blank');
        });

        if(this.NavigateToNextScreen == true){
            this.handleNext();
        }

        if(this.FinishFlow == true){
            this.handleFinish();
        }
    }

    //function for Navigating to webPage
    navigateToURL() {
        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                url: this.sfdcBaseURL
            }
        });
    }

     //function for Navigating to a record page
     navigateToURLNewWindow() {
        this[NavigationMixin.GenerateUrl]({
            type: 'standard__webPage',
            attributes: {
                url: this.sfdcBaseURL
            }
        }).then(url=> {
            window.open(url,'_blank');
        });
    }

    //Function for Navigating to Next Screen in a Flow.
    handleNext(event) {
        if (this.availableActions.find((action) => action === 'NEXT')){
            const nextNavigationEvent = new FlowNavigationNextEvent();
            this.dispatchEvent(nextNavigationEvent);
        }
    
    }

     //Function for Finishing a Flow.
     handleFinish(event) {
        if (this.availableActions.find((action) => action === 'FINISH')){
            const finishEvent = new FlowNavigationFinishEvent();
            this.dispatchEvent(finishEvent);
        }       
    }
}