/********************************************************************************************* 
* @Component Name  - Scc_registerSIOPParticipantLWC
* @description - this component is for SIOP Popup for Registering Participant
* @Created By  - CTS - Vaibhav Saptal
* @Created On - 06/13/2024 
* ********************************************************************************************/
import { LightningElement,track,api } from 'lwc';
import getSIOPurl from '@salesforce/apex/scc_checkSIOPRegistration.getSIOPurl';
import getSIOPOrderNumber from '@salesforce/apex/scc_checkSIOPRegistration.getSIOPOrderNumber';
import scc_OrderStatus_SIOP_Order_Register_Participants from "@salesforce/label/c.scc_OrderStatus_SIOP_Order_Register_Participants";
import scc_register_SIOP_Your_order_includes from "@salesforce/label/c.scc_register_SIOP_Your_order_includes";
import scc_register_SIOP_the_site_where from "@salesforce/label/c.scc_register_SIOP_the_site_where";
import scc_register_SIOP_To_Register from "@salesforce/label/c.scc_register_SIOP_To_Register";
import scc_register_SIOP_link from "@salesforce/label/c.scc_register_SIOP_link";
import getEnableConsoleLogsTrue from '@salesforce/apex/scc_headerLWC_Controller.getEnableConsoleLogsTrue' ;

export default class Scc_registerSIOPParticipantLWC extends LightningElement {
    @track openModal = true;
    @api orderNumber;
    @track ordernum;
    @track orderId;
    @track enableLogs = false;

    labels={
        scc_OrderStatus_SIOP_Order_Register_Participants,scc_register_SIOP_Your_order_includes,scc_register_SIOP_the_site_where,
        scc_register_SIOP_To_Register,scc_register_SIOP_link
    }

    connectedCallback(){
        this.orderId = this.orderNumber;
        getEnableConsoleLogsTrue().then(response => {
            this.enableLogs = response;
            if(this.enableLogs){
                console.log('getEnableConsoleLogsTrue response is',response);
            }
        }).catch(error => {
            if(this.enableLogs){
                console.log('error is', error);
            }
        })
    }
   
    closeModal(){
        const sendCustomEventToClosePopup = new CustomEvent("closepopup");
        this.dispatchEvent(sendCustomEventToClosePopup);
    }

    handleRegisterSIOP(){
        console.log('this.orderId',this.orderId);
        getSIOPOrderNumber({ orderID: this.orderId})
        .then( data => {
          if(this.enableLogs){
                console.log('getSIOPOrderNumber response is',data);
          }   
          this.ordernum = data[0].SAP_Document_Number__c;
        })
        .catch(error => {
            if(this.enableLogs){
                console.log('getSIOPOrderNumber error is',error);
            }
        })
        .finally(()=>{
            this.getSIOPDetails();
        });       
    }

    getSIOPDetails(){
        getSIOPurl({orderNum:this.ordernum})
        .then(result=> {
            if(this.enableLogs){
                console.log('result url IIis',result);
            }
           window.open(result,'_blank');
        })
        .catch(error=> {
            if(this.enableLogs){
                console.log('result error',error);
            }
        })
        .finally(()=>{
            this.closeModal();
        });
    }
}