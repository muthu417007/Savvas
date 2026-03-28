import { LightningElement, api } from 'lwc';
import modal from "@salesforce/resourceUrl/ensxtx_SalesDocDetail";
import { loadStyle } from "lightning/platformResourceLoader";
import getDetail from '@salesforce/apex/ensxtx_CTRL_SalesDocDetail.getDetail'
import getInvoice from '@salesforce/apex/ensxtx_CTRL_SalesDocDetail.getInvoice'
import getDelivery from '@salesforce/apex/ensxtx_CTRL_SalesDocDetail.getDelivery'
import getAppsettings from '@salesforce/apex/ensxtx_UTIL_GetAppSettings.getAppsettings'
import { FlowAttributeChangeEvent, FlowNavigationNextEvent } from 'lightning/flowSupport'

const getValue = (obj, peerData, props, i = 0) => {
    if (obj === undefined || props === undefined) return undefined
    if (peerData && props.length >= 2 && props[1] !== 'asList' && peerData[props[0]]) {
        if (obj.SalesItem) {
            if (props[0] === 'ITEM_USER_DEFINED') {
                let customItemData = peerData[props[0]];
                let customItem = customItemData.find(custom => custom.SalesItem === obj.SalesItem && custom.FIELD === props[1]);
                return customItem ? customItem.VALUE : undefined;
            }
            else if (props[0] === 'CONDITIONS') {
                let conditionData = peerData[props[0]];
                let condition = conditionData.find(condition => condition.ConditionItemNumber === obj.SalesItem && condition.ConditionType === props[1]);
                return condition ? condition[props[2]] : undefined;
            }
        } else {
            let customData = peerData[props[0]];
            let custom = customData.find(custom => custom.FIELD === props[1]);
            return custom ? custom.VALUE : undefined;
        }
    }
    if (i === props.length - 1) return obj[props[i]]

    return getValue(obj[props[i]], peerData, props, i + 1)
}

const getValueForPath = (obj, peerData, path) => getValue(obj, peerData, path?.split('.'))

const BaseOperation = (data, peerData) => (f, i) => ({
    ...f,
    Value: getValueForPath(data, peerData, f.Path),
    isString: f.Type === 'string',
    isDate: f.Type === 'date',
    isCurrency: f.Type === 'currency',
    isItemDetailLink: f.Type === 'itemDetailLink',
    key: i
})

const AddOperation = (data, peerData) => f => (
    f.Add !== undefined ? {
        ...f,
        Value: f.Add.reduce((acc, path) => (getValueForPath(data, peerData, path) || 0) + acc, 0)
    } : f
)

const JoinOperation = (data, peerData) => f => (
    f.Join && f.Join.Fields ? {
        ...f,
        Value: f.Join.Fields.map(path => getValueForPath(data, peerData, path)).join(f.Join.Separator)
    } : f
)

const CoalesceOperation = (data, peerData) => f => (
    f.Coalesce !== undefined ? {
        ...f,
        Value: f.Coalesce.reduce((acc, path) => acc ?? getValueForPath(data, peerData, path), undefined)
    } : f
)

const MapperOperation = (data, peerData) => f => (
    f.Mapper ? {
        ...f,
        Value: getValueForPath(
            data, peerData, f.Mapper.MappingValueAndFields.find(
                d => d.Value === getValueForPath(data, peerData, f.Mapper.FieldName)).FieldToMap)
    } : f
)

const ToFixedOperation = (data, peerData) => f => (
    f.ToFixed !== undefined ? {
        ...f,
        Value: parseFloat(getValueForPath(data, peerData, f.Path))?.toFixed(2)
    } : f
)

const YesNoOperation = (data, peerData) => f => (
    f.Type === 'yesno' ? {
        ...f,
        Value: getValueForPath(data, peerData, f.Path) ? 'Yes' : 'No', Type: 'string', isString: true
    } : f
)

