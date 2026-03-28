import { LightningElement, api} from 'lwc'
import { FlowNavigationNextEvent, FlowNavigationBackEvent } from 'lightning/flowSupport'

// Import custom labels
import ensxapp__Pager_Previous from '@salesforce/label/ensxapp.Pager_Previous';
import ensxapp__Pager_Next from '@salesforce/label/ensxapp.Pager_Next';

export default class EnsxtxFlowNavigation extends LightningElement {

    @api allowPrevious
    @api allowNext
    @api availableActions = [];

    label = {
        ensxapp__Pager_Previous,
        ensxapp__Pager_Next
    }

    get showPrevious() {
        return this.allowPrevious && this.availableActions.find((action) => action === 'BACK')
    }

    get showNext() {
        return this.allowNext && this.availableActions.find((action) => action === 'NEXT')
    }

    handlePrevious() {
        // navigate to the previous screen
        this.dispatchEvent(new FlowNavigationBackEvent())
    }

    handleNext() {
        // navigate to the next screen
        this.dispatchEvent(new FlowNavigationNextEvent())
    }
}