import { LightningElement, track } from 'lwc';
import getAppSettings from '@salesforce/apex/ensxtx_CTRL_AppSettingsEditor.getAppSettings'
import saveAppSetting from '@salesforce/apex/ensxtx_CTRL_AppSettingsEditor.saveAppSetting'
import saveAsNewModal from 'c/ensxtxAppSettingsSaveAsNew';

export const buildSettingInfo = (schema, key, value, parentProp) => {
    console.log('build setting info')
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
        inputObject: inputType === 'object' && !schema.table,
        inputArray: inputType === 'array' && (schema.items.type === 'string' || schema.items.type === 'number'),
        inputMultipleObject: inputType === 'array' && schema.items.type === 'object',
        inputTable: schema.table,
        selectOptions: schema.enum?.map(value => ({label: value, value: value})),
        value: value,
        isDefaultSetting: !parentProp.includes(':Simulate') && !parentProp.includes(':Create') && !parentProp.includes(':Update'),
        enableAddAndRemove: schema.table && schema.enableAddAndRemove,
        parentProperties: parentProp
    }
}

export const updateSettingValue = (setting, newValue, properties, operation) => {
    let isFound = false
    for (const prop in setting) {
        if (prop === properties[0]) {
            isFound = true
            if (properties.length === 1) {
                if (operation === 'update') {
                    setting[prop] = newValue;
                }
                else if (operation === 'insert') {
                    setting[prop] = {...setting[prop], ...newValue}
                }
                else if (operation === 'delete') {
                    delete setting[prop]
                }
            }
            else {
                properties.shift();
                setting[prop] = updateSettingValue({...setting[prop]}, newValue, properties, operation)
            }
            break;
        }
    }

    // This is to add new property if not found i.e. in Simulate, Create, or Update
    if (!isFound && (operation === 'insert' || operation === 'update')) {
        if (properties.length === 1) {
            setting[properties[0]] = newValue
        }
        else if (properties.length > 1) {
            let valueString = '{'
            const firstProp = properties.shift()

            // Build the object String
            properties.forEach((prop, index, array) => {
                if ((array.length - 1) === index) {
                    valueString += '"' + prop + '":'
                    if (typeof newValue === 'object') {
                        valueString += JSON.stringify(newValue)
                    }
                    else valueString += newValue
                    array.forEach(value => {
                        valueString += '}'
                    })
                }
                else {
                    valueString += '"' + prop + '":{'
                }
            })

            setting[firstProp] = JSON.parse(valueString)
        }
    }

    return setting
}


export default class EnsxtxAppSettingsEditor extends LightningElement {
    settings
    options
    selected
    selectedBody
    selectedAppSetting
    schemaDefinitions
    appSettingsSchema
    appSettingsValues = []
    loading = true
    saving = false
    displayMessage = false
    messages

    get showActionButtons() {
        return !!this.selected
    }

    get showAppSettingEditor() {
        return this.selectedAppSetting
    }

    get disabledButton() {
        return this.loading || !this.selectedAppSetting
    }

    constructor() {
        super();
        this.addEventListener('ensxtx__settings_event', (event) => {
            switch(event.detail.operation) {
                case 'insert':
                    this.handleSettingsNewProperty(event)
                    break
                case 'update':
                    this.handleSettingsChange(event)
                    break
                case 'delete':
                    this.handleSettingsDeleteProperty(event)
            }
        })
    }

    connectedCallback() {
        this.getAppSettings()
    }

    getAppSettings() {
        return new Promise((resolve, reject) => {
            console.log('get app settings')
            getAppSettings()
                .then(({ data }) => {
                    console.log('return get app settings: ' + data)
                    const appSettings = data.filter(item => item.Body && item.Schema)
                    this.options = [...appSettings
                        .map(setting => ({
                            label: setting.Label,
                            value: setting.Name
                        }))
                    ]
                    this.settings = appSettings
                })
                .catch(e => {
                    console.log(e)
                })
                .finally(() => {
                    this.loading = false
                    return resolve()
                })
        })
    }

    handleSettingsChange(event) {
        let setting = event.detail.setting
        const properties = (setting && setting.parentProperties) ? (setting.parentProperties + ':' + setting.name) : setting.name
        if (properties) {
            console.log('handle settings change value', JSON.parse(JSON.stringify(setting)))

            this.selectedBody = updateSettingValue(
                {...this.selectedBody},
                setting.newValue,
                properties.split(':'),
                event.detail.operation)

            console.log('updated body: ' + this.selectedBody);
        }
    }

    handleSettingsNewProperty(event) {
        let setting = event.detail.setting
        if (setting && setting.parentProperties) {
            console.log('handle new settings', JSON.parse(JSON.stringify(event.detail)))
            let newValue = {}
            let fieldName = setting.name
            if (setting.inputObject) {
                newValue[fieldName] = {}
                setting.cellInputs.forEach(input => {
                    newValue[fieldName][input.name] = input.value
                })
            }
            else if (setting.inputMultiple) {
                newValue[fieldName] = []
            }

            this.selectedBody = updateSettingValue(
                {...this.selectedBody},
                newValue,
                setting.parentProperties.split(':'),
                event.detail.operation)
        }
    }

