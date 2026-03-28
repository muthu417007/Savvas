import { LightningElement , track, api} from 'lwc';

export default class EnsxtxMessage extends LightningElement {
    @api message
    get messageClass() {
        return 'slds-m-around_xx-small slds-notify slds-notify_toast slds-theme_' + this.message.messageType.toLowerCase()
    }
}