import { LightningElement, api, track } from 'lwc';

export default class CpqToast extends LightningElement {
    
    @track type;
    @track title;
    @track message;
    @track showToastBar = false;
    @api autoCloseTime = 5000;
    @api topStyle = false;

    /*
    *********************************************************
    Function Name  : showToast
    Author         : Frank Berni
    Description    : function that sets up toast message to fire. To be called in parent components
    Param          : type, title, message
    return         : 
    ********************************************************
    */
    @api
    showToast(type, title, message) {
        this.type = type;
        this.title=title;
        this.message = message;
        this.showToastBar = true;
        if(type === 'success'){
            setTimeout(() => {
                this.closeToast();
            }, this.autoCloseTime);
        }
    }

     /*
    *********************************************************
    Function Name  : closeToast
    Author         : Frank Berni
    Description    : tied to Close button for notification. Resets all variables for toast and removes from screen
    Param          : 
    return         : 
    ********************************************************
    */
    closeToast() {
        this.showToastBar = false;
        this.type = '';
        this.title='';
        this.message = '';
	}

    // returns the icon matching the type of toast
    get getIconName() {
        return 'utility:' + this.type;
    }

    // returns slds tags matching type of toast
    get innerClass() {
        return 'slds-icon_container slds-icon-utility-' + this.type + ' slds-icon-utility-success slds-m-right_small slds-no-flex slds-align-top';
    }

    // returns slds tags matching the type of toast
    get outerClass() {
        return 'slds-notify slds-notify_toast slds-theme_' + this.type;
    }

    // returns styleClasses
    get containerClass() {
        let styleClasses = 'slds-notify_container'
        if(this.topStyle){
            styleClasses+=' align-vertical-space'; //adding horizontal spaces between error messagges
        }
        return styleClasses;
    }
}