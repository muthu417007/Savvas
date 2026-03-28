/********************************************************************************************* 
* @Component Name  - Scc_emailCartLWC
* @description - This component is used to display the email cart modal window
* @Created By  - CTS - Sagar Verma
* @Created On - 06/05/2024 
* ********************************************************************************************/

import { LightningElement,api, track  } from 'lwc';
export default class Scc_emailCartLWC extends LightningElement {
  @track emailAddresses = '';
  @track isopen = false;
  @track showErrorMessage = false;
  @track errorMessage = false;
  @track emailArray = [];
  @track renderCalled = false;

  connectedCallback() {
      //to catch escape keypress for accessibility
      this.template.addEventListener('keydown', this.handleKeydown.bind(this));
  }

  disconnectedCallback() {
      // Remove the keydown event listener when the component is removed from the DOM
      this.template.removeEventListener('keydown', this.handleKeydown);
  }

  renderedCallback() {
      if(!this.renderCalled) {
          this.focusCloseButton();
          this.renderCalled = true;
      }
  }

  handleEmailChange(event) {
      this.emailAddresses = event.target.value;
      const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
      this.emailArray = this.emailAddresses.split(',').map(email => email.trim());
      const allValidEmails = this.emailArray.every(email => emailPattern.test(email));
      if(this.emailAddresses.trim() !== '' && !allValidEmails) {
          this.showErrorMessage = true;
          this.errorMessage = 'Please enter valid email addresses separated by commas.';
      } else {
          this.showErrorMessage = false;
          this.errorMessage = '';
      }
  }

  handleEmailSend(event) {
      event.preventDefault();
      const emailAddresses = this.emailAddresses;
      this.dispatchEvent(new CustomEvent('send', {
          detail: emailAddresses
      }));
  }

  // To close popup
  closeModal() {
      this.isopen = false;
      const eve = new CustomEvent('cancel', {
          detail: this.isopen
      });
      this.dispatchEvent(eve)
  }

  //close popup when user press escape key -accessibility
  handleKeydown(event) {
      // Handle the keydown event
      if(event.key === 'Escape') {
          this.closeModal();
      }
  }

  focusCloseButton() {
      // Find the close button using data-id attribute
      const closeButton = this.template.querySelector('[data-id="closeButton"]');
      if(closeButton) {
          // Focus on the close button
          closeButton.focus();
      } else {
          console.error('Close button not found');
      }
  }

  //Trap focus inside modal
  focusOutClose(event) {
      var related = event.relatedTarget;
      if(related != undefined) {
          if(related.getAttribute('data-index') != 0) {
              this.template.querySelector('.cancel-modal-button').focus();
          }
      }
  }

  focusOutButton(event) {
      var related = event.relatedTarget;
      if(related != undefined) {
          if(related.getAttribute('data-index') != 0) {
              this.template.querySelector('.closebtnOnFocus').focus();
          }
      }
  }

}