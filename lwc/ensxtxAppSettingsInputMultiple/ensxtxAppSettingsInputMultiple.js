import { LightningElement, api } from 'lwc';

export const buildSettingInfo = (schema, key, value, requiredFields) => {
    let inputType;

    switch(schema.type) {
        case 'integer':
            inputType = 'number'
            break;
        case 'string':
            inputType = 'text'
            break;
        case 'boolean':
            inputType = 'checkbox'
            break;
        case 'array':
            inputType = 'array'
            break;
        default:
            inputType = 'object'
            break;
    }

    if (schema.enum !== undefined) inputType = 'select'

    return {
        ...schema,
        name: key,
        inputType: inputType,
        inputField: inputType === 'text' || inputType === 'number',
        inputCheckbox: inputType === 'checkbox',
        inputSelect: inputType === 'select',
        inputObject: inputType === 'object',
        inputArray: inputType === 'array' && (schema.items.type === 'string' || schema.items.type === 'number'),
        inputMultipleObject: inputType === 'array' && schema.items.type === 'object',
        selectOptions: schema.enum?.map(value => ({label: value, value: value})),
        isForInputMultiple: true,
        value: value,
        required: inputType === 'checkbox' ? false : (requiredFields?.find(field => field === key) ? true : false),
        outputValue: inputType === 'checkbox' ? (value === true ? 'Yes' : 'No') : value
    }
}

export default class EnsxtxAppSettingsInputMultiple extends LightningElement {

    @api setting

    // This indicate if the input has a parent of InputMultiple
    @api isChildInput

    values
    inputFields
    inputValues = []
    isEdit = false
    errorMessage

    connectedCallback() {
        console.log('setting: ', JSON.parse(JSON.stringify(this.setting)))
        if (this.setting.items.type === 'object') {
            this.inputFields = Object.entries(this.setting.items.properties).map(([key, value]) => {
                let schema = this.setting.items.properties[key]
                if (schema.properties) {
                    schema = {
                        ...schema,
                        objectSettings: Object.entries(schema.properties).map(([key1, value1]) => {
                            return buildSettingInfo(value1, key1, value[key1])
                        })
                    }
                }
                return buildSettingInfo(schema, key, schema.value, this.setting.items.required)
            })

            this.values = this.setting.value ? Object.entries(this.setting.value).map(([key, value]) => {
                return {
                    key: parseInt(key),
                    fields: Object.entries(value).map(([key, value]) => {
                        let schema = this.setting.items.properties[key]
                        if (schema.properties) {
                            schema = {
                                ...schema,
                                objectSettings: Object.entries(schema.properties).map(([key1, value1]) => {
                                    return buildSettingInfo(value1, key1, value[key1])
                                })
                            }
                        }
                        return buildSettingInfo(schema, key, value, this.setting.items.required)
                    })
                }
            }) : []
        }

        console.log('input fields:', this.inputFields)
        console.log('values:', this.values);
    }

    handleSettingsChange(event) {
        console.log('handle settings change multiple: ' + JSON.stringify(event.detail))
        if (event.detail.setting) {
            if (event.detail.arrayKey || event.detail.arrayKey === 0) {
                // Update existing value
                this.values = this.values.map(value => {
                    if (value.key === event.detail.arrayKey) {
                        value.fields = value.fields.map(field => {
                            if (field.name === event.detail.setting.name) {
                                let newValue = event.detail.setting.newValue
                                if (newValue.inputType === 'array') {
                                    field.value = newValue.newValue
                                }
                                else if (newValue.inputType === 'object') {
                                    if (field.value === undefined) field.value = {}
                                    field.value = Object.keys(newValue.properties).reduce((acc, curr) => {
                                        let innerNewValue
                                        if (newValue.newValue.inputType === 'array') {
                                            innerNewValue = newValue.newValue.newValue.newValue
                                        }
                                        else {
                                            innerNewValue = newValue.newValue.newValue
                                        }
                                        return {...acc, [curr]: newValue.newValue.name === curr ? innerNewValue : field.value[curr]}
                                    }, {})
                                }
                                else {
                                    field.value = newValue
                                    field.outputValue =
                                        typeof newValue === 'boolean' ? (newValue === true ? 'Yes' : 'No') : newValue
                                }
                            }
                            return field
                        })
                    }
                    return value
                })

                const newValue = this.multipleObjectNewValue(this.values)
                let newSetting = {...this.setting, newValue: newValue}

                const eventName = this.isChildInput
                    ? 'childinputmultiplechange'
                    : 'ensxtx__settings_event'

                const settingsChanged = new CustomEvent(eventName, {
                    bubbles: this.isChildInput ? false : true,
                    composed: this.isChildInput ? false : true,
                    detail: {
                        operation: 'update',
                        setting: newSetting
                    }
                })

                this.dispatchEvent(settingsChanged)
            }
        }
    }

