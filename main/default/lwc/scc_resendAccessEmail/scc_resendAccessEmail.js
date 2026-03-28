/*
Lightning Web component: scc_resendAccessEmail
Author: CTS (Sagar Verma)
Created Date: 26/07/2024
Reason: resend an access code via email to assist the customer.
Modified Date:
*/
import {
  LightningElement,
  api,
  track
} from 'lwc';
export default class Scc_resendAccessEmail extends LightningElement {
  @track emailAddresses = '';
  @track isopen = false;

  handleEmailChange(event) {
      this.emailAddresses = event.target.value;
      const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
      const emails = this.emailAddresses.split(',').map(email => email.trim());
      let isValid = true;
      emails.forEach(email => {
          if (!emailPattern.test(email)) {
              isValid = false;
          }
      });
      if (!isValid) {
          event.target.setCustomValidity('Please enter valid email addresses');
      } else {
          event.target.setCustomValidity('');
      }
      event.target.reportValidity();
  }

  handleEmailSend() {
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
}