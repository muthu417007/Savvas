import { LightningElement } from 'lwc';
import {FlowNavigationNextEvent} from 'lightning/flowSupport';

export default class CustomerTabNextBtn extends LightningElement {

    goToNextScreen(){
        const nxtNavigationEvent = new FlowNavigationNextEvent();
        this.dispatchEvent(nxtNavigationEvent);
    }
}