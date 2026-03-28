import { LightningElement, api } from 'lwc';
import { getSessionContext } from 'commerce/contextApi';
import { FlowAttributeChangeEvent, FlowNavigationNextEvent } from 'lightning/flowSupport'

export default class EnsxtxDocumentSearchWrapper extends LightningElement {

    @api appSettingsName
    @api documentSearchFlowName

    accountId
    messages = []

    get hasAccountId() {
        return this.accountId
    }

    connectedCallback() {
        getSessionContext()
            .then((response) => {
                if (response && response.effectiveAccountId) {
                    this.accountId = response.effectiveAccountId
                }
                else {
                    this.messages = [
                        {
                            key: 1,
                            messageType: 'WARNING',
                            message: 'Account Id is empty'
                        }
                    ]
                }
            })
    }
}