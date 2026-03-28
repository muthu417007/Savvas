import { LightningElement, api} from 'lwc';

export default class EnsxtxDebugValue extends LightningElement {
    @api debugValue
    @api debugName

    get debugString() {
        return JSON.stringify(this.debugValue, null, 4)
    }
}