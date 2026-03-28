import { LightningElement, api } from 'lwc';
import {FlowAttributeChangeEvent, FlowNavigationNextEvent} from 'lightning/flowSupport';


export default class TileCmp extends LightningElement {
    @api heading;
    @api headingColor = 'white';
    @api subHeading;
    @api backgroundImgUrl = '/support/resource/TS_flow_generic_btn';
    @api selectedCardHeading;

    handleNext(){
        const attributeChangeEvt = new FlowAttributeChangeEvent('selectedCardHeading',this.heading);
        this.dispatchEvent(attributeChangeEvt);
        const nextNavigationEvent = new FlowNavigationNextEvent();
        this.dispatchEvent(nextNavigationEvent);
    }

		// Made font size changes as part of WI - W-011424
    get headingColor(){
        let strVal = `font-weight:700; font-family:Poppins,sans-serif; vertical-align:middle; font-size:20px; color:${this.headingColor};`;
        console.log('strVal: '+strVal);
        return strVal;
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