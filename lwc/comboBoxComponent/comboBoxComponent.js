import { LightningElement, api } from 'lwc';

export default class ComboboxBasic extends LightningElement {
    value;

    @api
    difference;
    
    @api
    counter = 1;
    
    @api
    selectedVal;

    @api
    options = [];
    
    connectedCallback() {
       while(this.counter <= this.difference){
            this.options.push({ label: this.counter, value: this.counter+'' });
            this.counter++;
        }
        return this.options;
    }


    handleChange(event) {
        this.value = event.detail.value+'';
        this.selectedVal = event.detail.value;
    }
}