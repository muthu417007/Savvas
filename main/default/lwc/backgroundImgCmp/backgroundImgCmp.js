import { LightningElement, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import {FlowAttributeChangeEvent} from 'lightning/flowSupport';

export default class BackgroundImgCmp extends NavigationMixin(LightningElement) {
    @api backgroundImgUrl;
    @api redirectURL;
    @api trackClickEvent = false;
    @api trackClickDetails = [];

    handleClick(event){
        if(this.trackClickEvent){
            /*let title = 'Clicked on '+this.redirectURL;
            console.log('title: '+title);
            const attributeChangeEvt = new FlowAttributeChangeEvent('trackClickDetails',this.trackClickDetails.push(title));
            console.log('trackClickDetails: '+this.trackClickDetails);
            this.dispatchEvent(attributeChangeEvt);*/
        }
        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes:{
                url: this.redirectURL
            }
        });
    }

    get style(){
        return 'background-image: url(' + this.backgroundImgUrl + '); background-repeat: no-repeat; cursor:pointer; height: 150px; width: 100%; background-size: contain;';
    }

}