    handleAddValue(event) {
        console.log('handleAddValue inputFields: ' + JSON.stringify(this.inputFields))
        console.log('handleAddValue values: ' + JSON.stringify(this.values))
        let newKey = 1;

        if (this.values.length) {
            const lastItem = this.values[this.values.length - 1]
            newKey = lastItem.key + 1
        }

        this.values = [...this.values, {
            key: newKey,
            fields: this.inputFields.map(inputField => {
                let settingProps = this.setting.items.properties[inputField.name]
                if (settingProps.properties) {
                    settingProps = {
                        ...settingProps,
                        objectSettings: Object.entries(settingProps.properties).map(([key1, value1]) => {
                            return buildSettingInfo(value1, key1, settingProps[key1])
                        })
                    }
                }
                return buildSettingInfo(settingProps, inputField.name, inputField.value, this.setting.items.required)
            })
        }]

        const newValue = this.multipleObjectNewValue(this.values)
        let newSetting = {...this.setting, newValue: newValue}

        const eventName = this.isChildInput
            ? 'childinputmultiplechange'
            : 'ensxtx__settings_event'

        const settingsChanged = new CustomEvent(eventName, {
            bubbles: this.isChildInput ? false : true,
            composed: this.isChildInput ? false : true,
            detail: {
                operation: 'update',
                setting: newSetting
            }
        })

        this.dispatchEvent(settingsChanged)
    }

    multipleObjectNewValue (values) {
        return values.map(value => {
            let properties = {}
            value.fields.forEach(field => {
                let defaultValue = field.default
                if (!defaultValue) {
                    switch (field.type) {
                        case 'integer':
                            defaultValue = null
                            break
                        case 'string':
                            defaultValue = ''
                            break
                        case 'boolean':
                            defaultValue = false
                            break
                        case 'array':
                            defaultValue = []
                            break
                        case 'object':
                            defaultValue = {}
                            Object.entries(field.properties).map(([key, value]) => {
                                let innerDefaultValue
                                if (value.type === 'integer') innerDefaultValue = null
                                else if (value.type === 'string') innerDefaultValue = ''
                                else if (value.type === 'boolean') innerDefaultValue = false
                                else if (value.type === 'array') innerDefaultValue = []
                                defaultValue[key] = innerDefaultValue
                            })
                            break
                        default:
                            defaultValue = null
                            break
                    }
                }
                properties[field.name] = field.value !== undefined ? field.value : defaultValue
            })
            return properties
        })
    }

    handleDeleteValue(event) {
        console.log('handle delete value')
        const key = parseInt(event.target.name)
        this.values = this.values.filter(value => value.key !== key)

        const newValue = this.multipleObjectNewValue(this.values)
        let newSetting = {...this.setting, newValue: newValue}

        const eventName = this.isChildInput
            ? 'childinputmultiplechange'
            : 'ensxtx__settings_event'

        const settingsChanged = new CustomEvent(eventName, {
            bubbles: this.isChildInput ? false : true,
            composed: this.isChildInput ? false : true,
            detail: {
                operation: 'update',
                setting: newSetting
            }
        })

        this.dispatchEvent(settingsChanged)
    }
}