    handleSettingsDeleteProperty(event) {
        let setting = event.detail.setting
        if (setting && setting.parentProperties) {
            this.selectedBody = updateSettingValue(
                {...this.selectedBody},
                null,
                (setting.parentProperties + ':' + setting.name).split(':'),
                event.detail.operation)
        }
    }

    onOptionChange(event) {
        console.log('handle change')
        this.handleChange(event.target.value)
    }

    handleChange(value) {
        console.log('handle change')
        this.displayMessage = false
        this.loading = true
        this.appSettingsValues = []
        const loadAppSettingsBind = (function(value) {
            this.loadAppSettings(value)
        }).bind(this);
        setTimeout(loadAppSettingsBind, 500, value)
    }

    loadAppSettings(selectedValue) {
        console.log('loading app settings');

        this.selected = this.settings.find(d => d.Name === selectedValue)
        this.selectedBody = this.selected.Body
        console.log('selected: ', this.selected);
        this.selectedAppSetting = selectedValue

        if (this.selected.Schema.definitions) {
            this.schemaDefinitions = this.selected.Schema.definitions
            this.schemaDefinitions = this.cleanupDefinitions(this.selected.Schema.definitions)
        }
        else this.schemaDefinitions = {}

        console.log('schemaDefinitions', this.schemaDefinitions)

        let mainAppSettings = Object.entries(this.selectedBody).filter(([key, value]) => (key !== '$schema'))

        try {
            if (this.selected.Schema.patternProperties) {
                // This is typically the app settings structure for Transact
                this.appSettingsSchema = this.cleanupDefinitions(this.getSchema(this.selected.Schema.patternProperties))
                this.appSettingsValues = this.cleanupDefinitions(this.buildTransactAppSettings(mainAppSettings[0][1], this.appSettingsSchema, mainAppSettings[0][0]))
            }
            else {
                this.appSettingsSchema = this.cleanupDefinitions(this.selected.Schema.properties)
                let label = this.selected.Label
                this.appSettingsValues = this.cleanupDefinitions(this.buildAppSettings(mainAppSettings, this.appSettingsSchema, label))
            }
        }
        catch (ex) {
            this.messages = [{key: 0, message: 'Failure to build app setting: ' + ex.stack, messageType: 'ERROR'}]
            this.displayMessage = true
        }

        console.log('appSettingsSchema', this.appSettingsSchema)
        console.log('appSettingsValues', this.appSettingsValues)

        this.loading = false
    }

    cleanupDefinitions(obj) {
        for (const prop in obj) {
            let value = obj[prop];
            if (prop === '$ref') {
                return this.getReferenceDefinition(obj)
            }
            if (typeof value === 'object') {
                let newValue = this.cleanupDefinitions(value);
                obj[prop] = newValue
            }
        }
        return obj
    }

    getReferenceDefinition(obj) {
        let definition = obj.$ref.replace('#/definitions/', '')
        let correctDefinition = this.schemaDefinitions[definition]
        if (correctDefinition.$ref) correctDefinition = this.getReferenceDefinition(correctDefinition)
        delete obj.$ref
        let newObj = {...obj, ...correctDefinition}
        return newObj
    }

    getSchema(jsonSchema) {
        for (const prop in jsonSchema) {
            let value = jsonSchema[prop];
            if (prop === '^[A-Za-z_][A-Za-z0-9_]*$') {
                if (value.patternProperties) {
                    return this.getSchema(value.patternProperties)
                }
                else if (value.properties) {
                    return value.properties
                }
            }
        }
    }

    buildAppSettings(body, schema, label) {
        let appSettingsGroups =  {
            id: label,
            generalSettings: this.appSettingsProperties(body, schema, Object.fromEntries(body), '')
        }

        return [appSettingsGroups]
    }

    buildTransactAppSettings(body, schema, appSettingsKey) {
        return Object.entries(body).map(([key, value]) => {

            let generalSettings = Object.entries(value).filter(([key, value]) => (
                key !== 'Default' && key !== 'Simulate' && key !== 'Create' && key !== 'Update'))

            let defaultSettings = Object.entries(value).find(([key, value]) => key === 'Default')

            let fieldSettings = Object.entries(value).filter(([key, value]) => (
                key === 'Default' || key === 'Simulate' || key === 'Create' || key === 'Update'))

            let mappedFieldSettings = Object.fromEntries(fieldSettings.map(([key, value]) => {
                if (key === 'Default') return [key, value]
                else return [key, defaultSettings[1]]
            }))

            let parentProp = appSettingsKey + ':' + key

            fieldSettings.filter(([key, value]) => (key !== 'Default')).forEach(([key, value]) => {
                mappedFieldSettings = this.setAlternateValue(Object.entries(value), key, mappedFieldSettings)
            })

            let appSettingsGroups =  {
                id: key,
                generalSettings: this.appSettingsProperties(generalSettings, schema, Object.fromEntries(generalSettings), parentProp),
                fieldSettings: Object.entries(mappedFieldSettings).map(([fieldKey, fieldValue]) => {
                    return {
                        name: fieldKey,
                        objectSettings: this.appSettingsProperties(Object.entries(fieldValue), schema.Default.properties, fieldValue, parentProp + ':' + fieldKey)
                    }
                }),
                hasFieldSettings: true
            }

            return appSettingsGroups
        })
    }

