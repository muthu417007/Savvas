import { LightningElement, api} from 'lwc';

export default class EnsxtxDebug extends LightningElement {
    @api debugProperties = []
    @api httpTraces = []
}