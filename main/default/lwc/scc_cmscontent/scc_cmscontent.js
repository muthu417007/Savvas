import { LightningElement, api, wire } from 'lwc';
import getCMSContentByContentKey from '@salesforce/apex/scc_CMS.getCMSContentByContentKey';

export default class Scc_cmscontent extends LightningElement {
    @api contentId;
  contentData;

  isLoaded = false;
  error;
  errorTitle;

  connectedCallback() {

    getCMSContentByContentKey({ ContentKey: 'MCXSAQUVSM6ZFDLKCVJCTAXT3IC4' })
      .then(result => {
        console.log('result1::', result);
        this.contentData = result;
        this.isLoaded = true;
      })
      .catch(error => {
        console.log('error1::', JSON.stringify(error));
        console.log('contentId::', JSON.stringify(this.contentId));
        this.error = error;
        this.errorTitle = 'Error retreiving CMS Content!';
        this.isLoaded = true;
      });
  }
  
  get errorMessages() {
    return this.reduceErrors(this.error);
  }

  reduceErrors(errors) {
    if (!Array.isArray(errors)) {
      errors = [errors];
    }

    return (
      errors
        // Remove null/undefined items
        .filter((error) => !!error)
        // Extract an error message
        .map((error) => {
          // UI API read errors
          if (Array.isArray(error.body)) {
            return error.body.map((e) => e.message);
          }
          // UI API DML, Apex and network errors
          else if (error.body && typeof error.body.message === 'string') {
            return error.body.message;
          }
          // JS errors
          else if (typeof error.message === 'string') {
            return error.message;
          }
          // Unknown error shape so try HTTP status text
          return error.statusText;
        })
        // Flatten
        .reduce((prev, curr) => prev.concat(curr), [])
        // Remove empty strings
        .filter((message) => !!message)
    );
  }
}