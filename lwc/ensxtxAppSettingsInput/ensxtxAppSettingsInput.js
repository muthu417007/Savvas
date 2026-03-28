import { LightningElement, api } from 'lwc';

export default class EnsxtxAppSettingsInput extends LightningElement {

    inputSetting
    value
    currentValue

    @api arrayKey
    @api isChildInput

    @api
    get setting() {
        return this.inputSetting
    }
    set setting(value) {
        this.inputSetting = value
        this.value = value.value
    }

    @api hideLabel

    get label() {
        return !this.hideLabel ? this.inputSetting.title : ''
    }

    get description() {
        return !this.hideLabel ? this.inputSetting.description : ''
    }

    get showHeader() {
        return !this.hideLabel
    }

    @api
    clearValue() {
        this.value = null
    }

    handleOnFocusInput(event) {
        this.currentValue = event.target.value
    }

    handleOnBlurInput(event) {
        if (event.target.value != this.currentValue) {
            this.createEvent(event.target.value)
        }
    }

    handleCheckboxChange(event) {
        this.createEvent(event.target.checked)
    }

    handleSelectChange(event) {
        this.createEvent(event.target.value)
    }

    handleInputMultipleChange(event) {
        this.createEvent(event.detail.setting)
    }

    createEvent(value) {
        const newSetting = {...this.inputSetting, newValue: this.getValue(value)}

        const eventName = newSetting.isForInputMultiple
            ? 'inputchange'
            : 'ensxtx__settings_event'

        const settingsChanged = new CustomEvent(eventName, {
            bubbles: newSetting.isForInputMultiple ? false : true,
            composed: newSetting.isForInputMultiple ? false : true,
            detail: {
                operation: 'update',
                arrayKey: this.arrayKey,
                setting: newSetting
            }
        })

        this.dispatchEvent(settingsChanged)
    }

    getValue(value) {
        switch(this.inputSetting.inputType) {
            case 'number':
                return parseInt(value)
            default:
                return value
        }
    }
}