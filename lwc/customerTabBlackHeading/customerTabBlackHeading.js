import { LightningElement, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import {FlowAttributeChangeEvent, FlowNavigationNextEvent} from 'lightning/flowSupport';

export default class CustomerTabBlackHeading extends NavigationMixin(LightningElement) {
    @api heading;
    @api subHeading;
    @api backgroundImgUrl = '/support/resource/TS_flow_generic_btn';
    @api selectedCardHeading;
    @api redirectUrl;

    handleNext(){
        if(this.redirectUrl && this.redirectUrl.length > 0){
            this[NavigationMixin.Navigate]({
                type: 'standard__webPage',
                attributes:{
                    url: this.redirectUrl
                }
            });
        }else{
            const attributeChangeEvt = new FlowAttributeChangeEvent('selectedCardHeading',this.heading);
            this.dispatchEvent(attributeChangeEvt);
            const nextNavigationEvent = new FlowNavigationNextEvent();
            this.dispatchEvent(nextNavigationEvent);    
        }
        /* const nextNavigationEvent = new FlowNavigationNextEvent();
        this.dispatchEvent(nextNavigationEvent); */

    }

    get backgroundImgStyle(){
        return `background-image:url("${this.backgroundImgUrl}"); cursor:pointer; display:table; height:150px; width:243px; background-repeat:no-repeat; background-position:center;`;
    }

    get isHeadingPresent(){
        return (this.heading != null && this.heading.length > 0) ? true : false;
    }

    get isSubheadingPresent(){
        return (this.subHeading != null && this.subHeading.length > 0) ? true : false;
    }

    get inputVariables() {
        return this._inputVariables;
    }

    set inputVariables(variables) {
        this._inputVariables = variables || [];
    }
}