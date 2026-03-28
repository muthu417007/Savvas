import { LightningElement } from 'lwc';
import {FlowNavigationBackEvent} from 'lightning/flowSupport';
export default class CustomerTabBackBtn extends LightningElement {
    
    goToPrevScreen(){
        const backNavigationEvent = new FlowNavigationBackEvent();
        this.dispatchEvent(backNavigationEvent);
    }
}