import { LightningElement } from 'lwc';
import { FlowNavigationNextEvent} from 'lightning/flowSupport';
import { NavigationMixin } from 'lightning/navigation';


export default class NewOrderOption extends NavigationMixin(LightningElement) {

    //Go to Next screen of Flow
    handleNext(event){
        const nextNavigationEvent = new FlowNavigationNextEvent();
        this.dispatchEvent(nextNavigationEvent);
    }

    // Navigation to web page 
    navigateToWebPage() {
        this[NavigationMixin.Navigate]({
            "type": "standard__webPage",
            "attributes": {
                "url": "https://oasis.savvas.com/"
            }
        });
    }
}