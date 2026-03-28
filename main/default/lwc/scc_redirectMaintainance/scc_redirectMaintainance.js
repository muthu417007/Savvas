import { LightningElement } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

export default class Scc_redirectMaintainance extends NavigationMixin(LightningElement) {
    

    constructor(){
        super();
        
    }

    connectedCallback(){
        this.redirectUrl();
    }

    redirectUrl(){
        // if(this.redirectTrue){
        //     this[NavigationMixin.Navigate]({
        //         type: 'comm__namedPage',
        //         attributes: {
        //             name: 'Error'
        //         }
        //     });
        // }
    }
}