const CurrencyOperation = (currency, decimalPlaces) => f => {
    if (!f.isCurrency || f.Value === undefined) return f
    const toFormat = (value, fixed) => parseInt((100 * value).toFixed(0)) / Math.pow(10, fixed);
    let amount = toFormat(f.Value , decimalPlaces);

    amount = amount.toFixed(decimalPlaces);

    return { ...f, Value: `${amount} ${currency}`, isString: true, isCurrency: false }
}

const PriceOverUnitOperation = (data, peerData, decimalPlaces) => f => {
    if (f.PriceOverUnit === undefined) return f

    const amount = getValueForPath(data, peerData, f.PriceOverUnit['Amount'])
    const currency = getValueForPath(data, peerData, f.PriceOverUnit['Currency'])
    const quantity = getValueForPath(data, peerData, f.PriceOverUnit['Quantity'])
    const unit = getValueForPath(data, peerData, f.PriceOverUnit['Unit'])

    const toFormat = (n, fixed) => ~~(100 * n) / Math.pow(10, fixed);
    let formattedAmount = toFormat(amount , decimalPlaces);
    formattedAmount = formattedAmount.toFixed(decimalPlaces);

    if (!quantity) return { ...f, Value: `${formattedAmount} ${currency}`, isString: true }
    else return { ...f, Value: `${formattedAmount} ${currency} / ${quantity} ${unit}`, isString: true }
}

const MaxDateOperation = (data, peerData) => f => {
    if (f.MaxDate === undefined) return f

    const d = getValueForPath(data, peerData, f.MaxDate.Root).map(d => getValueForPath(d, peerData, f.MaxDate.DatePath)).filter(d => !!d)

    return { ...f, Value: d[d.length - 1], isDate: true, Type: 'date' }
}

const ConditionOperation = (data, peerData, decimalPlaces) => f => {
    if (f.Type !== 'conditionRate') return f

    const toFormat = (n, fixed) => ~~(100 * n) / Math.pow(10, fixed);
    let formattedAmount = toFormat(data.Rate, decimalPlaces);
    data.Rate = formattedAmount.toFixed(decimalPlaces);
    const p1 = `${data.Rate.toFixed(2)} ${data.CurrencyKey || data.RateUnit}`

    return { ...f, Value: data.ConditionPricingUnit ? `${p1} / ${data.ConditionPricingUnit} ${data.ConditionUnit || ''}` : p1, Type: 'string', isString: true }
}

const InterpolationOperation = (data, peerData) => f => {
    if (f.Interpolation === undefined) return f

    const matches = f.Interpolation.match(/\$\{\w+\}/g)
    let result = f.Interpolation

    for (let match of matches) {
        const key = /\w+/.exec(match)[0]
        const value = getValueForPath(data, peerData, key)
        result = result.replace(match, typeof value === 'number' ? value.toFixed(2) : value)
    }

    return { ...f, Value: result }
}

export default class EnsxtxSalesDocDetail extends LightningElement {
    @api documentNumber
    @api section
    @api documentType
    @api selectedSAPDocumentItemModel
    @api sapDocumentItemId
    @api selectedDocFlowLevel
    @api appsettingName
    appSettings = {};
    

    loading = true
    error = undefined
    data = undefined
    ogData = undefined
    settings = undefined
    type = undefined
    title = undefined
    detailLinkText = undefined
    details = undefined
    currency = undefined
    icon = undefined
    breakpoint = 7
    rows = []
    columns = []
    decimalPlacesfromSAP = undefined

    get displayDetail() {
        return this.type === 'Detail'
    }

    get displayList() {
        return this.type === 'List'
    }

    get detailsColumnOne() {
        return this.details
            ? this.details.length > this.breakpoint
                ? this.details.filter((_, i) => i < this.details.length / 2)
                : this.details
            : []
    }

    get detailsColumnTwo() {
        return this.details
            ? this.details.length > this.breakpoint
                ? this.details.filter((_, i) => i >= this.details.length / 2)
                : []
            : []
    }

