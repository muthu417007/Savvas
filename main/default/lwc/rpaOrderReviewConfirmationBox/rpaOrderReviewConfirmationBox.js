import { LightningElement, api, wire } from 'lwc';
import LightningConfirm from "lightning/confirm";
import LightningAlert from "lightning/alert";

import ORDER_OBJECT from "@salesforce/schema/Order__c";
import ID_FIELD from "@salesforce/schema/Order__c.Id";
import REVIEW_FIELD from "@salesforce/schema/Order__c.Review_Complete__c";
//Import the named import updateRecord
import { updateRecord, getRecord, getFieldValue } from "lightning/uiRecordApi";
const fields = [REVIEW_FIELD];

export default class RpaOrderReviewConfirmationBox extends LightningElement {
    @api recordId;

    @wire(getRecord, { recordId: '$recordId', fields })
    order;

    get disableButton(){
        return getFieldValue(this.order.data, REVIEW_FIELD);
    }

    async handleConfirmClick() {
        const result = await LightningConfirm.open({
            message: "Review complete for this Order?",
            variant: "default", // headerless
            label: "Order Review Complete"
        });

        //Confirm has been closed
        //result is true if OK was clicked
        if (result) {
            this.handleSuccessAlertClick();
        } else {
            //and false if cancel was clicked
            this.handleErrorAlertClick();
        }
    }

    async handleSuccessAlertClick() {
        //map the data to the fields
        const fields = {};
        fields[ID_FIELD.fieldApiName] = this.recordId;
        fields[REVIEW_FIELD.fieldApiName] = true;

        //5. Create a config object that had info about fields. 
        const recordInput = {
            fields: fields
        };
  
          //6. Invoke the method updateRecord()
        updateRecord(recordInput).then((record) => {
            console.log(record);
        });
        
        this.disable = true;
        await LightningAlert.open({
            message: "Review Complete",
            theme: "success",
            label: "Success!"
        });
    }

    async handleErrorAlertClick() {
        this.disable = false;
       /* await LightningAlert.open({
            message: `You clicked "Cancel"`,
            theme: "error",
            label: "Error!"
        });*/
    }
}