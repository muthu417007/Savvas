import { LightningElement, wire } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import { NavigationMixin } from 'lightning/navigation';
export default class SchedulingRequestContainer extends NavigationMixin(LightningElement) {
BASE_URL;
recordId;
    
    @wire(CurrentPageReference)
 		getStateParameters(currentPageReference) {
         		this.recordId = currentPageReference.state['recordId'];
    }	

    connectedCallback(){
        if(this.recordId != ''|| this.recordId!= null || this.recordId != 'undefined'){
            let objInitials = this.recordId.substring(0, 3);
            if(objInitials != '' && objInitials == '006'){
                this[NavigationMixin.Navigate]({
                type: 'standard__navItemPage',
                attributes: {
                    apiName: 'Scheduling_Request_Form'
                    },
                    state: {
                    c__recordId: this.recordId
                    }
                });
            } else {
                this[NavigationMixin.Navigate]({
                type: 'standard__navItemPage',
                attributes: {
                    apiName: 'Merge_Work_Orders'
                    },
                    state: {
                    c__recordId: this.recordId
                    }
                });
            }
        }
    }   
}