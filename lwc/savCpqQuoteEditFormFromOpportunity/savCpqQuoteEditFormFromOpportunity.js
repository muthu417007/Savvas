import { LightningElement, api, wire, track } from 'lwc';  
import { refreshApex } from '@salesforce/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent'
import { NavigationMixin } from 'lightning/navigation';
import getOppInfo from '@salesforce/apex/SavCpqQuoteController.getOppInfo';
import getPrimaryContact from '@salesforce/apex/SavCpqQuoteController.getPrimaryContact';
import getQuotePricebook from '@salesforce/apex/SavCpqQuoteController.getQuotePricebook';

export default class SavCpqQuoteEditFormFromOpportunity extends NavigationMixin(LightningElement) {

    @api recId;  
    //set with @track if need javascript flags
    @track opportunity
    @track hasPrimaryContact;
    @track account;
    @track oppName;
    @track primaryQuote;
    @track primaryContact;
    @track quotePricebookId;
    @track wiredResults = [];
    formSubmitting = false;
    // Ensure that these profile names get updated if the respective Org's Profile's Name get updated
    icomRep = 'ICOM Sales Rep';
    icomManager = 'ICOM Sales Mgr';
    sysAdmin = 'System Administrator';
    // NEW added new profiles icomSDManager and icomProsAdmin 
    icomSDManager = 'ICOM Sales Data Mgr';
    icomProsAdmin = 'ICOM PROS Admin';
    @track ownerProfile;

    // grabs additional fields from opportunity and maps their values to variables
    @wire(getOppInfo, { oppId: '$recId' })  
    opportunity({ error, data }) {  

        if (data) {
            console.log("Opp info updated");
            console.log('Data', JSON.stringify(data));
            console.log('Account Id', JSON.stringify(data.AccountId));
            this.opportunity = data;
            this.account = data.AccountId;
            this.oppName = data.Name;
            console.log('Profile:', JSON.stringify(data.Owner.Profile.Name));
            this.ownerProfile = data.Owner.Profile.Name;
            console.log('this.ownerProfile:', this.ownerProfile);
        } 
    }

    @wire (getQuotePricebook)
    quotePricebook({error, data}) {
        if (data) {
            console.log('Quote Pricebook Id', JSON.stringify(data.Id));
            this.quotePricebookId = data.Id;
        }
    }

    // lifecycle hook - on render
    renderedCallback() {
        const inputFields = this.template.querySelectorAll(
            'lightning-input-field'
        );
        if (inputFields && this.opportunity && this.quotePricebookId) {
            refreshApex(this.wiredResults);
            // change these fields to SBQQ Quote ones
            inputFields.forEach(field => {
                // added Quote_Name__c
                if(field.fieldName == 'Quote_Name__c') {
                    field.value = '';

                } if (field.fieldName == 'SBQQ__Account__c') {
                    // console.log('this.account', this.account);
                    // field.value = this.account;

                } if (field.fieldName == 'SBQQ__Opportunity2__c'){
                    field.value = this.recId;

                    // removed Future_Ship_Start_Date__c from check
                } if (field.fieldName == 'CPQ_Future_Pricing_Date__c') {
                    // removed October 1st assignment, and instead assigns today to fieldValue
                    // defaulting these date fields to Today's date
                    const today = new Date();
                    const year = today.getFullYear();
                    const month = String(today.getMonth() + 1);
                    const day = String(today.getDate());
                    
                    // Date field needs this specific format to default properly
                    field.value = `${year}-${month}-${day}`;

                    
                } if (field.fieldName == 'SBQQ__Primary__c') {
                    // updated so Primary is always true
                    field.value = true;

                } if (field.fieldName == 'SBQQ__PriceBook__c') {
                    // Defaulting the quote pricebook id
                    field.value = this.quotePricebookId;
                }

            });
        }
    }

    // Inserts a new related Quote unless primary contact role from opportunity does not exist or a SBQQ__Quote__c already exists
    handleSubmit(event) {
        console.log('handleSubmit');
        event.preventDefault(); // stop the form from submitting

        const fields = event.detail.fields;

        // querying primary contact roles
        getPrimaryContact({ oppId: this.recId })
            .then(result => {
                console.log('Returned from Controller: ' + JSON.stringify(result));
                
                // If a Primary Opportunity Contact Role is returned continue
                if (result) {
                    this.primaryContact = result.ContactId;
                    console.log('this.ownerProfile:', this.ownerProfile);
                    console.log('this.icomRep', this.icomRep);
                    console.log('this.icomManager', this.icomManager);
                    console.log('this.sysAdmin', this.sysAdmin);
                    
                    // NEW added new profiles icomSDManager and icomProsAdmin to validation check
                    // Check if Opportunity Owner Profile is ICOM Sales Rep or Mgr or Sys Admin
                    if (this.ownerProfile === this.icomRep || this.ownerProfile === this.icomManager || this.ownerProfile === this.sysAdmin
                        || this.ownerProfile === this.icomSDManager || this.ownerProfile === this.icomProsAdmin
                    ) {
                        // Creates the new Quote if formSubmitting is false
                        if (this.formSubmitting != true) {   
                            this.formSubmitting = true;
                            this.template.querySelector('lightning-record-edit-form').submit(fields);
                            refreshApex(this.wiredResults);
                        }
                    }
                    
                    // NEW Otherwise prevent new Quote if the Opportunity Owner Profile is not any of the approved Profiles
                    else {   
                        const event = new ShowToastEvent( {
                            title: 'No ICOM Sales Rep or Manager',
                            message: 'Opportunity\'s Owner Profile lacks privileges to create a Quote. Please contact your System Admin.',
                            variant: 'error'
                        });
                        this.dispatchEvent(event);
                    }
                
                // Prevents new Quote if no primary contact roles exist, dispatches message to user
                } else {
                    this.primaryContact = null;
                    const event = new ShowToastEvent( {
                        title: 'No Primary Contact',
                        message:  'Please add a primary contact to the opportunity contact roles.',
                        variant: 'error'
                    });
                    this.dispatchEvent(event);
                }
            })
            .catch(error => {
                console.log('Primary Contact Id Error ' + JSON.stringify(error));
                this.primaryContact = null;
            });  
    }

    // on success directs user to new Quote
    handleSuccess(event) {
        refreshApex(this.wiredResults);
        const toast = new ShowToastEvent( {
            title: 'Success',
            message:  'Quote Successfully Created',
            variant: 'success'
        });
        this.dispatchEvent(toast);
        // View a custom object record.
        this[NavigationMixin.Navigate]( {
            type: 'standard__recordPage',
            attributes: {
                recordId: event.detail.id,
                objectApiName: 'SBQQ__Quote__c', // objectApiName is optional
                actionName: 'view'  
            }
        });
    }

    // error handling
    handleError(event) {
        this.template;
        this.formSubmitting = false;
    }
}