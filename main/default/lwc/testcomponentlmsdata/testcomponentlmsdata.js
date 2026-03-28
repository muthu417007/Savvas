import { LightningElement,wire } from 'lwc';
import {APPLICATION_SCOPE,createMessageContext,MessageContext,publish,releaseMessageContext,subscribe,unsubscribe} from 'lightning/messageService';
import scc_MessageChannel from '@salesforce/messageChannel/scc_MessageChannel__c'; 

export default class Testcomponentlmsdata extends LightningElement {
    @wire(MessageContext) messageContext;
    handleClick(){

        const message={
            lmsData:{
                value:'home'
            },
             showHeldCartMsg: {
          
              value: 'im frotestcomponent'
            }
        }
         publish(this.messageContext,scc_MessageChannel,message);


       
    }

}