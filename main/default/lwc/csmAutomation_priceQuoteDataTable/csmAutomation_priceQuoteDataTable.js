import { LightningElement, api, wire, track } from 'lwc';
import getQuoteDetails from '@salesforce/apex/CSMAutomation_PriceQuoteController.getQuoteDetails';
import getQuoteLinesData from '@salesforce/apex/CSMAutomation_PriceQuoteController.getQuoteLinesData';

export default class CsmAutomation_priceQuoteDataTable extends LightningElement {
    @api recordId;
    opportunityId;
    quoteWrapper;
    quoteLineTemp = false;
    optionalProduct = false;
    quoteLinesData = [];
    quoteLinesOptionalData = [];
    formattedQuoteCreationDate;
    formattedQuoteExpirationDate;
    quoteStatus;
    solutionSubtotal;
    totalCredit;
    shippingHandling;
    total;

    // Columns for Quote Line Program datatable
    quoteLineProgramColumns = [
        {
            label: 'Solution', fieldName: 'Name',
            cellAttributes: { alignment: 'left', style: { fieldName: 'boldRowStyle' } }
        },
        {
            label: 'Base Amount', fieldName: 'BaseAmount__c', type: 'currency',
            cellAttributes: { alignment: 'left', style: { fieldName: 'boldRowStyle' } }
        },
        {
            label: 'Free Amount', fieldName: 'FreeAmount__c', type: 'text',
            cellAttributes: { alignment: 'left', style: { fieldName: 'boldRowStyle' } }
        },
        {
            label: 'Total', fieldName: 'Total__c', type: 'text',
            cellAttributes: { alignment: 'left', style: { fieldName: 'boldRowStyle' } }
        }
    ];

    // Columns for Quote Line datatable
    quoteLineColumns = [
        { label: 'ISBN', fieldName: 'SBQQ__ProductCode__c' },
        { label: 'Description', fieldName: 'SBQQ__Description__c', initialWidth: 300, wrapText: true },
        {
            label: 'Price', fieldName: 'SBQQ__NetPrice__c', type: 'currency',
            cellAttributes: { alignment: 'left', style: { fieldName: 'boldRowStyle' } }, class: { fieldName: 'cellClass' }
        },
        {
            label: 'Free Qty', fieldName: 'FWO_Quantity__c',
            cellAttributes: { alignment: 'center', style: { fieldName: 'boldRowStyle' } }, class: { fieldName: 'cellClass' }
        },
        {
            label: 'Charged Qty', fieldName: 'SBQQ__Quantity__c', initialWidth: 100,
            cellAttributes: {
                style: { fieldName: 'cellClass', fieldName: 'boldRowStyle' },
                alignment: 'center'
            }
        },
        {
            label: 'Free Amount', fieldName: 'Free_Amt__c', type: 'currency',
            cellAttributes: { alignment: 'left', style: { fieldName: 'boldRowStyle' } }
        },
        {
            label: 'Total Charged', fieldName: 'SBQQ__NetTotal__c', type: 'text', //'currency',
            cellAttributes: { alignment: 'left', style: { fieldName: 'boldRowStyle' } }
        }
    ];

    quoteLineOptionalProducts = [
        { label: 'ISBN', fieldName: 'SBQQ__ProductCode__c' },
        { label: 'Description', fieldName: 'SBQQ__Description__c', initialWidth: 300, wrapText: true },
        { label: 'Price', fieldName: 'SBQQ__ListPrice__c', type: 'currency', cellAttributes: { alignment: 'left' } },
        { label: 'Total Quantity', fieldName: 'Total_Quantity__c', cellAttributes: { alignment: 'center' } },
        { label: 'Base Amount', fieldName: 'SBQQ__ListTotal__c', type: 'currency', cellAttributes: { alignment: 'left' } },
        { label: 'Total Charged', fieldName: 'SBQQ__NetTotal__c', type: 'currency', cellAttributes: { alignment: 'left' } }
    ];

