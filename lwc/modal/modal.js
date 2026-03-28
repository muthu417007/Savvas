import { LightningElement, api } from 'lwc';

export default class Modal extends LightningElement {
    //default size of the modal has been kept as large 
    //other possible values are medium and small
    @api modalClass = "slds-modal slds-fade-in-open slds-modal_small";
		  openModal = false;
    handleOpenModal() {
        this.openModal = true;
    }
    handleCloseModal() {
        this.openModal = false;
    }
}