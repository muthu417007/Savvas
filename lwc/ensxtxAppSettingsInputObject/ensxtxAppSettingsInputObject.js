import { LightningElement, api } from 'lwc';

export default class EnsxtxAppSettingsInputObject extends LightningElement {

    @api setting
    @api isChildInput

    connectedCallback() {
        console.log('app settings input object: ' + this.setting);
    }

    handleSettingsChange(event) {
        console.log('object handle setting change: ' + event.detail.setting)

        const newSetting = {...this.setting, newValue: event.detail.setting}

        const settingsChanged = new CustomEvent('childinputmultiplechange', {
            bubbles: false,
            composed: false,
            detail: {
                operation: 'update',
                setting: newSetting
            }
        })

        this.dispatchEvent(settingsChanged)
    }
}