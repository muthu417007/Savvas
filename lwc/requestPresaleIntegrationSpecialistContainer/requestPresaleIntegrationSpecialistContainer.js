import { LightningElement, wire } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import { NavigationMixin } from 'lightning/navigation';

export default class RequestPresaleIntegrationSpecialistContainer extends NavigationMixin(LightningElement) {
    BASE_URL;
    recordId;
    
    @wire(CurrentPageReference)
 		getStateParameters(currentPageReference) {
            console.log('Inside requestPresaleIntegrationSpecialistContainer');
         		this.recordId = currentPageReference.state['recordId'];
    }	

    connectedCallback(){
        if(this.recordId != ''|| this.recordId!= null || this.recordId != 'undefined'){
            let objInitials = this.recordId.substring(0, 3);
            console.log('Inside requestPresaleIntegrationSpecialistContainer '+objInitials);
            if(objInitials != '' && objInitials == '006'){
                this[NavigationMixin.Navigate]({
                type: 'standard__navItemPage',
                attributes: {
                    apiName: 'Request_Presale_Integration_Specialist_Tab'
                    },
                    state: {
                    c__recordId: this.recordId
                    }
                });
            }
            console.log('Inside end requestPresaleIntegrationSpecialistContainer '+objInitials);
        }
    }   
}