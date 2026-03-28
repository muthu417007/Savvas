import { LightningElement, api } from 'lwc';
import {FlowAttributeChangeEvent, FlowNavigationNextEvent} from 'lightning/flowSupport';

export default class CustomerTabCmpV2 extends LightningElement {
    @api heading;
    @api headingColor = 'white';
    @api displayHeading = false;
    @api backgroundImgUrl = '/support/resource/TS_flow_generic_btn';
    @api selectedCardHeading;

    handleNext(){
        const attributeChangeEvt = new FlowAttributeChangeEvent('selectedCardHeading',this.heading);
        this.dispatchEvent(attributeChangeEvt);
        const nextNavigationEvent = new FlowNavigationNextEvent();
        this.dispatchEvent(nextNavigationEvent);
    }

    get headingColor(){
        let strVal = `font-weight:700; font-family:Poppins,sans-serif; vertical-align:middle; font-size:24px; color:${this.headingColor};`;
        return strVal;
    }

    get backgroundImgStyle(){
        return `background-image:url("${this.backgroundImgUrl}"); cursor:pointer; display:table; height:150px; width:243px; background-repeat:no-repeat; background-position:center;`;
    }

    get inputVariables() {
        return this._inputVariables;
    }

    set inputVariables(variables) {
        this._inputVariables = variables || [];
    }
}