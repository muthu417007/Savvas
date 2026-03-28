/********************************************************************************************* 
 * @Component Name  - scc_checkAccessCodeLWC
 * @description - LWC to check if access code entered by user is valid or not
 * @Created By  - CTS-Sameer Pujari
 * @Created On - 16/05/2024 
 * ********************************************************************************************/

import {
  LightningElement,
  track
} from 'lwc';
import scc_accessCodeFound from '@salesforce/label/c.scc_accessCodeFound';
import scc_accessCodeNotFound from '@salesforce/label/c.scc_accessCodeNotFound';
import checkAccessCode from '@salesforce/apex/scc_checkAccessCode.checkAccessCode';
import errormsg from '@salesforce/label/c.scc_siopNotValidOrder';
export default class scc_checkAccessCodeLWC extends LightningElement {

  @track openModal = true;
  @track closeModall = false;
  @track showValidAccessCodeMsg = false;
  @track showInValidAccessCodeMsg = false;
  @track accessCode = '';
  @track accessCodeResult = '';
  @track isCheckAccessCodeDisabled = true;
  @track INVALIDACCESSCODE = 'Not found';
  @track VALIDACCESSCODE = 'Found';
  @track checkButtonCSS = 'slds-button checkAccessCodeBtn modal-confirm-button-disabled';
  sccLabel;
  isRenderedCallbackCalled = false;

  connectedCallback() {
      this.template.addEventListener('keydown', this.handleKeydown.bind(this));
  }

  disconnectedCallback() {
      this.template.removeEventListener('keydown', this.handleKeydown);
  }

  renderedCallback() {
      if (this.isRenderedCallbackCalled == false) {
          const closeBtn = this.template.querySelector(".register-modal-close");
          closeBtn.focus();
          this.isRenderedCallbackCalled = true;
      }
  }

  showModal() {
      this.openModal = true;
      this.inputsCheck();
  }

  handleAccessCodeChange(event) {

      if (event.type == 'keypress') {
          if (event.keyCode === 8 || event.keyCode === 46) {
              this.accessCode = event.target.value;
              this.inputsCheck();
          }
          if (event.keyCode === 13 && !this.isCheckAccessCodeDisabled) {
              event.preventDefault();
              this.checkAccessCodeResponse();
          }
      } else {
          this.accessCode = event.target.value;
          this.inputsCheck();
      }

  }

  inputsCheck() {
      if (this.accessCode != undefined && this.accessCode != '') {
          this.isCheckAccessCodeDisabled = false;
          this.checkButtonCSS = 'slds-button checkAccessCodeBtn modal-confirm-button';
      } else {
          this.isCheckAccessCodeDisabled = true;
          this.checkButtonCSS = 'slds-button checkAccessCodeBtn modal-confirm-button-disabled';
          this.showValidAccessCodeMsg = false;
          this.showInValidAccessCodeMsg = false;
      }
  }

  closeModal() {
      const sendCustomEventToClosePopup = new CustomEvent("closepopup");
      this.dispatchEvent(sendCustomEventToClosePopup);

  }

  checkAccessCodeResponse(event) {
    
      event.preventDefault();
      if (!JSON.parse(event.target.getAttribute('aria-disabled'))) {
          checkAccessCode({
                  searchAccessCode: this.accessCode
              })
              .then(result => {
                console.log('searchAccessCode result>>>',result);
                const { status, CashedInDate, ExpirationDate, NumTimesCashedIn, NumCashins } = result;
                  this.accessCodeResult = result;
                  console.log('searchAccessCode result NumCashins>>>',result.NumCashins);
                  console.log('searchAccessCode result NumTimesCashedIn>>>',result.NumTimesCashedIn);
                  this.error = undefined;
                                    
                  var today = new Date();
                  var dd = String(today.getDate()).padStart(2, '0');
                  var mm = String(today.getMonth() + 1).padStart(2, '0'); //January is 0!
                  var yyyy = today.getFullYear();
                  
                  today = mm + '/' + dd + '/' + yyyy;                                    
                  
                       if (status == 'Code has EXPIRED' || status === 'Code has NOT been activated') {
                          console.log('status>>>',status);
                          this.showValidAccessCodeMsg = false;
                          this.showInValidAccessCodeMsg = true;
                          setTimeout(() => {
                              this.template.querySelector('.access-code-input').focus();
                          }, 100);
                          this.sccLabel = status;
                      } else if (status.includes('Code has been activated') && (CashedInDate != null || CashedInDate != '') && ExpirationDate > today) {
                        console.log('status>>>',status);
                        this.showValidAccessCodeMsg = true;
                        setTimeout(() => {
                            this.template.querySelector('.register-modal-close').focus();
                        }, 100);
                        this.showInValidAccessCodeMsg = false;
                        this.sccLabel = status;
                    } else if (status == 'Not found') {
                        console.log('status>>>',status);
                        this.showValidAccessCodeMsg = false;
                          this.showInValidAccessCodeMsg = true;
                          setTimeout(() => {
                              this.template.querySelector('.access-code-input').focus();
                          }, 100);
                          this.sccLabel = 'Access code NOT found';    
                        }              
              })
              .catch(error => {
                  this.error = error;
                  this.accessCodeResult = undefined;
                  console.log('error is', error);
              });
      } else {
          this.template.querySelector('.access-code-input').focus();
          event.preventDefault();
      }
  }

  focusOutClose(event) {
      var related = event.relatedTarget;
      if (related != undefined) {
          if (related.getAttribute('data-index') != 0) {
              this.template.querySelector('.checkAccessCodeBtn').focus();
          }
      }
  }

  focusOutButton(event) {
      var related = event.relatedTarget;
      if (related != undefined) {
          if (related.getAttribute('data-index') != 0) {
              this.template.querySelector('.register-modal-close').focus();
          }
      }
  }

  handleKeydown(event) {
      if (event.key === 'Escape') {
          if (this.openModal) {
              this.closeModal();
          }
      }
  }
}