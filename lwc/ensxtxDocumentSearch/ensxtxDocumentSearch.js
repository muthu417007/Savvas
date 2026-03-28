import { LightningElement, api} from 'lwc'
import getAppsettings from '@salesforce/apex/ensxtx_UTIL_GetAppSettings.getAppsettings'
import getCustomerNumber from '@salesforce/apex/ensxtx_CTRL_DocumentSearch.getCustomerNumber'
import search from '@salesforce/apex/ensxtx_CTRL_DocumentSearch.search'
import util from 'c/ensxtxDetailUtility'
import DocumentDetailModal from 'c/ensxtxDocumentDetailModal'
import { FlowAttributeChangeEvent, FlowNavigationNextEvent } from 'lightning/flowSupport'

// Import custom labels
import ensxtx_Common_Loading from '@salesforce/label/c.ensxtx_Common_Loading';
import ensxapp__ComponentSearch_Refresh from '@salesforce/label/ensxapp.ComponentSearch_Refresh';

const setValue = (field, soldToFieldName, customerNumber) => {
    if (field.DefaultValue) return field.DefaultValue
    else if (field.Name === soldToFieldName) return customerNumber
    else return null
}

const buildSearchParams = (searchParams, customerNumber) => {
    return {
        ...searchParams,
        Fields: searchParams.Fields.map(field => ({
            ...field,
            InputField: field.InputType === 'text' || field.InputType === 'number' || field.InputType === 'date',
            InputSearch: field.InputType === 'search',
            InputPicklist: field.InputType === 'picklist',
            InputCheckboxGroup: field.InputType === 'checkbox',
            value: setValue(field, searchParams.SoldToFieldName, customerNumber),
            options: field.AllowedValues?.map((av, index) => ({
                key: index,
                value: av.Value,
                label: av.Label
            }))
        }))
    }
}

export default class EnsxtxDocumentSearch extends LightningElement {

    @api recordId
    @api appSettingsName
    @api sapDocumentId
    @api sapDocumentFlowType
    @api isFlow

    loading = false
    appSettings = {}
    searchParams = {}
    searchInputs = {}
    pagingOptions = {}
    columns = []
    searchResults = []
    messages = []
    displayResults = false

    label = {
        ensxtx_Common_Loading,
        ensxapp__ComponentSearch_Refresh
    }

    get searchParamColumnCss() {
        const columnSize = (this.searchParams.Columns && this.searchParams.Columns > 0 && this.searchParams.Columns < 6) ? (6 / this.searchParams.Columns) : 3
        return 'slds-col slds-size_1-of-1 slds-medium-size_' + columnSize + '-of-6 slds-m-bottom_small'
    }

    get displaySearchResults() {
        return this.searchResults && this.searchResults.length > 0
    }

    connectedCallback() {
        this.loading = true
        if (this.appSettingsName) {
            getAppsettings({appsettingName: this.appSettingsName})
                .then(response => {
                    this.appSettings = JSON.parse(response)

                    if (this.appSettings.SearchResults) {
                        this.columns = this.appSettings.SearchResults.Columns
                            .filter(col => col.Display)
                            .map((col, index) => ({ Label: col.Label, key: index }))
                    }

                    if (this.recordId) {
                        return getCustomerNumber({recordId: this.recordId})
                    }
                })
                .then(response => {
                    let customerNumber = response?.data

                    // build search params and set default inputs
                    if (this.appSettings.SearchParams) {
                        this.searchParams = buildSearchParams(this.appSettings.SearchParams, customerNumber)
                        this.searchParams.Fields.forEach(field => {
                            if (field.value) this.searchInputs[field.Name] = field.value
                        })
                    }

                    if (this.appSettings.AutoSearch) {
                        this.handleSearch()
                    }
                })
                .catch(response => {
                    console.log(response)

                    this.messages = [
                        {
                            key: 1,
                            messageType: 'ERROR',
                            message: response?.body?.message || response
                        }
                    ]
                    this.displayResults = true
                })
                .finally((response) => {
                    if (!this.appSettings.AutoSearch) this.loading = false
                })
        }
        else {
            console.log('Error message: Please specify the app settings name')
            this.loading = false
        }
    }

