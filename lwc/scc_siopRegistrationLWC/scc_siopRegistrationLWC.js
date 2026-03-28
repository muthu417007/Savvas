/********************************************************************************************* 
* @Component Name  - Scc_siopRegistrationLWC
* @description - Component to display user's billing and shipping address on place order tab
* @Created By  - CTS-Muthukumar
* @Created On - 03/04/2024 
* ********************************************************************************************/

import { LightningElement, track } from 'lwc';
import checkUsrInp from '@salesforce/apex/scc_checkSIOPRegistration.checkSIOPRegistration';//verify user inputs
import errormsg from '@salesforce/label/c.scc_siopNotValidOrder'
import errorMessageHelp from '@salesforce/label/c.scc_siopErrorMessage'
export default class Scc_siopRegistrationLWC extends LightningElement {

  incorrectAttempts = 0;
  @track openModal = true;
  @track closeModall = false;
  @track showerrormsg = false;
  @track showErrorMessage = false;
  @track Zipcode = '';
  @track ordernum = '';
  @track isGoDisabled = true;
  errormessage = errormsg;
  errorMessageHelpContact = errorMessageHelp;

  //focus close button when popup opens - for accessibility
  isRenderedCallbackCalled = false
  renderedCallback() {
    if (this.isRenderedCallbackCalled == false) {
      const closeBtn = this.template.querySelector(".siop-modal-close-btn");
      closeBtn.focus();
      this.isRenderedCallbackCalled = true;
    }
  }
  showModal() {
    this.openModal = true;
  }
  handleZipcodeChange(event) {
    this.Zipcode = event.target.value;
    this.inputsCheck();
  }
  handleorderChange(event) {
    this.ordernum = event.target.value;
    this.inputsCheck();
  }
  inputsCheck() {
    if ((this.Zipcode != undefined) && (this.ordernum != undefined)) {
      this.isGoDisabled = false;
    } if ((this.Zipcode == undefined || this.Zipcode == '') || (this.ordernum == undefined || this.ordernum == '')) {
      this.isGoDisabled = true;
    }
  }
  // call apex method to verify user inputs
  verifyUsrInp(event) {
    event.preventDefault();
    if (!JSON.parse(event.target.getAttribute('aria-disabled'))) {
      
      checkUsrInp({ zipcode: this.Zipcode, ordernum: this.ordernum })
        .then((result) => {
          if (result != null && result != undefined) {
            this.showerrormsg=false;//added by sudha W-016431 
            this.showErrorMessage=false;//added by sudha W-016431 
            window.location.href = result;
          } else {
            this.incorrectAttempts++;
            if (this.incorrectAttempts <= 3) {
              this.showerrormsg = true;
              setTimeout(() => {
                this.template.querySelector('.zipcode-input').focus();
              }, 100);
            }
            else {
              this.showErrorMessage = true;
              this.showerrormsg = false;
              setTimeout(() => {
                this.template.querySelector('.zipcode-input').focus();
              }, 100);
            }
          }
        })
        .catch((error) => {
          this.error = error;
          this.showerrormsg = true;
          setTimeout(() => {
            this.template.querySelector('.zipcode-input').focus();
          }, 100);
        });
    } else {
      this.template.querySelector('.zipcode-input').focus();
      event.preventDefault();
    }
  }
  // To close popup
  closeModal() {
    const sendCustomEventToClosePopup = new CustomEvent("closepopup");
    this.dispatchEvent(sendCustomEventToClosePopup);
  }
  //Trap focus inside modal - for accessibility
  focusOutClose(event) {
    var related = event.relatedTarget;
    if (related != undefined) {
      if (related.getAttribute('data-index') != 0) {
        this.template.querySelector('.siop-modal-button').focus();
      }
    }
  }
  focusOutButton(event) {
    var related = event.relatedTarget;
    if (related != undefined) {
      if (related.getAttribute('data-index') != 0) {
        this.template.querySelector('.siop-modal-close-btn').focus();
      }
    }
  }
  connectedCallback() {
    //to catch escape keypress for accessibility
    this.template.addEventListener('keydown', this.handleKeydown.bind(this));
  }
  disconnectedCallback() {
    // Remove the keydown event listener when the component is removed from the DOM
    this.template.removeEventListener('keydown', this.handleKeydown);
  }
  handleKeydown(event) {
    // Handle the keydown event
    if (event.key === 'Escape') {
      if (this.openModal) {
        this.closeModal();
      }
    }
  }
}