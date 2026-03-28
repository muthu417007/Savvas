import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { FlowNavigationNextEvent } from 'lightning/flowSupport';

export default class ServiceAppointmentAttributeComp extends LightningElement {

@api
selectedVal;

@api
counter = 1;

@api
options = [];

@api
selectedId;

myValue ;

actionClicked;

@api
availableActions = [];

hasError = false;
recordCount=0;

connectedCallback() {
       while(this.counter <= this.selectedVal){
            this.options.push({ label: this.counter, value: this.counter+'' });
            this.counter++;
        }
        this.myValue = this.selectedId+'';
        return this.options;
    }

handleSuccess(event){
    event.preventDefault();
    this.recordCount = this.recordCount+1;
    console.log('onsuccess event recordEditForm'+
    JSON.stringify(event.detail.fields));
    if(!this.hasError && this.recordCount >= (this.options.length)){
        if (this.availableActions.find((action) => action === "NEXT")) {
            const navigateNextEvent = new FlowNavigationNextEvent();
            this.dispatchEvent(navigateNextEvent);
        }
    }
}


handleError(event){
    this.recordCount = this.recordCount+1;
    event.preventDefault();
    event.stopImmediatePropagation();
    this.hasError = true;
    console.log('onerror event recordEditForm '+
    JSON.stringify(event.detail.detail));
}

handleSave(event){

    console.log('onsuccess event recordEditForm'+
    JSON.stringify(event.detail.fields));

}

handleSubmit(event) {
    this.hasError = false;
    this.recordCount=0;
    event.preventDefault();
    let isVal = true;
    if (isVal) {
        this.template.querySelectorAll('lightning-record-edit-form').forEach(element => {
            element.submit();
        });
    }

}

}