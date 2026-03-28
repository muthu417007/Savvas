import { LightningElement, api, track } from 'lwc';

export default class Scc_emailCart extends LightningElement { 
    @track emailAddresses = '';
    @track isopen = false;

    handleEmailChange(event) {
          this.emailAddresses = event.target.value;
          } 
          handleEmailSend() {
                const emailAddresses = this.emailAddresses;
                this.dispatchEvent(new CustomEvent('send', { detail:  emailAddresses }));
 }  
            // To close popup
closeModal() {
  this.isopen = false;
  const eve = new CustomEvent('cancel',{
          detail:this.isopen
      });
      this.dispatchEvent(eve)

}

}