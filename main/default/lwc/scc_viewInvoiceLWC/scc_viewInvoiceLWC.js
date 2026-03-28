/********************************************************************************************* 
 * @Component Name  - scc_viewInvoiceLWC
 * @description - View Invoice for guest users
 * @Created By  - CTS - Varshaa
 * @Created On - 06/08/2024 
 * ********************************************************************************************/
import {
  LightningElement,
  track
} from 'lwc';
import generateRADARRequest from '@salesforce/apex/scc_documents_RADAR_Controller.generateRADARRequest';
import verifyInvoice from '@salesforce/apex/scc_signInLWCController.verifyInvoice';
import getEnableConsoleLogsTrue from '@salesforce/apex/scc_headerLWC_Controller.getEnableConsoleLogsTrue';

export default class Scc_viewInvoiceLWC extends LightningElement {

  @track openModal = true;
  @track Zipcode = '';
  @track Invoice = '';
  @track Email = '';
  @track isGoDisabled = true;
  @track errorMessage = '';
  @track showErrorMessage = false;
  @track emailArray = [];
  @track emailUpdated = '';
  @track enableLogs = false;

  isRenderedCallbackCalled = false

  constructor() {
      super();

      getEnableConsoleLogsTrue().then(response => {
          this.enableLogs = response;
          if (this.enableLogs) {
              console.log('getEnableConsoleLogsTrue response is', response);
          }
      }).catch(error => {
          if (this.enableLogs) {
              console.log('error is', error);
          }
      })
  }

  renderedCallback() {
      if (this.isRenderedCallbackCalled == false) {
          const closeBtn = this.template.querySelector(".guestOrderStatusClose");
          closeBtn.focus();
          this.isRenderedCallbackCalled = true;
      }
  }

  closeModal() {
      const sendCustomEventToClosePopup = new CustomEvent("closepopup");
      this.dispatchEvent(sendCustomEventToClosePopup);
  }

  handleZipChange(event) {
      if (event.target.dataset.id == 'Zipcode') {
          this.Zipcode = event.target.value.replace(/\D/g, '');
          event.target.value = this.Zipcode;
      }
  }

  handleNumChange(event) {
      if (event.target.dataset.id == 'Email') {
          this.Email = event.target.value;
          const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
          this.emailArray = this.Email.split(',').map(email => email.trim());
          let semiColonSeperated = this.Email.replace(/,/g, ';');
          this.emailUpdated = semiColonSeperated.replace(/\s*;\s*/g, ';').trim();
          const allValidEmails = this.emailArray.every(email => emailPattern.test(email));
          if (this.Email.trim() !== '' && !allValidEmails) {
              this.showErrorMessage = true;
              this.errorMessage = 'Please enter valid email addresses separated by commas.';
          } else {
              this.showErrorMessage = false;
              this.errorMessage = '';
          }
      }
  }
  handleInvoiceChange(event) {
      this.Invoice = event.target.value.replace(/\D/g, '');
      event.target.value = this.Invoice;
      if (this.enableLogs) console.log('invoice', this.Invoice);
  }
  get inputsCheck() {
      let boolVal = true;
      if (this.Zipcode != '' && this.Invoice != '' && this.Email != '') {
          boolVal = false;
      }
      return boolVal;
  }

  focusOutButton(event) {
      var related = event.relatedTarget;
      if (related != undefined) {
          if (related.getAttribute('data-index') != 0) {
              this.template.querySelector('.siop-modal-button').focus();
          }
      }
  }
  focusOutClose(event) {
      var related = event.relatedTarget;
      if (related != undefined) {
          if (related.getAttribute('data-index') != 0 || related.getAttribute('data-id') == "inputUsername") {

              this.template.querySelector('.guestOrderStatusClose').focus();
          }
      }
  }

  handleGo(event) {
      event.preventDefault();
      if (!JSON.parse(event.target.getAttribute('aria-disabled'))) {
          this.handleSubmit();
      } else {
          this.template.querySelector('.zipcode-input').focus();
      }
  }
  handleSubmit() {

      verifyInvoice({
              invoice: this.Invoice,
              postalcode: this.Zipcode
          })
          .then(result => {
              if (result) {
                  if (this.enableLogs) console.log(result);
                  const requestData = {
                      documentNumber: this.Invoice,
                      opeartion: 'Invoice',
                      emailId: this.emailUpdated,
                      Combined: 'N',
                      IncludePOD: 'N',
                      accountNumber: '',
                      month: '',
                      year: ''
                  }
                  generateRADARRequest({
                          requestData: requestData
                      }).then(data => {
                          this.base64String = JSON.parse(data);
                          if (this.enableLogs) console.log(data);
                      })
                      .catch(error => {
                          console.log('error', error);
                      })
              }
          })
          .catch(error => {
              console.log('result error', error);
          })
      this.closeModal();
  }

  connectedCallback() {      
      this.template.addEventListener('keydown', this.handleKeydown.bind(this));
  }
  disconnectedCallback() {
      this.template.removeEventListener('keydown', this.handleKeydown);
  }
  handleKeydown(event) {
      if (event.key === 'Escape') {
          if (this.enableLogs) console.log('Escape key pressed');
          if (this.openModal) {
              this.closeModal();
          }
      }
  }
}