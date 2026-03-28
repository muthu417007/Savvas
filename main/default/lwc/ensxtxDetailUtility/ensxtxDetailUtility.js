export default () => {
    const getValue = (obj, props, i = 0) => {
        if (obj === undefined || props === undefined) return undefined
        if (i === props.length - 1) return obj[props[i]]

        return getValue(obj[props[i]], props, i + 1)
    }

    const getValueForPath = (obj, path) => getValue(obj, path?.split('.'))

    const BaseOperation = data => (f, i) => ({
        ...f,
        Value: getValueForPath(data, f.Path),
        isString: f.Type === 'string',
        isDate: f.Type === 'date',
        isCurrency: f.Type === 'currency',
        isDetailLink: f.Type === 'detailLink',
        key: i
    })

    const AddOperation = data => f => (
        f.Add !== undefined ? {
            ...f,
            Value: f.Add.reduce((acc, path) => (getValueForPath(data, path) || 0) + acc, 0)
        } : f
    )

    const JoinOperation = data => f => (
        f.Join && f.Join.Fields ? {
            ...f,
            Value: f.Join.Fields.map(path => getValueForPath(data, path)).join(f.Join.Separator)
        } : f
    )

    const CoalesceOperation = data => f => (
        f.Coalesce !== undefined ? {
            ...f,
            Value: f.Coalesce.reduce((acc, path) => acc ?? getValueForPath(data, path), undefined)
        } : f
    )

    const MapperOperation = data => f => (
        f.Mapper ? {
            ...f,
            Value: getValueForPath(
                data, f.Mapper.MappingValueAndFields.find(
                    d => d.Value === getValueForPath(data, f.Mapper.FieldName)).FieldToMap)
        } : f
    )

    const ToFixedOperation = data => f => (
        f.ToFixed !== undefined ? {
            ...f,
            Value: parseFloat(getValueForPath(data, f.Path))?.toFixed(2)
        } : f
    )

    const YesNoOperation = data => f => (
        f.Type === 'yesno' ? {
            ...f,
            Value: getValueForPath(data, f.Path) ? 'Yes' : 'No', Type: 'string', isString: true
        } : f
    )

    const CurrencyOperation = (currency, decimalPlaces) => f => {
        if (!f.isCurrency || f.Value === undefined) return f
        const toFormat = (value, fixed) => parseInt((100 * value).toFixed(0)) / Math.pow(10, fixed);
        let amount = toFormat(f.Value , decimalPlaces);

        amount = amount.toFixed(decimalPlaces);

        return { ...f, Value: `${amount.toLocaleString()} ${currency}`, isString: true }
    }

    const PriceOverUnitOperation = (data, decimalPlaces) => f => {
        if (f.PriceOverUnit === undefined) return f

        const amount = getValueForPath(data, f.PriceOverUnit['Amount'])
        const currency = getValueForPath(data, f.PriceOverUnit['Currency'])
        const quantity = getValueForPath(data, f.PriceOverUnit['Quantity'])
        const unit = getValueForPath(data, f.PriceOverUnit['Unit'])

        const toFormat = (n, fixed) => ~~(100 * n) / Math.pow(10, fixed);
        let formattedAmount = toFormat(amount , decimalPlaces);
        formattedAmount = formattedAmount.toFixed(decimalPlaces);

        if (!quantity) return { ...f, Value: `${formattedAmount} ${currency}`, isString: true }
        else return { ...f, Value: `${formattedAmount} ${currency} / ${quantity} ${unit}`, isString: true }
    }

    const MaxDateOperation = data => f => {
        if (f.MaxDate === undefined) return f

        const d = getValueForPath(data, f.MaxDate.Root).map(d => getValueForPath(d, f.MaxDate.DatePath)).filter(d => !!d)

        return { ...f, Value: d[d.length - 1], isDate: true, Type: 'date' }
    }

    const ConditionOperation = (data, decimalPlaces) => f => {
        if (f.Type !== 'conditionRate') return f

        const toFormat = (n, fixed) => ~~(100 * n) / Math.pow(10, fixed);
        let formattedAmount = toFormat(data.Rate, decimalPlaces);
        data.Rate = formattedAmount.toFixed(decimalPlaces);
        const p1 = `${data.Rate.toFixed(2)} ${data.CurrencyKey || data.RateUnit}`

        return { ...f, Value: data.ConditionPricingUnit ? `${p1} / ${data.ConditionPricingUnit} ${data.ConditionUnit || ''}` : p1, Type: 'string', isString: true }
    }

    const InterpolationOperation = data => f => {
        if (f.Interpolation === undefined) return f

        const matches = f.Interpolation.match(/\$\{\w+\}/g)
        let result = f.Interpolation

        for (let match of matches) {
            const key = /\w+/.exec(match)[0]
            const value = getValueForPath(data, key)
            result = result.replace(match, typeof value === 'number' ? value.toFixed(2) : value)
        }

        return { ...f, Value: result }
    }

    return {
        getValue,
        getValueForPath,
        BaseOperation,
        AddOperation,
        JoinOperation,
        CoalesceOperation,
        MapperOperation,
        ToFixedOperation,
        YesNoOperation,
        CurrencyOperation,
        PriceOverUnitOperation,
        MaxDateOperation,
        ConditionOperation,
        InterpolationOperation
    }
}