    @wire(getQuoteDetails, { opportunityId: '$recordId' })
    wiredQuoteDetails({ error, data }) {
        if (data) {
            this.quoteWrapper = data;

            if (data.quoteLines != '') {
             this.quoteLinesOptionalData = data.quoteLines;
               /* this.quoteLinesOptionalData = data.quoteLines.map(item => {
                   const  SBQQ__Description__c = item.SBQQ__Description__c ? this.decodeHtmlEntities(item.SBQQ__Description__c) : '';
                    return { ...item, SBQQ__Description__c };
                });*/
                this.optionalProduct = true
            }

            this.formattedQuoteCreationDate = this.formatDate(data.quote.CreatedDate);
            this.formattedQuoteExpirationDate = this.formatDate(data.quote.CPQ_Quote_Expiry_Date__c);
            this.quoteStatus = data.quote.ApprovalStatus__c;

            if (this.quoteWrapper.quoteLinePrograms != '') {
                this.quoteLineTemp = true;
                this.quoteWrapper = {
                    ...data,
                    quoteLinePrograms: this.quoteWrapperWithFormattedValues
                };

                // Add four new rows for the totals at the end of the quoteLinePrograms array
                const updatedPrograms = [
                    ...this.quoteWrapper.quoteLinePrograms,
                    {
                        Name: 'Solution Subtotal:',
                        BaseAmount__c: data.quote.BaseListAmount__c,
                        FreeAmount__c: (data.quote.Free_Amount__c === undefined || data.quote.Free_Amount__c === '') ? '' : `$${Number(data.quote.Free_Amount__c).toLocaleString(undefined, { minimumFractionDigits: 2 })}`,
                        Total__c: (data.quote.Paid_Amount__c === undefined || data.quote.Paid_Amount__c === '') ? '' : `$${Number(data.quote.Paid_Amount__c).toLocaleString(undefined, { minimumFractionDigits: 2 })}`,
                        boldRowStyle: 'font-weight: bold'
                    },
                    {
                        Name: '',
                        BaseAmount__c: '',
                        FreeAmount__c: 'Total Credit:',
                        Total__c: (data.quote.Total_Credit__c === undefined || data.quote.Total_Credit__c === '') ? '' : `($${Number(data.quote.Total_Credit__c).toLocaleString(undefined, { minimumFractionDigits: 2 })})`,
                        boldRowStyle: 'font-weight: bold'
                    },
                    {
                        Name: '',
                        BaseAmount__c: '',
                        FreeAmount__c: 'Shipping & Handling:',
                        Total__c: (data.quote.Actual_SH__c === undefined || data.quote.Actual_SH__c === '') ? '' : `$${Number(data.quote.Actual_SH__c).toLocaleString(undefined, { minimumFractionDigits: 2 })}`,
                        boldRowStyle: 'font-weight: bold'
                    },
                    {
                        Name: '',
                        BaseAmount__c: '',
                        FreeAmount__c: 'Total:',
                        Total__c: (data.quote.Quote_NetTotal__c === undefined || data.quote.Quote_NetTotal__c === '') ? '' : `$${Number(data.quote.Quote_NetTotal__c).toLocaleString(undefined, { minimumFractionDigits: 2 })}`,
                        boldRowStyle: 'font-weight: bold'
                    }
                ];

                this.quoteWrapper = { ...this.quoteWrapper, quoteLinePrograms: updatedPrograms };
            }
        } else if (error) {
            console.error('Error fetching quote details:', error);
        }
    }

