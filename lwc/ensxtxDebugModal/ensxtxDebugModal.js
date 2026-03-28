import { api } from 'lwc';
import LightningModal from 'lightning/modal';

export default class EnsxtxDebugModal extends LightningModal {

    @api debugProperties = []
    @api httpTraces = []
}