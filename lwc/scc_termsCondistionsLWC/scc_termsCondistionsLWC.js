import { LightningElement } from 'lwc';
export default class Scc_termsCondistionsLWC extends LightningElement {
    
handleprivacyclose(event){
    event.preventDefault();
window.close();
}
}