    async getsettings (paramAppSetting) {
        return await new Promise((resolve, reject) => {
            return resolve (getAppsettings({appsettingName:paramAppSetting}));
        })
    }

    connectedCallback() {
        loadStyle(this, modal);
        this.getsettings(this.appsettingName)
        .then(result => {
            this.appSettings =  JSON.parse(result);
            this.settings = this.appSettings[this.section];
            this.type = this.settings.Type;
            this.title = this.settings.Title
            this.detailLinkText = this.appSettings.ItemDetailLinkText
            this.icon = this.settings.Icon

            let fetcher = undefined

            switch (this.appSettings.DocumentType) {
                case 'Sales':
                    fetcher = getDetail
                    break
                case 'Invoice':
                    fetcher = getInvoice
                    break
                case 'Delivery':
                    fetcher = getDelivery
                    break
                default:
                    fetcher = getDetail
            }

            fetcher({ documentNumber: this.documentNumber })
                .then(({ data }) => {
                    console.log('ensxtxSalesDocDetail pre', data)
                    this.ogData = data
                    this.decimalPlacesfromSAP = data.DecimalPlaces ? data.DecimalPlaces : 2
                    if (this.settings.FindBy && this.type === 'Detail') {
                        this.data = getValueForPath(data, undefined, this.settings.Root).find(d => d[this.settings.FindBy] === this.sapDocumentItemId)
                    }
                    else if (this.settings.FilterBy && this.type === 'List') {
                        this.data = getValueForPath(data, undefined, this.settings.Root).filter(d => d[this.settings.FilterBy] === this.sapDocumentItemId)
                    }
                    else if (this.settings.Root && !(this.settings.FindBy || this.settings.FilterBy)) {
                        this.data = getValueForPath(data, undefined, this.settings.Root)
                    }
                    else {
                        this.data = data
                    }
                    let peerData = {
                        USER_DEFINED: getValueForPath(data, undefined, 'USER_DEFINED.asList'),
                        ITEM_USER_DEFINED: getValueForPath(data, undefined, 'ITEM_USER_DEFINED.asList'),
                        CONDITIONS: getValueForPath(data, undefined, 'CONDITIONS.asList')
                    }

                    if (this.settings.Whitelist && this.type === 'List') {
                        this.data = getValueForPath(data, undefined, this.settings.Root).filter(d => this.settings.Whitelist.Values.includes(d[this.settings.Whitelist.Key]))
                    }

                    if (this.settings.Blacklist && this.type === 'List') {
                        this.data = getValueForPath(data, undefined, this.settings.Root).filter(d => !this.settings.Blacklist.Values.includes(d[this.settings.Blacklist.Key]))
                    }

                    console.log('ensxtxSalesDocDetail post', this.data)
                    this.currency = getValueForPath(data, undefined, this.appSettings.CurrencyPath)

                    if (this.type === 'Detail') {
                        this.breakpoint = this.settings.Breakpoint || this.breakpoint
                        this.details = this.settings.Fields
                            .filter(d => d.Display)
                            .map(BaseOperation(this.data, peerData))
                            .map(AddOperation(this.data, peerData))
                            .map(JoinOperation(this.data, peerData))
                            .map(MapperOperation(this.data, peerData))
                            .map(InterpolationOperation(this.data, peerData))
                            .map(ConditionOperation(this.data, peerData, this.decimalPlacesfromSAP))
                            .map(ToFixedOperation(this.data, peerData))
                            .map(CurrencyOperation(this.currency, this.decimalPlacesfromSAP))
                            .map(PriceOverUnitOperation(this.data, peerData, this.decimalPlacesfromSAP))
                            .map(CoalesceOperation(this.data, peerData))
                            .map(YesNoOperation(this.data, peerData))
                            .map(MaxDateOperation(this.data, peerData))
                    }

                    if (this.type === 'List') {
                        this.columns = this.settings.Fields.filter(c => c.Display).map((c, i) => ({ Name: c.Name, key: i }))

                        this.rows = this.data
                            .map(r => this.settings.Fields
                                .filter(r => r.Display)
                                .map(BaseOperation(r, peerData))
                                .map(AddOperation(r, peerData))
                                .map(JoinOperation(r, peerData))
                                .map(MapperOperation(r, peerData))
                                .map(InterpolationOperation(r, peerData))
                                .map(ConditionOperation(r, peerData, this.decimalPlacesfromSAP))
                                .map(ToFixedOperation(r, peerData))
                                .map(CurrencyOperation(this.currency, this.decimalPlacesfromSAP))
                                .map(PriceOverUnitOperation(r, peerData, this.decimalPlacesfromSAP))
                                .map(CoalesceOperation(r, peerData))
                                .map(YesNoOperation(r, peerData))
                                .map(MaxDateOperation(r, peerData))
                            )
                            .map((r, i) => ({ key: i, data: r }))
                    }
                })
                .catch(err => {
                    this.error = err
                })
                .finally(() => this.loading = false)
        })
    }

