/*
Lightning Web component:Scc_relatedTitleDetailLWC
Author: CTS (MuthuKumar)
Created Date: 03/04/2024
Reason: To fetch and display related products details
Modified Date: 15/04/2024
*/

import { LightningElement,wire,track,api } from 'lwc';
import getRelatedProductdetail  from '@salesforce/apex/scc_relatedProductsLWC_Controller.getRelatedproductsDetail';

export default class Scc_relatedTitleDetailLWC extends LightningElement {
    @track DisplayISBN;
      @api message;
      @api isbn;
    relatedProducts;
      connectedCallback(){
        getEnableConsoleLogsTrue().then(response => {
          this.enableLogs = response;
          if(this.enableLogs){
              console.log('getEnableConsoleLogsTrue response is',response);
          }
      }).catch(error => {
          if(this.enableLogs){
              console.log('error is', error);
          }
      })

      if(this.enableLogs){
      console.log('message from',this.message);
      console.log('message from',this.isbn);
      }
  }

    

    @wire(getRelatedProductdetail, { proddetailid: '$message', ISBN:'$isbn'})
    wiredRelatedProducts({ error, data }) {
        if (data) {
            this.relatedProducts = data;
            this.ISBNVAl= data.ISBN13__c;
            if(this.enableLogs){
              console.log('gettitledetailpagedata',data);
              console.log('gettitledetailpagedata',this.ISBNVAl);
            }
           

        } else if (error) {
            console.error('Error fetching related products:', error);
        }
    }  
     returnProductDetailpageOnclick(event){
        const sendCustomEventToCloseTitlePage = new CustomEvent("closetitlepage");
        this.dispatchEvent(sendCustomEventToCloseTitlePage);
    }
    
}