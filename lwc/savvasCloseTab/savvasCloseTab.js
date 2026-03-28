import { LightningElement } from 'lwc';
export default class SavvasCloseTab extends LightningElement {

connectedCallback() {
    window.close();
    console.log('tab closed');
    }

}