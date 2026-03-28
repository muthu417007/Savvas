import { LightningElement, api } from 'lwc';

export default class TileCmp extends LightningElement {
    @api heading;
    @api subHeading;
    @api backgroundImgUrl = '/support/resource/TS_flow_generic_btn';

    renderedCallback(){
        this.initCSSVariables();
    }

    initCSSVariables(){
        let css = document.body.style;
        css.setProperty('--backgroundImgUrl', url(this.backgroundImgUrl));
    }

    get isHeadingPresent(){
        return (this.heading != null && this.heading.length > 0) ? true : false;
    }

    get isSubheadingPresent(){
        return (this.subHeading != null && this.subHeading.length > 0) ? true : false;
    }
}