    @wire(getQuoteLinesData, { opportunityId: '$recordId' })
    wiredQuoteLines({ error, data }) {
        if (data) {

            const updatedData = data.map((wrapper, index, array) => {
                let total = wrapper.quote.Total_Credit__c;
                const records = Array.isArray(wrapper.records) ? wrapper.records : [];
                if (index === array.length - 1) {
                    const updateTotal = [
                        ...records,

                        {
                            SBQQ__Quantity__c: wrapper.quoteLineProductCategory + ' Subtotal:',
                            Free_Amt__c: wrapper.freeAmount,
                            SBQQ__NetTotal__c: (wrapper.totalChargedAmount === undefined || wrapper.totalChargedAmount === '') ? '' : `$${Number(wrapper.totalChargedAmount).toLocaleString(undefined, { minimumFractionDigits: 2 })}`,//wrapper.totalChargedAmount,
                            cellClass: 'text-align: left;',
                            boldRowStyle: 'font-weight: bold'
                        },
                        {
                            SBQQ__Quantity__c: '',
                            Free_Amt__c: '',
                            SBQQ__NetTotal__c: '',
                            cellClass: 'height: 20px;'
                        },
                        {
                            SBQQ__Quantity__c: 'Solution Subtotal:',
                            Free_Amt__c: wrapper.freeAmount,
                            SBQQ__NetTotal__c: (wrapper.quote.Paid_Amount__c === undefined || wrapper.quote.Paid_Amount__c === '') ? '' : `$${Number(wrapper.quote.Paid_Amount__c).toLocaleString(undefined, { minimumFractionDigits: 2 })}`,//wrapper.quote.Paid_Amount__c,
                            cellClass: 'text-align: left;',
                            boldRowStyle: 'font-weight: bold',
                            cellClass1: 'white-space: nowrap;overflow: hidden;text-overflow: ellipsis;max-width: 200px;',
                        },
                        {
                            SBQQ__Quantity__c: 'Total Credit:',
                            Free_Amt__c: '',
                            SBQQ__NetTotal__c: (total === undefined || total === '') ? '' : `($${Number(total).toLocaleString(undefined, { minimumFractionDigits: 2 })})`,
                            cellClass: 'text-align: left;',
                            boldRowStyle: 'font-weight: bold'
                        },
                        {
                            SBQQ__Quantity__c: 'Shipping & Handling:',
                            Free_Amt__c: '',
                            SBQQ__NetTotal__c: (wrapper.quote.Actual_SH__c === undefined || wrapper.quote.Actual_SH__c === '') ? '' : `$${Number(wrapper.quote.Actual_SH__c).toLocaleString(undefined, { minimumFractionDigits: 2 })}`,//wrapper.quote.Actual_SH__c,
                            cellClass: 'text-align: left;',
                            boldRowStyle: 'font-weight: bold'
                        },
                        {
                            SBQQ__Quantity__c: 'Total',
                            Free_Amt__c: '',
                            SBQQ__NetTotal__c: (wrapper.quote.Quote_NetTotal__c === undefined || wrapper.quote.Quote_NetTotal__c === '') ? '' : `$${Number(wrapper.quote.Quote_NetTotal__c).toLocaleString(undefined, { minimumFractionDigits: 2 })}`,//wrapper.quote.Quote_NetTotal__c,
                            cellClass: 'text-align: left;',
                            boldRowStyle: 'font-weight: bold'
                        }
                    ];
                    return {
                        ...wrapper,
                        records: updateTotal
                    };
                }

                const updatedRecords = [
                    ...records,
                    {
                        SBQQ__Quantity__c: wrapper.quoteLineProductCategory + ' Subtotal:',//wrapper.quoteLineProductCategory + ' Subtotal:',
                        Free_Amt__c: wrapper.freeAmount,
                        SBQQ__NetTotal__c: `$${Number(wrapper.totalChargedAmount).toLocaleString(undefined, { minimumFractionDigits: 2 })}`,//wrapper.totalChargedAmount,
                        cellClass: 'text-align: left;',
                        boldRowStyle: 'font-weight: bold',
                    },
                    {
                        SBQQ__Quantity__c: '',
                        Free_Amt__c: '',
                        SBQQ__NetTotal__c: '',
                        cellClass: 'height: 20px;'
                    }

                ];
                return {
                    ...wrapper,
                    records: updatedRecords
                };
            });
            this.quoteLinesData = updatedData;

            setTimeout(() => {

            }, 0);

        } else if (error) {
            console.error('Error retrieving quote lines data', error);
        }
    }

    formatDate(dateTime) {
        if (dateTime) {
            const date = new Date(dateTime);
            const month = String(date.getMonth() + 1).padStart(2, '0'); // Months are zero-based
            const day = String(date.getDate()).padStart(2, '0');
            const year = date.getFullYear();
            return `${month}-${day}-${year}`;
        }
        return '';
    }

    get quoteWrapperWithFormattedValues() {
        if (this.quoteWrapper) {
            // Iterate through quoteLinePrograms and add formatted FreeAmount__c
            return this.quoteWrapper.quoteLinePrograms.map(program => {
                let freeAmount = program.FreeAmount__c;
                let total = program.Total__c;

                // Check if FreeAmount__c is a number and format as currency
                if (!isNaN(freeAmount) && freeAmount !== null && freeAmount !== '') {
                    freeAmount = `$${Number(freeAmount).toLocaleString(undefined, { minimumFractionDigits: 2 })}`;// Format as currency
                }
                // Check if Total__c is a number and format as currency
                if (!isNaN(total) && total !== null && total !== '') {
                    total = `$${Number(total).toLocaleString(undefined, { minimumFractionDigits: 2 })}`;
                }

                return {
                    ...program,
                    FreeAmount__c: freeAmount,
                    Total__c: total,
                };
            });
        }
        return [];
    }
    decodeHtmlEntities(str) {
        const txt = document.createElement('textarea');
        txt.innerHTML = str;
        const decodedStr = txt.value;
       // const parser = new DOMParser();
       // const doc = parser.parseFromString(decodedStr, 'text/html');
       // return doc.body.textContent || "";
        return decodedStr.replace(/<\/?[^>]+(>|$)/g, "");
    }
}