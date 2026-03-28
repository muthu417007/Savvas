import { LightningElement, api } from 'lwc';

export default class EnsxtxAppSettingsMain extends LightningElement {
    @api appSettings

    get cssClass() {
        return this.appSettings.hasFieldSettings ? 'slds-col slds-size_1-of-1 slds-medium-size_1-of-2 slds-border_right' : 'slds-col slds-size_1-of-1'
    }

    constructor() {
        super()
    }

    connectedCallback()
    {
        console.log('connected app settings main');
        console.log('appSettings', JSON.parse(JSON.stringify(this.appSettings)))
    }
}