    onInputBlur(event) {
        this.searchInputs[event.target.name] = event.target.value
    }

    onInputChange(event) {
        this.searchInputs[event.target.name] = event.target.value
    }

    onCheckboxChange(event) {
        const currentValue = this.searchInputs[event.target.name];
        this.searchInputs[event.target.name] = !currentValue ? true : false
    }

    onSearch(event) {
        this.pagingOptions = {}
        this.handleSearch()
    }

    onRefresh(event) {
        this.handleSearch()
    }

    handleSearch() {
        this.loading = true
        this.messages = []
        search({
            docType: this.appSettings.DocType,
            searchParams: this.searchInputs,
            docTypes: this.appSettings.DocTypes,
            pagingOptions: this.pagingOptions,
            sortFields: this.appSettings.SortFields
        })
            .then(({ data, messages, pagingOptions }) => {
                const decimalPlaces = 2
                this.util = util()
                this.searchResults = data
                    .map(dt => this.appSettings.SearchResults.Columns
                        .filter(col => col.Display)
                        .map(this.util.BaseOperation(dt))
                        .map(this.util.AddOperation(dt))
                        .map(this.util.JoinOperation(dt))
                        .map(this.util.MapperOperation(dt))
                        .map(this.util.InterpolationOperation(dt))
                        .map(this.util.ConditionOperation(dt, decimalPlaces))
                        .map(this.util.ToFixedOperation(dt))
                        .map(this.util.CurrencyOperation(dt[this.appSettings.SearchResults.CurrencyPath], decimalPlaces))
                        .map(this.util.PriceOverUnitOperation(dt, decimalPlaces))
                        .map(this.util.CoalesceOperation(dt))
                        .map(this.util.YesNoOperation(dt))
                        .map(this.util.MaxDateOperation(dt))
                    )
                    .map((ele, index) => ({key: index, data: ele}))

                this.pagingOptions = pagingOptions
                if (messages && messages.length) {
                    this.messages = messages.map((message, index) => ({...message, key: index}))
                }
            })
            .catch(({response}) => {
                console.log(response)
                if (response) {
                        this.messages = [
                        {
                            key: 1,
                            messageType: 'ERROR',
                            message: response.body.message
                        }
                    ]
                }
            })
            .finally((response) => {
                this.displayResults = true
                this.loading = false
            })
    }

    onDetailClick(event) {
        const documentId = event.target.getAttribute('data-document-id')
        if (documentId) {

            let docFlowType
            if (this.appSettings.DocType === 'SalesDoc') {
                docFlowType = 'SAP_Sales_Doc'
            }
            else docFlowType = 'SAP_' + this.appSettings.DocType

            if (this.isFlow) {
                this.dispatchEvent(new FlowAttributeChangeEvent('sapDocumentId', event.target.getAttribute('data-document-id')))
                this.dispatchEvent(new FlowAttributeChangeEvent('sapDocumentFlowType', docFlowType))
                this.dispatchEvent(new FlowNavigationNextEvent())
            }
            else {
                DocumentDetailModal.open({
                    size: 'large',
                    label: 'SAP Document Detail',
                    sapDocumentId: event.target.getAttribute('data-document-id'),
                    sapDocumentFlowType: docFlowType,
                    detailFlowName: this.appSettings.DetailFlowName
                })
                .then((result) => {
                    console.log(result);
                });
            }
        }
        else {
            this.messages = [
                {
                    key: 1,
                    messageType: 'ERROR',
                    message: 'Document Id is empty'
                }
            ]
        }
    }

    handlePagingOptionsChange(event) {
        this.pagingOptions = event.detail.pagingOptions
        this.handleSearch()
    }
}