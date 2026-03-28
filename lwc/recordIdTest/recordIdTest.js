import { LightningElement, api } from 'lwc';

export default class RecordIdTest extends LightningElement {
    @api recordId;

    connectedCallback() {
        console.log('Record Id in connected callback=>'+this.recordId);
    }
}