import { api } from 'lwc';
import LightningModal from 'lightning/modal';

export default class EnsxtxDocumentDetailModal extends LightningModal {

    @api sapDocumentId
    @api sapDocumentFlowType
    @api detailFlowName

    get inputVariables() {
        return [
            {
                name: 'initialSAPDocumentId',
                type: 'String',
                value: this.sapDocumentId
            },
            {
                name: 'selectedDocFlowType',
                type: 'String',
                value: this.sapDocumentFlowType
            }
        ]
    }
}