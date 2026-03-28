import { LightningElement, wire, api, track } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
export default class ErrorModalPopUp extends LightningElement {
    @api recordId; // This is passed by default when used on a record page
    @track showModal = false;
	get reactiveRecordId() {
		return this.recordId;
	}
	@wire(getRecord, { recordId: '$reactiveRecordId', fields: ['CameleonCPQ__Quote__c.PricingDateFiscalYear__c'] })
	wiredRecord(result) {
		if (result.data) {
				console.log('error 2: ',!result.data.fields.PricingDateFiscalYear__c.value);
			this.showModal = !result.data.fields.PricingDateFiscalYear__c.value;
		}
	}
    closeModal() {
        // Close the modal when the user clicks "Close"
        this.showModal = false;		
    }
}