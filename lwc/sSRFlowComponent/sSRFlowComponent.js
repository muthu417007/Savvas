import {LightningElement, api, wire} from "lwc";
import { CurrentPageReference } from 'lightning/navigation';
import {ShowToastEvent} from "lightning/platformShowToastEvent";
import { CloseActionScreenEvent } from 'lightning/actions';
import modalStyling from '@salesforce/resourceUrl/modalStyling';
import { NavigationMixin } from 'lightning/navigation';
import { loadStyle } from 'lightning/platformResourceLoader';
export default class SSRFlowComponent extends NavigationMixin(LightningElement) {
	flowApiName = "Kimble_Scheduling_Request"; // api name of your flow
	recordId;
	isReady = false;
	flowInputVariables = [];
	isOpen = true;
	@wire(CurrentPageReference)
 		getStateParameters(currentPageReference) {
     		if (currentPageReference && currentPageReference.state['c__recordId']) {
         		this.recordId = currentPageReference.state['c__recordId'];
    	}
    }	
 	

	connectedCallback() {
		this.flowInputVariables = [
		{
			name: 'recordId',
			type: "String",
			value: this.recordId,
		},
	];
	}
	renderedCallback(){
		Promise.all([
			loadStyle(this, modalStyling +'/css/modalStyling.css')
		]).then(()=>{
			console.log('file loaded');
		}).catch(error =>{
			console.log('error in loading file!');
		})
	}

        // do something when flow status changed
	handleFlowStatusChange(event) {
		console.log("flow status.........", event.detail.status);
		if (event.detail.status === "FINISHED") {
			this.dispatchEvent(
				new ShowToastEvent({
					title: "Success",
					message: "Flow Finished Successfully",
					variant: "success",
				})
			);

			this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.recordId,
                actionName: 'view'
            }
        });
		}
	}

	closeAction(){
        this.dispatchEvent(new CloseActionScreenEvent());
    }
	handleClose(){
		this.isOpen = false;

		this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.recordId,
                actionName: 'view'
            }
        });
	}
}