    setAlternateValue(objectEntries, parentProp, mappedFieldSettings) {
        objectEntries.map(([key, value]) => {
            if (typeof value === 'object') {
                mappedFieldSettings = this.setAlternateValue(Object.entries(value), parentProp + ':' + key, mappedFieldSettings)
            }
            else {
                mappedFieldSettings = updateSettingValue(
                    {...mappedFieldSettings},
                    value,
                    (parentProp + ':' + key).split(':'),
                    'update')
            }
        })

        return mappedFieldSettings
    }

    appSettingsProperties(objectEntries, schema, propValues, parentProp) {
        return objectEntries.map(([key, value]) => {
            let settingSchema = schema[key]

            if (settingSchema.patternProperties) {
                if (!settingSchema.properties) settingSchema.properties = {};
                const patternProp = settingSchema.patternProperties[Object.keys(settingSchema.patternProperties)[0]]
                Object.keys(propValues[key]).
                    forEach(propKey => {
                        if (!settingSchema.properties[propKey]) {
                            settingSchema.properties[propKey] = {...patternProp, title: propKey}
                        }
                    })
            }

            if (settingSchema.properties) {
                settingSchema.objectSettings = this.appSettingsProperties(
                    Object.entries(value), settingSchema.properties, propValues[key], parentProp ? (parentProp + ':' + key) : key)
            }

            return buildSettingInfo(settingSchema, key, propValues[key], parentProp)
        })
    }

    handleDownload() {
        try {
            const link = document.createElement("a");
            const file = new Blob([this.getSelectedPrettyJson()], { type: 'application/json' })
            link.href = URL.createObjectURL(file);
            link.download = this.selected.Name;
            link.click();

            this.messages = [{key: 0, message: 'Download success', messageType: 'SUCCESS'}]
        }
        catch (ex) {
            this.messages = [{key: 0, message: 'Failed to download: ' + ex.message, messageType: 'ERROR'}]
        }
        finally {
            this.displayMessage = true
        }
    }

    handleCopy() {
        try {
            // For copy create an input field with the minimum size and place in a not visible part of the screen
            let tempTextAreaField = document.createElement('textarea');
            tempTextAreaField.style = 'position:fixed;top:-5rem;height:1px;width:10px;';
            tempTextAreaField.value = this.getSelectedPrettyJson();
            document.body.appendChild(tempTextAreaField);
            tempTextAreaField.select();
            document.execCommand('copy');
            tempTextAreaField.remove();

            this.messages = [{key: 0, message: 'Copied to clipboard', messageType: 'SUCCESS'}]
        }
        catch (ex) {
            this.messages = [{key: 0, message: 'Failed to copy clipboard: ' + ex.message, messageType: 'ERROR'}]
        }
        finally {
            this.displayMessage = true
        }
    }

    openSaveAsNewModal() {
        saveAsNewModal.open({
            size: 'medium',
            description: 'A modal to save a new app setting',
            settings: this.options,
            onsave: (event) => {
                event.stopPropagation();
                this.handleSave(event.detail.appSettingName)
            }
        })
        .then(result => {
            console.log(result);
        })
    }

    handleSaveClick() {
        this.handleSave(this.selected.Name)
    }

    handleSave(appSettingName) {
        console.log('handle save')
        this.saving = true
        this.displayMessage = false

        this.saveAppSettings(appSettingName)
            .then(res => {
                if (res) { appSettingName = res }
                return this.getAppSettings()
            })
            .then(res => {
                console.log('handle here')
                this.handleChange(appSettingName)
            })
            .catch(res => {
                console.log('catch exception: ' + res);
                this.messages = [{key: 0, message: res.body.message, messageType: 'ERROR'}]
            })
            .finally(res => {
                console.log('finally handle save')
                this.displayMessage = true
                this.saving = false
            })
    }

    saveAppSettings(appSettingName) {
        return new Promise((resolve, reject) => {
            console.log('save app settings')
            saveAppSetting({ appSettingNameOrLabel: appSettingName, content: btoa(this.getSelectedPrettyJson()) })
                .then(res => {
                    console.log('return save app settings')
                    this.messages = res.messages
                    if (res?.data?.isSuccess) {
                        this.messages = [{key: 0, message: 'App settings saved successfully.', messageType: 'SUCCESS'}]
                    }
                    return resolve(res?.data?.appSettingName)
                })
                .catch(res => {
                    return reject(res)
                })
                .finally(res => {
                    this.displayMessage = true
                })
        })
    }

    getSelectedPrettyJson() {
        return JSON.stringify(this.selectedBody, null, 2)
    }
}