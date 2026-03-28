/*********************************************************
  Component Name       : scc_showHeldCartMessage
  Created Date         : 06/10/2024  
  Author               : Cognizant 
  Description          : This component used in Home page and functionality related to 
                         display Held Carts message.
  
  Modifications Log
  06/10/2024     Zubiya           Initial Version
*********************************************************/


import { LightningElement, wire, track } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import scc_heldCartMessage from "@salesforce/label/c.scc_heldCartMessage";
import { decodeDefaultFieldValues } from 'lightning/pageReferenceUtils';


export default class Scc_showHeldCartMessage extends LightningElement {

  showHeldCartMsg = false;
  heldCartMessage = scc_heldCartMessage;

   @wire(CurrentPageReference)      
    setCurrentPageRef(pageRef) {
       
        if (pageRef.state.Source) {
           
            this.source = pageRef.state.Source;

             if(this.source == 'showHeldCartMssg'){
             
             this.showHeldCartMsg = true;
  
          }
          else{
             this.showHeldCartMsg = false;
  
          }
        }
        }
}