    handleClick(event) {
        const itemNumber = event.currentTarget.dataset.itemId

        let selected = undefined

        switch (this.appSettings.DocumentType) {
            case 'Sales':
                selected = {
                    sapDocumentId: this.documentNumber,
                    recordId: undefined,
                    itemNum: itemNumber,
                    itemDetail: this.ogData.ITEMS.asList.filter(i => i.ItemNumber === itemNumber),
                    scheduleLines: this.ogData.ITEMS_SCHEDULE.asList.filter(s => s.ItemNumber === itemNumber),
                    conditions: this.ogData.CONDITIONS.asList.filter(c => c.ConditionItemNumber === itemNumber),
                }
                this.selectedSAPDocumentItemModel = JSON.stringify(selected)
                this.sapDocumentItemId = itemNumber
                this.dispatchEvent(new FlowAttributeChangeEvent('selectedSAPDocumentItemModel', JSON.stringify(selected)))
                this.dispatchEvent(new FlowAttributeChangeEvent('sapDocumentItemId', itemNumber))
                this.dispatchEvent(new FlowAttributeChangeEvent('selectedDocFlowLevel', 'detail'))
                this.dispatchEvent(new FlowNavigationNextEvent())
                break;
            case 'Invoice':
                selected = {
                    sapDocumentId: this.documentNumber,
                    itemDetail: this.ogData.ITEMS.asList.find(i => i.ItemNumber === itemNumber),
                    itemConditions: this.ogData.CONDITIONS.asList.filter(c => c.ConditionItemNumber === itemNumber),
                    itemNum: itemNumber,
                }
                this.selectedSAPDocumentItemModel = JSON.stringify(selected)
                this.sapDocumentItemId = itemNumber
                this.dispatchEvent(new FlowAttributeChangeEvent('selectedSAPDocumentItemModel', JSON.stringify(selected)))
                this.dispatchEvent(new FlowAttributeChangeEvent('sapDocumentItemId', itemNumber))
                this.dispatchEvent(new FlowAttributeChangeEvent('selectedDocFlowLevel', 'detail'))
                this.dispatchEvent(new FlowNavigationNextEvent())
                break;
            case 'Delivery':
                selected = {
                    sapDocumentId: this.documentNumber,
                    itemDetail: this.ogData.ITEMS.asList.find(i => i.DeliveryItem === itemNumber),
                    itemNum: itemNumber,
                }
                this.selectedSAPDocumentItemModel = JSON.stringify(selected)
                this.sapDocumentItemId = itemNumber
                this.dispatchEvent(new FlowAttributeChangeEvent('selectedSAPDocumentItemModel', JSON.stringify(selected)))
                this.dispatchEvent(new FlowAttributeChangeEvent('sapDocumentItemId', itemNumber))
                this.dispatchEvent(new FlowAttributeChangeEvent('selectedDocFlowLevel', 'detail'))
                this.dispatchEvent(new FlowNavigationNextEvent())
                break;
        }
    }
}