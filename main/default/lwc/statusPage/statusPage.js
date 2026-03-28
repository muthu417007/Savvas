import { LightningElement } from 'lwc';
import { loadScript, loadStyle } from 'lightning/platformResourceLoader';
import status from '@salesforce/resourceUrl/status';


export default class StatusPage extends LightningElement { 

    renderedCallback() {

        Promise.all([
            loadScript(this, status),
        ]);
        //    .then(() => {
        //        alert('Files loaded.');
        //   })
        //    .catch(error => {
        //        alert(error.body.message);
        //    }); 
    }
}