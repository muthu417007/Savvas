import { LightningElement,api,track } from 'lwc';
import { FlowAttributeChangeEvent, FlowNavigationNextEvent } from 'lightning/flowSupport';
import frontImage from '@salesforce/resourceUrl/FlipImageFront';
import backImage from '@salesforce/resourceUrl/FlipImageBack';

export default class CustomerCareFlipImage2 extends LightningElement {

    frontImageUrl= frontImage;
    backImageUrl= backImage;
    @api componentTextLarge;
    @api componentTextSmall;
    @api selectedCardHeading;
    @track selectedheading;

    addClass(event){
        let index = event.currentTarget.dataset.rowIndex;
        let flipElement = this.template.querySelector('[data-id="' + index + '"]');
        flipElement.classList.add('class1');
    }

    removeClass(event){
        let index = event.currentTarget.dataset.rowIndex;
        let flipElement = this.template.querySelector('[data-id="' + index + '"]');
        flipElement.classList.remove('class1');
    }

    get backgroundImgStyle(){
        return `background-image:url("${this.frontImageUrl}"); cursor:pointer;display:table; height:150px; width:300px;background-repeat:no-repeat; `;
        //return `display: table;height: 150px;width: 300px;margin-left: auto;margin-right: auto; background: url(${this.frontImageUrl});background-size: 90%; z-index: -1; border-radius: 3px;`;
    }

    handleNext(event){
        console.log('h2:',event.currentTarget.dataset.targetId);
        this.selectedheading=event.currentTarget.dataset.targetId;
        const attributeChangeEvt = new FlowAttributeChangeEvent('selectedCardHeading',this.selectedheading);
            this.dispatchEvent(attributeChangeEvt);
            const nextNavigationEvent = new FlowNavigationNextEvent();
            this.dispatchEvent(nextNavigationEvent); 
    }
}