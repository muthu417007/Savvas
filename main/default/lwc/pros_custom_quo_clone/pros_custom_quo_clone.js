import { LightningElement, api, wire } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { NavigationMixin } from "lightning/navigation";
import { getRecord, getFieldValue } from "lightning/uiRecordApi";
import cloneQuoteContent from "@salesforce/apex/PROSCustomCloneCtrl.cloneQuoteContent";
import validateOpp from "@salesforce/apex/PROSCustomCloneCtrl.validateOpp";
import NAME_FIELD from "@salesforce/schema/CameleonCPQ__Quote__c.Name";

export default class Pros_custom_quo_clone extends NavigationMixin(
  LightningElement
) {
  @api recordId;
  @api objectApiName;
  redirect = true;
  resetpage = false;
  @wire(getRecord, {
    recordId: "$recordId",
    fields: [NAME_FIELD]
  })
  quo;

  get name() {
    return getFieldValue(this.quo.data, NAME_FIELD);
  }
  handleSubmit(event) {
    event.preventDefault(); // stop the form from submitting
    const fields = event.detail.fields;
    console.log(fields);
    try {
      validateOpp({ oppId: fields.CPQOpportunityId__c })
        .then((result) => {
          //logic to handle result... dont need a try catch

          this.template.querySelector("lightning-record-edit-form").submit(fields);
          console.debug(result);
        })
        .catch((error) => {
          const even = new ShowToastEvent({
            title: "Validation error",
            message: error.body.message,
            variant: "error"
          });
          this.dispatchEvent(even);
        });
      // this.template.querySelector("lightning-record-edit-form").submit(fields);
    } catch (e) {
      const even = new ShowToastEvent({
        title: "error!",
        message: e.body.message,
        variant: "error"
      });
      this.dispatchEvent(even);
    }
  }
  handleSuccess(event) {
    
    
    eval("$A.get('e.force:refreshView').fire();");
    const even = new ShowToastEvent({
      title: "Success!",
      message: "Record created!",
      variant: "success"
    });
    
    this.dispatchEvent(even);

    if (this.resetpage === true) {
      this.handleReset();
    }

    const updatedRecord = event.detail.id;
    cloneQuoteContent({
      srcQuoId: this.recordId,
      targetQuoId: updatedRecord,
      activeRelease: 1,
      refresh: false
    });
    console.log("onsuccess: ", updatedRecord);
    this[NavigationMixin.Navigate]({
      type: "standard__recordPage",
      attributes: {
        recordId: updatedRecord,
        objectApiName: "Account",
        actionName: "view"
      }
    });
  }
}