import { LightningElement, api, wire } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import NUMBER_FIELD from '@salesforce/schema/Order__c.Name';
const fields = [NUMBER_FIELD];


export default class Rpa_sappricecheck extends LightningElement {

    @api errorMessageToDisplay;
    @api recordId;
    @api isOnLoad;
    isSuccess = false;

    @wire(getRecord, {
        recordId: "$recordId",
        fields
      })order;
    
    get number() {
        return getFieldValue(this.order.data, NUMBER_FIELD);
    
    }

    connectedCallback(){  
        console.log('record Id', this.recordId);
        if(this.errorMessageToDisplay == 'Success')
            this.isSuccess = true;
        else
            this.isSuccess = false;
    }
}