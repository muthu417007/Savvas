import { LightningElement,wire } from 'lwc';
import geturl from  '@salesforce/apex/testgenerateurl.geturl';
export default class Testgenerateurl extends LightningElement {
     productData ;
      @wire(geturl)
    wiredProductData({ data, error }) {
        if (data) {
            this.productData = data;
            console.log('the generated url is',data);

        } else if (error) {
            // Handle error
        }
    }

}