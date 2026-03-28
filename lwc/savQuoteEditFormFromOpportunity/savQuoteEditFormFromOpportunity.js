import { LightningElement, api, wire, track } from 'lwc';  
import { refreshApex } from '@salesforce/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent'
import { NavigationMixin } from 'lightning/navigation';
import getQuotes from '@salesforce/apex/SavQuoteController.getQuotesOnOpp';
import getOppInfo from '@salesforce/apex/SavQuoteController.getOppInfo';
import getPrimaryContact from '@salesforce/apex/SavQuoteController.getPrimaryContact';

export default class SavQuoteEditFormFromOpportunity extends NavigationMixin(LightningElement) {

    @api recId;  
    //set with @track if need javascript flags
    @track hasPrimaryContact;
    @track hasQuote;
    @track account;
    @track oppName;
    @track primaryContact;
    @track wiredResults = [];
    formSubmitting = false;
/* 
    @wire(getQuotes, { oppId: '$recId' })
    getQuotes({ error, data }) {  
        
        if (data) {
            this.hasQuote = true;
            
        } else {

            this.hasQuote = false;

        }
    } */

    @wire(getQuotes, { oppId: '$recId' })
    getQuotes(result) {
        this.wiredResults = result;
        if (result.data) {
            this.hasQuote = true;
        } else {
            this.hasQuote = false;
        }
    }

    @wire(getOppInfo, { oppId: '$recId' })  
    opportunity({ error, data }) {  

        if (data) {

            console.log("Opp info updated");
            this.account = data.AccountId;
            this.oppName = data.Name;

        } 
    }
 
    /*
    @wire(getPrimaryContact, { oppId: '$recId' })  
    primaryContactId(results ) {  

        this.wiredResults = data;
        if (data) {
            console.log("Primary Contact Id updated "+ data.ContactId);
            this.primaryContact = data.ContactId;
            
        } 
    }*/

    renderedCallback() {
        const inputFields = this.template.querySelectorAll(
            'lightning-input-field'
        );
        if (inputFields) {
            refreshApex(this.wiredResults);
            inputFields.forEach(field => {
                if(field.fieldName == 'Name') {
                    field.value = '';

                } if (field.fieldName == 'CameleonCPQ__AccountId__c') {
                    field.value = this.account;

                } if (field.fieldName == 'CPQOpportunityId__c'){
                    field.value = this.recId;

                } if (field.fieldName == 'CameleonCPQ__PrimaryContactId__c') {
                    field.value = this.primaryContact

                }
            });
        }
    }

    handleSubmit(event) {
        event.preventDefault(); // stop the form from submitting

        const fields = event.detail.fields;
        getPrimaryContact({ oppId: this.recId })
            .then(result => {
                console.log('Returned from Controller: ' + JSON.stringify(result));
                if(result){
                    this.primaryContact = result.ContactId;
                    //getQuotes();
                    if(this.hasQuote){
                        const event = new ShowToastEvent( {
                            title: 'Quote Exists',
                            message:  'A quote on this Opp already exists, check the related lists.',
                        });
                        this.dispatchEvent(event);
            
                    } else if (this.formSubmitting != true){   
                        this.formSubmitting = true;
                        this.template.querySelector('lightning-record-edit-form').submit(fields);
                        refreshApex(this.wiredResults);
                    }
                }else {
                    this.primaryContact = null;
                    const event = new ShowToastEvent( {
                        title: 'No Primary Contact',
                        message:  'Please add a primary contact to the opportunity contact roles.',
                    });
                    this.dispatchEvent(event);
                }
            })
            .catch(error => {
                console.log('Primary Contact Id Error ' + JSON.stringify(error));
                this.primaryContact = null;
            });

       
    }

    handleSuccess(event) {
        eval("$A.get('e.force:refreshView').fire();");
        const payload = event.detail;

        const updatedRecord = event.detail.id;
        refreshApex(this.wiredResults);
        // View a custom object record.
        this[NavigationMixin.Navigate]( {
            type: 'standard__recordPage',
            attributes: {
                recordId: event.detail.id,
                objectApiName: 'CameleonCPQ__Quote__c', // objectApiName is optional
                actionName: 'view'
                
            }
        });
    }

    handleError(event) {
        this.template;
        this.formSubmitting = false;
    }
}